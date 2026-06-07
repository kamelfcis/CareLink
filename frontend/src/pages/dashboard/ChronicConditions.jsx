import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import { supabase } from '../../lib/supabase';
import { useChronicConditions } from '../../hooks/useChronicConditions';
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
import { Plus, Edit, Trash2, Heart } from 'lucide-react';
import ChronicConditionsSkeleton from './ChronicConditionsSkeleton';

const ChronicConditions = () => {
  const { patientId, conditions, loading, syncCache, profileReady } = useChronicConditions();
  const [dialogOpen, setDialogOpen] = useState(false);
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [selectedCondition, setSelectedCondition] = useState(null);
  const [formData, setFormData] = useState({ name: '', notes: '' });
  const [saving, setSaving] = useState(false);
  const [saveError, setSaveError] = useState(null);

  const handleOpenDialog = (condition = null) => {
    setSelectedCondition(condition);
    setFormData(condition ? { name: condition.name, notes: condition.notes || '' } : { name: '', notes: '' });
    setSaveError(null);
    setDialogOpen(true);
  };

  const handleSave = async () => {
    const trimmedName = formData.name.trim();
    if (!trimmedName) {
      setSaveError('Condition name is required.');
      return;
    }

    if (!patientId) {
      setSaveError('Please complete your profile before adding a chronic condition.');
      return;
    }

    setSaving(true);
    setSaveError(null);

    const payload = {
      name: trimmedName,
      notes: formData.notes.trim() || null,
    };

    try {
      if (selectedCondition) {
        const { data, error } = await supabase
          .from('chronic_conditions')
          .update(payload)
          .eq('id', selectedCondition.id)
          .select('id, name, notes, created_at')
          .single();

        if (error) throw error;

        syncCache(
          conditions.map((condition) =>
            condition.id === selectedCondition.id ? data : condition
          )
        );
      } else {
        const { data, error } = await supabase
          .from('chronic_conditions')
          .insert({
            patient_id: patientId,
            ...payload,
          })
          .select('id, name, notes, created_at')
          .single();

        if (error) throw error;

        syncCache([data, ...conditions]);
      }

      setDialogOpen(false);
    } catch (error) {
      console.error('Error saving condition:', error);
      setSaveError(error.message || 'Failed to save condition. Please try again.');
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async () => {
    if (!selectedCondition) return;

    const deletedId = selectedCondition.id;
    const previousConditions = conditions;

    syncCache(conditions.filter((condition) => condition.id !== deletedId));
    setDeleteDialogOpen(false);
    setSelectedCondition(null);

    try {
      const { error } = await supabase
        .from('chronic_conditions')
        .delete()
        .eq('id', deletedId);

      if (error) throw error;
    } catch (error) {
      syncCache(previousConditions);
      console.error('Error deleting condition:', error);
      alert('Failed to delete condition. Please try again.');
    }
  };

  if (loading) {
    return <ChronicConditionsSkeleton />;
  }

  if (!profileReady) {
    return (
      <Card>
        <CardHeader>
          <CardTitle>Chronic Conditions</CardTitle>
          <CardDescription>Manage your chronic medical conditions</CardDescription>
        </CardHeader>
        <CardContent className="text-center py-8 text-gray-500">
          <Heart className="h-12 w-12 mx-auto mb-4 opacity-50" />
          <p className="mb-4">Complete your profile before adding chronic conditions.</p>
          <Button asChild>
            <Link to="/dashboard/profile">Go to Profile</Link>
          </Button>
        </CardContent>
      </Card>
    );
  }

  return (
    <Card>
      <CardHeader>
        <div className="flex justify-between items-center">
          <div>
            <CardTitle>Chronic Conditions</CardTitle>
            <CardDescription>Manage your chronic medical conditions</CardDescription>
          </div>
          <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
            <DialogTrigger asChild>
              <Button onClick={() => handleOpenDialog()}>
                <Plus className="h-4 w-4 mr-2" />
                Add Condition
              </Button>
            </DialogTrigger>
            <DialogContent>
              <DialogHeader>
                <DialogTitle>{selectedCondition ? 'Edit' : 'Add'} Chronic Condition</DialogTitle>
                <DialogDescription>
                  Enter the details of your chronic condition.
                </DialogDescription>
              </DialogHeader>
              <div className="space-y-4 py-4">
                {saveError && (
                  <p className="text-sm text-destructive" role="alert">
                    {saveError}
                  </p>
                )}
                <div className="space-y-2">
                  <Label htmlFor="name">Condition Name *</Label>
                  <Input
                    id="name"
                    value={formData.name}
                    onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                    placeholder="e.g., Diabetes, Hypertension"
                    required
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
                <Button variant="outline" onClick={() => setDialogOpen(false)} disabled={saving}>
                  Cancel
                </Button>
                <Button onClick={handleSave} disabled={saving}>
                  {saving ? 'Saving...' : 'Save'}
                </Button>
              </DialogFooter>
            </DialogContent>
          </Dialog>
        </div>
      </CardHeader>
      <CardContent>
        {conditions.length === 0 ? (
          <div className="text-center py-8 text-gray-500">
            <Heart className="h-12 w-12 mx-auto mb-4 opacity-50" />
            <p>No chronic conditions added yet.</p>
          </div>
        ) : (
          <div className="space-y-4">
            {conditions.map((condition) => (
              <div
                key={condition.id}
                className="border rounded-lg p-4 flex justify-between items-start"
              >
                <div className="flex-1">
                  <h3 className="font-semibold text-lg">{condition.name}</h3>
                  {condition.notes && (
                    <p className="text-sm text-gray-600 mt-2">{condition.notes}</p>
                  )}
                </div>
                <div className="flex gap-2">
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={() => handleOpenDialog(condition)}
                  >
                    <Edit className="h-4 w-4" />
                  </Button>
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={() => {
                      setSelectedCondition(condition);
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
                This action cannot be undone. This will permanently delete the chronic condition.
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

export default ChronicConditions;
