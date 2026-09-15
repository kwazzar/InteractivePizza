import SwiftUI


extension PizzaSize {
    var title: String {
        switch self {
        case .small: return "S"
        case .medium: return "M"
        case .large: return "L"
        }
    }
    
    var imageSize: CGFloat {
        switch self {
        case .small: return 196
        case .medium: return 244
        case .large: return 274
        }
    }
}

struct SizeSelector: View {
    @Binding var selectedSize: PizzaSize?
    
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
    let size: PizzaSize
    @Binding var selectedSize: PizzaSize?
    let action: (PizzaSize) -> Void
    
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
    SizeSelector(selectedSize: .constant(.medium))
}
