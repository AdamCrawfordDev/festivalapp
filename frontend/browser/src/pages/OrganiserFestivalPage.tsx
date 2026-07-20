import { useParams } from "react-router-dom";

import AddSetButton from "../components/organiserfestival/AddSetButton";
import AddStageButton from "../components/organiserfestival/AddStageButton";
import FestivalHeader from "../components/organiserfestival/FestivalHeader";
import FestivalSchedule from "../components/organiserfestival/schedule/FestivalSchedule.tsx";
import { useFestival } from "../features/festivals/hooks/useFestivals";

export default function OrganiserFestivalPage() {
    const { festivalId } = useParams();

    const parsedFestivalId = Number(festivalId);
    const festivalQuery = useFestival(parsedFestivalId);

    if (
        !festivalId ||
        !Number.isInteger(parsedFestivalId) ||
        parsedFestivalId <= 0
    ) {
        return <p>Invalid festival.</p>;
    }

    if (festivalQuery.isPending) {
        return <p>Loading festival...</p>;
    }

    if (festivalQuery.isError) {
        return <p>Unable to load this festival.</p>;
    }

    const festival = festivalQuery.data;

    return (
        <div className="space-y-8">
            <FestivalHeader festival={festival} />

            <section className="px-10 pb-10">
                <div className="
                    mb-6
                    flex
                    flex-col
                    gap-4
                    sm:flex-row
                    sm:items-center
                    sm:justify-between
                ">
                    <div>
                        <h2 className="
                            font-heading
                            text-3xl
                            font-semibold
                        ">
                            Schedule
                        </h2>

                        <p className="
                            mt-1
                            text-[var(--color-text-muted)]
                        ">
                            Manage the festival timetable,
                            artists, and stages.
                        </p>
                    </div>

                    <div className="flex gap-3">
                        <AddStageButton
                            festivalId={festival.id}
                        />

                        <AddSetButton
                            festivalId={festival.id}
                        />
                    </div>
                </div>

                <FestivalSchedule
                    festivalId={festival.id}
                />
            </section>
        </div>
    );
}