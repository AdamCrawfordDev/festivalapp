import type {
    GroupedSchedule,
} from "../organiserfestival/schedule/scheduleTypes";

import PublicDayScheduleView from
        "./PublicDayScheduleView";

import PublicListScheduleView from
        "./PublicListScheduleView";

import PublicStageScheduleView from
        "./PublicStageScheduleView";

import PublicTimelineScheduleView from "./PublicTimelineScheduleView.tsx";

type PublicScheduleContentProps = {
    schedule: GroupedSchedule;
    festivalId: number;
};

export default function PublicScheduleContent({
                                                  schedule,
                                                  festivalId,
                                              }: PublicScheduleContentProps) {
    if (schedule.type === "list") {
        return (
            <PublicListScheduleView
                sets={schedule.sets}
                festivalId={festivalId}
            />
        );
    }

    if (schedule.type === "timeline") {
        return (
            <PublicTimelineScheduleView
                festivalId={festivalId}
                sets={schedule.sets}
            />
        );
    }

    if (schedule.type === "stage") {
        return (
            <PublicStageScheduleView
                stages={schedule.stages}
                festivalId={festivalId}
            />
        );
    }

    return (
        <PublicDayScheduleView
            days={schedule.days}
            festivalId={festivalId}
        />
    );
}