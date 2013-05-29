package;

import nme.events.MouseEvent;
import ru.stablex.ui.widgets.Widget;
import ru.stablex.ui.widgets.Box;
import ru.stablex.ui.widgets.Checkbox;

class WidgetUtils 
{
  public static function removeChildren(w:Box)
  {
     w.freeChildren();
  }
  
  public static function getChildAtIndexAs(w:Box, index:Int) 
  {
      var c = w.getChildAt(index);
      return cast c;
      //return ( Std.is(w, cls) ? cast w : null );
  }
  
  public static function selectAll(w:Box, checkboxName:String)
  {
    var cb = function(item) { return true; };

    selectItemsEx(w, checkboxName, cb);
  }
  
  public static function bindOnClick(obj:Widget, onBtnClick:MouseEvent->Void) : MouseEvent->Void 
  {
    obj.clearEvent(MouseEvent.CLICK);
    obj.addEventListener(MouseEvent.CLICK, onBtnClick);

    return onBtnClick;
  }

  public static function selectNone(w:Box, checkboxName:String)
  {
    var cb = function(item) { return false; };

    selectItemsEx(w, checkboxName, cb);
  }
  
  public static function selectUsingCallback(w:Box, checkboxName:String, cb:Dynamic)
  {
    selectItemsEx(w, checkboxName, cb);
  }
  
  public static function selectItemsEx(w:Box, checkboxName:String, cb:Dynamic)
  {
    for (i in 0 ... w.numChildren)
    {
      var project:Widget = getChildAtIndexAs(w, i);
      var check = cast(project.getChild(checkboxName), Checkbox);
      check.selected = cb(project);
    }
  }
  
  public static function selectItems(w:Box, checkboxName:String, state:Bool)
  {
    for (i in 0 ... w.numChildren)
    {
      var project:Widget = getChildAtIndexAs(w, i);
      var check = cast(project.getChild(checkboxName), Checkbox);
      check.selected = state;
    }
  }
}
