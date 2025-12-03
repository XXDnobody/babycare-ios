//
//  BabyCareApp.swift
//  BabyCare
//
//  Created on 2025-12-02.
//

import SwiftUI

@main
struct BabyCareApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            if appState.isOnboardingCompleted {
                MainTabView()
                    .environmentObject(appState)
            } else {
                OnboardingView()
                    .environmentObject(appState)
            }
        }
    }
}

// MARK: - App State
class AppState: ObservableObject {
    @Published var isOnboardingCompleted: Bool {
        didSet {
            UserDefaults.standard.set(isOnboardingCompleted, forKey: "isOnboardingCompleted")
        }
    }
    
    @Published var currentBaby: Baby?
    @Published var babies: [Baby] = []
    
    init() {
        self.isOnboardingCompleted = UserDefaults.standard.bool(forKey: "isOnboardingCompleted")
        loadBabies()
    }
    
    func loadBabies() {
        // Load from local storage
        if let data = UserDefaults.standard.data(forKey: "babies"),
           let decoded = try? JSONDecoder().decode([Baby].self, from: data) {
            babies = decoded
            currentBaby = babies.first
        }
    }
    
    func saveBabies() {
        if let encoded = try? JSONEncoder().encode(babies) {
            UserDefaults.standard.set(encoded, forKey: "babies")
        }
    }
    
    func addBaby(_ baby: Baby) {
        babies.append(baby)
        if currentBaby == nil {
            currentBaby = baby
        }
        saveBabies()
    }
    
    func updateBaby(_ baby: Baby) {
        if let index = babies.firstIndex(where: { $0.id == baby.id }) {
            babies[index] = baby
            if currentBaby?.id == baby.id {
                currentBaby = baby
            }
            saveBabies()
        }
    }
    
    func deleteBaby(_ baby: Baby) {
        babies.removeAll { $0.id == baby.id }
        
        // 如果删除的是当前选中的宝宝，切换到第一个宝宝（如果有的话）
        if currentBaby?.id == baby.id {
            currentBaby = babies.first
        }
        
        saveBabies()
    }
    
    func completeOnboarding() {
        isOnboardingCompleted = true
    }
}
