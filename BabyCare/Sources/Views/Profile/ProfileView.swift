//
//  ProfileView.swift
//  BabyCare
//
//  我的页面
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var showAddBaby = false
    @State private var showReportHistory = false
    @State private var showSettings = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    // User Card
                    userCard
                    
                    // Baby List
                    babyListSection
                    
                    // Function List
                    functionListSection
                    
                    // About Section
                    aboutSection
                }
                .padding(AppSpacing.md)
            }
            .background(Color.backgroundGray)
            .navigationTitle("我的")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showAddBaby) {
            AddBabyView(isFirstTime: false)
        }
        .sheet(isPresented: $showReportHistory) {
            ReportHistoryView()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
    
    // MARK: - User Card
    private var userCard: some View {
        VStack(spacing: AppSpacing.md) {
            HStack {
                // Avatar
                Circle()
                    .fill(Color.primaryPinkBackground)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.primaryPink)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("用户昵称")
                        .font(AppFont.h3())
                        .foregroundColor(.textPrimary)
                    Text("已注册 \(appState.currentBaby?.ageInDays ?? 128) 天")
                        .font(AppFont.caption())
                        .foregroundColor(.textTertiary)
                }
                
                Spacer()
            }
            
            // VIP Banner
            Button(action: {}) {
                HStack {
                    Text("👑")
                        .font(.system(size: 20))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("开通VIP会员")
                            .font(AppFont.bodyMedium())
                            .foregroundColor(.white)
                        Text("解锁全部功能")
                            .font(AppFont.caption())
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                }
                .padding(AppSpacing.md)
                .background(
                    LinearGradient(
                        colors: [Color.primaryPink, Color.primaryPinkLight],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(AppCornerRadius.md)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(AppSpacing.md)
        .background(Color.white)
        .cornerRadius(AppCornerRadius.md)
        .cardShadow()
    }
    
    // MARK: - Baby List Section
    private var babyListSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("宝宝档案")
                .font(AppFont.h4())
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 0) {
                // Baby items
                ForEach(appState.babies) { baby in
                    BabyListItem(
                        baby: baby,
                        isSelected: baby.id == appState.currentBaby?.id
                    ) {
                        appState.currentBaby = baby
                    }
                    
                    if baby.id != appState.babies.last?.id {
                        Divider()
                            .padding(.horizontal, AppSpacing.md)
                    }
                }
                
                // If no babies, show placeholder
                if appState.babies.isEmpty {
                    Text("暂无宝宝档案")
                        .font(AppFont.bodyMedium())
                        .foregroundColor(.textTertiary)
                        .padding(AppSpacing.lg)
                }
                
                Divider()
                
                // Add baby button
                Button(action: { showAddBaby = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.primaryPink)
                        Text("添加宝宝")
                            .font(AppFont.bodyMedium())
                            .foregroundColor(.primaryPink)
                        Spacer()
                    }
                    .padding(AppSpacing.md)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .background(Color.white)
            .cornerRadius(AppCornerRadius.md)
            .cardShadow()
        }
    }
    
    // MARK: - Function List Section
    private var functionListSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("功能")
                .font(AppFont.h4())
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 0) {
                FunctionListItem(icon: "doc.text.fill", title: "儿保报告管理", color: .accentBlue) {
                    showReportHistory = true
                }
                Divider().padding(.leading, 56)
                
                FunctionListItem(icon: "chart.line.uptrend.xyaxis", title: "评测历史记录", color: .successGreen) {
                    // Navigate to assessment history
                }
                Divider().padding(.leading, 56)
                
                FunctionListItem(icon: "photo.fill", title: "成长相册", color: .warningYellow) {
                    // Navigate to photo album
                }
                Divider().padding(.leading, 56)
                
                FunctionListItem(icon: "bell.fill", title: "通知设置", color: .errorRed) {
                    // Navigate to notifications
                }
                Divider().padding(.leading, 56)
                
                FunctionListItem(icon: "gearshape.fill", title: "应用设置", color: .textSecondary) {
                    showSettings = true
                }
            }
            .background(Color.white)
            .cornerRadius(AppCornerRadius.md)
            .cardShadow()
        }
    }
    
    // MARK: - About Section
    private var aboutSection: some View {
        VStack(spacing: 0) {
            FunctionListItem(icon: "questionmark.circle.fill", title: "帮助与反馈", color: .accentBlue) {
                // Navigate to help
            }
            Divider().padding(.leading, 56)
            
            FunctionListItem(icon: "info.circle.fill", title: "关于我们", color: .textSecondary) {
                // Navigate to about
            }
        }
        .background(Color.white)
        .cornerRadius(AppCornerRadius.md)
        .cardShadow()
    }
}

// MARK: - Baby List Item
struct BabyListItem: View {
    let baby: Baby
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                // Avatar
                Circle()
                    .fill(Color.primaryPinkBackground)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Text(baby.gender.emoji)
                            .font(.system(size: 20))
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(baby.nickname)
                        .font(AppFont.bodyMedium())
                        .foregroundColor(.textPrimary)
                    Text("\(baby.ageDescription) · \(baby.gender.displayName)")
                        .font(AppFont.caption())
                        .foregroundColor(.textTertiary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.primaryPink)
                }
            }
            .padding(AppSpacing.md)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Function List Item
struct FunctionListItem: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                    .frame(width: 32)
                
                Text(title)
                    .font(AppFont.bodyMedium())
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.textTertiary)
            }
            .padding(AppSpacing.md)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Report History View
struct ReportHistoryView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(0..<5) { index in
                    HStack {
                        Image(systemName: "doc.text.fill")
                            .foregroundColor(.primaryPink)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(4 - index)月龄儿保报告")
                                .font(AppFont.bodyMedium())
                            Text("2024-\(12 - index)-01")
                                .font(AppFont.caption())
                                .foregroundColor(.textTertiary)
                        }
                        
                        Spacer()
                        
                        Text("已分析")
                            .font(AppFont.caption())
                            .foregroundColor(.successGreen)
                    }
                    .padding(.vertical, AppSpacing.xs)
                }
            }
            .navigationTitle("儿保报告管理")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.textSecondary)
                    }
                }
            }
        }
    }
}

// MARK: - Settings View
struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("通知") {
                    Toggle("推送通知", isOn: $notificationsEnabled)
                }
                
                Section("外观") {
                    Toggle("深色模式", isOn: $darkModeEnabled)
                }
                
                Section("数据") {
                    Button("导出数据") {}
                    Button("清除缓存") {}
                }
                
                Section("账号") {
                    Button("退出登录") {}
                        .foregroundColor(.errorRed)
                }
                
                Section {
                    HStack {
                        Spacer()
                        Text("版本 1.0.0 (Build 1)")
                            .font(AppFont.caption())
                            .foregroundColor(.textTertiary)
                        Spacer()
                    }
                }
            }
            .navigationTitle("应用设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.textSecondary)
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppState())
}
