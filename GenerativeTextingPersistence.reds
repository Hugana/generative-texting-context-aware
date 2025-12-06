import RedFileSystem.*
import Codeware.*
import RedData.Json.*

public class JsonReaderSystem extends ScriptableSystem {

    private let m_callbackSystem: wref<CallbackSystem>;  
    private const let MOD_STORAGE_NAME: String = "JsonReaderSystem";  
    private static let m_storage: ref<FileSystemStorage>; 
    private let m_isStorageInitialized: Bool;


    private func OnAttach() {  
        this.m_callbackSystem = GameInstance.GetCallbackSystem();  
        this.m_isStorageInitialized = false;
        this.m_callbackSystem.RegisterCallback(n"Session/Ready", this, n"OnSessionReady");  
    }  

    private func OnDetach() {  
        this.m_callbackSystem.UnregisterCallback(n"Session/Ready", this, n"OnSessionReady");  
        this.m_callbackSystem = null;  
    }  


    private func InitializeStorage() -> Bool {
        this.m_storage = FileSystem.GetStorage(this.MOD_STORAGE_NAME);
        
        if this.m_storage == null {
            FTLogError(s"InitializeStorage: FATAL ERROR: Could not retrieve unique storage '\(this.MOD_STORAGE_NAME)'. (RFS unavailable)");
            this.m_isStorageInitialized = false; 
            return false;
        } else {
            FTLog(s"Storage initialized successfully for '\(this.MOD_STORAGE_NAME)'.");
            this.m_isStorageInitialized = true; 
            return true;
        }
    }

    private cb func OnSessionReady(event: ref<GameSessionEvent>) {  
        let isPreGame = event.IsPreGame();  
        
        if isPreGame {  
            FTLog(s"is in pre game");  
            return;  
        }  
        
        if this.m_storage == null {
            FTLog(s"Storage reference is NULL. Re-attempting initialization...");
            if !this.InitializeStorage() {
                FTLogError(s"OnSessionReady: Aborting operations due to persistent storage initialization failure.");
                return;
            }
        }
        
        FTLog(s"JsonReaderSystem is ready to serve file operations (Storage Status: \(this.m_isStorageInitialized)).");
    }
    

    public static func GetJsonReaderSystem() -> ref<JsonReaderSystem> {
        return GameInstance.GetScriptableSystemsContainer(GetGameInstance()).Get(n"JsonReaderSystem") as JsonReaderSystem;
    }

    public func GetFileStorage() -> ref<FileSystemStorage> {
        return this.m_storage;
    }
    
    public func IsStorageReady() -> Bool {
        return this.m_isStorageInitialized;
    }
}