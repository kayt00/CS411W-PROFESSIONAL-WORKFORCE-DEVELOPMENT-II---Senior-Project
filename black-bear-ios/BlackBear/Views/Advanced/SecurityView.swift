//
//  SecurityView.swift
//  BlackBear
//
//  Created by Katie Taylor on 2/7/21.
//

import SwiftUI

struct SecurityView: View {
    @EnvironmentObject var networkService: NetworkService
    @ObservedObject var viewModel: SecurityViewModel
    
    var body: some View {
        List {
            Section(header: HStack {
                Text("IP Blacklist by Country").modifier(SectionHeader())
                Image(systemName: "globe").modifier(SFButton(color: .textHeaderPrimary))
            }) {
                ForEach(networkService.blacklists) { blacklist in
                    HStack {
                        BlacklistRow(blacklist: blacklist)
                        Button(action: {viewModel.removeBlacklistIP()}) {
                            Image(systemName: "xmark.circle.fill").modifier(SFButton(color: .error))
                        }
                    }
                }
            }.modifier(ListRowStyling())
        }
        .navigationBarTitle(Text("Security"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {viewModel.addBlacklistIP()}) {Image(systemName: "plus").modifier(SFButton(color: .success))})
        .listStyle(GroupedListStyle())
        .onAppear {
            self.viewModel.setup(self.networkService)
        }
    }
}

struct SecurityView_Previews: PreviewProvider {
    static var previews: some View {
        SecurityView(viewModel: SecurityViewModel())
            .environmentObject(NetworkService())
    }
}

struct BlacklistRow: View {
    var blacklist: Blacklist
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(blacklist.countryName).modifier(SecondaryLabel())
        }
    }
}
