import React from 'react';
import { Card, CardContent, CardHeader } from '../../components/ui/card';

const StatisticsSkeleton = () => (
  <div className="space-y-6 animate-pulse">
    <div className="space-y-2">
      <div className="h-9 w-56 rounded bg-gray-200 dark:bg-gray-800" />
      <div className="h-5 w-72 rounded bg-gray-100 dark:bg-gray-900" />
    </div>

    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
      {[0, 1, 2, 3].map((item) => (
        <Card key={item} className="overflow-hidden border-0 shadow-lg">
          <CardContent className="p-6 space-y-4">
            <div className="h-16 rounded-lg bg-gray-200 dark:bg-gray-800 -m-6 mb-4 p-4" />
            <div className="h-4 w-24 rounded bg-gray-100 dark:bg-gray-900" />
            <div className="h-8 w-16 rounded bg-gray-200 dark:bg-gray-800" />
          </CardContent>
        </Card>
      ))}
    </div>

    <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
      {[0, 1].map((item) => (
        <Card key={item}>
          <CardHeader className="space-y-2">
            <div className="h-6 w-40 rounded bg-gray-200 dark:bg-gray-800" />
            <div className="h-4 w-56 rounded bg-gray-100 dark:bg-gray-900" />
          </CardHeader>
          <CardContent>
            <div className="h-[300px] rounded-lg bg-gray-100 dark:bg-gray-900" />
          </CardContent>
        </Card>
      ))}
    </div>

    <Card>
      <CardHeader className="space-y-2">
        <div className="h-6 w-36 rounded bg-gray-200 dark:bg-gray-800" />
        <div className="h-4 w-64 rounded bg-gray-100 dark:bg-gray-900" />
      </CardHeader>
      <CardContent className="space-y-4">
        {[0, 1, 2, 3].map((item) => (
          <div key={item} className="flex items-center justify-between p-4 border rounded-lg">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-full bg-gray-200 dark:bg-gray-800" />
              <div className="space-y-2">
                <div className="h-4 w-32 rounded bg-gray-200 dark:bg-gray-800" />
                <div className="h-3 w-24 rounded bg-gray-100 dark:bg-gray-900" />
              </div>
            </div>
            <div className="h-4 w-20 rounded bg-gray-100 dark:bg-gray-900" />
          </div>
        ))}
      </CardContent>
    </Card>
  </div>
);

export default StatisticsSkeleton;
