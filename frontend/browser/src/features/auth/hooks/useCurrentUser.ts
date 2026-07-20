import { useQuery } from "@tanstack/react-query";

import { getCurrentUser } from "../../../api/auth";

export const currentUserQueryKey = [
    "current-user",
] as const;

export function useCurrentUser() {
    return useQuery({
        queryKey: currentUserQueryKey,
        queryFn: getCurrentUser,
        retry: false,
        staleTime: 5 * 60 * 1000,
    });
}

export function useAuth() {
    const currentUser = useCurrentUser();

    return {
        user: currentUser.data,
        isLoading: currentUser.isPending,
        isAuthenticated: Boolean(
            currentUser.data,
        ),
        isError: currentUser.isError,
    };
}