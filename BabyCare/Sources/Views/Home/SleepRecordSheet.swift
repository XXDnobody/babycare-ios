//
//  SleepRecordSheet.swift
//  BabyCare
//
//  睡眠记录弹框 - 支持开始/结束时间记录
//

import SwiftUI

struct SleepRecordSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var sleepType: SleepRecord.SleepType = .nap
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date().addingTimeInterval(3600) // 默认1小时后
    @State private var isTimerRunning: Bool = false
    @State private var timerStartTime: Date = Date()
    @State private var notes: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    // Emoji Header
                    Text("😴")
                        .font(.system(size: 60))
                        .padding(.top, AppSpacing.lg)
                    
                    Text("记录睡眠")
                        .font(AppFont.h2())
                    
                    // 睡眠类型
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("睡眠类型")
                            .font(AppFont.bodyMedium())
                            .foregroundColor(.textSecondary)
                        
                        HStack(spacing: AppSpacing.md) {
                            SleepTypeButton(
                                title: "小睡",
                                emoji: "😴",
                                isSelected: sleepType == .nap
                            ) {
                                sleepType = .nap
                            }
                            
                            SleepTypeButton(
                                title: "夜间睡眠",
                                emoji: "🌙",
                                isSelected: sleepType == .nightSleep
                            ) {
                                sleepType = .nightSleep
                            }
                        }
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    
                    Divider()
                        .padding(.horizontal, AppSpacing.lg)
                    
                    // 计时器或手动输入
                    if !isTimerRunning {
                        manualInputSection
                    } else {
                        timerSection
                    }
                    
                    Divider()
                        .padding(.horizontal, AppSpacing.lg)
                    
                    // 备注
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("备注")
                            .font(AppFont.bodyMedium())
                            .foregroundColor(.textSecondary)
                        
                        TextField("添加备注（如睡眠质量、是否哭闹等）...", text: $notes, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(3...6)
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    
                    Spacer(minLength: AppSpacing.xl)
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
                    if !isTimerRunning {
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
    }
    
    // MARK: - 手动输入部分
    private var manualInputSection: some View {
        VStack(spacing: AppSpacing.lg) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("开始时间")
                    .font(AppFont.bodyMedium())
                    .foregroundColor(.textSecondary)
                
                DatePicker("", selection: $startTime)
                    .datePickerStyle(.compact)
                    .labelsHidden()
            }
            .padding(.horizontal, AppSpacing.lg)
            
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("结束时间")
                    .font(AppFont.bodyMedium())
                    .foregroundColor(.textSecondary)
                
                DatePicker("", selection: $endTime)
                    .datePickerStyle(.compact)
                    .labelsHidden()
            }
            .padding(.horizontal, AppSpacing.lg)
            
            // 显示时长
            let duration = calculateDuration(from: startTime, to: endTime)
            if duration.hours > 0 || duration.minutes > 0 {
                VStack(spacing: AppSpacing.xs) {
                    Text("睡眠时长")
                        .font(AppFont.caption())
                        .foregroundColor(.textSecondary)
                    
                    HStack(spacing: AppSpacing.xs) {
                        if duration.hours > 0 {
                            Text("\(duration.hours)")
                                .font(AppFont.h1())
                                .foregroundColor(.primaryPink)
                            Text("小时")
                                .font(AppFont.bodyMedium())
                                .foregroundColor(.textSecondary)
                        }
                        
                        if duration.minutes > 0 {
                            Text("\(duration.minutes)")
                                .font(AppFont.h1())
                                .foregroundColor(.primaryPink)
                            Text("分钟")
                                .font(AppFont.bodyMedium())
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.primaryPinkBackground)
                .cornerRadius(AppCornerRadius.md)
                .padding(.horizontal, AppSpacing.lg)
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
                .background(Color.primaryPink)
                .foregroundColor(.white)
                .cornerRadius(AppCornerRadius.md)
            }
            .padding(.horizontal, AppSpacing.lg)
        }
    }
    
    // MARK: - 计时器部分
    private var timerSection: some View {
        VStack(spacing: AppSpacing.lg) {
            VStack(spacing: AppSpacing.sm) {
                Text("睡眠中...")
                    .font(AppFont.bodyMedium())
                    .foregroundColor(.textSecondary)
                
                Text("开始时间: \(formatTime(timerStartTime))")
                    .font(AppFont.bodySmall())
                    .foregroundColor(.textTertiary)
            }
            
            SleepTimerView(startTime: timerStartTime)
                .padding()
                .background(Color.primaryPinkBackground)
                .cornerRadius(AppCornerRadius.lg)
                .padding(.horizontal, AppSpacing.lg)
            
            Button {
                stopTimer()
            } label: {
                HStack {
                    Image(systemName: "stop.circle.fill")
                    Text("结束睡眠")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.primaryPink)
                .foregroundColor(.white)
                .cornerRadius(AppCornerRadius.md)
            }
            .padding(.horizontal, AppSpacing.lg)
        }
    }
    
    // MARK: - Helper Functions
    private func startTimer() {
        timerStartTime = Date()
        startTime = timerStartTime
        isTimerRunning = true
    }
    
    private func stopTimer() {
        endTime = Date()
        isTimerRunning = false
    }
    
    private func calculateDuration(from start: Date, to end: Date) -> (hours: Int, minutes: Int) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: start, to: end)
        return (components.hour ?? 0, components.minute ?? 0)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func saveRecord() {
        // TODO: 保存记录到数据库
        print("Save sleep record")
        print("Type: \(sleepType == .nap ? "小睡" : "夜间睡眠")")
        print("Start: \(startTime)")
        print("End: \(endTime)")
        let duration = calculateDuration(from: startTime, to: endTime)
        print("Duration: \(duration.hours)h \(duration.minutes)m")
        if !notes.isEmpty {
            print("Notes: \(notes)")
        }
    }
}

// MARK: - Sleep Type Button
struct SleepTypeButton: View {
    let title: String
    let emoji: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.xs) {
                Text(emoji)
                    .font(.system(size: 32))
                Text(title)
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

// MARK: - Sleep Timer View
struct SleepTimerView: View {
    let startTime: Date
    @State private var currentTime = Date()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: startTime, to: currentTime)
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        let seconds = components.second ?? 0
        
        VStack(spacing: AppSpacing.sm) {
            HStack(spacing: AppSpacing.xs) {
                TimeUnit(value: hours, unit: "时")
                Text(":")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(.primaryPink)
                TimeUnit(value: minutes, unit: "分")
                Text(":")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(.primaryPink)
                TimeUnit(value: seconds, unit: "秒")
            }
        }
        .onReceive(timer) { _ in
            currentTime = Date()
        }
    }
}

struct TimeUnit: View {
    let value: Int
    let unit: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(String(format: "%02d", value))
                .font(.system(size: 40, weight: .medium, design: .monospaced))
                .foregroundColor(.primaryPink)
            Text(unit)
                .font(AppFont.caption())
                .foregroundColor(.textSecondary)
        }
    }
}

#Preview {
    SleepRecordSheet()
}
