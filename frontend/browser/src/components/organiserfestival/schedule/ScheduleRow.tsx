import type {FestivalSet} from "../../../types/festival";
import {formatTime} from "./scheduleUtils";

type ScheduleRowProps = {
    set: FestivalSet;
    showStage: boolean;
    hasBorder: boolean;
    onEdit: (set: FestivalSet) => void;
};

export default function ScheduleRow({
                                        set,
                                        showStage,
                                        hasBorder,
                                        onEdit,
                                    }: ScheduleRowProps) {
    return (
        <button
            type="button"
            onClick={() => onEdit(set)}
            aria-label={`Edit ${set.artist_name}'s set`}
            className={`
                group
                grid
                w-full
                cursor-pointer
                gap-3
                px-5
                py-4
                text-left
                transition
                hover:bg-[var(--color-surface-alt)]
                focus-visible:outline-none
                focus-visible:ring-2
                focus-visible:ring-inset
                focus-visible:ring-[var(--color-primary)]
                sm:items-center
                ${
                showStage
                    ? "sm:grid-cols-[150px_1fr_auto]"
                    : "sm:grid-cols-[150px_1fr_auto]"
            }
                ${
                hasBorder
                    ? "border-b border-[var(--color-border)]"
                    : ""
            }
            `}
        >
            <p className="font-medium">
                {formatTime(set.start_time)}
                {" – "}
                {formatTime(set.end_time)}
            </p>

            <div>
                <h4
                    className="
                        font-heading
                        text-lg
                        font-semibold
                        transition
                        group-hover:text-[var(--color-primary)]
                    "
                >
                    {set.artist_name}
                </h4>


            </div>

            <div className="flex items-center justify-end gap-3">
                {showStage && (
                    <p
                        className="
                            text-sm
                            text-[var(--color-text-muted)]
                        "
                    >
                        {set.stage_name}
                    </p>
                )}

                <svg
                    viewBox="0 0 20 20"
                    fill="none"
                    aria-hidden="true"
                    className="
                        h-5
                        w-5
                        shrink-0
                        text-[var(--color-text-muted)]
                        opacity-40
                        transition
                        group-hover:text-[var(--color-primary)]
                        group-hover:opacity-100
                        group-focus-visible:opacity-100
                    "
                >
                    <path
                        d="M4 13.75V16h2.25L14.6 7.65l-2.25-2.25L4 13.75Z"
                        stroke="currentColor"
                        strokeWidth="1.6"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                    />

                    <path
                        d="m11.75 6 2.25 2.25"
                        stroke="currentColor"
                        strokeWidth="1.6"
                        strokeLinecap="round"
                    />
                </svg>
            </div>
        </button>
    );
}