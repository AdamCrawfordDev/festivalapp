import {
    memo,
    useCallback,
    useEffect,
    useLayoutEffect,
    useMemo,
    useRef,
    useState,
} from "react";

import type {
    FestivalSet,
} from "../../types/festival";

import {
    useToggleSetLike,
} from "../../features/festivals/hooks/useToggleSetLike";

import {
    formatDayKey,
    formatTime,
    getFestivalDayKey,
    sortSetsByTime,
} from "../organiserfestival/schedule/scheduleUtils";

type PublicTimelineScheduleViewProps = {
    sets: FestivalSet[];
    festivalId: number;

    /*
     * This can open a modal, drawer or details page.
     * It is optional so the component still works
     * before the details view has been built.
     */
    onOpenSet?: (
        set: FestivalSet,
    ) => void;
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
    isPending: boolean;
    onOpenSet?: (
        set: FestivalSet,
    ) => void;
    onToggleLike: (
        setId: number,
    ) => void;
};

type TimelineStageRowProps = {
    stage: StageRowData;
    timelineWidth: number;
    hourWidth: number;
    pendingSetId?: number;
    onOpenSet?: (
        set: FestivalSet,
    ) => void;
    onToggleLike: (
        setId: number,
    ) => void;
};

type ZoomAnchor = {
    viewportX: number;
    timelinePosition: number;
};

/*
 * Timeline geometry
 */
const BASE_HOUR_WIDTH = 100;

const MIN_ZOOM = 0.5;
const MAX_ZOOM = 4;
const ZOOM_STEP = 0.25;
const DEFAULT_ZOOM = 1;

const STAGE_COLUMN_WIDTH = 150;

const ROW_HEIGHT = 76;
const SET_VERTICAL_GAP = 7;

/*
 * A slightly larger minimum prevents the fixed-size
 * heart from completely consuming very narrow cards.
 */
const MIN_SET_WIDTH = 94;

/*
 * Time remains the same font size at every zoom level.
 * It is only hidden when there is not enough room.
 */
const MIN_WIDTH_FOR_TIME = 132;

/*
 * Zoom behaviour
 */
const WHEEL_ZOOM_SENSITIVITY = 0.0018;
const PINCH_ZOOM_SENSITIVITY = 0.006;

const ZOOM_EASING = 0.35;
const ZOOM_FINISH_THRESHOLD = 0.001;

const GESTURE_END_DELAY = 140;

function startOfHour(
    date: Date,
) {
    const result =
        new Date(date);

    result.setMinutes(
        0,
        0,
        0,
    );

    return result;
}

function endOfHour(
    date: Date,
) {
    const result =
        new Date(date);

    const isExactlyOnHour =
        result.getMinutes() === 0 &&
        result.getSeconds() === 0 &&
        result.getMilliseconds() === 0;

    if (!isExactlyOnHour) {
        result.setHours(
            result.getHours() + 1,
        );
    }

    result.setMinutes(
        0,
        0,
        0,
    );

    return result;
}

function differenceInMinutes(
    first: Date,
    second: Date,
) {
    return (
        first.getTime() -
        second.getTime()
    ) / 60_000;
}

function clampZoom(
    zoom: number,
) {
    return Math.min(
        MAX_ZOOM,
        Math.max(
            MIN_ZOOM,
            zoom,
        ),
    );
}

function normaliseWheelDelta(
    event: WheelEvent,
) {
    let delta =
        Math.abs(event.deltaY) >=
        Math.abs(event.deltaX)
            ? event.deltaY
            : event.deltaX;

    if (event.deltaMode === 1) {
        delta *= 16;
    }

    if (event.deltaMode === 2) {
        delta *= window.innerHeight;
    }

    return delta;
}

const HeartIcon = memo(
    function HeartIcon({
                           filled,
                       }: {
        filled: boolean;
    }) {
        return (
            <svg
                viewBox="0 0 24 24"
                aria-hidden="true"
                className="
                    h-5
                    w-5
                    shrink-0
                "
                fill={
                    filled
                        ? "currentColor"
                        : "none"
                }
                stroke="currentColor"
                strokeWidth="2"
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
        );
    },
);

