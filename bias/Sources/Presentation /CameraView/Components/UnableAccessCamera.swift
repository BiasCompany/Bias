//
//  UnableAccessCamera.swift
//  bias
//
//  Created by Shafa Tiara Tsabita Himawan on 19/09/25.
//

import SwiftUI

struct UnableAccessCamera: View {
    @Environment(\.openURL) private var openURL
    var onBack: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { onBack?() }) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
                .tint(.blue)
                .font(.system(size: 17, weight: .regular))
                .padding(.top, 8)
                .padding(.leading, 16)
                Spacer()
            }

            Spacer(minLength: 0)

            VStack(spacing: 16) {
                Text("UNABLE  TO\nACCESS  CAMERA")
                    .font(.system(size: 24, weight: .heavy, design: .monospaced))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .lineSpacing(4)
                    .kerning(1)

                Text("Foundie does not\ncurrently have permission\nto access your camera.")
                    .font(.system(size: 16, weight: .regular))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 32)

            Spacer()

            VStack(spacing: 12) {
                CustomButton(
                    title: "OPEN SETTINGS",
                    isFilled: false,
                    action: openCameraSettings
                )
                .padding(.horizontal, 24)
            }
            .padding(.bottom, 28)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }

    // MARK: - Actions
    
    private func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            openURL(url)
        }
    }

    private func openSystemCameraPrivacyPageIfPossible() -> Bool {
        guard let url = URL(string: "App-Prefs:root=Privacy&path=CAMERA")
                ?? URL(string: "prefs:root=Privacy&path=CAMERA") else { return false }
        return UIApplication.shared.canOpenURL(url) && UIApplication.shared.open(url, options: [:], completionHandler: nil) == ()
    }

    private func openCameraSettings() {
        #if DEBUG
        _ = openSystemCameraPrivacyPageIfPossible()
        #else
        openAppSettings()
        #endif
    }
}

#Preview {
    UnableAccessCamera()
}
