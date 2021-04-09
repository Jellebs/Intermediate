//
//  CreateSongVC.swift
//  myFavoriteSongs
//
//  Created by Jesper Bertelsen on 08/04/2021.
//

import UIKit

class CreateSongVC: UIViewController {

    @IBOutlet weak var titleLbl: UINavigationBar!
    @IBOutlet weak var songTitle: UITextField!
    @IBOutlet weak var albumTitle: UITextField!
    @IBOutlet weak var artistName: UITextField!
    @IBOutlet weak var songLength: UITextField!
    
    var existingSong: Song?
    var persistenceCoordinator: PersistenceCoordinator!
    var parentPlaylist: Playlist!
    var placeholderText: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        songTitle.attributedPlaceholder = setPlaceholderColor(UITextField: songTitle,
                                                              placeHolderText: "Enter song title")
        albumTitle.attributedPlaceholder = setPlaceholderColor(UITextField: albumTitle,
                                                               placeHolderText: "Enter album title")
        artistName.attributedPlaceholder = setPlaceholderColor(UITextField: artistName, placeHolderText: "Enter artist name")
        songLength.attributedPlaceholder = setPlaceholderColor(UITextField: songLength, placeHolderText: "Enter song length like so: 00:00, minutes:seconds")
        configure()
        // Do any additional setup after loading the view.
    }
    
    func configure() {
        songTitle.delegate = self
        albumTitle.delegate = self
        artistName.delegate = self
        songLength.delegate = self
        if let existingSong = existingSong {
            songTitle.text = existingSong.title
            albumTitle.text = existingSong.album
            artistName.text = existingSong.artist
            songLength.text = existingSong.length
        }
    }
    
    func setPlaceholderColor(UITextField: UITextField, placeHolderText: String) -> NSAttributedString {
        let placeHolder = NSAttributedString(string: "\(placeHolderText)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        return placeHolder
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        dismissCreateSongVC()
    }
    @IBAction func saveBtnPressed(_ sender: Any) {
        saveSong(with: songTitle.text, album: albumTitle.text, artist: artistName.text, songLength: songLength.text)
    }
    
    func saveSong(with title: String?, album: String?, artist: String?, songLength: String?) {
        //update existingNotes
        if let existingSongContext = existingSong?.managedObjectContext {
            existingSong?.title = title
            existingSong?.album = album
            existingSong?.artist = artist
            existingSong?.length = songLength
            persistenceCoordinator?.saveChanges(
                in: existingSongContext) { [weak self] updateError in
                if updateError != nil {
                    print(
                        "Failed to save new song to playlist at: \(String(describing: updateError?.localizedDescription))"
                    )
                }
                DispatchQueue.main.async {
                    self?.dismissCreateSongVC()
                }
            }
        } else if let parentPlaylistContext = parentPlaylist?.managedObjectContext {
            let song = Song(context: parentPlaylistContext)
            song.title = title
            song.album = album
            song.artist = artist
            song.length = songLength
            song.dateAdded = Date()
            parentPlaylist.addToSongs(song)
            persistenceCoordinator?.saveChanges(
                in: parentPlaylistContext) { [weak self] saveError in
                if saveError != nil {
                    print(
                        "Failed to save new song to playlist at: \(String(describing: saveError?.localizedDescription))"
                    )
                }
                DispatchQueue.main.async {
                    self?.dismissCreateSongVC()
                }
            }
        }
    }
    func dismissCreateSongVC() {
        dismiss(animated: true, completion: nil)
    }

    static func constructCreateSongVC(
        with parentPlaylist: Playlist,
        persistenceCoordinator: PersistenceCoordinator,
        existingSong: Song?,
        from storyBoard: UIStoryboard) -> CreateSongVC? {
        let createSongVC = storyBoard.instantiateViewController(withIdentifier: String(describing: CreateSongVC.self)
        ) as? CreateSongVC
        createSongVC?.persistenceCoordinator = persistenceCoordinator
        createSongVC?.parentPlaylist = parentPlaylist
        createSongVC?.existingSong = existingSong
        createSongVC?.modalPresentationStyle = .fullScreen
        return createSongVC
    }
}

extension CreateSongVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == songTitle {
            albumTitle.becomeFirstResponder()
        }
        if textField == albumTitle {
            artistName.becomeFirstResponder()
        }
        if textField == artistName {
            songLength.becomeFirstResponder()
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        placeholderText = textField.placeholder
        textField.placeholder = ""
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.placeholder = placeholderText
    }
}
