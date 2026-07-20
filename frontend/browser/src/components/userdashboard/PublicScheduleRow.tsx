import { formatTime } from
    "../organiserfestival/schedule/scheduleUtils";

import type {
    FestivalSet,
} from "../../types/festival";

import {
    useToggleSetLike,
} from "../../features/festivals/hooks/useToggleSetLike";

type PublicScheduleRowProps = {
    set: FestivalSet;
    festivalId: number;
    showStage: boolean;
    hasBorder: boolean;
};

export default function PublicScheduleRow({
    set,
    festivalId,
    showStage,
    hasBorder,
}: PublicScheduleRowProps) {
    const toggleLike =
        useToggleSetLike(festivalId);

    const handleLike = () => {
        toggleLike.mutate(set.id);
    };

    const image = set.image ?? null;

    return (
        <article
            className={`
grid
grid-cols-[56px_1fr_auto]
items-center
gap-4
px-4
py-3
sm:grid-cols-[130px_56px_1fr_auto]
${
    hasBorder
        ? `
                            border-b
                            border-[var(--color-border)]
                        `
        : ""
}
`}
        >
            <p
                className="
                    hidden
                    whitespace-nowrap
                    text-sm
                    font-medium
                    text-[var(--color-text-muted)]
                    sm:block
                "
            >
                {formatTime(set.start_time)}
                {" – "}
                {formatTime(set.end_time)}
            </p>

            <div
                className="
                    h-14
                    w-14
                    overflow-hidden
                    rounded-lg
                    bg-[var(--color-background)]
                "
            >
                {image ? (
                    <img
                        src={image}
                        alt={set.artist_name}
                        loading="lazy"
                        decoding="async"
                        className="
                            h-full
                            w-full
                            object-cover
                        "
                    />
                ) : (
                    <div
                        className="
                            h-full
                            w-full
                            bg-[var(--color-primary)]/10
                        "
                    />
                )}
            </div>

            <div className="min-w-0">
                <h4
                    className="
                        truncate
                        font-heading
                        font-semibold
                        text-[var(--color-text)]
                    "
                >
                    {set.artist_name}
                </h4>

                <p
                    className="
                        mt-0.5
                        truncate
                        text-sm
                        text-[var(--color-text-muted)]
                    "
                >
                    <span className="sm:hidden">
                        {formatTime(
                            set.start_time,
                        )}
                        {" – "}
                        {formatTime(
                            set.end_time,
                        )}
                    </span>

                    {showStage && (
                        <>
                            <span className="sm:hidden">
                                {" · "}
                            </span>

                            <span>
                                {set.stage_name}
                            </span>
                        </>
                    )}
                </p>
            </div>

            <button
                type="button"
                onClick={handleLike}
                aria-label={
                    set.is_liked
                        ? `Unlike ${set.artist_name}`
                        : `Like ${set.artist_name}`
                }
                aria-pressed={set.is_liked}
                className={`
flex
h-10
w-10
items-center
justify-center
rounded-full
transition
focus-visible:outline-none
focus-visible:ring-1
focus-visible:ring-[var(--color-primary)]
${
    set.is_liked
        ? `
                                bg-[var(--color-primary)]/10
                                text-[var(--color-primary)]
                            `
        : `
                                text-[var(--color-text-muted)]
                                hover:bg-[var(--color-background)]
                                hover:text-[var(--color-primary)]
                            `
}
`}
            >
                <svg
                    viewBox="0 0 24 24"
                    aria-hidden="true"
                    className="h-5 w-5"
                    fill={
                        set.is_liked
                            ? "currentColor"
                            : "none"
                    }
                    stroke="currentColor"
                    strokeWidth="1.8"
                >
                    <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        d="
                            M20.84 4.61
                            a5.5 5.5 0 0 0-7.78 0
                            L12 5.67
                            l-1.06-1.06
                            a5.5 5.5 0 0 0-7.78 7.78
                            L12 21.23
                            l8.84-8.84
                            a5.5 5.5 0 0 0 0-7.78
                            Z
                        "
                    />
                </svg>
            </button>
        </article>
    );
}
