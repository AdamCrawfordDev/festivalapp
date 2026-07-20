type EmptyScheduleStateProps = {
    title: string;
    description: string;
};

export default function EmptyScheduleState({
                                               title,
                                               description,
                                           }: EmptyScheduleStateProps) {
    return (
        <div
            className="
                rounded-xl
                border
                border-[var(--color-border)]
                bg-[var(--color-surface)]
                p-8
                text-center
            "
        >
            <h3 className="font-heading text-xl">
                {title}
            </h3>

            <p
                className="
                    mt-2
                    text-[var(--color-text-muted)]
                "
            >
                {description}
            </p>
        </div>
    );
}