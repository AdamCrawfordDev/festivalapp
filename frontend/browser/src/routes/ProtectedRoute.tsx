import { Navigate, Outlet, useLocation } from "react-router-dom";

import { useCurrentUser } from "../features/auth/hooks/useCurrentUser";
import type {AccountType} from "../types/auth.tsx";

type ProtectedRouteProps = {
    allowedAccountType?: AccountType;
};

export default function ProtectedRoute({
                                           allowedAccountType,
                                       }: ProtectedRouteProps) {
    const location = useLocation();
    const currentUserQuery = useCurrentUser();

    if (currentUserQuery.isPending) {
        return (
            <div className="flex min-h-[60vh] items-center justify-center">
                <p>Loading...</p>
            </div>
        );
    }

    if (currentUserQuery.isError || !currentUserQuery.data) {
        return (
            <Navigate
                to="/login"
                replace
                state={{ from: location }}
            />
        );
    }

    const user = currentUserQuery.data;

    if (
        allowedAccountType &&
        user.account_type !== allowedAccountType
    ) {
        return <Navigate to="/dashboard" replace />;
    }

    return <Outlet />;
}