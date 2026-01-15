import SwiftUI

// MARK: - Cart Flow Navigation
enum CartFlowStep {
    case cart
    case platformSelection
    case mockupPreview
    case exporting
}

struct CartFlowView: View {
    @Binding var items: [GeneratedImage]
    @Environment(\.dismiss) var dismiss
    
    @State private var currentStep: CartFlowStep = .cart
    @State private var selectedPlatform: MarketingPlatform = .xiaohongshu
    @State private var selectedSizes: Set<AssetSize> = []
    @State private var exportItems: [ExportItem] = []
    @State private var exportProgress: Double = 0
    
    var body: some View {
        NavigationView {
            Group {
                switch currentStep {
                case .cart:
                    cartView
                case .platformSelection:
                    platformSelectionView
                case .mockupPreview:
                    mockupPreviewView
                case .exporting:
                    exportingView
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if currentStep != .cart {
                        Button(action: goBack) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    var navigationTitle: String {
        switch currentStep {
        case .cart: return "购物车"
        case .platformSelection: return "选择平台尺寸"
        case .mockupPreview: return "效果预览"
        case .exporting: return "生成物料"
        }
    }
    
    func goBack() {
        withAnimation {
            switch currentStep {
            case .platformSelection: currentStep = .cart
            case .mockupPreview: currentStep = .platformSelection
            case .exporting: currentStep = .mockupPreview
            default: break
            }
        }
    }
    
    // MARK: - Cart View
    var cartView: some View {
        VStack(spacing: 0) {
            if items.isEmpty {
                emptyCartView
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(items) { item in
                            CartItemCardEnhanced(image: item) {
                                withAnimation {
                                    items.removeAll { $0.id == item.id }
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                cartFooter
            }
        }
    }
    
    var emptyCartView: some View {
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
    }
    
    var cartFooter: some View {
        VStack(spacing: 12) {
            Divider()
            HStack {
                Text("已选 \(items.count) 张")
                    .font(.subheadline)
                    .foregroundColor(NPColors.textSecondary)
                Spacer()
                Button(action: {
                    HapticManager.shared.mediumTap()
                    withAnimation {
                        currentStep = .platformSelection
                    }
                }) {
                    HStack {
                        Text("下一步")
                        Image(systemName: "chevron.right")
                    }
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
    
    // MARK: - Platform Selection View
    var platformSelectionView: some View {
        VStack(spacing: 0) {
            // Selected images preview
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(items) { item in
                        Rectangle()
                            .fill(thumbnailColor(for: item.imageName))
                            .frame(width: 60, height: 80)
                            .overlay(
                                Image(systemName: thumbnailIcon(for: item.imageName))
                                    .font(.system(size: 24))
                                    .foregroundColor(thumbnailIconColor(for: item.imageName))
                            )
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
            .background(NPColors.bgSecondary)
            
            // Platform Tabs
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(MarketingPlatform.allCases) { platform in
                        platformTab(platform)
                    }
                }
                .padding()
            }
            
            // Size Cards
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(selectedPlatform.sizes) { size in
                        sizeCard(size)
                    }
                }
                .padding()
            }
            
            // Footer
            platformSelectionFooter
        }
    }
    
    func platformTab(_ platform: MarketingPlatform) -> some View {
        Button(action: {
            withAnimation {
                selectedPlatform = platform
                HapticManager.shared.selection()
            }
        }) {
            HStack(spacing: 6) {
                Image(systemName: platform.icon)
                    .font(.system(size: 14))
                Text(platform.rawValue)
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundColor(selectedPlatform == platform ? .white : NPColors.textPrimary)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                selectedPlatform == platform ?
                AnyView(platform.color) :
                AnyView(NPColors.bgSecondary)
            )
            .cornerRadius(20)
        }
    }
    
    func sizeCard(_ size: AssetSize) -> some View {
        let isSelected = selectedSizes.contains(size)
        
        return Button {
            withAnimation {
                if isSelected {
                    selectedSizes.remove(size)
                } else {
                    selectedSizes.insert(size)
                }
                HapticManager.shared.selection()
            }
        } label: {
            HStack(spacing: 16) {
                // Size preview icon
                RoundedRectangle(cornerRadius: 6)
                    .stroke(NPColors.textTertiary, lineWidth: 1)
                    .aspectRatio(size.aspectRatio, contentMode: .fit)
                    .frame(width: 48)
                    .overlay(
                        Text(size.ratio)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(NPColors.textTertiary)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(size.name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(NPColors.textPrimary)
                        
                        if size.isRecommended {
                            Text("推荐")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(selectedPlatform.color)
                                .cornerRadius(4)
                        }
                    }
                    
                    Text(size.displaySize)
                        .font(.system(size: 13))
                        .foregroundColor(NPColors.textSecondary)
                    
                    Text(size.description)
                        .font(.system(size: 12))
                        .foregroundColor(NPColors.textTertiary)
                }
                
                Spacer()
                
                // Checkbox
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? selectedPlatform.color : NPColors.textTertiary)
            }
            .padding()
            .background(NPColors.bgSecondary)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? selectedPlatform.color : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    var platformSelectionFooter: some View {
        VStack(spacing: 12) {
            Divider()
            HStack {
                Text("已选 \(selectedSizes.count) 个尺寸")
                    .font(.subheadline)
                    .foregroundColor(NPColors.textSecondary)
                Spacer()
                
                Button(action: {
                    HapticManager.shared.mediumTap()
                    withAnimation {
                        currentStep = .mockupPreview
                    }
                }) {
                    Text("预览效果")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(selectedSizes.isEmpty ? Color.gray : NPColors.brandPrimary)
                        .cornerRadius(12)
                }
                .disabled(selectedSizes.isEmpty)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .background(NPColors.bgPrimary)
    }
    
    // MARK: - Mockup Preview View
    var mockupPreviewView: some View {
        VStack(spacing: 0) {
            // Platform mockup
            ZStack {
                Color(white: 0.95)
                
                VStack(spacing: 0) {
                    // Mock phone frame
                    mockPhoneFrame
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Generate button
            VStack(spacing: 12) {
                Divider()
                Button(action: {
                    startExport()
                }) {
                    HStack {
                        Image(systemName: "arrow.down.doc.fill")
                        Text("生成物料 (\(items.count) × \(selectedSizes.count))")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(NPColors.brandPrimary)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
            .background(NPColors.bgPrimary)
        }
    }
    
    var mockPhoneFrame: some View {
        VStack(spacing: 0) {
            // Status bar mock
            HStack {
                Text("9:41")
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "cellularbars")
                    Image(systemName: "wifi")
                    Image(systemName: "battery.100")
                }
                .font(.system(size: 12))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            
            // App header mock
            HStack {
                Image(systemName: selectedPlatform.icon)
                    .foregroundColor(selectedPlatform.color)
                Text(selectedPlatform.rawValue)
                    .font(.system(size: 18, weight: .bold))
                Spacer()
            }
            .padding()
            .background(Color.white)
            
            // Content mock
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(items.prefix(4)) { item in
                        Rectangle()
                            .fill(thumbnailColor(for: item.imageName))
                            .aspectRatio(selectedSizes.first?.aspectRatio ?? 1, contentMode: .fit)
                            .overlay(
                                Image(systemName: thumbnailIcon(for: item.imageName))
                                    .font(.system(size: 32))
                                    .foregroundColor(thumbnailIconColor(for: item.imageName))
                            )
                            .cornerRadius(8)
                    }
                }
                .padding(8)
            }
        }
        .frame(width: 280, height: 500)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
    }
    
    // MARK: - Exporting View
    var exportingView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            if exportProgress < 1 {
                VStack(spacing: 16) {
                    ProgressView(value: exportProgress)
                        .progressViewStyle(LinearProgressViewStyle(tint: NPColors.brandPrimary))
                        .frame(width: 200)
                    
                    Text("正在生成物料...")
                        .font(.headline)
                        .foregroundColor(NPColors.textPrimary)
                    
                    Text("\(Int(exportProgress * 100))%")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(NPColors.brandPrimary)
                }
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 64))
                        .foregroundColor(.green)
                    
                    Text("生成完成！")
                        .font(.title2.bold())
                        .foregroundColor(NPColors.textPrimary)
                    
                    Text("共 \(items.count * selectedSizes.count) 张物料")
                        .font(.subheadline)
                        .foregroundColor(NPColors.textSecondary)
                }
            }
            
            Spacer()
            
            if exportProgress >= 1 {
                VStack(spacing: 12) {
                    Button(action: {
                        HapticManager.shared.success()
                        // Simulate download
                    }) {
                        HStack {
                            Image(systemName: "arrow.down.circle.fill")
                            Text("批量下载")
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(NPColors.brandPrimary)
                        .cornerRadius(12)
                    }
                    
                    Button(action: {
                        HapticManager.shared.lightTap()
                        // Simulate share
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("分享到平台")
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(NPColors.brandPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(NPColors.bgSecondary)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
    }
    
    func startExport() {
        withAnimation {
            currentStep = .exporting
            exportProgress = 0
        }
        
        // Simulate export progress
        let totalItems = items.count * selectedSizes.count
        let progressPerItem = 1.0 / Double(totalItems)
        
        for i in 0..<totalItems {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.5) {
                withAnimation {
                    exportProgress = min(Double(i + 1) * progressPerItem, 1.0)
                }
                
                if i == totalItems - 1 {
                    HapticManager.shared.success()
                }
            }
        }
    }
    
    // MARK: - Helpers
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
}

// MARK: - Enhanced Cart Item Card
struct CartItemCardEnhanced: View {
    let image: GeneratedImage
    let onRemove: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 8) {
                Rectangle()
                    .fill(thumbnailColor)
                    .aspectRatio(3/4, contentMode: .fit)
                    .overlay(
                        Image(systemName: thumbnailIcon)
                            .font(.system(size: 40))
                            .foregroundColor(thumbnailIconColor)
                    )
                    .cornerRadius(12)
                
                Text("营销图片")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(NPColors.textPrimary)
                
                Text("原始尺寸")
                    .font(.system(size: 11))
                    .foregroundColor(NPColors.textTertiary)
            }
            
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
    
    var thumbnailColor: Color {
        switch image.imageName {
        case "cake": return Color.pink.opacity(0.2)
        case "coffee": return Color.brown.opacity(0.2)
        default: return Color.gray.opacity(0.2)
        }
    }
    
    var thumbnailIcon: String {
        switch image.imageName {
        case "cake": return "birthday.cake.fill"
        case "coffee": return "cup.and.saucer.fill"
        default: return "photo"
        }
    }
    
    var thumbnailIconColor: Color {
        switch image.imageName {
        case "cake": return .pink
        case "coffee": return .brown
        default: return .gray
        }
    }
}
