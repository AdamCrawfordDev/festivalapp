import PublicFestivalList from "./PublicFestivalList";

export default function UserDashboardBody() {
    return (
        <main className="px-6 py-10 sm:px-10">
            <div className="mx-auto max-w-5xl">
                <header className="mb-8">
                    <h1
                        className="
                            font-heading
                            text-3xl
                            font-semibold
                        "
                    >
                        Discover festivals
                    </h1>

                    <p
                        className="
                            mt-2
                            text-[var(--color-text-muted)]
                        "
                    >
                        Browse upcoming festivals and
                        explore their schedules.
                    </p>
                </header>

                <PublicFestivalList />
            </div>
        </main>
    );
}