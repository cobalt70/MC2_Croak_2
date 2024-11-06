//
//  NotificatePostureLiveActivity.swift
//  NotificatePosture
//
//  Created by jeong hyein on 5/11/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct NotificatePostureAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var posture: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct NotificatePostureLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NotificatePostureAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("\(context.state.posture)")
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
                    Text("Bottom \(context.state.posture)")
                    // more content
                }
            } compactLeading: {
                Text("30분 이상")
            } compactTrailing: {
                Text(context.state.posture)
            } minimal: {
                Text(context.state.posture)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

//extension NotificatePostureAttributes {
//    fileprivate static var preview: NotificatePostureAttributes {
//        NotificatePostureAttributes(name: "World")
//    }
//}
//
//extension NotificatePostureAttributes.ContentState {
//    fileprivate static var smiley: NotificatePostureAttributes.ContentState {
//        NotificatePostureAttributes.ContentState(emoji: "😀")
//     }
//     
//     fileprivate static var starEyes: NotificatePostureAttributes.ContentState {
//         NotificatePostureAttributes.ContentState(emoji: "🤩")
//     }
//}
//
//#Preview("Notification", as: .content, using: NotificatePostureAttributes.preview) {
//   NotificatePostureLiveActivity()
//} contentStates: {
//    NotificatePostureAttributes.ContentState.smiley
//    NotificatePostureAttributes.ContentState.starEyes
//}
