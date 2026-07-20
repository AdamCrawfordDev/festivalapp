import { useParams } from "react-router-dom";

import FestivalHeader from "../components/organiserfestival/FestivalHeader";
import {usePublicFestival} from "../features/festivals/hooks/usePublicFestivals.ts";
import PublicFestivalSchedule from "../components/userdashboard/PublicFestivalSchedule.tsx";

export default function FestivalPage() {
    const { festivalId } = useParams();

    const parsedFestivalId = Number(festivalId);

    const festivalQuery =
        usePublicFestival(parsedFestivalId);

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
        return (
            <p>
                Unable to load this festival.
            </p>
        );
    }

    const festival = festivalQuery.data;

    return (
        <div className="space-y-8">
            <FestivalHeader festival={festival} />

            <section className="px-10 pb-10">
                <div className="mb-6">
                    <h2
                        className="
                            font-heading
                            text-3xl
                            font-semibold
                        "
                    >
                        Schedule
                    </h2>

                    <p
                        className="
                            mt-1
                            text-[var(--color-text-muted)]
                        "
                    >
                        Browse the festival timetable by
                        list, day, or stage.
                    </p>
                </div>

                <PublicFestivalSchedule
                    festivalId={festival.id}
                />
            </section>
        </div>
    );
}