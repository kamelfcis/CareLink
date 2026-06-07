import React, { useState } from 'react';
import { supabase } from '../../lib/supabase';
import { VACCINATION_COLUMNS } from '../../lib/vaccinationsCache';
import { useVaccinations } from '../../hooks/useVaccinations';
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
import { Plus, Edit, Trash2, Syringe } from 'lucide-react';
import VaccinationsSkeleton from './VaccinationsSkeleton';

const Vaccinations = () => {
  const { patientId, vaccinations, loading, syncCache } = useVaccinations();
  const [dialogOpen, setDialogOpen] = useState(false);
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [selectedVaccination, setSelectedVaccination] = useState(null);
  const [formData, setFormData] = useState({
    vaccine_name: '',
    dose_number: '',
    vaccination_date: '',
    notes: '',
  });

  const handleOpenDialog = (vaccination = null) => {
    setSelectedVaccination(vaccination);
    setFormData(
      vaccination
        ? {
            vaccine_name: vaccination.vaccine_name,
            dose_number: vaccination.dose_number?.toString() || '',
            vaccination_date: vaccination.vaccination_date || '',
            notes: vaccination.notes || '',
          }
        : { vaccine_name: '', dose_number: '', vaccination_date: '', notes: '' }
    );
    setDialogOpen(true);
  };

  const handleSave = async () => {
    if (!patientId) return;

    try {
      const updateData = {
        vaccine_name: formData.vaccine_name,
        dose_number: formData.dose_number ? parseInt(formData.dose_number) : null,
        vaccination_date: formData.vaccination_date || null,
        notes: formData.notes || null,
      };

      if (selectedVaccination) {
        const { data, error } = await supabase
          .from('vaccinations')
          .update(updateData)
          .eq('id', selectedVaccination.id)
          .select(VACCINATION_COLUMNS)
          .single();

        if (error) throw error;

        syncCache(
          vaccinations.map((vaccination) =>
            vaccination.id === selectedVaccination.id ? data : vaccination
          )
        );
      } else {
        const { data, error } = await supabase
          .from('vaccinations')
          .insert({
            patient_id: patientId,
            ...updateData,
          })
          .select(VACCINATION_COLUMNS)
          .single();

        if (error) throw error;

        syncCache([data, ...vaccinations]);
      }

      setDialogOpen(false);
    } catch (error) {
      console.error('Error saving vaccination:', error);
      alert('Failed to save vaccination. Please try again.');
    }
  };

  const handleDelete = async () => {
    if (!selectedVaccination) return;

    const deletedId = selectedVaccination.id;
    const previousVaccinations = vaccinations;

    syncCache(vaccinations.filter((vaccination) => vaccination.id !== deletedId));
    setDeleteDialogOpen(false);
    setSelectedVaccination(null);

    try {
      const { error } = await supabase
        .from('vaccinations')
        .delete()
        .eq('id', deletedId);

      if (error) throw error;
    } catch (error) {
      syncCache(previousVaccinations);
      console.error('Error deleting vaccination:', error);
      alert('Failed to delete vaccination. Please try again.');
    }
  };

  if (loading) {
    return <VaccinationsSkeleton />;
  }

  return (
    <Card>
      <CardHeader>
        <div className="flex justify-between items-center">
          <div>
            <CardTitle>Vaccinations</CardTitle>
            <CardDescription>Track your vaccination history</CardDescription>
          </div>
          <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
            <DialogTrigger asChild>
              <Button onClick={() => handleOpenDialog()}>
                <Plus className="h-4 w-4 mr-2" />
                Add Vaccination
              </Button>
            </DialogTrigger>
            <DialogContent>
              <DialogHeader>
                <DialogTitle>{selectedVaccination ? 'Edit' : 'Add'} Vaccination</DialogTitle>
                <DialogDescription>Enter the details of your vaccination.</DialogDescription>
              </DialogHeader>
              <div className="space-y-4 py-4">
                <div className="space-y-2">
                  <Label htmlFor="vaccine_name">Vaccine Name *</Label>
                  <Input
                    id="vaccine_name"
                    value={formData.vaccine_name}
                    onChange={(e) => setFormData({ ...formData, vaccine_name: e.target.value })}
                    placeholder="e.g., COVID-19, Flu Shot"
                    required
                  />
                </div>
                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="dose_number">Dose Number</Label>
                    <Input
                      id="dose_number"
                      type="number"
                      min="1"
                      value={formData.dose_number}
                      onChange={(e) => setFormData({ ...formData, dose_number: e.target.value })}
                      placeholder="e.g., 1, 2, 3"
                    />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="vaccination_date">Vaccination Date</Label>
                    <Input
                      id="vaccination_date"
                      type="date"
                      value={formData.vaccination_date}
                      onChange={(e) => setFormData({ ...formData, vaccination_date: e.target.value })}
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
        {vaccinations.length === 0 ? (
          <div className="text-center py-8 text-gray-500">
            <Syringe className="h-12 w-12 mx-auto mb-4 opacity-50" />
            <p>No vaccinations recorded yet.</p>
          </div>
        ) : (
          <div className="space-y-4">
            {vaccinations.map((vaccination) => (
              <div
                key={vaccination.id}
                className="border rounded-lg p-4 flex justify-between items-start"
              >
                <div className="flex-1">
                  <h3 className="font-semibold text-lg">{vaccination.vaccine_name}</h3>
                  <div className="flex gap-4 mt-2 text-sm text-gray-600">
                    {vaccination.dose_number && (
                      <span>Dose: {vaccination.dose_number}</span>
                    )}
                    {vaccination.vaccination_date && (
                      <span>
                        Date: {new Date(vaccination.vaccination_date).toLocaleDateString()}
                      </span>
                    )}
                  </div>
                  {vaccination.notes && (
                    <p className="text-sm text-gray-600 mt-2">{vaccination.notes}</p>
                  )}
                </div>
                <div className="flex gap-2">
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={() => handleOpenDialog(vaccination)}
                  >
                    <Edit className="h-4 w-4" />
                  </Button>
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={() => {
                      setSelectedVaccination(vaccination);
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
                This action cannot be undone. This will permanently delete the vaccination record.
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

export default Vaccinations;
