import Foundation
import Testing
@testable import SharedKit

@Suite("SupportPromptScheduler")
struct SupportPromptSchedulerTests {

  @Test("does not show below 16 launches")
  func noPromptBelowThreshold() {
    #expect(!SupportPromptScheduler.shouldShow(count: 1, isSupporter: false, lastShownDate: nil))
    #expect(!SupportPromptScheduler.shouldShow(count: 15, isSupporter: false, lastShownDate: nil))
  }

  @Test("shows on first time above threshold with no prior shown")
  func firstPromptAboveThreshold() {
    #expect(SupportPromptScheduler.shouldShow(count: 16, isSupporter: false, lastShownDate: nil))
    #expect(SupportPromptScheduler.shouldShow(count: 100, isSupporter: false, lastShownDate: nil))
  }

  @Test("never shows for supporters")
  func neverShowsForSupporters() {
    #expect(!SupportPromptScheduler.shouldShow(count: 100, isSupporter: true, lastShownDate: nil))
    let now = Date.now
    let yearAgo = Calendar.current.date(byAdding: .year, value: -1, to: now)!
    #expect(!SupportPromptScheduler.shouldShow(count: 9999, isSupporter: true, lastShownDate: yearAgo, now: now))
  }

  @Test("suppressed within 4-month cooldown")
  func suppressedWithinCooldown() {
    let now = Date.now
    let twoMonthsAgo = Calendar.current.date(byAdding: .month, value: -2, to: now)!
    #expect(!SupportPromptScheduler.shouldShow(count: 50, isSupporter: false, lastShownDate: twoMonthsAgo, now: now))
  }

  @Test("shown again after cooldown")
  func allowedAfterCooldown() {
    let now = Date.now
    let fiveMonthsAgo = Calendar.current.date(byAdding: .month, value: -5, to: now)!
    #expect(SupportPromptScheduler.shouldShow(count: 50, isSupporter: false, lastShownDate: fiveMonthsAgo, now: now))
  }

  @Test("4-month boundary still suppressed")
  func exactFourMonthBoundary() {
    let now = Date.now
    let exactly = Calendar.current.date(byAdding: .month, value: -4, to: now)!
    #expect(!SupportPromptScheduler.shouldShow(count: 50, isSupporter: false, lastShownDate: exactly, now: now))
  }
}
