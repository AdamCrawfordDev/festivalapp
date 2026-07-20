import type { FestivalSet } from "../../../types/festival";

export type ScheduleView =
    | "list"
    | "timeline"
    | "day"
    | "stage";

export type GroupedSchedule =
    | {
    type: "list";
    sets: FestivalSet[];
}
    | {
    type: "timeline";
    sets: FestivalSet[];
}
    | {
    type: "stage";
    stages: Record<
        string,
        Record<string, FestivalSet[]>
    >;
}
    | {
    type: "day";
    days: Record<
        string,
        Record<string, FestivalSet[]>
    >;
};