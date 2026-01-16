import SwiftUI

struct HomeInputBar: View {
    @Binding var text: String
    let onSend: () -> Void
    let onCameraTap: () -> Void
    let onStyleTap: () -> Void
    var onAdvancedTap: (() -> Void)? = nil
    
    @FocusState private var isFocused: Bool
    @State private var showProductDrawer = false
    @State private var selectedProducts: Set<UUID> = []
    
    var body: some View {
        VStack(spacing: 0) {
            // Selected Products Badge
            if !selectedProducts.isEmpty {
                SelectedProductsBadge(count: selectedProducts.count)
                    .padding(.bottom, 8)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            // Input Row - matches design: icons + text field + send button
            HStack(spacing: 12) {
                // Left icons (Product, Style)
                HStack(spacing: 4) {
                    BarIconButton(
                        icon: "doc.text.fill",
                        isHighlighted: !selectedProducts.isEmpty
                    ) {
                        showProductDrawer = true
                    }
                    BarIconButton(icon: "slider.horizontal.3") {
                        onStyleTap()
                    }
                }
                
                // Input Field
                ZStack(alignment: .leading) {
                    if text.isEmpty {
                        Text(selectedProducts.isEmpty ? "Ask anything..." : "Ask about selections...")
                            .foregroundColor(NPColors.textTertiary)
                            .padding(.horizontal, 16)
                    }
                    
                    TextField("", text: $text)
                        .textFieldStyle(.plain)
                        .focused($isFocused)
                        .submitLabel(.send)
                        .onSubmit {
                            if !text.isEmpty { onSend() }
                        }
                        .padding(.horizontal, 16)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(NPColors.bgTertiary)
                .cornerRadius(NPRadius.full)
                .onTapGesture {
                    isFocused = true
                }
                
                // Send Button
                Button(action: {
                    HapticManager.shared.mediumTap()
                    onSend()
                }) {
                    Circle()
                        .fill(text.isEmpty ? Color.gray.opacity(0.3) : NPColors.brandPrimary)
                        .frame(width: 44, height: 44)
                        .overlay(
                            Image(systemName: "arrow.up")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                        )
                }
                .disabled(text.isEmpty)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                Rectangle()
                    .fill(NPColors.bgPrimary)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: -4)
                    .ignoresSafeArea()
            )
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: selectedProducts.count)
        .overlay(
            ProductSelectionDrawer(
                isPresented: $showProductDrawer,
                selectedProducts: $selectedProducts,
                products: MockProducts.items
            )
        )
    }
}

// MARK: - Bar Icon Button
struct BarIconButton: View {
    let icon: String
    var isHighlighted: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            HapticManager.shared.lightTap()
            action()
        }) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(isHighlighted ? NPColors.brandPrimary : NPColors.textSecondary)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(isHighlighted ? NPColors.brandPrimary.opacity(0.1) : Color.clear)
                        .frame(width: 36, height: 36)
                )
        }
    }
}

// MARK: - Attachment Button
struct AttachmentButton: View {
    let icon: String
    let label: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            HapticManager.shared.lightTap()
            action()
        }) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                Text(label)
                    .font(.system(size: 13, weight: .medium))
            }
            .foregroundColor(color)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(color.opacity(0.1))
            .cornerRadius(NPRadius.full)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct IconButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            HapticManager.shared.lightTap()
            action()
        }) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(NPColors.textSecondary)
                .frame(width: 40, height: 40)
        }
    }
}
