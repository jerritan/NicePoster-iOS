import SwiftUI

// MARK: - Chat History View Extension
extension ConversationalEditorView {
    var chatHistoryView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(editMessages) { msg in
                        editMessageBubble(msg)
                            .id(msg.id)
                    }
                }
                .padding()
            }
            .frame(height: 140)
            .background(Color(white: 0.08))
            .onChange(of: editMessages.count) {
                if let lastId = editMessages.last?.id {
                    withAnimation {
                        proxy.scrollTo(lastId, anchor: .bottom)
                    }
                }
            }
        }
    }
    
    func editMessageBubble(_ msg: EditMessage) -> some View {
        HStack {
            if msg.isUser { Spacer() }
            
            Text(msg.content)
                .font(.system(size: 15))
                .foregroundColor(msg.isUser ? .white : .white.opacity(0.9))
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    msg.isUser ?
                    AnyView(NPColors.brandGradient.cornerRadius(16)) :
                    AnyView(Color(white: 0.2).cornerRadius(16))
                )
            
            if !msg.isUser { Spacer() }
        }
    }
}

// MARK: - Brush Tools Bar Extension
extension ConversationalEditorView {
    var brushToolsBar: some View {
        HStack(spacing: 20) {
            ForEach(BrushTool.allCases, id: \.self) { tool in
                Button(action: {
                    selectedBrushTool = tool
                    HapticManager.shared.selection()
                    
                    if tool == .upload {
                        handleUploadTap()
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tool.rawValue)
                            .font(.system(size: 22))
                            .foregroundColor(selectedBrushTool == tool ? NPColors.brandPrimary : .white)
                        Text(brushToolLabel(tool))
                            .font(.system(size: 11))
                            .foregroundColor(selectedBrushTool == tool ? NPColors.brandPrimary : .gray)
                    }
                    .frame(width: 60)
                }
            }
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    editorState = .processing
                    simulateProcessing()
                }
            }) {
                Text("确认选区")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(NPColors.brandPrimary)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(white: 0.1))
    }
    
    func brushToolLabel(_ tool: BrushTool) -> String {
        switch tool {
        case .select: return "框选"
        case .mask: return "涂抹"
        case .upload: return "上传"
        }
    }
    
    func handleUploadTap() {
        addAIMessage("请选择要上传的图片 📷")
        HapticManager.shared.mediumTap()
    }
    
    func simulateProcessing() {
        addAIMessage("正在处理中... ⏳")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation {
                editorState = .showingComparison
                showComparison = true
                addAIMessage("完成啦！✨ 左右滑动对比效果")
                HapticManager.shared.success()
            }
        }
    }
}

// MARK: - Bottom Toolbar Extension
extension ConversationalEditorView {
    var bottomToolbar: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Image(systemName: "sparkles")
                    .foregroundColor(NPColors.brandPrimary)
                
                TextField("告诉我怎么修改...", text: $inputText)
                    .submitLabel(.send)
                    .foregroundColor(.white)
                    .onSubmit {
                        sendEditMessage()
                    }
                
                if !inputText.isEmpty {
                    Button(action: sendEditMessage) {
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
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    quickActionButton("替换元素", icon: "arrow.triangle.2.circlepath")
                    quickActionButton("添加元素", icon: "plus.rectangle.on.rectangle")
                    quickActionButton("调整光线", icon: "sun.max")
                    quickActionButton("放大高清", icon: "arrow.up.left.and.arrow.down.right")
                    quickActionButton("消除物体", icon: "eraser")
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 20)
        }
        .background(Color.black)
    }
    
    func quickActionButton(_ title: String, icon: String) -> some View {
        Button(action: {
            inputText = title
            HapticManager.shared.lightTap()
        }) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                Text(title)
                    .font(.system(size: 13))
            }
            .foregroundColor(.white.opacity(0.8))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(white: 0.2))
            .cornerRadius(16)
        }
    }
    
    func sendEditMessage() {
        guard !inputText.isEmpty else { return }
        
        let userMsg = inputText
        addUserMessage(userMsg)
        inputText = ""
        HapticManager.shared.lightTap()
        
        processUserIntent(userMsg)
    }
    
    func processUserIntent(_ message: String) {
        let lowercased = message.lowercased()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            if lowercased.contains("替换") || lowercased.contains("换成") {
                addAIMessage("好的，请框选要替换的区域 🎯")
                withAnimation {
                    editorState = .waitingForSelection
                }
            } else if lowercased.contains("添加") || lowercased.contains("加个") {
                addAIMessage("好的，请框选要添加元素的位置 🎯")
                withAnimation {
                    editorState = .waitingForSelection
                }
            } else if lowercased.contains("光线") || lowercased.contains("提亮") || lowercased.contains("暗") {
                withAnimation {
                    editorState = .processing
                }
                addAIMessage("正在调整光线... ⏳")
                simulateQuickEdit("光线调整完成！✨")
            } else if lowercased.contains("放大") || lowercased.contains("高清") || lowercased.contains("4k") {
                withAnimation {
                    editorState = .processing
                }
                addAIMessage("正在放大至高清... ⏳")
                simulateQuickEdit("已放大至 4K 高清！✨")
            } else if lowercased.contains("消除") || lowercased.contains("删除") || lowercased.contains("去掉") {
                addAIMessage("好的，请涂抹要消除的区域 🎯")
                withAnimation {
                    editorState = .waitingForSelection
                    selectedBrushTool = .mask
                }
            } else {
                addAIMessage("收到！让我看看怎么处理... 🤔\n请先框选需要修改的区域")
                withAnimation {
                    editorState = .waitingForSelection
                }
            }
            
            HapticManager.shared.success()
        }
    }
    
    func simulateQuickEdit(_ successMessage: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation {
                editorState = .idle
                addAIMessage(successMessage)
                HapticManager.shared.success()
            }
        }
    }
}

// MARK: - Comparison Slider Extension
extension ConversationalEditorView {
    func comparisonSliderView(geometry: GeometryProxy) -> some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(width: 2)
                .position(x: geometry.size.width * comparisonProgress, y: geometry.size.height / 2)
            
            Circle()
                .fill(Color.white)
                .frame(width: 32, height: 32)
                .overlay(
                    Image(systemName: "arrow.left.arrow.right")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black)
                )
                .position(x: geometry.size.width * comparisonProgress, y: geometry.size.height / 2)
                .gesture(
                    DragGesture()
                        .onChanged { val in
                            comparisonProgress = min(max(val.location.x / geometry.size.width, 0), 1)
                        }
                )
        }
    }
    
    var processingOverlay: some View {
        ZStack {
            Color.black.opacity(0.7).ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(NPColors.brandPrimary)
                
                Text("AI 正在处理...")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("请稍候，马上就好")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(32)
            .background(Color(white: 0.15).cornerRadius(16))
        }
    }
}
