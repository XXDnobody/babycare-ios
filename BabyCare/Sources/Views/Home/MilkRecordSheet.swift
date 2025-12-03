//
//  MilkRecordSheet.swift
//  BabyCare
//
//  喝奶记录弹框 - 支持亲喂和瓶装两种方式
//

import SwiftUI

struct MilkRecordSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var feedingMethod: FeedingRecord.FeedingMethod = .bottle
    @State private var feedingType: FeedingRecord.FeedingType = .formula
    @State private var amount: Double = 180
    @State private var recordTime: Date = Date()  // 记录时间
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date()
    @State private var isTimerRunning: Bool = false
    @State private var notes: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    // Emoji Header
                    Text("🍼")
                        .font(.system(size: 60))
                        .padding(.top, AppSpacing.lg)
                    
                    Text("记录喝奶")
                        .font(AppFont.h2())
                    
                    // 记录时间
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("记录时间")
                            .font(AppFont.bodyMedium())
                            .foregroundColor(.textSecondary)
                        
                        DatePicker("", selection: $recordTime)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    
                    // 方式选择：亲喂 / 瓶装
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("喂养方式")
                            .font(AppFont.bodyMedium())
                            .foregroundColor(.textSecondary)
                        
                        HStack(spacing: AppSpacing.md) {
                            ForEach(FeedingRecord.FeedingMethod.allCases, id: \.self) { method in
                                MethodButton(
                                    method: method,
                                    isSelected: feedingMethod == method
                                ) {
                                    feedingMethod = method
                                }
                            }
                        }
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    
                    Divider()
                        .padding(.horizontal, AppSpacing.lg)
                    
                    // 根据方式显示不同内容
                    if feedingMethod == .breastfeeding {
                        breastfeedingSection
                    } else {
                        bottleSection
                    }
                    
                    // 备注
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("备注")
                            .font(AppFont.bodyMedium())
                            .foregroundColor(.textSecondary)
                        
                        TextField("添加备注...", text: $notes, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(3...6)
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    
                    Spacer()
                }
            }
            .background(Color.backgroundGray)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                    .foregroundColor(.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        saveRecord()
                        dismiss()
                    }
                    .foregroundColor(.primaryPink)
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    // MARK: - 亲喂部分
    private var breastfeedingSection: some View {
        VStack(spacing: AppSpacing.lg) {
            // 计时器或手动输入
            VStack(spacing: AppSpacing.md) {
                if !isTimerRunning {
                    // 手动输入时间
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("开始时间")
                            .font(AppFont.bodyMedium())
                            .foregroundColor(.textSecondary)
                        
                        DatePicker("", selection: $startTime, displayedComponents: [.hourAndMinute])
                            .datePickerStyle(.compact)
                            .labelsHidden()
                    }
                    
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("结束时间")
                            .font(AppFont.bodyMedium())
                            .foregroundColor(.textSecondary)
                        
                        DatePicker("", selection: $endTime, displayedComponents: [.hourAndMinute])
                            .datePickerStyle(.compact)
                            .labelsHidden()
                    }
                    
                    // 显示时长
                    let duration = Calendar.current.dateComponents([.minute], from: startTime, to: endTime).minute ?? 0
                    if duration > 0 {
                        Text("时长：\(duration) 分钟")
                            .font(AppFont.h3())
                            .foregroundColor(.primaryPink)
                    }
                    
                    // 开始计时按钮
                    Button {
                        startTimer()
                    } label: {
                        HStack {
                            Image(systemName: "timer")
                            Text("开始计时")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primaryPinkBackground)
                        .foregroundColor(.primaryPink)
                        .cornerRadius(AppCornerRadius.md)
                    }
                } else {
                    // 计时中
                    VStack(spacing: AppSpacing.md) {
                        Text("正在计时...")
                            .font(AppFont.bodyMedium())
                            .foregroundColor(.textSecondary)
                        
                        TimerView(startTime: startTime)
                        
                        Button {
                            stopTimer()
                        } label: {
                            HStack {
                                Image(systemName: "stop.circle.fill")
                                Text("结束")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.primaryPink)
                            .foregroundColor(.white)
                            .cornerRadius(AppCornerRadius.md)
                        }
                    }
                }
            }
            .padding(.horizontal, AppSpacing.lg)
        }
    }
    
    // MARK: - 瓶装部分
    private var bottleSection: some View {
        VStack(spacing: AppSpacing.lg) {
            // 类型选择：母乳 / 奶粉
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("类型")
                    .font(AppFont.bodyMedium())
                    .foregroundColor(.textSecondary)
                
                HStack(spacing: AppSpacing.md) {
                    TypeButton(
                        title: "母乳",
                        emoji: "🤱",
                        isSelected: feedingType == .breastMilk
                    ) {
                        feedingType = .breastMilk
                    }
                    
                    TypeButton(
                        title: "奶粉",
                        emoji: "🍼",
                        isSelected: feedingType == .formula
                    ) {
                        feedingType = .formula
                    }
                }
            }
            .padding(.horizontal, AppSpacing.lg)
            
            // 奶量输入
            VStack(spacing: AppSpacing.sm) {
                Text("\(Int(amount)) ml")
                    .font(AppFont.h1())
                    .foregroundColor(.primaryPink)
                
                Slider(value: $amount, in: 30...300, step: 10)
                    .tint(.primaryPink)
                    .padding(.horizontal, AppSpacing.xl)
                
                // 快捷按钮 - 横向滚动
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppSpacing.sm) {
                        ForEach([60, 90, 120, 150, 180, 210, 240, 270], id: \.self) { value in
                            Button("\(value)ml") {
                                amount = Double(value)
                            }
                            .font(AppFont.bodyMedium())
                            .padding(.horizontal, AppSpacing.md)
                            .padding(.vertical, AppSpacing.sm)
                            .background(amount == Double(value) ? Color.primaryPink : Color.gray.opacity(0.2))
                            .foregroundColor(amount == Double(value) ? .white : .textSecondary)
                            .cornerRadius(AppCornerRadius.full)
                        }
                    }
                    .padding(.horizontal, AppSpacing.lg)
                }
            }
            .padding(.horizontal, AppSpacing.lg)
        }
    }
    
    // MARK: - Helper Functions
    private func startTimer() {
        startTime = Date()
        endTime = Date()
        isTimerRunning = true
    }
    
    private func stopTimer() {
        endTime = Date()
        isTimerRunning = false
    }
    
    private func saveRecord() {
        // TODO: 保存记录到数据库
        print("Save milk record")
        print("Method: \(feedingMethod.displayName)")
        if feedingMethod == .bottle {
            print("Type: \(feedingType.displayName)")
            print("Amount: \(amount) ml")
        } else {
            let duration = Calendar.current.dateComponents([.minute], from: startTime, to: endTime).minute ?? 0
            print("Duration: \(duration) minutes")
        }
        if !notes.isEmpty {
            print("Notes: \(notes)")
        }
    }
}

