import type { ButtonHTMLAttributes, ReactNode } from "react";
import { twMerge } from "tailwind-merge";

type ButtonVariant = "primary" | "secondary" | "ghost";

type ButtonProps = {
    children: ReactNode;
    variant?: ButtonVariant;
} & ButtonHTMLAttributes<HTMLButtonElement>;

const variantClasses: Record<ButtonVariant, string> = {
    primary: `
        bg-[var(--color-primary)]
        text-white
        border-transparent
        hover:brightness-95
        hover:shadow-md
    `,

    secondary: `
        bg-[var(--color-surface)]
        text-[var(--color-text)]
        border-[var(--color-border)]
        hover:bg-[var(--color-surface-alt)]
        hover:border-[var(--color-border-strong)]
    `,

    ghost: `
        bg-transparent
        text-[var(--color-text)]
        border-transparent
        hover:bg-[var(--color-surface-alt)]
    `,
};

export default function Button({
                                   children,
                                   variant = "primary",
                                   className,
                                   type = "button",
                                   ...props
                               }: ButtonProps) {
    return (
        <button
            type={type}
            className={twMerge(
                `
                    inline-flex
                    items-center
                    justify-center
                    rounded-xl
                    border
                    px-6
                    py-3
                    font-semibold
                    transition-all
                    duration-200
                    hover:-translate-y-0.5
                    active:translate-y-0
                    active:scale-[0.98]
                    disabled:cursor-not-allowed
                    disabled:opacity-50
                    disabled:hover:translate-y-0
                `,
                variantClasses[variant],
                className,
            )}
            {...props}
        >
            {children}
        </button>
    );
}