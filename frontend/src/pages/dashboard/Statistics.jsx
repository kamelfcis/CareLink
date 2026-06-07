import React from 'react';
import { useTranslation } from 'react-i18next';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '../../components/ui/card';
import {
  BarChart,
  Bar,
  PieChart,
  Pie,
  Cell,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
} from 'recharts';
import { motion } from 'framer-motion';
import {
  Heart,
  Scissors,
  Pill,
  FileText,
  Activity,
  TrendingUp,
} from 'lucide-react';
import { useStatistics } from '../../hooks/useStatistics';
import StatisticsSkeleton from './StatisticsSkeleton';

const Statistics = () => {
  const { t } = useTranslation();
  const { stats, recentActivity, loading } = useStatistics();

  if (loading) {
    return <StatisticsSkeleton />;
  }

  const totalRecords = Object.values(stats).reduce((sum, val) => sum + val, 0);

  const chartData = [
    { name: t('statistics.chronicConditions'), value: stats.chronic, color: '#ef4444' },
    { name: t('statistics.surgeries'), value: stats.surgeries, color: '#3b82f6' },
    { name: t('statistics.medications'), value: stats.medications, color: '#10b981' },
    { name: t('statistics.labTests'), value: stats.labTests, color: '#f59e0b' },
    { name: t('statistics.allergies'), value: stats.allergies, color: '#8b5cf6' },
    { name: t('statistics.vaccinations'), value: stats.vaccinations, color: '#ec4899' },
  ].filter((item) => item.value > 0);

  const barChartData = [
    { category: t('statistics.chronicConditions'), count: stats.chronic },
    { category: t('statistics.surgeries'), count: stats.surgeries },
    { category: t('statistics.medications'), count: stats.medications },
    { category: t('statistics.labTests'), count: stats.labTests },
    { category: t('statistics.allergies'), count: stats.allergies },
    { category: t('statistics.vaccinations'), count: stats.vaccinations },
  ];

  const statCards = [
    {
      title: t('statistics.totalRecords'),
      value: totalRecords,
      icon: Activity,
      gradient: 'from-[#0d797e] to-[#0a5f63]',
    },
    {
      title: t('statistics.chronicConditions'),
      value: stats.chronic,
      icon: Heart,
      gradient: 'from-red-500 to-red-600',
    },
    {
      title: t('statistics.medications'),
      value: stats.medications,
      icon: Pill,
      gradient: 'from-[#0d797e] to-[#0a5f63]',
    },
    {
      title: t('statistics.labTests'),
      value: stats.labTests,
      icon: FileText,
      gradient: 'from-yellow-500 to-yellow-600',
    },
  ];

  return (
    <div className="space-y-6">
      <motion.div
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
      >
        <h1 className="text-3xl font-bold">{t('statistics.title')}</h1>
        <p className="text-gray-600 mt-2">{t('statistics.overview')}</p>
      </motion.div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {statCards.map((card, index) => {
          const Icon = card.icon;
          return (
            <motion.div
              key={card.title}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5, delay: index * 0.1 }}
            >
              <Card className="overflow-hidden border-0 shadow-lg">
                <CardContent className="p-6">
                  <div className={`bg-gradient-to-br ${card.gradient} rounded-lg p-4 -m-6 mb-4`}>
                    <div className="flex items-center justify-between">
                      <Icon className="h-8 w-8 text-white" />
                      <TrendingUp className="h-5 w-5 text-white/80" />
                    </div>
                  </div>
                  <h3 className="text-sm font-medium text-gray-600 mb-1">{card.title}</h3>
                  <p className="text-3xl font-bold text-gray-900">{card.value}</p>
                </CardContent>
              </Card>
            </motion.div>
          );
        })}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <motion.div
          initial={{ opacity: 0, x: -20 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ duration: 0.5, delay: 0.4 }}
        >
          <Card>
            <CardHeader>
              <CardTitle>{t('statistics.healthTrends')}</CardTitle>
              <CardDescription>Distribution of your medical records</CardDescription>
            </CardHeader>
            <CardContent>
              <ResponsiveContainer width="100%" height={300}>
                <BarChart data={barChartData}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis dataKey="category" />
                  <YAxis />
                  <Tooltip />
                  <Legend />
                  <Bar dataKey="count" fill="#3b82f6" radius={[8, 8, 0, 0]} />
                </BarChart>
              </ResponsiveContainer>
            </CardContent>
          </Card>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, x: 20 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ duration: 0.5, delay: 0.5 }}
        >
          <Card>
            <CardHeader>
              <CardTitle>Records Distribution</CardTitle>
              <CardDescription>Pie chart of medical data</CardDescription>
            </CardHeader>
            <CardContent>
              <ResponsiveContainer width="100%" height={300}>
                <PieChart>
                  <Pie
                    data={chartData}
                    cx="50%"
                    cy="50%"
                    labelLine={false}
                    label={({ name, percent }) => `${name}: ${(percent * 100).toFixed(0)}%`}
                    outerRadius={80}
                    fill="#8884d8"
                    dataKey="value"
                  >
                    {chartData.map((entry, index) => (
                      <Cell key={`cell-${index}`} fill={entry.color} />
                    ))}
                  </Pie>
                  <Tooltip />
                </PieChart>
              </ResponsiveContainer>
            </CardContent>
          </Card>
        </motion.div>
      </div>

      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5, delay: 0.6 }}
      >
        <Card>
          <CardHeader>
            <CardTitle>{t('statistics.recentActivity')}</CardTitle>
            <CardDescription>Your recent medical record additions</CardDescription>
          </CardHeader>
          <CardContent>
            {recentActivity.length === 0 ? (
              <p className="text-center text-gray-500 py-8">No recent activity</p>
            ) : (
              <div className="space-y-4">
                {recentActivity.map((activity, index) => (
                  <motion.div
                    key={index}
                    initial={{ opacity: 0, x: -20 }}
                    animate={{ opacity: 1, x: 0 }}
                    transition={{ duration: 0.3, delay: index * 0.1 }}
                    className="flex items-center justify-between p-4 border rounded-lg hover:bg-gray-50 transition-colors"
                  >
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 bg-primary/10 rounded-full flex items-center justify-center">
                        {activity.type === 'Chronic Condition' && <Heart className="h-5 w-5 text-red-500" />}
                        {activity.type === 'Surgery' && <Scissors className="h-5 w-5 text-blue-500" />}
                        {activity.type === 'Medication' && <Pill className="h-5 w-5 text-green-500" />}
                      </div>
                      <div>
                        <p className="font-medium">{activity.name}</p>
                        <p className="text-sm text-gray-500">{activity.type}</p>
                      </div>
                    </div>
                    <p className="text-sm text-gray-500">
                      {new Date(activity.date).toLocaleDateString()}
                    </p>
                  </motion.div>
                ))}
              </div>
            )}
          </CardContent>
        </Card>
      </motion.div>
    </div>
  );
};

export default Statistics;
