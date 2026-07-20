import type { ScheduleView } from "./scheduleTypes";

type ScheduleToolbarProps = {
    search: string;
    view: ScheduleView;
    onSearchChange: (search: string) => void;
    onViewChange: (view: ScheduleView) => void;
};

export default function ScheduleToolbar({
                                            search,
                                            view,
                                            onSearchChange,
                                            onViewChange,
                                        }: ScheduleToolbarProps) {
    return (
        <div
            className="
                flex
                flex-col
                gap-4
                lg:flex-row
                lg:items-center
                lg:justify-between
            "
        >
            <input
                type="search"
                value={search}
                onChange={(event) =>
                    onSearchChange(event.target.value)
                }
                placeholder="Search artists or stages"
                className="
                    w-full
                    rounded-xl
                    border
                    border-[var(--color-border)]
                    bg-[var(--color-surface)]
                    px-4
                    py-3
                    outline-none
                    transition
                    focus:border-[var(--color-primary)]
                    lg:max-w-md
                "
            />

            <div
                className="
                    inline-flex
                    w-fit
                    rounded-xl
                    border
                    border-[var(--color-border)]
                    bg-[var(--color-surface)]
                    p-1
                "
            >
                <ViewButton
                    label="List"
                    active={view === "list"}
                    onClick={() => onViewChange("list")}
                />

                <ViewButton
                    label="Day"
                    active={view === "day"}
                    onClick={() => onViewChange("day")}
                />

                <ViewButton
                    label="Stage"
                    active={view === "stage"}
                    onClick={() => onViewChange("stage")}
                />
                <ViewButton
                    label="Timeline"
                    active={view === "timeline"}
                    onClick={() => onViewChange("timeline")}
                />
            </div>
        </div>
    );
}

type ViewButtonProps = {
    label: string;
    active: boolean;
    onClick: () => void;
};

function ViewButton({
                        label,
                        active,
                        onClick,
                    }: ViewButtonProps) {
    return (
        <button
            type="button"
            onClick={onClick}
            className={`
                rounded-lg
                px-4
                py-2
                text-sm
                font-medium
                transition
                ${
                active
                    ? `
                            bg-[var(--color-primary)]
                            text-white
                        `
                    : `
                            text-[var(--color-text-muted)]
                            hover:bg-[var(--color-surface-alt)]
                            hover:text-[var(--color-text)]
                        `
            }
            `}
        >
            {label}
        </button>
    );
}