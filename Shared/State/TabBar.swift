//
//  TabBar.swift
//  Suwatte (iOS)
//
//  Created by Mantton on 2022-02-28.
//

import Foundation
import SwiftUI

enum AppTabs: Int, CaseIterable {
    case downloads, feed, more, library, browse, history

    var id: Int {
        hashValue
    }

    @ViewBuilder
    func view() -> some View {
        switch self {
        case .downloads:
            DownloadsView()
                .protectContent()

        case .feed:
            NavigationView {
                UpdateFeedView()
            }
            .protectContent()
            .navigationViewStyle(.stack)

        case .more:
            MoreView()
        case .library:
            LibraryView()
        case .browse:
            BrowseView()
        case .history:
            NavigationView {
                HistoryView()
            }
            .protectContent()
            .navigationViewStyle(.stack)
        }
    }

    func label() -> String {
        switch self {
        case .downloads:
            return "Download Queue"
        case .feed:
            return "Feed"
        case .more:
            return "More"
        case .library:
            return "Library"
        case .browse:
            return "Browse"
        case .history:
            return "History"
        }
    }

    func systemImage() -> String {
        switch self {
        case .downloads:
            return "square.and.arrow.down"
        case .feed:
            let hasNotifs = UIApplication.shared.applicationIconBadgeNumber > 0
            return hasNotifs ? "bell.badge" : "bell"
        case .more:
            return "ellipsis.circle"
        case .library:
            return "books.vertical"
        case .browse:
            return "safari"
        case .history:
            return "clock"
        }
    }

    static var defaultSettings: [AppTabs] = [.library, .feed, .history, .browse, .more]
}
