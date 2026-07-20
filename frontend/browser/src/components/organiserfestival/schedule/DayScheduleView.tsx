import type { FestivalSet } from "../../../types/festival";
import CollapsibleGroup from "./CollapsibleGroup";
import SetGroup from "./SetGroup";
import { formatDayKey } from "./scheduleUtils";

type DayScheduleViewProps = {
    days: Record<
        string,
        Record<string, FestivalSet[]>
    >;
};

export default function DayScheduleView({
                                            days,
                                        }: DayScheduleViewProps) {
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
                                        <SetGroup
                                            sets={sets}
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