//
//  DataImporter.swift
//  CoreDataNotesApp
//
//  Created by Code Pro on 8/11/19.
//  Copyright © 2019 Code Pro. All rights reserved.
//

import Foundation

struct DataImporter {

    // MARK: - Properties

    enum ImportError: Error {
        case openingFileFailed
        case parseFailed
        case savingDataFailed
    }

    typealias DataImportHandler = (ImportError?) -> Void

    enum ResourceConstant {
        static let preloadedDataFileName = "preloaded-folders"
        static let playlistKey = "playlist"
        static let songKey = "songs"
        static let lengthKey = "length"
        static let titleKey = "title"
        static let albumKey = "album"
        static let songAddedDate = "addedDate"
        static let playlistCreationDate = "creationDate"
        static let dateFormat = "MM-dd-YYYY"
        static let artistKey = "artist"
        static let importCompletedKey = "previousDataImport"
    }

    private let persistenceCoordinator: PersistenceCoordinator
    private let preloadedFileName: String

    // MARK: - Init

    /// Configures a new instance of `DataImporter` with the necessary
    /// dependencies.
    /// - Parameter persistenceCoordinator: The persistence coordinator use for
    /// data importing.
    /// - Parameter preloadedFileName: The name of the file to import data from.
    init(persistenceCoordinator: PersistenceCoordinator, preloadedFileName: String) {
        self.persistenceCoordinator = persistenceCoordinator
        self.preloadedFileName = preloadedFileName
    }
}

// MARK: - Public APIs

extension DataImporter {

    // MARK: - Import Data Management

    /// Indicates if data has been previously imported.
    public func hasCompletedLocalDataImport() -> Bool {
        return UserDefaults.standard.bool(forKey: ResourceConstant.importCompletedKey)
    }

    /// Imports preloaded data from the specified file into a `CoreData` .sqlite
    /// cache.
    /// - Parameter completionHandler: A handler that calls back when the import
    /// has finished.
    public func importPreloadedData(completionHandler: DataImportHandler?) {
        if let preloadedFileUrl = Bundle.main.url(forResource: preloadedFileName, withExtension: "json"),
            let jsonData = try? Data(contentsOf: preloadedFileUrl),
            let preloadedFolders = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any] {
            print(preloadedFolders)

            if let playlists = preloadedFolders[ResourceConstant.playlistKey] as? [[String: Any]] {
                importPlaylist(from: playlists,
                              usingCoordinator: persistenceCoordinator,
                              completionHandler: completionHandler)
            } else {
                completionHandler?(.parseFailed)
            }

        } else {
            completionHandler?(.openingFileFailed)
        }
    }

}

// MARK: -  Private APIs

private extension DataImporter {

    // MARK: - Import Management

    private func importPlaylist(from playlist: [[String: Any]],
                               usingCoordinator persistenceCoordinator: PersistenceCoordinator,
                               completionHandler: DataImportHandler?) {

        let importContext = persistenceCoordinator.privateContext

        importContext.perform {

            for playlistDict in playlist {

                let playlist = Playlist(context: importContext)
                playlist.title = playlistDict[ResourceConstant.titleKey] as? String

                let dateFormater = DateFormatter()
                dateFormater.dateFormat = ResourceConstant.dateFormat

                if let createdDate = playlistDict[ResourceConstant.playlistCreationDate] as? String {
                    playlist.creationDate = dateFormater.date(from: createdDate)
                }

                if let songs = playlistDict[ResourceConstant.songKey] as? [[String: Any]] {

                    for songDict in songs {

                        let song = Song(context: importContext)
                        song.title = songDict[ResourceConstant.titleKey] as? String
                        song.album = songDict[ResourceConstant.albumKey] as? String
                        song.artist = songDict[ResourceConstant.artistKey] as? String
                        song.length = songDict[ResourceConstant.lengthKey] as? String
                        
                        if let songAddedDate = songDict[ResourceConstant.songAddedDate] as? String {
                            song.dateAdded = dateFormater.date(from: songAddedDate)
                        }
                        
                        playlist.addToSongs(song)
                    }
                }
            }

            //Save all the changes in the context.
            persistenceCoordinator.saveChanges(in: importContext, completionHandler: { saveError in
                if let saveError = saveError {
                    print("Failed to save the imported folders: \(saveError.localizedDescription)")
                    completionHandler?(.savingDataFailed)
                } else {

                    //Indicate that we have successfully imported the data.
                    UserDefaults.standard.set(true, forKey: ResourceConstant.importCompletedKey)

                    //Successful import
                    completionHandler?(nil)
                }
            })
        }
    }
}


