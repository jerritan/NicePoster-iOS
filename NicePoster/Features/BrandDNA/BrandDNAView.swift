import SwiftUI

// MARK: - Brand DNA View (Bento Box Layout)
struct BrandDNAView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showAddAsset = false
    
    var body: some View {
        ZStack {
            // Background
            NPColors.bgPrimary.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                header
                
                // Bento Grid
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Top Row: Moodboard + Palette/Icons
                        topBentoRow
                        
                        // Main Asset Card
                        mainAssetCard
                        
                        // Typography Section
                        typographySection
                        
                        // Font Sample
                        fontSampleCard
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 100)
                }
            }
            
            // Floating Add Button
            VStack {
                Spacer()
                addButton
            }
        }
    }
    
    // MARK: - Header
    var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("CAMPAIGN ASSETS")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(NPColors.brandPrimary)
                    .tracking(1.2)
                
                Text("Brand DNA")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(NPColors.textPrimary)
            }
            
            Spacer()
            
            Button(action: {
                HapticManager.shared.lightTap()
            }) {
                Image(systemName: "person.fill")
                    .font(.system(size: 18))
                    .foregroundColor(NPColors.textSecondary)
                    .frame(width: 44, height: 44)
                    .background(NPColors.bgSecondary)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    // MARK: - Top Bento Row
    var topBentoRow: some View {
        HStack(alignment: .top, spacing: 12) {
            // Moodboard Card (Large)
            MoodboardCard()
            
            // Right Column: Palette + Icons
            VStack(spacing: 12) {
                PaletteCard()
                IconsCard()
            }
        }
    }
    
    // MARK: - Main Asset Card
    var mainAssetCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Badge
            HStack(spacing: 6) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 12))
                    .foregroundColor(NPColors.brandPrimary)
                Text("MAIN ASSET")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(NPColors.brandPrimary)
                    .tracking(0.8)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("NicePoster")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(NPColors.textPrimary)
                    
                    Text("Primary logo lockup with\niridescent finish.")
                        .font(.system(size: 14))
                        .foregroundColor(NPColors.textSecondary)
                        .lineSpacing(2)
                }
                
                Spacer()
                
                // Logo Icon with Pearl Effect
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.95, green: 0.95, blue: 0.98),
                                    Color(red: 0.9, green: 0.92, blue: 0.98)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 64, height: 64)
                    
                    Image(systemName: "fingerprint")
                        .font(.system(size: 28, weight: .light))
                        .foregroundColor(NPColors.textPrimary.opacity(0.6))
                }
            }
        }
        .padding(20)
        .background(NPColors.bgSecondary)
        .cornerRadius(20)
    }
    
    // MARK: - Typography Section
    var typographySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Typography")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(NPColors.textPrimary)
                
                Spacer()
                
                Text("2 Families")
                    .font(.system(size: 13))
                    .foregroundColor(NPColors.textTertiary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(NPColors.bgTertiary)
                    .cornerRadius(12)
            }
            
            HStack(spacing: 16) {
                // Epilogue Font
                FontCard(
                    fontName: "Epilogue",
                    usage: "Headlines & Display",
                    sample: "Aa",
                    isSerif: false
                )
                
                // Manrope Font
                FontCard(
                    fontName: "Manrope",
                    usage: "Body & Metadata",
                    sample: "Aa",
                    isSerif: false
                )
            }
        }
    }
    
    // MARK: - Font Sample Card
    var fontSampleCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Text("Sample:")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(NPColors.textSecondary)
                
                Text("The quick brown fox jumps over the lazy dog. 1234567890")
                    .font(.system(size: 14))
                    .foregroundColor(NPColors.textTertiary)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(NPColors.bgSecondary)
        .cornerRadius(16)
    }
    
    // MARK: - Add Button
    var addButton: some View {
        Button(action: {
            HapticManager.shared.mediumTap()
            showAddAsset = true
        }) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(NPColors.brandPrimary)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(.white)
                        .shadow(color: NPColors.brandPrimary.opacity(0.3), radius: 12, x: 0, y: 6)
                )
        }
        .padding(.bottom, 32)
    }
}

// MARK: - Moodboard Card
struct MoodboardCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image Area
            ZStack(alignment: .topLeading) {
                // Warm gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.95, green: 0.88, blue: 0.85),
                        Color(red: 0.92, green: 0.85, blue: 0.82)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Mock moodboard image
                VStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(red: 0.85, green: 0.75, blue: 0.7))
                        .frame(width: 80, height: 100)
                        .rotationEffect(.degrees(-5))
                        .offset(x: 30, y: -20)
                }
                
                // NEW Badge
                Text("NEW")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(NPColors.brandPrimary)
                    .cornerRadius(6)
                    .padding(12)
            }
            .frame(height: 160)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            // Text
            VStack(alignment: .leading, spacing: 4) {
                Text("Moodboard")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(NPColors.textPrimary)
                
                Text("Ethereal directions for\nQ3 campaign.")
                    .font(.system(size: 13))
                    .foregroundColor(NPColors.textSecondary)
                    .lineSpacing(2)
            }
            .padding(.horizontal, 4)
            .padding(.top, 12)
        }
        .padding(12)
        .background(NPColors.bgSecondary)
        .cornerRadius(20)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Palette Card
struct PaletteCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Palette")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(NPColors.textPrimary)
                
                Spacer()
                
                Image(systemName: "paintpalette")
                    .font(.system(size: 14))
                    .foregroundColor(NPColors.textTertiary)
            }
            
            // Color Bubbles
            HStack(spacing: -8) {
                Circle()
                    .fill(Color(hex: "00AACC"))
                    .frame(width: 36, height: 36)
                
                Circle()
                    .fill(Color(hex: "101718"))
                    .frame(width: 36, height: 36)
                
                Circle()
                    .fill(Color(hex: "FFCCE0"))
                    .frame(width: 36, height: 36)
            }
            
            Text("#00AACC · #101718")
                .font(.system(size: 11))
                .foregroundColor(NPColors.textTertiary)
        }
        .padding(16)
        .background(NPColors.bgSecondary)
        .cornerRadius(16)
    }
}

// MARK: - Icons Card
struct IconsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Icons")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(NPColors.textPrimary)
                
                Spacer()
            }
            
            Text("Line Art · 1.5px")
                .font(.system(size: 12))
                .foregroundColor(NPColors.textTertiary)
            
            // Icon Examples
            HStack(spacing: 16) {
                Image(systemName: "leaf")
                    .font(.system(size: 20, weight: .light))
                    .foregroundColor(NPColors.textPrimary)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 20, weight: .light))
                    .foregroundColor(NPColors.textPrimary)
                
                Image(systemName: "circle.grid.3x3")
                    .font(.system(size: 20, weight: .light))
                    .foregroundColor(NPColors.textPrimary)
            }
        }
        .padding(16)
        .background(NPColors.bgSecondary)
        .cornerRadius(16)
    }
}

// MARK: - Font Card
struct FontCard: View {
    let fontName: String
    let usage: String
    let sample: String
    let isSerif: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(sample)
                .font(.system(size: 40, weight: .bold, design: isSerif ? .serif : .default))
                .foregroundColor(NPColors.textPrimary)
            
            Text(fontName)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(NPColors.textPrimary)
            
            Text(usage)
                .font(.system(size: 12))
                .foregroundColor(NPColors.brandPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(NPColors.bgSecondary)
        .cornerRadius(16)
    }
}

// MARK: - Preview
#Preview {
    BrandDNAView()
}
