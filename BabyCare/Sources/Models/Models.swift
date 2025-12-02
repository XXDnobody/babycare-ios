//
//  Models.swift
//  BabyCare
//
//  数据模型定义
//

import Foundation

// MARK: - Baby 宝宝档案
struct Baby: Identifiable, Codable {
    var id: UUID = UUID()
    var nickname: String
    var birthDate: Date
    var gender: Gender
    var avatarData: Data?
    
    // 生长指标
    var height: Double?  // cm
    var weight: Double?  // kg
    var headCircumference: Double?  // cm
    
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    
    enum Gender: String, Codable, CaseIterable {
        case male = "male"
        case female = "female"
        
        var displayName: String {
            switch self {
            case .male: return "男孩"
            case .female: return "女孩"
            }
        }
        
        var emoji: String {
            switch self {
            case .male: return "👦"
            case .female: return "👧"
            }
        }
    }
    
    // 计算月龄
    var ageInDays: Int {
        Calendar.current.dateComponents([.day], from: birthDate, to: Date()).day ?? 0
    }
    
    var ageInMonths: Int {
        Calendar.current.dateComponents([.month], from: birthDate, to: Date()).month ?? 0
    }
    
    var ageDescription: String {
        let months = ageInMonths
        let days = ageInDays % 30
        if months > 0 {
            return "\(months)月\(days)天"
        } else {
            return "\(days)天"
        }
    }
}

// MARK: - Report 儿保报告
struct Report: Identifiable, Codable {
    var id: UUID = UUID()
    var babyId: UUID
    var title: String
    var reportDate: Date
    var fileData: Data?
    var fileName: String?
    var fileType: FileType
    var analysisResult: AnalysisResult?
    var createdAt: Date = Date()
    
    enum FileType: String, Codable {
        case image = "image"
        case pdf = "pdf"
    }
}

// MARK: - AI分析结果
struct AnalysisResult: Codable {
    var indicators: [HealthIndicator]
    var summary: String
    var suggestions: [String]
    var warnings: [String]
}

struct HealthIndicator: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var value: String
    var unit: String
    var status: IndicatorStatus
    var percentile: String?
    var reference: String?
    var suggestion: String?
    
    enum IndicatorStatus: String, Codable {
        case normal = "normal"
        case attention = "attention"
        case abnormal = "abnormal"
        
        var color: String {
            switch self {
            case .normal: return "green"
            case .attention: return "yellow"
            case .abnormal: return "red"
            }
        }
        
        var displayName: String {
            switch self {
            case .normal: return "正常"
            case .attention: return "关注"
            case .abnormal: return "异常"
            }
        }
    }
}

// MARK: - Schedule 日程
struct ScheduleTask: Identifiable, Codable {
    var id: UUID = UUID()
    var babyId: UUID
    var date: Date
    var scheduledTime: Date
    var taskType: TaskType
    var title: String
    var detail: String?
    var targetValue: Double?  // 目标值(奶量ml/时长min)
    var actualValue: Double?  // 实际值
    var actualTime: Date?
    var isCompleted: Bool = false
    var notes: String?
    
    enum TaskType: String, Codable, CaseIterable {
        case milk = "milk"
        case food = "food"
        case nap = "nap"
        case exercise = "exercise"
        case play = "play"
        
        var displayName: String {
            switch self {
            case .milk: return "喝奶"
            case .food: return "辅食"
            case .nap: return "小睡"
            case .exercise: return "运动"
            case .play: return "互动游戏"
            }
        }
        
        var emoji: String {
            switch self {
            case .milk: return "🍼"
            case .food: return "🥣"
            case .nap: return "😴"
            case .exercise: return "🏃"
            case .play: return "🎮"
            }
        }
        
        var unit: String {
            switch self {
            case .milk: return "ml"
            case .food: return "次"
            case .nap, .exercise, .play: return "分钟"
            }
        }
    }
}

// MARK: - DailySnapshot 日度快照
struct DailySnapshot: Identifiable, Codable {
    var id: UUID = UUID()
    var babyId: UUID
    var date: Date
    
    var milkCount: Int = 0
    var milkVolume: Int = 0  // ml
    var foodCount: Int = 0
    var napCount: Int = 0
    var napMinutes: Int = 0
    var nightWakeCount: Int = 0
    var exerciseMinutes: Int = 0
    var taskCompletionRate: Double = 0
    
