import React from 'react';
import { motion } from 'framer-motion';
import { Heart } from 'lucide-react';

const Logo = ({ className = "h-16 w-16", animated = false, showText = false, textSize = "text-3xl" }) => {
  const [imageError, setImageError] = React.useState(false);
  const [imageLoaded, setImageLoaded] = React.useState(false);

  const logoContent = imageError ? (
    <Heart className={`${className} text-primary`} />
  ) : (
    <motion.img
      src="/logo.png"
      alt="CareLink Logo"
      className={`${className} ${imageLoaded ? 'opacity-100' : 'opacity-0'} transition-opacity duration-300`}
      onError={() => setImageError(true)}
      onLoad={() => setImageLoaded(true)}
      initial={animated ? { scale: 0, rotate: -180 } : false}
      animate={animated ? { scale: 1, rotate: 0 } : { scale: 1 }}
      transition={animated ? { duration: 0.6, type: "spring", stiffness: 200 } : {}}
      whileHover={animated ? { scale: 1.1, rotate: 5 } : { scale: 1.05 }}
      whileTap={animated ? { scale: 0.95 } : {}}
    />
  );

  const content = showText ? (
    <div className="flex items-center gap-3">
      {logoContent}
      <motion.span
        className={`${textSize} font-bold text-primary`}
        initial={animated ? { opacity: 0, x: -20 } : false}
        animate={animated ? { opacity: 1, x: 0 } : {}}
        transition={animated ? { delay: 0.3, duration: 0.5 } : {}}
      >
        CareLink
      </motion.span>
    </div>
  ) : (
    logoContent
  );

  if (animated && !imageError) {
    return <div>{content}</div>;
  }

  return (
    <motion.div
      initial={animated ? { scale: 0 } : false}
      animate={animated ? { scale: 1 } : {}}
      transition={animated ? { duration: 0.5, type: "spring" } : {}}
    >
      {content}
    </motion.div>
  );
};

export default Logo;

