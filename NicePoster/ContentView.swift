//
//  ContentView.swift
//  NicePoster
//
//  Created by Haishan Tan on 2026/1/15.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        AppMainTabView()
    }
}

// MARK: - Main Tab View
struct AppMainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("首页")
                }
                .tag(0)
            
            CampaignListView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "folder.fill" : "folder")
                    Text("活动")
                }
                .tag(1)
            
            CartTabView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "cart.fill" : "cart")
                    Text("购物车")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "person.fill" : "person")
                    Text("我的")
                }
                .tag(3)
        }
        .tint(NPColors.brandPrimary)
    }
}

// MARK: - Cart Tab View (Light Theme)
struct CartTabView: View {
    @State private var cartItems: [GeneratedImage] = GeneratedImage.mockCartItems
    @State private var showOutputSelection = false
    
    var body: some View {
        ZStack {
            NPColors.bgPrimary.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("购物车")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(NPColors.textPrimary)
                    
                    Spacer()
                    
                    if !cartItems.isEmpty {
                        Text("\(cartItems.count) 张图片")
                            .font(.system(size: 14))
                            .foregroundColor(NPColors.textSecondary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                if cartItems.isEmpty {
                    // Empty State
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "cart")
                            .font(.system(size: 64))
                            .foregroundColor(NPColors.textTertiary)
                        Text("购物车是空的")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(NPColors.textSecondary)
                        Text("在首页生成图片后添加到购物车")
                            .font(.system(size: 14))
                            .foregroundColor(NPColors.textTertiary)
                    }
                    Spacer()
                } else {
                    // Cart Items Grid
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12)
                        ], spacing: 12) {
                            ForEach(cartItems) { item in
                                CartItemThumbnail(item: item)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                    
                    // Export Button
                    VStack(spacing: 0) {
                        Button(action: {
                            HapticManager.shared.mediumTap()
                            showOutputSelection = true
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("导出所有图片")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(NPColors.brandPrimary)
                            .cornerRadius(16)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                    .background(
                        Rectangle()
                            .fill(NPColors.bgPrimary)
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: -5)
                            .ignoresSafeArea()
                    )
                }
            }
        }
        .fullScreenCover(isPresented: $showOutputSelection) {
            OutputSelectionView(
                cartItems: $cartItems,
                onDismiss: { showOutputSelection = false },
                onPreviewMockup: { showOutputSelection = false }
            )
        }
    }
}

// MARK: - Cart Item Thumbnail
struct CartItemThumbnail: View {
    let item: GeneratedImage
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(item.mockColor)
                .aspectRatio(1, contentMode: .fit)
            
            Image(systemName: item.mockIcon)
                .font(.system(size: 24))
                .foregroundColor(.white.opacity(0.5))
        }
        .shadow(color: NPShadow.shadow1.color, radius: NPShadow.shadow1.radius, x: 0, y: NPShadow.shadow1.y)
    }
}

// MARK: - Profile View (Light Theme)
struct ProfileView: View {
    var body: some View {
        ZStack {
            NPColors.bgPrimary.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack(spacing: 16) {
                        Circle()
                            .fill(NPColors.brandGradient)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 36))
                                    .foregroundColor(.white)
                            )
                        
                        VStack(spacing: 4) {
                            Text("未登录")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(NPColors.textPrimary)
                            Text("点击登录账号")
                                .font(.system(size: 14))
                                .foregroundColor(NPColors.textSecondary)
                        }
                        
                        Button(action: {
                            HapticManager.shared.lightTap()
                        }) {
                            Text("登录 / 注册")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 32)
                                .padding(.vertical, 12)
                                .background(NPColors.brandPrimary)
                                .cornerRadius(24)
                        }
                    }
                    .padding(.vertical, 32)
                    
                    // Settings Section
                    ProfileSection(title: "设置") {
                        ProfileMenuItem(icon: "person.circle", title: "账号设置")
                        ProfileMenuItem(icon: "bell", title: "通知设置")
                        ProfileMenuItem(icon: "paintbrush", title: "外观设置")
                    }
                    
                    // About Section
                    ProfileSection(title: "关于") {
                        ProfileMenuItem(icon: "questionmark.circle", title: "帮助中心")
                        ProfileMenuItem(icon: "info.circle", title: "关于 NicePoster")
                        ProfileMenuItem(icon: "star", title: "给我们评分")
                    }
                    
                    // App Info
                    VStack(spacing: 4) {
                        Text("NicePoster")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(NPColors.textSecondary)
                        Text("版本 1.0.0")
                            .font(.system(size: 12))
                            .foregroundColor(NPColors.textTertiary)
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: - Profile Section
struct ProfileSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(NPColors.textSecondary)
                .padding(.bottom, 12)
            
            VStack(spacing: 0) {
                content
            }
            .background(NPColors.bgSecondary)
            .cornerRadius(16)
        }
    }
}

// MARK: - Profile Menu Item
struct ProfileMenuItem: View {
    let icon: String
    let title: String
    
    var body: some View {
        Button(action: {
            HapticManager.shared.lightTap()
        }) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(NPColors.brandPrimary)
                    .frame(width: 24)
                
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(NPColors.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(NPColors.textTertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }
}

#Preview {
    ContentView()
}
