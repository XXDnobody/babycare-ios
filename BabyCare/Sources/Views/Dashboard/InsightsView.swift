//
//  InsightsView.swift
//  BabyCare
//
//  智能洞察列表页
//

import SwiftUI

struct InsightsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.md) {
                    // Header
                    HStack {
                        Text("🤖")
                            .font(.system(size: 24))
                        Text("AI为您发现了 \(sampleInsights.count) 条洞察")
                            .font(AppFont.bodyMedium())
                            .foregroundColor(.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, AppSpacing.md)
                    
                    // Insights List
                    ForEach(sampleInsights) { insight in
                        InsightDetailCard(insight: insight)
                    }
                }
                .padding(.vertical, AppSpacing.md)
            }
            .background(Color.backgroundGray)
            .navigationTitle("智能洞察")
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
    
    private var sampleInsights: [Insight] {
        [
            Insight(
                type: .pattern,
                title: "最佳小睡时间窗口",
                description: "根据过去14天数据分析，宝宝在以下时段入睡成功率最高：\n\n• 上午 9:00-9:30 (92%)\n• 下午 13:30-14:00 (88%)\n• 傍晚 17:00-17:30 (78%)",
                suggestion: "建议在这些时间安排小睡",
                evidence: ["14天数据分析", "入睡成功率统计"]
            ),
            Insight(
                type: .anomaly,
                title: "疑似厌奶期迹象",
                description: "近3天奶量下降18%，从日均850ml降至700ml。\n\n可能原因：\n• 4月龄生理性厌奶期\n• 环境干扰注意力分散",
                suggestion: "建议在安静环境喂奶，减少外界刺激",
                evidence: ["奶量趋势分析", "月龄特征匹配"]
            ),
            Insight(
                type: .correlation,
                title: "辅食与睡眠关联",
                description: "发现添加鸡蛋当天，夜醒次数增加0.8次。\n\n这可能是正常的消化反应，也需要观察是否有过敏迹象。",
                suggestion: "建议继续观察，如有皮疹等过敏症状请及时就医",
                evidence: ["辅食记录", "睡眠数据关联"]
            ),
            Insight(
                type: .pattern,
                title: "运动与睡眠正相关",
                description: "数据显示，当天运动时长超过30分钟时，夜间睡眠时长平均增加25分钟，夜醒次数减少0.5次。",
                suggestion: "建议每天安排足够的运动互动时间",
                evidence: ["运动记录", "睡眠质量分析"]
            ),
            Insight(
                type: .anomaly,
                title: "体重增速放缓",
                description: "近2周体重增速为15g/天，略低于同月龄标准(20-25g/天)。\n\n目前仍在正常范围内，建议持续关注。",
                suggestion: "可适当增加喂养次数，下次儿保时咨询医生",
                evidence: ["生长曲线分析", "WHO标准对比"]
            )
        ]
    }
}

// MARK: - Insight Detail Card
struct InsightDetailCard: View {
    let insight: Insight
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            // Header
            HStack(alignment: .top) {
                Text(insight.type.emoji)
                    .font(.system(size: 24))
                
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    // Type Badge
                    Text(insight.type.displayName)
                        .font(AppFont.caption())
                        .foregroundColor(.white)
                        .padding(.horizontal, AppSpacing.sm)
                        .padding(.vertical, 2)
                        .background(badgeColor)
                        .cornerRadius(AppCornerRadius.full)
                    
                    // Title
                    Text(insight.title)
                        .font(AppFont.h4())
                        .foregroundColor(.textPrimary)
                }
                
                Spacer()
            }
            
            // Divider
            Rectangle()
                .fill(Color.borderColor)
                .frame(height: 1)
            
            // Description
            Text(insight.description)
                .font(AppFont.bodyMedium())
                .foregroundColor(.textSecondary)
                .lineSpacing(6)
            
            // Suggestion
            if let suggestion = insight.suggestion {
                HStack(alignment: .top, spacing: AppSpacing.sm) {
                    Text("💡")
                    Text(suggestion)
                        .font(AppFont.bodyMedium())
                        .foregroundColor(.primaryPink)
                }
                .padding(AppSpacing.sm)
                .background(Color.primaryPinkBackground)
                .cornerRadius(AppCornerRadius.sm)
            }
            
            // Evidence (expandable)
            if !insight.evidence.isEmpty {
                Button(action: { isExpanded.toggle() }) {
                    HStack {
                        Text("数据依据")
                            .font(AppFont.caption())
                            .foregroundColor(.textTertiary)
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 12))
                            .foregroundColor(.textTertiary)
                    }
                }
                
                if isExpanded {
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        ForEach(insight.evidence, id: \.self) { evidence in
                            HStack(spacing: AppSpacing.xs) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(.successGreen)
                                Text(evidence)
                                    .font(AppFont.caption())
                                    .foregroundColor(.textSecondary)
                            }
                        }
                    }
                    .padding(AppSpacing.sm)
                    .background(Color.backgroundGray)
                    .cornerRadius(AppCornerRadius.sm)
                }
            }
        }
        .padding(AppSpacing.md)
        .background(Color.white)
        .cornerRadius(AppCornerRadius.md)
        .cardShadow()
        .padding(.horizontal, AppSpacing.md)
    }
    
    private var badgeColor: Color {
        switch insight.type {
        case .pattern: return .accentBlue
        case .anomaly: return .warningYellow
        case .correlation: return .successGreen
        }
    }
}

#Preview {
    InsightsView()
}
