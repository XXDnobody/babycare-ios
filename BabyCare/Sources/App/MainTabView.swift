//
//  MainTabView.swift
//  BabyCare
//
//  主Tab导航视图
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    @EnvironmentObject var appState: AppState
    
    enum Tab: String, CaseIterable {
        case home = "home"
        case schedule = "schedule"
        case dashboard = "dashboard"
        case profile = "profile"
        
        var title: String {
            switch self {
            case .home: return "首页"
            case .schedule: return "日程"
            case .dashboard: return "复盘"
            case .profile: return "我的"
            }
        }
        
        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .schedule: return "calendar"
            case .dashboard: return "chart.bar.fill"
            case .profile: return "person.fill"
            }
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label(Tab.home.title, systemImage: Tab.home.icon)
                }
                .tag(Tab.home)
            
            ScheduleView()
                .tabItem {
                    Label(Tab.schedule.title, systemImage: Tab.schedule.icon)
                }
                .tag(Tab.schedule)
            
            DashboardView()
                .tabItem {
                    Label(Tab.dashboard.title, systemImage: Tab.dashboard.icon)
                }
                .tag(Tab.dashboard)
            
            ProfileView()
                .tabItem {
                    Label(Tab.profile.title, systemImage: Tab.profile.icon)
                }
                .tag(Tab.profile)
        }
        .tint(.primaryPink)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState())
}
