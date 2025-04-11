import { UserButton } from '@clerk/nextjs';
import Link from 'next/link';
import { BrandLogo } from './BrandLogo';
import { ThemeToggle } from './ThemeToggle';
import { Button } from '../ui/button';

const NavBar = ({}) => {
  return (
    <header className="flex py-4 shadow bg-background">
      <nav className="flex items-center gap-10 container">
        <Link className="mr-auto" href="/dashboard">
          <BrandLogo />
        </Link>
        <Button variant={'default'}>Book Demo</Button>
        <ThemeToggle />
        <UserButton />
      </nav>
    </header>
  );
};

export default NavBar;
