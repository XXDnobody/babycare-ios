//
//  ScheduleView.swift
//  BabyCare
//
//  日程规划页面 - 时间轴视图
//

import SwiftUI

struct ScheduleView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedDate: Date = Date()
    @State private var tasks: [ScheduleTask] = []
    @State private var showAddTask = false
    @State private var selectedTask: ScheduleTask?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Date Selector
                dateSelector
                
                // Timeline
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(sampleTasks) { task in
                            TimelineTaskRow(task: task) {
                                selectedTask = task
                            }
                        }
                    }
                    .padding(.vertical, AppSpacing.md)
                }
                .background(Color.backgroundGray)
            }
            .navigationTitle("今日日程")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddTask = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(.primaryPink)
                    }
                }
            }
        }
        .sheet(item: $selectedTask) { task in
            TaskDetailSheet(task: task)
        }
        .sheet(isPresented: $showAddTask) {
            AddTaskView()
        }
    }
    
    // MARK: - Date Selector
    private var dateSelector: some View {
        HStack {
            Button(action: { changeDate(by: -1) }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.primaryPink)
            }
            
            Spacer()
            
            Text(dateString)
                .font(AppFont.h4())
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Button(action: { changeDate(by: 1) }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.primaryPink)
            }
        }
        .padding(AppSpacing.md)
        .background(Color.white)
    }
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日 EEEE"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: selectedDate)
    }
    
    private func changeDate(by days: Int) {
        if let newDate = Calendar.current.date(byAdding: .day, value: days, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    // Sample data for preview
    private var sampleTasks: [ScheduleTask] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return [
            ScheduleTask(
                babyId: UUID(),
                date: today,
                scheduledTime: calendar.date(bySettingHour: 6, minute: 30, second: 0, of: today)!,
                taskType: .milk,
                title: "晨奶",
                targetValue: 180,
                actualValue: 180,
                isCompleted: true
            ),
            ScheduleTask(
                babyId: UUID(),
                date: today,
                scheduledTime: calendar.date(bySettingHour: 8, minute: 0, second: 0, of: today)!,
                taskType: .exercise,
                title: "早操互动",
                detail: "趴卧练习15min",
                targetValue: 15,
                actualValue: 15,
                isCompleted: true
            ),
            ScheduleTask(
                babyId: UUID(),
                date: today,
                scheduledTime: calendar.date(bySettingHour: 9, minute: 0, second: 0, of: today)!,
                taskType: .nap,
                title: "上午小睡",
                detail: "预计1-1.5h",
                targetValue: 90,
                isCompleted: false
            ),
            ScheduleTask(
                babyId: UUID(),
                date: today,
                scheduledTime: calendar.date(bySettingHour: 10, minute: 30, second: 0, of: today)!,
                taskType: .milk,
                title: "上午奶",
                targetValue: 180,
                isCompleted: false
            ),
            ScheduleTask(
                babyId: UUID(),
                date: today,
                scheduledTime: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: today)!,
                taskType: .food,
                title: "午餐辅食",
                detail: "米粉+南瓜泥",
                isCompleted: false
            ),
            ScheduleTask(
                babyId: UUID(),
                date: today,
                scheduledTime: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: today)!,
                taskType: .nap,
                title: "下午小睡",
                detail: "预计1.5-2h",
                targetValue: 100,
                isCompleted: false
            ),
            ScheduleTask(
                babyId: UUID(),
                date: today,
                scheduledTime: calendar.date(bySettingHour: 16, minute: 30, second: 0, of: today)!,
                taskType: .milk,
                title: "下午奶",
                targetValue: 180,
                isCompleted: false
            ),
            ScheduleTask(
                babyId: UUID(),
                date: today,
                scheduledTime: calendar.date(bySettingHour: 18, minute: 0, second: 0, of: today)!,
                taskType: .play,
                title: "互动游戏",
                detail: "抓握玩具练习",
                targetValue: 20,
                isCompleted: false
            ),
            ScheduleTask(
                babyId: UUID(),
                date: today,
                scheduledTime: calendar.date(bySettingHour: 19, minute: 0, second: 0, of: today)!,
                taskType: .milk,
                title: "晚奶",
                targetValue: 180,
                isCompleted: false
            )
        ]
    }
}

