//
//  CountryListTableViewCell.swift
//  CountryInfoApp
//
//  Created by Shravan Gundawar on 19/05/24.
//

import UIKit

class CountryListTableViewCell: UITableViewCell {

    //MARK: IBOutlets
    @IBOutlet weak var cellBackView: UIView!
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    
    //MARK: Properties
    private var flagURL: URL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: Methods
    func setupUI() {
        cellBackView.layer.cornerRadius = 20
        cellBackView.layer.borderWidth = 1.0
        cellBackView.layer.borderColor = UIColor.black.cgColor
        cellBackView.clipsToBounds = true
        cellBackView.backgroundColor = #colorLiteral(red: 0.8446564078, green: 0.5145705342, blue: 1, alpha: 0.5)
        
        
        setFont(label: capitalLabel, size: 12)
        setFont(label: currencyLabel, size: 12)
        setFont(label: populationLabel, size: 12)
    }
    
    func setFont(label: UILabel, size: Int) {
        label.font = UIFont.systemFont(ofSize: CGFloat(size))
    }
    
    func setImage(with country: CountryDataModel, viewModel: CountryListViewModel) {
           nameLabel.text = country.name
           countryImageView.image = nil // Reset image to avoid flickering

           if let flagURLString = URL(string: country.media.flag) {
               flagURL = flagURLString
               viewModel.loadImage(from: flagURLString) { [weak self] image in
                   guard let self = self else { return }
                   DispatchQueue.main.async {
                       if flagURLString == self.flagURL { // Ensure the cell hasn't been reused with a different flag URL
                           self.countryImageView.image = image
                       }
                   }
               }
           } else {
               self.countryImageView.image = UIImage(named: "PlaceholderImage")
           }
       }
    
}
