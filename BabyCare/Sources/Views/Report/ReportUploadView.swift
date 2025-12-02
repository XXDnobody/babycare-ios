//
//  ReportUploadView.swift
//  BabyCare
//
//  报告上传与AI分析页面
//

import SwiftUI
import PhotosUI

struct ReportUploadView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var isAnalyzing = false
    @State private var analysisResult: AnalysisResult?
    @State private var showCamera = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    if analysisResult != nil {
                        analysisResultView
                    } else if isAnalyzing {
                        analyzingView
                    } else {
                        uploadSection
                        historySection
                    }
                }
                .padding(AppSpacing.md)
            }
            .background(Color.backgroundGray)
            .navigationTitle("儿保报告分析")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.textSecondary)
                    }
                }
                
                if analysisResult != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: shareResult) {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.primaryPink)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Upload Section
    private var uploadSection: some View {
        VStack(spacing: AppSpacing.lg) {
            // Upload Area
            PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                VStack(spacing: AppSpacing.md) {
                    ZStack {
                        RoundedRectangle(cornerRadius: AppCornerRadius.md)
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [8]))
                            .foregroundColor(.borderColor)
                        
                        VStack(spacing: AppSpacing.md) {
                            Image(systemName: "doc.badge.plus")
                                .font(.system(size: 48))
                                .foregroundColor(.primaryPink)
                            
                            Text("点击上传报告")
                                .font(AppFont.h4())
                                .foregroundColor(.textPrimary)
                            
                            Text("支持 JPG/PNG/PDF 格式\n文件大小不超过 20MB")
                                .font(AppFont.caption())
                                .foregroundColor(.textTertiary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(AppSpacing.xl)
                    }
                    .frame(height: 200)
                }
            }
            .onChange(of: selectedPhotoItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedImage = image
                        startAnalysis()
                    }
                }
            }
            
            // Divider
            HStack {
                Rectangle()
                    .fill(Color.borderColor)
                    .frame(height: 1)
                Text("或")
                    .font(AppFont.caption())
                    .foregroundColor(.textTertiary)
                Rectangle()
                    .fill(Color.borderColor)
                    .frame(height: 1)
            }
            
            // Camera Button
            Button(action: { showCamera = true }) {
                HStack {
                    Image(systemName: "camera.fill")
                    Text("拍照扫描")
                }
            }
            .buttonStyle(SecondaryButtonStyle())
        }
        .padding(AppSpacing.md)
        .background(Color.white)
        .cornerRadius(AppCornerRadius.md)
    }
    
    // MARK: - Analyzing View
    private var analyzingView: some View {
        VStack(spacing: AppSpacing.lg) {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
                    .cornerRadius(AppCornerRadius.md)
            }
            
            ProgressView()
                .scaleEffect(1.5)
            
            Text("AI正在分析报告...")
                .font(AppFont.h4())
                .foregroundColor(.textPrimary)
            
            Text("请稍候,这可能需要几秒钟")
                .font(AppFont.bodySmall())
                .foregroundColor(.textTertiary)
        }
        .padding(AppSpacing.xl)
    }
    
    // MARK: - Analysis Result View
    private var analysisResultView: some View {
        VStack(alignment: .leading, spacing: AppSpacing.lg) {
            // Header
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text("4月龄儿保报告分析")
                    .font(AppFont.h3())
                    .foregroundColor(.textPrimary)
                
                Text(Date(), style: .date)
                    .font(AppFont.caption())
                    .foregroundColor(.textTertiary)
            }
            
            // Growth Indicators
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                SectionHeader(title: "📊 生长指标")
                
                VStack(spacing: 0) {
                    IndicatorRow(name: "身高", value: "65.0cm", status: .normal, percentile: "P50-P75 百分位")
                    Divider()
                    IndicatorRow(name: "体重", value: "7.5kg", status: .normal, percentile: "P50-P75 百分位")
                    Divider()
                    IndicatorRow(name: "头围", value: "42.0cm", status: .normal, percentile: "P50 百分位")
                }
                .background(Color.white)
                .cornerRadius(AppCornerRadius.md)
            }
            
            // Blood Test
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                SectionHeader(title: "🩸 血常规")
                
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    HStack {
                        Text("血红蛋白")
                            .font(AppFont.bodyMedium())
                        Spacer()
                        Text("110g/L")
                            .font(AppFont.bodyMedium())
                        StatusBadge(status: .attention)
                    }
                    
                    HStack(alignment: .top, spacing: AppSpacing.xs) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.warningYellow)
                            .font(.system(size: 14))
                        Text("略低于参考值(≥110)")
                            .font(AppFont.bodySmall())
                            .foregroundColor(.textSecondary)
                    }
                    
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        Text("💡 建议:")
                            .font(AppFont.bodySmall())
                            .foregroundColor(.textSecondary)
                        
                        Text("• 适当补充铁剂")
                            .font(AppFont.bodySmall())
                            .foregroundColor(.textSecondary)
                        Text("• 6月龄后添加含铁辅食")
                            .font(AppFont.bodySmall())
                            .foregroundColor(.textSecondary)
                    }
                }
                .padding(AppSpacing.md)
                .background(Color.white)
                .cornerRadius(AppCornerRadius.md)
            }
            
            // AI Summary
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                SectionHeader(title: "🤖 AI综合建议")
                
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text("宝宝整体发育良好！生长指标处于正常范围。血红蛋白偏低需关注，建议适当补充铁剂，并在6月龄后添加含铁丰富的辅食，如猪肝泥、牛肉泥等。")
                        .font(AppFont.bodyMedium())
                        .foregroundColor(.textSecondary)
                        .lineSpacing(6)
                }
                .padding(AppSpacing.md)
                .background(Color.white)
                .cornerRadius(AppCornerRadius.md)
            }
            
            // Disclaimer
            HStack(alignment: .top, spacing: AppSpacing.xs) {
                Image(systemName: "exclamationmark.circle")
                    .foregroundColor(.textTertiary)
                    .font(.system(size: 14))
                Text("以上分析仅供参考，不替代医生诊断")
                    .font(AppFont.caption())
                    .foregroundColor(.textTertiary)
            }
            .padding(.top, AppSpacing.sm)
        }
    }
    
    // MARK: - History Section
    private var historySection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            SectionHeader(title: "历史报告")
            
            VStack(spacing: 0) {
                ReportHistoryRow(title: "4月龄儿保报告", date: "2024-12-01", status: "已分析")
                Divider()
                ReportHistoryRow(title: "3月龄儿保报告", date: "2024-11-01", status: "已分析")
            }
            .background(Color.white)
            .cornerRadius(AppCornerRadius.md)
        }
    }
    
    // MARK: - Actions
    private func startAnalysis() {
        isAnalyzing = true
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isAnalyzing = false
            analysisResult = AnalysisResult(
                indicators: [],
                summary: "宝宝整体发育良好",
                suggestions: [],
                warnings: []
            )
        }
    }
    
    private func shareResult() {
        // Share functionality
    }
}