// MARK: - Timeline Task Row
struct TimelineTaskRow: View {
    let task: ScheduleTask
    let onTap: () -> Void
    
    private var isCurrentTask: Bool {
        let now = Date()
        let taskTime = task.scheduledTime
        let hoursDiff = Calendar.current.dateComponents([.hour], from: taskTime, to: now).hour ?? 0
        return hoursDiff >= 0 && hoursDiff < 2 && !task.isCompleted
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.md) {
            // Time Column
            VStack {
                Text(timeString)
                    .font(AppFont.bodySmall())
                    .foregroundColor(.textSecondary)
                    .frame(width: 50)
            }
            
            // Timeline
            VStack(spacing: 0) {
                Circle()
                    .fill(task.isCompleted ? Color.successGreen : (isCurrentTask ? Color.primaryPink : Color.borderColor))
                    .frame(width: 12, height: 12)
                
                Rectangle()
                    .fill(Color.borderColor)
                    .frame(width: 2)
                    .frame(maxHeight: .infinity)
            }
            .frame(width: 12)
            
            // Task Card
            Button(action: onTap) {
                HStack {
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        HStack {
                            Text(task.taskType.emoji)
                            Text(task.title)
                                .font(AppFont.h4())
                                .foregroundColor(.textPrimary)
                        }
                        
                        if let detail = task.detail {
                            Text(detail)
                                .font(AppFont.bodySmall())
                                .foregroundColor(.textSecondary)
                        }
                        
                        if let target = task.targetValue {
                            Text("\(Int(target)) \(task.taskType.unit)")
                                .font(AppFont.caption())
                                .foregroundColor(.textTertiary)
                        }
                    }
                    
                    Spacer()
                    
                    // Status Icon
                    statusIcon
                }
                .padding(AppSpacing.md)
                .background(isCurrentTask ? Color.primaryPinkBackground : Color.white)
                .cornerRadius(AppCornerRadius.md)
                .overlay(
                    RoundedRectangle(cornerRadius: AppCornerRadius.md)
                        .stroke(isCurrentTask ? Color.primaryPink : Color.clear, lineWidth: 1)
                )
                .cardShadow()
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, AppSpacing.md)
        .frame(minHeight: 80)
    }
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: task.scheduledTime)
    }
    
    @ViewBuilder
    private var statusIcon: some View {
        if task.isCompleted {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.successGreen)
                .font(.system(size: 24))
        } else if isCurrentTask {
            Image(systemName: "clock.fill")
                .foregroundColor(.primaryPink)
                .font(.system(size: 24))
        } else {
            Circle()
                .stroke(Color.borderColor, lineWidth: 2)
                .frame(width: 24, height: 24)
        }
    }
}

// MARK: - Task Detail Sheet
struct TaskDetailSheet: View {
    let task: ScheduleTask
    @Environment(\.dismiss) var dismiss
    @State private var actualTime: Date
    @State private var actualValue: Double
    @State private var notes: String = ""
    
