import SwiftUI

// MARK: - Image Action Types
enum ImageAction {
    case addToCart
    case edit
    case regenerate
    case delete
}

struct ResultGridView: View {
    let images: [GeneratedImage]
    let onImageTap: (GeneratedImage) -> Void
    var onImageAction: ((GeneratedImage, ImageAction) -> Void)? = nil
    
    @State private var currentIndex: Int = 0
    @State private var fullscreenImage: GeneratedImage? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Image(systemName: "sparkles.rectangle.stack.fill")
                    .foregroundColor(NPColors.brandPrimary)
                Text("为你生成了 \(images.count) 张草稿")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(NPColors.textPrimary)
                
                Spacer()
                
                // Page indicator
                Text("\(currentIndex + 1)/\(images.count)")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(NPColors.textSecondary)
            }
            .padding(.horizontal, 4)
            
            // Card Carousel with 3D Effect
            TabView(selection: $currentIndex) {
                ForEach(Array(images.enumerated()), id: \.element.id) { index, image in
                    ResultCarouselCard(
                        image: image,
                        onTap: {
                            fullscreenImage = image
                        },
                        onEdit: {
                            onImageTap(image)
                        },
                        onAction: { action in
                            onImageAction?(image, action)
                        }
                    )
                    .tag(index)
                    .scaleEffect(index == currentIndex ? 1.0 : 0.92)
                    .opacity(index == currentIndex ? 1.0 : 0.6)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentIndex)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 340)
            
            // Dot indicators
            HStack(spacing: 6) {
                ForEach(0..<images.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? NPColors.brandPrimary : NPColors.textTertiary.opacity(0.3))
                        .frame(width: 6, height: 6)
                        .animation(.easeInOut(duration: 0.2), value: currentIndex)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(12)
        .background(NPColors.bgSecondary)
        .cornerRadius(16)
        .fullScreenCover(item: $fullscreenImage) { image in
            FullscreenImagePreview(image: image) {
                fullscreenImage = nil
            }
        }
    }
}

// MARK: - Carousel Card
struct ResultCarouselCard: View {
    let image: GeneratedImage
    let onTap: () -> Void
    let onEdit: () -> Void
    let onAction: (ImageAction) -> Void
    
