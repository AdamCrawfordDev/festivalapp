import type { FestivalSet } from "../../../types/festival";
import SetGroup from "./SetGroup";

type ListScheduleViewProps = {
    sets: FestivalSet[];
};

export default function ListScheduleView({
                                             sets,
                                         }: ListScheduleViewProps) {
    return (
        <SetGroup
            sets={sets}
            showStage
        />
    );
}