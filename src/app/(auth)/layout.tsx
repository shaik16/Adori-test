import { FC, ReactNode } from 'react';

interface AuthLayoutProps {
  children: ReactNode;
}

const AuthLayout: FC<AuthLayoutProps> = ({ children }) => {
  return (
    <div className="min-h-screen flex flex-col justify-center items-center bg-background">
      {children}
    </div>
  );
};

export default AuthLayout;
