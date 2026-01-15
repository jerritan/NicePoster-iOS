import SwiftUI

struct ChatBubble: View {
    let message: ChatMessage
    var onImageTap: ((GeneratedImage) -> Void)? = nil
    var onImageAction: ((GeneratedImage, ImageAction) -> Void)? = nil
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if !message.isUser {
                // AI Avatar
                Image(systemName: "sparkles")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(NPColors.brandGradient)
                    .clipShape(Circle())
            } else {
                Spacer()
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 8) {
                if case .text = message.type {
                    Text(message.content)
                        .font(.system(size: 17))
                        .foregroundColor(message.isUser ? .white : NPColors.textPrimary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            message.isUser ? 
                            AnyView(NPColors.brandGradient) : 
                            AnyView(NPColors.bgSecondary)
                        )
                        .cornerRadius(16, corners: message.isUser ? [.topLeft, .bottomLeft, .bottomRight] : [.topRight, .bottomLeft, .bottomRight])
                }
                
                // Handle specific message types like Product Selection
                if case let .productSelection(products) = message.type {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(message.content)
                            .font(.system(size: 17))
                            .foregroundColor(NPColors.textPrimary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(products) { product in
                                    ProductCard(product: product)
                                }
                            }
                            .padding(.horizontal, 1) // Avoid clipping shadow
                        }
                    }
                    .padding(16)
                    .background(NPColors.bgSecondary)
                    .cornerRadius(16)
                }
                
                // Handle Style Selection
                if case let .styleSelection(options) = message.type {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(message.content)
                            .font(.system(size: 17))
                            .foregroundColor(NPColors.textPrimary)
                        
                        VStack(spacing: 10) {
                            ForEach(options) { option in
                                StyleOptionCard(option: option)
                            }
                        }
                    }
                    .padding(16)
                    .background(NPColors.bgSecondary)
                    .cornerRadius(16)
                }
                
                // Handle Thinking
                if case .thinking = message.type {
                    ThinkingBubble()
                }
                
                // Handle Image Results
                if case let .imageResult(images) = message.type {
                    ResultGridView(
                        images: images,
                        onImageTap: { selectedImage in
                            HapticManager.shared.mediumTap()
                            onImageTap?(selectedImage)
                        },
                        onImageAction: onImageAction
                    )
                }
            }
            
            if !message.isUser {
                Spacer()
            } else {
                // User Avatar
                Image(systemName: "person.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(Color.gray)
                    .clipShape(Circle())
            }
        }
    }
}

struct ProductCard: View {
    let product: Product
    @State private var isSelected = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Rectangle() // Placeholder for image
                .fill(Color.gray.opacity(0.2))
                .frame(height: 80)
                .overlay(
                    Image(systemName: "cup.and.saucer.fill")
                        .foregroundColor(.gray)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.system(size: 13, weight: .semibold))
                    .lineLimit(1)
                Text(product.price)
                    .font(.system(size: 12))
                    .foregroundColor(NPColors.textSecondary)
            }
            .padding(8)
        }
        .frame(width: 100)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? NPColors.brandPrimary : Color.clear, lineWidth: 2)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .onTapGesture {
            withAnimation {
                isSelected.toggle()
                HapticManager.shared.selection()
            }
        }
    }
}

// Helper for custom corner radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
