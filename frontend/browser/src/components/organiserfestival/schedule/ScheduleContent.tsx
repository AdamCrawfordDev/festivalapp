import DayScheduleView from "./DayScheduleView";
import ListScheduleView from "./ListScheduleView";
import StageScheduleView from "./StageScheduleView";
import type { GroupedSchedule } from "./scheduleTypes";
import TimelineScheduleView from "./TimelineScheduleView.tsx";

type ScheduleContentProps = {
    schedule: GroupedSchedule;
};

export default function ScheduleContent({
                                            schedule,
                                        }: ScheduleContentProps) {
    if (schedule.type === "list") {
        return (
            <ListScheduleView
                sets={schedule.sets}
            />
        );
    }

    if (schedule.type === "timeline") {
        return (
            <TimelineScheduleView
                sets={schedule.sets}
            />
        );
    }

    if (schedule.type === "stage") {
        return (
            <StageScheduleView
                stages={schedule.stages}
            />
        );
    }

    return (
        <DayScheduleView
            days={schedule.days}
        />
    );
}