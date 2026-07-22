import type {
    FestivalSet,
} from "../../../types/festival";

import type {
    GroupedSchedule,
    ScheduleView,
} from "./scheduleTypes";

const FESTIVAL_TIME_ZONE =
    "Europe/Zagreb";

const FESTIVAL_DAY_CUTOFF_HOUR = 6;

type FestivalDateParts = {
    year: number;
    month: number;
    day: number;
    hour: number;
};

function getFestivalDateParts(
    value: string | Date,
): FestivalDateParts {
    const date =
        value instanceof Date
            ? value
            : new Date(value);

    const formatter =
        new Intl.DateTimeFormat(
            "en-GB",
            {
                timeZone:
                FESTIVAL_TIME_ZONE,
                year: "numeric",
                month: "2-digit",
                day: "2-digit",
                hour: "2-digit",
                hourCycle: "h23",
            },
        );

    const parts =
        formatter.formatToParts(date);

    const readPart = (
        type: Intl.DateTimeFormatPartTypes,
    ): number => {
        const part = parts.find(
            (item) => item.type === type,
        );

        if (!part) {
            throw new Error(
                `Could not read ${type} from date.`,
            );
        }

        return Number(part.value);
    };

    return {
        year: readPart("year"),
        month: readPart("month"),
        day: readPart("day"),
        hour: readPart("hour"),
    };
}

function formatDateKeyFromParts(
    year: number,
    month: number,
    day: number,
): string {
    return [
        String(year).padStart(4, "0"),
        String(month).padStart(2, "0"),
        String(day).padStart(2, "0"),
    ].join("-");
}

function subtractCalendarDay(
    year: number,
    month: number,
    day: number,
): {
    year: number;
    month: number;
    day: number;
} {
    /*
     * UTC is used only to perform safe calendar arithmetic.
     * These values already represent the Croatian calendar
     * date, so no device timezone conversion is involved.
     */
    const date = new Date(
        Date.UTC(
            year,
            month - 1,
            day,
        ),
    );

    date.setUTCDate(
        date.getUTCDate() - 1,
    );

    return {
        year: date.getUTCFullYear(),
        month: date.getUTCMonth() + 1,
        day: date.getUTCDate(),
    };
}

export function formatTime(
    value: string,
): string {
    return new Intl.DateTimeFormat(
        "en-GB",
        {
            hour: "2-digit",
            minute: "2-digit",
            hour12: false,
            timeZone:
            FESTIVAL_TIME_ZONE,
        },
    ).format(
        new Date(value),
    );
}

export function getFestivalDayKey(
    dateString: string,
): string {
    const parts =
        getFestivalDateParts(
            dateString,
        );

    /*
     * Midnight through 05:59 belongs to the
     * previous printed festival day.
     */
    if (
        parts.hour <
        FESTIVAL_DAY_CUTOFF_HOUR
    ) {
        const previousDay =
            subtractCalendarDay(
                parts.year,
                parts.month,
                parts.day,
            );

        return formatDateKeyFromParts(
            previousDay.year,
            previousDay.month,
            previousDay.day,
        );
    }

    return formatDateKeyFromParts(
        parts.year,
        parts.month,
        parts.day,
    );
}

/*
 * Keep this exported name for any older code that
 * still calls getDayKey().
 */
export function getDayKey(
    dateString: string,
): string {
    return getFestivalDayKey(
        dateString,
    );
}

export function formatDayKey(
    dayKey: string,
): string {
    /*
     * The day key is already a festival calendar date.
     * Formatting it in UTC prevents the browser timezone
     * from moving it forwards or backwards.
     */
    const date = new Date(
        `${dayKey}T12:00:00Z`,
    );

    return new Intl.DateTimeFormat(
        "en-GB",
        {
            weekday: "long",
            day: "numeric",
            month: "long",
            timeZone: "UTC",
        },
    ).format(date);
}

export function sortSetsByTime(
    sets: FestivalSet[],
): FestivalSet[] {
    return [...sets].sort(
        (
            first,
            second,
        ) => {
            return (
                new Date(
                    first.start_time,
                ).getTime() -
                new Date(
                    second.start_time,
                ).getTime()
            );
        },
    );
}

function groupBy<T>(
    items: T[],
    getKey: (
        item: T,
    ) => string,
): Record<string, T[]> {
    return items.reduce<
        Record<string, T[]>
    >(
        (
            groups,
            item,
        ) => {
            const key =
                getKey(item);

            if (!groups[key]) {
                groups[key] = [];
            }

            groups[key].push(item);

            return groups;
        },
        {},
    );
}

export function filterSets(
    sets: FestivalSet[],
    search: string,
): FestivalSet[] {
    const normalizedSearch =
        search
            .trim()
            .toLowerCase();

    if (!normalizedSearch) {
        return sortSetsByTime(
            sets,
        );
    }

    return sortSetsByTime(
        sets.filter(
            (set) => {
                return (
                    set.artist_name
                        .toLowerCase()
                        .includes(
                            normalizedSearch,
                        ) ||
                    set.stage_name
                        .toLowerCase()
                        .includes(
                            normalizedSearch,
                        )
                );
            },
        ),
    );
}

export function buildGroupedSchedule(
    sets: FestivalSet[],
    view: ScheduleView,
): GroupedSchedule {
    const orderedSets =
        sortSetsByTime(
            sets,
        );

    if (view === "list") {
        return {
            type: "list",
            sets: orderedSets,
        };
    }

    if (view === "timeline") {
        return {
            type: "timeline",
            sets: orderedSets,
        };
    }

    if (view === "stage") {
        const setsByStage =
            groupBy(
                orderedSets,
                (set) =>
                    set.stage_name,
            );

        return {
            type: "stage",
            stages:
                Object.fromEntries(
                    Object.entries(
                        setsByStage,
                    ).map(
                        (
                            [
                                stageName,
                                stageSets,
                            ],
                        ) => [
                            stageName,
                            groupBy(
                                stageSets,
                                (set) =>
                                    getFestivalDayKey(
                                        set.start_time,
                                    ),
                            ),
                        ],
                    ),
                ),
        };
    }

    const setsByDay =
        groupBy(
            orderedSets,
            (set) =>
                getFestivalDayKey(
                    set.start_time,
                ),
        );

    return {
        type: "day",
        days:
            Object.fromEntries(
                Object.entries(
                    setsByDay,
                ).map(
                    (
                        [
                            dayKey,
                            daySets,
                        ],
                    ) => [
                        dayKey,
                        groupBy(
                            daySets,
                            (set) =>
                                set.stage_name,
                        ),
                    ],
                ),
            ),
    };
}