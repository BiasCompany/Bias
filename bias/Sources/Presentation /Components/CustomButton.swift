import SwiftUI

enum ButtonVariant {
    case active
    case disabled
}

struct CustomButton: View {
    
    let title: String
    let action: () -> Void
    
    var isFilled: Bool = true
    var isIconOnly: Bool = false
    var isLoading: Bool = false
    var iconName: String? = nil
    var variant: ButtonVariant = .active
    
    
    private var backgroundColor: Color {
        switch variant {
        case .active:   return .black
        case .disabled: return .gray
        }
    }
    
    private var progressViewColor: Color {
        switch variant {
        case .active:   return .white
        case .disabled: return .black
        }
    }
    
    private var foregroundColor: Color {
        if isFilled {
            return .white
        } else {
            return variant == .disabled ? .gray : .black
        }
    }
    
    
    var body: some View {
        Button(action: action) {
            Group {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: progressViewColor))
                        .scaleEffect(0.9)
                } else if isIconOnly, let iconName = iconName {
                    Image(systemName: iconName)
                } else {
                    Text(title)
                }
            }
            .font(.system(size: 16, weight: .medium, design: .monospaced))
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(isFilled ? backgroundColor : Color.white)
            .foregroundColor(foregroundColor)
            .overlay(
                Rectangle()
                    .stroke(Color.black, lineWidth: isFilled ? 0 : 1)
            )
            
        }
        .disabled(variant == .disabled || isLoading)
    }
}


#Preview {
    VStack(spacing: 16) {
        CustomButton(title: "CONTINUE", action: {})
        CustomButton(title: "I DON’T KNOW MY UNDERTONE", action: {}, isFilled: false)
        CustomButton(title: "", action: {}, isFilled: false, isIconOnly: true, iconName: "star")
        CustomButton(title: "NEXT", action: {}, isFilled: true, variant: .disabled)
        CustomButton(title: "LOADING", action: {}, isFilled: true, isLoading: true, variant: .disabled)
    }
    .padding()
}
