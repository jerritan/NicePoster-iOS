import SwiftUI

// MARK: - Edit Canvas View (Light Theme)
struct EditCanvasView: View {
    let imageName: String?
    let onDismiss: () -> Void
    let onSave: () -> Void
    
    @State private var selectedTool: EditTool = .brush
    @State private var inputText: String = ""
    @State private var showMask = true
    @State private var maskOffset: CGSize = .zero
    @State private var aiMessages: [AIEditMessage] = [
        AIEditMessage(text: "Highlighted! Now upload the photo of your New Strawberry Latte to replace it.", hasUploadButton: true)
    ]
    
    enum EditTool: String, CaseIterable {
        case brush = "Brush"
        case select = "Select"
        case relight = "Relight"
        
        var icon: String {
            switch self {
            case .brush: return "pencil.tip"
            case .select: return "square.dashed"
            case .relight: return "sun.max.fill"
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Light background
            NPColors.bgPrimary.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                header
                
                // Canvas area
                ZStack {
                    // Image with mask
                    canvasArea
                    
                    // Undo/Redo buttons
                    undoRedoButtons
                }
                .frame(maxHeight: .infinity)
                
                // AI Chat section
                aiChatSection
                
                // Tool pills
                toolPills
                
                // Bottom input
                bottomInput
            }
        }
    }
    
