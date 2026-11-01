//
//  MaintenanceService.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 11/1/26.
//

protocol MaintenanceService {
}

struct MaintenanceServiceImpl: MaintenanceService {
    let client: NetworkProvider<CatalogEndpoint>
}
