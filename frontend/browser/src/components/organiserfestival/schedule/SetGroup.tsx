import { useState } from "react";

import type { FestivalSet } from "../../../types/festival";
import ScheduleRow from "./ScheduleRow";
import { sortSetsByTime } from "./scheduleUtils";
import EditSetForm from "./EditSetForm.tsx";

type SetGroupProps = {
    sets: FestivalSet[];
    showStage: boolean;
};

export default function SetGroup({
                                     sets,
                                     showStage,
                                 }: SetGroupProps) {
    const [selectedSet, setSelectedSet] =
        useState<FestivalSet | null>(null);

    const orderedSets = sortSetsByTime(sets);

    function closeEditForm() {
        setSelectedSet(null);
    }

    return (
        <>
            <div
                className="
                    overflow-hidden
                    rounded-xl
                    border
                    border-[var(--color-border)]
                    bg-[var(--color-surface)]
                "
            >
                {orderedSets.map((set, index) => (
                    <ScheduleRow
                        key={set.id}
                        set={set}
                        showStage={showStage}
                        hasBorder={
                            index < orderedSets.length - 1
                        }
                        onEdit={setSelectedSet}
                    />
                ))}
            </div>

            {selectedSet && (
                <div
                    className="
                        fixed
                        inset-0
                        z-50
                        flex
                        items-center
                        justify-center
                        bg-black/50
                        p-4
                    "
                    role="dialog"
                    aria-modal="true"
                    aria-label={`Edit ${selectedSet.artist_name}'s set`}
                    onClick={closeEditForm}
                >
                    <div
                        className="w-full max-w-lg"
                        onClick={(event) =>
                            event.stopPropagation()
                        }
                    >
                        <EditSetForm
                            set={selectedSet}
                            onClose={closeEditForm}
                        />
                    </div>
                </div>
            )}
        </>
    );
}