    // MARK: - Header
    var header: some View {
        HStack {
            Button(action: {
                HapticManager.shared.lightTap()
                onDismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(NPColors.textPrimary)
            }
            
            Spacer()
            
            Text("Edit Canvas")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(NPColors.textPrimary)
            
            Spacer()
            
            Button(action: {
                HapticManager.shared.success()
                onSave()
            }) {
                Text("Save")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(NPColors.brandPrimary)
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(NPColors.bgPrimary)
    }
    
    // MARK: - Canvas Area
    var canvasArea: some View {
        GeometryReader { geometry in
            ZStack {
                // Mock image
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color(red: 0.3, green: 0.25, blue: 0.2))
                    .overlay(
                        VStack(spacing: 20) {
                            // Mock cafe scene elements
                            HStack(spacing: 30) {
                                // Cake
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(red: 0.4, green: 0.35, blue: 0.3))
                                    .frame(width: 80, height: 60)
                                    .overlay(
                                        Image(systemName: "birthday.cake")
                                            .font(.system(size: 30))
                                            .foregroundColor(.white.opacity(0.3))
                                    )
                                
                                // Teapot
                                Circle()
                                    .fill(Color.white.opacity(0.8))
                                    .frame(width: 70, height: 70)
                                    .overlay(
                                        Image(systemName: "cup.and.saucer.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(.gray)
                                    )
                                
                                // Coffee cup
                                Circle()
                                    .fill(Color(red: 0.9, green: 0.85, blue: 0.8))
                                    .frame(width: 50, height: 50)
                            }
                            .offset(y: -30)
                        }
                    )
                
                // Mask overlay
                if showMask {
                    MaskOverlay(offset: maskOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    maskOffset = value.translation
                                }
                        )
                }
            }
        }
    }
    
    // MARK: - Undo/Redo Buttons
    var undoRedoButtons: some View {
        VStack(spacing: 12) {
            Button(action: {
                HapticManager.shared.lightTap()
            }) {
                Image(systemName: "arrow.uturn.backward")
                    .font(.system(size: 18))
                    .foregroundColor(NPColors.textPrimary)
                    .frame(width: 44, height: 44)
                    .background(NPColors.bgSecondary)
                    .clipShape(Circle())
                    .shadow(color: NPShadow.shadow1.color, radius: NPShadow.shadow1.radius, x: 0, y: NPShadow.shadow1.y)
            }
            
            Button(action: {
                HapticManager.shared.lightTap()
            }) {
                Image(systemName: "arrow.uturn.forward")
                    .font(.system(size: 18))
                    .foregroundColor(NPColors.textTertiary)
                    .frame(width: 44, height: 44)
                    .background(NPColors.bgSecondary)
                    .clipShape(Circle())
                    .shadow(color: NPShadow.shadow1.color, radius: NPShadow.shadow1.radius, x: 0, y: NPShadow.shadow1.y)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .padding(.trailing, 16)
        .padding(.top, 16)
    }
    
    // MARK: - AI Chat Section
    var aiChatSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            // AI label
            HStack(spacing: 6) {
                Circle()
                    .fill(NPColors.brandPrimary)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Image(systemName: "sparkles")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                    )
                Text("NicePoster AI")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(NPColors.textSecondary)
            }
            
            // Message bubble
            ForEach(aiMessages) { message in
                VStack(alignment: .leading, spacing: 12) {
                    Text(message.text)
                        .font(.system(size: 15))
                        .foregroundColor(NPColors.textPrimary)
                    
                    if message.hasUploadButton {
                        Button(action: {
                            HapticManager.shared.mediumTap()
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 14))
                                Text("Upload Photo")
                                    .font(.system(size: 14, weight: .medium))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(NPColors.brandPrimary)
                            .cornerRadius(8)
                        }
                    }
                }
                .padding(14)
                .background(NPColors.bgSecondary)
                .cornerRadius(16)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
    
    // MARK: - Tool Pills
    var toolPills: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(EditTool.allCases, id: \.self) { tool in
                    ToolPill(
                        icon: tool.icon,
                        label: tool.rawValue,
                        isSelected: selectedTool == tool
                    ) {
                        HapticManager.shared.selection()
                        selectedTool = tool
                    }
                }
                
                // More tools placeholder
                ToolPill(icon: "ellipsis", label: "", isSelected: false) {}
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Bottom Input
    var bottomInput: some View {
        HStack(spacing: 12) {
            Button(action: {
                HapticManager.shared.lightTap()
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(NPColors.brandPrimary)
                    .frame(width: 40, height: 40)
                    .background(NPColors.brandPrimary.opacity(0.1))
                    .clipShape(Circle())
            }
            
            HStack {
                TextField("Describe changes or upload...", text: $inputText)
                    .foregroundColor(NPColors.textPrimary)
                    .accentColor(NPColors.brandPrimary)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(NPColors.bgTertiary)
            .cornerRadius(24)
            
            Button(action: {
                HapticManager.shared.mediumTap()
            }) {
                Circle()
                    .fill(inputText.isEmpty ? Color.gray.opacity(0.3) : NPColors.brandPrimary)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: "arrow.up")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    )
            }
            .disabled(inputText.isEmpty)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(NPColors.bgPrimary)
    }
}

// MARK: - Mask Overlay
struct MaskOverlay: View {
    let offset: CGSize
    
    var body: some View {
        ZStack {
            // Semi-transparent red/pink mask
            Path { path in
                path.move(to: CGPoint(x: 120, y: 180))
                path.addCurve(
                    to: CGPoint(x: 280, y: 280),
                    control1: CGPoint(x: 180, y: 150),
                    control2: CGPoint(x: 300, y: 200)
                )
                path.addCurve(
                    to: CGPoint(x: 150, y: 320),
                    control1: CGPoint(x: 260, y: 350),
                    control2: CGPoint(x: 180, y: 340)
                )
                path.addCurve(
                    to: CGPoint(x: 120, y: 180),
                    control1: CGPoint(x: 100, y: 280),
                    control2: CGPoint(x: 80, y: 220)
                )
            }
            .fill(Color.pink.opacity(0.3))
            .offset(offset)
            
            // Dashed stroke
            Path { path in
                path.move(to: CGPoint(x: 120, y: 180))
                path.addCurve(
                    to: CGPoint(x: 280, y: 280),
                    control1: CGPoint(x: 180, y: 150),
                    control2: CGPoint(x: 300, y: 200)
                )
                path.addCurve(
                    to: CGPoint(x: 150, y: 320),
                    control1: CGPoint(x: 260, y: 350),
                    control2: CGPoint(x: 180, y: 340)
                )
                path.addCurve(
                    to: CGPoint(x: 120, y: 180),
                    control1: CGPoint(x: 100, y: 280),
                    control2: CGPoint(x: 80, y: 220)
                )
            }
            .stroke(style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
            .foregroundColor(.pink)
            .offset(offset)
            
            // Mask label
            HStack(spacing: 4) {
                Image(systemName: "pencil.tip")
                    .font(.system(size: 10))
                Text("Mask")
                    .font(.system(size: 11, weight: .semibold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.pink)
            .cornerRadius(12)
            .offset(x: 80 + offset.width, y: 100 + offset.height)
        }
    }
}

// MARK: - Tool Pill (Light Theme)
struct ToolPill: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                if !label.isEmpty {
                    Text(label)
                        .font(.system(size: 14, weight: .medium))
                }
            }
            .foregroundColor(isSelected ? NPColors.brandPrimary : NPColors.textSecondary)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .stroke(isSelected ? NPColors.brandPrimary : NPColors.textTertiary.opacity(0.3), lineWidth: 1.5)
                    .background(Capsule().fill(isSelected ? NPColors.brandPrimary.opacity(0.1) : Color.clear))
            )
        }
    }
}

// MARK: - AI Edit Message Model
struct AIEditMessage: Identifiable {
    let id = UUID()
    let text: String
    let hasUploadButton: Bool
}
