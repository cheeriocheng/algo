import AVFoundation

public class Chirp: NSObject {
    // MARK: - Constants
    private let kDefaultExtension = "wav"
    
    // MARK: - Singleton
    public static let sharedManager = Chirp()
    
    // MARK: - Private Variables
    private var soundIDs = [String:SystemSoundID]()
    
    // MARK: - Public
    public func prepareSound(#fileName: String) -> SystemSoundID? {
        let fixedSoundFileName = self.fixedSoundFileName(fileName: fileName)
        if let soundID = soundIDForKey(fixedSoundFileName) {
            return soundID
        }
        
        if let pathURL = pathURLForSound(fileName: fixedSoundFileName) {
            var soundID: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(pathURL, &soundID)
            soundIDs[fixedSoundFileName] = soundID
            return soundID
        }
        
        return nil
    }
    
    public func playSound(#fileName: String) {
        let fixedSoundFileName = self.fixedSoundFileName(fileName: fileName)
        var soundID = soundIDForKey(fixedSoundFileName) ?? prepareSound(fileName: fileName)
        if soundID != nil {
            AudioServicesPlaySystemSound(soundID!)
        }
    }
    
    public func removeSound(#fileName: String) {
        let fixedSoundFileName = self.fixedSoundFileName(fileName: fileName)
        if let soundID = soundIDForKey(fixedSoundFileName) {
            AudioServicesDisposeSystemSoundID(soundID)
            soundIDs.removeValueForKey(fixedSoundFileName)
        }
    }
    
    // MARK: - Private
    private func soundIDForKey(key: String) -> SystemSoundID? {
        return soundIDs[key]
    }
    
    private func fixedSoundFileName(#fileName: String) -> String {
        var fixedSoundFileName = fileName.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
        var soundFileComponents = fixedSoundFileName.componentsSeparatedByString(".")
        if soundFileComponents.count == 1 {
            fixedSoundFileName = "\(soundFileComponents[0]).\(kDefaultExtension)"
        }
        return fixedSoundFileName
    }
    
    private func pathForSound(#fileName: String) -> String? {
        let fixedSoundFileName = self.fixedSoundFileName(fileName: fileName)
        let components = fixedSoundFileName.componentsSeparatedByString(".")
        return NSBundle.mainBundle().pathForResource(components[0], ofType: components[1])
    }
    
    private func pathURLForSound(#fileName: String) -> NSURL? {
        if let path = pathForSound(fileName: fileName) {
            return NSURL(fileURLWithPath: path)
        }
        return nil
    }
}
