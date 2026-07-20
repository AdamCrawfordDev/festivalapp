import { useMutation, useQueryClient } from "@tanstack/react-query";
import { useNavigate } from "react-router-dom";

import { logoutUser } from "../../../api/auth";
import Button from "../../../components/ui/Button";
import { currentUserQueryKey } from "../hooks/useCurrentUser";

export default function LogoutButton() {
    const navigate = useNavigate();
    const queryClient = useQueryClient();

    const logoutMutation = useMutation({
        mutationFn: logoutUser,

        onSuccess: () => {
            queryClient.setQueryData(currentUserQueryKey, null);
            queryClient.removeQueries({
                queryKey: currentUserQueryKey,
            });

            navigate("/");
        },
    });

    return (
        <Button
            variant="ghost"
            onClick={() => logoutMutation.mutate()}
            disabled={logoutMutation.isPending}
        >
            {logoutMutation.isPending ? "Logging out..." : "Log out"}
        </Button>
    );
}