import {
    useMutation,
    useQueryClient,
} from "@tanstack/react-query";

import { updateCurrentUser } from "../../../api/auth";
import { currentUserQueryKey } from "./useCurrentUser";

export function useUpdateCurrentUser() {
    const queryClient = useQueryClient();

    return useMutation({
        mutationFn: updateCurrentUser,

        onSuccess: (updatedUser) => {
            queryClient.setQueryData(
                currentUserQueryKey,
                updatedUser,
            );
        },
    });
}