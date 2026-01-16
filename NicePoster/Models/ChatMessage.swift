import SwiftUI

struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    let isUser: Bool
    let content: String
    let type: MessageType
    let timestamp = Date()
    
    enum MessageType: Equatable {
        case text
        case productSelection([Product])
        case styleSelection([StyleOption])
        case advancedOptions
        case thinking
        case imageResult([GeneratedImage])
        
        static func == (lhs: MessageType, rhs: MessageType) -> Bool {
            switch (lhs, rhs) {
            case (.text, .text), (.advancedOptions, .advancedOptions), (.thinking, .thinking):
                return true
            case let (.productSelection(l), .productSelection(r)):
                return l.map(\.id) == r.map(\.id)
            case let (.styleSelection(l), .styleSelection(r)):
                return l.map(\.id) == r.map(\.id)
            case let (.imageResult(l), .imageResult(r)):
                return l.map(\.id) == r.map(\.id)
            default:
                return false
            }
        }
    }
}

// Note: Product is defined in Models/Product.swift

struct StyleOption: Identifiable, Equatable {
    let id = UUID()
    let type: StyleOptionType
    let title: String
    let subtitle: String?
    let icon: String
}

enum StyleOptionType: Equatable {
    case brandDNA
    case reference
    case ai
}

struct GeneratedImage: Identifiable, Equatable {
    let id = UUID()
    let imageName: String
    var mockColor: Color = Color.gray
    var mockIcon: String = "photo"
    
    // MARK: - Mock Data
    static let mockCartItems: [GeneratedImage] = [
        GeneratedImage(imageName: "cart_1", mockColor: Color(red: 0.3, green: 0.2, blue: 0.15), mockIcon: "flame.fill"),
        GeneratedImage(imageName: "cart_2", mockColor: Color(red: 0.15, green: 0.2, blue: 0.25), mockIcon: "leaf.fill"),
        GeneratedImage(imageName: "cart_3", mockColor: Color(red: 0.4, green: 0.2, blue: 0.3), mockIcon: "sparkles"),
        GeneratedImage(imageName: "cart_4", mockColor: Color(red: 0.2, green: 0.25, blue: 0.3), mockIcon: "star.fill"),
        GeneratedImage(imageName: "cart_5", mockColor: Color(red: 0.35, green: 0.15, blue: 0.2), mockIcon: "heart.fill"),
        GeneratedImage(imageName: "cart_6", mockColor: Color(red: 0.1, green: 0.3, blue: 0.25), mockIcon: "cup.and.saucer.fill")
    ]
}
