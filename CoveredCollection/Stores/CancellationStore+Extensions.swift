import Foundation

// Placeholder home for the cancel-flow mutations that will land on UserProfileStore.
// Move these into UserProfileStore.swift when implementing.

extension UserProfileStore {
    func pauseSubscription(days: Int) {}

    func cancelSubscription(reason: CancellationReason) {}

    func applyCoreDowngrade() {}

    func resumeSubscription() {}

    func recordCounterOfferAccepted(_ offer: CounterOffer) {}
}
