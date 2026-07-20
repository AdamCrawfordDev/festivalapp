import { useQuery } from "@tanstack/react-query";

import { getStages } from "../../../api/festivals";

export function useStages(festivalId: number) {
    return useQuery({
        queryKey: ["stages", festivalId],
        queryFn: () => getStages(festivalId),
        enabled: festivalId > 0,
    });
}