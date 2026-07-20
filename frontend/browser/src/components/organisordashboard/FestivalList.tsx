import { useNavigate } from "react-router-dom";

import { useAuth } from "../../features/auth/hooks/useCurrentUser";
import { useFestivals } from "../../features/festivals/hooks/useFestivals";

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

export default function FestivalList() {
    const navigate = useNavigate();
    const festivalsQuery = useFestivals();

    const {
        user,
        isLoading: isUserLoading,
    } = useAuth();

    if (
        festivalsQuery.isPending ||
        isUserLoading
    ) {
        return <p>Loading festivals...</p>;
    }

    if (festivalsQuery.isError) {
        return <p>Unable to load festivals.</p>;
    }

    const organiserName =
        user?.display_name?.trim() ||
        user?.username?.trim() ||
        "Organiser";

    const organiserInitial = organiserName
        .charAt(0)
        .toUpperCase();

    return (
        <div className="space-y-6">
            {festivalsQuery.data.map((festival) => (
                <button
                    key={festival.id}
                    type="button"
                    onClick={() =>
                        navigate(
                            `/organiser/festivals/${festival.id}`,
                        )
                    }
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
                        {festival.image ? (
                            <img
                                src={festival.image}
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
                                {festival.name
                                    .charAt(0)
                                    .toUpperCase()}
                            </div>
                        )}

                        <div
                            className="
                                absolute
                                inset-0
                                bg-gradient-to-t
                                from-black/70
                                via-black/20
                                to-transparent
                            "
                        />

                        <div
                            className="
                                absolute
                                inset-x-0
                                bottom-0
                                flex
                                items-end
                                justify-between
                                gap-4
                                p-6
                                text-white
                            "
                        >
                            <div className="min-w-0">
                                <h2
                                    className="
                                        truncate
                                        font-heading
                                        text-2xl
                                        font-semibold
                                    "
                                >
                                    {festival.name}
                                </h2>

                                <div
                                    className="
                                        mt-2
                                        flex
                                        items-center
                                        gap-2
                                        text-sm
                                        text-white/85
                                    "
                                >
                                    {user?.profile_picture ? (
                                        <img
                                            src={
                                                user.profile_picture
                                            }
                                            alt=""
                                            className="
                                                h-7
                                                w-7
                                                rounded-full
                                                object-cover
                                                ring-1
                                                ring-white/40
                                            "
                                        />
                                    ) : (
                                        <div
                                            className="
                                                flex
                                                h-7
                                                w-7
                                                items-center
                                                justify-center
                                                rounded-full
                                                bg-white/20
                                                text-xs
                                                font-semibold
                                                text-white
                                                ring-1
                                                ring-white/30
                                            "
                                        >
                                            {organiserInitial}
                                        </div>
                                    )}

                                    <span className="truncate">
                                        {organiserName}
                                    </span>

                                    <span>•</span>

                                    <span className="shrink-0">
                                        {formatFestivalDates(
                                            festival.start_date,
                                            festival.end_date,
                                        )}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    {festival.description && (
                        <div className="px-6 py-4">
                            <p
                                className="
                                    line-clamp-2
                                    text-sm
                                    leading-6
                                    text-[var(--color-text-muted)]
                                "
                            >
                                {festival.description}
                            </p>
                        </div>
                    )}
                </button>
            ))}
        </div>
    );
}