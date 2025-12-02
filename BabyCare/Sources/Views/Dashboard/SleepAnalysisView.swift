//
//  SleepAnalysisView.swift
//  BabyCare
//
//  睡眠分析详情页
//

import SwiftUI
import Charts

struct SleepAnalysisView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    // Overview Stats
                    overviewSection
                    
                    // Sleep Distribution
                    sleepDistributionSection
                    
                    // Sleep Timeline
                    sleepTimelineSection
                    
                    // Insights
                    insightsSection
                }
                .padding(AppSpacing.md)
            }
            .background(Color.backgroundGray)
            .navigationTitle("睡眠分析")
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
    
    // MARK: - Overview Section
    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("本周睡眠概览")
                .font(AppFont.h4())
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: AppSpacing.md) {
                SleepStatCard(title: "日均睡眠", value: "14.5h", emoji: "😴")
                SleepStatCard(title: "夜间睡眠", value: "10.2h", emoji: "🌙")
                SleepStatCard(title: "日间小睡", value: "4.3h", emoji: "☀️")
                SleepStatCard(title: "夜醒次数", value: "1.2次", emoji: "⏰")
            }
        }
        .padding(AppSpacing.md)
        .background(Color.white)
        .cornerRadius(AppCornerRadius.md)
        .cardShadow()
    }
    
    // MARK: - Sleep Distribution Section
    private var sleepDistributionSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("睡眠时间分布")
                .font(AppFont.h4())
            
            // Time axis header
            HStack {
                Text("")
                    .frame(width: 30)
                ForEach([0, 3, 6, 9, 12, 15, 18, 21], id: \.self) { hour in
                    Text("\(hour)")
                        .font(AppFont.caption())
                        .foregroundColor(.textTertiary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Sleep bars for each day
            VStack(spacing: 8) {
                ForEach(sleepTimelineData, id: \.day) { dayData in
                    HStack(spacing: 4) {
                        Text(dayData.day)
                            .font(AppFont.caption())
                            .foregroundColor(.textSecondary)
                            .frame(width: 30)
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                // Background
                                Rectangle()
                                    .fill(Color.backgroundGray)
                                    .frame(height: 20)
                                
                                // Sleep blocks
                                ForEach(dayData.sleepBlocks, id: \.start) { block in
                                    Rectangle()
                                        .fill(block.isNight ? Color.accentBlue : Color.primaryPink)
                                        .frame(
                                            width: CGFloat(block.end - block.start) / 24 * geometry.size.width,
                                            height: 20
                                        )
                                        .offset(x: CGFloat(block.start) / 24 * geometry.size.width)
                                }
                            }
                            .cornerRadius(4)
                        }
                        .frame(height: 20)
                    }
                }
            }
            
            // Legend
            HStack(spacing: AppSpacing.lg) {
                HStack(spacing: 4) {
                    Rectangle()
                        .fill(Color.accentBlue)
                        .frame(width: 16, height: 12)
                        .cornerRadius(2)
                    Text("夜间睡眠")
                        .font(AppFont.caption())
                        .foregroundColor(.textSecondary)
                }
                
                HStack(spacing: 4) {
                    Rectangle()
                        .fill(Color.primaryPink)
                        .frame(width: 16, height: 12)
                        .cornerRadius(2)
                    Text("日间小睡")
                        .font(AppFont.caption())
                        .foregroundColor(.textSecondary)
                }
                
                HStack(spacing: 4) {
                    Rectangle()
                        .fill(Color.backgroundGray)
                        .frame(width: 16, height: 12)
                        .cornerRadius(2)
                    Text("清醒")
                        .font(AppFont.caption())
                        .foregroundColor(.textSecondary)
                }
            }
        }
        .padding(AppSpacing.md)
        .background(Color.white)
        .cornerRadius(AppCornerRadius.md)
        .cardShadow()
    }
    
    private var sleepTimelineData: [DaySleepData] {
        [
            DaySleepData(day: "一", sleepBlocks: [
                SleepBlock(start: 0, end: 6, isNight: true),
                SleepBlock(start: 9, end: 10.5, isNight: false),
                SleepBlock(start: 13, end: 15, isNight: false),
                SleepBlock(start: 20, end: 24, isNight: true)
            ]),
            DaySleepData(day: "二", sleepBlocks: [
                SleepBlock(start: 0, end: 6.5, isNight: true),
                SleepBlock(start: 9.5, end: 11, isNight: false),
                SleepBlock(start: 14, end: 15.5, isNight: false),
                SleepBlock(start: 20, end: 24, isNight: true)
            ]),
            DaySleepData(day: "三", sleepBlocks: [
                SleepBlock(start: 0, end: 6, isNight: true),
                SleepBlock(start: 9, end: 10, isNight: false),
                SleepBlock(start: 13.5, end: 15, isNight: false),
                SleepBlock(start: 19.5, end: 24, isNight: true)
            ]),
            DaySleepData(day: "四", sleepBlocks: [
                SleepBlock(start: 0, end: 7, isNight: true),
                SleepBlock(start: 10, end: 11.5, isNight: false),
                SleepBlock(start: 14, end: 16, isNight: false),
                SleepBlock(start: 20.5, end: 24, isNight: true)
            ]),
            DaySleepData(day: "五", sleepBlocks: [
                SleepBlock(start: 0, end: 6, isNight: true),
                SleepBlock(start: 9, end: 10.5, isNight: false),
                SleepBlock(start: 13, end: 15, isNight: false),
                SleepBlock(start: 20, end: 24, isNight: true)
            ]),
            DaySleepData(day: "六", sleepBlocks: [
                SleepBlock(start: 0, end: 6.5, isNight: true),
                SleepBlock(start: 9.5, end: 11, isNight: false),
                SleepBlock(start: 14, end: 16, isNight: false),
                SleepBlock(start: 20, end: 24, isNight: true)
            ]),
            DaySleepData(day: "日", sleepBlocks: [
                SleepBlock(start: 0, end: 6, isNight: true),
                SleepBlock(start: 9, end: 10.5, isNight: false),
                SleepBlock(start: 13.5, end: 15, isNight: false),
                SleepBlock(start: 20, end: 24, isNight: true)
            ])
        ]
    }
    
    // MARK: - Sleep Timeline Section
    private var sleepTimelineSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("睡眠时长趋势")
                .font(AppFont.h4())
            
            Chart {
                ForEach(sleepDurationData, id: \.day) { item in
                    BarMark(
                        x: .value("日期", item.day),
                        y: .value("时长", item.nightHours)
                    )
                    .foregroundStyle(Color.accentBlue)
                    .position(by: .value("Type", "夜间"))
                    
                    BarMark(
                        x: .value("日期", item.day),
                        y: .value("时长", item.napHours)
                    )
                    .foregroundStyle(Color.primaryPink)
                    .position(by: .value("Type", "日间"))
                }
            }
            .frame(height: 180)
            .chartYAxisLabel("小时")
        }
        .padding(AppSpacing.md)
        .background(Color.white)
        .cornerRadius(AppCornerRadius.md)
        .cardShadow()
    }
    
    private var sleepDurationData: [SleepDurationPoint] {
        [
            SleepDurationPoint(day: "一", nightHours: 10, napHours: 4.5),
            SleepDurationPoint(day: "二", nightHours: 10.5, napHours: 4),
            SleepDurationPoint(day: "三", nightHours: 9.5, napHours: 4),
            SleepDurationPoint(day: "四", nightHours: 10.5, napHours: 5),
            SleepDurationPoint(day: "五", nightHours: 10, napHours: 4.5),
            SleepDurationPoint(day: "六", nightHours: 10.5, napHours: 4.5),
            SleepDurationPoint(day: "日", nightHours: 10, napHours: 4)
        ]
    }
    
    // MARK: - Insights Section
    private var insightsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text("💡")
                Text("智能洞察")
                    .font(AppFont.h4())
            }
            
            VStack(spacing: AppSpacing.sm) {
                InsightItem(
                    emoji: "🌟",
                    title: "最佳入睡时间窗口",
                    description: "宝宝在 9:00-10:30 入睡成功率最高(90%)"
                )
                
                InsightItem(
                    emoji: "📉",
                    title: "周三夜醒较多",
                    description: "夜醒3次，可能与当天辅食添加有关"
                )
                
                InsightItem(
                    emoji: "✨",
                    title: "睡眠规律性提升",
                    description: "本周入睡时间标准差降低15%"
                )
            }
        }
        .padding(AppSpacing.md)
        .background(Color.white)
        .cornerRadius(AppCornerRadius.md)
        .cardShadow()
    }
}

