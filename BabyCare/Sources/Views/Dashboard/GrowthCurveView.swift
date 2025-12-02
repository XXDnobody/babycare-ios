//
//  GrowthCurveView.swift
//  BabyCare
//
//  生长曲线详情页
//

import SwiftUI
import Charts

struct GrowthCurveView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedMetric: GrowthMetric = .weight
    
    enum GrowthMetric: String, CaseIterable {
        case weight = "体重"
        case height = "身高"
        case headCircumference = "头围"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    // Metric Selector
                    metricSelector
                    
                    // Chart
                    chartSection
                    
                    // Current Stats
                    currentStatsSection
                    
                    // Add Record Button
                    addRecordButton
                }
                .padding(AppSpacing.md)
            }
            .background(Color.backgroundGray)
            .navigationTitle("生长曲线")
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
    
    // MARK: - Metric Selector
    private var metricSelector: some View {
        HStack(spacing: 0) {
            ForEach(GrowthMetric.allCases, id: \.self) { metric in
                Button(action: { selectedMetric = metric }) {
                    Text(metric.rawValue)
                        .font(AppFont.bodyMedium())
                        .foregroundColor(selectedMetric == metric ? .white : .textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppSpacing.sm)
                        .background(selectedMetric == metric ? Color.primaryPink : Color.clear)
                }
            }
        }
        .background(Color.white)
        .cornerRadius(AppCornerRadius.sm)
        .cardShadow()
    }
    
    // MARK: - Chart Section
    private var chartSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text("\(selectedMetric.rawValue)曲线")
                    .font(AppFont.h4())
                
                Spacer()
                
                Text("参考标准: WHO")
                    .font(AppFont.caption())
                    .foregroundColor(.textTertiary)
            }
            
            // Chart placeholder with sample data
            Chart {
                // Baby's data points
                ForEach(sampleGrowthData, id: \.month) { point in
                    LineMark(
                        x: .value("月龄", point.month),
                        y: .value("数值", point.value)
                    )
                    .foregroundStyle(Color.primaryPink)
                    .symbol {
                        Circle()
                            .fill(Color.primaryPink)
                            .frame(width: 8, height: 8)
                    }
                    
                    PointMark(
                        x: .value("月龄", point.month),
                        y: .value("数值", point.value)
                    )
                    .foregroundStyle(Color.primaryPink)
                }
                
                // P50 Reference Line
                ForEach(p50Data, id: \.month) { point in
                    LineMark(
                        x: .value("月龄", point.month),
                        y: .value("P50", point.value)
                    )
                    .foregroundStyle(Color.textTertiary.opacity(0.5))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                }
                
                // P97 Reference Line
                ForEach(p97Data, id: \.month) { point in
                    LineMark(
                        x: .value("月龄", point.month),
                        y: .value("P97", point.value)
                    )
                    .foregroundStyle(Color.textTertiary.opacity(0.3))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                }
                
                // P3 Reference Line
                ForEach(p3Data, id: \.month) { point in
                    LineMark(
                        x: .value("月龄", point.month),
                        y: .value("P3", point.value)
                    )
                    .foregroundStyle(Color.textTertiary.opacity(0.3))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                }
            }
            .frame(height: 250)
            .chartXAxisLabel("月龄")
            .chartYAxisLabel(selectedMetric == .weight ? "kg" : "cm")
            
            // Legend
            HStack(spacing: AppSpacing.lg) {
                LegendItem(color: .primaryPink, label: "宝宝")
                LegendItem(color: .textTertiary.opacity(0.5), label: "P50", dashed: true)
                LegendItem(color: .textTertiary.opacity(0.3), label: "P3/P97", dashed: true)
            }
            .font(AppFont.caption())
        }
        .padding(AppSpacing.md)
        .background(Color.white)
        .cornerRadius(AppCornerRadius.md)
        .cardShadow()
    }
    
    // Sample data
    private var sampleGrowthData: [GrowthPoint] {
        switch selectedMetric {
        case .weight:
            return [
                GrowthPoint(month: 0, value: 3.2),
                GrowthPoint(month: 1, value: 4.5),
                GrowthPoint(month: 2, value: 5.6),
                GrowthPoint(month: 3, value: 6.4),
                GrowthPoint(month: 4, value: 7.2)
            ]
        case .height:
            return [
                GrowthPoint(month: 0, value: 50),
                GrowthPoint(month: 1, value: 54),
                GrowthPoint(month: 2, value: 58),
                GrowthPoint(month: 3, value: 61),
                GrowthPoint(month: 4, value: 64)
            ]
        case .headCircumference:
            return [
                GrowthPoint(month: 0, value: 34),
                GrowthPoint(month: 1, value: 37),
                GrowthPoint(month: 2, value: 39),
                GrowthPoint(month: 3, value: 40.5),
                GrowthPoint(month: 4, value: 42)
            ]
        }
    }
    
    private var p50Data: [GrowthPoint] {
        switch selectedMetric {
        case .weight:
            return [
                GrowthPoint(month: 0, value: 3.3),
                GrowthPoint(month: 1, value: 4.5),
                GrowthPoint(month: 2, value: 5.6),
                GrowthPoint(month: 3, value: 6.4),
                GrowthPoint(month: 4, value: 7.0),
                GrowthPoint(month: 5, value: 7.5),
                GrowthPoint(month: 6, value: 7.9)
            ]
        case .height:
            return [
                GrowthPoint(month: 0, value: 49.9),
                GrowthPoint(month: 1, value: 54.7),
                GrowthPoint(month: 2, value: 58.4),
                GrowthPoint(month: 3, value: 61.4),
                GrowthPoint(month: 4, value: 63.9),
                GrowthPoint(month: 5, value: 65.9),
                GrowthPoint(month: 6, value: 67.6)
            ]
        case .headCircumference:
            return [
                GrowthPoint(month: 0, value: 34.5),
                GrowthPoint(month: 1, value: 37.3),
                GrowthPoint(month: 2, value: 39.1),
                GrowthPoint(month: 3, value: 40.5),
                GrowthPoint(month: 4, value: 41.6),
                GrowthPoint(month: 5, value: 42.6),
                GrowthPoint(month: 6, value: 43.3)
            ]
        }
    }
    
    private var p97Data: [GrowthPoint] {
        p50Data.map { GrowthPoint(month: $0.month, value: $0.value * 1.15) }
    }
    
    private var p3Data: [GrowthPoint] {
        p50Data.map { GrowthPoint(month: $0.month, value: $0.value * 0.85) }
    }
    
    // MARK: - Current Stats Section
    private var currentStatsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(.primaryPink)
                Text("当前\(selectedMetric.rawValue)")
                    .font(AppFont.h4())
            }
            
            HStack(spacing: AppSpacing.lg) {
                StatItem(label: "当前值", value: currentValue, unit: selectedMetric == .weight ? "kg" : "cm")
                StatItem(label: "百分位", value: "P65", unit: "正常")
                StatItem(label: "记录时间", value: "12.01", unit: "")
            }
        }
        .padding(AppSpacing.md)
        .background(Color.white)
        .cornerRadius(AppCornerRadius.md)
        .cardShadow()
    }
    
    private var currentValue: String {
        switch selectedMetric {
        case .weight: return "7.8"
        case .height: return "65.0"
        case .headCircumference: return "42.0"
        }
    }
    
    // MARK: - Add Record Button
    private var addRecordButton: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("添加新记录")
            }
        }
        .buttonStyle(PrimaryButtonStyle())
    }
}

// MARK: - Growth Point
struct GrowthPoint: Identifiable {
    let id = UUID()
    let month: Int
    let value: Double
}

// MARK: - Legend Item
struct LegendItem: View {
    let color: Color
    let label: String
    var dashed: Bool = false
    
    var body: some View {
        HStack(spacing: 4) {
            if dashed {
                Rectangle()
                    .stroke(color, style: StrokeStyle(lineWidth: 2, dash: [4, 2]))
                    .frame(width: 16, height: 2)
            } else {
                Rectangle()
                    .fill(color)
                    .frame(width: 16, height: 3)
                    .cornerRadius(1.5)
            }
            Text(label)
                .foregroundColor(.textSecondary)
        }
    }
}

// MARK: - Stat Item
struct StatItem: View {
    let label: String
    let value: String
    let unit: String
    
    var body: some View {
        VStack(spacing: AppSpacing.xs) {
            Text(label)
                .font(AppFont.caption())
                .foregroundColor(.textTertiary)
            HStack(alignment: .lastTextBaseline, spacing: 2) {
                Text(value)
                    .font(AppFont.h3())
                    .foregroundColor(.textPrimary)
                Text(unit)
                    .font(AppFont.caption())
                    .foregroundColor(.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    GrowthCurveView()
}
