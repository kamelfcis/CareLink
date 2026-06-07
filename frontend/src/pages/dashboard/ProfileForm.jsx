import React, { useState, useEffect, useRef } from 'react';
import { useAuth } from '../../context/AuthContext';
import { supabase } from '../../lib/supabase';
import { useTranslation } from 'react-i18next';
import { Button } from '../../components/ui/button';
import { Input } from '../../components/ui/input';
import { Label } from '../../components/ui/label';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '../../components/ui/card';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '../../components/ui/select';
import { Textarea } from '../../components/ui/textarea';
import { Save, CheckCircle, Upload, User, X } from 'lucide-react';

const ProfileForm = () => {
  const { patient, user, refreshPatient } = useAuth();
  const { t } = useTranslation();
  const [loading, setLoading] = useState(false);
  const [saved, setSaved] = useState(false);
  const [uploadingImage, setUploadingImage] = useState(false);
  const [imagePreview, setImagePreview] = useState(null);
  const [imageFile, setImageFile] = useState(null);
  const fileInputRef = useRef(null);
  const [formData, setFormData] = useState({
    full_name: '',
    phone: '',
    email: '',
    dob: '',
    gender: '',
    blood_type: '',
    height_cm: '',
    weight_kg: '',
    emergency_contact_name: '',
    emergency_contact_phone: '',
    emergency_contact_relation: '',
    photo_url: '',
  });

  useEffect(() => {
    if (patient) {
      setFormData({
        full_name: patient.full_name || '',
        phone: patient.phone || '',
        email: patient.email || user?.email || '',
        dob: patient.dob || '',
        gender: patient.gender || '',
        blood_type: patient.blood_type || '',
        height_cm: patient.height_cm || '',
        weight_kg: patient.weight_kg || '',
        emergency_contact_name: patient.emergency_contact?.name || '',
        emergency_contact_phone: patient.emergency_contact?.phone || '',
        emergency_contact_relation: patient.emergency_contact?.relation || '',
        photo_url: patient.photo_url || '',
      });
      
      // Set image preview if photo_url exists
      if (patient.photo_url) {
        // Get public URL from Supabase Storage
        try {
          const { data } = supabase.storage.from('patient-photos').getPublicUrl(patient.photo_url);
          if (data?.publicUrl) {
            setImagePreview(data.publicUrl);
          } else {
            setImagePreview(null);
          }
        } catch (error) {
          console.error('Error loading image preview:', error);
          setImagePreview(null);
        }
      } else {
        setImagePreview(null);
      }
    }
  }, [patient, user]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
  };

  const handleSelectChange = (name, value) => {
    setFormData((prev) => ({ ...prev, [name]: value }));
  };

  const handleImageChange = async (e) => {
    const file = e.target.files?.[0];
    if (!file) return;

    // Validate file type
    if (!file.type.startsWith('image/')) {
      alert(t('profile.invalidImageType') || 'Please select a valid image file');
      return;
    }

    // Validate file size (max 5MB)
    if (file.size > 5 * 1024 * 1024) {
      alert(t('profile.imageTooLarge') || 'Image size should be less than 5MB');
      return;
    }

    setImageFile(file);
    
    // Create preview
    const reader = new FileReader();
    reader.onloadend = () => {
      setImagePreview(reader.result);
    };
    reader.readAsDataURL(file);
  };

  const handleRemoveImage = () => {
    setImageFile(null);
    setImagePreview(null);
    setFormData((prev) => ({ ...prev, photo_url: '' }));
    if (fileInputRef.current) {
      fileInputRef.current.value = '';
    }
  };

  const uploadImage = async (patientId) => {
    if (!imageFile || !patientId) return null;

    setUploadingImage(true);
    try {
      const fileExt = imageFile.name.split('.').pop();
      const fileName = `${patientId}/${Date.now()}.${fileExt}`;
      
      // Upload to Supabase Storage
      const { data: uploadData, error: uploadError } = await supabase.storage
        .from('patient-photos')
        .upload(fileName, imageFile, {
          cacheControl: '3600',
          upsert: false
        });

      if (uploadError) {
        // If file exists, try to update it (use upsert)
        if (uploadError.message.includes('already exists') || uploadError.message.includes('Duplicate')) {
          const { data: updateData, error: updateError } = await supabase.storage
            .from('patient-photos')
            .update(fileName, imageFile, {
              cacheControl: '3600',
              upsert: true
            });
          
          if (updateError) throw updateError;
          return fileName;
        }
        throw uploadError;
      }

      // Delete old image if exists and different from new one
      if (formData.photo_url && formData.photo_url !== fileName) {
        try {
          // Extract just the filename part after the patient ID
          const oldPathParts = formData.photo_url.split('/');
          if (oldPathParts.length >= 2) {
            const oldFileName = oldPathParts.slice(-2).join('/');
            await supabase.storage
              .from('patient-photos')
              .remove([oldFileName]);
          }
        } catch (deleteError) {
          // Ignore delete errors (file might not exist)
          console.warn('Could not delete old image:', deleteError);
        }
      }

      return fileName;
    } catch (error) {
      console.error('Error uploading image:', error);
      alert(t('profile.imageUploadError') || 'Failed to upload image. Please try again.');
      return null;
    } finally {
      setUploadingImage(false);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setSaved(false);

    try {
      let patientId = patient?.id;
      let photoUrl = formData.photo_url;

      // If creating new patient, we need to create it first, then upload image
      if (!patientId) {
        const emergencyContact = {
          name: formData.emergency_contact_name,
          phone: formData.emergency_contact_phone,
          relation: formData.emergency_contact_relation,
        };

        const userRow = {
          id: user.id,
          name: formData.full_name,
          email: formData.email,
          phone: formData.phone || null,
        };
        const { error: userUpsertError } = await supabase
          .from('users')
          .upsert(userRow, { onConflict: 'id' });
        if (userUpsertError) throw userUpsertError;

        const initialData = {
          patient_id: user.id,
          gender: formData.gender || null,
          blood_type: formData.blood_type || null,
          height_cm: formData.height_cm ? parseFloat(formData.height_cm) : null,
          weight_kg: formData.weight_kg ? parseFloat(formData.weight_kg) : null,
          emergency_contact: emergencyContact,
          date_of_birth: formData.dob || null,
        };

        const { data, error } = await supabase
          .from('patients')
          .insert(initialData)
          .select('id')
          .single();

        if (error) throw error;
        patientId = data.id;
      }

      // Upload image if a new one was selected (now we have patientId)
      if (imageFile && patientId) {
        const uploadedFileName = await uploadImage(patientId);
        if (uploadedFileName) {
          photoUrl = uploadedFileName;
        }
      }

      const emergencyContact = {
        name: formData.emergency_contact_name,
        phone: formData.emergency_contact_phone,
        relation: formData.emergency_contact_relation,
      };

      const patientUpdate = {
        gender: formData.gender || null,
        blood_type: formData.blood_type || null,
        height_cm: formData.height_cm ? parseFloat(formData.height_cm) : null,
        weight_kg: formData.weight_kg ? parseFloat(formData.weight_kg) : null,
        emergency_contact: emergencyContact,
        date_of_birth: formData.dob || null,
      };

      const { error: updateError } = await supabase
        .from('patients')
        .update(patientUpdate)
        .eq('id', patientId);

      if (updateError) throw updateError;

      const { error: userUpdateError } = await supabase
        .from('users')
        .update({
          name: formData.full_name,
          email: formData.email,
          phone: formData.phone || null,
          image: photoUrl || null,
        })
        .eq('id', user.id);

      if (userUpdateError) throw userUpdateError;

      await refreshPatient();
      setImageFile(null); // Clear the file after successful save
      setSaved(true);
      setTimeout(() => setSaved(false), 3000);
    } catch (error) {
      console.error('Error saving profile:', error);
      alert(t('errors.failedToSave'));
    } finally {
      setLoading(false);
    }
  };

  return (
    <Card>
      <CardHeader>
        <CardTitle>{t('dashboard.patientProfile')}</CardTitle>
        <CardDescription>{t('dashboard.updateInfo')}</CardDescription>
      </CardHeader>
      <CardContent>
        <form onSubmit={handleSubmit} className="space-y-6">
          {/* Profile Image Upload */}
          <div className="flex flex-col items-center gap-4 pb-6 border-b">
            <div className="relative">
              {imagePreview ? (
                <div className="relative group">
                  <img
                    src={imagePreview}
                    alt="Profile"
                    className="w-32 h-32 rounded-full object-cover border-4 border-primary/20 shadow-lg"
                  />
                  <button
                    type="button"
                    onClick={handleRemoveImage}
                    className="absolute top-0 right-0 p-2 bg-red-500 text-white rounded-full opacity-0 group-hover:opacity-100 transition-opacity shadow-lg"
                    title={t('profile.removeImage') || 'Remove image'}
                  >
                    <X className="h-4 w-4" />
                  </button>
                </div>
              ) : (
                <div className="w-32 h-32 rounded-full bg-primary/10 border-4 border-primary/20 flex items-center justify-center">
                  <User className="h-16 w-16 text-primary/40" />
                </div>
              )}
            </div>
            <div className="flex flex-col items-center gap-2">
              <input
                ref={fileInputRef}
                type="file"
                accept="image/*"
                onChange={handleImageChange}
                className="hidden"
                id="profile-image-upload"
              />
              <label htmlFor="profile-image-upload">
                <Button
                  type="button"
                  variant="outline"
                  className="cursor-pointer"
                  disabled={uploadingImage || loading}
                  asChild
                >
                  <span>
                    <Upload className="h-4 w-4 mr-2" />
                    {uploadingImage ? (t('profile.uploadingImage') || 'Uploading...') : (t('profile.uploadImage') || 'Upload Photo')}
                  </span>
                </Button>
              </label>
              <p className="text-xs text-gray-500 text-center">
                {t('profile.imageHint') || 'JPG, PNG or GIF. Max size 5MB'}
              </p>
            </div>
          </div>

          <div className="grid md:grid-cols-2 gap-6">
            <div className="space-y-2">
              <Label htmlFor="full_name">Full Name *</Label>
              <Input
                id="full_name"
                name="full_name"
                value={formData.full_name}
                onChange={handleChange}
                required
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="phone">Phone</Label>
              <Input
                id="phone"
                name="phone"
                type="tel"
                value={formData.phone}
                onChange={handleChange}
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="email">Email *</Label>
              <Input
                id="email"
                name="email"
                type="email"
                value={formData.email}
                onChange={handleChange}
                required
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="dob">Date of Birth</Label>
              <Input
                id="dob"
                name="dob"
                type="date"
                value={formData.dob}
                onChange={handleChange}
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="gender">Gender</Label>
              <Select
                value={formData.gender}
                onValueChange={(value) => handleSelectChange('gender', value)}
              >
                <SelectTrigger>
                  <SelectValue placeholder="Select gender" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="male">Male</SelectItem>
                  <SelectItem value="female">Female</SelectItem>
                  <SelectItem value="other">Other</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-2">
              <Label htmlFor="blood_type">Blood Type</Label>
              <Select
                value={formData.blood_type}
                onValueChange={(value) => handleSelectChange('blood_type', value)}
              >
                <SelectTrigger>
                  <SelectValue placeholder="Select blood type" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="A+">A+</SelectItem>
                  <SelectItem value="A-">A-</SelectItem>
                  <SelectItem value="B+">B+</SelectItem>
                  <SelectItem value="B-">B-</SelectItem>
                  <SelectItem value="AB+">AB+</SelectItem>
                  <SelectItem value="AB-">AB-</SelectItem>
                  <SelectItem value="O+">O+</SelectItem>
                  <SelectItem value="O-">O-</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-2">
              <Label htmlFor="height_cm">Height (cm)</Label>
              <Input
                id="height_cm"
                name="height_cm"
                type="number"
                value={formData.height_cm}
                onChange={handleChange}
                min="0"
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="weight_kg">Weight (kg)</Label>
              <Input
                id="weight_kg"
                name="weight_kg"
                type="number"
                value={formData.weight_kg}
                onChange={handleChange}
                min="0"
              />
            </div>
          </div>

          <div className="border-t pt-6">
            <h3 className="text-lg font-semibold mb-4">Emergency Contact</h3>
            <div className="grid md:grid-cols-3 gap-4">
              <div className="space-y-2">
                <Label htmlFor="emergency_contact_name">Name</Label>
                <Input
                  id="emergency_contact_name"
                  name="emergency_contact_name"
                  value={formData.emergency_contact_name}
                  onChange={handleChange}
                />
              </div>

              <div className="space-y-2">
                <Label htmlFor="emergency_contact_phone">Phone</Label>
                <Input
                  id="emergency_contact_phone"
                  name="emergency_contact_phone"
                  type="tel"
                  value={formData.emergency_contact_phone}
                  onChange={handleChange}
                />
              </div>

              <div className="space-y-2">
                <Label htmlFor="emergency_contact_relation">Relation</Label>
                <Input
                  id="emergency_contact_relation"
                  name="emergency_contact_relation"
                  value={formData.emergency_contact_relation}
                  onChange={handleChange}
                  placeholder="e.g., Spouse, Parent"
                />
              </div>
            </div>
          </div>

          <div className="flex justify-end gap-4">
            {saved && (
              <div className="flex items-center gap-2 text-green-600">
                <CheckCircle className="h-4 w-4" />
                <span>Profile saved!</span>
              </div>
            )}
            <Button type="submit" disabled={loading}>
              <Save className="h-4 w-4 mr-2" />
              {loading ? 'Saving...' : 'Save Profile'}
            </Button>
          </div>
        </form>
      </CardContent>
    </Card>
  );
};

export default ProfileForm;

