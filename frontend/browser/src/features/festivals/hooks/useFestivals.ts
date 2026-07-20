import { useQuery } from "@tanstack/react-query";

import {
    getFestival,
    getFestivals,
} from "../../../api/festivals";

export const festivalsQueryKey = ["festivals"] as const;

export function useFestivals() {
    return useQuery({
        queryKey: festivalsQueryKey,
        queryFn: getFestivals,
    });
}

export function festivalQueryKey(festivalId: number) {
    return ["festivals", festivalId] as const;
}

export function useFestival(festivalId: number) {
    return useQuery({
        queryKey: festivalQueryKey(festivalId),
        queryFn: () => getFestival(festivalId),
        enabled: Number.isInteger(festivalId) && festivalId > 0,
    });
}