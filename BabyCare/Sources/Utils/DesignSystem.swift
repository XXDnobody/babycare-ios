//
//  DesignSystem.swift
//  BabyCare
//
//  设计系统 - 颜色、字体、样式定义
//

import SwiftUI

// MARK: - Color System
extension Color {
    // Primary Colors
    static let primaryPink = Color(hex: "FF6B9D")
    static let primaryPinkLight = Color(hex: "FF8DB5")
    static let primaryPinkLighter = Color(hex: "FFAFC9")
    static let primaryPinkBackground = Color(hex: "FFF0F5")
    
    // Secondary Colors
    static let accentBlue = Color(hex: "5B9FED")
    static let successGreen = Color(hex: "4CAF50")
    static let warningYellow = Color(hex: "FFB300")
    static let errorRed = Color(hex: "F44336")
    
    // Neutral Colors
    static let textPrimary = Color(hex: "1A1A1A")
    static let textSecondary = Color(hex: "4A4A4A")
    static let textTertiary = Color(hex: "9E9E9E")
    static let borderColor = Color(hex: "E0E0E0")
    static let backgroundGray = Color(hex: "F5F5F5")
    
    // Hex initializer
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Typography
struct AppFont {
    // Heading
    static func h1() -> Font { .system(size: 28, weight: .bold, design: .default) }
    static func h2() -> Font { .system(size: 22, weight: .semibold, design: .default) }
    static func h3() -> Font { .system(size: 18, weight: .medium, design: .default) }
    static func h4() -> Font { .system(size: 16, weight: .semibold, design: .default) }
    
    // Body
    static func bodyLarge() -> Font { .system(size: 17, weight: .regular, design: .default) }
    static func bodyMedium() -> Font { .system(size: 15, weight: .regular, design: .default) }
    static func bodySmall() -> Font { .system(size: 13, weight: .regular, design: .default) }
    
    // Caption
    static func caption() -> Font { .system(size: 12, weight: .regular, design: .default) }
    static func overline() -> Font { .system(size: 10, weight: .medium, design: .default) }
}

// MARK: - Spacing
struct AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

// MARK: - Corner Radius
struct AppCornerRadius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let full: CGFloat = 9999
}

// MARK: - Shadow
extension View {
    func cardShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
    }
    
    func lightShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 1)
    }
}

// MARK: - Card Style
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .cornerRadius(AppCornerRadius.md)
            .cardShadow()
    }
}

extension View {
    func cardStyle() -> some View {
        self.modifier(CardStyle())
    }
}

// MARK: - Primary Button Style
struct PrimaryButtonStyle: ButtonStyle {
    var isEnabled: Bool = true
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppFont.h4())
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.sm)
                    .fill(isEnabled ? Color.primaryPink : Color.textTertiary)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Secondary Button Style
struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppFont.h4())
            .foregroundColor(.primaryPink)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.sm)
                    .stroke(Color.primaryPink, lineWidth: 1.5)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Quick Action Button
struct QuickActionButton: View {
    let emoji: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.sm) {
                Text(emoji)
                    .font(.system(size: 28))
                Text(title)
                    .font(AppFont.caption())
                    .foregroundColor(.textSecondary)
            }
            .frame(width: 70, height: 70)
            .background(Color.white)
            .cornerRadius(AppCornerRadius.md)
            .cardShadow()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Metric Card
struct MetricCard: View {
    let title: String
    let value: String
    let trend: String?
    let trendUp: Bool?
    let emoji: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            HStack {
                Text(emoji)
                    .font(.system(size: 16))
                Text(title)
                    .font(AppFont.caption())
                    .foregroundColor(.textTertiary)
            }
            
            Text(value)
                .font(AppFont.h3())
                .foregroundColor(.textPrimary)
            
            if let trend = trend, let isUp = trendUp {
                HStack(spacing: 2) {
                    Image(systemName: isUp ? "arrow.up" : "arrow.down")
                        .font(.system(size: 10))
                    Text(trend)
                        .font(AppFont.caption())
                }
                .foregroundColor(isUp ? .successGreen : .errorRed)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.md)
        .background(Color.white)
        .cornerRadius(AppCornerRadius.md)
        .cardShadow()
    }
}

// MARK: - Status Badge
struct StatusBadge: View {
    let status: HealthIndicator.IndicatorStatus
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
            Text(status.displayName)
                .font(AppFont.caption())
                .foregroundColor(statusColor)
        }
        .padding(.horizontal, AppSpacing.sm)
        .padding(.vertical, AppSpacing.xs)
        .background(statusColor.opacity(0.1))
        .cornerRadius(AppCornerRadius.full)
    }
    
    var statusColor: Color {
        switch status {
        case .normal: return .successGreen
        case .attention: return .warningYellow
        case .abnormal: return .errorRed
        }
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let emoji: String
    let title: String
    let description: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            Text(emoji)
                .font(.system(size: 64))
            
            Text(title)
                .font(AppFont.h3())
                .foregroundColor(.textPrimary)
            
            Text(description)
                .font(AppFont.bodyMedium())
                .foregroundColor(.textTertiary)
                .multilineTextAlignment(.center)
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    HStack {
                        Text(actionTitle)
                        Image(systemName: "arrow.right")
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, AppSpacing.xl)
                .padding(.top, AppSpacing.md)
            }
        }
        .padding(AppSpacing.xl)
    }
}

// MARK: - Loading View
struct LoadingView: View {
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            ProgressView()
                .scaleEffect(1.5)
            Text("加载中...")
                .font(AppFont.bodyMedium())
                .foregroundColor(.textTertiary)
        }
    }
}

// MARK: - Section Header
struct SectionHeader: View {
    let title: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    init(title: String, actionTitle: String? = nil, action: (() -> Void)? = nil) {
        self.title = title
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(AppFont.h4())
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    HStack(spacing: 4) {
                        Text(actionTitle)
                            .font(AppFont.bodySmall())
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(.primaryPink)
                }
            }
        }
    }
}

// MARK: - Progress Ring
struct ProgressRing: View {
    let progress: Double
    let size: CGFloat
    let lineWidth: CGFloat
    
    init(progress: Double, size: CGFloat = 100, lineWidth: CGFloat = 10) {
        self.progress = progress
        self.size = size
        self.lineWidth = lineWidth
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.borderColor, lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.primaryPink,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.8), value: progress)
            
            Text("\(Int(progress * 100))%")
                .font(AppFont.h2())
                .foregroundColor(.textPrimary)
        }
        .frame(width: size, height: size)
    }
}
