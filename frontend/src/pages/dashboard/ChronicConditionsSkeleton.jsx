import React from 'react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '../../components/ui/card';

const ChronicConditionsSkeleton = () => (
  <Card>
    <CardHeader>
      <div className="flex justify-between items-center">
        <div className="space-y-2">
          <CardTitle>Chronic Conditions</CardTitle>
          <CardDescription>Manage your chronic medical conditions</CardDescription>
        </div>
        <div className="h-10 w-36 rounded-md bg-gray-200 dark:bg-gray-800 animate-pulse" />
      </div>
    </CardHeader>
    <CardContent className="space-y-4">
      {[0, 1, 2].map((item) => (
        <div
          key={item}
          className="border rounded-lg p-4 flex justify-between items-start animate-pulse"
        >
          <div className="flex-1 space-y-2">
            <div className="h-5 w-40 rounded bg-gray-200 dark:bg-gray-800" />
            <div className="h-4 w-full max-w-md rounded bg-gray-100 dark:bg-gray-900" />
          </div>
          <div className="flex gap-2">
            <div className="h-9 w-9 rounded-md bg-gray-200 dark:bg-gray-800" />
            <div className="h-9 w-9 rounded-md bg-gray-200 dark:bg-gray-800" />
          </div>
        </div>
      ))}
    </CardContent>
  </Card>
);

export default ChronicConditionsSkeleton;
