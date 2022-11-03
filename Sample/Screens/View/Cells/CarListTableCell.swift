//
//  CarListTableCell.swift
//  BellTechnical
//
//  Created by Ritu on 2022-09-01.
//

import UIKit

class CarListTableCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var stackVwRating: UIStackView!
    @IBOutlet weak var stackVwCons: UIStackView!
    @IBOutlet weak var stackVwPros: UIStackView!
    @IBOutlet weak var stackVwExpanded: UIStackView!
    @IBOutlet weak var lblCarPrice: UILabel!
    @IBOutlet weak var lblCarName: UILabel!
    @IBOutlet weak var imgVwCar: UIImageView!

    //MARK: - Variables
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    var expandedCell = Int.max

    //MARK: - Set Data in Cells
    var cellViewModel: CarListTableCellViewModel? {
        didSet {
            if let value = cellViewModel?.lblCarName as? String{
                lblCarName.text = value
            }
            if let value = cellViewModel?.lblCarPrice as? Double{
                lblCarPrice.text = "Price : \(String(describing: value))"
            }
            if let image = cellViewModel?.imgVwCar as? UIImage{
                imgVwCar.image = image
            }
            
            //Setting the rating view
            if let value = cellViewModel?.rating as? Int{
                for _ in (0..<value){
                    let imgStar:StarImage = StarImage()
                    imgStar.draw(CGRect())
                    
                    let imageViewWidthConstraint = NSLayoutConstraint(item: imgStar, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
                    let imageViewHeightConstraint = NSLayoutConstraint(item: imgStar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
                    imgStar.addConstraints([imageViewWidthConstraint, imageViewHeightConstraint])

                    stackVwRating.addArrangedSubview(imgStar)
                }
            }
            
            //Setting the expanded Cell view
            if let value = cellViewModel?.expandedCell as? Int{
                if value != Int.max{
                    if cellViewModel?.arrPros.count ?? 0 > 0 {
                        stackVwPros.isHidden = false
                        if let pros = cellViewModel?.arrPros as? [String]{
                            for item in pros{
                                let lblToAdd = UILabel()
                                lblToAdd.text = item
                                lblToAdd.textColor = UIColor.black
                                stackVwPros.addArrangedSubview(lblToAdd)
                            }
                        }
                     }else{
                         stackVwPros.isHidden = true
                     }
                 
                    if cellViewModel?.arrCons.count ?? 0 > 0 {
                         stackVwCons.isHidden = false
                        if let cons = cellViewModel?.arrCons as? [String]{
                            for item in cons{
                                let lblToAdd = UILabel()
                                lblToAdd.text = item
                                lblToAdd.textColor = UIColor.black
                                stackVwCons.addArrangedSubview(lblToAdd)
                            }
                        }
                     }else{
                         stackVwCons.isHidden = true
                     }
                     stackVwExpanded.isHidden = false
             
                 }else{
                     stackVwPros.isHidden = true
                     stackVwCons.isHidden = true
                     stackVwExpanded.isHidden = true
                 }
            }
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initView() {
        // Cell view customization
        backgroundColor = .clear
        
        // Line separator full width
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        lblCarPrice.text = nil
        lblCarName.text = nil
        imgVwCar.image = nil
        expandedCell = Int.max
        
        //Remove all subviews
        for item in stackVwPros.arrangedSubviews{
            if let lbl = item as? UILabel{
                if lbl.text != "Pros :"{
                    item.removeFromSuperview()
                }
            }
        }
        
        for item in stackVwCons.arrangedSubviews{
            if let lbl = item as? UILabel{
                if lbl.text != "Cons :"{
                    item.removeFromSuperview()
                }
            }
        }
        
        for item in stackVwRating.arrangedSubviews{
            if let _ = item as? UIImageView{
                item.removeFromSuperview()
            }
        }
    }

}
