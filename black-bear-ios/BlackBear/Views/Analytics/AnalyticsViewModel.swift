//
//  AnalyticsViewModel.swift
//  BlackBear
//
//  Created by ktayl023 on 2/20/21.
//

import Combine

final class AnalyticsViewModel: ObservableObject, Identifiable {
    var networkService: NetworkService?

    func setup(_ networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func updateGraph() {
        // I'm not sure what functions will be here - maybe update analytic values onAppear and display values in graph form?
    }
}
