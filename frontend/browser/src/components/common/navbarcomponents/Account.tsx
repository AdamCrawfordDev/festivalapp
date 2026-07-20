import {useAuth} from "../../../features/auth/hooks/useCurrentUser.ts";
import {Link} from "react-router-dom";
import AccountButton from "./AccountButton.tsx";

export default function AccountLogin() {
    const {
        isAuthenticated,
    } = useAuth();

    return (<>
        {isAuthenticated ?  <AccountButton/>: <Link to="/login">Login</Link> }
    </>);
}