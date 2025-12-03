//
//  FoodRecordSheet.swift
//  BabyCare
//
//  辅食记录弹框 - 支持预设选项和自定义输入
//

import SwiftUI

struct FoodRecordSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedFoods: Set<CommonFood> = []
    @State private var customFood: String = ""
    @State private var showingCustomInput: Bool = false
    @State private var recordTime: Date = Date()  // 记录时间
    @State private var notes: String = ""
    
    let foodCategories: [String: [CommonFood]] = {
        var dict: [String: [CommonFood]] = [:]
        for food in CommonFood.allCases {
            if dict[food.category] == nil {
                dict[food.category] = []
            }
            dict[food.category]?.append(food)
        }
        return dict
    }()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    // Emoji Header
                    Text("🥣")
                        .font(.system(size: 60))
                        .padding(.top, AppSpacing.lg)
                    
                    Text("记录辅食")
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
                    
                    // 选中的辅食
                    if !selectedFoods.isEmpty || !customFood.isEmpty {
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("已选择")
                                .font(AppFont.bodyMedium())
                                .foregroundColor(.textSecondary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: AppSpacing.sm) {
                                    ForEach(Array(selectedFoods), id: \.self) { food in
                                        SelectedFoodTag(
                                            text: food.displayName,
                                            emoji: food.emoji
                                        ) {
                                            selectedFoods.remove(food)
                                        }
                                    }
                                    
                                    if !customFood.isEmpty {
                                        SelectedFoodTag(
                                            text: customFood,
                                            emoji: "🍽️"
                                        ) {
                                            customFood = ""
                                        }
                                    }
                                }
                                .padding(.horizontal, AppSpacing.lg)
                            }
                        }
                    }
                    
                    Divider()
                        .padding(.horizontal, AppSpacing.lg)
                    
                    // 常见辅食选项
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        Text("常见辅食")
                            .font(AppFont.h4())
                            .foregroundColor(.textPrimary)
                            .padding(.horizontal, AppSpacing.lg)
                        
                        ForEach(Array(foodCategories.keys.sorted()), id: \.self) { category in
                            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                                Text(category)
                                    .font(AppFont.bodyMedium())
                                    .foregroundColor(.textSecondary)
                                    .padding(.horizontal, AppSpacing.lg)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: AppSpacing.sm) {
                                        ForEach(foodCategories[category] ?? [], id: \.self) { food in
                                            FoodOptionButton(
                                                food: food,
                                                isSelected: selectedFoods.contains(food)
                                            ) {
                                                if selectedFoods.contains(food) {
                                                    selectedFoods.remove(food)
                                                } else {
                                                    selectedFoods.insert(food)
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal, AppSpacing.lg)
                                }
                            }
                        }
                    }
                    
                    // 自定义输入
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        HStack {
                            Text("自定义辅食")
                                .font(AppFont.bodyMedium())
                                .foregroundColor(.textSecondary)
                            
                            Spacer()
                            
                            Button {
                                showingCustomInput.toggle()
                            } label: {
                                Image(systemName: showingCustomInput ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        
                        if showingCustomInput {
                            VStack(spacing: AppSpacing.sm) {
                                TextField("输入辅食名称", text: $customFood)
                                    .textFieldStyle(.roundedBorder)
                                    .padding(.horizontal, AppSpacing.lg)
                            }
                        }
                    }
                    
                    Divider()
                        .padding(.horizontal, AppSpacing.lg)
                    
                    // 备注
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("备注")
                            .font(AppFont.bodyMedium())
                            .foregroundColor(.textSecondary)
                        
                        TextField("添加备注（如接受度、过敏情况等）...", text: $notes, axis: .vertical)
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
                    .disabled(selectedFoods.isEmpty && customFood.isEmpty)
                }
            }
        }
    }
    
    private func saveRecord() {
        // TODO: 保存记录到数据库
        print("Save food record")
        print("Selected foods: \(selectedFoods.map { $0.displayName }.joined(separator: ", "))")
        if !customFood.isEmpty {
            print("Custom food: \(customFood)")
        }
        if !notes.isEmpty {
            print("Notes: \(notes)")
        }
    }
}

// MARK: - Food Option Button
struct FoodOptionButton: View {
    let food: CommonFood
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.xs) {
                Text(food.emoji)
                    .font(.system(size: 28))
                Text(food.displayName)
                    .font(AppFont.caption())
            }
            .frame(width: 70, height: 70)
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

// MARK: - Selected Food Tag
struct SelectedFoodTag: View {
    let text: String
    let emoji: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: AppSpacing.xs) {
            Text(emoji)
            Text(text)
                .font(AppFont.bodySmall())
            
            Button {
                onRemove()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.textTertiary)
            }
        }
        .padding(.horizontal, AppSpacing.sm)
        .padding(.vertical, AppSpacing.xs)
        .background(Color.primaryPinkBackground)
        .foregroundColor(.primaryPink)
        .cornerRadius(AppCornerRadius.sm)
    }
}

#Preview {
    FoodRecordSheet()
}
