//
//  DependencyContainer.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 10/28/26.
//

import Foundation

final public class Services {
    public static var shared: Services = .init()
    
    private init() {}
    
    var login: UserService {
        let provider = NetworkProvider<AuthenticationEndpoint>()
        return UserServiceImpl(client: provider)
    }
}
