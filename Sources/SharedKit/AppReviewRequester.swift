import StoreKit

public enum AppReviewRequester {
  static let launchCountKey = "launchCount"
  static let lastReviewDateKey = "lastReviewDate"

  /// Increments the launch counter and triggers a review prompt if thresholds are met.
  /// Call once on every app launch.
  @MainActor
  public static func trackLaunch() async {
    let defaults = UserDefaults.standard
    let count = defaults.integer(forKey: launchCountKey) + 1
    defaults.set(count, forKey: launchCountKey)
    guard shouldRequestReview(count: count, lastReviewDate: defaults.object(forKey: lastReviewDateKey) as? Date) else { return }
    await requestReviewScene()
  }

  /// Requests a review immediately, bypassing launch count and date thresholds.
  /// Call from the "Rate this App" button.
  @MainActor
  public static func requestReview() async {
    await requestReviewScene()
  }

  // MARK: - Internal

  /// Pure function — exposed internal for unit tests via @testable import.
  static func shouldRequestReview(count: Int, lastReviewDate: Date?, now: Date = .now) -> Bool {
    guard count > 10 else { return false }
    guard let lastDate = lastReviewDate else { return true }
    let cutoff = Calendar.current.date(byAdding: .month, value: -4, to: now)!
    return lastDate < cutoff
  }

  @MainActor
  private static func requestReviewScene() async {
#if os(iOS)
    guard let scene = UIApplication.shared.connectedScenes
      .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
    else { return }
    await AppStore.requestReview(in: scene)
    UserDefaults.standard.set(Date.now, forKey: lastReviewDateKey)
#endif
  }
}
