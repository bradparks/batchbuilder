package;

import nme.events.MouseEvent;
import ru.stablex.ui.widgets.Widget;
import cpp.vm.Thread;
using WidgetUtils;

class BuildProjectItem extends BuildProjectItemUi
{
  public var builder: ProjectBuilder;
  public var project (getProject,setProject) : String;
  public var active (getActive,setActive) : Bool;
  public var buildOp: String;
  public var buildTarget: String;
  private var _active: Bool;
  private var imgIdle = "ui/android/img/idle.png";
  private var imgBuilding = "ui/android/img/processing.png";
  private var imgBuilt = "ui/android/img/success.gif";
  private var imgError = "ui/android/img/error.png";

  public function new()
  {
    super();

    builder = new ProjectBuilder();
    builder.owner = this;
    _active = false;
    
    bindOnClick(onProjectClicked);
  }

  public function clearBuild()
  {
     builder.clear();
     refreshBuild();
  }

  public function kill()
  {
     builder.kill();
     refreshBuild();
  }

  private function getProject(): String
  {
    return btn.text;
  }

  private function setProject(value:String):String
  {
    btn.text = value;
    
    return btn.text;
  }

  private function getActive(): Bool
  {
    return _active;
  }

  private function setActive(value:Bool):Bool
  {
    if (value)
    {
      //color = Std.random(0xFFFFFF);
      //red color = F03037
      //green color = 02AB1E
      color = 0x02AB1E;
    }
    else
    {
      color =  0x000000;
    }
    refresh();
  
    _active = value;
    
    return _active;
  }

  public function onProjectClicked(e:MouseEvent)
  {
    //processClick();
  }
  
  public function processClick()
  {
    try
    {
      active = true;
      Sys.sleep(.25);
      
      if (refreshBuild())
      {
        builder.processProject(project, buildOp, buildTarget);
        active = false;
        return true;
      }
    }
    catch(e:String)
    {
    }
    
    active = false;
    
    return false;
  }
  
  public function resetBuild()
  {
    img.src = imgIdle;
    status.text = "not built";
    
    img.refresh();
  }
  
  public function refreshBuild()
  {
    var txt;
    var shouldBuild = false;
    
    img.src = imgBuilt;
    
    if (builder.building)
    {
      img.src = imgBuilding;
      txt = "Building....";
    }
    else if (builder.hasError())
    {
      img.src = imgError;
      txt = builder.error;
    }
    else if (builder.wasBuilt())
    {
      if (builder.hasOutput())
      {
        txt = builder.stdout;
      }
      else
      {
        txt = "Successful Build. No errors.";
      }
    }
    else
    {
      txt = "not built";
      shouldBuild = true;
      img.src = imgIdle;
    }

    status.text = txt;
    img.refresh();
    
    return shouldBuild;
  }
}
