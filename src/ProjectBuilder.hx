package; 

import sys.io.Process;

using StringTools;

class ProjectBuilder 
{
  public var error:String;
  public var stdout:String;
  public var building: Bool;
  public var lastBuild: Date;
  public var owner:BuildProjectItem;
  public var p:Process;

  public function new()
  {
    building = false;
  }

  public function out(msg:String)
  {
    trace(msg);
  }

  public function wasBuilt()
  {
    return lastBuild != null;
  }

  public function clear()
  {
    error = "";
    stdout  = "";
    lastBuild = null;
  }
  
  public function kill()
  {
     clear();
     p.kill();
  }
  
  public function processProject(projectFolderName:String, buildOp:String, target:String)
  {
    if (projectFolderName == "")
      return false;
      
    if (building)
      return false;

    var nmmlFile = projectFile(projectFolderName);

    building = true;
    error = "";
    stdout  = "";
    lastBuild = Date.now();

    owner.processClick();
    try
    {
      runOpenFl(projectFolderName, "build", nmmlFile, target);
    }
    catch (e:String)
    {
      building = false;
    }
    building = false;

    owner.processClick();
    
    return success();
  }

  public function hasOutput()
  {
    return EzUtils.isDefined(stdout);
  }

  public function hasError()
  {
    return ! success();
  }

  public function success()
  {
    return EzUtils.isMissing(error);
  }

  public function projectFile(projectFolderName:String)
  {
    return projectFolderName;
  }

  public function logError(projectName:String, errorType:String, errorMsg:String, cmd:String, nmmlFile:String, target:String)
  {
    var msg = errorMsg;
    if (EzUtils.isMissing(msg))
      msg = "";

    out(projectName + ": " + errorMsg);
  }

  public function runOpenFl(projectName:String, cmd:String, nmmlFile:String, target:String)
  {
    out("Processing:" + projectName);

    trace(["openfl",cmd, nmmlFile, target]);

    p = new Process("openfl", [cmd, nmmlFile, target]);

    this.error = p.stderr.readAll().toString();
    this.stdout = p.stdout.readAll().toString();

    if (EzUtils.isDefined(this.error))
    {
      logError(projectName, "ERROR", this.error, cmd, nmmlFile, target);
    }

    if (EzUtils.isDefined(this.stdout))
    {
      logError(projectName, "STDOUT", this.stdout, cmd, nmmlFile, target);
    }

    p.close(); 
  }

  static public function getDataFileAsArray(fileName)
  {
    var result = new Array<String>();
    var txt = "";

    try
    {
      var absoluteFilename = EzUtils.appFile(fileName);
      if (! EzUtils.exists(absoluteFilename))
        return result;

      var data = sys.io.File.getContent(absoluteFilename);
      txt = EzUtils.nvl(data, "");
      result = txt.trim().split("\n");
    }
    catch(e:String)
    {
    }

    return result;
  }
}
