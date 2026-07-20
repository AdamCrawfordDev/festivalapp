import { useNavigate } from "react-router-dom";

import { usePublicFestivals } from "../../features/festivals/hooks/usePublicFestivals";
import FestivalCard from "../festivals/FestivalCard";

export default function PublicFestivalList() {
    const navigate = useNavigate();
    const festivalsQuery =
        usePublicFestivals();

    if (festivalsQuery.isPending) {
        return <p>Loading festivals...</p>;
    }

    if (festivalsQuery.isError) {
        return (
            <p>
                Unable to load festivals.
            </p>
        );
    }

    if (festivalsQuery.data.length === 0) {
        return (
            <div
                className="
                    rounded-xl
                    border
                    border-[var(--color-border)]
                    bg-[var(--color-surface)]
                    p-8
                    text-center
                "
            >
                <h2 className="font-heading text-xl">
                    No festivals available
                </h2>

                <p
                    className="
                        mt-2
                        text-[var(--color-text-muted)]
                    "
                >
                    New festivals will appear here.
                </p>
            </div>
        );
    }

    return (
        <div className="space-y-6">
            {festivalsQuery.data.map(
                (festival) => (
                    <FestivalCard
                        key={festival.id}
                        name={festival.name}
                        description={
                            festival.description
                        }
                        startDate={
                            festival.start_date
                        }
                        endDate={
                            festival.end_date
                        }
                        image={festival.image}
                        organiserName={
                            festival.organiser_name
                        }
                        organiserProfilePicture={
                            festival
                                .organiser_profile_picture
                        }
                        onClick={() =>
                            navigate(
                                `/festivals/${festival.id}`,
                            )
                        }
                    />
                ),
            )}
        </div>
    );
}