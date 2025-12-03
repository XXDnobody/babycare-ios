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
    
    // 出生胎龄（用于早产儿矫正月龄）
    var gestationalWeeks: Int?  // 胎龄周数
    var gestationalDays: Int?   // 胎龄天数（0-6）
    
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
        // 不包含起始日
        Calendar.current.dateComponents([.day], from: birthDate, to: Date()).day ?? 0
    }
    
    var ageInMonths: Int {
        Calendar.current.dateComponents([.month], from: birthDate, to: Date()).month ?? 0
    }
    
    var ageDescription: String {
        let calendar = Calendar.current
        
        // 获取出生日期的年月日
        let birthComponents = calendar.dateComponents([.year, .month, .day], from: birthDate)
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        
        guard let birthYear = birthComponents.year,
              let birthMonth = birthComponents.month,
              let birthDay = birthComponents.day,
              let todayYear = todayComponents.year,
              let todayMonth = todayComponents.month,
              let todayDay = todayComponents.day else {
            return "0天"
        }
        
        // 计算月数和天数（不包含起始日，从第二天开始算）
        var months = (todayYear - birthYear) * 12 + (todayMonth - birthMonth)
        var days = todayDay - birthDay  // 不加1，不包含起始日
        
        // 如果天数为负数，需要从上个月借天数
        if days < 0 {
            months -= 1
            // 获取上个月的天数
            let previousMonth = calendar.date(byAdding: .month, value: -1, to: Date()) ?? Date()
            let daysInPreviousMonth = calendar.range(of: .day, in: .month, for: previousMonth)?.count ?? 30
            days += daysInPreviousMonth
        }
        
        if months > 0 {
            if days > 0 {
                return "\(months)月\(days)天"
            } else {
                return "\(months)月"
            }
        } else {
            return "\(days)天"
        }
    }
    
    // 是否为早产儿（37周之前分娩）
    var isPremature: Bool {
        guard let weeks = gestationalWeeks else { return false }
        return weeks < 37
    }
    
    // 矫正月龄描述（用于早产儿）
    var correctedAgeDescription: String? {
        guard isPremature,
              let gestationalWeeks = gestationalWeeks else {
            return nil
        }
        
        let gestationalDays = gestationalDays ?? 0
        
        // 计算需要矫正的天数（40周 - 实际胎龄）
        let fullTermWeeks = 40
        let weeksToCorrect = fullTermWeeks - gestationalWeeks
        let daysToCorrect = (weeksToCorrect * 7) - gestationalDays
        
        // 从实际日龄中减去矫正天数
        let actualDays = ageInDays
        let correctedDays = actualDays - daysToCorrect
        
        if correctedDays <= 0 {
            return "0天"
        }
        
        // 转换为月和天
        let correctedMonths = correctedDays / 30  // 简化计算
        let remainingDays = correctedDays % 30
        
        if correctedMonths > 0 {
            if remainingDays > 0 {
                return "\(correctedMonths)月\(remainingDays)天"
            } else {
                return "\(correctedMonths)月"
            }
        } else {
            return "\(correctedDays)天"
        }
    }
    
    // 胎龄描述
    var gestationalAgeDescription: String? {
        guard let weeks = gestationalWeeks else { return nil }
        let days = gestationalDays ?? 0
        
        if days > 0 {
            return "\(weeks)周\(days)天"
        } else {
            return "\(weeks)周"
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
    var method: FeedingMethod?  // 喂养方式（亲喂/瓶装）
    var food: String?
    var amount: Double?  // ml或次数
    var unit: String?
    var startTime: Date?  // 亲喂开始时间
    var endTime: Date?    // 亲喂结束时间
    var acceptance: Acceptance
    var isAllergic: Bool = false
    var notes: String?
    
    // 喂养类型
    enum FeedingType: String, Codable, CaseIterable {
        case breastMilk = "breastMilk"  // 母乳
        case formula = "formula"        // 奶粉
        case mixed = "mixed"            // 混合喂养
        case solidFood = "solidFood"    // 辅食
        
        var displayName: String {
            switch self {
            case .breastMilk: return "母乳"
            case .formula: return "奶粉"
            case .mixed: return "混合"
            case .solidFood: return "辅食"
            }
        }
    }
    
    // 喂养方式
    enum FeedingMethod: String, Codable, CaseIterable {
        case breastfeeding = "breastfeeding"  // 亲喂
        case bottle = "bottle"                // 瓶装
        
        var displayName: String {
            switch self {
            case .breastfeeding: return "亲喂"
            case .bottle: return "瓶装"
            }
        }
        
        var emoji: String {
            switch self {
            case .breastfeeding: return "🤱"
            case .bottle: return "🍼"
            }
        }
    }
    
    // 接受度
    enum Acceptance: String, Codable {
        case full = "full"       // 全部吃完
        case half = "half"       // 吃了一半
        case little = "little"   // 吃得很少
        case refused = "refused" // 拒绝
        
        var displayName: String {
            switch self {
            case .full: return "全部吃完"
            case .half: return "吃了一半"
            case .little: return "吃得很少"
            case .refused: return "拒绝"
            }
        }
    }
    
    // 计算亲喂时长（分钟）
    var durationMinutes: Int? {
        guard let start = startTime, let end = endTime else { return nil }
        return Calendar.current.dateComponents([.minute], from: start, to: end).minute
    }
}

// MARK: - CommonFood 常见辅食选项
enum CommonFood: String, CaseIterable {
    // 谷物类
    case rice = "rice"              // 米粉
    case riceCereal = "riceCereal"  // 米糊
    case oatmeal = "oatmeal"        // 燕麦
    case noodles = "noodles"        // 面条
    
    // 蔬菜类
    case pumpkin = "pumpkin"        // 南瓜
    case carrot = "carrot"          // 胡萝卜
    case potato = "potato"          // 土豆
    case sweetPotato = "sweetPotato" // 红薯
    case broccoli = "broccoli"      // 西兰花
    case spinach = "spinach"        // 菠菜
    
    // 水果类
    case apple = "apple"            // 苹果
    case banana = "banana"          // 香蕉
    case pear = "pear"              // 梨
    case avocado = "avocado"        // 牛油果
    
    // 蛋白质类
    case egg = "egg"                // 鸡蛋
    case fish = "fish"              // 鱼肉
    case chicken = "chicken"        // 鸡肉
    case pork = "pork"              // 猪肉
    case beef = "beef"              // 牛肉
    
    var displayName: String {
        switch self {
        case .rice: return "米粉"
        case .riceCereal: return "米糊"
        case .oatmeal: return "燕麦"
        case .noodles: return "面条"
        case .pumpkin: return "南瓜"
        case .carrot: return "胡萝卜"
        case .potato: return "土豆"
        case .sweetPotato: return "红薯"
        case .broccoli: return "西兰花"
        case .spinach: return "菠菜"
        case .apple: return "苹果"
        case .banana: return "香蕉"
        case .pear: return "梨"
        case .avocado: return "牛油果"
        case .egg: return "鸡蛋"
        case .fish: return "鱼肉"
        case .chicken: return "鸡肉"
        case .pork: return "猪肉"
        case .beef: return "牛肉"
        }
    }
    
    var emoji: String {
        switch self {
        case .rice, .riceCereal: return "🍚"
        case .oatmeal: return "🥣"
        case .noodles: return "🍜"
        case .pumpkin: return "🎃"
        case .carrot: return "🥕"
        case .potato: return "🥔"
        case .sweetPotato: return "🍠"
        case .broccoli: return "🥦"
        case .spinach: return "🥬"
        case .apple: return "🍎"
        case .banana: return "🍌"
        case .pear: return "🍐"
        case .avocado: return "🥑"
        case .egg: return "🥚"
        case .fish: return "🐟"
        case .chicken: return "🍗"
        case .pork: return "🥓"
        case .beef: return "🥩"
        }
    }
    
    var category: String {
        switch self {
        case .rice, .riceCereal, .oatmeal, .noodles:
            return "谷物类"
        case .pumpkin, .carrot, .potato, .sweetPotato, .broccoli, .spinach:
            return "蔬菜类"
        case .apple, .banana, .pear, .avocado:
            return "水果类"
        case .egg, .fish, .chicken, .pork, .beef:
            return "蛋白质类"
        }
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

// MARK: - DiaperRecord 尿布记录
struct DiaperRecord: Identifiable, Codable {
    var id: UUID = UUID()
    var babyId: UUID
    var date: Date
    var type: DiaperType
    var peeStatus: Status?  // 尿尿状态
    var peeColor: PeeColor?  // 尿尿颜色
    var poopStatus: Status?  // 便便状态
    var poopColor: PoopColor?  // 便便颜色
    var notes: String?
    
    // 尿布类型
    enum DiaperType: String, Codable, CaseIterable {
        case pee = "pee"          // 尿尿
        case poop = "poop"        // 便便
        case both = "both"        // 尿尿+便便
        
        var displayName: String {
            switch self {
            case .pee: return "尿尿"
            case .poop: return "便便"
            case .both: return "尿尿+便便"
            }
        }
        
        var emoji: String {
            switch self {
            case .pee: return "💧"
            case .poop: return "💩"
            case .both: return "💧💩"
            }
        }
    }
    
    // 状态
    enum Status: String, Codable, CaseIterable {
        case normal = "normal"    // 正常
        case dry = "dry"          // 较干
        case loose = "loose"      // 较稀
        
        var displayName: String {
            switch self {
            case .normal: return "正常"
            case .dry: return "较干"
            case .loose: return "较稀"
            }
        }
    }
    
    // 尿尿颜色
    enum PeeColor: String, Codable, CaseIterable {
        case clear = "clear"              // 透明/淡黄色（正常）
        case lightYellow = "lightYellow"  // 淡黄色（正常）
        case yellow = "yellow"            // 黄色（正常）
        case darkYellow = "darkYellow"    // 深黄色（需关注）
        case orange = "orange"            // 橙色（需就医）
        case red = "red"                  // 红色/血尿（需就医）
        case brown = "brown"              // 棕色（需就医）
        
        var displayName: String {
            switch self {
            case .clear: return "透明淡黄"
            case .lightYellow: return "淡黄色"
            case .yellow: return "黄色"
            case .darkYellow: return "深黄色"
            case .orange: return "橙色"
            case .red: return "红色"
            case .brown: return "棕色"
            }
        }
        
        var emoji: String {
            switch self {
            case .clear: return "🤍"      // 白色圈
            case .lightYellow: return "🟡" // 淡黄色圈
            case .yellow: return "🟡"      // 黄色圈
            case .darkYellow: return "🟠"  // 橙黄色圈
            case .orange: return "🟠"      // 橙色圈
            case .red: return "🔴"         // 红色圈
            case .brown: return "🟤"       // 棕色圈
            }
        }
        
        var isNormal: Bool {
            switch self {
            case .clear, .lightYellow, .yellow: return true
            case .darkYellow, .orange, .red, .brown: return false
            }
        }
        
        var warning: String? {
            switch self {
            case .clear, .lightYellow, .yellow: return nil
            case .darkYellow: return "深黄色尿液可能提示饮水不足，建议多喝水"
            case .orange: return "橙色尿液可能与脱水或肝脏问题有关，建议就医"
            case .red: return "红色尿液可能含有血液，建议立即就医"
            case .brown: return "棕色尿液可能提示肝脏或胆道问题，建议立即就医"
            }
        }
    }
    
    // 便便颜色
    enum PoopColor: String, Codable, CaseIterable {
        case yellow = "yellow"          // 黄色（正常）
        case golden = "golden"          // 金黄色（正常）
        case brown = "brown"            // 棕色（正常）
        case green = "green"            // 绿色（需关注）
        case black = "black"            // 黑色（新生儿胎便或需就医）
        case white = "white"            // 白色（异常，需就医）
        case red = "red"                // 红色（可能有血，需就医）
        
        var displayName: String {
            switch self {
            case .yellow: return "黄色"
            case .golden: return "金黄色"
            case .brown: return "棕色"
            case .green: return "绿色"
            case .black: return "黑色"
            case .white: return "白色"
            case .red: return "红色"
            }
        }
        
        var emoji: String {
            switch self {
            case .yellow: return "🟡"
            case .golden: return "🟠"
            case .brown: return "🟤"
            case .green: return "🟢"
            case .black: return "⚫"
            case .white: return "⚪"
            case .red: return "🔴"
            }
        }
        
        var isNormal: Bool {
            switch self {
            case .yellow, .golden, .brown: return true
            case .green, .black, .white, .red: return false
            }
        }
        
        var warning: String? {
            switch self {
            case .yellow, .golden, .brown: return nil
            case .green: return "绿色便便可能与消化、饮食有关，持续出现建议咨询医生"
            case .black: return "黑色便便（非新生儿）可能提示消化道出血，建议就医"
            case .white: return "白色便便可能提示胆道问题，建议立即就医"
            case .red: return "红色便便可能含有血液，建议立即就医"
            }
        }
    }
}
