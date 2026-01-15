import SwiftUI

struct HomeView: View {
    @State private var messages: [ChatMessage] = []
    @State private var inputText: String = ""
    @State private var showSuggestions = true
    @State private var showEditor = false
    @State private var selectedImageForEditing: GeneratedImage?
    @State private var conversationState: ConversationState = .idle
    
    // Cart State
    @State private var cartItems: [GeneratedImage] = []
    @State private var showCartDrawer = false
    
    // Generation Results
    @State private var showGenerationResults = false
    @State private var currentPrompt: String = ""
    
    enum ConversationState {
        case idle
        case intentConfirmed // Round 1
        case styleSelection // Round 2
        case advancedOptions // Round 3
        case generating // Round 4
        case completed
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                // Logo
                HStack(spacing: 8) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(NPColors.brandGradient)
                            .frame(width: 36, height: 36)
                        Image(systemName: "sparkles")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                    Text("NicePoster")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(NPColors.textPrimary)
                }
                
                Spacer()
                
                // User avatar
                Circle()
                    .stroke(NPColors.textTertiary.opacity(0.3), lineWidth: 1)
                    .frame(width: 36, height: 36)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 16))
                            .foregroundColor(NPColors.textTertiary)
                    )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(NPColors.bgPrimary)
            
            // Content area
            ZStack(alignment: .bottomTrailing) {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 20) {
                            // AI Greeting Bubble
                            if messages.isEmpty {
                                HStack(alignment: .top, spacing: 12) {
                                    // AI Avatar
                                    ZStack {
                                        Circle()
                                            .fill(NPColors.brandGradient)
                                            .frame(width: 36, height: 36)
                                        Image(systemName: "sparkles")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    
                                    // Speech Bubble
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Hi! Ready to create")
                                            .font(.system(size: 22, weight: .semibold))
                                            .foregroundColor(NPColors.textPrimary)
                                        HStack(spacing: 4) {
                                            Text("something")
                                                .font(.system(size: 22, weight: .semibold))
                                                .foregroundColor(NPColors.textPrimary)
                                            Text("amazing")
                                                .font(.system(size: 22, weight: .bold))
                                                .foregroundStyle(NPColors.brandGradient)
                                            Text("today?")
                                                .font(.system(size: 22, weight: .semibold))
                                                .foregroundColor(NPColors.textPrimary)
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 14)
                                    .background(NPColors.bgSecondary)
                                    .cornerRadius(16)
                                    .cornerRadius(4, corners: [.topLeft])
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 12)
                            }
                            
                            // Message History
                            ForEach(messages) { message in
                                ChatBubble(
                                    message: message,
                                    onImageTap: { image in
                                        selectedImageForEditing = image
                                    },
                                    onImageAction: { image, action in
                                        handleImageAction(image: image, action: action)
                                    }
                                )
                                .id(message.id)
                            }
                            
                            // Horizontal Inspiration Cards
                            if showSuggestions && messages.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(mockInspirations) { item in
                                            InspirationCardCompact(item: item) {
                                                sendMessage(content: item.title)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                                
                                // AI Status Text
                                Text("AI is analyzing your recent templates...")
                                    .font(.system(size: 14))
                                    .foregroundColor(NPColors.textTertiary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 24)
                            }
                            
                            // Bottom padding
                            Color.clear.frame(height: 100)
                        }
                        .padding(.top, 8)
                    }
                    .onChange(of: messages.count) {
                        if let lastId = messages.last?.id {
                            withAnimation {
                                proxy.scrollTo(lastId, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // Cart FAB
                if !cartItems.isEmpty {
                    CartFAB(count: cartItems.count) {
                        HapticManager.shared.mediumTap()
                        showCartDrawer = true
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .background(NPColors.bgPrimary)
            
            // Input Bar - outside ZStack for proper touch handling
            HomeInputBar(
                text: $inputText,
                onSend: { sendMessage(content: inputText) },
                onCameraTap: { showEditor = true },
                onStyleTap: {}
            )
        }
        .background(NPColors.bgPrimary.ignoresSafeArea())
        .sheet(isPresented: $showCartDrawer) {
            CartFlowView(items: $cartItems)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .fullScreenCover(item: $selectedImageForEditing) { image in
            ConversationalEditorView(imageName: image.imageName)
        }
        .fullScreenCover(isPresented: $showEditor) {
            ConversationalEditorView(imageName: nil)
        }
        .fullScreenCover(isPresented: $showGenerationResults) {
            GenerationResultsView(
                prompt: currentPrompt,
                onDismiss: {
                    showGenerationResults = false
                },
                onPreviewResults: { results in
                    showGenerationResults = false
                    showCartDrawer = true
                }
            )
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func sendMessage(content: String) {
        guard !content.isEmpty else { return }
        
        let userMsg = ChatMessage(isUser: true, content: content, type: .text)
        withAnimation {
            messages.append(userMsg)
            inputText = ""
            showSuggestions = false
        }
        
        handleConversationFlow(userContent: content)
    }
    
    func handleConversationFlow(userContent: String) {
        // Show thinking state immediately
        let thinkingMsg = ChatMessage(
            isUser: false,
            content: "",
            type: .thinking
        )
        withAnimation {
            messages.append(thinkingMsg)
            conversationState = .generating
        }
        
        // Save prompt and navigate to results after 2 seconds
        currentPrompt = userContent
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            conversationState = .completed
            HapticManager.shared.success()
            showGenerationResults = true
        }
    }
    
    func handleImageAction(image: GeneratedImage, action: ImageAction) {
        switch action {
        case .addToCart:
            if !cartItems.contains(where: { $0.id == image.id }) {
                withAnimation(.spring()) {
                    cartItems.append(image)
                }
            }
        case .edit:
            selectedImageForEditing = image
        case .regenerate:
            // TODO: Implement regeneration
            HapticManager.shared.warning()
        case .delete:
            // TODO: Implement deletion from results
            HapticManager.shared.warning()
        }
    }
}

// MARK: - Cart FAB Button
struct CartFAB: View {
    let count: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                Circle()
                    .fill(NPColors.brandPrimary)
                    .frame(width: 56, height: 56)
                    .shadow(color: NPColors.brandPrimary.opacity(0.4), radius: 8, x: 0, y: 4)
                    .overlay(
                        Image(systemName: "cart.fill")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)
                    )
                
                // Badge
                Text("\(count)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .padding(6)
                    .background(Circle().fill(Color.red))
                    .offset(x: 8, y: -4)
            }
        }
        .buttonStyle(NPButtonStyle())
    }
}

// MARK: - Cart Drawer View
struct CartDrawerView: View {
    @Binding var items: [GeneratedImage]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if items.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "cart")
                            .font(.system(size: 48))
                            .foregroundColor(NPColors.textTertiary)
                        Text("购物车是空的")
                            .font(.headline)
                            .foregroundColor(NPColors.textSecondary)
                        Text("长按图片选择「加入购物车」来添加")
                            .font(.subheadline)
                            .foregroundColor(NPColors.textTertiary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(items) { item in
                                SimpleCartItemCard(image: item) {
                                    withAnimation {
                                        items.removeAll { $0.id == item.id }
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    
                    // Checkout Button
                    VStack(spacing: 12) {
                        Divider()
                        HStack {
                            Text("已选 \(items.count) 张")
                                .font(.subheadline)
                                .foregroundColor(NPColors.textSecondary)
                            Spacer()
                            Button(action: {
                                HapticManager.shared.success()
                                // TODO: Checkout action
                            }) {
                                Text("全部下载")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(NPColors.brandPrimary)
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    }
                    .background(NPColors.bgPrimary)
                }
            }
            .navigationTitle("购物车")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Simple Cart Item Card
struct SimpleCartItemCard: View {
    let image: GeneratedImage
    let onRemove: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Rectangle()
                .fill(Color.white)
                .aspectRatio(3/4, contentMode: .fit)
                .overlay(
                    Group {
                        if image.imageName == "cake" {
                            Image(systemName: "birthday.cake.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.pink.opacity(0.5))
                        } else if image.imageName == "coffee" {
                            Image(systemName: "cup.and.saucer.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.brown.opacity(0.5))
                        } else {
                            Image(systemName: "photo")
                                .font(.system(size: 40))
                                .foregroundColor(.gray.opacity(0.5))
                        }
                    }
                )
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            
            // Remove button
            Button(action: {
                HapticManager.shared.lightTap()
                onRemove()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(.white, .red)
            }
            .padding(8)
        }
    }
}
