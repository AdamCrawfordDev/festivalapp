import { formatDayKey } from "./scheduleUtils";

type DayHeadingProps = {
    dayKey: string;
    secondary?: boolean;
};

export default function DayHeading({
                                       dayKey,
                                       secondary = false,
                                   }: DayHeadingProps) {
    if (secondary) {
        return (
            <h4
                className="
                    font-heading
                    text-lg
                    font-semibold
                    text-[var(--color-text-muted)]
                "
            >
                {formatDayKey(dayKey)}
            </h4>
        );
    }

    return (
        <h3
            className="
                font-heading
                text-2xl
                font-semibold
            "
        >
            {formatDayKey(dayKey)}
        </h3>
    );
}