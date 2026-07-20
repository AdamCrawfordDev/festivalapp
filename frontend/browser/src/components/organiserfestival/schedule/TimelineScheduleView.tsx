import {
    memo,
    useEffect,
    useMemo,
    useState,
} from "react";

import type { FestivalSet } from "../../../types/festival";
import {
    formatDayKey,
    formatTime,
    getFestivalDayKey,
    sortSetsByTime,
} from "../../organiserfestival/schedule/scheduleUtils";

type TimelineScheduleViewProps = {
    sets: FestivalSet[];
    onSetClick?: (set: FestivalSet) => void;
};

type PositionedSet = {
    set: FestivalSet;
    left: number;
    width: number;
    formattedTime: string;
};

type StageRowData = {
    stageName: string;
    sets: PositionedSet[];
};

type TimelineSetCardProps = {
    positionedSet: PositionedSet;
    onSetClick?: (set: FestivalSet) => void;
};

type TimelineStageRowProps = {
    stage: StageRowData;
    timelineWidth: number;
    onSetClick?: (set: FestivalSet) => void;
};

const HOUR_WIDTH = 100;
const STAGE_COLUMN_WIDTH = 150;
const ROW_HEIGHT = 74;
const SET_VERTICAL_GAP = 6;
const MIN_SET_WIDTH = 68;

function startOfHour(date: Date) {
    const result = new Date(date);

    result.setMinutes(0, 0, 0);

    return result;
}

function endOfHour(date: Date) {
    const result = new Date(date);

    if (
        result.getMinutes() !== 0 ||
        result.getSeconds() !== 0 ||
        result.getMilliseconds() !== 0
    ) {
        result.setHours(result.getHours() + 1);
    }

    result.setMinutes(0, 0, 0);

    return result;
}

function differenceInMinutes(
    first: Date,
    second: Date,
) {
    return (
        first.getTime() - second.getTime()
    ) / 60_000;
}

const TimelineSetCard = memo(
    function TimelineSetCard({
                                 positionedSet,
                                 onSetClick,
                             }: TimelineSetCardProps) {
        const {
            set,
            left,
            width,
            formattedTime,
        } = positionedSet;

        const isClickable = Boolean(onSetClick);

        return (
            <button
                type="button"
                disabled={!isClickable}
                onClick={() => onSetClick?.(set)}
                title={`${set.artist_name} · ${formattedTime}`}
                style={{
                    left,
                    width,
                    top: SET_VERTICAL_GAP,
                    height:
                        ROW_HEIGHT -
                        SET_VERTICAL_GAP * 2,
                }}
                className={`
                    absolute
                    isolate
                    overflow-hidden
                    rounded-lg
                    border
                    border-black/10
                    bg-[var(--color-primary)]
                    text-left
                    text-white
                    ${
                    isClickable
                        ? `
                                cursor-pointer
                                hover:brightness-110
                                focus-visible:outline-none
                                focus-visible:ring-2
                                focus-visible:ring-[var(--color-primary)]
                                focus-visible:ring-offset-1
                            `
                        : `
                                cursor-default
                            `
                }
                `}
            >
                {set.image && (
                    <img
                        src={set.image}
                        alt=""
                        loading="lazy"
                        decoding="async"
                        draggable={false}
                        className="
                            pointer-events-none
                            absolute
                            inset-0
                            h-full
                            w-full
                            select-none
                            object-cover
                        "
                    />
                )}

                <div
                    className={`
                        pointer-events-none
                        absolute
                        inset-0
                        ${
                        set.image
                            ? `
                                    bg-gradient-to-r
                                    from-black/80
                                    via-black/45
                                    to-black/20
                                `
                            : `
                                    bg-[var(--color-primary)]
                                `
                    }
                    `}
                />

                <div
                    className="
                        pointer-events-none
                        relative
                        z-10
                        flex
                        h-full
                        min-w-0
                        flex-col
                        justify-end
                        px-2.5
                        py-2
                    "
                >
                    <p
                        className="
                            truncate
                            font-heading
                            text-xs
                            font-semibold
                        "
                    >
                        {set.artist_name}
                    </p>

                    <p
                        className="
                            mt-0.5
                            truncate
                            text-[10px]
                            text-white/80
                        "
                    >
                        {formattedTime}
                    </p>
                </div>
            </button>
        );
    },
);