// MARK: - Method Button
struct MethodButton: View {
    let method: FeedingRecord.FeedingMethod
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.xs) {
                Text(method.emoji)
                    .font(.system(size: 32))
                Text(method.displayName)
                    .font(AppFont.bodyMedium())
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(isSelected ? Color.primaryPinkBackground : Color.white)
            .foregroundColor(isSelected ? .primaryPink : .textSecondary)
            .cornerRadius(AppCornerRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.md)
                    .stroke(isSelected ? Color.primaryPink : Color.clear, lineWidth: 2)
            )
        }
    }
}

// MARK: - Type Button
struct TypeButton: View {
    let title: String
    let emoji: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                Text(emoji)
                    .font(.system(size: 24))
                Text(title)
                    .font(AppFont.bodyMedium())
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.sm)
            .background(isSelected ? Color.primaryPinkBackground : Color.white)
            .foregroundColor(isSelected ? .primaryPink : .textSecondary)
            .cornerRadius(AppCornerRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.md)
                    .stroke(isSelected ? Color.primaryPink : Color.clear, lineWidth: 2)
            )
        }
    }
}

// MARK: - Timer View
struct TimerView: View {
    let startTime: Date
    @State private var currentTime = Date()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        let duration = Calendar.current.dateComponents([.minute, .second], from: startTime, to: currentTime)
        let minutes = duration.minute ?? 0
        let seconds = duration.second ?? 0
        
        Text(String(format: "%02d:%02d", minutes, seconds))
            .font(.system(size: 48, weight: .medium, design: .monospaced))
            .foregroundColor(.primaryPink)
            .onReceive(timer) { _ in
                currentTime = Date()
            }
    }
}

#Preview {
    MilkRecordSheet()
}
