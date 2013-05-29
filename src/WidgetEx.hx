package;

import nme.events.MouseEvent;
import ru.stablex.ui.widgets.Widget;
import ru.stablex.ui.widgets.Box;

class WidgetEx extends Widget
{
  public function OldbindOnClick(obj:Widget, onBtnClick:MouseEvent->Void) : MouseEvent->Void 
  {
    obj.clearEvent(MouseEvent.CLICK);
    obj.addEventListener(MouseEvent.CLICK, onBtnClick);

    return onBtnClick;
  }
}
