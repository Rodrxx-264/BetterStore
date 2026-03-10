import Foundation

struct AppModel: Codable, Identifiable {
    let id: Int
    let nombre: String
    let tipo: String
    let url: String
    let urlIcono: String
    let nombre_archivo: String
}