    @State private var showingMenu = false
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Main Image Area
            ZStack(alignment: .topTrailing) {
                imageContent
                    .aspectRatio(3/4, contentMode: .fit)
                    .cornerRadius(NPRadius.large, corners: [.topLeft, .topRight])
                    .onTapGesture {
                        HapticManager.shared.lightTap()
                        onTap()
                    }
                    .onLongPressGesture {
                        HapticManager.shared.mediumTap()
                        showingMenu = true
                    }
                
                // Menu Button
                Button(action: {
                    HapticManager.shared.selection()
                    showingMenu = true
                }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Circle().fill(.ultraThinMaterial))
                }
                .padding(12)
            }
            
            // Bottom Action Bar
            HStack(spacing: 0) {
                ActionButton(icon: "cart.badge.plus", title: "加购") {
                    HapticManager.shared.success()
                    onAction(.addToCart)
                }
                
                ActionButton(icon: "pencil", title: "编辑") {
                    onEdit()
                }
                
                ActionButton(icon: "arrow.clockwise", title: "重生") {
                    onAction(.regenerate)
                }
                
                ActionButton(icon: "square.and.arrow.down", title: "保存") {
                    HapticManager.shared.lightTap()
                    // Save action placeholder
                }
            }
            .frame(height: 56)
            .background(NPColors.bgPrimary)
            .cornerRadius(NPRadius.large, corners: [.bottomLeft, .bottomRight])
        }
        .background(NPColors.bgPrimary)
        .cornerRadius(NPRadius.large)
        .shadow(color: NPShadow.shadow3.color, radius: NPShadow.shadow3.radius, x: 0, y: NPShadow.shadow3.y)
        .padding(.horizontal, 8)
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        .confirmationDialog("选择操作", isPresented: $showingMenu, titleVisibility: .visible) {
            Button(action: {
                HapticManager.shared.success()
                onAction(.addToCart)
            }) {
                Label("加入购物车", systemImage: "cart.badge.plus")
            }
            
            Button(action: {
                onEdit()
            }) {
                Label("继续编辑", systemImage: "pencil")
            }
            
            Button(action: {
                onAction(.regenerate)
            }) {
                Label("重新生成这张", systemImage: "arrow.clockwise")
            }
            
            Button(role: .destructive, action: {
                onAction(.delete)
            }) {
                Label("删除这张", systemImage: "trash")
            }
            
            Button("取消", role: .cancel) { }
        }
    }
    
    @ViewBuilder
    var imageContent: some View {
        Rectangle()
            .fill(Color.white)
            .overlay(
                ZStack {
                    mockImageView
                    
                    LinearGradient(
                        colors: [Color.clear, Color.black.opacity(0.15)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
            )
    }
    
    @ViewBuilder
    var mockImageView: some View {
        if image.imageName == "cake" {
            Color.pink.opacity(0.1)
                .overlay(
                    Image(systemName: "birthday.cake.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.pink.opacity(0.6))
                )
        } else if image.imageName == "coffee" {
            Color.brown.opacity(0.1)
                .overlay(
                    Image(systemName: "cup.and.saucer.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.brown.opacity(0.6))
                )
        } else {
            Color.gray.opacity(0.1)
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 60))
                        .foregroundColor(.gray.opacity(0.5))
                )
        }
    }
}

// MARK: - Fullscreen Preview
struct FullscreenImagePreview: View {
    let image: GeneratedImage
    let onDismiss: () -> Void
    
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Image
            imageContent
                .scaleEffect(scale)
                .offset(offset)
                .gesture(
                    MagnificationGesture()
                        .onChanged { val in
                            let delta = val / lastScale
                            lastScale = val
                            scale = min(max(scale * delta, 1.0), 4.0)
                        }
                        .onEnded { _ in
                            lastScale = 1.0
                        }
                )
                .gesture(
                    DragGesture()
                        .onChanged { val in
                            offset = CGSize(
                                width: lastOffset.width + val.translation.width,
                                height: lastOffset.height + val.translation.height
                            )
                        }
                        .onEnded { _ in
                            lastOffset = offset
                        }
                )
            
            // Close button
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        HapticManager.shared.lightTap()
                        onDismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Circle().fill(.ultraThinMaterial))
                    }
                    .padding()
                }
                Spacer()
            }
        }
        .onTapGesture(count: 2) {
            withAnimation(.spring()) {
                if scale > 1.0 {
                    scale = 1.0
                    offset = .zero
                    lastOffset = .zero
                } else {
                    scale = 2.0
                }
            }
        }
    }
    
    @ViewBuilder
    var imageContent: some View {
        if image.imageName == "cake" {
            Color.pink.opacity(0.2)
                .aspectRatio(3/4, contentMode: .fit)
                .overlay(
                    Image(systemName: "birthday.cake.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.pink)
                )
                .cornerRadius(16)
        } else if image.imageName == "coffee" {
            Color.brown.opacity(0.2)
                .aspectRatio(3/4, contentMode: .fit)
                .overlay(
                    Image(systemName: "cup.and.saucer.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.brown)
                )
                .cornerRadius(16)
        } else {
            Color.gray.opacity(0.2)
                .aspectRatio(3/4, contentMode: .fit)
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 100))
                        .foregroundColor(.gray)
                )
                .cornerRadius(16)
        }
    }
}

// MARK: - Action Button
struct ActionButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                Text(title)
                    .font(.system(size: 11, weight: .medium))
            }
            .foregroundColor(NPColors.textSecondary)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Scale Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

