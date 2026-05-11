import Foundation
import Testing
@testable import SharedKit

@Suite("AppReviewRequester")
struct AppReviewRequesterTests {

  @Test("does not request review below 11 launches")
  func noReviewBelowThreshold() {
    #expect(!AppReviewRequester.shouldRequestReview(count: 10, lastReviewDate: nil))
    #expect(!AppReviewRequester.shouldRequestReview(count: 1, lastReviewDate: nil))
  }

  @Test("requests review on first time above threshold with no prior review")
  func firstReviewAboveThreshold() {
    #expect(AppReviewRequester.shouldRequestReview(count: 11, lastReviewDate: nil))
    #expect(AppReviewRequester.shouldRequestReview(count: 50, lastReviewDate: nil))
  }

  @Test("does not request review if last review was within 4 months")
  func suppressedWhenRecentReview() {
    let now = Date.now
    let twoMonthsAgo = Calendar.current.date(byAdding: .month, value: -2, to: now)!
    #expect(!AppReviewRequester.shouldRequestReview(count: 20, lastReviewDate: twoMonthsAgo, now: now))
  }

  @Test("requests review if last review was over 4 months ago")
  func allowedAfterCooldown() {
    let now = Date.now
    let fiveMonthsAgo = Calendar.current.date(byAdding: .month, value: -5, to: now)!
    #expect(AppReviewRequester.shouldRequestReview(count: 20, lastReviewDate: fiveMonthsAgo, now: now))
  }

  @Test("4-month boundary — exactly 4 months ago is still suppressed")
  func exactFourMonthBoundary() {
    let now = Date.now
    let exactlyFourMonthsAgo = Calendar.current.date(byAdding: .month, value: -4, to: now)!
    #expect(!AppReviewRequester.shouldRequestReview(count: 20, lastReviewDate: exactlyFourMonthsAgo, now: now))
  }
}
