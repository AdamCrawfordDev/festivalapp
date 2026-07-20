import { useQuery } from "@tanstack/react-query";
import {getPublicFestivalSets} from "../../../api/users.ts";



export function usePublicFestivalSets(
    festivalId: number,
) {
    return useQuery({
        queryKey: [
            "public-festival-sets",
            festivalId,
        ],
        queryFn: () =>
            getPublicFestivalSets(
                festivalId,
            ),
    });
}