    var weight: Double?  // kg
    var height: Double?  // cm
}

// MARK: - WeeklyReport 周报
struct WeeklyReport: Identifiable, Codable {
    var id: UUID = UUID()
    var babyId: UUID
    var weekStart: Date
    var weekEnd: Date
    
    var totalMilkVolume: Int = 0
    var avgDailyMilk: Int = 0
    var totalFoodCount: Int = 0
    var totalSleepMinutes: Int = 0
    var avgDailySleep: Double = 0
    var totalNightWakes: Int = 0
    var avgNightWakes: Double = 0
    var avgCompletionRate: Double = 0
    
    var aiSummary: String?
    var insights: [Insight] = []
    var milestones: [Milestone] = []
}

// MARK: - Insight 智能洞察
struct Insight: Identifiable, Codable {
    var id: UUID = UUID()
    var type: InsightType
    var title: String
    var description: String
    var suggestion: String?
    var evidence: [String] = []
    var createdAt: Date = Date()
    
    enum InsightType: String, Codable {
        case pattern = "pattern"          // 模式识别
        case anomaly = "anomaly"          // 异常检测
        case correlation = "correlation"  // 关联分析
        
        var emoji: String {
            switch self {
            case .pattern: return "🔍"
            case .anomaly: return "⚠️"
            case .correlation: return "🔗"
            }
        }
        
        var displayName: String {
            switch self {
            case .pattern: return "模式识别"
            case .anomaly: return "异常检测"
            case .correlation: return "关联分析"
            }
        }
    }
}

// MARK: - Milestone 里程碑
struct Milestone: Identifiable, Codable {
    var id: UUID = UUID()
    var babyId: UUID
    var title: String
    var description: String
    var category: Category
    var achievedDate: Date?
    var isAchieved: Bool = false
    
    enum Category: String, Codable, CaseIterable {
        case motor = "motor"           // 大运动
        case fineMotor = "fineMotor"   // 精细动作
        case language = "language"     // 语言
        case social = "social"         // 社交
        case cognitive = "cognitive"   // 认知
        
        var displayName: String {
            switch self {
            case .motor: return "大运动"
            case .fineMotor: return "精细动作"
            case .language: return "语言"
            case .social: return "社交"
            case .cognitive: return "认知"
            }
        }
        
        var emoji: String {
            switch self {
            case .motor: return "🏃"
            case .fineMotor: return "✋"
            case .language: return "🗣️"
            case .social: return "👫"
            case .cognitive: return "🧠"
            }
        }
    }
}

// MARK: - GrowthRecord 生长记录
struct GrowthRecord: Identifiable, Codable {
    var id: UUID = UUID()
    var babyId: UUID
    var date: Date
    var weight: Double?  // kg
    var height: Double?  // cm
    var headCircumference: Double?  // cm
    var notes: String?
}

// MARK: - FeedingRecord 喂养记录
struct FeedingRecord: Identifiable, Codable {
    var id: UUID = UUID()
    var babyId: UUID
    var date: Date
    var type: FeedingType
    var food: String?
    var amount: Double?
    var unit: String?
    var acceptance: Acceptance
    var isAllergic: Bool = false
    var notes: String?
    
    enum FeedingType: String, Codable {
        case breastMilk = "breastMilk"
        case formula = "formula"
        case mixed = "mixed"
        case solidFood = "solidFood"
    }
    
    enum Acceptance: String, Codable {
        case full = "full"       // 全部吃完
        case half = "half"       // 吃了一半
        case little = "little"   // 吃得很少
        case refused = "refused" // 拒绝
    }
}

// MARK: - SleepRecord 睡眠记录
struct SleepRecord: Identifiable, Codable {
    var id: UUID = UUID()
    var babyId: UUID
    var startTime: Date
    var endTime: Date?
    var type: SleepType
    var quality: SleepQuality?
    var wakeCount: Int = 0
    var notes: String?
    
    var durationMinutes: Int {
        guard let end = endTime else { return 0 }
        return Calendar.current.dateComponents([.minute], from: startTime, to: end).minute ?? 0
    }
    
    enum SleepType: String, Codable {
        case nightSleep = "nightSleep"
        case nap = "nap"
    }
    
    enum SleepQuality: String, Codable {
        case good = "good"
        case fair = "fair"
        case poor = "poor"
    }
}
