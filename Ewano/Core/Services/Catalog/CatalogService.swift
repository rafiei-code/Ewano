//
//  CatalogService.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import Foundation

protocol CatalogService {
    func manufacturers() async throws -> [Manufacturer]
    func manufacturer(id: Int) async throws -> Manufacturer
    func models(manufacturerID: Int) async throws -> [ManufacturerModel]
    func engines(modelID: Int) async throws -> [ModelEngine]
    func engineMaintenance(engineID: Int) async throws -> EngineMaintenanceResponse
}

struct CatalogServiceImpl: CatalogService {
    let client: NetworkProvider<CatalogEndpoint>

    func manufacturers() async throws -> [Manufacturer] {
        try await client.request(.manufacturers)
    }

    func manufacturer(id: Int) async throws -> Manufacturer {
        try await client.request(.manufacturer(id: id))
    }

    func models(manufacturerID: Int) async throws -> [ManufacturerModel] {
        try await client.request(.models(manufacturerID: manufacturerID))
    }

    func engines(modelID: Int) async throws -> [ModelEngine] {
        try await client.request(.engines(modelID: modelID))
    }

    func engineMaintenance(engineID: Int) async throws -> EngineMaintenanceResponse {
        try await client.request(.engineMaintenance(engineID: engineID))
    }
}
