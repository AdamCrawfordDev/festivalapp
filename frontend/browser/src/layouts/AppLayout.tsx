import { Outlet } from "react-router-dom";
import Navbar from "../components/common/Navbar";
import Footer from "../components/common/Footer";

export default function AppLayout() {
    return (
        <div className="flex min-h-screen flex-col bg-(--color-background) text-(--color-text)">
            <Navbar />

            <main className="flex-1 w-full">
                <Outlet />
            </main>

            <Footer />
        </div>
    );
}