const TimelineStageRow = memo(
    function TimelineStageRow({
                                  stage,
                                  timelineWidth,
                                  onSetClick,
                              }: TimelineStageRowProps) {
        return (
            <div
                style={{
                    height: ROW_HEIGHT,
                }}
                className="
                    flex
                    border-b
                    border-[var(--color-border)]
                    last:border-b-0
                "
            >
                <div
                    style={{
                        width: STAGE_COLUMN_WIDTH,
                    }}
                    className="
                        sticky
                        left-0
                        z-20
                        flex
                        shrink-0
                        items-center
                        border-r
                        border-[var(--color-border)]
                        bg-[var(--color-surface)]
                        px-4
                    "
                >
                    <span
                        className="
                            line-clamp-2
                            font-heading
                            text-sm
                            font-semibold
                            text-[var(--color-text)]
                        "
                    >
                        {stage.stageName}
                    </span>
                </div>

                <div
                    style={{
                        width: timelineWidth,
                        backgroundImage: `
                            repeating-linear-gradient(
                                to right,
                                transparent 0,
                                transparent ${
                            HOUR_WIDTH - 1
                        }px,
                                var(--color-border) ${
                            HOUR_WIDTH - 1
                        }px,
                                var(--color-border) ${HOUR_WIDTH}px
                            )
                        `,
                    }}
                    className="
                        relative
                        shrink-0
                        bg-[var(--color-background)]
                    "
                >
                    {stage.sets.map(
                        (positionedSet) => (
                            <TimelineSetCard
                                key={
                                    positionedSet.set.id
                                }
                                positionedSet={
                                    positionedSet
                                }
                                onSetClick={
                                    onSetClick
                                }
                            />
                        ),
                    )}
                </div>
            </div>
        );
    },
);

