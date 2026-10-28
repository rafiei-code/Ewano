//
//  VehicleSwitcher.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/28.
//

import SwiftUI

struct VehicleSwitcher: View {
    let cars: [Car]
    @Binding var selectedCarID: String?

    private var selectedCar: Car? {
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

    static func displayName(_ car: Car) -> String {
        if let year = car.carManufacturingYears.first?.year {
            return "\(year) \(car.name)"
        }
        return car.name
    }
}

#Preview {
    @Previewable @State var selectedCarID: String? = UserModel.sample.cars.first?.id
    VehicleSwitcher(cars: UserModel.sample.cars, selectedCarID: $selectedCarID)
        .padding()
        .background(.svSurface)
}
