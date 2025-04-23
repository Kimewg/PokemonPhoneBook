import Foundation

struct Pokemon: Codable {
    var sprites: Sprites
}

struct Sprites: Codable {
    var frontDefault: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
