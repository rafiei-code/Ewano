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
    
    var user: UserService {
        let provider = NetworkProvider<UserEndpoint>()
        return UserServiceImpl(client: provider)
    }
}
