//
//  AdvancedView.swift
//  Black Bear
//
//  Created by Jeremy Fleshman on 2/6/21.
//

import SwiftUI

struct AdvancedView: View {
    var body: some View {
        ZStack {
            AdvancedList()
        }
    }
}

struct AdvancedView_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedView()
    }
}

struct AdvancedList: View {
   
    var body: some View {
        NavigationView {
         List {
            NavigationLink(destination: SecurityView(viewModel: SecurityViewModel())) {
                HStack {
                    Image(systemName: "lock.shield").modifier(SFButton(color: Color.textHeaderSecondary))
                    Text("Security").modifier(NavigationTabText())
                }
            }.modifier(NavigationTab())
            
            NavigationLink(destination: SSHServerView(viewModel: SSHServerViewModel())) {
                HStack {
                    Image(systemName: "terminal").modifier(SFButton(color: Color.textHeaderSecondary))
                    Text("SSH Server").modifier(NavigationTabText())
                }
            }.modifier(NavigationTab())
            
            NavigationLink(destination: HoneypotView(viewModel: HoneypotViewModel())) {
                HStack {
                    Image(systemName: "binoculars.fill").modifier(SFButton(color: Color.textHeaderSecondary))
                    Text("Honeypot").modifier(NavigationTabText())
                }
            }.modifier(NavigationTab())
          }
         .navigationBarTitle(Text("Advanced"), displayMode: .inline)
        }
    }
}





