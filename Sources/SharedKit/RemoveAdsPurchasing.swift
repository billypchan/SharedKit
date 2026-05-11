import Foundation

@MainActor
public protocol RemoveAdsPurchasing: ObservableObject {
  var isPremium: Bool { get }
  var isPurchasing: Bool { get }
  var purchaseError: String? { get }
  var removeAdsProductDisplayPrice: String? { get }
  func purchase() async
  func restore() async
}
