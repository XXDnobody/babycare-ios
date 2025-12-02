//
//  FeedingAnalysisView.swift
//  BabyCare
//
//  喂养分析详情页
//

import SwiftUI
import Charts

struct FeedingAnalysisView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    // Milk Trend Chart
                    milkTrendSection
                    
                    // Food Acceptance Heatmap
                    foodAcceptanceSection
                    
                    // Allergy Records
                    allergySection
                    
                    // Summary
                    summarySection
                }
                .padding(AppSpacing.md)
            }
            .background(Color.backgroundGray)
            .navigationTitle("喂养分析")
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
    
    // MARK: - Milk Trend Section
    private var milkTrendSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("本周奶量趋势")
                .font(AppFont.h4())
            
            Chart {
                ForEach(milkData, id: \.day) { item in
                    BarMark(
                        x: .value("日期", item.day),
                        y: .value("奶量", item.volume)
                    )
                    .foregroundStyle(Color.primaryPink.gradient)
                    .cornerRadius(4)
                }
                
                // Target line
                RuleMark(y: .value("目标", 800))
                    .foregroundStyle(Color.successGreen)
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                    .annotation(position: .trailing) {
                        Text("目标")
                            .font(AppFont.caption())
                            .foregroundColor(.successGreen)
                    }
            }
            .frame(height: 200)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            
            HStack {
                Text("日均: 820ml")
                    .font(AppFont.bodyMedium())
                    .foregroundColor(.textSecondary)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text("目标: 800ml")
                        .font(AppFont.bodyMedium())
                        .foregroundColor(.textSecondary)
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.successGreen)
                }
            }
        }
        .padding(AppSpacing.md)
        .background(Color.white)
        .cornerRadius(AppCornerRadius.md)
        .cardShadow()
    }
    
    private var milkData: [MilkDataPoint] {
        [
            MilkDataPoint(day: "一", volume: 780),
            MilkDataPoint(day: "二", volume: 850),
            MilkDataPoint(day: "三", volume: 820),
            MilkDataPoint(day: "四", volume: 790),
            MilkDataPoint(day: "五", volume: 880),
            MilkDataPoint(day: "六", volume: 810),
            MilkDataPoint(day: "日", volume: 810)
        ]
    }
    
    // MARK: - Food Acceptance Section
    private var foodAcceptanceSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("辅食接受度")
                .font(AppFont.h4())
            
            Text("颜色越深 = 接受度越高")
                .font(AppFont.caption())
                .foregroundColor(.textTertiary)
            
            // Heatmap
            VStack(spacing: 4) {
                // Header row
                HStack(spacing: 4) {
                    Text("")
                        .frame(width: 60)
                    ForEach(["一", "二", "三", "四", "五", "六", "日"], id: \.self) { day in
                        Text(day)
                            .font(AppFont.caption())
                            .foregroundColor(.textTertiary)
                            .frame(width: 32)
                    }
                }
                
                // Data rows
                ForEach(foodData, id: \.food) { row in
                    HStack(spacing: 4) {
                        Text(row.food)
                            .font(AppFont.bodySmall())
                            .foregroundColor(.textSecondary)
                            .frame(width: 60, alignment: .leading)
                        
                        ForEach(0..<7, id: \.self) { index in
                            Rectangle()
                                .fill(cellColor(for: row.acceptance[index]))
                                .frame(width: 32, height: 24)
                                .cornerRadius(4)
                        }
                    }
                }
            }
            
            // Legend
            HStack(spacing: AppSpacing.md) {
                HeatmapLegend(color: .successGreen, label: "全部吃完")
                HeatmapLegend(color: .successGreen.opacity(0.5), label: "吃了一半")
                HeatmapLegend(color: .backgroundGray, label: "未添加")
                HeatmapLegend(color: .errorRed.opacity(0.5), label: "不接受")
            }
            .font(AppFont.caption())
        }
        .padding(AppSpacing.md)
        .background(Color.white)
        .cornerRadius(AppCornerRadius.md)
        .cardShadow()
    }
    
    private func cellColor(for acceptance: FeedingRecord.Acceptance?) -> Color {
        guard let acceptance = acceptance else {
            return Color.backgroundGray
        }
        switch acceptance {
        case .full: return .successGreen
        case .half: return .successGreen.opacity(0.5)
        case .little: return .warningYellow.opacity(0.5)
        case .refused: return .errorRed.opacity(0.5)
        }
    }
    
    private var foodData: [FoodRow] {
        [
            FoodRow(food: "米粉", acceptance: [.full, .full, .full, .full, .full, nil, nil]),
            FoodRow(food: "南瓜", acceptance: [.full, nil, .full, nil, .full, nil, nil]),
            FoodRow(food: "胡萝卜", acceptance: [nil, .full, nil, .full, nil, nil, nil]),
            FoodRow(food: "苹果", acceptance: [.full, .full, nil, nil, .full, nil, nil]),
            FoodRow(food: "鸡蛋", acceptance: [.half, nil, nil, nil, nil, nil, nil])
        ]
    }
    
    // MARK: - Allergy Section
    private var allergySection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.warningYellow)
                Text("过敏记录")
                    .font(AppFont.h4())
            }
            
            HStack {
                Text("🥚")
                    .font(.system(size: 24))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("鸡蛋 - 首次尝试")
                        .font(AppFont.bodyMedium())
                        .foregroundColor(.textPrimary)
                    Text("12.01 - 观察中，无异常")
                        .font(AppFont.caption())
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "eye.fill")
                    .foregroundColor(.warningYellow)
            }
            .padding(AppSpacing.sm)
            .background(Color.warningYellow.opacity(0.1))
            .cornerRadius(AppCornerRadius.sm)
        }
        .padding(AppSpacing.md)
        .background(Color.white)
        .cornerRadius(AppCornerRadius.md)
        .cardShadow()
    }
    
    // MARK: - Summary Section
    private var summarySection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("💡 本周喂养总结")
                .font(AppFont.h4())
            
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                SummaryBullet(text: "奶量稳定，日均820ml达标")
                SummaryBullet(text: "辅食种类丰富，接受度良好")
                SummaryBullet(text: "首次尝试鸡蛋，需继续观察")
                SummaryBullet(text: "建议下周可尝试添加肉泥")
            }
        }
        .padding(AppSpacing.md)
        .background(Color.white)
        .cornerRadius(AppCornerRadius.md)
        .cardShadow()
    }
}

// MARK: - Data Models
struct MilkDataPoint {
    let day: String
    let volume: Int
}

struct FoodRow {
    let food: String
    let acceptance: [FeedingRecord.Acceptance?]
}

// MARK: - Heatmap Legend
struct HeatmapLegend: View {
    let color: Color
    let label: String
    
    var body: some View {
        HStack(spacing: 4) {
            Rectangle()
                .fill(color)
                .frame(width: 12, height: 12)
                .cornerRadius(2)
            Text(label)
                .foregroundColor(.textSecondary)
        }
    }
}

// MARK: - Summary Bullet
struct SummaryBullet: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.sm) {
            Text("•")
                .foregroundColor(.primaryPink)
            Text(text)
                .font(AppFont.bodyMedium())
                .foregroundColor(.textSecondary)
        }
    }
}

#Preview {
    FeedingAnalysisView()
}
