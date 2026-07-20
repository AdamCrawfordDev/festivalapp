import { useQuery } from "@tanstack/react-query";

import { getSets } from "../../../api/festivals";

export function useSets(festivalId: number) {
    return useQuery({
        queryKey: ["sets", festivalId],
        queryFn: () => getSets(festivalId),
        enabled: festivalId > 0,
    });
}