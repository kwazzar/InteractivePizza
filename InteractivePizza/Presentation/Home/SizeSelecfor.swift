import SwiftUI

enum Size: String, CaseIterable {
    case small, medium, large
    
    var title: String {
        switch self {
        case .small: return "S"
        case .medium: return "M"
        case .large: return "L"
        }
        
    }
}

struct SizeSelector: View {
    @State private var selectedSize: Size? = .medium
    
    var body: some View {
        HStack(spacing: 45) {
            SizeButton(size: .small, selectedSize: $selectedSize) { _ in }
                .offset(y: -20)
            
            SizeButton(size: .medium, selectedSize: $selectedSize) { _ in }
            
            SizeButton(size: .large, selectedSize: $selectedSize) { _ in }
                .offset(y: -20)
        }
    }
}

struct SizeButton: View {
    let size: Size
    @Binding var selectedSize: Size?
    let action: (Size) -> Void
    
    var body: some View {
        Button(action: {
            selectedSize = size
            action(size)
        }) {
            Text(size.title.uppercased())
                .font(.figtree(.medium, size: 18))
                .lineSpacing(6)
                .tracking(-0.5)
                .foregroundStyle(selectedSize == size ? .white : .black)
                .frame(width: 48, height: 48)
                .background(
                    Circle()
                        .fill(selectedSize == size ? .black : .white)
                        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
                )
        }
    }
}

#Preview {
    SizeSelector()
}