const TimelineSetCard = memo(
    function TimelineSetCard({
                                 positionedSet,
                                 isPending,
                                 onOpenSet,
                                 onToggleLike,
                             }: TimelineSetCardProps) {
        const {
            set,
            left,
            width,
            formattedTime,
        } = positionedSet;

        const image =
            set.image ?? null;

        const showTime =
            width >=
            MIN_WIDTH_FOR_TIME;

        const handleOpenSet =
            useCallback(() => {
                if (onOpenSet) {
                    onOpenSet(set);
                    return;
                }

                /*
                 * Temporary fallback until the
                 * details view is connected.
                 */
                console.log(
                    "Open set details:",
                    set.id,
                );
            }, [
                onOpenSet,
                set,
            ]);

        const handleToggleLike =
            useCallback(() => {
                if (isPending) {
                    return;
                }

                onToggleLike(
                    set.id,
                );
            }, [
                isPending,
                onToggleLike,
                set.id,
            ]);

        return (
            <article
                style={{
                    left,
                    width,
                    top:
                    SET_VERTICAL_GAP,
                    height:
                        ROW_HEIGHT -
                        SET_VERTICAL_GAP *
                        2,
                }}
                className="
                    group
                    absolute
                    isolate
                    overflow-hidden
                    rounded-lg
                    text-white
                "
            >
                <button
                    type="button"
                    onClick={
                        handleOpenSet
                    }
                    aria-label={
                        `View details for ${set.artist_name}`
                    }
                    className={`
                        absolute
                        inset-0
                        z-0
                        overflow-hidden
                        rounded-lg
                        border
                        text-left
                        transition-[filter,box-shadow,border-color]
                        hover:brightness-110
                        focus-visible:z-10
                        focus-visible:outline-none
                        focus-visible:ring-2
                        focus-visible:ring-[var(--color-primary)]
                        focus-visible:ring-offset-1
                        ${
                        set.is_liked
                            ? `
                                    border-[var(--color-primary)]
                                    shadow-sm
                                    shadow-[var(--color-primary)]/30
                                `
                            : `
                                    border-black/10
                                `
                    }
                    `}
                >
                    {image && (
                        <img
                            src={image}
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

                    <span
                        className={`
                            pointer-events-none
                            absolute
                            inset-0
                            ${
                            image
                                ? `
                                        bg-gradient-to-r
                                        from-black/90
                                        via-black/60
                                        to-black/25
                                    `
                                : `
                                        bg-[var(--color-primary)]
                                    `
                        }
                        `}
                    />

                    <span
                        className="
                            pointer-events-none
                            relative
                            z-10
                            flex
                            h-full
                            min-w-0
                            flex-col
                            justify-center
                            px-2.5
                            pr-13
                        "
                    >
                        <span
                            className="
                                block
                                truncate
                                font-heading
                                text-xs
                                font-semibold
                                leading-tight
                            "
                        >
                            {
                                set.artist_name
                            }
                        </span>

                        {showTime && (
                            <span
                                className="
                                    mt-1
                                    block
                                    truncate
                                    text-[10px]
                                    font-medium
                                    leading-none
                                    text-white/80
                                "
                            >
                                {
                                    formattedTime
                                }
                            </span>
                        )}
                    </span>
                </button>

                <button
                    type="button"
                    onClick={
                        handleToggleLike
                    }
                    disabled={
                        isPending
                    }
                    aria-label={
                        set.is_liked
                            ? `Remove ${set.artist_name} from your schedule`
                            : `Add ${set.artist_name} to your schedule`
                    }
                    aria-pressed={
                        set.is_liked
                    }
                    title={
                        set.is_liked
                            ? "Remove from schedule"
                            : "Add to schedule"
                    }
                    className={`
                        absolute
                        right-2
                        top-1/2
                        z-20
                        flex
                        h-9
                        w-9
                        -translate-y-1/2
                        items-center
                        justify-center
                        rounded-full
                        border
                        backdrop-blur-md
                        transition-[background-color,border-color,opacity,transform]
                        hover:scale-105
                        active:scale-95
                        focus-visible:outline-none
                        focus-visible:ring-2
                        focus-visible:ring-white
                        disabled:cursor-default
                        disabled:opacity-65
                        disabled:hover:scale-100
                        ${
                        set.is_liked
                            ? `
                                    border-white/40
                                    bg-[var(--color-primary)]
                                    text-white
                                `
                            : `
                                    border-white/25
                                    bg-black/45
                                    text-white
                                    hover:bg-black/65
                                `
                    }
                    `}
                >
                    <HeartIcon
                        filled={
                            set.is_liked
                        }
                    />
                </button>
            </article>
        );
    },
);

const TimelineStageRow = memo(
    function TimelineStageRow({
                                  stage,
                                  timelineWidth,
                                  hourWidth,
                                  pendingSetId,
                                  onOpenSet,
                                  onToggleLike,
                              }: TimelineStageRowProps) {
        return (
            <div
                style={{
                    height:
                    ROW_HEIGHT,
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
                        width:
                        STAGE_COLUMN_WIDTH,
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
                            leading-tight
                            text-[var(--color-text)]
                        "
                    >
                        {
                            stage.stageName
                        }
                    </span>
                </div>

                <div
                    style={{
                        width:
                        timelineWidth,
                        backgroundImage: `
                            repeating-linear-gradient(
                                to right,
                                transparent 0,
                                transparent ${
                            hourWidth - 1
                        }px,
                                var(--color-border) ${
                            hourWidth - 1
                        }px,
                                var(--color-border) ${hourWidth}px
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
                        (
                            positionedSet,
                        ) => (
                            <TimelineSetCard
                                key={
                                    positionedSet
                                        .set
                                        .id
                                }
                                positionedSet={
                                    positionedSet
                                }
                                isPending={
                                    pendingSetId ===
                                    positionedSet
                                        .set
                                        .id
                                }
                                onOpenSet={
                                    onOpenSet
                                }
                                onToggleLike={
                                    onToggleLike
                                }
                            />
                        ),
                    )}
                </div>
            </div>
        );
    },
);

export default function PublicTimelineScheduleView({
                                                       sets,
                                                       festivalId,
                                                       onOpenSet,
                                                   }: PublicTimelineScheduleViewProps) {
    const toggleLike =
        useToggleSetLike(
            festivalId,
        );

    const scrollContainerRef =
        useRef<HTMLDivElement>(
            null,
        );

    const zoomRef =
        useRef(
            DEFAULT_ZOOM,
        );

    const targetZoomRef =
        useRef(
            DEFAULT_ZOOM,
        );

    const zoomAnchorRef =
        useRef<ZoomAnchor | null>(
            null,
        );

    const animationFrameRef =
        useRef<number | null>(
            null,
        );

    const gestureEndTimerRef =
        useRef<number | null>(
            null,
        );

    const pendingScrollLeftRef =
        useRef<number | null>(
            null,
        );

    const [
        zoom,
        setZoom,
    ] = useState(
        DEFAULT_ZOOM,
    );

    const hourWidth =
        BASE_HOUR_WIDTH *
        zoom;

    useEffect(() => {
        zoomRef.current =
            zoom;
    }, [zoom]);

    useLayoutEffect(() => {
        const container =
            scrollContainerRef.current;

        const pendingScrollLeft =
            pendingScrollLeftRef.current;

        if (
            !container ||
            pendingScrollLeft === null
        ) {
            return;
        }

        const maximumScrollLeft =
            Math.max(
                0,
                container.scrollWidth -
                container.clientWidth,
            );

        container.scrollLeft =
            Math.min(
                maximumScrollLeft,
                Math.max(
                    0,
                    pendingScrollLeft,
                ),
            );

        pendingScrollLeftRef.current =
            null;
    }, [zoom]);

    useEffect(() => {
        return () => {
            if (
                animationFrameRef.current !==
                null
            ) {
                cancelAnimationFrame(
                    animationFrameRef.current,
                );
            }

            if (
                gestureEndTimerRef.current !==
                null
            ) {
                window.clearTimeout(
                    gestureEndTimerRef.current,
                );
            }
        };
    }, []);

    const handleToggleLike =
        useCallback(
            (
                setId: number,
            ) => {
                if (
                    toggleLike.isPending
                ) {
                    return;
                }

                toggleLike.mutate(
                    setId,
                );
            },
            [toggleLike],
        );

    const createZoomAnchor =
        useCallback(
            (
                viewportX: number,
            ) => {
                const container =
                    scrollContainerRef.current;

                if (!container) {
                    return null;
                }

                const contentX =
                    container.scrollLeft +
                    viewportX;

                const timelinePosition =
                    Math.max(
                        0,
                        contentX -
                        STAGE_COLUMN_WIDTH,
                    ) /
                    zoomRef.current;

                return {
                    viewportX,
                    timelinePosition,
                };
            },
            [],
        );

    const runZoomAnimation =
        useCallback(() => {
            if (
                animationFrameRef.current !==
                null
            ) {
                return;
            }

            const animate = () => {
                animationFrameRef.current =
                    null;

                const currentZoom =
                    zoomRef.current;

                const targetZoom =
                    targetZoomRef.current;

                const difference =
                    targetZoom -
                    currentZoom;

                const nextZoom =
                    Math.abs(
                        difference,
                    ) <=
                    ZOOM_FINISH_THRESHOLD
                        ? targetZoom
                        : currentZoom +
                        difference *
                        ZOOM_EASING;

                const anchor =
                    zoomAnchorRef.current;

                const container =
                    scrollContainerRef.current;

                if (
                    anchor &&
                    container
                ) {
                    const nextContentX =
                        STAGE_COLUMN_WIDTH +
                        anchor.timelinePosition *
                        nextZoom;

                    pendingScrollLeftRef.current =
                        nextContentX -
                        anchor.viewportX;
                }

                zoomRef.current =
                    nextZoom;

                setZoom(
                    nextZoom,
                );

                const shouldContinue =
                    Math.abs(
                        targetZoom -
                        nextZoom,
                    ) >
                    ZOOM_FINISH_THRESHOLD;

                if (
                    shouldContinue
                ) {
                    animationFrameRef.current =
                        requestAnimationFrame(
                            animate,
                        );
                }
            };

            animationFrameRef.current =
                requestAnimationFrame(
                    animate,
                );
        }, []);

    const beginZoomGesture =
        useCallback(
            (
                viewportX: number,
            ) => {
                if (
                    !zoomAnchorRef.current
                ) {
                    zoomAnchorRef.current =
                        createZoomAnchor(
                            viewportX,
                        );
                }

                if (
                    gestureEndTimerRef.current !==
                    null
                ) {
                    window.clearTimeout(
                        gestureEndTimerRef.current,
                    );
                }

                gestureEndTimerRef.current =
                    window.setTimeout(
                        () => {
                            zoomAnchorRef.current =
                                null;

                            gestureEndTimerRef.current =
                                null;
                        },
                        GESTURE_END_DELAY,
                    );
            },
            [createZoomAnchor],
        );

    const setZoomTarget =
        useCallback(
            (
                nextZoom: number,
                viewportX: number,
            ) => {
                beginZoomGesture(
                    viewportX,
                );

                targetZoomRef.current =
                    clampZoom(
                        nextZoom,
                    );

                runZoomAnimation();
            },
            [
                beginZoomGesture,
                runZoomAnimation,
            ],
        );

    useEffect(() => {
        const container =
            scrollContainerRef.current;

        if (!container) {
            return;
        }

        const handleWheel = (
            event: WheelEvent,
        ) => {
            const isPinchGesture =
                event.ctrlKey;

            const isHorizontalGesture =
                Math.abs(
                    event.deltaX,
                ) >
                Math.abs(
                    event.deltaY,
                );

            if (
                isHorizontalGesture &&
                !isPinchGesture
            ) {
                event.preventDefault();
                event.stopPropagation();

                container.scrollLeft +=
                    event.deltaX;

                return;
            }

            event.preventDefault();
            event.stopPropagation();

            const delta =
                normaliseWheelDelta(
                    event,
                );

            if (delta === 0) {
                return;
            }

            const bounds =
                container.getBoundingClientRect();

            const viewportX =
                Math.min(
                    container.clientWidth,
                    Math.max(
                        0,
                        event.clientX -
                        bounds.left,
                    ),
                );

            const sensitivity =
                isPinchGesture
                    ? PINCH_ZOOM_SENSITIVITY
                    : WHEEL_ZOOM_SENSITIVITY;

            const zoomFactor =
                Math.exp(
                    -delta *
                    sensitivity,
                );

            setZoomTarget(
                targetZoomRef.current *
                zoomFactor,
                viewportX,
            );
        };

        container.addEventListener(
            "wheel",
            handleWheel,
            {
                passive: false,
            },
        );

        return () => {
            container.removeEventListener(
                "wheel",
                handleWheel,
            );
        };
    }, [setZoomTarget]);

    const zoomFromCentre =
        useCallback(
            (
                nextZoom: number,
            ) => {
                const container =
                    scrollContainerRef.current;

                if (!container) {
                    return;
                }

                zoomAnchorRef.current =
                    null;

                setZoomTarget(
                    nextZoom,
                    container.clientWidth /
                    2,
                );
            },
            [setZoomTarget],
        );

    const zoomIn =
        useCallback(() => {
            zoomFromCentre(
                targetZoomRef.current +
                ZOOM_STEP,
            );
        }, [zoomFromCentre]);

    const zoomOut =
        useCallback(() => {
            zoomFromCentre(
                targetZoomRef.current -
                ZOOM_STEP,
            );
        }, [zoomFromCentre]);

    const resetZoom =
        useCallback(() => {
            zoomFromCentre(
                DEFAULT_ZOOM,
            );
        }, [zoomFromCentre]);

    const orderedSets =
        useMemo(
            () =>
                sortSetsByTime(
                    sets,
                ),
            [sets],
        );

    const setsByDay =
        useMemo(() => {
            const grouped =
                new Map<
                    string,
                    FestivalSet[]
                >();

            for (
                const set of
                orderedSets
                ) {
                const dayKey =
                    getFestivalDayKey(
                        set.start_time,
                    );

                const currentSets =
                    grouped.get(
                        dayKey,
                    );

                if (currentSets) {
                    currentSets.push(
                        set,
                    );
                } else {
                    grouped.set(
                        dayKey,
                        [set],
                    );
                }
            }

            return grouped;
        }, [orderedSets]);

    const availableDays =
        useMemo(
            () =>
                Array.from(
                    setsByDay.keys(),
                ).sort(),
            [setsByDay],
        );

    const [
        selectedDay,
        setSelectedDay,
    ] = useState(
        availableDays[0] ??
        "",
    );

    useEffect(() => {
        if (
            availableDays.length >
            0 &&
            !availableDays.includes(
                selectedDay,
            )
        ) {
            setSelectedDay(
                availableDays[0],
            );
        }
    }, [
        availableDays,
        selectedDay,
    ]);

    const daySets =
        setsByDay.get(
            selectedDay,
        ) ?? [];

    const timeline =
        useMemo(() => {
            if (
                daySets.length ===
                0
            ) {
                return null;
            }

            let earliestStart =
                Number.POSITIVE_INFINITY;

            let latestEnd =
                Number.NEGATIVE_INFINITY;

            const parsedSets =
                daySets.map(
                    (
                        set,
                    ) => {
                        const startTimestamp =
                            Date.parse(
                                set.start_time,
                            );

                        const endTimestamp =
                            Date.parse(
                                set.end_time,
                            );

                        earliestStart =
                            Math.min(
                                earliestStart,
                                startTimestamp,
                            );

                        latestEnd =
                            Math.max(
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

            const timelineStart =
                startOfHour(
                    new Date(
                        earliestStart,
                    ),
                );

            const timelineEnd =
                endOfHour(
                    new Date(
                        latestEnd,
                    ),
                );

            const totalMinutes =
                differenceInMinutes(
                    timelineEnd,
                    timelineStart,
                );

            const timelineWidth =
                (
                    totalMinutes /
                    60
                ) *
                hourWidth;

            const stageMap =
                new Map<
                    string,
                    PositionedSet[]
                >();

            for (
                const parsedSet of
                parsedSets
                ) {
                const start =
                    new Date(
                        parsedSet.startTimestamp,
                    );

                const end =
                    new Date(
                        parsedSet.endTimestamp,
                    );

                const left =
                    (
                        differenceInMinutes(
                            start,
                            timelineStart,
                        ) /
                        60
                    ) *
                    hourWidth +
                    2;

                const durationWidth =
                    (
                        differenceInMinutes(
                            end,
                            start,
                        ) /
                        60
                    ) *
                    hourWidth;

                const positionedSet:
                    PositionedSet = {
                    set:
                    parsedSet.set,
                    left,
                    width:
                        Math.max(
                            durationWidth -
                            4,
                            MIN_SET_WIDTH,
                        ),
                    formattedTime:
                        `${formatTime(
                            parsedSet
                                .set
                                .start_time,
                        )} – ${formatTime(
                            parsedSet
                                .set
                                .end_time,
                        )}`,
                };

                const stageName =
                    parsedSet.set
                        .stage_name;

                const stageSets =
                    stageMap.get(
                        stageName,
                    );

                if (stageSets) {
                    stageSets.push(
                        positionedSet,
                    );
                } else {
                    stageMap.set(
                        stageName,
                        [
                            positionedSet,
                        ],
                    );
                }
            }

            const stages:
                StageRowData[] =
                Array.from(
                    stageMap.entries(),
                )
                    .sort(
                        (
                            [first],
                            [second],
                        ) =>
                            first.localeCompare(
                                second,
                            ),
                    )
                    .map(
                        ([
                             stageName,
                             positionedSets,
                         ]) => ({
                            stageName,
                            sets:
                            positionedSets,
                        }),
                    );

            const hourMarkers:
                Date[] = [];

            const current =
                new Date(
                    timelineStart,
                );

            while (
                current <=
                timelineEnd
                ) {
                hourMarkers.push(
                    new Date(
                        current,
                    ),
                );

                current.setHours(
                    current.getHours() +
                    1,
                );
            }

            return {
                stages,
                timelineWidth,
                hourMarkers,
            };
        }, [
            daySets,
            hourWidth,
        ]);

    if (
        availableDays.length ===
        0 ||
        !timeline
    ) {
        return null;
    }

    const zoomPercentage =
        Math.round(
            zoom * 100,
        );

    const pendingSetId =
        toggleLike.isPending
            ? toggleLike.variables
            : undefined;

    return (
        <section className="space-y-3">
            <div
                className="
                    flex
                    flex-col
                    gap-3
                    lg:flex-row
                    lg:items-center
                    lg:justify-between
                "
            >
                <div
                    className="
                        custom-scrollbar
                        flex
                        max-w-full
                        gap-1
                        overflow-x-auto
                        pb-1
                    "
                >
                    {availableDays.map(
                        (
                            dayKey,
                        ) => {
                            const isSelected =
                                selectedDay ===
                                dayKey;

                            return (
                                <button
                                    key={
                                        dayKey
                                    }
                                    type="button"
                                    onClick={() =>
                                        setSelectedDay(
                                            dayKey,
                                        )
                                    }
                                    aria-pressed={
                                        isSelected
                                    }
                                    className={`
                                        shrink-0
                                        rounded-lg
                                        px-3
                                        py-1.5
                                        text-sm
                                        font-medium
                                        transition
                                        focus-visible:outline-none
                                        focus-visible:ring-2
                                        focus-visible:ring-[var(--color-primary)]
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
                                    {formatDayKey(
                                        dayKey,
                                    )}
                                </button>
                            );
                        },
                    )}
                </div>

                <div
                    className="
                        flex
                        flex-wrap
                        items-center
                        justify-between
                        gap-3
                        lg:justify-end
                    "
                >
                    <p
                        className="
                            text-xs
                            leading-relaxed
                            text-[var(--color-text-muted)]
                        "
                    >
                        Select a set for
                        details. Use the
                        heart to add it
                        to your schedule.
                    </p>

                    <div
                        className="
                            flex
                            items-center
                            overflow-hidden
                            rounded-lg
                            border
                            border-[var(--color-border)]
                            bg-[var(--color-surface)]
                        "
                    >
                        <button
                            type="button"
                            onClick={
                                zoomOut
                            }
                            disabled={
                                targetZoomRef.current <=
                                MIN_ZOOM
                            }
                            aria-label="Zoom timeline out"
                            title="Zoom out"
                            className="
                                flex
                                h-9
                                w-9
                                items-center
                                justify-center
                                border-r
                                border-[var(--color-border)]
                                text-lg
                                font-medium
                                text-[var(--color-text)]
                                transition
                                hover:bg-[var(--color-background)]
                                focus-visible:outline-none
                                focus-visible:ring-2
                                focus-visible:ring-inset
                                focus-visible:ring-[var(--color-primary)]
                                disabled:cursor-not-allowed
                                disabled:opacity-40
                            "
                        >
                            −
                        </button>

                        <button
                            type="button"
                            onClick={
                                resetZoom
                            }
                            title="Reset zoom"
                            aria-label={`Reset zoom. Current zoom ${zoomPercentage}%`}
                            className="
                                h-9
                                min-w-16
                                px-2
                                text-xs
                                font-semibold
                                tabular-nums
                                text-[var(--color-text-muted)]
                                transition
                                hover:bg-[var(--color-background)]
                                hover:text-[var(--color-text)]
                                focus-visible:outline-none
                                focus-visible:ring-2
                                focus-visible:ring-inset
                                focus-visible:ring-[var(--color-primary)]
                            "
                        >
                            {
                                zoomPercentage
                            }
                            %
                        </button>

                        <button
                            type="button"
                            onClick={
                                zoomIn
                            }
                            disabled={
                                targetZoomRef.current >=
                                MAX_ZOOM
                            }
                            aria-label="Zoom timeline in"
                            title="Zoom in"
                            className="
                                flex
                                h-9
                                w-9
                                items-center
                                justify-center
                                border-l
                                border-[var(--color-border)]
                                text-lg
                                font-medium
                                text-[var(--color-text)]
                                transition
                                hover:bg-[var(--color-background)]
                                focus-visible:outline-none
                                focus-visible:ring-2
                                focus-visible:ring-inset
                                focus-visible:ring-[var(--color-primary)]
                                disabled:cursor-not-allowed
                                disabled:opacity-40
                            "
                        >
                            +
                        </button>
                    </div>
                </div>
            </div>

            <div
                className="
                    overflow-hidden
                    rounded-xl
                    border
                    border-[var(--color-border)]
                    bg-[var(--color-surface)]
                    shadow-sm
                "
            >
                <div
                    ref={
                        scrollContainerRef
                    }
                    className="
                        custom-scrollbar
                        overflow-x-auto
                        overscroll-contain
                    "
                >
                    <div
                        style={{
                            width:
                                STAGE_COLUMN_WIDTH +
                                timeline.timelineWidth,
                            minWidth:
                                "100%",
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
                                    (
                                        marker,
                                        index,
                                    ) => (
                                        <div
                                            key={
                                                marker.toISOString()
                                            }
                                            style={{
                                                left:
                                                    index *
                                                    hourWidth,
                                                width:
                                                hourWidth,
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
                                                tabular-nums
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
                            (
                                stage,
                            ) => (
                                <TimelineStageRow
                                    key={
                                        stage.stageName
                                    }
                                    stage={
                                        stage
                                    }
                                    timelineWidth={
                                        timeline.timelineWidth
                                    }
                                    hourWidth={
                                        hourWidth
                                    }
                                    pendingSetId={
                                        pendingSetId
                                    }
                                    onOpenSet={
                                        onOpenSet
                                    }
                                    onToggleLike={
                                        handleToggleLike
                                    }
                                />
                            ),
                        )}
                    </div>
                </div>
            </div>

            <p
                className="
                    text-right
                    text-[10px]
                    leading-relaxed
                    text-[var(--color-text-muted)]
                "
            >
                Scroll vertically or
                pinch over the timeline
                to zoom. Swipe
                horizontally to move.
            </p>
        </section>
    );
}