import React, { useState } from 'react';
import { supabase } from '../../lib/supabase';
import { LAB_TEST_COLUMNS } from '../../lib/labTestsCache';
import { useLabTests } from '../../hooks/useLabTests';
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
import { Plus, Edit, Trash2, FileText, Upload, X } from 'lucide-react';
import LabTestsSkeleton from './LabTestsSkeleton';

const LabTests = () => {
  const { patientId, labTests, loading, syncCache } = useLabTests();
  const [dialogOpen, setDialogOpen] = useState(false);
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [selectedTest, setSelectedTest] = useState(null);
  const [uploading, setUploading] = useState(false);
  const [selectedFile, setSelectedFile] = useState(null);
  const [formData, setFormData] = useState({
    test_name: '',
    test_date: '',
    test_number: '',
    notes: '',
  });

  const handleOpenDialog = (test = null) => {
    setSelectedTest(test);
    setSelectedFile(null);
    setFormData(
      test
        ? {
            test_name: test.test_name || '',
            test_date: test.test_date || '',
            test_number: test.test_number || '',
            notes: test.notes || '',
          }
        : { test_name: '', test_date: '', test_number: '', notes: '' }
    );
    setDialogOpen(true);
  };

  const handleFileSelect = (e) => {
    const file = e.target.files[0];
    if (file) {
      setSelectedFile(file);
    }
  };

  const uploadFile = async (file, currentPatientId) => {
    const fileExt = file.name.split('.').pop();
    const fileName = `${Math.random()}.${fileExt}`;
    const filePath = `${currentPatientId}/${fileName}`;

    const { error: uploadError } = await supabase.storage
      .from('lab-tests')
      .upload(filePath, file);

    if (uploadError) throw uploadError;

    const { data } = supabase.storage.from('lab-tests').getPublicUrl(filePath);
    return data.publicUrl;
  };

  const handleSave = async () => {
    if (!patientId) return;

    try {
      setUploading(true);
      let filePath = selectedTest?.file_path || null;

      if (selectedFile) {
        filePath = await uploadFile(selectedFile, patientId);
      }

      const updateData = {
        ...formData,
        test_date: formData.test_date || null,
        file_path: filePath,
      };

      if (selectedTest) {
        const { data, error } = await supabase
          .from('lab_tests')
          .update(updateData)
          .eq('id', selectedTest.id)
          .select(LAB_TEST_COLUMNS)
          .single();

        if (error) throw error;

        syncCache(
          labTests.map((test) => (test.id === selectedTest.id ? data : test))
        );
      } else {
        const { data, error } = await supabase
          .from('lab_tests')
          .insert({
            patient_id: patientId,
            ...updateData,
          })
          .select(LAB_TEST_COLUMNS)
          .single();

        if (error) throw error;

        syncCache([data, ...labTests]);
      }

      setDialogOpen(false);
      setSelectedFile(null);
    } catch (error) {
      console.error('Error saving lab test:', error);
      alert('Failed to save lab test. Please try again.');
    } finally {
      setUploading(false);
    }
  };

  const handleDelete = async () => {
    if (!selectedTest) return;

    const deletedId = selectedTest.id;
    const deletedTest = selectedTest;
    const previousLabTests = labTests;

    syncCache(labTests.filter((test) => test.id !== deletedId));
    setDeleteDialogOpen(false);
    setSelectedTest(null);

    try {
      if (deletedTest.file_path) {
        const filePath = deletedTest.file_path.split('/').slice(-2).join('/');
        await supabase.storage.from('lab-tests').remove([filePath]);
      }

      const { error } = await supabase
        .from('lab_tests')
        .delete()
        .eq('id', deletedId);

      if (error) throw error;
    } catch (error) {
      syncCache(previousLabTests);
      console.error('Error deleting lab test:', error);
      alert('Failed to delete lab test. Please try again.');
    }
  };

  if (loading) {
    return <LabTestsSkeleton />;
  }

  return (
    <Card>
      <CardHeader>
        <div className="flex justify-between items-center">
          <div>
            <CardTitle>Lab Tests</CardTitle>
            <CardDescription>Upload and manage your lab test results</CardDescription>
          </div>
          <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
            <DialogTrigger asChild>
              <Button onClick={() => handleOpenDialog()}>
                <Plus className="h-4 w-4 mr-2" />
                Add Lab Test
              </Button>
            </DialogTrigger>
            <DialogContent className="max-w-2xl">
              <DialogHeader>
                <DialogTitle>{selectedTest ? 'Edit' : 'Add'} Lab Test</DialogTitle>
                <DialogDescription>Enter the details and upload your lab test results.</DialogDescription>
              </DialogHeader>
              <div className="space-y-4 py-4">
                <div className="space-y-2">
                  <Label htmlFor="test_name">Test Name</Label>
                  <Input
                    id="test_name"
                    value={formData.test_name}
                    onChange={(e) => setFormData({ ...formData, test_name: e.target.value })}
                    placeholder="e.g., Complete Blood Count, Lipid Panel"
                  />
                </div>
                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="test_date">Test Date</Label>
                    <Input
                      id="test_date"
                      type="date"
                      value={formData.test_date}
                      onChange={(e) => setFormData({ ...formData, test_date: e.target.value })}
                    />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="test_number">Test Number</Label>
                    <Input
                      id="test_number"
                      value={formData.test_number}
                      onChange={(e) => setFormData({ ...formData, test_number: e.target.value })}
                      placeholder="Lab reference number"
                    />
                  </div>
                </div>
                <div className="space-y-2">
                  <Label htmlFor="file">Upload Test Result</Label>
                  <div className="flex items-center gap-4">
                    <Input
                      id="file"
                      type="file"
                      accept="image/*,.pdf"
                      onChange={handleFileSelect}
                      className="flex-1"
                    />
                    {selectedFile && (
                      <div className="flex items-center gap-2 text-sm text-gray-600">
                        <span>{selectedFile.name}</span>
                        <Button
                          type="button"
                          variant="ghost"
                          size="icon"
                          onClick={() => setSelectedFile(null)}
                        >
                          <X className="h-4 w-4" />
                        </Button>
                      </div>
                    )}
                  </div>
                  {selectedTest?.file_path && !selectedFile && (
                    <p className="text-xs text-gray-500">
                      Current file: <a href={selectedTest.file_path} target="_blank" rel="noopener noreferrer" className="text-primary hover:underline">View</a>
                    </p>
                  )}
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
                <Button onClick={handleSave} disabled={uploading}>
                  <Upload className="h-4 w-4 mr-2" />
                  {uploading ? 'Uploading...' : 'Save'}
                </Button>
              </DialogFooter>
            </DialogContent>
          </Dialog>
        </div>
      </CardHeader>
      <CardContent>
        {labTests.length === 0 ? (
          <div className="text-center py-8 text-gray-500">
            <FileText className="h-12 w-12 mx-auto mb-4 opacity-50" />
            <p>No lab tests uploaded yet.</p>
          </div>
        ) : (
          <div className="space-y-4">
            {labTests.map((test) => (
              <div
                key={test.id}
                className="border rounded-lg p-4 flex justify-between items-start"
              >
                <div className="flex-1">
                  <h3 className="font-semibold text-lg">{test.test_name || 'Unnamed Test'}</h3>
                  <div className="flex gap-4 mt-2 text-sm text-gray-600">
                    {test.test_date && (
                      <span>Date: {new Date(test.test_date).toLocaleDateString()}</span>
                    )}
                    {test.test_number && <span>Ref: {test.test_number}</span>}
                  </div>
                  {test.notes && (
                    <p className="text-sm text-gray-600 mt-2">{test.notes}</p>
                  )}
                  {test.file_path && (
                    <a
                      href={test.file_path}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="text-primary hover:underline text-sm mt-2 inline-block"
                    >
                      View Test Result →
                    </a>
                  )}
                </div>
                <div className="flex gap-2">
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={() => handleOpenDialog(test)}
                  >
                    <Edit className="h-4 w-4" />
                  </Button>
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={() => {
                      setSelectedTest(test);
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
                This action cannot be undone. This will permanently delete the lab test record and its file.
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

export default LabTests;
