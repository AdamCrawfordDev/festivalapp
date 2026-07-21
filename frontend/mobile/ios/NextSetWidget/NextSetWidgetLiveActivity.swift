//
//  NextSetWidgetLiveActivity.swift
//  NextSetWidget
//
//  Created by builder on 7/21/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct NextSetWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct NextSetWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NextSetWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension NextSetWidgetAttributes {
    fileprivate static var preview: NextSetWidgetAttributes {
        NextSetWidgetAttributes(name: "World")
    }
}

extension NextSetWidgetAttributes.ContentState {
    fileprivate static var smiley: NextSetWidgetAttributes.ContentState {
        NextSetWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: NextSetWidgetAttributes.ContentState {
         NextSetWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: NextSetWidgetAttributes.preview) {
   NextSetWidgetLiveActivity()
} contentStates: {
    NextSetWidgetAttributes.ContentState.smiley
    NextSetWidgetAttributes.ContentState.starEyes
}
