import { Link } from "react-router-dom";

import BrandName from "./navbarcomponents/BrandName";
import AccountLogin from "./navbarcomponents/Account";
import {useAuth} from "../../features/auth/hooks/useCurrentUser.ts";

export default function Navbar() {

    const { user } = useAuth();

    return (
        <nav
            className="
                sticky
                top-0
                z-50
                flex
                items-center
                justify-between
                border-b
                border-[var(--color-border)]
                bg-[var(--color-surface)]
                px-6
                py-4
            "
        >
            <BrandName />

            <div className="flex items-center gap-6">
                <Link
                    to={
                        user?.account_type === "organiser"
                            ? "/organiser/dashboard"
                            : "/dashboard"
                    }
                    className="
        font-medium
        transition
        hover:text-[var(--color-primary)]
    "
                >
                    Home
                </Link>

                <AccountLogin />
            </div>
        </nav>
    );
}