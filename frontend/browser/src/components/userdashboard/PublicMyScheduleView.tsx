import { useMemo } from "react";

import type {
    FestivalSet,
} from "../../types/festival";

import CollapsibleGroup from
    "../organiserfestival/schedule/CollapsibleGroup";

import EmptyScheduleState from
    "../organiserfestival/schedule/EmptyScheduleState";

import {
    formatDayKey,
    getFestivalDayKey,
    sortSetsByTime,
} from "../organiserfestival/schedule/scheduleUtils";

import PublicSetGroup from "./PublicSetGroup";

type PublicMyScheduleViewProps = {
    sets: FestivalSet[];
    festivalId: number;
};

export default function PublicMyScheduleView({
    sets,
    festivalId,
}: PublicMyScheduleViewProps) {
    const likedSetsByDay = useMemo(() => {
        const grouped: Record<
            string,
            FestivalSet[]
        > = {};

        const likedSets = sortSetsByTime(
            sets.filter((set) => set.is_liked),
        );

        for (const set of likedSets) {
            const dayKey = getFestivalDayKey(
                set.start_time,
            );

            if (!grouped[dayKey]) {
                grouped[dayKey] = [];
            }

            grouped[dayKey].push(set);
        }

        return grouped;
    }, [sets]);

    const days = Object.entries(
        likedSetsByDay,
    ).sort(([firstDay], [secondDay]) =>
        firstDay.localeCompare(secondDay),
    );

    if (days.length === 0) {
        return (
            <EmptyScheduleState
                title="Your schedule is empty"
                description={
                    "Like sets to add them to your " +
                    "personal schedule."
                }
            />
        );
    }

    return (
        <div className="space-y-8">
            {days.map(([dayKey, daySets]) => (
                <CollapsibleGroup
                    key={dayKey}
                    title={formatDayKey(dayKey)}
                >
                    <PublicSetGroup
                        sets={daySets}
                        festivalId={festivalId}
                        showStage
                    />
                </CollapsibleGroup>
            ))}
        </div>
    );
}

