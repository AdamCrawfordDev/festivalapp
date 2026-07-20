import {
    useMutation,
    useQueryClient,
} from "@tanstack/react-query";

import { toggleSetLike } from "../../../api/festivals";
import type { FestivalSet } from "../../../types/festival";

export function useToggleSetLike(
    festivalId: number,
) {
    const queryClient = useQueryClient();

    const queryKey = [
        "public-festival-sets",
        festivalId,
    ];

    return useMutation({
        mutationFn: toggleSetLike,

        onMutate: async (setId: number) => {
            await queryClient.cancelQueries({
                queryKey,
            });

            const previousSets =
                queryClient.getQueryData<
                    FestivalSet[]
                >(queryKey);

            queryClient.setQueryData<
                FestivalSet[]
            >(
                queryKey,
                (currentSets) =>
                    currentSets?.map((set) => {
                        if (set.id !== setId) {
                            return set;
                        }

                        const isLiked =
                            !set.is_liked;

                        return {
                            ...set,
                            is_liked: isLiked,
                            like_count: Math.max(
                                0,
                                set.like_count +
                                (isLiked
                                    ? 1
                                    : -1),
                            ),
                        };
                    }),
            );

            return {
                previousSets,
            };
        },

        onError: (
            _error,
            _setId,
            context,
        ) => {
            queryClient.setQueryData(
                queryKey,
                context?.previousSets,
            );
        },

        onSuccess: (response) => {
            queryClient.setQueryData<
                FestivalSet[]
            >(
                queryKey,
                (currentSets) =>
                    currentSets?.map((set) =>
                        set.id === response.set_id
                            ? {
                                ...set,
                                is_liked:
                                response.is_liked,
                                like_count:
                                response.like_count,
                            }
                            : set,
                    ),
            );
        },

        onSettled: () => {
            queryClient.invalidateQueries({
                queryKey,
            });
        },
    });
}