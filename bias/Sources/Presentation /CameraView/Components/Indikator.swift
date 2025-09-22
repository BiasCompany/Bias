//
//  Indikator.swift
//  bias
//
//  Created by Shafa Tiara Tsabita Himawan on 19/09/25.
//


import SwiftUI

public enum CheckState { case good, bad }

public enum StatusItem {
    case face, light, accessories

    var goodAsset: String {
        switch self {
        case .face:        return "faceGreen"
        case .light:       return "lampGreen"
        case .accessories: return "glassGreen"
        }
    }
    var badAsset: String {
        switch self {
        case .face:        return "faceRed"
        case .light:       return "lampRed"
        case .accessories: return "glassRed"
        }
    }
}

struct StatusDot: View {
    let item: StatusItem
    let state: CheckState
    var size: CGFloat = 65

    private var bgColor: Color {
        state == .good ? Color("green") : Color("red")
    }
    private var iconImage: Image {
        state == .good ? Image(item.goodAsset) : Image(item.badAsset)
    }

    var body: some View {
        ZStack {
            Circle().fill(bgColor)
            iconImage
                .resizable()
                .renderingMode(.original)
                .scaledToFit()
                .frame(width: size * 0.52, height: size * 0.52)
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.white.opacity(0.12), lineWidth: 1))
        .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 3)
        .accessibilityHidden(true)
    }
}

public struct CaptureStatusBar: View {
    public var face: CheckState
    public var light: CheckState
    public var accessories: CheckState

    public init(face: CheckState, light: CheckState, accessories: CheckState) {
        self.face = face
        self.light = light
        self.accessories = accessories
    }

    public var body: some View {
        HStack(spacing: 20) {
            StatusDot(item: .face,        state: face)
            StatusDot(item: .light,       state: light)
            StatusDot(item: .accessories, state: accessories)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.black.opacity(0.25))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
        .padding(.horizontal, 24)
    }
}

public struct CaptureStatusWithGuidance: View {
    public var face: CheckState
    public var light: CheckState
    public var accessories: CheckState

    public var priority: [StatusItem] = [.face, .light, .accessories]

    @State private var lastMessage: String?

    public init(
        face: CheckState,
        light: CheckState,
        accessories: CheckState,
        priority: [StatusItem] = [.face, .light, .accessories]
    ) {
        self.face = face
        self.light = light
        self.accessories = accessories
        self.priority = priority
    }

    public var body: some View {
        VStack(spacing: 16) {
            if let message = guidanceMessage() {
                Text(message)
                    .font(.system(size: 20, weight: .semibold, design: .monospaced))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .kerning(1)
                    .lineSpacing(4)
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
                    .animation(.easeInOut(duration: 0.25), value: message)
                    .onAppear { lastMessage = message }
                    .onChange(of: message) { _, new in
                        lastMessage = new
                    }
                    .padding(.bottom, 110)
            } else {
                EmptyView()
            }
            CaptureStatusBar(face: face, light: light, accessories: accessories)
        }
    }

    private func guidanceMessage() -> String? {
        for item in priority {
            switch item {
            case .face where face == .bad:
                return "SHOW YOUR ENTIRE FACE"
            case .light where light == .bad:
                return "ADJUST YOUR BRIGHTNESS"
            case .accessories where accessories == .bad:
                return "TAKE OFF YOUR ACCESSORIES\n(EX: GLASSES, HAT, ETC)"
            default:
                continue
            }
        }
        return nil
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack {
            Spacer()
            CaptureStatusWithGuidance(
                face: .bad,
                light: .bad,
                accessories: .good
            )
            .padding(.bottom, 24)
        }
    }
}
