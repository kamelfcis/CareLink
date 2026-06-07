import React, { useState } from 'react';
import { supabase } from '../../lib/supabase';
import { useMedications } from '../../hooks/useMedications';
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
import { Plus, Edit, Trash2, Pill } from 'lucide-react';
import MedicationsSkeleton from './MedicationsSkeleton';

const MEDICATION_COLUMNS =
  'id, medication_name, dosage, frequency, start_date, end_date, notes';

const Medications = () => {
  const { patientId, medications, loading, syncCache } = useMedications();
  const [dialogOpen, setDialogOpen] = useState(false);
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [selectedMedication, setSelectedMedication] = useState(null);
  const [formData, setFormData] = useState({
    medication_name: '',
    dosage: '',
    frequency: '',
    start_date: '',
    end_date: '',
    notes: '',
  });

  const handleOpenDialog = (medication = null) => {
    setSelectedMedication(medication);
    setFormData(
      medication
        ? {
            medication_name: medication.medication_name,
            dosage: medication.dosage || '',
            frequency: medication.frequency || '',
            start_date: medication.start_date || '',
            end_date: medication.end_date || '',
            notes: medication.notes || '',
          }
        : {
            medication_name: '',
            dosage: '',
            frequency: '',
            start_date: '',
            end_date: '',
            notes: '',
          }
    );
    setDialogOpen(true);
  };

  const handleSave = async () => {
    if (!patientId) return;

    try {
      const updateData = {
        ...formData,
        start_date: formData.start_date || null,
        end_date: formData.end_date || null,
      };

      if (selectedMedication) {
        const { data, error } = await supabase
          .from('medications')
          .update(updateData)
          .eq('id', selectedMedication.id)
          .select(MEDICATION_COLUMNS)
          .single();

        if (error) throw error;

        syncCache(
          medications.map((medication) =>
            medication.id === selectedMedication.id ? data : medication
          )
        );
      } else {
        const { data, error } = await supabase
          .from('medications')
          .insert({
            patient_id: patientId,
            ...updateData,
          })
          .select(MEDICATION_COLUMNS)
          .single();

        if (error) throw error;

        syncCache([data, ...medications]);
      }

      setDialogOpen(false);
    } catch (error) {
      console.error('Error saving medication:', error);
      alert('Failed to save medication. Please try again.');
    }
  };

  const handleDelete = async () => {
    if (!selectedMedication) return;

    const deletedId = selectedMedication.id;
    const previousMedications = medications;

    syncCache(medications.filter((medication) => medication.id !== deletedId));
    setDeleteDialogOpen(false);
    setSelectedMedication(null);

    try {
      const { error } = await supabase
        .from('medications')
        .delete()
        .eq('id', deletedId);

      if (error) throw error;
    } catch (error) {
      syncCache(previousMedications);
      console.error('Error deleting medication:', error);
      alert('Failed to delete medication. Please try again.');
    }
  };

  if (loading) {
    return <MedicationsSkeleton />;
  }

  return (
    <Card>
      <CardHeader>
        <div className="flex justify-between items-center">
          <div>
            <CardTitle>Medications</CardTitle>
            <CardDescription>Manage your current and past medications</CardDescription>
          </div>
          <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
            <DialogTrigger asChild>
              <Button onClick={() => handleOpenDialog()}>
                <Plus className="h-4 w-4 mr-2" />
                Add Medication
              </Button>
            </DialogTrigger>
            <DialogContent className="max-w-2xl">
              <DialogHeader>
                <DialogTitle>{selectedMedication ? 'Edit' : 'Add'} Medication</DialogTitle>
                <DialogDescription>Enter the details of your medication.</DialogDescription>
              </DialogHeader>
              <div className="space-y-4 py-4">
                <div className="space-y-2">
                  <Label htmlFor="medication_name">Medication Name *</Label>
                  <Input
                    id="medication_name"
                    value={formData.medication_name}
                    onChange={(e) => setFormData({ ...formData, medication_name: e.target.value })}
                    placeholder="e.g., Aspirin, Metformin"
                    required
                  />
                </div>
                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="dosage">Dosage</Label>
                    <Input
                      id="dosage"
                      value={formData.dosage}
                      onChange={(e) => setFormData({ ...formData, dosage: e.target.value })}
                      placeholder="e.g., 2 pills, 5 ml"
                    />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="frequency">Frequency</Label>
                    <Input
                      id="frequency"
                      value={formData.frequency}
                      onChange={(e) => setFormData({ ...formData, frequency: e.target.value })}
                      placeholder="e.g., Twice daily"
                    />
                  </div>
                </div>
                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="start_date">Start Date</Label>
                    <Input
                      id="start_date"
                      type="date"
                      value={formData.start_date}
                      onChange={(e) => setFormData({ ...formData, start_date: e.target.value })}
                    />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="end_date">End Date</Label>
                    <Input
                      id="end_date"
                      type="date"
                      value={formData.end_date}
                      onChange={(e) => setFormData({ ...formData, end_date: e.target.value })}
                    />
                  </div>
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
        {medications.length === 0 ? (
          <div className="text-center py-8 text-gray-500">
            <Pill className="h-12 w-12 mx-auto mb-4 opacity-50" />
            <p>No medications added yet.</p>
          </div>
        ) : (
          <div className="space-y-4">
            {medications.map((medication) => (
              <div
                key={medication.id}
                className="border rounded-lg p-4 flex justify-between items-start"
              >
                <div className="flex-1">
                  <h3 className="font-semibold text-lg">{medication.medication_name}</h3>
                  <div className="flex gap-4 mt-2 text-sm text-gray-600">
                    {medication.dosage && <span>Dosage: {medication.dosage}</span>}
                    {medication.frequency && <span>Frequency: {medication.frequency}</span>}
                  </div>
                  {medication.start_date && (
                    <p className="text-sm text-gray-600 mt-1">
                      {medication.end_date
                        ? `${new Date(medication.start_date).toLocaleDateString()} - ${new Date(medication.end_date).toLocaleDateString()}`
                        : `Started: ${new Date(medication.start_date).toLocaleDateString()}`}
                    </p>
                  )}
                  {medication.notes && (
                    <p className="text-sm text-gray-600 mt-2">{medication.notes}</p>
                  )}
                </div>
                <div className="flex gap-2">
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={() => handleOpenDialog(medication)}
                  >
                    <Edit className="h-4 w-4" />
                  </Button>
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={() => {
                      setSelectedMedication(medication);
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
                This action cannot be undone. This will permanently delete the medication record.
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

export default Medications;
