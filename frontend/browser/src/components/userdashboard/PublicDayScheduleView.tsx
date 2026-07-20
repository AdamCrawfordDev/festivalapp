import type {
    FestivalSet,
} from "../../types/festival";

import CollapsibleGroup from
        "../organiserfestival/schedule/CollapsibleGroup";

import {
    formatDayKey,
} from "../organiserfestival/schedule/scheduleUtils";

import PublicSetGroup from "./PublicSetGroup";

type PublicDayScheduleViewProps = {
    days: Record<
        string,
        Record<string, FestivalSet[]>
    >;
    festivalId: number;
};

export default function PublicDayScheduleView({
                                                  days,
                                                  festivalId,
                                              }: PublicDayScheduleViewProps) {
    return (
        <div className="space-y-10">
            {Object.entries(days).map(
                ([dayKey, stages]) => (
                    <CollapsibleGroup
                        key={dayKey}
                        title={formatDayKey(dayKey)}
                    >
                        <div className="space-y-5 pl-3">
                            {Object.entries(stages).map(
                                ([stageName, sets]) => (
                                    <CollapsibleGroup
                                        key={stageName}
                                        title={stageName}
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