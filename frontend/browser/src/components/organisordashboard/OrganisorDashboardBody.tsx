import AddFestivalButton from "./AddFestivalButton";
import FestivalList from "./FestivalList";

export default function OrganiserDashboardBody() {
    return (
        <main className="px-6 pb-24 sm:px-10">
            <div className="mx-auto max-w-5xl">
                <FestivalList />
            </div>

            <div className="fixed bottom-8 right-8 z-40">
                <AddFestivalButton />
            </div>
        </main>
    );
}