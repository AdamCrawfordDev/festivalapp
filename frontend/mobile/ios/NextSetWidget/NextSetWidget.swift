import Foundation
import SwiftUI
import WidgetKit

// MARK: - API models

struct WidgetScheduleResponse: Decodable {
    let generatedAt: Date?
    let currentSet: FestivalWidgetSet?
    let nextSet: FestivalWidgetSet?
    let sets: [FestivalWidgetSet]

    enum CodingKeys: String, CodingKey {
        case generatedAt = "generated_at"
        case currentSet = "current_set"
        case nextSet = "next_set"
        case sets
    }
}

struct FestivalWidgetSet: Decodable, Identifiable, Hashable {
    let id: Int
    let festivalId: Int
    let festivalName: String
    let artistName: String
    let stageName: String
    let startTime: Date
    let endTime: Date
    let displayImage: String?
    let status: String

    enum CodingKeys: String, CodingKey {
        case id
        case festivalId = "festival_id"
        case festivalName = "festival_name"
        case artistName = "artist_name"
        case stageName = "stage_name"
        case startTime = "start_time"
        case endTime = "end_time"
        case displayImage = "display_image"
        case status
    }
}

// MARK: - Date decoding

extension JSONDecoder {
    static var widgetDecoder: JSONDecoder {
        let decoder = JSONDecoder()

        decoder.dateDecodingStrategy = .custom {
            decoder in

            let container =
                try decoder.singleValueContainer()

            let value =
                try container.decode(String.self)

            let fractionalFormatter =
                ISO8601DateFormatter()

            fractionalFormatter.formatOptions = [
                .withInternetDateTime,
                .withFractionalSeconds,
            ]

            if let date =
                fractionalFormatter.date(
                    from: value
                ) {
                return date
            }

            let standardFormatter =
                ISO8601DateFormatter()

            standardFormatter.formatOptions = [
                .withInternetDateTime,
            ]

            if let date =
                standardFormatter.date(
                    from: value
                ) {
                return date
            }

            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription:
                    "Unable to decode ISO-8601 date: \(value)"
            )
        }

        return decoder
    }
}

// MARK: - API client

enum WidgetAPIError:
    LocalizedError {
    case invalidURL
    case invalidResponse
    case requestFailed(Int)
    case emptyToken

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The widget API URL is invalid."

        case .invalidResponse:
            return "The server returned an invalid response."

        case .requestFailed(let statusCode):
            return (
                "The widget API request failed "
                + "with status \(statusCode)."
            )

        case .emptyToken:
            return "The widget token is missing."
        }
    }
}

struct WidgetAPIClient {
    func fetchSchedule() async throws
        -> WidgetScheduleResponse {
        guard
            !WidgetBuildConfig.apiToken
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
                .isEmpty
        else {
            throw WidgetAPIError.emptyToken
        }

        guard let url = URL(
            string: WidgetBuildConfig.apiURL
        ) else {
            throw WidgetAPIError.invalidURL
        }

        var request = URLRequest(
            url: url
        )

        request.httpMethod = "GET"

        request.timeoutInterval = 15

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Accept"
        )

        request.setValue(
            "WidgetToken "
                + WidgetBuildConfig.apiToken,
            forHTTPHeaderField:
                "Authorization"
        )

        let configuration =
            URLSessionConfiguration
                .ephemeral

        configuration.timeoutIntervalForRequest =
            15

        configuration.timeoutIntervalForResource =
            20

        let session = URLSession(
            configuration: configuration
        )

        let (
            data,
            response
        ) = try await session.data(
            for: request
        )

        guard let httpResponse =
            response as? HTTPURLResponse
        else {
            throw WidgetAPIError
                .invalidResponse
        }

        guard
            (200 ... 299)
                .contains(
                    httpResponse.statusCode
                )
        else {
            throw WidgetAPIError.requestFailed(
                httpResponse.statusCode
            )
        }

        let decoded =
            try JSONDecoder
                .widgetDecoder
                .decode(
                    WidgetScheduleResponse.self,
                    from: data
                )

