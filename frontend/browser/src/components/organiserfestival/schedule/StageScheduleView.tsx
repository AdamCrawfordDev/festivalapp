import type { FestivalSet } from "../../../types/festival";
import CollapsibleGroup from "./CollapsibleGroup";
import SetGroup from "./SetGroup";
import { formatDayKey } from "./scheduleUtils";

type StageScheduleViewProps = {
    stages: Record<
        string,
        Record<string, FestivalSet[]>
    >;
};

export default function StageScheduleView({
                                              stages,
                                          }: StageScheduleViewProps) {
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