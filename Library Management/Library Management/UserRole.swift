import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    var email: String
    var phoneNumber: String
    var role: Role
    var isVerified: Bool = false

    enum Role: String, Codable {
        case admin
        case librarian
        case user
    }
}
