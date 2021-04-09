//
//  Song+CoreDataProperties.swift
//  myFavoriteSongs
//
//  Created by Jesper Bertelsen on 08/04/2021.
//
//

import Foundation
import CoreData


extension Song {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Song> {
        return NSFetchRequest<Song>(entityName: "Song")
    }

    @NSManaged public var album: String?
    @NSManaged public var artist: String?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var dateRelase: Date?
    @NSManaged public var length: String?
    @NSManaged public var title: String?
    @NSManaged public var playlist: Playlist?

}

extension Song : Identifiable {

}
