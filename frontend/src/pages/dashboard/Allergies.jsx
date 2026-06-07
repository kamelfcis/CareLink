import React, { useState, useEffect } from 'react';
import { useAuth } from '../../context/AuthContext';
import { supabase } from '../../lib/supabase';
import { Button } from '../../components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '../../components/ui/card';
import { Input } from '../../components/ui/input';
import { Label } from '../../components/ui/label';
import { Textarea } from '../../components/ui/textarea';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '../../components/ui/dialog';
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from '../../components/ui/alert-dialog';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '../../components/ui/select';
import { Plus, Edit, Trash2, AlertTriangle } from 'lucide-react';

const Allergies = () => {
  const { patient, patientLoading } = useAuth();
  const [allergies, setAllergies] = useState([]);
  const [loading, setLoading] = useState(true);
  const [dialogOpen, setDialogOpen] = useState(false);
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [selectedAllergy, setSelectedAllergy] = useState(null);
  const [formData, setFormData] = useState({
    allergy_name: '',
    severity: '',
    notes: '',
  });

  useEffect(() => {
    if (patientLoading) {
      setLoading(true);
      return;
    }

    if (patient?.id) {
      fetchAllergies();
    } else {
      setAllergies([]);
      setLoading(false);
    }
  }, [patient, patientLoading]);

  const fetchAllergies = async () => {
    if (!patient?.id) return;

    try {
      const { data, error } = await supabase
        .from('allergies')
        .select('*')
        .eq('patient_id', patient.id)
        .order('created_at', { ascending: false });

      if (error) throw error;
      setAllergies(data || []);
    } catch (error) {
      console.error('Error fetching allergies:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleOpenDialog = (allergy = null) => {
    setSelectedAllergy(allergy);
    setFormData(
      allergy
        ? {
            allergy_name: allergy.allergy_name,
            severity: allergy.severity || '',
            notes: allergy.notes || '',
          }
        : { allergy_name: '', severity: '', notes: '' }
    );
    setDialogOpen(true);
  };

  const handleSave = async () => {
    if (!patient?.id) return;

    try {
      const updateData = {
        ...formData,
        severity: formData.severity || null,
      };

      if (selectedAllergy) {
        const { error } = await supabase
          .from('allergies')
          .update(updateData)
          .eq('id', selectedAllergy.id);

        if (error) throw error;
      } else {
        const { error } = await supabase.from('allergies').insert({
          patient_id: patient.id,
          ...updateData,
        });

        if (error) throw error;
      }

      setDialogOpen(false);
      fetchAllergies();
    } catch (error) {
      console.error('Error saving allergy:', error);
      alert('Failed to save allergy. Please try again.');
    }
  };

  const handleDelete = async () => {
    if (!selectedAllergy) return;

    try {
      const { error } = await supabase
        .from('allergies')
        .delete()
        .eq('id', selectedAllergy.id);

      if (error) throw error;

      setDeleteDialogOpen(false);
      setSelectedAllergy(null);
      fetchAllergies();
    } catch (error) {
      console.error('Error deleting allergy:', error);
      alert('Failed to delete allergy. Please try again.');
    }
  };

  if (loading) {
    return <div className="text-center py-8">Loading...</div>;
  }

  return (
    <Card>
      <CardHeader>
        <div className="flex justify-between items-center">
          <div>
            <CardTitle>Allergies</CardTitle>
            <CardDescription>Record your allergies and sensitivities</CardDescription>
          </div>
          <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
            <DialogTrigger asChild>
              <Button onClick={() => handleOpenDialog()}>
                <Plus className="h-4 w-4 mr-2" />
                Add Allergy
              </Button>
            </DialogTrigger>
            <DialogContent>
              <DialogHeader>
                <DialogTitle>{selectedAllergy ? 'Edit' : 'Add'} Allergy</DialogTitle>
                <DialogDescription>Enter the details of your allergy.</DialogDescription>
              </DialogHeader>
              <div className="space-y-4 py-4">
                <div className="space-y-2">
                  <Label htmlFor="allergy_name">Allergy Name *</Label>
                  <Input
                    id="allergy_name"
                    value={formData.allergy_name}
                    onChange={(e) => setFormData({ ...formData, allergy_name: e.target.value })}
                    placeholder="e.g., Penicillin, Peanuts"
                    required
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="severity">Severity</Label>
                  <Select
                    value={formData.severity}
                    onValueChange={(value) => setFormData({ ...formData, severity: value })}
                  >
                    <SelectTrigger>
                      <SelectValue placeholder="Select severity" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="mild">Mild</SelectItem>
                      <SelectItem value="moderate">Moderate</SelectItem>
                      <SelectItem value="severe">Severe</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <div className="space-y-2">
                  <Label htmlFor="notes">Notes</Label>
                  <Textarea
                    id="notes"
                    value={formData.notes}
                    onChange={(e) => setFormData({ ...formData, notes: e.target.value })}
                    placeholder="Additional information..."
                    rows={4}
                  />
                </div>
              </div>
              <DialogFooter>
                <Button variant="outline" onClick={() => setDialogOpen(false)}>
                  Cancel
                </Button>
                <Button onClick={handleSave}>Save</Button>
              </DialogFooter>
            </DialogContent>
          </Dialog>
        </div>
      </CardHeader>
      <CardContent>
        {allergies.length === 0 ? (
          <div className="text-center py-8 text-gray-500">
            <AlertTriangle className="h-12 w-12 mx-auto mb-4 opacity-50" />
            <p>No allergies recorded yet.</p>
          </div>
        ) : (
          <div className="space-y-4">
            {allergies.map((allergy) => (
              <div
                key={allergy.id}
                className="border rounded-lg p-4 flex justify-between items-start"
              >
                <div className="flex-1">
                  <h3 className="font-semibold text-lg">{allergy.allergy_name}</h3>
                  {allergy.severity && (
                    <p className="text-sm text-gray-600 mt-1">
                      Severity: <span className="capitalize">{allergy.severity}</span>
                    </p>
                  )}
                  {allergy.notes && (
                    <p className="text-sm text-gray-600 mt-2">{allergy.notes}</p>
                  )}
                </div>
                <div className="flex gap-2">
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={() => handleOpenDialog(allergy)}
                  >
                    <Edit className="h-4 w-4" />
                  </Button>
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={() => {
                      setSelectedAllergy(allergy);
                      setDeleteDialogOpen(true);
                    }}
                  >
                    <Trash2 className="h-4 w-4 text-destructive" />
                  </Button>
                </div>
              </div>
            ))}
          </div>
        )}

        <AlertDialog open={deleteDialogOpen} onOpenChange={setDeleteDialogOpen}>
          <AlertDialogContent>
            <AlertDialogHeader>
              <AlertDialogTitle>Are you sure?</AlertDialogTitle>
              <AlertDialogDescription>
                This action cannot be undone. This will permanently delete the allergy record.
              </AlertDialogDescription>
            </AlertDialogHeader>
            <AlertDialogFooter>
              <AlertDialogCancel>Cancel</AlertDialogCancel>
              <AlertDialogAction onClick={handleDelete} className="bg-destructive">
                Delete
              </AlertDialogAction>
            </AlertDialogFooter>
          </AlertDialogContent>
        </AlertDialog>
      </CardContent>
    </Card>
  );
};

export default Allergies;


