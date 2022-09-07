import SwiftUI

struct CheckListItemMarkdownVisibility: EnvironmentKey {
    static let defaultValue: Backport<Any>.Visibility = .automatic
}

internal extension EnvironmentValues {
    var markdownCheckListItemVisibility: CheckListItemMarkdownVisibility.Value {
        get { self[CheckListItemMarkdownVisibility.self] }
        set { self[CheckListItemMarkdownVisibility.self] = newValue }
    }
}

public extension View {
    func markdownCheckListItem(_ visibility: Backport<Any>.Visibility) -> some View {
        environment(\.markdownCheckListItemVisibility, visibility)
    }
}

struct CheckListItemBulletMarkdownVisibility: EnvironmentKey {
    static let defaultValue: Backport<Any>.Visibility = .automatic
}

internal extension EnvironmentValues {
    var markdownCheckListItemBulletVisibility: CheckListItemBulletMarkdownVisibility.Value {
        get { self[CheckListItemBulletMarkdownVisibility.self] }
        set { self[CheckListItemBulletMarkdownVisibility.self] = newValue }
    }
}

public extension View {
    func markdownCheckListItemBullet(_ visibility: Backport<Any>.Visibility) -> some View {
        environment(\.markdownCheckListItemBulletVisibility, visibility)
    }
}
