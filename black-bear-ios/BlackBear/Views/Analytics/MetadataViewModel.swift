//
//  MetadataViewModel.swift
//  BlackBear
//
//  Created by ktayl023 on 2/20/21.
//

import Combine

final class MetadataViewModel: ObservableObject, Identifiable {
    var networkService: NetworkService?

    func setup(_ networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func updateMetadata() {
        // I'm not sure what functions will be here - maybe update metadata values onAppear and display?
    }
}
