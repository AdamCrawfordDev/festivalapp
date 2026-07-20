import {
    useEffect,
    useRef,
    useState,
} from "react";

type SelectOption = {
    value: string;
    label: string;
};

type SelectFieldProps = {
    label: string;
    value: string;
    options: SelectOption[];
    placeholder?: string;
    error?: string;
    disabled?: boolean;
    onChange: (value: string) => void;
};

export default function SelectField({
                                        label,
                                        value,
                                        options,
                                        placeholder = "Select an option",
                                        error,
                                        disabled = false,
                                        onChange,
                                    }: SelectFieldProps) {
    const [isOpen, setIsOpen] = useState(false);
    const containerRef = useRef<HTMLDivElement>(null);

    const selectedOption = options.find(
        (option) => option.value === value,
    );

    useEffect(() => {
        function handleOutsideClick(event: MouseEvent) {
            if (
                containerRef.current &&
                !containerRef.current.contains(
                    event.target as Node,
                )
            ) {
                setIsOpen(false);
            }
        }

        document.addEventListener(
            "mousedown",
            handleOutsideClick,
        );

        return () => {
            document.removeEventListener(
                "mousedown",
                handleOutsideClick,
            );
        };
    }, []);

    useEffect(() => {
        if (disabled) {
            setIsOpen(false);
        }
    }, [disabled]);

    function toggleOpen() {
        if (!disabled) {
            setIsOpen((current) => !current);
        }
    }

    function selectOption(optionValue: string) {
        onChange(optionValue);
        setIsOpen(false);
    }

    return (
        <div ref={containerRef}>
            <label className="mb-2 block text-sm font-medium">
                {label}
            </label>

            <div className="relative">
                <button
                    type="button"
                    disabled={disabled}
                    aria-haspopup="listbox"
                    aria-expanded={isOpen}
                    onClick={toggleOpen}
                    className="
                        flex
                        w-full
                        items-center
                        justify-between
                        gap-3
                        rounded-xl
                        border
                        border-[var(--color-border)]
                        bg-[var(--color-surface)]
                        px-4
                        py-3
                        text-left
                        outline-none
                        transition
                        hover:border-[var(--color-primary)]
                        focus:border-[var(--color-primary)]
                        focus:ring-2
                        focus:ring-[var(--color-primary)]/15
                        disabled:cursor-not-allowed
                        disabled:opacity-60
                    "
                >
                    <span
                        className={
                            selectedOption
                                ? "text-[var(--color-text)]"
                                : "text-[var(--color-text-muted)]"
                        }
                    >
                        {selectedOption?.label ??
                            placeholder}
                    </span>

                    <svg
                        viewBox="0 0 20 20"
                        fill="none"
                        aria-hidden="true"
                        className={`
                            h-5
                            w-5
                            shrink-0
                            text-[var(--color-text-muted)]
                            transition-transform
                            ${isOpen ? "rotate-180" : ""}
                        `}
                    >
                        <path
                            d="M5 7.5L10 12.5L15 7.5"
                            stroke="currentColor"
                            strokeWidth="1.8"
                            strokeLinecap="round"
                            strokeLinejoin="round"
                        />
                    </svg>
                </button>

                {isOpen && !disabled && (
                    <div
                        className="
                            absolute
                            left-0
                            right-0
                            z-50
                            mt-2
                            overflow-hidden
                            rounded-xl
                            border
                            border-[var(--color-border)]
                            bg-[var(--color-surface)]
                            shadow-lg
                        "
                    >
                        <div
                            role="listbox"
                            className="
                                custom-scrollbar
                                max-h-64
                                overflow-y-auto
                                overscroll-contain
                                p-1
                                pr-2
                            "
                        >
                            {options.length === 0 ? (
                                <p
                                    className="
                                        px-3
                                        py-2.5
                                        text-sm
                                        text-[var(--color-text-muted)]
                                    "
                                >
                                    No options available
                                </p>
                            ) : (
                                options.map((option) => {
                                    const isSelected =
                                        option.value ===
                                        value;

                                    return (
                                        <button
                                            key={
                                                option.value
                                            }
                                            type="button"
                                            role="option"
                                            aria-selected={
                                                isSelected
                                            }
                                            onClick={() =>
                                                selectOption(
                                                    option.value,
                                                )
                                            }
                                            className={`
                                                flex
                                                w-full
                                                items-center
                                                justify-between
                                                rounded-lg
                                                px-3
                                                py-2.5
                                                text-left
                                                text-sm
                                                transition
                                                ${
                                                isSelected
                                                    ? `
                                                            bg-[var(--color-surface-alt)]
                                                            font-medium
                                                            text-[var(--color-primary)]
                                                        `
                                                    : `
                                                            text-[var(--color-text)]
                                                            hover:bg-[var(--color-surface-alt)]
                                                        `
                                            }
                                            `}
                                        >
                                            <span>
                                                {
                                                    option.label
                                                }
                                            </span>

                                            {isSelected && (
                                                <span
                                                    aria-hidden="true"
                                                    className="
                                                        text-[var(--color-primary)]
                                                    "
                                                >
                                                    ✓
                                                </span>
                                            )}
                                        </button>
                                    );
                                })
                            )}
                        </div>
                    </div>
                )}
            </div>

            {error && (
                <p className="mt-1 text-sm text-[var(--color-error)]">
                    {error}
                </p>
            )}
        </div>
    );
}