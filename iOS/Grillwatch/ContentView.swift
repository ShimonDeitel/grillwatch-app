import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showingAdd = false
    @State private var showingSettings = false
    @State private var showingPaywall = false
    @State private var editingEntry: GrillEntry?

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                List {
                    ForEach(store.entries) { entry in
                        Button {
                            editingEntry = entry
                        } label: {
                            EntryRow(entry: entry)
                        }
                        .accessibilityIdentifier("entryRow_\(entry.grillName)")
                    }
                    .onDelete { offsets in
                        store.delete(at: offsets)
                    }
                    .listRowBackground(Theme.cardBackground)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Grillwatch")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAddMore {
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("addButton")
                }
            }
            .sheet(isPresented: $showingAdd) {
                EntryFormView(entry: nil) { newEntry in
                    store.add(newEntry)
                }
            }
            .sheet(item: $editingEntry) { entry in
                EntryFormView(entry: entry) { updated in
                    store.update(updated)
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
        }
    }
}

struct EntryRow: View {
    let entry: GrillEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.grillName).font(Theme.bodyFont).fontWeight(.semibold)
            Text(entry.lastCleaned).font(Theme.captionFont).foregroundStyle(.secondary)
            if !entry.notes.isEmpty {
                Text(entry.notes).font(Theme.captionFont).foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct EntryFormView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var grillName: String
    @State private var lastCleaned: String
    @State private var tankLevel: String
    @State private var notes: String
    @FocusState private var focusedField: Field?
    private enum Field { case f1, f2, f3, f4 }

    let existing: GrillEntry?
    let onSave: (GrillEntry) -> Void

    init(entry: GrillEntry?, onSave: @escaping (GrillEntry) -> Void) {
        self.existing = entry
        self.onSave = onSave
        _grillName = State(initialValue: entry?.grillName ?? "")
        _lastCleaned = State(initialValue: entry?.lastCleaned ?? "")
        _tankLevel = State(initialValue: entry?.tankLevel ?? "")
        _notes = State(initialValue: entry?.notes ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Grillname", text: $grillName)
                        .focused($focusedField, equals: .f1)
                        .accessibilityIdentifier("field_grillName")
                    TextField("Lastcleaned", text: $lastCleaned)
                        .focused($focusedField, equals: .f2)
                        .accessibilityIdentifier("field_lastCleaned")
                    TextField("Tanklevel", text: $tankLevel)
                        .focused($focusedField, equals: .f3)
                        .accessibilityIdentifier("field_tankLevel")
                    TextField("Notes", text: $notes)
                        .focused($focusedField, equals: .f4)
                        .accessibilityIdentifier("field_notes")
                }
            }
            .scrollDismissesKeyboard(.immediately)
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = nil
            }
            .navigationTitle(existing == nil ? "New Grill" : "Edit Grill")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("cancelButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let entry = GrillEntry(
                            id: existing?.id ?? UUID(),
                            grillName: grillName,
                            lastCleaned: lastCleaned,
                            tankLevel: tankLevel,
                            notes: notes,
                            createdAt: existing?.createdAt ?? Date()
                        )
                        onSave(entry)
                        dismiss()
                    }
                    .disabled(grillName.isEmpty)
                    .accessibilityIdentifier("saveButton")
                }
            }
        }
    }
}
