import Foundation

public enum SupportPromptScheduler {
  static let launchCountKey = "supportPromptLaunchCount"
  static let lastShownDateKey = "supportPromptLastShownDate"

  /// Increments the launch counter and returns true if the support prompt should be shown.
  /// Call once on every app launch — separately from `AppReviewRequester.trackLaunch`.
  @MainActor
  public static func trackLaunchAndShouldShow(isSupporter: Bool) -> Bool {
    let defaults = UserDefaults.standard
    let count = defaults.integer(forKey: launchCountKey) + 1
    defaults.set(count, forKey: launchCountKey)
    return shouldShow(
      count: count,
      isSupporter: isSupporter,
      lastShownDate: defaults.object(forKey: lastShownDateKey) as? Date
    )
  }

  /// Records that the prompt was shown so it isn't re-shown for the cooldown window.
  @MainActor
  public static func markShown() {
    UserDefaults.standard.set(Date.now, forKey: lastShownDateKey)
  }

  /// Pure function — exposed internal for unit tests via @testable import.
  static func shouldShow(count: Int, isSupporter: Bool, lastShownDate: Date?, now: Date = .now) -> Bool {
    if isSupporter { return false }
    guard count > 15 else { return false }
    guard let last = lastShownDate else { return true }
    let cutoff = Calendar.current.date(byAdding: .month, value: -4, to: now)!
    return last < cutoff
  }
}
