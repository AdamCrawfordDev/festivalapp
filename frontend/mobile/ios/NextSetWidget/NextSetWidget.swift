import SwiftUI
import WidgetKit

struct NextSetEntry: TimelineEntry {
    let date: Date
}

struct NextSetProvider: TimelineProvider {
    func placeholder(
        in context: Context
    ) -> NextSetEntry {
        NextSetEntry(
            date: Date()
        )
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (
            NextSetEntry
        ) -> Void
    ) {
        completion(
            NextSetEntry(
                date: Date()
            )
        )
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (
            Timeline<NextSetEntry>
        ) -> Void
    ) {
        let entry = NextSetEntry(
            date: Date()
        )

        let refreshDate =
            Calendar.current.date(
                byAdding: .minute,
                value: 30,
                to: Date()
            ) ?? Date()
                .addingTimeInterval(
                    1800
                )

        completion(
            Timeline(
                entries: [
                    entry,
                ],
                policy: .after(
                    refreshDate
                )
            )
        )
    }
}

struct NextSetWidgetView: View {
    let entry: NextSetEntry

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            Image(
                systemName:
                    "music.note"
            )
            .font(
                .title2
            )

            Text(
                "Festival Companion"
            )
            .font(
                .headline
            )

            Text(
                "Widget setup works"
            )
            .font(
                .caption
            )
            .foregroundStyle(
                .secondary
            )

            Spacer()

            Text(
                entry.date,
                style: .time
            )
            .font(
                .caption2
            )
        }
        .padding()
        .containerBackground(
            .fill.tertiary,
            for: .widget
        )
    }
}

struct NextSetWidget: Widget {
    let kind =
        "NextSetWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider:
                NextSetProvider()
        ) { entry in
            NextSetWidgetView(
                entry: entry
            )
        }
        .configurationDisplayName(
            "Next Set"
        )
        .description(
            "Shows your next saved festival set."
        )
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
        ])
    }
}

@main
struct NextSetWidgetBundle:
    WidgetBundle {
    var body: some Widget {
        NextSetWidget()
    }
}