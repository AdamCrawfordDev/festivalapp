import { useQuery } from "@tanstack/react-query";

import { getPublicFestivals } from "../../../api/festivals";
import {getPublicFestival} from "../../../api/users.ts";

export function usePublicFestivals() {
    return useQuery({
        queryKey: ["public-festivals"],
        queryFn: getPublicFestivals,
    });
}




export function usePublicFestival(
    festivalId: number,
) {
    return useQuery({
        queryKey: [
            "public-festival",
            festivalId,
        ],
        queryFn: () =>
            getPublicFestival(festivalId),
        enabled:
            Number.isInteger(festivalId) &&
            festivalId > 0,
    });
}