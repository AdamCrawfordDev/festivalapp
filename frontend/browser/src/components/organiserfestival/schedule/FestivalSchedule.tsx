import { useMemo, useState } from "react";

import { useSets } from "../../../features/festivals/hooks/useSets";
import EmptyScheduleState from "./EmptyScheduleState";
import ScheduleContent from "./ScheduleContent";
import ScheduleToolbar from "./ScheduleToolbar";
import type { ScheduleView } from "./scheduleTypes";
import {
    buildGroupedSchedule,
    filterSets,
} from "./scheduleUtils";

type FestivalScheduleProps = {
    festivalId: number;
};

export default function FestivalSchedule({
                                             festivalId,
                                         }: FestivalScheduleProps) {
    const setsQuery = useSets(festivalId);

    const [search, setSearch] = useState("");
    const [view, setView] =
        useState<ScheduleView>("list");

    const filteredSets = useMemo(
        () =>
            filterSets(
                setsQuery.data ?? [],
                search,
            ),
        [setsQuery.data, search],
    );

    const groupedSchedule = useMemo(
        () =>
            buildGroupedSchedule(
                filteredSets,
                view,
            ),
        [filteredSets, view],
    );

    if (setsQuery.isPending) {
        return <p>Loading schedule...</p>;
    }

    if (setsQuery.isError) {
        return (
            <p>
                Unable to load the festival schedule.
            </p>
        );
    }

    if (setsQuery.data.length === 0) {
        return (
            <EmptyScheduleState
                title="No sets yet"
                description={
                    "Add a stage, then add the first " +
                    "artist to the timetable."
                }
            />
        );
    }

    return (
        <div className="space-y-8">
            <ScheduleToolbar
                search={search}
                view={view}
                onSearchChange={setSearch}
                onViewChange={setView}
            />

            {filteredSets.length === 0 ? (
                <EmptyScheduleState
                    title="No matching sets"
                    description={
                        "Try searching for another " +
                        "artist or stage."
                    }
                />
            ) : (
                <ScheduleContent
                    schedule={groupedSchedule}
                />
            )}
        </div>
    );
}