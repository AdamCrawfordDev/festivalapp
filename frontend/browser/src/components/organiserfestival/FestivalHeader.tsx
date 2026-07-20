type FestivalHeaderData = {
    name: string;
    description: string;
    start_date: string;
    end_date: string;
    image: string | null;
};

type FestivalHeaderProps = {
    festival: FestivalHeaderData;
};

export default function FestivalHeader({
                                           festival,
                                       }: FestivalHeaderProps) {
    const formattedDates = `${new Date(
        festival.start_date,
    ).toLocaleDateString("en-GB", {
        day: "numeric",
        month: "long",
        year: "numeric",
    })} – ${new Date(
        festival.end_date,
    ).toLocaleDateString("en-GB", {
        day: "numeric",
        month: "long",
        year: "numeric",
    })}`;

    return (
        <header
            className="
                grid
                gap-8
                px-10
                pt-10
                lg:grid-cols-[1fr_420px]
                lg:items-center
            "
        >
            <div>
                <p className="text-sm font-medium text-[var(--color-primary)]">
                    {formattedDates}
                </p>

                <h1
                    className="
                        mt-3
                        font-heading
                        text-4xl
                        font-semibold
                        sm:text-5xl
                    "
                >
                    {festival.name}
                </h1>

                {festival.description && (
                    <p
                        className="
                            mt-4
                            max-w-2xl
                            leading-7
                            text-[var(--color-text-muted)]
                        "
                    >
                        {festival.description}
                    </p>
                )}
            </div>

            {festival.image && (
                <div
                    className="
                        h-72
                        overflow-hidden
                        rounded-2xl
                        bg-[var(--color-surface-alt)]
                    "
                >
                    <img
                        src={festival.image}
                        alt={festival.name}
                        className="
                            h-full
                            w-full
                            object-cover
                        "
                    />
                </div>
            )}
        </header>
    );
}