// MARK: - Indicator Row
struct IndicatorRow: View {
    let name: String
    let value: String
    let status: HealthIndicator.IndicatorStatus
    let percentile: String?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(name)
                    .font(AppFont.bodyMedium())
                    .foregroundColor(.textPrimary)
                
                if let percentile = percentile {
                    Text(percentile)
                        .font(AppFont.caption())
                        .foregroundColor(.textTertiary)
                }
            }
            
            Spacer()
            
            Text(value)
                .font(AppFont.bodyMedium())
                .foregroundColor(.textPrimary)
            
            StatusBadge(status: status)
        }
        .padding(AppSpacing.md)
    }
}

// MARK: - Report History Row
struct ReportHistoryRow: View {
    let title: String
    let date: String
    let status: String
    
    var body: some View {
        HStack {
            Image(systemName: "doc.text.fill")
                .foregroundColor(.primaryPink)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppFont.bodyMedium())
                    .foregroundColor(.textPrimary)
                Text(date)
                    .font(AppFont.caption())
                    .foregroundColor(.textTertiary)
            }
            
            Spacer()
            
            Text(status)
                .font(AppFont.caption())
                .foregroundColor(.successGreen)
            
            Image(systemName: "chevron.right")
                .foregroundColor(.textTertiary)
                .font(.system(size: 12))
        }
        .padding(AppSpacing.md)
    }
}

#Preview {
    ReportUploadView()
}