        return WidgetScheduleResponse(
            generatedAt:
                decoded.generatedAt,
            currentSet:
                decoded.currentSet,
            nextSet:
                decoded.nextSet,
            sets:
                decoded.sets.sorted {
                    lhs,
                    rhs in

                    if lhs.startTime ==
                        rhs.startTime {
                        return lhs.id <
                            rhs.id
                    }

                    return lhs.startTime <
                        rhs.startTime
                }
        )
    }
}

// MARK: - Timeline entry

struct NextSetEntry: TimelineEntry {
    let date: Date
    let schedule: WidgetScheduleResponse?
    let errorMessage: String?

    static var placeholder:
        NextSetEntry {
        let now = Date()

        let placeholderSet =
            FestivalWidgetSet(
                id: 1,
                festivalId: 1,
                festivalName:
                    "Festival Companion",
                artistName:
                    "Your next artist",
                stageName:
                    "Main Stage",
                startTime:
                    now.addingTimeInterval(
                        30 * 60
                    ),
                endTime:
                    now.addingTimeInterval(
                        90 * 60
                    ),
                displayImage: nil,
                status: "upcoming"
            )

        return NextSetEntry(
            date: now,
            schedule:
                WidgetScheduleResponse(
                    generatedAt: now,
                    currentSet: nil,
                    nextSet:
                        placeholderSet,
                    sets: [
                        placeholderSet,
                    ]
                ),
            errorMessage: nil
        )
    }

    static func failure(
        at date: Date,
        message: String
    ) -> NextSetEntry {
        NextSetEntry(
            date: date,
            schedule: nil,
            errorMessage: message
        )
    }
}

// MARK: - Timeline provider

struct NextSetProvider:
    TimelineProvider {
    private let apiClient =
        WidgetAPIClient()

    func placeholder(
        in context: Context
    ) -> NextSetEntry {
        .placeholder
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (
            NextSetEntry
        ) -> Void
    ) {
        if context.isPreview {
            completion(
                .placeholder
            )

            return
        }

        Task {
            do {
                let schedule =
                    try await apiClient
                        .fetchSchedule()

                completion(
                    NextSetEntry(
                        date: Date(),
                        schedule: schedule,
                        errorMessage: nil
                    )
                )
            } catch {
                completion(
                    .failure(
                        at: Date(),
                        message:
                            "Unable to update"
                    )
                )
            }
        }
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (
            Timeline<NextSetEntry>
        ) -> Void
    ) {
        Task {
            let now = Date()

            do {
                let schedule =
                    try await apiClient
                        .fetchSchedule()

                let dates =
                    timelineDates(
                        schedule: schedule,
                        now: now
                    )

                let entries =
                    dates.map {
                        entryDate in

                        NextSetEntry(
                            date: entryDate,
                            schedule:
                                schedule,
                            errorMessage: nil
                        )
                    }

                let requestedRefresh =
                    nextRefreshDate(
                        schedule: schedule,
                        now: now
                    )

                completion(
                    Timeline(
                        entries: entries,
                        policy: .after(
                            requestedRefresh
                        )
                    )
                )
            } catch {
                let entry =
                    NextSetEntry.failure(
                        at: now,
                        message:
                            "Unable to update"
                    )

                completion(
                    Timeline(
                        entries: [
                            entry,
                        ],
                        policy: .after(
                            now.addingTimeInterval(
                                15 * 60
                            )
                        )
                    )
                )
            }
        }
    }

    private func timelineDates(
        schedule: WidgetScheduleResponse,
        now: Date
    ) -> [Date] {
        var dates: Set<Date> = [
            now,
        ]

        for festivalSet
            in schedule.sets {
            guard
                festivalSet.endTime >
                    now
            else {
                continue
            }

            let reminderDate =
                festivalSet.startTime
                    .addingTimeInterval(
                        -15 * 60
                    )

            if reminderDate > now {
                dates.insert(
                    reminderDate
                )
            }

            if festivalSet.startTime >
                now {
                dates.insert(
                    festivalSet.startTime
                )
            }

            if festivalSet.endTime >
                now {
                dates.insert(
                    festivalSet.endTime
                )
            }
        }

        return dates
            .sorted()
            .prefix(40)
            .map {
                $0
            }
    }

    private func nextRefreshDate(
        schedule: WidgetScheduleResponse,
        now: Date
    ) -> Date {
        let normalRefresh =
            now.addingTimeInterval(
                30 * 60
            )

        let nextBoundary =
            schedule.sets
                .flatMap {
                    festivalSet in

                    [
                        festivalSet
                            .startTime,
                        festivalSet
                            .endTime,
                    ]
                }
                .filter {
                    $0 > now
                }
                .min()

        guard let nextBoundary else {
            return normalRefresh
        }

        return min(
            normalRefresh,
            nextBoundary
                .addingTimeInterval(
                    60
                )
        )
    }
}

