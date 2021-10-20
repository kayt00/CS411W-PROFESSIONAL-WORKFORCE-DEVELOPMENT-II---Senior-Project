//
//  DashboardView.swift
//  Black Bear
//
//  Created by Jeremy Fleshman on 2/6/21.
//

import SwiftUI

enum Tabs: Int {
    case devices, network, analytics, advanced, profile
}

struct DashboardView: View {

    init() {
        UITabBar.appearance().backgroundColor = UIColor.darkGray
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Avenir", size: 20)!]
    }
    @State var selectedTab: Tabs = .devices
    @Environment(\.deeplink) var deeplink

    var body: some View {
        //TabView(selection: $selectedTab) {
        TabView() {
            Tab(imageName: "house",
                imageText: "Devices",
                tag: Tabs.devices.rawValue) { DevicesView(viewModel: DevicesViewModel()) }

            Tab(imageName: "icloud",
                imageText: "Network",
                tag: Tabs.network.rawValue) { NetworkView() }

            Tab(imageName: "timer",
                imageText: "Analytics",
                tag: Tabs.analytics.rawValue) { MetadataView(viewModel: MetadataViewModel()) }

            Tab(imageName: "exclamationmark.shield",
                imageText: "Advanced",
                tag: Tabs.advanced.rawValue) { AdvancedView() }

            Tab(imageName: "person",
                imageText: "Profile",
                tag: Tabs.profile.rawValue) { ProfileView(viewModel: ProfileViewModel()) }
        }
        .accentColor(Color.success)
        .onChange(of: deeplink) { deeplink in
            guard deeplink == .addDevice else { return }
            selectedTab = .devices
        }
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView().preferredColorScheme(.dark)
            .environmentObject(UserService())
            .environmentObject(NetworkService())
//            .previewLayout(.sizeThatFits)
    }
}

struct Tab<Content: View>: View {
    let content: Content
    let imageName: String
    let imageText: String
    let tag: Int

    init(imageName: String, imageText: String, tag: Int,
         @ViewBuilder content: @escaping () -> Content) {
        self.imageName = imageName
        self.imageText = imageText
        self.tag = tag
        self.content = content()
    }

    var body: some View {
        content
            .font(.title)
            .tabItem( {
                Image(systemName: imageName)
                Text(imageText)
            })
            .tag(tag)
    }
}
