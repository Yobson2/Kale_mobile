import { cn } from "@/app/lib/utils";

type ButtonVariant = "primary" | "secondary" | "ghost" | "light";
type ButtonSize = "md" | "lg";

const variantStyles: Record<ButtonVariant, string> = {
  // The app's primary action: an emerald gradient, never a flat fill.
  primary:
    "bg-linear-to-b from-emerald-700 to-emerald-800 text-white shadow-[0_1px_0_rgba(255,255,255,0.18)_inset,0_10px_24px_-10px_rgba(0,108,73,0.6)] hover:from-emerald-800 hover:to-emerald-900",
  secondary: "bg-surface-high text-ink hover:bg-surface",
  ghost: "text-ink hover:bg-ink/5",
  light: "bg-emerald-200 text-emerald-950 hover:bg-white",
};

const sizeStyles: Record<ButtonSize, string> = {
  md: "h-11 px-5 text-sm",
  lg: "h-13 px-6 text-base",
};

export function buttonClasses({
  variant = "primary",
  size = "md",
  className,
}: {
  variant?: ButtonVariant;
  size?: ButtonSize;
  className?: string;
}) {
  return cn(
    "inline-flex items-center justify-center gap-2 rounded-xl font-semibold whitespace-nowrap transition duration-200 ease-out active:scale-[0.98]",
    variantStyles[variant],
    sizeStyles[size],
    className
  );
}

interface ButtonLinkProps extends React.AnchorHTMLAttributes<HTMLAnchorElement> {
  variant?: ButtonVariant;
  size?: ButtonSize;
}

export function ButtonLink({ variant, size, className, children, ...props }: ButtonLinkProps) {
  return (
    <a className={buttonClasses({ variant, size, className })} {...props}>
      {children}
    </a>
  );
}
