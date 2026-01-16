import SwiftUI

// MARK: - Bubble Cart View (3D Carousel Selection)
struct BubbleCartView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var cartItems: [GeneratedImage]
    let onExport: () -> Void
    
    @State private var currentIndex: Int = 0
    @State private var selectedItems: Set<UUID> = []
    @State private var selectAll = false
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Background
            NPColors.bgPrimary.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                header
                
                Spacer()
                
                // 3D Carousel
                carousel3D
                
                // Page Indicators
                pageIndicators
                    .padding(.top, 24)
                
                Spacer()
                
                // Bottom Action Bar
                bottomBar
            }
        }
    }
    
    // MARK: - Header
    var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Select for")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(NPColors.textPrimary)
                Text("Export")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(NPColors.textPrimary)
            }
            
            Spacer()
            
            // Select All Toggle
            VStack(alignment: .trailing, spacing: 4) {
                Text("Select")
                    .font(.system(size: 14))
                    .foregroundColor(NPColors.textSecondary)
                Text("All")
                    .font(.system(size: 14))
                    .foregroundColor(NPColors.textSecondary)
            }
            
            Toggle("", isOn: $selectAll)
                .toggleStyle(SwitchToggleStyle(tint: NPColors.brandPrimary))
                .labelsHidden()
                .onChange(of: selectAll) { _, newValue in
                    HapticManager.shared.selection()
                    if newValue {
                        selectedItems = Set(cartItems.map { $0.id })
                    } else {
                        selectedItems.removeAll()
                    }
                }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }
    
    // MARK: - 3D Carousel
    var carousel3D: some View {
        GeometryReader { geometry in
            let _ = geometry.size.width / 2 // Available for future use
            
            ZStack {
                ForEach(Array(cartItems.enumerated()), id: \.element.id) { index, item in
                    CarouselCard(
                        item: item,
                        isSelected: selectedItems.contains(item.id),
                        isCentered: index == currentIndex,
                        offset: calculateOffset(for: index, totalWidth: geometry.size.width),
                        scale: calculateScale(for: index),
                        opacity: calculateOpacity(for: index),
                        onToggleSelection: {
                            toggleSelection(item)
                        }
                    )
                    .zIndex(index == currentIndex ? 10 : Double(cartItems.count - abs(index - currentIndex)))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation.width
                    }
                    .onEnded { value in
                        let threshold: CGFloat = 50
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            if value.translation.width > threshold && currentIndex > 0 {
                                currentIndex -= 1
                                HapticManager.shared.selection()
                            } else if value.translation.width < -threshold && currentIndex < cartItems.count - 1 {
                                currentIndex += 1
                                HapticManager.shared.selection()
                            }
                            dragOffset = 0
                        }
                    }
            )
        }
        .frame(height: 400)
    }
    
    // MARK: - Page Indicators
    var pageIndicators: some View {
        HStack(spacing: 8) {
            ForEach(0..<cartItems.count, id: \.self) { index in
                Circle()
                    .fill(index == currentIndex ? NPColors.brandPrimary : NPColors.textTertiary.opacity(0.3))
                    .frame(width: index == currentIndex ? 8 : 6, height: index == currentIndex ? 8 : 6)
                    .animation(.spring(response: 0.3), value: currentIndex)
            }
        }
    }
    
    // MARK: - Bottom Bar
    var bottomBar: some View {
        VStack(spacing: 16) {
            // Status
            HStack(spacing: 8) {
                Circle()
                    .fill(selectedItems.isEmpty ? NPColors.textTertiary : NPColors.brandPrimary)
                    .frame(width: 8, height: 8)
                
                Text(selectedItems.isEmpty ? "SELECT IMAGES" : "READY TO EXPORT")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(selectedItems.isEmpty ? NPColors.textTertiary : NPColors.brandPrimary)
                    .tracking(1.2)
            }
            
            Text("\(selectedItems.count) images selected")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(NPColors.textPrimary)
            
            // Export Button
            Button(action: {
                HapticManager.shared.mediumTap()
                onExport()
            }) {
                HStack(spacing: 10) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 16))
                    Text("Distribute to Platforms")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    LinearGradient(
                        colors: [Color(red: 1.0, green: 0.45, blue: 0.4), Color(red: 1.0, green: 0.55, blue: 0.5)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(28)
                .shadow(color: Color(red: 1.0, green: 0.45, blue: 0.4).opacity(0.4), radius: 16, x: 0, y: 8)
            }
            .disabled(selectedItems.isEmpty)
            .opacity(selectedItems.isEmpty ? 0.5 : 1)
            .padding(.horizontal, 24)
        }
        .padding(.bottom, 32)
    }
    
    // MARK: - Helper Functions
    private func calculateOffset(for index: Int, totalWidth: CGFloat) -> CGFloat {
        let diff = CGFloat(index - currentIndex)
        let baseOffset = diff * 120
        let dragContribution = dragOffset * 0.3
        return baseOffset + dragContribution
    }
    
    private func calculateScale(for index: Int) -> CGFloat {
        let diff = abs(index - currentIndex)
        switch diff {
        case 0: return 1.0
        case 1: return 0.75
        default: return 0.55
        }
    }
    
    private func calculateOpacity(for index: Int) -> Double {
        let diff = abs(index - currentIndex)
        switch diff {
        case 0: return 1.0
        case 1: return 0.7
        default: return 0.4
        }
    }
    
    private func toggleSelection(_ item: GeneratedImage) {
        HapticManager.shared.lightTap()
        if selectedItems.contains(item.id) {
            selectedItems.remove(item.id)
            selectAll = false
        } else {
            selectedItems.insert(item.id)
            if selectedItems.count == cartItems.count {
                selectAll = true
            }
        }
    }
}

// MARK: - Carousel Card
struct CarouselCard: View {
    let item: GeneratedImage
    let isSelected: Bool
    let isCentered: Bool
    let offset: CGFloat
    let scale: CGFloat
    let opacity: Double
    let onToggleSelection: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Card Content
            RoundedRectangle(cornerRadius: 32)
                .fill(item.mockColor)
                .frame(width: 180, height: 260)
                .overlay(
                    Image(systemName: item.mockIcon)
                        .font(.system(size: 48))
                        .foregroundColor(.white.opacity(0.4))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(
                            isCentered && isSelected ? NPColors.brandPrimary : Color.clear,
                            lineWidth: 4
                        )
                )
                .shadow(
                    color: Color.black.opacity(isCentered ? 0.2 : 0.1),
                    radius: isCentered ? 30 : 15,
                    x: 0,
                    y: isCentered ? 20 : 10
                )
            
            // Selection Checkbox (only visible on centered card)
            if isCentered {
                Button(action: onToggleSelection) {
                    ZStack {
                        Circle()
                            .fill(isSelected ? NPColors.brandPrimary : .white)
                            .frame(width: 44, height: 44)
                            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                        
                        if isSelected {
                            Image(systemName: "checkmark")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .offset(x: -8, y: -12)
            }
        }
        .scaleEffect(scale)
        .opacity(opacity)
        .offset(x: offset)
        .blur(radius: isCentered ? 0 : 2)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: offset)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: scale)
    }
}

// MARK: - Preview
#Preview {
    BubbleCartView(
        cartItems: .constant(GeneratedImage.mockCartItems),
        onExport: {}
    )
}
