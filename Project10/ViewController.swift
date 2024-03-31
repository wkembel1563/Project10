//
//  ViewController.swift
//  Project10
//
//  Created by Will Kembel on 3/28/24.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPerson))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? CollectionViewCell else {
            fatalError("Cannot dequeue CollectionViewCell")
        }
        
        let person = people[indexPath.item]
        let imageURL = documentsDirectory().appendingPathComponent(person.imageName)
        let image = UIImage(contentsOfFile: imageURL.path)
        
        // cell content
        //
        cell.imageView.image = image
        cell.labelView.text = person.name
        cell.isUserInteractionEnabled = true
        
        // formatting
        //
        cell.imageView.layer.cornerRadius = 7
        cell.imageView.clipsToBounds = true
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    @objc func addPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            fatalError("Edited image could not be cast to UIImage")
        }
        
        let imageName = UUID().uuidString
        let imageURL = documentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imageURL)
        }
        
        let person = Person(name: "Unknown", imageName: imageName)
        people.append(person)
        
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: "Rename", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default){
            [weak self, weak person, weak ac] alert in
            guard let newName = ac?.textFields?[0].text else { return }
            person?.name = newName
            self?.collectionView.reloadData()
        })
        
        present(ac, animated: true)
    }

}

