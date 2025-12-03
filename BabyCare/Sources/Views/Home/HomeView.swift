//
//  HomeView.swift
//  BabyCare
//
//  首页视图
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var showAddReport = false
    @State private var showAssessment = false
    @State private var showPhotoAlbum = false
    @State private var showQuickMilk = false
    @State private var showQuickFood = false
    @State private var showQuickSleep = false
    @State private var showQuickDiaper = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    // Header
                    headerSection
                    
                    // Today's Progress Card
                    todayProgressCard
                    
                    // Quick Actions
                    quickActionsSection
                    
                    // Milestone Reminder
                    milestoneSection
                    
                    // Today's Summary
                    todaySummarySection
                }
                .padding(AppSpacing.md)
            }
            .background(Color.backgroundGray)
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showAddReport) {
            ReportUploadView()
        }
        .sheet(isPresented: $showQuickMilk) {
            MilkRecordSheet()
        }
        .sheet(isPresented: $showQuickFood) {
            FoodRecordSheet()
        }
        .sheet(isPresented: $showQuickSleep) {
            SleepRecordSheet()
        }
        .sheet(isPresented: $showQuickDiaper) {
            DiaperRecordSheet()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("👋 Hi, \(appState.currentBaby?.nickname ?? "宝贝")")
                    .font(AppFont.h2())
                    .foregroundColor(.textPrimary)
                
                Text("今天是第 \(appState.currentBaby?.ageInDays ?? 0) 天 · \(appState.currentBaby?.ageDescription ?? "")")
                    .font(AppFont.bodyMedium())
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            // Baby Avatar
            Circle()
                .fill(Color.primaryPinkBackground)
                .frame(width: 50, height: 50)
                .overlay(
                    Text(appState.currentBaby?.gender.emoji ?? "👶")
                        .font(.system(size: 24))
                )
        }
        .padding(.top, AppSpacing.md)
    }
    
    // MARK: - Today's Progress Card
    private var todayProgressCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text("📊")
                    .font(.system(size: 20))
                Text("今日任务完成度")
                    .font(AppFont.h4())
                    .foregroundColor(.textPrimary)
            }
            
            HStack(spacing: AppSpacing.lg) {
                ProgressRing(progress: 0.78, size: 80, lineWidth: 8)
                
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.successGreen)
                        Text("已完成 7/9")
                            .font(AppFont.bodyMedium())
                            .foregroundColor(.textSecondary)
                    }
                    
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.warningYellow)
                        Text("下次喝奶 14:30")
                            .font(AppFont.bodyMedium())
                            .foregroundColor(.textSecondary)
                    }
                }
                
                Spacer()
            }
        }
        .padding(AppSpacing.md)
        .background(Color.white)
        .cornerRadius(AppCornerRadius.md)
        .cardShadow()
    }
    
    // MARK: - Quick Actions Section
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("快捷操作")
                .font(AppFont.h4())
                .foregroundColor(.textPrimary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: AppSpacing.md) {
                QuickActionButton(emoji: "🍼", title: "喝奶") {
                    showQuickMilk = true
                }
                QuickActionButton(emoji: "🥣", title: "辅食") {
                    showQuickFood = true
                }
                QuickActionButton(emoji: "😴", title: "睡眠") {
                    showQuickSleep = true
                }
                QuickActionButton(emoji: "🧷", title: "换尿布") {
                    showQuickDiaper = true
                }
                QuickActionButton(emoji: "📋", title: "报告") {
                    showAddReport = true
                }
                QuickActionButton(emoji: "📈", title: "评测", isVIP: true) {
                    showAssessment = true
                }
            }
        }
    }
    
    // MARK: - Milestone Section
    private var milestoneSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            SectionHeader(title: "🎉 里程碑提醒", actionTitle: "查看全部") {
                // Navigate to milestones
            }
            
            MilestoneCard(
                emoji: "🏃",
                category: "大运动发育",
                title: "宝宝\(appState.currentBaby?.ageInMonths ?? 4)个月啦",
                description: "可以尝试练习翻身了哦!"
            )
        }
    }
    
    // MARK: - Today Summary Section
    private var todaySummarySection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            SectionHeader(title: "📝 今日记录")
            
            HStack(spacing: AppSpacing.md) {
                SummaryItem(emoji: "🍼", title: "喝奶", value: "3次", detail: "540ml")
                SummaryItem(emoji: "🥣", title: "辅食", value: "1次", detail: "米粉")
                SummaryItem(emoji: "😴", title: "小睡", value: "2次", detail: "2.5h")
            }
        }
    }
}

// MARK: - Milestone Card
struct MilestoneCard: View {
    let emoji: String
    let category: String
    let title: String
    let description: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                HStack {
                    Text(emoji)
                    Text(category)
                        .font(AppFont.caption())
                        .foregroundColor(.primaryPink)
                }
                
                Text(title)
                    .font(AppFont.h4())
                    .foregroundColor(.textPrimary)
                
                Text(description)
                    .font(AppFont.bodySmall())
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.textTertiary)
        }
        .padding(AppSpacing.md)
        .background(Color.white)
        .cornerRadius(AppCornerRadius.md)
        .cardShadow()
    }
}

// MARK: - Summary Item
struct SummaryItem: View {
    let emoji: String
    let title: String
    let value: String
    let detail: String
    
    var body: some View {
        VStack(spacing: AppSpacing.xs) {
            Text(emoji)
                .font(.system(size: 24))
            Text(title)
                .font(AppFont.caption())
                .foregroundColor(.textTertiary)
            Text(value)
                .font(AppFont.h4())
                .foregroundColor(.textPrimary)
            Text(detail)
                .font(AppFont.caption())
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.md)
        .background(Color.white)
        .cornerRadius(AppCornerRadius.md)
        .cardShadow()
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
}
