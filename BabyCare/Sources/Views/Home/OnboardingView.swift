//
//  OnboardingView.swift
//  BabyCare
//
//  引导页视图
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentPage = 0
    @State private var showAddBaby = false
    
    let pages: [OnboardingPage] = [
        OnboardingPage(
            emoji: "👶",
            title: "记录宝宝成长",
            description: "轻松录入宝宝基础信息\n自动生成专属成长曲线"
        ),
        OnboardingPage(
            emoji: "📊",
            title: "智能分析报告",
            description: "AI解读儿保报告\n科学评估宝宝发育状况"
        ),
        OnboardingPage(
            emoji: "📅",
            title: "贴心日程规划",
            description: "个性化喂养/睡眠计划\n轻松管理每日育儿任务"
        )
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Skip Button
            HStack {
                Spacer()
                Button("跳过") {
                    showAddBaby = true
                }
                .font(AppFont.bodyMedium())
                .foregroundColor(.textTertiary)
                .padding()
            }
            
            // Pages
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    OnboardingPageView(page: pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Page Indicator
            HStack(spacing: 8) {
                ForEach(0..<pages.count, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? Color.primaryPink : Color.borderColor)
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut, value: currentPage)
                }
            }
            .padding(.vertical, AppSpacing.lg)
            
            // Button
            Button(action: {
                if currentPage < pages.count - 1 {
                    withAnimation {
                        currentPage += 1
                    }
                } else {
                    showAddBaby = true
                }
            }) {
                Text(currentPage < pages.count - 1 ? "下一步" : "开始使用")
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal, AppSpacing.lg)
            .padding(.bottom, AppSpacing.xl)
        }
        .background(Color.white)
        .fullScreenCover(isPresented: $showAddBaby) {
            AddBabyView(isFirstTime: true)
        }
    }
}

struct OnboardingPage {
    let emoji: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()
            
            // Illustration placeholder
            ZStack {
                Circle()
                    .fill(Color.primaryPinkBackground)
                    .frame(width: 200, height: 200)
                
                Text(page.emoji)
                    .font(.system(size: 80))
            }
            
            Text(page.title)
                .font(AppFont.h1())
                .foregroundColor(.textPrimary)
            
            Text(page.description)
                .font(AppFont.bodyLarge())
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(6)
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, AppSpacing.xl)
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
}
