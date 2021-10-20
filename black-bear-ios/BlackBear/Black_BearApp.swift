//
//  Black_BearApp.swift
//  Black Bear
//
//  Created by Jeremy Fleshman on 1/30/21.
//

import SwiftUI
import UserNotifications

@main
struct Black_BearApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @State var deeplink: DeeplinkHandler.Deeplink?

    var body: some Scene {
        WindowGroup {
            let userService = UserService()
            let networkService = NetworkService()
            if userService.userIsLoggedIn {
                DashboardView()
                    .environmentObject(userService)
                    .environmentObject(networkService)
                    .environment(\.deeplink, deeplink)
                    .onOpenURL { url in
                        handleDeeplink(for: url)
                    }
            } else {
                LoginView(viewModel: LoginViewModel())
                    .environmentObject(userService)
                    .environmentObject(networkService)
                    .environment(\.deeplink, deeplink)
                    .onOpenURL { url in
                        handleDeeplink(for: url)
                    }
            }
        }
    }
}

// MARK: - App Delegate
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    #warning("Push notifications are not guaranteed to arrive")
    // TODO: Implement backup solution for 2FA -- Local Notification?

    // Called when app isn't running and user taps notification that launches the app
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        registerForPushNotifications()

        // Check if app launched from a push notification
        let notificationOption = launchOptions?[.remoteNotification]

        if let notification = notificationOption as? [String: AnyObject],
           let aps = notification["aps"] as? [String: AnyObject] {
            print("aps: \(aps)")
        }

        UNUserNotificationCenter.current().delegate = self

        return true
    }

    // Note: Simulator will not provide a valid push token
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        #warning("TODO: Token needs to be sent to BB server for sending push notifications")
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("Failed to register: \(error.localizedDescription)")
    }

    // called when user interacts with a push notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("called UNC didReceive:")

        handleNotificationWithLink(for: response.notification)
        completionHandler()
    }

    // called when app is in foreground and notification is received
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("called UNC willPresent:")

        completionHandler([.banner, .badge])
    }

    fileprivate func handleNotificationWithLink(for notification: UNNotification) {
        guard
            let aps = notification.request.content.userInfo["aps"] as? [String: AnyObject],
            let url = URL(string: aps["link_url"] as! String)
        else { return }
        print(aps)

        #warning("Eval if added device can be injected into environment")

        UIApplication.shared.open(url)
    }

    fileprivate func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, _ in
                print("Permission granted: \(granted)")
                guard let self = self else { return }
                guard granted else { return }
                self.getNotificationSettings()
            }
    }

    fileprivate func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

// MARK: Deeplink Handling
extension Black_BearApp {
    func handleDeeplink(for url: URL) {
        let deeplinkHandler = DeeplinkHandler()
        guard
            let deeplink = deeplinkHandler.manage(url: url)
        else { return }
        self.deeplink = deeplink

        // reset environmentValue for future deep links
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
            self.deeplink = nil
        }
    }
}
