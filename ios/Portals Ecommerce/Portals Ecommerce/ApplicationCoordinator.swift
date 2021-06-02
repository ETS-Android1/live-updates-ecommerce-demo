import UIKit

protocol ApplicationCoordinationParticipant: AnyObject {
    var coordinator: ApplicationCoordinator? { get set }
}

@objc class ApplicationCoordinator: NSObject, UINavigationControllerDelegate {
    let imageLoader = ImageLoader()
    private(set) var products: [Product]
    private(set) var user: User
    private(set) var cart: Cart
    
    override init() {
        products = ApplicationCoordinator.generatedProducts()
        user = ApplicationCoordinator.generatedUser()
        cart = Cart()
        
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            let url = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: url)
                let demo = try JSONDecoder().decode(DemoData.self, from: data)
                products = demo.products
                user = demo.user
            }
            catch {
                assertionFailure("Failed to load demo JSON")
            }
        }
    }
    
    // MARK: - UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let participant = viewController as? ApplicationCoordinationParticipant {
            participant.coordinator = self
        }
    }
}

private extension ApplicationCoordinator {
    private static func generatedProducts() -> [Product] {
        var list: [Product] = []
        for i in 1...20 {
            list.append(Product(id: i,
                                title: "Product \(i)",
                                description: "Some awesome details.",
                                price: Int.random(in: 1...45),
                                imageName: "product\(i)_image",
                                category: ((i % 3) == 0) ? .mustHaves : .recommended))
        }
        return list
    }
    
    private static func generatedUser() -> User {
        return User(id: 100,
                    firstName: "Test",
                    lastName: "McTestington",
                    email: "hello@ionic.io",
                    imageName: "user_image",
                    addresses: [
                        Address(id: 200,
                                street: "123 Main",
                                city: "Anytown",
                                state: "WI",
                                postalCode: "12345",
                                isPreferred: true)
                    ],
                    creditCards: [
                        CreditCard(id: 300,
                                   company: "Visa",
                                   number: "",
                                   expiration:
                                    "12/31/2024",
                                   isPreferred: true)
                    ])
    }
}
