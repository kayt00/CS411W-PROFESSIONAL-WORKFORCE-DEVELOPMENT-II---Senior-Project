//
//  NetworkView.swift
//  Black Bear
//
//  Created by Jeremy Fleshman on 2/6/21.
//

import SwiftUI

struct NetworkView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: NetworkGeneralView(viewModel: NetworkGeneralViewModel())) {
                    HStack {
                        Image(systemName: "wifi").modifier(SFButton(color: Color.textHeaderSecondary))
                        Text("General").modifier(NavigationTabText())
                    }
                }.modifier(NavigationTab())
                NavigationLink(destination: NetworkUsersView(viewModel: NetworkUsersViewModel())) {
                    HStack {
                        Image(systemName: "person.2.fill").modifier(SFButton(color: Color.textHeaderSecondary))
                        Text("Users").modifier(NavigationTabText())
                    }
                }.modifier(NavigationTab())
                NavigationLink(destination: NetworkVlansView(viewModel: NetworkVlansViewModel())) {
                    HStack {
                        Image(systemName: "arrow.branch").modifier(SFButton(color: Color.textHeaderSecondary))
                        Text("Subdivisions").modifier(NavigationTabText())
                    }
                }.modifier(NavigationTab())
            }
            .navigationBarTitle(Text("Network"), displayMode: .inline)
        }
    }
}

struct NetworkView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkView()
    }
}
/*
struct NetworkViewRow: View {
    var title: String

    var body: some View {
        Text(title).modifier(NavigationTabText())
    }
}
 */
 
