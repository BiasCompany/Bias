//
//  BackButton.swift
//  lumi
//
//  Created by Adithya Firmansyah Putra on 22/09/25.
//
import SwiftUI

struct BackButton : View {
    @EnvironmentObject var router: Router
    var isWhite: Bool = false
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Button(action: { onTap != nil ? onTap!() : router.navigateBack() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(isWhite ? .white : .black)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
                    .accessibilityLabel("Back")
            }
            .buttonStyle(.plain)

            Spacer()
        }
    }
}
