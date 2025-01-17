import Foundation

struct SafeAreaInsetsHolder: Decodable {
    let top: CGFloat
    let bottom: CGFloat
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(SafeAreaInsetsHolder.self, from: data)
    }
    
    enum CodingKeys: String, CodingKey {
        case top = "safeAreaTop"
        case bottom = "safeAreaBottom"
    }
}