// MARK: - Schedule selection

extension NextSetEntry {
    var remainingSets:
        [FestivalWidgetSet] {
        guard let schedule else {
            return []
        }

        return schedule.sets
            .filter {
                $0.endTime > date
            }
            .sorted {
                lhs,
                rhs in

                if lhs.startTime ==
                    rhs.startTime {
                    return lhs.id <
                        rhs.id
                }

                return lhs.startTime <
                    rhs.startTime
            }
    }

    var currentSet:
        FestivalWidgetSet? {
        remainingSets.first {
            festivalSet in

            festivalSet.startTime
                <= date
            &&
            festivalSet.endTime
                > date
        }
    }

    var nextSet:
        FestivalWidgetSet? {
        remainingSets.first {
            $0.startTime > date
        }
    }

    var primarySet:
        FestivalWidgetSet? {
        currentSet ?? nextSet
    }

    var primaryIsLive: Bool {
        currentSet != nil
    }
}

// MARK: - Shared formatting

enum WidgetFormatters {
    static let time:
        DateFormatter = {
        let formatter =
            DateFormatter()

        formatter.dateStyle = .none
        formatter.timeStyle = .short

        return formatter
    }()

    static let day:
        DateFormatter = {
        let formatter =
            DateFormatter()

        formatter.setLocalizedDateFormatFromTemplate(
            "EEE d MMM"
        )

        return formatter
    }()
}

// MARK: - Main widget view

struct NextSetWidgetEntryView:
    View {
    @Environment(
        \.widgetFamily
    )
    private var family

    let entry: NextSetEntry

    var body: some View {
        Group {
            switch family {
            case .accessoryInline:
                AccessoryInlineView(
                    entry: entry
                )

            case .accessoryCircular:
                AccessoryCircularView(
                    entry: entry
                )

            case .accessoryRectangular:
                AccessoryRectangularView(
                    entry: entry
                )

            case .systemMedium:
                MediumScheduleView(
                    entry: entry
                )

            default:
                SmallScheduleView(
                    entry: entry
                )
            }
        }
        .containerBackground(
            .fill.tertiary,
            for: .widget
        )
    }
}

// MARK: - Lock Screen: inline

struct AccessoryInlineView:
    View {
    let entry: NextSetEntry

    var body: some View {
        if let festivalSet =
            entry.primarySet {
            if entry.primaryIsLive {
                Label(
                    "Now: "
                        + festivalSet
                            .artistName,
                    systemImage:
                        "music.note"
                )
            } else {
                Label(
                    festivalSet.artistName
                        + " "
                        + WidgetFormatters
                            .time
                            .string(
                                from:
                                    festivalSet
                                        .startTime
                            ),
                    systemImage:
                        "music.note"
                )
            }
        } else {
            Label(
                "No upcoming sets",
                systemImage:
                    "calendar.badge.checkmark"
            )
        }
    }
}

// MARK: - Lock Screen: circular

struct AccessoryCircularView:
    View {
    let entry: NextSetEntry

    var body: some View {
        if let festivalSet =
            entry.primarySet {
            VStack(
                spacing: 1
            ) {
                Image(
                    systemName:
                        entry.primaryIsLive
                            ? "waveform"
                            : "music.note"
                )
                .font(
                    .caption
                )

                Text(
                    WidgetFormatters
                        .time
                        .string(
                            from:
                                festivalSet
                                    .startTime
                        )
                )
                .font(
                    .caption2
                )
                .fontWeight(
                    .semibold
                )
                .minimumScaleFactor(
                    0.7
                )
            }
            .widgetAccentable()
        } else {
            Image(
                systemName:
                    "checkmark"
            )
            .widgetAccentable()
        }
    }
}

