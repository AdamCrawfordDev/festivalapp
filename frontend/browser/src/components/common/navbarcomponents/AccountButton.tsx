import { CircleUserRound } from "lucide-react";
import {Link} from "react-router-dom";

export default function AccountButton() {
    return (
        <Link to="/account">
        <button
            type="button"
            aria-label="Account"
            className="
                flex
                h-10
                w-10
                items-center
                justify-center
                rounded-full
                transition
                hover:bg-[var(--color-surface-alt)]
                hover:text-[var(--color-primary)]
                focus-visible:outline-none
                focus-visible:ring-2
                focus-visible:ring-[var(--color-primary)]
            "
        >
            <CircleUserRound className="h-6 w-6" />
        </button>
        </Link>
    );
}