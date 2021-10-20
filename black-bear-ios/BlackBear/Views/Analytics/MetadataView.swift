//
//  MetadataView.swift
//  BlackBear
//
//  Created by Katie Taylor on 2/7/21.
//
#warning("TODO: Collect actual network data values")
import SwiftUI

struct MetadataView: View {
    @EnvironmentObject var networkService: NetworkService
    @ObservedObject var viewModel: MetadataViewModel
    
    var body: some View {
        ZStack {
            NavigationView {
                List {
                  Section {
                    GraphDetail()
                    
                    HStack {
                        Image(systemName: "arrow.up.to.line.alt").modifier(SFButton(color: Color.textHeaderSecondary))
                        VStack(alignment: .leading) {
                            Text("Upload Speed").modifier(SecondaryLabel())
                            let formattedUploadSpeed = String(format: "%.0f", networkService.uploadSpeed)
                            Text("\(formattedUploadSpeed) mbps").modifier(LabelContents())
                        }
                    }
                    HStack {
                        Image(systemName: "icloud.and.arrow.up").modifier(SFButton(color: Color.textHeaderSecondary))
                        VStack(alignment: .leading) {
                            Text("Uploaded Data (Today)").modifier(SecondaryLabel())
                            let formattedUploadedData = String(format: "%.1f", networkService.uploadedData)
                            Text("\(formattedUploadedData) GB").modifier(LabelContents())
                        }
                    }
                    HStack {
                        Image(systemName: "arrow.down.to.line.alt").modifier(SFButton(color: Color.textHeaderSecondary))
                        VStack(alignment: .leading) {
                            Text("Download Speed").modifier(SecondaryLabel())
                            let formattedDownloadSpeed = String(format: "%.0f", networkService.downloadSpeed)
                            Text("\(formattedDownloadSpeed) mbps").modifier(LabelContents())
                        }
                    }
                    HStack {
                        Image(systemName: "icloud.and.arrow.down").modifier(SFButton(color: Color.textHeaderSecondary))
                        VStack(alignment: .leading) {
                            Text("Downloaded Data (Today)").modifier(SecondaryLabel())
                            let formattedDownloadedData = String(format: "%.1f", networkService.downloadedData)
                            Text("\(formattedDownloadedData) GB").modifier(LabelContents())
                        }
                    }
                    HStack {
                        Image(systemName: "laptopcomputer.and.iphone").modifier(SFButton(color: Color.textHeaderSecondary))
                        VStack(alignment: .leading) {
                            Text("Online Devices").modifier(SecondaryLabel())
                            Text("\(networkService.onlineDevices)").modifier(LabelContents())
                        }
                    }
                    HStack {
                        Image(systemName: "network").modifier(SFButton(color: Color.textHeaderSecondary))
                        VStack(alignment: .leading) {
                            Text("Network Strength").modifier(SecondaryLabel())
                            Text(networkService.networkStrength).modifier(LabelContents())
                        }
                    }
                  }
                    .modifier(ListRowStyling())
                }
                .navigationBarTitle(Text("Analytics"), displayMode: .inline)
            }
            .onAppear {
                self.viewModel.setup(self.networkService)
            }
        }
    }
}

struct MetadataView_Previews: PreviewProvider {
    static var previews: some View {
        MetadataView(viewModel: MetadataViewModel())
            .environmentObject(NetworkService())
    }
}

struct GraphDetail: View {
    var body: some View {
        NavigationLink(destination: AnalyticsView(viewModel: AnalyticsViewModel())) {
            HStack {
                Image(systemName: "chart.bar").modifier(SFButton(color: Color.success))
                Text("Analytics Graph").modifier(GraphNavigationTabLabel())
            }
        }
    }
}
