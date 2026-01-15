import SwiftUI

struct SuggestionGrid: View {
    let suggestions = [
        ("情人节甜品推广", "适合节日营销", "heart.fill"),
        ("新品上市预热", "提升期待感", "flame.fill"),
        ("周末限时折扣", "刺激到店消费", "clock.fill"),
        ("精选套餐推荐", "提高客单价", "star.fill")
    ]
    
    var onSelect: (String) -> Void
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(0..<suggestions.count, id: \.self) { index in
                SuggestionCard(
                    title: suggestions[index].0,
                    subtitle: suggestions[index].1,
                    icon: suggestions[index].2
                ) {
                    onSelect(suggestions[index].0)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

struct SuggestionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            HapticManager.shared.lightTap()
            action()
        }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(NPColors.brandPrimary)
                        .font(.system(size: 20))
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(NPColors.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(NPColors.textSecondary)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(NPButtonStyle())
    }
}
