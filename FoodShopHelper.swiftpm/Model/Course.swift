import SwiftUI

struct Course: Identifiable, Hashable, Codable {
    var id = UUID()
    var course :[Recipe]
}
