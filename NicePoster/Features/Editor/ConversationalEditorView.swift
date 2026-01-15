import SwiftUI

// MARK: - Editor State
enum EditorState {
    case idle
    case waitingForSelection
    case waitingForUpload
    case processing
    case showingComparison
}

enum BrushTool: String, CaseIterable {
    case select = "rectangle.dashed"
    case mask = "hand.draw.fill"
    case upload = "camera.fill"
}

struct EditMessage: Identifiable {
    let id = UUID()
    let isUser: Bool
    let content: String
    let timestamp = Date()
}

struct ConversationalEditorView: View {
    @Environment(\.dismiss) var dismiss
    var imageName: String?
    var allImages: [GeneratedImage]
    
    init(imageName: String? = nil, allImages: [GeneratedImage] = []) {
        self.imageName = imageName
        self.allImages = allImages.isEmpty && imageName != nil 
            ? [GeneratedImage(imageName: imageName ?? "photo")] 
            : allImages
    }
    
    // Image State
    @State var currentImageIndex: Int = 0
    @State var scale: CGFloat = 1.0
    @State var lastScale: CGFloat = 1.0
    @State var offset: CGSize = .zero
    @State var lastOffset: CGSize = .zero
    
    // Editing State
    @State var editorState: EditorState = .idle
    @State var selectedBrushTool: BrushTool?
    @State var editMessages: [EditMessage] = []
    @State var inputText: String = ""
    
    // Comparison State
    @State var showComparison = false
    @State var comparisonProgress: CGFloat = 0.5
    
    var currentImage: GeneratedImage? {
        guard !allImages.isEmpty, currentImageIndex < allImages.count else { return nil }
        return allImages[currentImageIndex]
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                topBar
                imageCanvas
                
                if !editMessages.isEmpty {
                    chatHistoryView
                }
                
                if editorState == .waitingForSelection {
                    brushToolsBar
                }
                
                bottomToolbar
            }
            
            if editorState == .processing {
                processingOverlay
            }
        }
        .onAppear {
            if editMessages.isEmpty {
                addAIMessage("Hi！我来帮你编辑这张图 ✨\n告诉我你想怎么修改？")
            }
        }
    }
    
    // MARK: - Top Bar
    var topBar: some View {
        VStack(spacing: 12) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Circle().fill(.ultraThinMaterial))
                }
                
                Spacer()
                
                Text("对话编辑")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: { 
                    HapticManager.shared.success()
                    dismiss() 
                }) {
                    Text("完成")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(NPColors.brandPrimary)
                }
            }
            .padding(.horizontal)
            
            if allImages.count > 1 {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(allImages.enumerated()), id: \.element.id) { index, image in
                            thumbnailView(image: image, index: index)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.vertical, 12)
        .background(Color.black.opacity(0.95))
    }
    
    func thumbnailView(image: GeneratedImage, index: Int) -> some View {
        Button(action: {
            withAnimation {
                currentImageIndex = index
                HapticManager.shared.selection()
            }
        }) {
            Rectangle()
                .fill(thumbnailColor(for: image.imageName))
                .frame(width: 48, height: 64)
                .overlay(
                    Image(systemName: thumbnailIcon(for: image.imageName))
                        .font(.system(size: 20))
                        .foregroundColor(thumbnailIconColor(for: image.imageName))
                )
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(index == currentImageIndex ? NPColors.brandPrimary : Color.clear, lineWidth: 2)
                )
        }
    }
    
    // MARK: - Image Canvas
    var imageCanvas: some View {
        GeometryReader { geometry in
            ZStack {
                currentImageView
                    .scaleEffect(scale)
                    .offset(offset)
                    .gesture(imageGestures)
                
                if showComparison {
                    comparisonSliderView(geometry: geometry)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 280)
        .clipped()
    }
    
    @ViewBuilder
    var currentImageView: some View {
        let name = currentImage?.imageName ?? imageName ?? "photo"
        Rectangle()
            .fill(thumbnailColor(for: name))
            .aspectRatio(3/4, contentMode: .fit)
            .overlay(
                Image(systemName: thumbnailIcon(for: name))
                    .font(.system(size: 80))
                    .foregroundColor(thumbnailIconColor(for: name))
            )
            .cornerRadius(12)
    }
    
    var imageGestures: some Gesture {
        SimultaneousGesture(
            MagnificationGesture()
                .onChanged { val in
                    let delta = val / lastScale
                    lastScale = val
                    scale = min(max(scale * delta, 0.5), 4.0)
                }
                .onEnded { _ in lastScale = 1.0 },
            DragGesture()
                .onChanged { val in
                    offset = CGSize(
                        width: lastOffset.width + val.translation.width,
                        height: lastOffset.height + val.translation.height
                    )
                }
                .onEnded { _ in lastOffset = offset }
        )
    }
    
    // MARK: - Helper Functions
    func thumbnailColor(for name: String) -> Color {
        switch name {
        case "cake": return Color.pink.opacity(0.2)
        case "coffee": return Color.brown.opacity(0.2)
        default: return Color.gray.opacity(0.2)
        }
    }
    
    func thumbnailIcon(for name: String) -> String {
        switch name {
        case "cake": return "birthday.cake.fill"
        case "coffee": return "cup.and.saucer.fill"
        default: return "photo"
        }
    }
    
    func thumbnailIconColor(for name: String) -> Color {
        switch name {
        case "cake": return .pink
        case "coffee": return .brown
        default: return .gray
        }
    }
    
    func addUserMessage(_ content: String) {
        editMessages.append(EditMessage(isUser: true, content: content))
    }
    
    func addAIMessage(_ content: String) {
        editMessages.append(EditMessage(isUser: false, content: content))
    }
}
