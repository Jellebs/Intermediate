//
//  PlaylistVC.swift
//  myFavoriteSongs
//
//  Created by Jesper Bertelsen on 08/04/2021.
//

import UIKit
import CoreData

class PlaylistVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playlistNameLbl: UILabel!
    @IBOutlet weak var playlistDescLbl: UILabel!
    @IBOutlet weak var playlistCreationDateLbl: UILabel!
    @IBOutlet weak var playlistHeaderImg: UIImageView!
    
    
    private var _persistenceCoordinator: PersistenceCoordinator?
    private var _playlistManagedObjectID: NSManagedObjectID?
    private var _playlist: Playlist?
    
    var persistenceCoordinator: PersistenceCoordinator? {
        return _persistenceCoordinator
    }
    var playlistManagedObjectID: NSManagedObjectID? {
        return _playlistManagedObjectID
    }
    var playlist: Playlist? {
        return _playlist
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSongs()
        configureTable()
        configureInterface()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    func configureTable() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    func configureInterface() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewSongTapped)
        )
        let backItem = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.left.fill"), landscapeImagePhone: nil, style: .done, target: self, action: #selector(dismissPlaylistVC)
        )
        backItem.tintColor = LÆKKER_LIMEGRØN
        addItem.tintColor = LÆKKER_LIMEGRØN
        
        navigationItem.leftBarButtonItem = backItem
        navigationItem.rightBarButtonItem = addItem
        
        
        if let creationDate = playlist?.creationDate {
            playlistCreationDateLbl.text = "Created the \(StartVC.dateformatter.string(from: creationDate))"
        } else {
            playlistCreationDateLbl.text = ""
        }
        playlistNameLbl.text = playlist?.title
        playlistDescLbl.text = playlist?.headerDescription
        playlistHeaderImg.image = UIImage(named: playlist?.headerImg ?? "1")
        
        
    }
    func loadSongs() {
        if let persistenceCoordinator = _persistenceCoordinator, let playlistID = _playlistManagedObjectID, let playlist = persistenceCoordinator.fetchContext.object(with: playlistID) as? Playlist {
            self._playlist = playlist
            //henter objektet med samme manageobjectID. Her er det playlisten.Sangene kan nu findes ud fra self.playlist
        }
    }
    @objc func dismissPlaylistVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func createNewSongTapped() {
        createOrUpdateSong(existingSong: nil)
    }
    func createOrUpdateSong(existingSong: Song?) {
        if let storyboard = self.storyboard,
           let persistenceCoordinator = _persistenceCoordinator,
           let playlist = _playlist,
           let createSongVC = CreateSongVC.constructCreateSongVC(
                                        with: playlist,
                                        persistenceCoordinator: persistenceCoordinator,
                                        existingSong: existingSong,
                                        from: storyboard) {
            present(createSongVC, animated: true, completion: nil)
        }
    }
    
    func deleteSong(song: Song, indexPath: IndexPath) {
        _playlist?.removeFromSongs(song)
        if let songContext = song.managedObjectContext {
            _persistenceCoordinator?.saveChanges(in:
                                            songContext) { [weak self] deleteError in
                DispatchQueue.main.async {
                    self?.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
    static func constructPlaylistVC(with managedObjectID: NSManagedObjectID, persistenceCoordinator: PersistenceCoordinator, from storyBoard: UIStoryboard) -> PlaylistVC? {
        let playlistVC = storyBoard.instantiateViewController(withIdentifier: String(describing: PlaylistVC.self)) as? PlaylistVC
        playlistVC?._persistenceCoordinator = persistenceCoordinator
        playlistVC?._playlistManagedObjectID = managedObjectID
        return playlistVC
        //En statisk funktion laves, så playlistVC altid kan bygges inden, at den bliver initialized. Her laves ViewControlleren inden, at den er blevet loadet.
    }
}

extension PlaylistVC: UITableViewDelegate, UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let songs = playlist?.songs?.allObjects as? [Song] {
            deleteSong(song: songs[indexPath.row], indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let songs = playlist?.songs?.allObjects as? [Song] {
            createOrUpdateSong(existingSong: songs[indexPath.row])
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist?.songs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SongCell.identifier) as? SongCell
        if let songs = playlist?.songs?.allObjects as? [Song]{
            let song = songs[indexPath.row]
            
            if let songDate = song.dateAdded {
                cell?.configureCell(
                    title: song.title,
                    artist: song.artist,
                    album: song.album,
                    dateAdded: StartVC.dateformatter.string(from: songDate),
                    songLength: song.length ?? ""
                )
                
            }
        }
        return cell!
    }
}
