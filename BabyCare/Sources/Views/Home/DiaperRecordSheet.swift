//
//  DiaperRecordSheet.swift
//  BabyCare
//
//  换尿布记录弹框 - 类型、状态、便便颜色
//

import SwiftUI

struct DiaperRecordSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var diaperType: DiaperRecord.DiaperType = .pee
    @State private var peeStatus: DiaperRecord.Status = .normal
    @State private var peeColor: DiaperRecord.PeeColor = .yellow
    @State private var poopStatus: DiaperRecord.Status = .normal
    @State private var poopColor: DiaperRecord.PoopColor = .yellow
    @State private var recordTime: Date = Date()  // 记录时间
    @State private var notes: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    // Emoji Header
                    Text("🧷")
                        .font(.system(size: 60))
                        .padding(.top, AppSpacing.lg)
                    
                    Text("记录换尿布")
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
                    
                    // 类型选择
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("类型")
                            .font(AppFont.bodyMedium())
                            .foregroundColor(.textSecondary)
                        
                        HStack(spacing: AppSpacing.sm) {
                            ForEach(DiaperRecord.DiaperType.allCases, id: \.self) { type in
                                DiaperTypeButton(
                                    type: type,
                                    isSelected: diaperType == type
                                ) {
                                    diaperType = type
                                }
                            }
                        }
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    
                    Divider()
                        .padding(.horizontal, AppSpacing.lg)
                    
                    // 根据类型显示不同选项
                    if diaperType == .pee || diaperType == .both {
                        peeSection
                    }
                    
                    if diaperType == .poop || diaperType == .both {
                        poopSection
                    }
                    
                    Divider()
                        .padding(.horizontal, AppSpacing.lg)
                    
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
    
    // MARK: - 尿尿部分
    private var peeSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            // 尿尿颜色
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("尿尿颜色")
                    .font(AppFont.bodyMedium())
                    .foregroundColor(.textSecondary)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: AppSpacing.sm) {
                    ForEach(DiaperRecord.PeeColor.allCases, id: \.self) { color in
                        PeeColorButton(
                            color: color,
                            isSelected: peeColor == color
                        ) {
                            peeColor = color
                        }
                    }
                }
            }
            .padding(.horizontal, AppSpacing.lg)
            
            // 颜色警告提示
            if let warning = peeColor.warning {
                HStack(alignment: .top, spacing: AppSpacing.sm) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.warningYellow)
                    Text(warning)
                        .font(AppFont.bodySmall())
                        .foregroundColor(.textSecondary)
                }
                .padding(AppSpacing.sm)
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(AppCornerRadius.sm)
                .padding(.horizontal, AppSpacing.lg)
            }
        }
    }
    
    // MARK: - 便便部分
    private var poopSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            // 便便状态
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("便便状态")
                    .font(AppFont.bodyMedium())
                    .foregroundColor(.textSecondary)
                
                HStack(spacing: AppSpacing.sm) {
                    ForEach(DiaperRecord.Status.allCases, id: \.self) { status in
                        StatusButton(
                            status: status,
                            isSelected: poopStatus == status
                        ) {
                            poopStatus = status
                        }
                    }
                }
            }
            .padding(.horizontal, AppSpacing.lg)
            
            // 便便颜色
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("便便颜色")
                    .font(AppFont.bodyMedium())
                    .foregroundColor(.textSecondary)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: AppSpacing.sm) {
                    ForEach(DiaperRecord.PoopColor.allCases, id: \.self) { color in
                        PoopColorButton(
                            color: color,
                            isSelected: poopColor == color
                        ) {
                            poopColor = color
                        }
                    }
                }
            }
            .padding(.horizontal, AppSpacing.lg)
            
            // 颜色警告提示
            if let warning = poopColor.warning {
                HStack(alignment: .top, spacing: AppSpacing.sm) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.warningYellow)
                    Text(warning)
                        .font(AppFont.bodySmall())
                        .foregroundColor(.textSecondary)
                }
                .padding(AppSpacing.sm)
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(AppCornerRadius.sm)
                .padding(.horizontal, AppSpacing.lg)
            }
        }
    }
    
    // MARK: - Helper Functions
    private func saveRecord() {
        // TODO: 保存记录到数据库
        print("Save diaper record")
        print("Type: \(diaperType.displayName)")
        print("Record time: \(recordTime)")
        
        if diaperType == .pee || diaperType == .both {
            print("Pee color: \(peeColor.displayName)")
        }
        
        if diaperType == .poop || diaperType == .both {
            print("Poop status: \(poopStatus.displayName)")
            print("Poop color: \(poopColor.displayName)")
        }
        
        if !notes.isEmpty {
            print("Notes: \(notes)")
        }
    }
}

// MARK: - Diaper Type Button
struct DiaperTypeButton: View {
    let type: DiaperRecord.DiaperType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.xs) {
                Text(type.emoji)
                    .font(.system(size: 28))
                Text(type.displayName)
                    .font(AppFont.bodySmall())
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.sm)
            .background(isSelected ? Color.primaryPinkBackground : Color.white)
            .foregroundColor(isSelected ? .primaryPink : .textSecondary)
            .cornerRadius(AppCornerRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.md)
                    .stroke(isSelected ? Color.primaryPink : Color.borderGray, lineWidth: isSelected ? 2 : 1)
            )
        }
    }
}

// MARK: - Status Button
struct StatusButton: View {
    let status: DiaperRecord.Status
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(status.displayName)
                .font(AppFont.bodyMedium())
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppSpacing.sm)
                .background(isSelected ? Color.primaryPinkBackground : Color.white)
                .foregroundColor(isSelected ? .primaryPink : .textSecondary)
                .cornerRadius(AppCornerRadius.md)
                .overlay(
                    RoundedRectangle(cornerRadius: AppCornerRadius.md)
                        .stroke(isSelected ? Color.primaryPink : Color.borderGray, lineWidth: isSelected ? 2 : 1)
                )
        }
    }
}

// MARK: - Pee Color Button
struct PeeColorButton: View {
    let color: DiaperRecord.PeeColor
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.xs) {
                Text(color.emoji)
                    .font(.system(size: 24))
                Text(color.displayName)
                    .font(AppFont.caption())
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.sm)
            .background(isSelected ? Color.blue.opacity(0.1) : Color.white)
            .foregroundColor(isSelected ? .blue : .textPrimary)
            .cornerRadius(AppCornerRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.md)
                    .stroke(isSelected ? Color.blue : Color.borderGray, lineWidth: isSelected ? 2 : 1)
            )
        }
    }
}

// MARK: - Poop Color Button
struct PoopColorButton: View {
    let color: DiaperRecord.PoopColor
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.xs) {
                Text(color.emoji)
                    .font(.system(size: 24))
                Text(color.displayName)
                    .font(AppFont.caption())
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.sm)
            .background(isSelected ? Color.primaryPinkBackground : Color.white)
            .foregroundColor(isSelected ? .primaryPink : .textPrimary)
            .cornerRadius(AppCornerRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.md)
                    .stroke(isSelected ? Color.primaryPink : Color.borderGray, lineWidth: isSelected ? 2 : 1)
            )
        }
    }
}

#Preview {
    DiaperRecordSheet()
}
