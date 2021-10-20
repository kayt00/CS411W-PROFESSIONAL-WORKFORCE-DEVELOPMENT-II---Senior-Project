//
//  NetworkVlansView.swift
//  BlackBear
//
//  Created by Jeremy Fleshman on 2/7/21.
//

import SwiftUI

enum VlanAlert {
    case vlanAdded, vlanRemoved
}

struct NetworkVlansView: View {
    @EnvironmentObject var networkService: NetworkService
    @EnvironmentObject var userService: UserService
    @ObservedObject var viewModel: NetworkVlansViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showVLANAlert = false
    @State private var vlanAlert: VlanAlert = .vlanAdded
    @State private var showingDetail = false
    
    var body: some View {
        ZStack {
            List {
                Section(header: HStack {
                    Text("Default").modifier(SectionHeader())
                    Image(systemName: "gearshape.2").modifier(SFButton(color: Color.textHeaderPrimary))
                }) {
                /*ForEach(networkService.subdivisions) { subdivision in
                        if(subdivision.roleType == "default") {
                            VlanRow(subdivision: subdivision)
                        }
                 }*/
                    ForEach(viewModel.vlans) { vlan in
                      if vlan.id <= 4 {
                            VlanRow(subdivision: vlan)
                      }
                    }
                }
               Section(header: Text("Other / Random").modifier(SectionHeader())) {
                   /* ForEach(networkService.subdivisions) { subdivision in
                        if(subdivision.roleType == "other") {
                            VlanRow(subdivision: subdivision)
                        }
                    }*/
                /*
                    ForEach(viewModel.randomVlan) { vlan in
                        VlanRow(subdivision: vlan)
                    }
                 */
                    ForEach(viewModel.vlans) { vlan in
                      if vlan.id > 4 {
                            VlanRow(subdivision: vlan)
                       }
                    }
                }
            }.listStyle(GroupedListStyle())
            .alert(isPresented: $showVLANAlert) {
                switch vlanAlert {
                    case .vlanAdded:
                        return Alert(title: Text("Subdivision created!"))
                    case .vlanRemoved:
                        return Alert(title: Text("Subdivision suspended."))
                }
            }
            
            .navigationBarTitle(Text("Subdivisions"), displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action: {showingDetail.toggle()})
                                        {Image(systemName: "plus").modifier(SFButton(color: .success))})
                                        .sheet(isPresented: $showingDetail,
                                               onDismiss: { showVLANAlert = true }
                                        ) {
                                            NetworkVlansAddVlanView(viewModel: NetworkVlansAddVlanViewModel(networkService: networkService))
                                        }
        }
        .onAppear {
            self.viewModel.setup(self.userService, self.networkService)
            self.viewModel.allVlans()
           // self.viewModel.fetchRandomVlans()
        }.onReceive(networkService.$vlanAdded) { _ in
            vlanAlert = .vlanAdded
        }.onReceive(networkService.$vlanRemoved) { 
            vlanAlert = .vlanRemoved
            showVLANAlert = $0
        }
    }
}

struct NetworkVlansView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkVlansView(viewModel: NetworkVlansViewModel())
            .environmentObject(NetworkService())
    }
}

struct VlanRow: View {
    var subdivision: vlan

    var body: some View {
        NavigationLink(destination: NetworkVlanDetailView(selectedVlan: subdivision, viewModel: NetworkVlanDetailViewModel())) {
            VStack(alignment: .leading) {
               Text(subdivision.VlanName).modifier(SecondaryLabel())
            }.modifier(LabelContents())
        }.modifier(NavigationTab())
    }
}

