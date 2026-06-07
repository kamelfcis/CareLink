import React, { useState } from 'react';
import { supabase } from '../../lib/supabase';
import { useSurgeries } from '../../hooks/useSurgeries';
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
import { Plus, Edit, Trash2, Scissors } from 'lucide-react';
import SurgeriesSkeleton from './SurgeriesSkeleton';

const SURGERY_COLUMNS = 'id, operation_name, operation_date, notes';

const Surgeries = () => {
  const { patientId, surgeries, loading, syncCache } = useSurgeries();
  const [dialogOpen, setDialogOpen] = useState(false);
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [selectedSurgery, setSelectedSurgery] = useState(null);
  const [formData, setFormData] = useState({
    operation_name: '',
    operation_date: '',
    notes: '',
  });

  const handleOpenDialog = (surgery = null) => {
    setSelectedSurgery(surgery);
    setFormData(
      surgery
        ? {
            operation_name: surgery.operation_name,
            operation_date: surgery.operation_date || '',
            notes: surgery.notes || '',
          }
        : { operation_name: '', operation_date: '', notes: '' }
    );
    setDialogOpen(true);
  };

  const handleSave = async () => {
    if (!patientId) return;

    try {
      const updateData = {
        ...formData,
        operation_date: formData.operation_date || null,
      };

      if (selectedSurgery) {
        const { data, error } = await supabase
          .from('surgeries')
          .update(updateData)
          .eq('id', selectedSurgery.id)
          .select(SURGERY_COLUMNS)
          .single();

        if (error) throw error;

        syncCache(
          surgeries.map((surgery) =>
            surgery.id === selectedSurgery.id ? data : surgery
          )
        );
      } else {
        const { data, error } = await supabase
          .from('surgeries')
          .insert({
            patient_id: patientId,
            ...updateData,
          })
          .select(SURGERY_COLUMNS)
          .single();

        if (error) throw error;

        syncCache([data, ...surgeries]);
      }

      setDialogOpen(false);
    } catch (error) {
      console.error('Error saving surgery:', error);
      alert('Failed to save surgery. Please try again.');
    }
  };

  const handleDelete = async () => {
    if (!selectedSurgery) return;

    const deletedId = selectedSurgery.id;
    const previousSurgeries = surgeries;

    syncCache(surgeries.filter((surgery) => surgery.id !== deletedId));
    setDeleteDialogOpen(false);
    setSelectedSurgery(null);

    try {
      const { error } = await supabase
        .from('surgeries')
        .delete()
        .eq('id', deletedId);

      if (error) throw error;
    } catch (error) {
      syncCache(previousSurgeries);
      console.error('Error deleting surgery:', error);
      alert('Failed to delete surgery. Please try again.');
    }
  };

  if (loading) {
    return <SurgeriesSkeleton />;
  }

  return (
    <Card>
      <CardHeader>
        <div className="flex justify-between items-center">
          <div>
            <CardTitle>Surgeries</CardTitle>
            <CardDescription>Record your surgical history</CardDescription>
          </div>
          <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
            <DialogTrigger asChild>
              <Button onClick={() => handleOpenDialog()}>
                <Plus className="h-4 w-4 mr-2" />
                Add Surgery
              </Button>
            </DialogTrigger>
            <DialogContent>
              <DialogHeader>
                <DialogTitle>{selectedSurgery ? 'Edit' : 'Add'} Surgery</DialogTitle>
                <DialogDescription>Enter the details of your surgery.</DialogDescription>
              </DialogHeader>
              <div className="space-y-4 py-4">
                <div className="space-y-2">
                  <Label htmlFor="operation_name">Operation Name *</Label>
                  <Input
                    id="operation_name"
                    value={formData.operation_name}
                    onChange={(e) => setFormData({ ...formData, operation_name: e.target.value })}
                    placeholder="e.g., Appendectomy, Knee Replacement"
                    required
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="operation_date">Operation Date</Label>
                  <Input
                    id="operation_date"
                    type="date"
                    value={formData.operation_date}
                    onChange={(e) => setFormData({ ...formData, operation_date: e.target.value })}
                  />
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
        {surgeries.length === 0 ? (
          <div className="text-center py-8 text-gray-500">
            <Scissors className="h-12 w-12 mx-auto mb-4 opacity-50" />
            <p>No surgeries recorded yet.</p>
          </div>
        ) : (
          <div className="space-y-4">
            {surgeries.map((surgery) => (
              <div
                key={surgery.id}
                className="border rounded-lg p-4 flex justify-between items-start"
              >
                <div className="flex-1">
                  <h3 className="font-semibold text-lg">{surgery.operation_name}</h3>
                  {surgery.operation_date && (
                    <p className="text-sm text-gray-600 mt-1">
                      Date: {new Date(surgery.operation_date).toLocaleDateString()}
                    </p>
                  )}
                  {surgery.notes && (
                    <p className="text-sm text-gray-600 mt-2">{surgery.notes}</p>
                  )}
                </div>
                <div className="flex gap-2">
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={() => handleOpenDialog(surgery)}
                  >
                    <Edit className="h-4 w-4" />
                  </Button>
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={() => {
                      setSelectedSurgery(surgery);
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
                This action cannot be undone. This will permanently delete the surgery record.
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

export default Surgeries;
