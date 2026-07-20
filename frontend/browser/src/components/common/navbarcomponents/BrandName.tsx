import { Link } from "react-router-dom";

export default function BrandName() {
    return (
        <Link to="/">
            <h1 className="text-2xl font-bold">PlanIt</h1>
        </Link>
    );
}