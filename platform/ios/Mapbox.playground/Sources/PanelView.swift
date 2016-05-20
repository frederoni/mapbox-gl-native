import Foundation
import UIKit

public protocol PanelViewDelegate {
    func didSwitchPitch(sender: UISwitch)
}

public class PanelView : UIView {
    
    public var deleteMarkerSwitchView: UISwitch?
    public var hideMarkerSwitchView: UISwitch?
    public var pitchSwitchView: UISwitch?
    public var delegate: PanelViewDelegate?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        
        let switchPosY = bounds.width - bounds.width / 2.0 as CGFloat
        
        // Delete markers
        let deleteSwitchLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        deleteSwitchLabel.adjustsFontSizeToFitWidth = true
        deleteSwitchLabel.text = "Delete Markers"
        deleteMarkerSwitchView = UISwitch(frame: CGRect(x: switchPosY, y:0, width: 100, height: 50))
        addSubview(deleteSwitchLabel)
        addSubview(deleteMarkerSwitchView!)
        
        // Hide markers
        let hideSwitchLabel = UILabel(frame: CGRect(x: 0, y: 30, width: 100, height: 30))
        hideSwitchLabel.adjustsFontSizeToFitWidth = true
        hideSwitchLabel.text = "Hide Markers"
        hideMarkerSwitchView = UISwitch(frame: CGRect(x: switchPosY, y: 30, width: 100, height: 50))
        addSubview(hideSwitchLabel)
        addSubview(hideMarkerSwitchView!)
        
        // Pitch map
        let pitchLabel = UILabel(frame: CGRect(x: 0, y: 60, width: 100, height: 30))
        pitchLabel.text = "Pitch"
        let pitchSwitch = UISwitch(frame: CGRect(x: switchPosY, y: 60, width: 100, height: 50))
        pitchSwitch.addTarget(self, action: #selector(didSwitchPitch(_:)), forControlEvents: .ValueChanged)
        addSubview(pitchLabel)
        addSubview(pitchSwitch)
    }
    
    func didSwitchPitch(sender: UISwitch) {
        delegate?.didSwitchPitch(sender)
    }
    
    /*
     let zoomPanel = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
     zoomPanel.alpha = 0.8
     zoomPanel.backgroundColor = UIColor.whiteColor()
     
     let zoomOutButton = UIButton(type: .System)
     zoomOutButton.setTitle("-", forState: .Normal)
     zoomOutButton.sizeToFit()
     
     let zoomInButton = UIButton(type: .System)
     zoomInButton.backgroundColor = UIColor.blackColor()
     zoomInButton.setTitle("+", forState: .Normal)
     zoomInButton.sizeToFit()
     
     panel.addSubview(zoomOutButton)
     panel.addSubview(zoomInButton)
     */
}
