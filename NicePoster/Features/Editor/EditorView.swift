import SwiftUI

struct EditorView: View {
    @Environment(\.dismiss) var dismiss
    var imageName: String? // Input image
    
    @State private var inputText: String = ""
    @State private var isCropMode = false
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    // Tools
    enum EditorTool: String, CaseIterable {
        case crop = "crop"
        case erase = "eraser"
        case text = "text.cursor"
        case replace = "arrow.triangle.2.circlepath"
        case magic = "wand.and.stars"
    }
    
    @State private var selectedTool: EditorTool?
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Bar
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Circle().fill(.ultraThinMaterial))
                    }
                    
                    Spacer()
                    
                    Text("编辑图片")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: { 
                        HapticManager.shared.success()
                        dismiss() 
                    }) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Circle().fill(NPColors.brandPrimary))
                    }
                }
                .padding()
                
                Spacer()
                
                // Image Canvas
                GeometryReader { geometry in
                    ZStack {
                        // Image Placeholder or Actual Image
                        if let imageName = imageName, imageName != "photo" {
                            // In a real app, load from URL or Asset
                            // For mock, we reuse the system images if they match our mock data keys
                            // or fallback to a colored rectangle with the icon
                            if imageName == "cake" {
                                Color.pink.opacity(0.1)
                                    .overlay(
                                        Image(systemName: "birthday.cake.fill")
                                            .font(.system(size: 100))
                                            .foregroundColor(.pink)
                                    )
                            } else if imageName == "coffee" {
                                Color.brown.opacity(0.1)
                                    .overlay(
                                        Image(systemName: "cup.and.saucer.fill")
                                            .font(.system(size: 100))
                                            .foregroundColor(.brown)
                                    )
                            } else {
                                Color(white: 0.15)
                                    .overlay(
                                        Image(systemName: "photo")
                                            .font(.system(size: 60))
                                            .foregroundColor(.gray)
                                    )
                            }
                        } else {
                            Rectangle()
                                .fill(Color(white: 0.15))
                                .overlay(
                                    Image(systemName: "photo")
                                        .font(.system(size: 60))
                                        .foregroundColor(.gray)
                                )
                        }
                    }
                    .scaleEffect(scale)
                            .offset(offset)
                            .gesture(
                                MagnificationGesture()
                                    .onChanged { val in
                                        let delta = val / lastScale
                                        lastScale = val
                                        scale *= delta
                                    }
                                    .onEnded { _ in
                                        lastScale = 1.0
                                    }
                            )
                            .gesture(
                                DragGesture()
                                    .onChanged { val in
                                        let translation = val.translation
                                        offset = CGSize(
                                            width: lastOffset.width + translation.width,
                                            height: lastOffset.height + translation.height
                                        )
                                    }
                                    .onEnded { _ in
                                        lastOffset = offset
                                    }
                            )
                    }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                
                Spacer()
                
                // Bottom Toolbar (CapCut Style)
                VStack(spacing: 0) {
                    // Chat Input for AI Editing
                    HStack {
                        Image(systemName: "sparkles")
                            .foregroundColor(NPColors.brandPrimary)
                        
                        TextField("告诉 AI 怎么修图...", text: $inputText)
                            .submitLabel(.send)
                            .foregroundColor(.white)
                        
                        if !inputText.isEmpty {
                            Button(action: {
                                inputText = ""
                                HapticManager.shared.lightTap()
                            }) {
                                Image(systemName: "arrow.up.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(NPColors.brandPrimary)
                            }
                        }
                    }
                    .padding()
                    .background(Color(white: 0.15))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.bottom, 12)
                    
                    // Tool Icons
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 24) {
                            ForEach(EditorTool.allCases, id: \.self) { tool in
                                EditorToolButton(
                                    icon: tool.rawValue,
                                    label: toolLabel(for: tool),
                                    isSelected: selectedTool == tool
                                ) {
                                    withAnimation {
                                        selectedTool = tool
                                        HapticManager.shared.selection()
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 20)
                }
                .background(Color.black.ignoresSafeArea())
            }
        }
    }
    
    func toolLabel(for tool: EditorTool) -> String {
        switch tool {
        case .crop: return "裁剪"
        case .erase: return "消除"
        case .text: return "文字"
        case .replace: return "替换"
        case .magic: return "AI重绘"
        }
    }
}

struct EditorToolButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? NPColors.brandPrimary : .white)
                
                Text(label)
                    .font(.system(size: 11))
                    .foregroundColor(isSelected ? NPColors.brandPrimary : .gray)
            }
            .frame(width: 44)
        }
    }
}
