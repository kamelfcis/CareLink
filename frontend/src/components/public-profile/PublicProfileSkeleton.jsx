import React from 'react';

const Pulse = ({ className }) => (
  <div className={`animate-pulse rounded-lg bg-gray-200/80 dark:bg-gray-700/50 ${className}`} />
);

const PublicProfileSkeleton = () => (
  <div className="min-h-screen bg-gradient-to-br from-slate-50 via-teal-50/30 to-slate-100 py-6 md:py-10">
    <div className="container mx-auto px-4 max-w-5xl space-y-6">
      {/* Hero skeleton */}
      <div className="rounded-2xl border border-primary/10 bg-white/80 backdrop-blur p-6 md:p-8 shadow-lg">
        <div className="flex flex-col sm:flex-row items-start gap-6">
          <Pulse className="h-24 w-24 rounded-2xl shrink-0" />
          <div className="flex-1 space-y-3 w-full">
            <Pulse className="h-8 w-2/3 max-w-xs" />
            <Pulse className="h-4 w-40" />
            <div className="flex flex-wrap gap-2 pt-2">
              {[1, 2, 3, 4, 5, 6].map((i) => (
                <Pulse key={i} className="h-8 w-24 rounded-full" />
              ))}
            </div>
          </div>
          <Pulse className="h-[200px] w-[200px] rounded-xl shrink-0 hidden sm:block" />
        </div>
      </div>

      {/* Tabs skeleton */}
      <div className="flex gap-2 overflow-hidden">
        {[1, 2, 3, 4, 5, 6, 7].map((i) => (
          <Pulse key={i} className="h-10 w-28 shrink-0 rounded-full" />
        ))}
      </div>

      {/* Content skeleton */}
      <div className="rounded-2xl border border-primary/10 bg-white/80 backdrop-blur p-6 shadow-lg space-y-4">
        <Pulse className="h-6 w-48" />
        <div className="grid sm:grid-cols-2 gap-4">
          {[1, 2, 3, 4].map((i) => (
            <div key={i} className="rounded-xl border border-gray-100 p-4 space-y-3">
              <Pulse className="h-5 w-3/4" />
              <Pulse className="h-4 w-full" />
              <Pulse className="h-4 w-2/3" />
            </div>
          ))}
        </div>
      </div>
    </div>
  </div>
);

export default PublicProfileSkeleton;