// MARK: - Lock Screen: rectangular

struct AccessoryRectangularView:
    View {
    let entry: NextSetEntry

    var body: some View {
        if let festivalSet =
            entry.primarySet {
            VStack(
                alignment: .leading,
                spacing: 2
            ) {
                Text(
                    entry.primaryIsLive
                        ? "NOW PLAYING"
                        : "NEXT SET"
                )
                .font(
                    .caption2
                )
                .fontWeight(
                    .bold
                )
                .widgetAccentable()

                Text(
                    festivalSet.artistName
                )
                .font(
                    .headline
                )
                .lineLimit(
                    1
                )
                .minimumScaleFactor(
                    0.75
                )

                Text(
                    WidgetFormatters
                        .time
                        .string(
                            from:
                                festivalSet
                                    .startTime
                        )
                    + " • "
                    + festivalSet.stageName
                )
                .font(
                    .caption
                )
                .lineLimit(
                    1
                )
            }
        } else {
            VStack(
                alignment: .leading,
                spacing: 3
            ) {
                Text(
                    "MY SCHEDULE"
                )
                .font(
                    .caption2
                )
                .fontWeight(
                    .bold
                )
                .widgetAccentable()

                Text(
                    "No upcoming sets"
                )
                .font(
                    .headline
                )

                Text(
                    "Enjoy the festival"
                )
                .font(
                    .caption
                )
            }
        }
    }
}

// MARK: - Home Screen: small

struct SmallScheduleView:
    View {
    let entry: NextSetEntry

    var body: some View {
        if let errorMessage =
            entry.errorMessage {
            WidgetErrorView(
                message: errorMessage
            )
        } else if let festivalSet =
            entry.primarySet {
            VStack(
                alignment: .leading,
                spacing: 7
            ) {
                HStack(
                    spacing: 5
                ) {
                    Image(
                        systemName:
                            entry.primaryIsLive
                                ? "waveform"
                                : "music.note"
                    )

                    Text(
                        entry.primaryIsLive
                            ? "NOW"
                            : "NEXT"
                    )
                    .fontWeight(
                        .bold
                    )

                    Spacer()
                }
                .font(
                    .caption
                )
                .foregroundStyle(
                    entry.primaryIsLive
                        ? .red
                        : .secondary
                )

                Text(
                    festivalSet.artistName
                )
                .font(
                    .title3
                )
                .fontWeight(
                    .bold
                )
                .lineLimit(
                    2
                )
                .minimumScaleFactor(
                    0.75
                )

                Spacer(
                    minLength: 2
                )

                Text(
                    WidgetFormatters
                        .time
                        .string(
                            from:
                                festivalSet
                                    .startTime
                        )
                )
                .font(
                    .title2
                )
                .fontWeight(
                    .semibold
                )

                Text(
                    festivalSet.stageName
                )
                .font(
                    .caption
                )
                .foregroundStyle(
                    .secondary
                )
                .lineLimit(
                    1
                )

                Text(
                    festivalSet.festivalName
                )
                .font(
                    .caption2
                )
                .foregroundStyle(
                    .tertiary
                )
                .lineLimit(
                    1
                )
            }
            .padding()
        } else {
            WidgetEmptyView()
        }
    }
}

// MARK: - Home Screen: medium

