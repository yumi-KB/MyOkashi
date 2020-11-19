import UIKit

struct OkashiJson: Codable {
    // お菓子の名称
    let name: String?
    // メーカー
    let maker: String?
    // 掲載URL
    let url: URL?
    // 画像URL
    let image: URL?
}
