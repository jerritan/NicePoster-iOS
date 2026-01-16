import SwiftUI

// MARK: - Product Selection Drawer (Half-Sheet)
struct ProductSelectionDrawer: View {
    @Binding var isPresented: Bool
    @Binding var selectedProducts: Set<UUID>
    let products: [Product]
    
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Blurred Background
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .blur(radius: 0.5)
                    .onTapGesture {
                        dismissDrawer()
                    }
                    .transition(.opacity)
            }
            
            // Drawer
            VStack {
                Spacer()
                
                if isPresented {
                    drawerContent
                        .transition(.move(edge: .bottom))
                        .offset(y: max(0, dragOffset))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    if value.translation.height > 0 {
                                        dragOffset = value.translation.height
                                    }
                                }
                                .onEnded { value in
                                    if value.translation.height > 100 {
                                        dismissDrawer()
                                    } else {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                            dragOffset = 0
                                        }
                                    }
                                }
                        )
                }
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: isPresented)
    }
    
    // MARK: - Drawer Content
    var drawerContent: some View {
        VStack(spacing: 0) {
            // Handle
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color.gray.opacity(0.4))
                .frame(width: 36, height: 5)
                .padding(.top, 12)
            
            // Header
            HStack {
                HStack(spacing: 12) {
                    // Purple Icon
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 0.4, green: 0.3, blue: 0.9).opacity(0.15))
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: "doc.text.fill")
                            .font(.system(size: 18))
                            .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.9))
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Your Library")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(NPColors.textPrimary)
                        
                        Text("Select items to use in chat")
                            .font(.system(size: 13))
                            .foregroundColor(NPColors.textSecondary)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    HapticManager.shared.lightTap()
                    dismissDrawer()
                }) {
                    Text("View All")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.9))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 16)
            
            // Products Scroll
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(products) { product in
                        DrawerProductCard(
                            product: product,
                            isSelected: selectedProducts.contains(product.id),
                            onToggle: {
                                toggleProduct(product.id)
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
        }
        .frame(height: 320) // Fixed height for half-sheet
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(NPColors.bgPrimary)
                .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: -10)
        )
        .padding(.bottom, 80) // Space for input bar + tab bar
    }
    
    private func toggleProduct(_ id: UUID) {
        HapticManager.shared.lightTap()
        if selectedProducts.contains(id) {
            selectedProducts.remove(id)
        } else {
            selectedProducts.insert(id)
        }
    }
    
    private func dismissDrawer() {
        HapticManager.shared.lightTap()
        withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
            dragOffset = 0
            isPresented = false
        }
    }
}

// MARK: - Drawer Product Card (renamed to avoid conflict)
struct DrawerProductCard: View {
    let product: Product
    let isSelected: Bool
    let onToggle: () -> Void
    
    private let purpleColor = Color(red: 0.4, green: 0.3, blue: 0.9)
    
    var body: some View {
        Button(action: onToggle) {
            ZStack(alignment: .topTrailing) {
                // Card with image and name
                ZStack(alignment: .bottom) {
                    // Product Image
                    if product.isRemoteImage, let url = product.imageURL {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            case .failure:
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .overlay(
                                        Image(systemName: "photo")
                                            .foregroundColor(.gray)
                                    )
                            case .empty:
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .overlay(ProgressView())
                            @unknown default:
                                Rectangle().fill(Color.gray.opacity(0.2))
                            }
                        }
                        .frame(width: 140, height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 140, height: 180)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    // Name overlay at bottom
                    Text(product.name)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            LinearGradient(
                                colors: [Color.black.opacity(0.7), Color.black.opacity(0)],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .clipShape(
                            UnevenRoundedRectangle(
                                bottomLeadingRadius: 16,
                                bottomTrailingRadius: 16
                            )
                        )
                }
                .frame(width: 140, height: 180)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? purpleColor : Color.clear, lineWidth: 3)
                )
                
                // Checkmark badge
                ZStack {
                    Circle()
                        .fill(isSelected ? purpleColor : .white.opacity(0.9))
                        .frame(width: 26, height: 26)
                        .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .offset(x: -10, y: 10)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Selected Products Badge
struct SelectedProductsBadge: View {
    let count: Int
    
    private let cyanColor = Color(red: 0.3, green: 0.8, blue: 0.9)
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(cyanColor)
                .frame(width: 10, height: 10)
            
            Text("\(count) products selected")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(Color(red: 0.2, green: 0.2, blue: 0.25))
        )
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        NPColors.bgPrimary.ignoresSafeArea()
        ProductSelectionDrawer(
            isPresented: Binding.constant(true),
            selectedProducts: Binding.constant(Set<UUID>()),
            products: MockProducts.items
        )
    }
}
