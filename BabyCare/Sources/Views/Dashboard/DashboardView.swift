//
//  DashboardView.swift
//  BabyCare
//
//  复盘仪表盘主页面
//

import SwiftUI
import Charts

struct DashboardView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedPeriod: Period = .week
    @State private var showGrowthCurve = false
    @State private var showFeedingAnalysis = false
    @State private var showSleepAnalysis = false
    @State private var showInsights = false
    
    enum Period: String, CaseIterable {
        case week = "周"
        case month = "月"
        case quarter = "季"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    // Period Selector
                    periodSelector
                    
                    // Overview Card
                    overviewCard
                    
                    // Core Metrics
                    coreMetricsSection
                    
                    // Quick Links
                    quickLinksSection
                    
                    // Insights Preview
                    insightsPreviewSection
                    
                    // Weekly Report
                    weeklyReportCard
                }
                .padding(AppSpacing.md)
            }
            .background(Color.backgroundGray)
            .navigationTitle("复盘仪表盘")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showGrowthCurve) {
            GrowthCurveView()
        }
        .sheet(isPresented: $showFeedingAnalysis) {
            FeedingAnalysisView()
        }
        .sheet(isPresented: $showSleepAnalysis) {
            SleepAnalysisView()
        }
        .sheet(isPresented: $showInsights) {
            InsightsView()
        }
    }
    
    // MARK: - Period Selector
    private var periodSelector: some View {
        HStack(spacing: 0) {
            ForEach(Period.allCases, id: \.self) { period in
                Button(action: { selectedPeriod = period }) {
                    Text(period.rawValue)
                        .font(AppFont.bodyMedium())
                        .foregroundColor(selectedPeriod == period ? .white : .textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppSpacing.sm)
                        .background(selectedPeriod == period ? Color.primaryPink : Color.clear)
                }
            }
        }
        .background(Color.white)
        .cornerRadius(AppCornerRadius.sm)
        .cardShadow()
    }
    
    // MARK: - Overview Card
    private var overviewCard: some View {
        VStack(spacing: AppSpacing.md) {
            Text(periodDateRange)
                .font(AppFont.caption())
                .foregroundColor(.textSecondary)
            
            HStack(spacing: AppSpacing.lg) {
                // Progress Ring
                VStack {
                    ProgressRing(progress: 0.85, size: 100, lineWidth: 10)
                    
                    HStack(spacing: 4) {
                        Text("较上周")
                            .font(AppFont.caption())
                            .foregroundColor(.textTertiary)
                        Image(systemName: "arrow.up")
                            .font(.system(size: 10))
                            .foregroundColor(.successGreen)
                        Text("5%")
                            .font(AppFont.caption())
                            .foregroundColor(.successGreen)
                        Text("👍")
                    }
                }
                
                Spacer()
                
                // Quick Stats
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    QuickStat(emoji: "✅", label: "已完成", value: "59/70")
                    QuickStat(emoji: "🍼", label: "总奶量", value: "5740ml")
                    QuickStat(emoji: "😴", label: "总睡眠", value: "101.5h")
                }
            }
        }
        .padding(AppSpacing.md)
        .background(Color.white)
        .cornerRadius(AppCornerRadius.md)
        .cardShadow()
    }
    
    private var periodDateRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M.d"
        let now = Date()
        let weekAgo = Calendar.current.date(byAdding: .day, value: -6, to: now)!
        return "\(formatter.string(from: weekAgo)) - \(formatter.string(from: now)) 本周概览"
    }
    
    // MARK: - Core Metrics Section
    private var coreMetricsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("核心指标")
                .font(AppFont.h4())
                .foregroundColor(.textPrimary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: AppSpacing.md) {
                MetricCard(
                    title: "日均奶量",
                    value: "820ml",
                    trend: "3%",
                    trendUp: true,
                    emoji: "🍼"
                )
                
                MetricCard(
                    title: "日均睡眠",
                    value: "14.5h",
                    trend: "0.5h",
                    trendUp: false,
                    emoji: "😴"
                )
                
                MetricCard(
                    title: "夜醒次数",
                    value: "1.2次",
                    trend: "0.3",
                    trendUp: false,
                    emoji: "🌙"
                )
                
                MetricCard(
                    title: "辅食次数",
                    value: "2次",
                    trend: nil,
                    trendUp: nil,
                    emoji: "🥣"
                )
            }
        }
    }
    
    // MARK: - Quick Links Section
    private var quickLinksSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("详细分析")
                .font(AppFont.h4())
                .foregroundColor(.textPrimary)
            
            VStack(spacing: AppSpacing.sm) {
                QuickLinkRow(emoji: "📈", title: "生长曲线", subtitle: "体重/身高/头围趋势") {
                    showGrowthCurve = true
                }
                
                QuickLinkRow(emoji: "🍼", title: "喂养分析", subtitle: "奶量趋势·辅食接受度") {
                    showFeedingAnalysis = true
                }
                
                QuickLinkRow(emoji: "😴", title: "睡眠分析", subtitle: "睡眠时长·夜醒统计") {
                    showSleepAnalysis = true
                }
            }
        }
    }
    
    // MARK: - Insights Preview Section
    private var insightsPreviewSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            SectionHeader(title: "🤖 智能洞察", actionTitle: "查看全部") {
                showInsights = true
            }
            
            VStack(spacing: AppSpacing.sm) {
                InsightPreviewCard(
                    type: .pattern,
                    title: "最佳小睡时间窗口",
                    description: "上午 9:00-9:30 入睡成功率最高(92%)"
                )
                
                InsightPreviewCard(
                    type: .anomaly,
                    title: "疑似厌奶期迹象",
                    description: "近3天奶量下降18%，建议在安静环境喂奶"
                )
            }
        }
    }
    
    // MARK: - Weekly Report Card
    private var weeklyReportCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            SectionHeader(title: "📝 周报")
            
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                HStack {
                    Circle()
                        .fill(Color.primaryPinkBackground)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Text("😊")
                                .font(.system(size: 24))
                        )
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("小宝贝的第18周")
                            .font(AppFont.h4())
                            .foregroundColor(.textPrimary)
                        Text("11.25 - 12.01")
                            .font(AppFont.caption())
                            .foregroundColor(.textTertiary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.textTertiary)
                }
                
                Text("亲爱的家长，这周小宝贝表现非常棒！奶量稳定在820ml左右，已开始尝试辅食，对米粉接受度好...")
                    .font(AppFont.bodySmall())
                    .foregroundColor(.textSecondary)
                    .lineLimit(3)
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "doc.text.fill")
                        Text("导出PDF完整报告")
                    }
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            .padding(AppSpacing.md)
            .background(Color.white)
            .cornerRadius(AppCornerRadius.md)
            .cardShadow()
        }
    }
}

