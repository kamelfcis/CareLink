import React from 'react';
import { Card, CardContent, CardHeader } from './ui/card';

const DashboardPageFallback = () => (
  <Card>
    <CardHeader>
      <div className="h-7 w-48 rounded bg-gray-200 dark:bg-gray-800 animate-pulse" />
      <div className="h-4 w-72 max-w-full rounded bg-gray-100 dark:bg-gray-900 animate-pulse mt-2" />
    </CardHeader>
    <CardContent className="space-y-4">
      {[0, 1, 2].map((item) => (
        <div
          key={item}
          className="h-20 rounded-lg bg-gray-100 dark:bg-gray-900 animate-pulse"
        />
      ))}
    </CardContent>
  </Card>
);

export default DashboardPageFallback;
