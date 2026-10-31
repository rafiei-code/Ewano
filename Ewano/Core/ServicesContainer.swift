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
    
    var auth: AuthService {
        AuthServiceImpl(client: NetworkProvider<AuthenticationEndpoint>())
    }

    var userProfile: UserProfileService {
        UserProfileServiceImpl(client: NetworkProvider<UserProfileEndpoint>())
    }

    var userCars: UserCarsService {
        UserCarsServiceImpl(client: NetworkProvider<UserCarsEndpoint>())
    }

    var users: UsersService {
        UsersServiceImpl(client: NetworkProvider<UsersEndpoint>())
    }

    var catalog: CatalogService {
        CatalogServiceImpl(client: NetworkProvider<CatalogEndpoint>())
    }
}
