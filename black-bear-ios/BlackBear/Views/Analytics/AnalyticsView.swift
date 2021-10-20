//
//  AnalyticsView.swift
//  Black Bear
//
//  Created by Jeremy Fleshman on 2/6/21.
//
#warning("TODO: Collect actual network data values")
import SwiftUI

struct AnalyticsView: View {
    @EnvironmentObject var networkService: NetworkService
    @ObservedObject var viewModel: AnalyticsViewModel
    
    @State var pickerSelection = 0

    var body: some View {
        ZStack {
            Color.theme
            VStack{
                VStack {
                    Text("Subdivision Usage").modifier(GraphTitle())
                    Text("(Megabytes of data)").modifier(GraphTitleUnits())
                }
                .padding()
                Picker(selection: $pickerSelection, label: Text("Stats"))
                {
                    Text("Download").tag(0)
                    Text("Upload").tag(1)
                }.modifier(GraphPickerStyling())

                HStack(alignment: .center, spacing: 10)
                {
                    ForEach(networkService.barValues[pickerSelection], id: \.self){
                        data in
                        
                        BarView(value: data, cornerRadius: 8)
                    }
                }.padding(.top, 24).animation(.default)
                
                GraphVLANCategories()
            }
        }
        .onAppear {
            self.viewModel.setup(self.networkService)
        }
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView(viewModel: AnalyticsViewModel())
            .environmentObject(NetworkService())
    }
}

struct BarView: View {
    var value: CGFloat
    var cornerRadius: CGFloat
    
    var body: some View {
        VStack {
            ZStack (alignment: .bottom) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .frame(width: 60, height: 200).foregroundColor(Color.theme)
                RoundedRectangle(cornerRadius: cornerRadius)
                    .frame(width: 60, height: value).foregroundColor(Color.success)
                Spacer()
            }.padding(.bottom, 8)
        }
    
    }
}

struct GraphVLANCategories: View {
    var body: some View {
        HStack {
            VStack {
                Text("PC &")
                Text("Phones")
            }.frame(width: 60)
            VStack {
                Text("Smart")
                Text("Home")
            }.frame(width: 60)
            VStack {
                Text("Gaming")
                Text("& TV")
            }.frame(width: 60)
            Text("Guest").frame(width: 60)
        }.modifier(GraphCategoriesStyling())
    }
}

