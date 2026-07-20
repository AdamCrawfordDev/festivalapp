type FestivalCardProps = {
    name: string;
    description: string;
    startDate: string;
    endDate: string;
    image: string | null;
    organiserName: string;
    organiserProfilePicture: string | null;
    onClick: () => void;
};

function formatFestivalDates(
    startDate: string,
    endDate: string,
) {
    const start = new Date(startDate);
    const end = new Date(endDate);

    const startLabel = start.toLocaleDateString(
        "en-GB",
        {
            day: "numeric",
            month: "short",
        },
    );

    const endLabel = end.toLocaleDateString(
        "en-GB",
        {
            day: "numeric",
            month: "short",
            year: "numeric",
        },
    );

    return `${startLabel} – ${endLabel}`;
}

export default function FestivalCard({
                                         name,
                                         description,
                                         startDate,
                                         endDate,
                                         image,
                                         organiserName,
                                         organiserProfilePicture,
                                         onClick,
                                     }: FestivalCardProps) {
    const festivalInitial =
        name.trim().charAt(0).toUpperCase() || "F";

    const organiserInitial =
        organiserName
            .trim()
            .charAt(0)
            .toUpperCase() || "O";

    return (
        <button
            type="button"
            onClick={onClick}
            className="
                group
                w-full
                overflow-hidden
                rounded-xl
                border
                border-[var(--color-border)]
                bg-[var(--color-surface)]
                text-left
                shadow-sm
                transition
                hover:border-[var(--color-primary)]
                hover:shadow-lg
                focus-visible:outline-none
                focus-visible:ring-2
                focus-visible:ring-[var(--color-primary)]
            "
        >
            <div
                className="
                    relative
                    h-56
                    w-full
                    overflow-hidden
                    bg-[var(--color-surface-alt)]
                "
            >
                {image ? (
                    <img
                        src={image}
                        alt=""
                        className="
                            h-full
                            w-full
                            object-cover
                            transition-transform
                            duration-300
                            group-hover:scale-[1.02]
                        "
                    />
                ) : (
                    <div
                        className="
                            flex
                            h-full
                            w-full
                            items-center
                            justify-center
                            font-heading
                            text-5xl
                            font-semibold
                            text-[var(--color-primary)]
                        "
                    >
                        {festivalInitial}
                    </div>
                )}

                <div
                    className="
                        absolute
                        inset-0
                        bg-gradient-to-t
                        from-black/75
                        via-black/20
                        to-transparent
                    "
                />

                <div
                    className="
                        absolute
                        inset-x-0
                        bottom-0
                        p-6
                        text-white
                    "
                >
                    <h2
                        className="
                            truncate
                            font-heading
                            text-2xl
                            font-semibold
                        "
                    >
                        {name}
                    </h2>

                    <div
                        className="
                            mt-2
                            flex
                            min-w-0
                            items-center
                            gap-2
                            text-sm
                            text-white/85
                        "
                    >
                        {organiserProfilePicture ? (
                            <img
                                src={
                                    organiserProfilePicture
                                }
                                alt=""
                                className="
                                    h-7
                                    w-7
                                    shrink-0
                                    rounded-full
                                    object-cover
                                    ring-1
                                    ring-white/40
                                "
                            />
                        ) : (
                            <span
                                className="
                                    flex
                                    h-7
                                    w-7
                                    shrink-0
                                    items-center
                                    justify-center
                                    rounded-full
                                    bg-white/20
                                    text-xs
                                    font-semibold
                                    ring-1
                                    ring-white/30
                                "
                            >
                                {organiserInitial}
                            </span>
                        )}

                        <span className="truncate">
                            {organiserName}
                        </span>

                        <span aria-hidden="true">
                            •
                        </span>

                        <span className="shrink-0">
                            {formatFestivalDates(
                                startDate,
                                endDate,
                            )}
                        </span>
                    </div>
                </div>
            </div>

            {description && (
                <div className="px-6 py-4">
                    <p
                        className="
                            line-clamp-2
                            text-sm
                            leading-6
                            text-[var(--color-text-muted)]
                        "
                    >
                        {description}
                    </p>
                </div>
            )}
        </button>
    );
}