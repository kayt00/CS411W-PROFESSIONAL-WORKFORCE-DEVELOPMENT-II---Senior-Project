//
//  NetworkVlanDetailView.swift
//  BlackBear
//
//  Created by ktayl023 on 2/11/21.
//

import SwiftUI

struct NetworkVlanDetailView: View {
    let selectedVlan: vlan
    @State var vlanSelectedToBeRemoved = false

    @EnvironmentObject var networkService: NetworkService
    @ObservedObject var viewModel: NetworkVlanDetailViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            List {
                Section {
                    VlanDetailRow(
                        label: "Created By",
                        data: selectedVlan.Creator.uuidString
                    )
                    // same issue as DeviceDetailView w/converting Date -> String
                    /*
                    VlanDetailRow(
                        label: "Created On",
                        data: selectedVlan.CreationTimeStamp
                    )
                    */
                    VlanDetailRow(
                        label: "Upload Limit",
                        data: "\(selectedVlan.UploadLimitMB) MB"
                    )
                    VlanDetailRow(
                        label: "Download Limit",
                        data: "\(selectedVlan.DownloadLimitMB) MB"
                    )
                    VlanDetailRow(
                        label: "Peak Upload Limit",
                        data: "\(selectedVlan.PeakUploadLimitMBps) MBps"
                    )
                    VlanDetailRow(
                        label: "Peak Download Limit",
                        data: "\(selectedVlan.PeakDownloadLimitMBps) MBps"
                    )
                }.modifier(ListRowStyling())
            }
            Spacer()
                .navigationBarTitle(Text(selectedVlan.VlanName), displayMode: .inline)
            // if(selectedVlan.roleType != "default") {
            if selectedVlan.id > 4 {
                Button(action: {vlanSelectedToBeRemoved = true}) {
                        Text("Suspend Subdivision")
                    }.alert(isPresented: $vlanSelectedToBeRemoved) {
                        vlanRemovalConfirmation(vlanSelection: selectedVlan)
                    }
                    .modifier(RemoveButton())
                .padding(.bottom, 20)
            }
           // }
        }.onAppear {
            self.viewModel.setup(self.networkService)
        }
      }
}
/*
struct NetworkVlanDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkVlanDetailView(selectedVlan: vlan(from: JSONDecoder()), viewModel: NetworkVlanDetailViewModel())
            .environmentObject(NetworkService())
    }
}
 */
 
struct VlanDetailRow: View {
    let label: String
    let data: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(label).modifier(SecondaryLabel())
            Text(data).modifier(LabelContents())
        }
        .font(.body)
    }
}

extension NetworkVlanDetailView {
    private func vlanRemovalConfirmation(vlanSelection: vlan) -> Alert {
        return Alert(
            title: Text("Are you sure you want to suspend the \(vlanSelection.VlanName) subdivision?"),
            message: Text("All devices that are authorized to the \(vlanSelection.VlanName) subdivision will automatically be disconnected and unauthorized from the home network."),
            primaryButton: .default(Text("Suspend")) {
            viewModel.removeCustomVlan(vlan: selectedVlan)
                presentationMode.wrappedValue.dismiss()
            },
            secondaryButton: .cancel()
        )
    }
}

