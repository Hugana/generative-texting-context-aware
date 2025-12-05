// 1. IMPORT the necessary module for file system access
import RedFileSystem.*
import Codeware.*
import RedData.Json.*
// A simple class to house the mod's logic
// A simple class to house the mod's logic

public class JsonReaderSystem extends ScriptableSystem {

    private let m_callbackSystem: wref<CallbackSystem>;  
    // Unique name required by Red File System to get the storage area [1]  
    private const let MOD_STORAGE_NAME: String = "JsonReaderSystem";  
    private const let CONFIG_FILE_NAME: String = "my_config.json";   

    /// Lifecycle ///  

    private func OnAttach() {  
        this.m_callbackSystem = GameInstance.GetCallbackSystem();  
        // Register to run checks when the game session is ready  
        this.m_callbackSystem.RegisterCallback(n"Session/Ready", this, n"OnSessionReady");  
    }  

    private func OnDetach() {  
        this.m_callbackSystem.UnregisterCallback(n"Session/Ready", this, n"OnSessionReady");  
        this.m_callbackSystem = null;  
    }  

    /// Game events ///  

    private cb func OnSessionReady(event: ref<GameSessionEvent>) {  
        // CRITICAL CHECK: Only run file I/O during the pre-game/loading phase [1]  
        let isPreGame = event.IsPreGame();  

        if isPreGame {  
            FTLog(s"is in pre game");  
            return;  
        }  
        
        FTLog(s"== Safe JSON Read Initiated (Pre-Game) ==");  
        this.ReadAndLogJson();  
        FTLog(s"== Safe JSON Read Finished ==");  
    }  

    /// JSON Reading Logic ///  

    private func ReadAndLogJson() {  
        // 1. Get the unique storage for this mod using the Red File System API [1]  
        // We use 'this.' to resolve the constant within the function [1]  
        let storage: ref<FileSystemStorage> = FileSystem.GetStorage(this.MOD_STORAGE_NAME);   
        
        if storage == null {  
            FTLogError(s"ReadAndLogJson: FATAL ERROR: Could not retrieve unique storage '\(this.MOD_STORAGE_NAME)'. Check if Red File System is installed.");   
            return;  
        }  

        // 2. Get the file handle (path is relative to the storage folder) [1]  
        let file = storage.GetFile(this.CONFIG_FILE_NAME);   
        
        if!IsDefined(file) {  
            FTLogError(s"ReadAndLogJson: Access denied or file not found: \(this.CONFIG_FILE_NAME). Ensure it is in r6/storages/\(this.MOD_STORAGE_NAME)/");   
            return;  
        }  

        // 3. Read and parse the JSON content into a JsonVariant [1]  
        let json = file.ReadAsJson();   

        // 4. Validate parsing success [1]  
        if!IsDefined(json) {  
            FTLogError(s"ReadAndLogJson: FATAL ERROR: Failed to parse JSON file: \(this.CONFIG_FILE_NAME). Check JSON syntax for errors.");   
            return;  
        }  

        

        // 5. Check the root element type (optional, but good practice) [1]  
        if!json.IsObject() {  
            FTLogError(s"ReadAndLogJson: ERROR: Root of the JSON document is not an object.");   
            return;  
        }  

        // 6. Convert the validated JsonVariant structure back into a formatted string [1]  
        let jsonContent: String = json.ToString("    ");  

        // 7. Print to log file (r6/logs/redscript_rCURRENT.log)  
        FTLog(s"----- START JSON CONTENT for \(this.CONFIG_FILE_NAME) -----");  
        FTLog(jsonContent);   
        FTLog(s"----- END JSON CONTENT -----");  

        let json = ParseJson(jsonContent) as JsonObject;  

        let modId = json.GetKeyString("mod_id");  

        FTLog(s"MODID ->'\(modId)'.");  

        json.SetKeyString("last_check_status", "RedFileSystem");  
        
        let file = storage.GetFile("data.json");  

        
        let status = file.WriteJson(json);  
        // Same as:  
        // let status = file.WriteText(json.ToString());  

        if !status {  
        FTLogError(s"Failed to write in file '\(file.GetFilename())'.");  
        } else {  
        FTLog(s"Wrote Json in file '\(file.GetFilename())'.");  
        }  
    }

}

