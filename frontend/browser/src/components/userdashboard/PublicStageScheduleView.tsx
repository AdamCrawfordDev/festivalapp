import type {
    FestivalSet,
} from "../../types/festival";

import CollapsibleGroup from
        "../organiserfestival/schedule/CollapsibleGroup";

import {
    formatDayKey,
} from "../organiserfestival/schedule/scheduleUtils";

import PublicSetGroup from "./PublicSetGroup";

type PublicStageScheduleViewProps = {
    stages: Record<
        string,
        Record<string, FestivalSet[]>
    >;
    festivalId: number;
};

export default function PublicStageScheduleView({
                                                    stages,
                                                    festivalId,
                                                }: PublicStageScheduleViewProps) {
    return (
        <div className="space-y-10">
            {Object.entries(stages).map(
                ([stageName, days]) => (
                    <CollapsibleGroup
                        key={stageName}
                        title={stageName}
                    >
                        <div className="space-y-5 pl-3">
                            {Object.entries(days).map(
                                ([dayKey, sets]) => (
                                    <CollapsibleGroup
                                        key={dayKey}
                                        title={formatDayKey(
                                            dayKey,
                                        )}
                                        headingLevel="h4"
                                    >
                                        <PublicSetGroup
                                            sets={sets}
                                            festivalId={
                                                festivalId
                                            }
                                            showStage={false}
                                        />
                                    </CollapsibleGroup>
                                ),
                            )}
                        </div>
                    </CollapsibleGroup>
                ),
            )}
        </div>
    );
}