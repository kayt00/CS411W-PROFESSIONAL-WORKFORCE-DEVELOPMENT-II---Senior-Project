//
//  SSHServerViewModel.swift
//  BlackBear
//
//  Created by ktayl023 on 2/20/21.
//

import Combine

final class SSHServerViewModel: ObservableObject, Identifiable {
    var networkService: NetworkService?

    func setup(_ networkService: NetworkService) {
        self.networkService = networkService
    }

    func addSSH() {
     //not sure if were still including this feature
    }
    
    func updateSSHName() {
    
    }
}
