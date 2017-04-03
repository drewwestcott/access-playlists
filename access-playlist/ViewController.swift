//
//  ViewController.swift
//  access-playlist
//
//  Created by Drew Westcott on 02/04/2017.
//  Copyright © 2017 Drew Westcott. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var playlistTable: UITableView!
	@IBOutlet weak var accessError: UITextView!
	
	var mediaAvailable: Bool!
	var mediaPlayer = MPMediaLibrary()
	var availablePlaylists = [String]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		accessError.isHidden = true
		playlistTable.delegate = self
		playlistTable.dataSource = self
		
		checkMediaAccess()
		if mediaAvailable {
			displayPlaylists()
		}
	
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func checkMediaAccess() {
	
		let mediaAccess = MPMediaLibrary.authorizationStatus()
		switch (mediaAccess) {
		case MPMediaLibraryAuthorizationStatus.authorized:
				print("Media Access has been given")
			mediaAvailable = true
		case MPMediaLibraryAuthorizationStatus.denied, MPMediaLibraryAuthorizationStatus.restricted:
				print("Unable to access your media library, we will not be able to play music for you.")
				accessError.isHidden = false
		case MPMediaLibraryAuthorizationStatus.notDetermined:
				MPMediaLibrary.requestAuthorization({ (MPMediaLibraryAuthorizationStatus) in
					print("Requesting Access")
				})
		}
		
	}
	
	func displayPlaylists() {
		
		let myPlaylistQuery = MPMediaQuery.playlists()
		let playlists = myPlaylistQuery.collections
		
		for playlist in playlists! {
			let playlistFound = playlist.value(forProperty: MPMediaPlaylistPropertyName)!
			
			print(playlistFound)
			availablePlaylists.append(playlistFound as! String)
		}
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		
		return 1
		
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return availablePlaylists.count
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = playlistTable.dequeueReusableCell(withIdentifier: "playlistCell", for: indexPath) as! PlaylistCell
		cell.playlistName.text = availablePlaylists[indexPath.row]
		return cell
	}

}

