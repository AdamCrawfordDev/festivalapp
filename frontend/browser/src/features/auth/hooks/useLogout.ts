import { useMutation, useQueryClient } from "@tanstack/react-query";
import { useNavigate } from "react-router-dom";

import { logoutUser } from "../../../api/auth";
import { currentUserQueryKey } from "./useCurrentUser";

export function useLogout() {
    const queryClient = useQueryClient();
    const navigate = useNavigate();

    return useMutation({
        mutationFn: logoutUser,

        onSuccess: async () => {
            queryClient.setQueryData(
                currentUserQueryKey,
                null,
            );

            await queryClient.invalidateQueries({
                queryKey: currentUserQueryKey,
            });

            navigate("/");
        },
    });
}