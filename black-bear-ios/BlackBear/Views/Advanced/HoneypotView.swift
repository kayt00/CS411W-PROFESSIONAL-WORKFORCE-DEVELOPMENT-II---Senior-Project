//
//  HoneypotView.swift
//  BlackBear
//
//  Created by Katie Taylor on 2/7/21.
//

import SwiftUI

struct HoneypotView: View {
    @State private var attackAlertsOn = true
    @State private var removeAttackerOn = true
    @State private var blockAttackOn = true
    @EnvironmentObject var networkService: NetworkService
    @ObservedObject var viewModel: HoneypotViewModel
    
    var body: some View {
        List {
            Section(header: HStack {
                Text("IP").modifier(SectionHeader())
                Image(systemName: "globe").modifier(SFButton(color: .textHeaderPrimary))
            }) {
                Text("\(networkService.honeypot.ip)").modifier(SecondaryLabel())
            }.modifier(ListRowStyling())
            
            Section(header: HStack {
                Text("Open Ports").modifier(SectionHeader())
                Image(systemName: "wave.3.right").modifier(SFButton(color: .textHeaderPrimary))
            }) {
                
                ForEach(networkService.honeypot.ports, id: \.id) { port in
                    HStack {
                        Text("\(port.portNum)").modifier(SecondaryLabel())
                        Button(action: {viewModel.removePort()}) {
                            Image(systemName: "xmark.circle.fill").modifier(SFButton(color: .error))
                        }
                    }
                }
            }.modifier(ListRowStyling())
     /*Based off Todd's feedback, we may want to remove this whole section:
             -Push notification on attack
             -- Tough to decide whether something is really an attack, lot of work
    **/
            Section(header: HStack {
                Text("Notifications").modifier(SectionHeader())
                Image(systemName: "bell.badge").modifier(SFButton(color: .textHeaderPrimary))
            }) {
                HStack {
                    Toggle(isOn: $attackAlertsOn) {
                        Text("Push notifications when attacked").modifier(TertiaryLabel())
                    }
                    if networkService.honeypot.attackAlertsOn {
                        //TO DO
                    }
                }
                
                HStack {
                    Toggle(isOn: $removeAttackerOn) {
                        Text("Remove attacker from network").modifier(TertiaryLabel())
                    }
                    if networkService.honeypot.removeAttackerOn {
                        //TO DO
                    }
                }
                
                HStack {
                    Toggle(isOn: $blockAttackOn) {
                        Text("Block attacker's MAC & IP").modifier(TertiaryLabel())
                    }
                    if networkService.honeypot.blockAttackOn {
                        //TO DO
                    }
                }
            }.modifier(ListRowStyling())
        }
        .navigationBarTitle(Text("Honeypot"), displayMode: .inline)
       /* .navigationBarItems(trailing: Button(action: {viewModel.addPort()}) {
            Image(systemName: "plus").modifier(SFButton(color: .success))
        })
      */
        .listStyle(GroupedListStyle())
        .onAppear {
            self.viewModel.setup(self.networkService)
        }
    }
}

struct HoneypotView_Previews: PreviewProvider {
    static var previews: some View {
        HoneypotView(viewModel: HoneypotViewModel())
            .environmentObject(NetworkService())
    }
}