// MARK: - Quick Stat
struct QuickStat: View {
    let emoji: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Text(emoji)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(AppFont.caption())
                    .foregroundColor(.textTertiary)
                Text(value)
                    .font(AppFont.bodyMedium())
                    .foregroundColor(.textPrimary)
            }
        }
    }
}

// MARK: - Quick Link Row
struct QuickLinkRow: View {
    let emoji: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(emoji)
                    .font(.system(size: 24))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(AppFont.bodyMedium())
                        .foregroundColor(.textPrimary)
                    Text(subtitle)
                        .font(AppFont.caption())
                        .foregroundColor(.textTertiary)
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
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Insight Preview Card
struct InsightPreviewCard: View {
    let type: Insight.InsightType
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.sm) {
            Text(type.emoji)
                .font(.system(size: 20))
            
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                HStack {
                    Text(type.displayName)
                        .font(AppFont.caption())
                        .foregroundColor(.primaryPink)
                        .padding(.horizontal, AppSpacing.sm)
                        .padding(.vertical, 2)
                        .background(Color.primaryPinkBackground)
                        .cornerRadius(AppCornerRadius.full)
                }
                
                Text(title)
                    .font(AppFont.bodyMedium())
                    .foregroundColor(.textPrimary)
                
                Text(description)
                    .font(AppFont.bodySmall())
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
        }
        .padding(AppSpacing.md)
        .background(Color.white)
        .cornerRadius(AppCornerRadius.md)
        .cardShadow()
    }
}

#Preview {
    DashboardView()
        .environmentObject(AppState())
}
