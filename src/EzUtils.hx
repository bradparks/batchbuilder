package;

import sys.io.Process;

class EzUtils 
{
  static public function isDefined(obj)
  {
    return ! isMissing(obj);
  }

  static public function appFile(filename)
  {
    return Sys.executablePath() + "/" + filename;
    //return "/Users/Brad/haxedemos/batchbuilder/" + filename;
  }
  
  
  static public function matches(value:String, pattern:String)
  {
     var r : EReg = new EReg(pattern, "");
     return r.match(value);
  }
  
  static public function findFilesInFolder(folder:String, filePattern:String, recursive:Bool)
  {
    var result = [];
    
    doFindFilesInFolder(folder, filePattern, recursive, result);
    
    return result;
  }
  
  static public function doFindFilesInFolder(folder:String, filePattern:String, recursive:Bool, results)
  {
    var files = sys.FileSystem.readDirectory(folder);
    
    for (ff in files)
    {
      var path = folder + "/" + ff;
     
      if (matches(path, filePattern))
      {
        results.push(path);
      } 
      
      if (recursive && sys.FileSystem.isDirectory(path)) 
      {
        doFindFilesInFolder(path, filePattern, recursive, results);
      }
      else
      {
        //trace("file:" + path);
      }
    }
  }
  
  static public function isMissing(obj)
  {
    if (obj == null)
      return true;

    var aStr = obj + "";

    if (StringTools.trim(aStr) == "")
      return true;
    
    return false;
  }

  // Recursively delete everything reachable from the path. 
  // Silently ignores nonexisting paths. 
  public static function unlink( path : String ) : Void 
  { 
#if !flash
    if (sys.FileSystem.exists(path) ) 
    { 
      if (sys.FileSystem.isDirectory(path) ) 
      { 
        for (entry in sys.FileSystem.readDirectory(path) ) 
        { 
          unlink (path + "/" + entry ); 
        } 
        sys.FileSystem.deleteDirectory(path); 
      } 
      else 
      { 
        sys.FileSystem.deleteFile(path); 
      } 
    } 
#end
  } 

  static function nvl(data:Dynamic, defaultValue:String)
  {
    if (data == null)
      return defaultValue;
    if (data == "")
      return defaultValue;

    return data;
  }

  static public function getAsLines(text:String)
  {
    var data = nvl(text, "");
    var result = data.split("\n");
    return result;
  }

  static public function replace(subject, searchFor, replaceWith)
  {
    return StringTools.replace(subject, searchFor, replaceWith);
  }

  static public function fullPath(folder:String, filename:String)
  {
    return folder + "/" + filename;
  }

  static public function ensureFoldersExist(filename:String)
  {
#if !flash
      if (sys.FileSystem.exists(filename))
      {
        return;
      }

      var folders = filename.split("/");
      var currPath = "/";

      for (i in 0...folders.length-1)
      {
        var folder = folders[i];
        if (isMissing(folder))
          continue;

        currPath += folder + "/";

        if (sys.FileSystem.exists(currPath))
          continue;

        //trace("create folder:" + currPath);
        sys.FileSystem.createDirectory(currPath);
      }
#end
  }

  static public function getUid():Float
  {
    return Date.now().getTime();
  }
}
