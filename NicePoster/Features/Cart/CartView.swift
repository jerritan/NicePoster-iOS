import SwiftUI

struct CartView: View {
    @State private var cartItems: [CartItem] = [
        CartItem(imageName: "cake", title: "草莓蛋糕推广", size: "3:4", isSelected: true),
        CartItem(imageName: "coffee", title: "情人节拿铁", size: "1:1", isSelected: true)
    ]
    
    @State private var isExporting = false
    
    var body: some View {
        NavigationView {
            ZStack {
                NPColors.bgPrimary.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    if cartItems.isEmpty {
                        EmptyCartView()
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                ForEach(cartItems) { item in
                                    CartItemCard(item: item) {
                                        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
                                            cartItems[index].isSelected.toggle()
                                            HapticManager.shared.selection()
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    
                    // Bottom Action Bar
                    VStack(spacing: 0) {
                        Divider()
                        HStack {
                            VStack(alignment: .leading) {
                                Text("已选 \(cartItems.filter{$0.isSelected}.count) 张")
                                    .font(.headline)
                                Text("准备导出")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Button(action: { isExporting = true }) {
                                Text("生成物料")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 32)
                                    .padding(.vertical, 12)
                                    .background(NPColors.brandGradient)
                                    .cornerRadius(24)
                                    .shadow(color: NPColors.brandPrimary.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            .disabled(cartItems.filter{$0.isSelected}.isEmpty)
                        }
                        .padding()
                        .background(Color.white)
                    }
                }
            }
            .navigationTitle("购物车")
            .navigationBarItems(trailing: Button("编辑") {})
        }
    }
}

struct CartItem: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let size: String
    var isSelected: Bool
}

struct CartItemCard: View {
    let item: CartItem
    let onToggle: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 0) {
                // Image Placeholder
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .aspectRatio(3/4, contentMode: .fit)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.system(size: 14, weight: .medium))
                        .lineLimit(1)
                    
                    Text(item.size)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(4)
                }
                .padding(10)
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            
            // Selection Checkbox
            Button(action: onToggle) {
                Image(systemName: item.isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(item.isSelected ? NPColors.brandPrimary : .gray.opacity(0.5))
                    .background(Circle().fill(.white))
            }
            .padding(8)
        }
    }
}

struct EmptyCartView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "cart")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            Text("购物车是空的")
                .font(.headline)
                .foregroundColor(.gray)
            Text("去首页生成一些图片吧")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}
