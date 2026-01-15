import SwiftUI

// MARK: - Generation Results View (Light Theme)
struct GenerationResultsView: View {
    let prompt: String
    let onDismiss: () -> Void
    let onPreviewResults: ([GeneratedResult]) -> Void
    
    @State private var results: [GeneratedResult] = GeneratedResult.mockResults
    @State private var currentIndex: Int = 0
    @State private var selectedItems: Set<UUID> = []
    @State private var showEditCanvas = false
    @State private var editingResult: GeneratedResult?
    @State private var showOutputSelection = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Light background
            NPColors.bgPrimary.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                header
                
                ScrollView {
                    VStack(spacing: 16) {
                        // User prompt bubble
                        promptBubble
                        
                        // Generation status
                        generationStatus
                        
                        // Card carousel
                        cardCarousel
                        
                        // Bottom padding
                        Color.clear.frame(height: 120)
                    }
                    .padding(.top, 8)
                }
            }
            
            // Bottom selection bar
            if !selectedItems.isEmpty {
                selectionBar
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: selectedItems.isEmpty)
        .fullScreenCover(isPresented: $showEditCanvas) {
            EditCanvasView(
                imageName: nil,
                onDismiss: { showEditCanvas = false },
                onSave: { showEditCanvas = false }
            )
        }
        .fullScreenCover(isPresented: $showOutputSelection) {
            OutputSelectionView(
                cartItems: .constant(selectedItems.compactMap { id in
                    if let result = results.first(where: { $0.id == id }) {
                        return GeneratedImage(imageName: "generated_\(result.id)")
                    }
                    return nil
                }),
                onDismiss: { showOutputSelection = false },
                onPreviewMockup: {
                    showOutputSelection = false
                    let selected = results.filter { selectedItems.contains($0.id) }
                    onPreviewResults(selected)
                }
            )
        }
    }
    
    // MARK: - Header
    var header: some View {
        HStack {
            Button(action: {
                HapticManager.shared.lightTap()
                onDismiss()
            }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(NPColors.textPrimary)
            }
            
            Spacer()
            
            Text("Generation Results")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(NPColors.textPrimary)
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(NPColors.textPrimary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(NPColors.bgPrimary)
    }
    
    // MARK: - Prompt Bubble
    var promptBubble: some View {
        Text(prompt)
            .font(.system(size: 15))
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(NPColors.brandPrimary)
            .cornerRadius(16)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    // MARK: - Generation Status
    var generationStatus: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(NPColors.brandPrimary)
                .frame(width: 8, height: 8)
            Text("\(results.count) layouts generated")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(NPColors.textSecondary)
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Card Carousel
    var cardCarousel: some View {
        VStack(spacing: 16) {
            TabView(selection: $currentIndex) {
                ForEach(Array(results.enumerated()), id: \.element.id) { index, result in
                    ResultCard(
                        result: result,
                        isSelected: selectedItems.contains(result.id),
                        onSelect: {
                            toggleSelection(result.id)
                        },
                        onEdit: {
                            editingResult = result
                            showEditCanvas = true
                        },
                        onRegen: {},
                        onSave: {}
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 520)
            
            // Dot indicators
            HStack(spacing: 8) {
                ForEach(0..<results.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? NPColors.brandPrimary : NPColors.textTertiary.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
        }
    }
    
    // MARK: - Selection Bar
    var selectionBar: some View {
        HStack(spacing: 12) {
            // Thumbnails
            HStack(spacing: -8) {
                ForEach(Array(selectedItems.prefix(3)), id: \.self) { id in
                    if let result = results.first(where: { $0.id == id }) {
                        Circle()
                            .fill(result.mockColor)
                            .frame(width: 36, height: 36)
                            .overlay(
                                Circle().stroke(NPColors.bgPrimary, lineWidth: 2)
                            )
                    }
                }
            }
            
            // Count
            VStack(alignment: .leading, spacing: 2) {
                Text("\(selectedItems.count) items")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(NPColors.textPrimary)
                Text("Selected")
                    .font(.system(size: 12))
                    .foregroundColor(NPColors.textSecondary)
            }
            
            Spacer()
            
            // Preview button
            Button(action: {
                HapticManager.shared.mediumTap()
                showOutputSelection = true
            }) {
                HStack(spacing: 8) {
                    Text("Preview Results")
                        .font(.system(size: 15, weight: .semibold))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(NPColors.brandPrimary)
                .cornerRadius(24)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(NPColors.bgSecondary)
                .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: -5)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
    }
    
    func toggleSelection(_ id: UUID) {
        HapticManager.shared.selection()
        if selectedItems.contains(id) {
            selectedItems.remove(id)
        } else {
            selectedItems.insert(id)
        }
    }
}

// MARK: - Result Card (Light Theme)
struct ResultCard: View {
    let result: GeneratedResult
    let isSelected: Bool
    let onSelect: () -> Void
    let onEdit: () -> Void
    let onRegen: () -> Void
    let onSave: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Image area
            ZStack(alignment: .top) {
                // Mock image
                RoundedRectangle(cornerRadius: 16)
                    .fill(result.mockColor)
                    .overlay(
                        Image(systemName: result.mockIcon)
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.3))
                    )
                
                // Best Match badge
                if result.isBestMatch {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 12))
                        Text("Best Match")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(NPColors.brandPrimary)
                    .cornerRadius(16)
                    .padding(.top, 12)
                }
            }
            .frame(height: 320)
            .cornerRadius(16, corners: [.topLeft, .topRight])
            
            // Info area
            VStack(alignment: .leading, spacing: 8) {
                Text(result.title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(NPColors.textPrimary)
                
                Text(result.subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(NPColors.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(NPColors.bgPrimary)
            
            // Action bar
            HStack(spacing: 0) {
                ResultActionButton(icon: "cart.badge.plus", label: "Add", isHighlighted: isSelected) {
                    onSelect()
                }
                
                ResultActionButton(icon: "slider.horizontal.3", label: "Edit") {
                    onEdit()
                }
                
                ResultActionButton(icon: "arrow.clockwise", label: "Regen") {
                    onRegen()
                }
                
                ResultActionButton(icon: "bookmark", label: "Save") {
                    onSave()
                }
            }
            .background(NPColors.bgPrimary)
            .cornerRadius(16, corners: [.bottomLeft, .bottomRight])
        }
        .background(NPColors.bgPrimary)
        .cornerRadius(16)
        .shadow(color: NPShadow.shadow2.color, radius: NPShadow.shadow2.radius, x: 0, y: NPShadow.shadow2.y)
        .padding(.horizontal, 20)
    }
}

// MARK: - Result Action Button (Light Theme)
struct ResultActionButton: View {
    let icon: String
    let label: String
    var isHighlighted: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            HapticManager.shared.lightTap()
            action()
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(label)
                    .font(.system(size: 11, weight: .medium))
            }
            .foregroundColor(isHighlighted ? NPColors.brandPrimary : NPColors.textSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
    }
}

// MARK: - Generated Result Model
struct GeneratedResult: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let isBestMatch: Bool
    let mockColor: Color
    let mockIcon: String
    
    static let mockResults: [GeneratedResult] = [
        GeneratedResult(
            title: "Option 1",
            subtitle: "Fiery Close-up",
            isBestMatch: true,
            mockColor: Color(red: 0.3, green: 0.2, blue: 0.15),
            mockIcon: "flame.fill"
        ),
        GeneratedResult(
            title: "Option 2",
            subtitle: "Minimal Elegance",
            isBestMatch: false,
            mockColor: Color(red: 0.15, green: 0.2, blue: 0.25),
            mockIcon: "leaf.fill"
        ),
        GeneratedResult(
            title: "Option 3",
            subtitle: "Bold & Vibrant",
            isBestMatch: false,
            mockColor: Color(red: 0.4, green: 0.2, blue: 0.3),
            mockIcon: "sparkles"
        ),
        GeneratedResult(
            title: "Option 4",
            subtitle: "Classic Style",
            isBestMatch: false,
            mockColor: Color(red: 0.2, green: 0.25, blue: 0.3),
            mockIcon: "star.fill"
        )
    ]
}