    init(task: ScheduleTask) {
        self.task = task
        _actualTime = State(initialValue: task.actualTime ?? Date())
        _actualValue = State(initialValue: task.actualValue ?? task.targetValue ?? 0)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: AppSpacing.lg) {
                // Header
                VStack(spacing: AppSpacing.sm) {
                    Text(task.taskType.emoji)
                        .font(.system(size: 48))
                    
                    Text(task.title)
                        .font(AppFont.h2())
                        .foregroundColor(.textPrimary)
                }
                .padding(.top, AppSpacing.lg)
                
                // Info Card
                VStack(spacing: AppSpacing.md) {
                    InfoRow(title: "计划时间", value: formatTime(task.scheduledTime))
                    
                    if let target = task.targetValue {
                        InfoRow(title: "建议\(task.taskType.unit == "ml" ? "奶量" : "时长")", value: "\(Int(target)) \(task.taskType.unit)")
                    }
                    
                    if let detail = task.detail {
                        InfoRow(title: "详情", value: detail)
                    }
                }
                .padding(AppSpacing.md)
                .background(Color.backgroundGray)
                .cornerRadius(AppCornerRadius.md)
                .padding(.horizontal, AppSpacing.md)
                
                Divider()
                    .padding(.horizontal, AppSpacing.md)
                
                // Record Section
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    Text("📝 执行记录")
                        .font(AppFont.h4())
                        .padding(.horizontal, AppSpacing.md)
                    
                    // Actual Time
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        Text("实际时间")
                            .font(AppFont.bodySmall())
                            .foregroundColor(.textSecondary)
                        
                        DatePicker("", selection: $actualTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .frame(height: 100)
                    }
                    .padding(.horizontal, AppSpacing.md)
                    
                    // Actual Value
                    if task.targetValue != nil {
                        VStack(alignment: .leading, spacing: AppSpacing.xs) {
                            Text("实际\(task.taskType.unit == "ml" ? "奶量" : "时长") (\(task.taskType.unit))")
                                .font(AppFont.bodySmall())
                                .foregroundColor(.textSecondary)
                            
                            HStack {
                                Slider(value: $actualValue, in: 0...300, step: 10)
                                    .tint(.primaryPink)
                                
                                Text("\(Int(actualValue))")
                                    .font(AppFont.h4())
                                    .foregroundColor(.primaryPink)
                                    .frame(width: 50)
                            }
                        }
                        .padding(.horizontal, AppSpacing.md)
                    }
                    
                    // Notes
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        Text("备注")
                            .font(AppFont.bodySmall())
                            .foregroundColor(.textSecondary)
                        
                        TextField("添加备注...", text: $notes)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    .padding(.horizontal, AppSpacing.md)
                }
                
                Spacer()
                
                // Complete Button
                Button(action: {
                    // Save and dismiss
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("完成打卡")
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, AppSpacing.md)
                .padding(.bottom, AppSpacing.lg)
            }
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
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

// MARK: - Info Row
struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(AppFont.bodyMedium())
                .foregroundColor(.textSecondary)
            Spacer()
            Text(value)
                .font(AppFont.bodyMedium())
                .foregroundColor(.textPrimary)
        }
    }
}

// MARK: - Add Task View
struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @State private var taskType: ScheduleTask.TaskType = .milk
    @State private var scheduledTime: Date = Date()
    @State private var targetValue: String = ""
    @State private var notes: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("任务类型") {
                    Picker("类型", selection: $taskType) {
                        ForEach(ScheduleTask.TaskType.allCases, id: \.self) { type in
                            HStack {
                                Text(type.emoji)
                                Text(type.displayName)
                            }
                            .tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("时间") {
                    DatePicker("计划时间", selection: $scheduledTime, displayedComponents: .hourAndMinute)
                }
                
                Section("目标值") {
                    HStack {
                        TextField("输入目标值", text: $targetValue)
                            .keyboardType(.numberPad)
                        Text(taskType.unit)
                            .foregroundColor(.textSecondary)
                    }
                }
                
                Section("备注") {
                    TextField("添加备注...", text: $notes)
                }
            }
            .navigationTitle("添加任务")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") { dismiss() }
                        .foregroundColor(.textSecondary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        // Save task
                        dismiss()
                    }
                    .foregroundColor(.primaryPink)
                }
            }
        }
    }
}

#Preview {
    ScheduleView()
        .environmentObject(AppState())
}
