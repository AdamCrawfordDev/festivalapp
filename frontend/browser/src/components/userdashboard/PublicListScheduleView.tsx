import type {
    FestivalSet,
} from "../../types/festival";

import PublicSetGroup from "./PublicSetGroup";

type PublicListScheduleViewProps = {
    sets: FestivalSet[];
    festivalId: number;
};

export default function PublicListScheduleView({
                                                   sets,
                                                   festivalId,
                                               }: PublicListScheduleViewProps) {
    return (
        <PublicSetGroup
            sets={sets}
            festivalId={festivalId}
            showStage
        />
    );
}