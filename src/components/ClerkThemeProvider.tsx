'use client';

import { useTheme } from 'next-themes';
import { ClerkProvider } from '@clerk/nextjs';
import { useEffect, useState } from 'react';
import { dark } from '@clerk/themes';

export function ClerkThemeProvider({ children }: { children: React.ReactNode }) {
  const { theme, systemTheme } = useTheme();
  const [resolvedTheme, setResolvedTheme] = useState<{
    baseTheme?: unknown;
    variables: {
      colorPrimary: string;
    };
  }>({
    baseTheme: dark,
    variables: { colorPrimary: '#ff2056' },
  });

  useEffect(() => {
    const finalTheme = theme === 'system' ? systemTheme : theme;
    setResolvedTheme(
      finalTheme === 'dark'
        ? {
            baseTheme: dark,
            variables: { colorPrimary: '#ff2056' },
          }
        : {
            variables: { colorPrimary: '#ff2056' },
          }
    );
  }, [theme, systemTheme]);

  return (
    // @ts-expect-error because the type of baseTheme is not available to use
    <ClerkProvider appearance={resolvedTheme}>{children}</ClerkProvider>
  );
}
