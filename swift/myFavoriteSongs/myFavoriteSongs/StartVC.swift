//
//  StartVC.swift
//  myFavoriteSongs
//
//  Created by Jesper Bertelsen on 07/04/2021.
//

import UIKit
import CoreData
import PMAlertController

class StartVC: UIViewController {

    static let dateformatter: DateFormatter = {
        let dateformatter = DateFormatter()
        dateformatter.locale = .current
        dateformatter.timeZone = .current
        dateformatter.dateFormat = "YYYY-MM-dd"
        
        return dateformatter
    } ()
    @IBOutlet weak var tableView: UITableView!
    var playlistFetchResultsController: NSFetchedResultsController<Playlist>!
    var persistenceCoordinator: PersistenceCoordinator!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Playlists"
        loadPlaylist()
        configureInterface()
        configureTable()
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSave(_:)), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func contextDidSave(_ notification: Notification) {
        persistenceCoordinator.fetchContext.mergeChanges(fromContextDidSave: notification)
    }
    
    func configureInterface() {
        
        if self.navigationController?.title != nil {
            let shadow = NSShadow()
                    shadow.shadowColor = UIColor.white
                    shadow.shadowOffset = .init(width: 0, height: 1)
                    shadow.shadowBlurRadius = 2
            let font = UIFont(name: "Helvetica neue", size: 25)
            navigationController?.navigationBar.titleTextAttributes =
                [NSAttributedString.Key.font: font!,
                 NSAttributedString.Key.shadow: shadow,
                 NSAttributedString.Key.foregroundColor: LÆKKER_LIMEGRØN]
           
            
        }
        
    }
    func configureTable() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    func loadPlaylist() {
        let playlistFetchRequest: NSFetchRequest<Playlist> = Playlist.fetchRequest()
        playlistFetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        playlistFetchResultsController = NSFetchedResultsController(
            fetchRequest: playlistFetchRequest,
            managedObjectContext: persistenceCoordinator.fetchContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        playlistFetchResultsController.delegate = self
        
        do {
            try playlistFetchResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func createNewPlaylist(_ sender: Any) {
        displayAlertView()
    }
    
    func displayAlertView() {
        
        let alertInpuntView = PMAlertController(title: "Playlist name", description: "Enter a playlist name", image: UIImage(), style: .alert)
        alertInpuntView.alertView.layer.cornerRadius = 6
        alertInpuntView.alertView.backgroundColor = UIColor.black
        let black = UIColor.black
        let noder = UIImage(systemName: "music.quarternote.3")
        alertInpuntView.alertImage.tintColor = LÆKKER_LIMEGRØN
        alertInpuntView.alertImage.image = noder
        alertInpuntView.alertImage.backgroundColor = UIColor.black
        
        
        present(alertInpuntView, animated: true, completion: nil)
        
//        let alertInputView = UIAlertController(title: "Playlist name",
//                                               message: "Enter a playlist name",
//                                               preferredStyle: .alert)
//
//        let message = NSString(string: "Enter a playlist name")
//        alertInputView.message = message.attribu
//        alertInputView.addTextField { nameTextField in
//            nameTextField.placeholder = "Enter a playlist name"
//        }
//        alertInputView.addTextField { descriptionTextField in
//            descriptionTextField.placeholder = "Enter playlist description"
//        }
//        alertInputView.addTextField { imgStringTextField in
//            imgStringTextField.placeholder = "Enter a number between 1-5"
//        }
//
//        let textFields = alertInputView.textFields
//        for textField in textFields! {
//            textField.textColor = LÆKKER_LIMEGRØN
//            textField.textInputView.tintColor = UIColor.black
//            textField.tintColor = UIColor.black
//            textField.backgroundColor = UIColor.black
//        }
//        alertInputView.addAction(UIAlertAction(title: "Cancel",
//                                               style: .cancel,
//                                               handler: nil
//                                               )
//                                )
//        alertInputView.addAction(UIAlertAction(title: "Save",
//                                               style: .default,
//                                               handler: { [weak self]  alertAction in
//                                                if let playlistName = alertInputView.textFields?.first?.text,
//                                                   let description = alertInputView.textFields?[1].text,
//                                                   let imgString = alertInputView.textFields?[2].text,
//                                                   !playlistName.isEmpty {
//
//                                                    self?.createPlaylist(playlistName: playlistName,
//                                                                         playlistDescription: description,
//                                                                         stringOf: imgString)
//                                                } else {
//                                                    print("Invalid input")
//                                                }
//                                               }
//                                              )
//                                )
//        present(alertInputView, animated: true, completion: nil)
    }
    
    
    func createPlaylist(playlistName: String, playlistDescription: String, stringOf headerImg: String) {
        let savingContext = persistenceCoordinator.fetchContext
        
        let playlist = Playlist(context: savingContext)
        playlist.title = playlistName
        playlist.creationDate = Date()
        playlist.headerDescription = playlistDescription
        playlist.headerImg = headerImg
        persistenceCoordinator.saveChanges(in: savingContext) { saveException in
            if saveException == nil {
                print("Successfully saved \(playlistName)")
            }
        }
    }
    
    func delete(playlist: Playlist) {
        persistenceCoordinator.delete(managedObjects: [playlist]) { deleteException in
            if let deleteExcception = deleteException {
                print("Failed to delete folder with error:\(deleteExcception.localizedDescription)")
            }
        }
    }
    
    
    func displaySongsForPlaylist(for playlist: Playlist) {
        if let storyboard = self.storyboard,
           let playlistVC = PlaylistVC.constructPlaylistVC(with: playlist.objectID,
                                                           persistenceCoordinator: persistenceCoordinator,
                                                           from: storyboard) {
            navigationController?.pushViewController(playlistVC, animated: true)
        }
    }
}


//MARK:-                            UITABLEVIEW

extension StartVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let playlist = playlistFetchResultsController?.object(at: indexPath) {
            displaySongsForPlaylist(for: playlist)
            //Her viderebringes parentPlaylisten fra tableviewet til logikken
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlistFetchResultsController.fetchedObjects?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistCell.identifier, for: indexPath) as? PlaylistCell
        let playlist = playlistFetchResultsController.object(at: indexPath)
        let defaultTitle = playlist.songs?.allObjects.first as? Playlist
        
        if let creationDate = playlist.creationDate, let playlistCount = playlist.songs?.allObjects.count {
            let titleDefault = String(describing: defaultTitle?.title)
            cell?.configureCell(playlistTitle: playlist.title ?? "\(titleDefault))",
                                playlistDescription: playlist.headerDescription ?? "En playlist ved navn \(String(describing: playlist.title))",
                                playlistImg: playlist.headerImg ?? "1",
                                playlistCount: "\(playlistCount) songs"
            )
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete,
           let playlist = playlistFetchResultsController?.object(at: indexPath) {
            delete(playlist: playlist)
        }
    }
}

//MARK:-                          FETCHEDRESULTSCONTROLLER

extension StartVC: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        @unknown default:
            print("The default case has been called.")
        }
    }
}


