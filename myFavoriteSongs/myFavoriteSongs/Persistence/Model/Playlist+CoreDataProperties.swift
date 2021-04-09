//
//  Playlist+CoreDataProperties.swift
//  myFavoriteSongs
//
//  Created by Jesper Bertelsen on 08/04/2021.
//
//

import Foundation
import CoreData


extension Playlist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Playlist> {
        return NSFetchRequest<Playlist>(entityName: "Playlist")
    }

    @NSManaged public var creationDate: Date?
    @NSManaged public var headerDescription: String?
    @NSManaged public var headerImg: String?
    @NSManaged public var songsCount: Int16
    @NSManaged public var title: String?
    @NSManaged public var songs: NSSet?

}

// MARK: Generated accessors for songs
extension Playlist {

    @objc(addSongsObject:)
    @NSManaged public func addToSongs(_ value: Song)

    @objc(removeSongsObject:)
    @NSManaged public func removeFromSongs(_ value: Song)

    @objc(addSongs:)
    @NSManaged public func addToSongs(_ values: NSSet)

    @objc(removeSongs:)
    @NSManaged public func removeFromSongs(_ values: NSSet)

}

extension Playlist : Identifiable {

}
