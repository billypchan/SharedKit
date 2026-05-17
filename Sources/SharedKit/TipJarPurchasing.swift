import Foundation

public enum TipJarTier: String, CaseIterable, Sendable {
  case oneTime
  case monthly
  case yearly
}

@MainActor
public protocol TipJarPurchasing: ObservableObject {
  var isSupporter: Bool { get }
  var isPurchasing: Bool { get }
  var purchaseError: String? { get }
  func displayPrice(for tier: TipJarTier) -> String?
  func purchase(_ tier: TipJarTier) async
  func restore() async
}
