import { useNavigate } from "react-router-dom";
import Button from "../ui/Button";

export default function GetStarted() {
    const navigate = useNavigate();

    return (
        <div className="mt-10 flex flex-col gap-4 sm:flex-row">
            <Button
                variant="primary"
                onClick={() => navigate("/attendee/register")}
            >
                I'm a partier
            </Button>

            <Button
                variant="secondary"
                onClick={() => navigate("/organiser/register")}
            >
                I'm an organiser
            </Button>
        </div>
    );
}