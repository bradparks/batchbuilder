package;

import ru.stablex.ui.UIBuilder;


/**
* Simple demo project for StablexUI
*/
class Init{

    static public function main () : Void{
      UIBuilder.regClass('BuildProjectItem');
      UIBuilder.regClass('WidgetEx');
      UIBuilder.regClass('ColorWidget');
      
      //create xml-based classes for custom widgets
      UIBuilder.createClass("ui/buildProjectItemUi.xml", "BuildProjectItemUi");
      
      UIBuilder.createClass("ui/coolListItem.xml", "CoolListItem");

      //register main class to access it's methods and properties in xml
      UIBuilder.regClass('Main');
  
      //initialize StablexUI
      //UIBuilder.saveCodeTo('/tmp/stablex');
  
      UIBuilder.init('ui/android/defaults.xml');
  
      //register skins
      UIBuilder.regSkins('ui/android/skins.xml');
  
      //create callback for alert popup
      Main.alert = UIBuilder.buildFn('ui/alert.xml');

      //Run application
      Main.main();

    }//function main()


    /**
    * constructor
    *
    */
    public function new() : Void {
    }//function new()



}//class Init


