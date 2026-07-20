import {
    useMemo,
    useState,
} from "react";

import { usePublicFestivalSets } from
    "../../features/festivals/hooks/usePublicFestivalSets";

import EmptyScheduleState from
    "../organiserfestival/schedule/EmptyScheduleState";

import ScheduleToolbar from
    "../organiserfestival/schedule/ScheduleToolbar";

import type {
    ScheduleView,
} from "../organiserfestival/schedule/scheduleTypes";

import {
    buildGroupedSchedule,
    filterSets,
} from "../organiserfestival/schedule/scheduleUtils";

import PublicMyScheduleView from
    "./PublicMyScheduleView";

import PublicScheduleContent from
    "./PublicScheduleContent";

type PublicFestivalScheduleProps = {
    festivalId: number;
};

type PublicScheduleView =
    | ScheduleView
    | "my-schedule";

export default function PublicFestivalSchedule({
    festivalId,
}: PublicFestivalScheduleProps) {
    const setsQuery =
        usePublicFestivalSets(festivalId);

    const [search, setSearch] = useState("");

    const [view, setView] =
        useState<PublicScheduleView>("list");

    const filteredSets = useMemo(
        () =>
            filterSets(
                setsQuery.data ?? [],
                search,
            ),
        [setsQuery.data, search],
    );

    const groupedSchedule = useMemo(() => {
        if (view === "my-schedule") {
            return null;
        }

        return buildGroupedSchedule(
            filteredSets,
            view,
        );
    }, [filteredSets, view]);

    if (setsQuery.isPending) {
        return <p>Loading schedule...</p>;
    }

    if (setsQuery.isError) {
        return (
            <p>
                Unable to load the festival schedule.
            </p>
        );
    }

    if (setsQuery.data.length === 0) {
        return (
            <EmptyScheduleState
                title="No schedule available"
                description={
                    "The organiser has not added any " +
                    "sets yet."
                }
            />
        );
    }

    return (
        <div className="space-y-8">
            <div
                className="
                    flex
                    flex-col
                    gap-3
                    lg:flex-row
                    lg:items-center
                    lg:justify-between
                "
            >
                <ScheduleToolbar
                    search={search}
                    view={
                        view === "my-schedule"
                            ? "list"
                            : view
                    }
                    onSearchChange={setSearch}
                    onViewChange={setView}
                />

                <button
                    type="button"
                    onClick={() =>
                        setView((currentView) =>
                            currentView ===
                            "my-schedule"
                                ? "list"
                                : "my-schedule",
                        )
                    }
                    aria-pressed={
                        view === "my-schedule"
                    }
                    className={`
inline-flex
shrink-0
items-center
justify-center
gap-2
rounded-xl
border
px-4
py-2.5
text-sm
font-semibold
transition
${
    view === "my-schedule"
        ? `
                                    border-[var(--color-primary)]
                                    bg-[var(--color-primary)]
                                    text-white
                                `
        : `
                                    border-[var(--color-border)]
                                    bg-[var(--color-surface)]
                                    text-[var(--color-text)]
                                    hover:border-[var(--color-primary)]
                                    hover:text-[var(--color-primary)]
                                `
}
`}
                >
                    <svg
                        viewBox="0 0 24 24"
                        aria-hidden="true"
                        className="h-5 w-5"
                        fill={
                            view === "my-schedule"
                                ? "currentColor"
                                : "none"
                        }
                        stroke="currentColor"
                        strokeWidth="1.8"
                    >
                        <path
                            strokeLinecap="round"
                            strokeLinejoin="round"
                            d="
                                M20.84 4.61
                                a5.5 5.5 0 0 0-7.78 0
                                L12 5.67
                                l-1.06-1.06
                                a5.5 5.5 0 0 0-7.78 7.78
                                L12 21.23
                                l8.84-8.84
                                a5.5 5.5 0 0 0 0-7.78
                                Z
                            "
                        />
                    </svg>

                    My schedule
                </button>
            </div>

            {view === "my-schedule" ? (
                <PublicMyScheduleView
                    sets={setsQuery.data}
                    festivalId={festivalId}
                />
            ) : filteredSets.length === 0 ? (
                <EmptyScheduleState
                    title="No matching sets"
                    description={
                        "Try searching for another " +
                        "artist or stage."
                    }
                />
            ) : (
                groupedSchedule && (
                    <PublicScheduleContent
                        schedule={
                            groupedSchedule
                        }
                        festivalId={festivalId}
                    />
                )
            )}
        </div>
    );
}
