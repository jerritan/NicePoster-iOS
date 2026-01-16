import SwiftUI

// MARK: - Product Model
struct Product: Identifiable, Hashable, Equatable {
    let id = UUID()
    let name: String
    let imageName: String
    let category: String
    var price: String = ""
    
    // For mock data with URLs
    var imageURL: URL? {
        URL(string: imageName)
    }
    
    var isRemoteImage: Bool {
        imageName.hasPrefix("http")
    }
    
    // Hashable conformance - use only id
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Mock Products
struct MockProducts {
    static let items: [Product] = [
        Product(
            name: "Strawberry Cake",
            imageName: "https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=400",
            category: "Dessert"
        ),
        Product(
            name: "Rose Latte",
            imageName: "https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400",
            category: "Beverage"
        ),
        Product(
            name: "Weekend Brunch",
            imageName: "https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400",
            category: "Set Menu"
        ),
        Product(
            name: "Tiramisu",
            imageName: "https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=400",
            category: "Dessert"
        ),
        Product(
            name: "Matcha Parfait",
            imageName: "https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400",
            category: "Dessert"
        ),
        Product(
            name: "Cappuccino",
            imageName: "https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=400",
            category: "Beverage"
        )
    ]
}