// MARK: - Data Models
struct DaySleepData {
    let day: String
    let sleepBlocks: [SleepBlock]
}

struct SleepBlock {
    let start: Double
    let end: Double
    let isNight: Bool
}

struct SleepDurationPoint {
    let day: String
    let nightHours: Double
    let napHours: Double
}

// MARK: - Sleep Stat Card
struct SleepStatCard: View {
    let title: String
    let value: String
    let emoji: String
    
    var body: some View {
        VStack(spacing: AppSpacing.xs) {
            Text(emoji)
                .font(.system(size: 24))
            Text(title)
                .font(AppFont.caption())
                .foregroundColor(.textTertiary)
            Text(value)
                .font(AppFont.h3())
                .foregroundColor(.textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.md)
        .background(Color.backgroundGray)
        .cornerRadius(AppCornerRadius.sm)
    }
}

// MARK: - Insight Item
struct InsightItem: View {
    let emoji: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.sm) {
            Text(emoji)
                .font(.system(size: 20))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppFont.bodyMedium())
                    .foregroundColor(.textPrimary)
                Text(description)
                    .font(AppFont.bodySmall())
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
        }
        .padding(AppSpacing.sm)
        .background(Color.primaryPinkBackground)
        .cornerRadius(AppCornerRadius.sm)
    }
}

#Preview {
    SleepAnalysisView()
}
