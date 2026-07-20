import { useQuery } from "@tanstack/react-query";

import { getArtists } from "../../../api/festivals";

export function useArtists(festivalId: number) {
    return useQuery({
        queryKey: ["artists", festivalId],
        queryFn: () => getArtists(festivalId),
        enabled: festivalId > 0,
    });
}