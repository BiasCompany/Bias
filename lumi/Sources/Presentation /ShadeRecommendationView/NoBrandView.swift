import SwiftUI

struct NoBrandView: View {
    var body: some View {
        VStack(spacing: 20) {
            
            Image("iconnobrand")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 100)
            
            Text("NO SHADES FOUND")
                .font(.title2.monospaced())
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("We couldn’t find any shades that match your skin tone.")
                .font(.callout)
                .fontWeight(.regular)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NoBrandView()
}
