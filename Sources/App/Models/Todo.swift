import FluentMySQL
import Vapor

final class Todo: Codable {
    var id: Int?
    var title: String
    
    init(id: Int? = nil, title: String) {
        self.id = id
        self.title = title
    }
}

extension Todo: MySQLModel {}
extension Todo: Content {}
extension Todo: Migration {}
extension Todo: Parameter {}
