//
//  VehicleSwitcher.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/28.
//

import SwiftUI

struct VehicleSwitcher: View {
    let cars: [CarModel]
    @Binding var selectedCarID: Int?

    private var selectedCar: CarModel? {
        cars.first { $0.id == selectedCarID }
    }

    var body: some View {
        Menu {
            Picker("Vehicle", selection: $selectedCarID) {
                ForEach(cars, id: \.id) { car in
                    Text(Self.displayName(car)).tag(Optional(car.id))
                }
            }
        } label: {
            HStack(spacing: 6) {
                Image(.icDirectionsCar)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(.svPrimary)
                Text(selectedCar.map(Self.displayName) ?? "Select vehicle")
                    .font(.svLabel)
                    .bold()
                    .foregroundStyle(.svOnSurface)
                    .lineLimit(1)
                Image(.icArrowDropDown)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(.svOutline)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background {
                Capsule()
                    .fill(.svSurfaceLowest)
                    .shadow(color: .black.opacity(0.06), radius: 2, y: 1)
            }
        }
        .accessibilityLabel("Vehicle")
        .accessibilityValue(selectedCar.map(Self.displayName) ?? "None")
    }

    nonisolated static func displayName(_ car: CarModel) -> String {
        return car.name
    }

    nonisolated static func displayName(_ car: Car) -> String {
        if let year = car.carManufacturingYears.first?.year {
            return "\(year) \(car.name)"
        }
        return car.name
    }
}

#Preview {
    VehicleSwitcher(cars: CarModel.samples, selectedCarID: .constant(CarModel.samples.first?.id))
        .padding()
        .background(.svSurface)
}
