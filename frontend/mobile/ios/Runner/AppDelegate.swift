import Flutter
import UIKit
import WidgetKit

@main
@objc class AppDelegate:
    FlutterAppDelegate {

    private static let widgetChannelName =
        "com.adam.festivalcompanion/widget"

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions
            launchOptions: [
                UIApplication
                    .LaunchOptionsKey: Any
            ]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(
            with: self
        )

        let didFinishLaunching =
            super.application(
                application,
                didFinishLaunchingWithOptions:
                    launchOptions
            )

        configureWidgetChannel()

        return didFinishLaunching
    }

    private func configureWidgetChannel() {
        guard let controller =
            window?.rootViewController
                as? FlutterViewController
        else {
            return
        }

        let channel = FlutterMethodChannel(
            name:
                Self.widgetChannelName,
            binaryMessenger:
                controller.binaryMessenger
        )

        channel.setMethodCallHandler {
            call,
            result in

            switch call.method {
            case "reloadTimeline":
                guard
                    let arguments =
                        call.arguments
                            as? [String: Any],
                    let kind =
                        arguments["kind"]
                            as? String,
                    !kind.isEmpty
                else {
                    result(
                        FlutterError(
                            code:
                                "INVALID_ARGUMENTS",
                            message:
                                "Widget kind is required.",
                            details: nil
                        )
                    )

                    return
                }

                WidgetCenter.shared
                    .reloadTimelines(
                        ofKind: kind
                    )

                result(nil)

            case "reloadAllTimelines":
                WidgetCenter.shared
                    .reloadAllTimelines()

                result(nil)

            default:
                result(
                    FlutterMethodNotImplemented
                )
            }
        }
    }
}