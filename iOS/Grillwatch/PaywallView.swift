import SwiftUI

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var purchases: PurchaseManager

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                VStack(spacing: 20) {
                    Image(systemName: "star.circle.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(Theme.accent)
                    Text("Grillwatch Pro")
                        .font(Theme.titleFont)
                    Text("Multi-grill tracking plus part replacement history")
                        .font(Theme.bodyFont)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                    if let product = purchases.product {
                        Text("\(product.displayPrice) one-time")
                            .font(Theme.captionFont)
                            .foregroundStyle(.secondary)
                    }
                    Button {
                        Task {
                            await purchases.purchase()
                            if purchases.isPro { dismiss() }
                        }
                    } label: {
                        Text("Unlock Pro")
                            .font(Theme.bodyFont.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.accent)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .accessibilityIdentifier("unlockProButton")
                    .padding(.horizontal)
                    Button("Not now") { dismiss() }
                        .accessibilityIdentifier("dismissPaywallButton")
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .accessibilityIdentifier("closePaywallButton")
                }
            }
        }
    }
}
