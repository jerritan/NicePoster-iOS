import SwiftUI

// MARK: - Platform Definition
enum MarketingPlatform: String, CaseIterable, Identifiable {
    case dianping = "大众点评"
    case xiaohongshu = "小红书"
    case douyin = "抖音"
    case meituan = "美团"
    case eleme = "饿了么"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .dianping: return "star.circle.fill"
        case .xiaohongshu: return "book.fill"
        case .douyin: return "play.circle.fill"
        case .meituan: return "bag.fill"
        case .eleme: return "takeoutbag.and.cup.and.straw.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .dianping: return Color(red: 1, green: 0.42, blue: 0)
        case .xiaohongshu: return Color(red: 0.99, green: 0.17, blue: 0.33)
        case .douyin: return .black
        case .meituan: return Color(red: 1, green: 0.82, blue: 0)
        case .eleme: return Color(red: 0, green: 0.59, blue: 1)
        }
    }
    
    var sizes: [AssetSize] {
        switch self {
        case .dianping:
            return [
                AssetSize(name: "入口图", ratio: "1:1", width: 800, height: 800, description: "店铺列表展示图"),
                AssetSize(name: "大图轮播", ratio: "16:9", width: 1080, height: 608, description: "店铺详情页轮播"),
                AssetSize(name: "菜品图", ratio: "4:3", width: 800, height: 600, description: "菜品展示图"),
                AssetSize(name: "团购图", ratio: "16:9", width: 1080, height: 608, description: "团购套餐展示")
            ]
        case .xiaohongshu:
            return [
                AssetSize(name: "笔记封面(方版)", ratio: "1:1", width: 1080, height: 1080, description: "适合产品展示"),
                AssetSize(name: "笔记封面(竖版)", ratio: "3:4", width: 1242, height: 1660, description: "流量首选，适合探店", isRecommended: true),
                AssetSize(name: "笔记封面(横版)", ratio: "4:3", width: 1440, height: 1080, description: "适合多图拼接"),
                AssetSize(name: "商品图", ratio: "1:1", width: 1080, height: 1080, description: "商品详情展示")
            ]
        case .douyin:
            return [
                AssetSize(name: "视频封面", ratio: "9:16", width: 1080, height: 1920, description: "竖版视频封面"),
                AssetSize(name: "团购图片", ratio: "16:9", width: 1080, height: 610, description: "团购商品图"),
                AssetSize(name: "推荐菜图片", ratio: "14:9", width: 1120, height: 720, description: "门店推荐菜"),
                AssetSize(name: "企业号头图", ratio: "16:9", width: 750, height: 422, description: "企业主页头图")
            ]
        case .meituan:
            return [
                AssetSize(name: "店铺招牌", ratio: "16:9", width: 692, height: 390, description: "店铺首页招牌"),
                AssetSize(name: "商品图片", ratio: "4:3", width: 1200, height: 900, description: "商品展示图"),
                AssetSize(name: "Banner海报", ratio: "3:1", width: 720, height: 240, description: "活动海报"),
                AssetSize(name: "门店头像", ratio: "1:1", width: 800, height: 800, description: "店铺头像")
            ]
        case .eleme:
            return [
                AssetSize(name: "顶部招牌", ratio: "16:9", width: 750, height: 560, description: "店铺顶部招牌"),
                AssetSize(name: "店铺海报", ratio: "4:1", width: 1138, height: 292, description: "店内活动海报"),
                AssetSize(name: "商品图片", ratio: "1:1", width: 640, height: 640, description: "菜品展示图"),
                AssetSize(name: "头像Logo", ratio: "1:1", width: 800, height: 800, description: "店铺Logo")
            ]
        }
    }
}

// MARK: - Asset Size
struct AssetSize: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let ratio: String
    let width: Int
    let height: Int
    let description: String
    var isRecommended: Bool = false
    
    var displaySize: String {
        "\(width)×\(height)"
    }
    
    var aspectRatio: CGFloat {
        CGFloat(width) / CGFloat(height)
    }
}

// MARK: - Export Item
struct ExportItem: Identifiable {
    let id = UUID()
    let image: GeneratedImage
    let platform: MarketingPlatform
    let size: AssetSize
    var status: ExportStatus = .pending
}

enum ExportStatus {
    case pending
    case processing
    case completed
    case failed
}
