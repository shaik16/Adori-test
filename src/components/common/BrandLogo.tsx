'use client';

import Image from 'next/image';
import { useTheme } from 'next-themes';
import { useEffect, useState } from 'react';

export function BrandLogo() {
  const { theme, systemTheme } = useTheme();
  const [isMounted, setIsMounted] = useState(false);

  useEffect(() => {
    // Wait for hydration to finish
    setIsMounted(true);
  }, []);

  if (!isMounted) {
    // Skip rendering entirely on server
    return null;
  }

  const currentTheme = theme === 'system' ? systemTheme : theme;
  const logoSrc = currentTheme === 'dark' ? '/adori-without-text.svg' : '/adori-logo-dark.png';

  return (
    <span className="flex items-center gap-2 font-semibold flex-shrink-0 text-lg">
      <Image src={logoSrc} height={50} width={50} alt="logo" />
      <span>Adori AI</span>
    </span>
  );
}