struct MediumScheduleView:
    View {
    let entry: NextSetEntry

    private var visibleSets:
        [FestivalWidgetSet] {
        Array(
            entry.remainingSets
                .prefix(3)
        )
    }

    var body: some View {
        if let errorMessage =
            entry.errorMessage {
            WidgetErrorView(
                message: errorMessage
            )
        } else if
            visibleSets.isEmpty {
            WidgetEmptyView()
        } else {
            VStack(
                alignment: .leading,
                spacing: 7
            ) {
                HStack {
                    Label(
                        entry.currentSet == nil
                            ? "UP NEXT"
                            : "MY SCHEDULE",
                        systemImage:
                            "music.note.list"
                    )
                    .font(
                        .caption
                    )
                    .fontWeight(
                        .bold
                    )

                    Spacer()

                    if let festival =
                        visibleSets
                            .first?
                            .festivalName {
                        Text(
                            festival
                        )
                        .font(
                            .caption2
                        )
                        .foregroundStyle(
                            .secondary
                        )
                        .lineLimit(
                            1
                        )
                    }
                }

                Divider()

                ForEach(
                    Array(
                        visibleSets
                            .enumerated()
                    ),
                    id: \.element.id
                ) {
                    index,
                    festivalSet in

                    MediumScheduleRow(
                        festivalSet:
                            festivalSet,
                        isLive:
                            entry.currentSet?
                                .id ==
                                festivalSet.id
                    )

                    if index <
                        visibleSets.count - 1 {
                        Divider()
                            .opacity(
                                0.5
                            )
                    }
                }
            }
            .padding()
        }
    }
}

struct MediumScheduleRow:
    View {
    let festivalSet:
        FestivalWidgetSet

    let isLive: Bool

    var body: some View {
        HStack(
            spacing: 10
        ) {
            VStack(
                alignment: .leading,
                spacing: 1
            ) {
                Text(
                    isLive
                        ? "NOW"
                        : WidgetFormatters
                            .time
                            .string(
                                from:
                                    festivalSet
                                        .startTime
                            )
                )
                .font(
                    .caption
                )
                .fontWeight(
                    .bold
                )
                .foregroundStyle(
                    isLive
                        ? .red
                        : .secondary
                )
                .frame(
                    width: 50,
                    alignment: .leading
                )
            }

            VStack(
                alignment: .leading,
                spacing: 1
            ) {
                Text(
                    festivalSet.artistName
                )
                .font(
                    .subheadline
                )
                .fontWeight(
                    .semibold
                )
                .lineLimit(
                    1
                )

                Text(
                    festivalSet.stageName
                )
                .font(
                    .caption2
                )
                .foregroundStyle(
                    .secondary
                )
                .lineLimit(
                    1
                )
            }

            Spacer()
        }
    }
}

// MARK: - Empty/error states

struct WidgetEmptyView:
    View {
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            Image(
                systemName:
                    "calendar.badge.checkmark"
            )
            .font(
                .title2
            )

            Text(
                "No upcoming sets"
            )
            .font(
                .headline
            )

            Text(
                "Like sets in Festival Companion "
                    + "to build your schedule."
            )
            .font(
                .caption
            )
            .foregroundStyle(
                .secondary
            )

            Spacer()
        }
        .padding()
    }
}

struct WidgetErrorView:
    View {
    let message: String

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            Image(
                systemName:
                    "wifi.exclamationmark"
            )
            .font(
                .title2
            )

            Text(
                message
            )
            .font(
                .headline
            )

            Text(
                "The widget will try again shortly."
            )
            .font(
                .caption
            )
            .foregroundStyle(
                .secondary
            )

            Spacer()
        }
        .padding()
    }
}

// MARK: - Widget declaration

struct NextSetWidget: Widget {
    static let kind =
        "NextSetWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: Self.kind,
            provider:
                NextSetProvider()
        ) {
            entry in

            NextSetWidgetEntryView(
                entry: entry
            )
        }
        .configurationDisplayName(
            "Festival Schedule"
        )
        .description(
            "Shows your live and upcoming "
                + "liked festival sets."
        )
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .accessoryInline,
            .accessoryCircular,
            .accessoryRectangular,
        ])
    }
}

#Preview(
    "Small",
    as: .systemSmall
) {
    NextSetWidget()
} timeline: {
    NextSetEntry.placeholder
}

#Preview(
    "Medium",
    as: .systemMedium
) {
    NextSetWidget()
} timeline: {
    NextSetEntry.placeholder
}

#Preview(
    "Lock Screen",
    as: .accessoryRectangular
) {
    NextSetWidget()
} timeline: {
    NextSetEntry.placeholder
}