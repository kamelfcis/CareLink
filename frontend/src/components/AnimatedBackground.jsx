import React from 'react';
import { motion } from 'framer-motion';

const AnimatedBackground = ({ imageUrl, overlay = true }) => {
  return (
    <div className="fixed inset-0 overflow-hidden -z-10">
      <motion.div
        className="absolute inset-0"
        animate={{
          scale: [1, 1.1, 1],
        }}
        transition={{
          duration: 20,
          repeat: Infinity,
          ease: "easeInOut",
        }}
        style={{
          backgroundImage: imageUrl ? `url(${imageUrl})` : 'linear-gradient(135deg, #0d797e 0%, #0a5f63 50%, #087075 100%)',
          backgroundSize: 'cover',
          backgroundPosition: 'center',
          backgroundRepeat: 'no-repeat',
        }}
      >
        {overlay && (
          <div className="absolute inset-0 bg-gradient-to-br from-[#0d797e]/20 via-[#0d797e]/10 to-transparent backdrop-blur-sm" />
        )}
      </motion.div>
      <div className="absolute inset-0 bg-gradient-to-b from-transparent via-white/50 to-white dark:via-gray-900/50 dark:to-gray-900" />
    </div>
  );
};

export default AnimatedBackground;

