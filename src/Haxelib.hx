package;

import sys.io.Process;

class Haxelib 
{
  static public function list(lib_name:String)
  {
    var p = new Process("haxelib", ["list", lib_name]);

    var result = EzUtils.getAsLines(p.stdout.readAll().toString());

    return result;
  }
}
