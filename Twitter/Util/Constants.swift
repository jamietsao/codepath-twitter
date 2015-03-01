//
//  Constants.swift
//  Twitter
//
//  Created by Jamie Tsao on 2/27/15.
//  Copyright (c) 2015 jamietsao. All rights reserved.
//

import Foundation

struct Constants {
    
    enum TimelineViewType {
        case Home, Mentions, User, Favorites
    }

    struct Menu {
        static let HeaderIndex = 0
        static let ProfileIndex = 1
        static let HomeIndex = 2
        static let MenuItems = [ "Header", "Profile", "Home", "Mentions", "Favorites" ]
        static let MenuViewtypes = [ TimelineViewType.Home, TimelineViewType.Mentions, TimelineViewType.Favorites ]
        static let MenuViewTypeTitle: [ TimelineViewType : String ] = [ TimelineViewType.Home : "Home", TimelineViewType.Mentions : "Mentions", TimelineViewType.Favorites : "Favorites" ]
    }
    
    struct IDs {
        static let HomeTimelineNavigationController = "HomeTimelineNavigationController"
        static let ProfileNavigationController = "ProfileNavigationController"
        static let ProfileViewController = "ProfileViewController"
        static let MenuUserCell = "MenuUserCell"
        static let MenuItemCell = "MenuItemCell"
        
    }
    
    struct ImageAssets {
    }
    
    struct Labels {
    }
    
}