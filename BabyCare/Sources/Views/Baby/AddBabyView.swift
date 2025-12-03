//
//  AddBabyView.swift
//  BabyCare
//
//  添加宝宝信息页面
//

import SwiftUI
import PhotosUI

struct AddBabyView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    var isFirstTime: Bool = false
    var editingBaby: Baby? = nil  // 如果不为空，表示编辑模式
    
    @State private var nickname: String = ""
    @State private var birthDate: Date = Date()
    @State private var gender: Baby.Gender = .male
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var headCircumference: String = ""
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var avatarImage: UIImage?
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    private var isEditMode: Bool {
        editingBaby != nil
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    // Avatar Section
                    avatarSection
                    
                    // Basic Info Section
                    basicInfoSection
                    
                    // Growth Metrics Section
                    growthMetricsSection
                    
                    // Save Button
                    saveButton
                }
                .padding(AppSpacing.md)
            }
            .background(Color.backgroundGray)
            .navigationTitle(isEditMode ? "编辑宝宝信息" : "添加宝宝信息")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                loadEditingData()
            }
            .toolbar {
                if !isFirstTime {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("取消") {
                            dismiss()
                        }
                        .foregroundColor(.textSecondary)
                    }
                }
            }
            .alert("提示", isPresented: $showingAlert) {
                Button("确定", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    // MARK: - Avatar Section
    private var avatarSection: some View {
        VStack(spacing: AppSpacing.md) {
            PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                ZStack {
                    if let avatarImage = avatarImage {
                        Image(uiImage: avatarImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(Color.primaryPinkBackground)
                            .frame(width: 100, height: 100)
                            .overlay(
                                VStack(spacing: 4) {
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 24))
                                    Text("添加头像")
                                        .font(AppFont.caption())
                                }
                                .foregroundColor(.primaryPink)
                            )
                    }
                }
            }
            .onChange(of: selectedPhotoItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        avatarImage = image
                    }
                }
            }
        }
        .padding(.top, AppSpacing.lg)
    }
    
    // MARK: - Basic Info Section
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("基础信息")
                .font(AppFont.h4())
                .foregroundColor(.textPrimary)
            
            VStack(spacing: AppSpacing.md) {
                // Nickname
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text("宝宝昵称 *")
                        .font(AppFont.bodySmall())
                        .foregroundColor(.textSecondary)
                    
                    TextField("请输入宝宝昵称", text: $nickname)
                        .textFieldStyle(CustomTextFieldStyle())
                }
                
                // Birth Date
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text("出生日期 *")
                        .font(AppFont.bodySmall())
                        .foregroundColor(.textSecondary)
                    
                    DatePicker("", selection: $birthDate, in: ...Date(), displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(AppSpacing.md)
                        .background(Color.white)
                        .cornerRadius(AppCornerRadius.sm)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppCornerRadius.sm)
                                .stroke(Color.borderColor, lineWidth: 1)
                        )
                }
                
                // Gender
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text("性别 *")
                        .font(AppFont.bodySmall())
                        .foregroundColor(.textSecondary)
                    
                    HStack(spacing: AppSpacing.md) {
                        GenderButton(
                            gender: .male,
                            isSelected: gender == .male
                        ) {
                            gender = .male
                        }
                        
                        GenderButton(
                            gender: .female,
                            isSelected: gender == .female
                        ) {
                            gender = .female
                        }
                    }
                }
            }
            .padding(AppSpacing.md)
            .background(Color.white)
            .cornerRadius(AppCornerRadius.md)
        }
    }
    
    // MARK: - Growth Metrics Section
    private var growthMetricsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("生长指标 (选填)")
                .font(AppFont.h4())
                .foregroundColor(.textPrimary)
            
            VStack(spacing: AppSpacing.md) {
                HStack(spacing: AppSpacing.md) {
                    // Height
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        Text("身高 (cm)")
                            .font(AppFont.bodySmall())
                            .foregroundColor(.textSecondary)
                        
                        TextField("65.0", text: $height)
                            .textFieldStyle(CustomTextFieldStyle())
                            .keyboardType(.decimalPad)
                    }
                    
                    // Weight
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        Text("体重 (kg)")
                            .font(AppFont.bodySmall())
                            .foregroundColor(.textSecondary)
                        
                        TextField("7.5", text: $weight)
                            .textFieldStyle(CustomTextFieldStyle())
                            .keyboardType(.decimalPad)
                    }
                }
                
                // Head Circumference
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text("头围 (cm)")
                        .font(AppFont.bodySmall())
                        .foregroundColor(.textSecondary)
                    
                    TextField("42.0", text: $headCircumference)
                        .textFieldStyle(CustomTextFieldStyle())
                        .keyboardType(.decimalPad)
                }
            }
            .padding(AppSpacing.md)
            .background(Color.white)
            .cornerRadius(AppCornerRadius.md)
        }
    }
    
    // MARK: - Save Button
    private var saveButton: some View {
        Button(action: saveBaby) {
            Text(isEditMode ? "更新" : "保存")
        }
        .buttonStyle(PrimaryButtonStyle(isEnabled: !nickname.isEmpty))
        .disabled(nickname.isEmpty)
        .padding(.top, AppSpacing.md)
    }
    
    // MARK: - Actions
    private func loadEditingData() {
        guard let baby = editingBaby else { return }
        
        nickname = baby.nickname
        birthDate = baby.birthDate
        gender = baby.gender
        height = baby.height != nil ? String(format: "%.1f", baby.height!) : ""
        weight = baby.weight != nil ? String(format: "%.1f", baby.weight!) : ""
        headCircumference = baby.headCircumference != nil ? String(format: "%.1f", baby.headCircumference!) : ""
        
        if let data = baby.avatarData, let image = UIImage(data: data) {
            avatarImage = image
        }
    }
    
    private func saveBaby() {
        guard !nickname.isEmpty else {
            alertMessage = "请输入宝宝昵称"
            showingAlert = true
            return
        }
        
        var baby: Baby
        
        if let editingBaby = editingBaby {
            // 编辑模式：保留原有ID和时间戳
            baby = Baby(
                id: editingBaby.id,
                nickname: nickname,
                birthDate: birthDate,
                gender: gender,
                avatarData: editingBaby.avatarData,
                createdAt: editingBaby.createdAt,
                updatedAt: Date()
            )
        } else {
            // 新建模式
            baby = Baby(
                nickname: nickname,
                birthDate: birthDate,
                gender: gender
            )
        }
        
        if let h = Double(height) {
            baby.height = h
        }
        if let w = Double(weight) {
            baby.weight = w
        }
        if let hc = Double(headCircumference) {
            baby.headCircumference = hc
        }
        if let image = avatarImage, let data = image.jpegData(compressionQuality: 0.8) {
            baby.avatarData = data
        }
        
        if isEditMode {
            appState.updateBaby(baby)
        } else {
            appState.addBaby(baby)
        }
        
        if isFirstTime {
            appState.completeOnboarding()
        }
        
        dismiss()
    }
}

// MARK: - Gender Button
struct GenderButton: View {
    let gender: Baby.Gender
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.xs) {
                Text(gender.emoji)
                    .font(.system(size: 32))
                Text(gender.displayName)
                    .font(AppFont.bodyMedium())
                    .foregroundColor(isSelected ? .primaryPink : .textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(AppSpacing.md)
            .background(isSelected ? Color.primaryPinkBackground : Color.backgroundGray)
            .cornerRadius(AppCornerRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.md)
                    .stroke(isSelected ? Color.primaryPink : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Custom TextField Style
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(AppSpacing.md)
            .background(Color.white)
            .cornerRadius(AppCornerRadius.sm)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.sm)
                    .stroke(Color.borderColor, lineWidth: 1)
            )
    }
}

#Preview {
    AddBabyView(isFirstTime: true)
        .environmentObject(AppState())
}