export default function TimelineScheduleView({
                                                 sets,
                                                 onSetClick,
                                             }: TimelineScheduleViewProps) {
    const orderedSets = useMemo(
        () => sortSetsByTime(sets),
        [sets],
    );

    const setsByDay = useMemo(() => {
        const grouped = new Map<
            string,
            FestivalSet[]
        >();

        for (const set of orderedSets) {
            const dayKey = getFestivalDayKey(
                set.start_time,
            );

            const existing = grouped.get(dayKey);

            if (existing) {
                existing.push(set);
            } else {
                grouped.set(dayKey, [set]);
            }
        }

        return grouped;
    }, [orderedSets]);

    const availableDays = useMemo(
        () =>
            Array.from(
                setsByDay.keys(),
            ).sort(),
        [setsByDay],
    );

    const [selectedDay, setSelectedDay] =
        useState(availableDays[0] ?? "");

    useEffect(() => {
        if (
            availableDays.length > 0 &&
            !availableDays.includes(selectedDay)
        ) {
            setSelectedDay(availableDays[0]);
        }
    }, [availableDays, selectedDay]);

    const daySets =
        setsByDay.get(selectedDay) ?? [];

    const timeline = useMemo(() => {
        if (daySets.length === 0) {
            return null;
        }

        let earliestStart =
            Number.POSITIVE_INFINITY;

        let latestEnd =
            Number.NEGATIVE_INFINITY;

        const parsedSets = daySets.map(
            (set) => {
                const startTimestamp =
                    Date.parse(set.start_time);

                const endTimestamp =
                    Date.parse(set.end_time);

                earliestStart = Math.min(
                    earliestStart,
                    startTimestamp,
                );

                latestEnd = Math.max(
                    latestEnd,
                    endTimestamp,
                );

                return {
                    set,
                    startTimestamp,
                    endTimestamp,
                };
            },
        );

        const timelineStart = startOfHour(
            new Date(earliestStart),
        );

        const timelineEnd = endOfHour(
            new Date(latestEnd),
        );

        const totalMinutes =
            differenceInMinutes(
                timelineEnd,
                timelineStart,
            );

        const timelineWidth =
            (totalMinutes / 60) * HOUR_WIDTH;

        const stageMap = new Map<
            string,
            PositionedSet[]
        >();

        for (const parsedSet of parsedSets) {
            const start = new Date(
                parsedSet.startTimestamp,
            );

            const end = new Date(
                parsedSet.endTimestamp,
            );

            const left =
                (differenceInMinutes(
                        start,
                        timelineStart,
                    ) /
                    60) *
                HOUR_WIDTH +
                2;

            const calculatedWidth =
                (differenceInMinutes(
                        end,
                        start,
                    ) /
                    60) *
                HOUR_WIDTH;

            const positionedSet: PositionedSet =
                {
                    set: parsedSet.set,
                    left,
                    width: Math.max(
                        calculatedWidth - 4,
                        MIN_SET_WIDTH,
                    ),
                    formattedTime: `${formatTime(
                        parsedSet.set.start_time,
                    )} – ${formatTime(
                        parsedSet.set.end_time,
                    )}`,
                };

            const stageName =
                parsedSet.set.stage_name;

            const existing =
                stageMap.get(stageName);

            if (existing) {
                existing.push(positionedSet);
            } else {
                stageMap.set(stageName, [
                    positionedSet,
                ]);
            }
        }

        const stages: StageRowData[] =
            Array.from(stageMap.entries())
                .sort(([first], [second]) =>
                    first.localeCompare(second),
                )
                .map(
                    ([
                         stageName,
                         positionedSets,
                     ]) => ({
                        stageName,
                        sets: positionedSets,
                    }),
                );

        const hourMarkers: Date[] = [];
        const current = new Date(
            timelineStart,
        );

        while (current <= timelineEnd) {
            hourMarkers.push(
                new Date(current),
            );

            current.setHours(
                current.getHours() + 1,
            );
        }

        return {
            stages,
            timelineWidth,
            hourMarkers,
        };
    }, [daySets]);

    if (
        availableDays.length === 0 ||
        !timeline
    ) {
        return null;
    }

    return (
        <section className="space-y-3">
            <div
                className="
                    custom-scrollbar
                    flex
                    max-w-full
                    gap-1
                    overflow-x-auto
                "
            >
                {availableDays.map((dayKey) => {
                    const isSelected =
                        selectedDay === dayKey;

                    return (
                        <button
                            key={dayKey}
                            type="button"
                            onClick={() =>
                                setSelectedDay(dayKey)
                            }
                            className={`
                                shrink-0
                                rounded-lg
                                px-3
                                py-1.5
                                text-sm
                                font-medium
                                ${
                                isSelected
                                    ? `
                                            bg-[var(--color-primary)]
                                            text-white
                                        `
                                    : `
                                            text-[var(--color-text-muted)]
                                            hover:bg-[var(--color-surface)]
                                            hover:text-[var(--color-text)]
                                        `
                            }
                            `}
                        >
                            {formatDayKey(dayKey)}
                        </button>
                    );
                })}
            </div>

            <div
                className="
                    overflow-hidden
                    rounded-xl
                    border
                    border-[var(--color-border)]
                    bg-[var(--color-surface)]
                "
            >
                <div
                    className="
                        custom-scrollbar
                        overflow-x-auto
                        overscroll-x-contain
                    "
                >
                    <div
                        style={{
                            width:
                                STAGE_COLUMN_WIDTH +
                                timeline.timelineWidth,
                            minWidth: "100%",
                        }}
                    >
                        <div
                            className="
                                sticky
                                top-0
                                z-30
                                flex
                                border-b
                                border-[var(--color-border)]
                                bg-[var(--color-surface)]
                            "
                        >
                            <div
                                style={{
                                    width:
                                    STAGE_COLUMN_WIDTH,
                                }}
                                className="
                                    sticky
                                    left-0
                                    z-40
                                    flex
                                    h-11
                                    shrink-0
                                    items-center
                                    border-r
                                    border-[var(--color-border)]
                                    bg-[var(--color-surface)]
                                    px-4
                                    text-xs
                                    font-semibold
                                    uppercase
                                    tracking-wide
                                    text-[var(--color-text-muted)]
                                "
                            >
                                Stage
                            </div>

                            <div
                                style={{
                                    width:
                                    timeline.timelineWidth,
                                }}
                                className="
                                    relative
                                    h-11
                                    shrink-0
                                "
                            >
                                {timeline.hourMarkers.map(
                                    (marker, index) => (
                                        <div
                                            key={
                                                marker.toISOString()
                                            }
                                            style={{
                                                left:
                                                    index *
                                                    HOUR_WIDTH,
                                                width:
                                                HOUR_WIDTH,
                                            }}
                                            className="
                                                absolute
                                                inset-y-0
                                                flex
                                                items-center
                                                border-r
                                                border-[var(--color-border)]
                                                px-3
                                                text-xs
                                                font-medium
                                                text-[var(--color-text-muted)]
                                            "
                                        >
                                            {formatTime(
                                                marker.toISOString(),
                                            )}
                                        </div>
                                    ),
                                )}
                            </div>
                        </div>

                        {timeline.stages.map(
                            (stage) => (
                                <TimelineStageRow
                                    key={
                                        stage.stageName
                                    }
                                    stage={stage}
                                    timelineWidth={
                                        timeline.timelineWidth
                                    }
                                    onSetClick={
                                        onSetClick
                                    }
                                />
                            ),
                        )}
                    </div>
                </div>
            </div>
        </section>
    );
}