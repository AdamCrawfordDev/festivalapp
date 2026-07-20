import type {
    FormHTMLAttributes,
    ReactNode,
} from "react";
import { twMerge } from "tailwind-merge";

type FormProps = {
    title?: string;
    description?: string;
    children: ReactNode;
    footer?: ReactNode;
} & FormHTMLAttributes<HTMLFormElement>;

export default function Form({
                                 title,
                                 description,
                                 children,
                                 footer,
                                 className,
                                 ...props
                             }: FormProps) {
    return (
        <form
            className={twMerge(
                `
                    w-full
                    max-w-lg
                    rounded-2xl
                    border
                    border-[var(--color-border)]
                    bg-[var(--color-surface)]
                    p-6
                    shadow-md
                    sm:p-8
                `,
                className,
            )}
            {...props}
        >
            {(title || description) && (
                <div className="mb-8">
                    {title && (
                        <h1 className="font-heading text-3xl font-semibold text-[var(--color-accent)]">
                            {title}
                        </h1>
                    )}

                    {description && (
                        <p className="mt-2 text-sm leading-6 text-[var(--color-text-muted)]">
                            {description}
                        </p>
                    )}
                </div>
            )}

            <div className="space-y-5">
                {children}
            </div>

            {footer && (
                <div className="mt-6 border-t border-[var(--color-border)] pt-6">
                    {footer}
                </div>
            )}
        </form>
    );
}