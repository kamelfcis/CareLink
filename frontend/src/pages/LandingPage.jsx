import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { motion } from 'framer-motion';
import { Swiper, SwiperSlide } from 'swiper/react';
import { Navigation, Pagination, Autoplay, EffectFade } from 'swiper/modules';
import { Button } from '../components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '../components/ui/card';
import LanguageToggle from '../components/LanguageToggle';
import Logo from '../components/Logo';
import Footer from '../components/Footer';
import { Heart, Shield, QrCode, FileText, Users, CheckCircle, Lock, Clock, Globe, Stethoscope } from 'lucide-react';
import 'swiper/css';
import 'swiper/css/navigation';
import 'swiper/css/pagination';
import 'swiper/css/effect-fade';

const LandingPage = () => {
  const { t } = useTranslation();

  const heroSlides = [
    {
      title: t('landing.heroTitle'),
      subtitle: t('landing.heroSubtitle'),
      image: '/hero-medical-team.jpg', // Replace with your healthcare image
      // Fallback to Unsplash if local image doesn't exist
      fallbackImage: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=1920&q=80',
      overlay: 'bg-[#0d797e]/70',   
    },
    {
      title: 'Secure Medical Records',
      subtitle: 'Your health information protected with enterprise-grade encryption',
      image: '/hero-medical-records.jpg', // Replace with your healthcare image
      fallbackImage: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=1920&q=80',
      overlay: 'bg-[#0d797e]/70',
    },
    {
      title: 'Instant Access Anywhere',
      subtitle: 'Access your medical profile from any device, anywhere in the world',
      image: '/hero-healthcare-technology.jpg', // Replace with your healthcare image
      fallbackImage: 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=1920&q=80',
      overlay: 'bg-[#0d797e]/70',
    },
  ];
  
  // Pre-check if local images exist on mount
  React.useEffect(() => {
    heroSlides.forEach((slide, index) => {
      const img = new Image();
      img.onerror = () => {
        // Local image doesn't exist, use fallback
        setImageErrors(prev => ({ ...prev, [index]: true }));
      };
      img.onload = () => {
        // Local image exists, use it
        setImageErrors(prev => ({ ...prev, [index]: false }));
      };
      img.src = slide.image;
    });
  }, []);

  const services = [
    {
      icon: FileText,
      title: t('landing.createProfileStep'),
      description: t('landing.createProfileDesc'),
      color: 'bg-blue-500',
    },
    {
      icon: QrCode,
      title: t('landing.getQRCode'),
      description: t('landing.getQRCodeDesc'),
      color: 'bg-green-500',
    },
    {
      icon: Shield,
      title: t('landing.shareSecurely'),
      description: t('landing.shareSecurelyDesc'),
      color: 'bg-purple-500',
    },
    {
      icon: Lock,
      title: 'Data Encryption',
      description: 'All your medical data is encrypted and stored securely',
      color: 'bg-red-500',
    },
    {
      icon: Clock,
      title: '24/7 Access',
      description: 'Access your medical profile anytime, anywhere',
      color: 'bg-yellow-500',
    },
    {
      icon: Stethoscope,
      title: 'Healthcare Integration',
      description: 'Easy integration with healthcare providers and hospitals',
      color: 'bg-indigo-500',
    },
  ];

  const benefits = [
    'Secure and encrypted medical data storage',
    'Instant access via QR code scanning',
    'Comprehensive medical history tracking',
    'Emergency contact information',
    'Lab test results and documents',
    'Medication and allergy management',
  ];

  return (
    <div className="min-h-screen bg-gradient-to-b from-[#0d797e]/10 to-white dark:from-gray-900 dark:to-gray-800">
      {/* Header */}
      <motion.header
        initial={{ y: -100 }}
        animate={{ y: 0 }}
        transition={{ duration: 0.5 }}
        className="border-b bg-white/80 dark:bg-gray-900/80 backdrop-blur-sm sticky top-0 z-50"
      >
        <div className="container mx-auto px-4 py-4 flex justify-between items-center">
          <motion.div
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            className="flex items-center gap-2"
          >
            <Logo className="h-14 w-14" animated showText textSize="text-3xl" />
          </motion.div>
          <div className="flex gap-4 items-center">
            <LanguageToggle />
            <Link to="/login">
              <Button variant="ghost">{t('auth.login')}</Button>
            </Link>
            <Link to="/signup">
              <Button>{t('auth.signup')}</Button>
            </Link>
          </div>
        </div>
      </motion.header>

      {/* Hero Slider */}
      <section className="relative h-[600px] md:h-[700px] overflow-hidden">
        <Swiper
          modules={[Navigation, Pagination, Autoplay, EffectFade]}
          effect="fade"
          spaceBetween={0}
          slidesPerView={1}
          navigation
          pagination={{ clickable: true }}
          autoplay={{
            delay: 5000,
            disableOnInteraction: false,
          }}
          loop={true}
          className="h-full"
        >
          {heroSlides.map((slide, index) => {
            // Use fallback images directly since local images don't exist yet
            // When you add local images, they will be used automatically
            const imageUrl = slide.fallbackImage;
            
            return (
              <SwiperSlide key={index}>
                <div className="relative h-full w-full overflow-hidden">
                  {/* Background Image with Zoom Effect */}
                  <div className="absolute inset-0 w-full h-full hero-slide-bg" style={{ zIndex: 0 }}>
                    <div
                      className="absolute inset-0 w-full h-full"
                      style={{
                        backgroundImage: `url(${imageUrl})`,
                        backgroundSize: 'cover',
                        backgroundPosition: 'center',
                        backgroundRepeat: 'no-repeat',
                        zIndex: 0,
                      }}
                    />
                  </div>
                
                {/* Overlay for better text readability */}
                <div className={`absolute inset-0 ${slide.overlay}`} style={{ zIndex: 1 }} />
                
                {/* Content */}
                <div className="relative h-full flex items-center justify-center text-white z-10">
                  <motion.div
                    initial={{ opacity: 0, y: 50 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ duration: 0.8 }}
                    className="container mx-auto px-4 text-center"
                  >
                    <h1 className="text-4xl md:text-5xl lg:text-6xl font-bold mb-6 drop-shadow-lg">
                      {slide.title}
                    </h1>
                    <p className="text-lg md:text-xl lg:text-2xl mb-8 max-w-3xl mx-auto opacity-95 drop-shadow-md">
                      {slide.subtitle}
                    </p>
                    <Link to="/signup">
                      <motion.div
                        whileHover={{ scale: 1.05 }}
                        whileTap={{ scale: 0.95 }}
                      >
                        <Button size="lg" className="text-lg px-8 py-6 bg-white text-primary hover:bg-gray-100 shadow-xl">
                          {t('landing.createProfile')}
                        </Button>
                      </motion.div>
                    </Link>
                  </motion.div>
                </div>
              </div>
            </SwiperSlide>
            );
          })}
        </Swiper>
      </section>

      {/* Services Swiper */}
      <section className="container mx-auto px-4 py-16">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
        >
          <h2 className="text-3xl font-bold text-center mb-12 dark:text-white">{t('landing.howItWorks')}</h2>
        </motion.div>
        
        <Swiper
          modules={[Navigation, Pagination, Autoplay]}
          spaceBetween={30}
          slidesPerView={1}
          breakpoints={{
            640: {
              slidesPerView: 2,
            },
            1024: {
              slidesPerView: 3,
            },
          }}
          navigation
          pagination={{ clickable: true }}
          autoplay={{
            delay: 4000,
            disableOnInteraction: false,
          }}
          loop={true}
          className="pb-12"
        >
          {services.map((service, index) => {
            const Icon = service.icon;
            return (
              <SwiperSlide key={index}>
                <motion.div
                  initial={{ opacity: 0, y: 20 }}
                  whileInView={{ opacity: 1, y: 0 }}
                  viewport={{ once: true }}
                  transition={{ duration: 0.5, delay: index * 0.1 }}
                  whileHover={{ y: -10 }}
                >
                  <Card className="h-full hover:shadow-xl transition-shadow">
                    <CardHeader>
                      <motion.div
                        whileHover={{ rotate: 360 }}
                        transition={{ duration: 0.5 }}
                        className={`w-16 h-16 ${service.color} rounded-lg flex items-center justify-center mb-4`}
                      >
                        <Icon className="h-8 w-8 text-white" />
                      </motion.div>
                      <CardTitle className="dark:text-white">{service.title}</CardTitle>
                      <CardDescription className="dark:text-gray-300">
                        {service.description}
                      </CardDescription>
                    </CardHeader>
                  </Card>
                </motion.div>
              </SwiperSlide>
            );
          })}
        </Swiper>
      </section>

      {/* Benefits Section */}
      <section className="container mx-auto px-4 py-16">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
          className="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-8"
        >
          <h2 className="text-3xl font-bold text-center mb-12 dark:text-white">{t('landing.whyChoose')}</h2>
          <div className="grid md:grid-cols-2 gap-6 max-w-4xl mx-auto">
            {benefits.map((benefit, index) => (
              <motion.div
                key={index}
                initial={{ opacity: 0, x: -20 }}
                whileInView={{ opacity: 1, x: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5, delay: index * 0.1 }}
                className="flex items-start gap-3"
              >
                <CheckCircle className="h-5 w-5 text-primary mt-0.5 flex-shrink-0" />
                <p className="text-gray-700 dark:text-gray-300">{benefit}</p>
              </motion.div>
            ))}
          </div>
        </motion.div>
      </section>

      {/* CTA Section */}
      <section className="container mx-auto px-4 py-20 text-center">
        <motion.div
          initial={{ opacity: 0, scale: 0.9 }}
          whileInView={{ opacity: 1, scale: 1 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
        >
          <Card className="max-w-2xl mx-auto bg-primary text-primary-foreground">
            <CardHeader>
              <CardTitle className="text-3xl mb-4">{t('landing.readyToStart')}</CardTitle>
              <CardDescription className="text-primary-foreground/90">
                {t('landing.readyToStartDesc')}
              </CardDescription>
            </CardHeader>
            <CardContent>
              <Link to="/signup">
                <motion.div whileHover={{ scale: 1.05 }} whileTap={{ scale: 0.95 }}>
                  <Button size="lg" variant="secondary" className="text-lg px-8">
                    {t('landing.createProfile')}
                  </Button>
                </motion.div>
              </Link>
            </CardContent>
          </Card>
        </motion.div>
      </section>

      {/* Footer */}
      <Footer />
    </div>
  );
};

export default LandingPage;
