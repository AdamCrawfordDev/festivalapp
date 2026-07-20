import {
    type ReactNode,
    useState,
} from "react";

type CollapsibleGroupProps = {
    title: string;
    children: ReactNode;
    defaultOpen?: boolean;
    headingLevel?: "h3" | "h4";
};

export default function CollapsibleGroup({
                                             title,
                                             children,
                                             defaultOpen = false,
                                             headingLevel = "h3",
                                         }: CollapsibleGroupProps) {
    const [isOpen, setIsOpen] =
        useState(defaultOpen);

    const Heading = headingLevel;

    const headingClasses =
        headingLevel === "h3"
            ? "font-heading text-2xl font-semibold"
            : "font-heading text-lg font-semibold";

    return (
        <section className="space-y-3">
            <Heading className={headingClasses}>
                <button
                    type="button"
                    onClick={() =>
                        setIsOpen((current) => !current)
                    }
                    aria-expanded={isOpen}
                    className="
                        block
                        w-full
                        cursor-pointer
                        rounded-xl
                        px-3
                        py-2
                        text-left
                        transition
                        hover:bg-[var(--color-surface-alt)]
                        hover:text-[var(--color-primary)]
                    "
                >
                    {title}
                </button>
            </Heading>

            {isOpen && (
                <div>
                    {children}
                </div>
            )}
        </section>
    );
}