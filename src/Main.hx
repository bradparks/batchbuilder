package;

import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.Lib;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.Button;
import ru.stablex.ui.widgets.Text;
import ru.stablex.ui.widgets.Options;
import ru.stablex.ui.events.WidgetEvent;
import nme.events.MouseEvent;
import nme.events.MouseEvent;

#if neko
import neko.vm.Thread;
#else
import cpp.vm.Thread;
#end

using WidgetUtils;

class Main extends ru.stablex.ui.widgets.Widget
{
  static public var alert : Dynamic->ru.stablex.ui.widgets.Floating;
  public var gui:Dynamic;
  public var info:ru.stablex.ui.widgets.Text;
  public var lstAllProjects:ru.stablex.ui.widgets.Box;
  public var cancelled: Bool = false;
  public var btnTarget:ru.stablex.ui.widgets.Options;

  static public function main () : Void
  {
    var m = new Main();
    
    m.createIt();
  }

  public function createIt():Void
  {
    var gui = UIBuilder.buildFn('ui/index.xml')();
    this.gui = gui;
    
    Lib.current.stage.align     = StageAlign.TOP_LEFT;
    Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;

    info = cast(gui.getChild("txt"), ru.stablex.ui.widgets.Text);
    lstAllProjects = cast(gui.getChild("lstAllProjects"), ru.stablex.ui.widgets.Box);

    var btnBuildAll = gui.getChild("btnBuildAll");
    var btnBuildSelected = gui.getChild("btnBuildSelected");
    var btnBuildFailed = gui.getChild("btnBuildFailed");
    var btnClearAll = gui.getChild("btnClearAll");
    var btnSelection = gui.getChild("btnSelection");
    var btnKill = gui.getChild("btnKill");
    btnTarget = cast(gui.getChild("btnTarget"), ru.stablex.ui.widgets.Options);
    btnBuildAll.addEventListener(MouseEvent.CLICK, onBuildAllClicked);
    btnBuildSelected.addEventListener(MouseEvent.CLICK, onBuildSelectedProjects);
    btnBuildFailed.addEventListener(MouseEvent.CLICK, onBuildFailedProjects);
    btnClearAll.addEventListener(MouseEvent.CLICK, onClearAllClicked);
    btnSelection.addEventListener(WidgetEvent.CHANGE, onBtnSelection);
    btnTarget.addEventListener(WidgetEvent.CHANGE, onBtnTarget);
    btnKill.addEventListener(MouseEvent.CLICK, onBtnKill);
    
    loadProjects();

    gui.show();
  }
  
  public function onBtnTarget(e:MouseEvent)
  {
    clearAllProjects();
  }
  
  public function onBtnSelection(e:MouseEvent)
  {
    var selection:Options = cast(gui.getChild("btnSelection"), Options);
    
    switch(selection.value) {
    case 'all':
      lstAllProjects.selectAll('check');
    case 'none':
      lstAllProjects.selectNone('check');
    case 'error':
      var cb = function(item) { return item.builder.hasError(); };
      lstAllProjects.selectItemsEx('check', cb);
    case 'invert':
      var cb = function(item) { return ! item.check.selected; };
      lstAllProjects.selectItemsEx('check', cb);
    default:
    }
    
    lstAllProjects.refresh();
  }
  
  public function buildProjects(cb:Dynamic)
  {
    var f = function(){ buildProjectsCallback(cb);};
    var thread = Thread.create(f);
    thread.sendMessage(Thread.current());
  }
  
  public function onBuildSelectedProjects(e:MouseEvent)
  {
    var cb = function(item) { return item.check.selected; };
    buildProjects(cb);
  }
  
  public function onBuildFailedProjects(e:MouseEvent)
  {
    var cb = function(item) { return item.builder.hasError(); };
    buildProjects(cb);
  }
  
  public function onBuildAllClicked(e:MouseEvent)
  {
    var cb = function(item) { return true;} ;
    buildProjects(cb);
  }
  
  public function onBtnKill(e:MouseEvent)
  {
    cancelled = true;
  }
  
  public function onClearAllClicked(e:MouseEvent)
  {
     clearAllProjects();
  }
  
  public function clearAllProjects()
  {
    var projects = this.lstAllProjects;
    
    for (i in 0...projects.numChildren)
    {
      var project:BuildProjectItem = projects.getChildAtIndexAs(i);
      project.clearBuild();
    }
  }

  public function killProjects()
  {
    var projects = this.lstAllProjects;

    for (i in 0...projects.numChildren)
    {
      var project:BuildProjectItem = projects.getChildAtIndexAs(i);
      
      project.kill();
    }
  }

  public function buildProjectsCallback(cb:Dynamic)
  {
    cancelled = false;
    
    var main = Thread.readMessage(true);
    var projects = this.lstAllProjects;
    
    for (i in 0...projects.numChildren)
    {
      var project:BuildProjectItem = projects.getChildAtIndexAs(i);
      project.resetBuild();
    }
    
    for (i in 0...projects.numChildren)
    {
      main.sendMessage(1 + 1);
      
      if (cancelled)
        return;
        
      var project:BuildProjectItem = projects.getChildAtIndexAs(i);
      project.buildOp = "build";
      project.buildTarget = btnTarget.value;
      
      if (! cb(project))
        continue;
        
      if (project.processClick())
      {
        
      }
    }
  }

  public function onInfoEvent(text:String)
  {
    info.text = text;
  }
  
  public function loadProjects()
  {
    this.lstAllProjects.removeChildren();
    
    var data = ProjectBuilder.getDataFileAsArray("projects.txt");
    if (data.length == 0)
    {
      var folder = Sys.getCwd();
      var pattern = "FlixelNME.xml$";
      data = EzUtils.findFilesInFolder(folder, pattern, true);
    }
    
    for (project in data)
    {
      var widget = UIBuilder.create(BuildProjectItem, 
        {
          btn:
          {
              text: project
          }
        }
      );
      this.lstAllProjects.addChild(widget);
    }
  }
}
