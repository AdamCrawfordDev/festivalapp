import { useMemo } from "react";

import type {
    FestivalSet,
} from "../../types/festival";

import {
    sortSetsByTime,
} from "../organiserfestival/schedule/scheduleUtils";

import PublicScheduleRow from
        "./PublicScheduleRow";

type PublicSetGroupProps = {
    sets: FestivalSet[];
    festivalId: number;
    showStage: boolean;
};

export default function PublicSetGroup({
                                           sets,
                                           festivalId,
                                           showStage,
                                       }: PublicSetGroupProps) {
    const orderedSets = useMemo(
        () => sortSetsByTime(sets),
        [sets],
    );

    return (
        <div
            className="
                overflow-hidden
                rounded-xl
                border
                border-[var(--color-border)]
                bg-[var(--color-surface)]
            "
        >
            {orderedSets.map(
                (set, index) => (
                    <PublicScheduleRow
                        key={set.id}
                        set={set}
                        festivalId={festivalId}
                        showStage={showStage}
                        hasBorder={
                            index <
                            orderedSets.length - 1
                        }
                    />
                ),
            )}
        </div>
    );
}