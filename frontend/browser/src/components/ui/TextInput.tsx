import {
    forwardRef,
    type InputHTMLAttributes,
    type ReactNode,
} from "react";
import { twMerge } from "tailwind-merge";

type TextInputProps = {
    label?: string;
    error?: string;
    helperText?: string;
    leadingIcon?: ReactNode;
} & InputHTMLAttributes<HTMLInputElement>;

const TextInput = forwardRef<HTMLInputElement, TextInputProps>(
    (
        {
            id,
            label,
            error,
            helperText,
            leadingIcon,
            className,
            disabled,
            ...props
        },
        ref,
    ) => {
        const inputId = id ?? props.name;
        const messageId = inputId ? `${inputId}-message` : undefined;
        const hasMessage = Boolean(error || helperText);

        return (
            <div className="w-full">
                {label && (
                    <label
                        htmlFor={inputId}
                        className="mb-2 block text-sm font-semibold text-[var(--color-text)]"
                    >
                        {label}
                    </label>
                )}

                <div className="relative">
                    {leadingIcon && (
                        <span className="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-4 text-[var(--color-text-muted)]">
                            {leadingIcon}
                        </span>
                    )}

                    <input
                        ref={ref}
                        id={inputId}
                        disabled={disabled}
                        aria-invalid={Boolean(error)}
                        aria-describedby={hasMessage ? messageId : undefined}
                        className={twMerge(
                            `
                                w-full
                                rounded-xl
                                border
                                border-[var(--color-border)]
                                bg-[var(--color-surface)]
                                px-4
                                py-3
                                text-[var(--color-text)]
                                shadow-sm
                                outline-none
                                transition
                                duration-200
                                placeholder:text-[var(--color-text-muted)]
                                hover:border-[var(--color-border-strong)]
                                focus:border-[var(--color-primary)]
                                focus:ring-4
                                focus:ring-[color-mix(in_srgb,var(--color-primary)_18%,transparent)]
                                disabled:cursor-not-allowed
                                disabled:bg-[var(--color-surface-alt)]
                                disabled:opacity-60
                            `,
                            leadingIcon && "pl-11",
                            error &&
                            `
                                    border-[var(--color-error)]
                                    focus:border-[var(--color-error)]
                                    focus:ring-[color-mix(in_srgb,var(--color-error)_15%,transparent)]
                                `,
                            className,
                        )}
                        {...props}
                    />
                </div>

                {hasMessage && (
                    <p
                        id={messageId}
                        className={twMerge(
                            "mt-2 text-sm",
                            error
                                ? "text-[var(--color-error)]"
                                : "text-[var(--color-text-muted)]",
                        )}
                    >
                        {error ?? helperText}
                    </p>
                )}
            </div>
        );
    },
);

TextInput.displayName = "TextInput";

export default TextInput;