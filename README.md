Batch Builder
============

BatchBuilder - Build multiple NME Projects using a SIMPLE GUI

A PRE PRE Alpha tool to build multiple NME projects using a GUI. This isn't ready for any serious use at all, yet....

Currently targets CPP builds, and has only been built using MonoDevelop on a mac.

It's so alpha that you need to edit code to specify the folder to search for NMML files to build ;-)

Edit src/Main.xh and change the following path to the path with your NMML files in it.

      var folder = "/Users/Brad/haxedemos/official_clean";
      
Notes: If you try it, you'll see it's definitely not there yet.... The big thing it needs is a common dialog for browsing for the folder to select.... I'm planning on doing that sometime soon.....

My personal TODO's are:

- Dialog for selecting target folder
- Cleanup of UI so "in progress" builds look nicer
- Ensure build processes can be killed easily. Kind of working now, but needs more checks.
- Scroll projects list as the active build changes

After that, I plan on allowing multiple configurations to be setup and saved, so you could say:

- build all projects using flixel 1.09, and NME 3.5.5
- build all projets using flixel 1.08 and NME 3.5.5
- Summarize results for both of the above builds.

This would be "generic" in the sense that it just used "haxelib list" behind the scenes to get an configure the targets and active library versions, and would allow any lib to be specified in the configuration.

So definitely not done, but in progress ;-)

