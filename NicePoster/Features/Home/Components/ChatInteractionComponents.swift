import SwiftUI
import Combine

struct StyleOptionCard: View {
    let option: StyleOption
    @State private var isSelected = false
    
    var body: some View {
        Button(action: {
            withAnimation {
                isSelected.toggle()
                HapticManager.shared.selection()
            }
        }) {
            HStack(spacing: 12) {
                // Icon
                ZStack {
                    Circle()
                        .fill(isSelected ? NPColors.brandPrimary.opacity(0.1) : Color.white)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: option.icon)
                        .font(.system(size: 20))
                        .foregroundColor(isSelected ? NPColors.brandPrimary : NPColors.textSecondary)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(option.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(NPColors.textPrimary)
                    
                    if let subtitle = option.subtitle {
                        Text(subtitle)
                            .font(.system(size: 12))
                            .foregroundColor(NPColors.textSecondary)
                    }
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(NPColors.brandPrimary)
                        .font(.system(size: 20))
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(NPColors.textSecondary.opacity(0.5))
                        .font(.system(size: 20))
                }
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? NPColors.brandPrimary : Color.clear, lineWidth: 1.5)
            )
            .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(NPButtonStyle())
    }
}

struct ThinkingBubble: View {
    @State private var stepIndex = 0
    let steps = [
        "正在分析品牌视觉规则...",
        "正在生成摄影方案...",
        "正在创作图像..."
    ]
    
    let timer = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .symbolEffect(.pulse)
                    .foregroundColor(NPColors.brandPrimary)
                Text("Perfect! 让我开始为你构思 4 张营销图...")
                    .font(.system(size: 17))
                    .foregroundColor(NPColors.textPrimary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(0..<steps.count, id: \.self) { index in
                    HStack(spacing: 8) {
                        if index < stepIndex {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(NPColors.success)
                                .font(.system(size: 14))
                        } else if index == stepIndex {
                            ProgressView()
                                .scaleEffect(0.8)
                                .frame(width: 14, height: 14)
                        } else {
                            Circle()
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1.5)
                                .frame(width: 14, height: 14)
                        }
                        
                        Text(steps[index])
                            .font(.system(size: 14))
                            .foregroundColor(index <= stepIndex ? NPColors.textPrimary : NPColors.textSecondary)
                            .opacity(index <= stepIndex ? 1 : 0.6)
                    }
                }
            }
            .padding(.leading, 4)
        }
        .padding(16)
        .background(NPColors.bgSecondary)
        .cornerRadius(16)
        .onReceive(timer) { _ in
            if stepIndex < steps.count {
                withAnimation {
                    stepIndex += 1
                }
            }
        }
    }
}
