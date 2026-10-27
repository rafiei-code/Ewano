//
//  CarManufacturingYearModel.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/27.
//

import Foundation

struct CarManufacturingYearModel: Codable {
    let id: String
    let year: Int
    let engineConfigurations: [EngineConfigurationModel]
    let carImageURl: String
    let transmissions: [TransmissionModel]
}
