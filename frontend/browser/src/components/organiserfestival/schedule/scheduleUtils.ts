import type { FestivalSet } from "../../../types/festival";
import type {
    GroupedSchedule,
    ScheduleView,
} from "./scheduleTypes";

export function formatTime(dateString: string) {
    return new Date(dateString).toLocaleTimeString([], {
        hour: "2-digit",
        minute: "2-digit",
    });
}

export function getDayKey(dateString: string) {
    const date = new Date(dateString);

    return [
        date.getFullYear(),
        String(date.getMonth() + 1).padStart(2, "0"),
        String(date.getDate()).padStart(2, "0"),
    ].join("-");
}

export function formatDayKey(dayKey: string) {
    return new Date(
        `${dayKey}T12:00:00`,
    ).toLocaleDateString([], {
        weekday: "long",
        day: "numeric",
        month: "long",
    });
}

export function sortSetsByTime(
    sets: FestivalSet[],
) {
    return [...sets].sort(
        (first, second) =>
            new Date(first.start_time).getTime() -
            new Date(second.start_time).getTime(),
    );
}

function groupBy<T>(
    items: T[],
    getKey: (item: T) => string,
): Record<string, T[]> {
    return items.reduce<Record<string, T[]>>(
        (groups, item) => {
            const key = getKey(item);

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
) {
    const normalizedSearch = search
        .trim()
        .toLowerCase();

    if (!normalizedSearch) {
        return sortSetsByTime(sets);
    }

    return sortSetsByTime(
        sets.filter(
            (set) =>
                set.artist_name
                    .toLowerCase()
                    .includes(normalizedSearch) ||
                set.stage_name
                    .toLowerCase()
                    .includes(normalizedSearch),
        ),
    );
}

export function buildGroupedSchedule(
    sets: FestivalSet[],
    view: ScheduleView,
): GroupedSchedule {
    const orderedSets = sortSetsByTime(sets);

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
        const setsByStage = groupBy(
            orderedSets,
            (set) => set.stage_name,
        );

        return {
            type: "stage",
            stages: Object.fromEntries(
                Object.entries(setsByStage).map(
                    ([stageName, stageSets]) => [
                        stageName,
                        groupBy(
                            stageSets,
                            (set) =>
                                getDayKey(set.start_time),
                        ),
                    ],
                ),
            ),
        };
    }

    const setsByDay = groupBy(
        orderedSets,
        (set) => getDayKey(set.start_time),
    );

    return {
        type: "day",
        days: Object.fromEntries(
            Object.entries(setsByDay).map(
                ([dayKey, daySets]) => [
                    dayKey,
                    groupBy(
                        daySets,
                        (set) => set.stage_name,
                    ),
                ],
            ),
        ),
    };
}

const FESTIVAL_DAY_CUTOFF_HOUR = 6;

function formatDateKey(date: Date) {
    return [
        date.getFullYear(),
        String(date.getMonth() + 1).padStart(2, "0"),
        String(date.getDate()).padStart(2, "0"),
    ].join("-");
}



export function getFestivalDayKey(
    dateString: string,
) {
    const date = new Date(dateString);

    /*
     * Midnight through 05:59 belongs to the
     * previous festival day.
     */
    if (
        date.getHours() <
        FESTIVAL_DAY_CUTOFF_HOUR
    ) {
        date.setDate(date.getDate() - 1);
    }

    return formatDateKey(date);
}