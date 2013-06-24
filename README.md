Batch Builder
============

BatchBuilder - Build multiple OpenFL Projects using a SIMPLE GUI

A PRE PRE Alpha tool to build multiple OpenFL projects using a GUI. This isn't ready for any serious use at all, yet....

Currently targets Neko and CPP builds, and has only been built on a mac.

To specify the projects to build, either edit the "projects.txt" file, or cd into the dir that you want to run tests from, and launch the executable from there.

Notes: If you try it, you'll see it's definitely not there yet.... The big thing it needs is a common dialog for browsing for the folder to select.... I'm planning on doing that sometime soon.....

My personal TODO's are:

- Dialog for selecting target folder
- Cleanup of UI so "in progress" builds look nicer
- Ensure build processes can be killed easily. Kind of working now, but needs more checks.
- Scroll projects list as the active build changes

After that, I plan on allowing multiple configurations to be setup and saved, so you could say:

- build all projects using flixel 1.09, and OpenFL 
- build all projects using flixel 1.08 and OpenFL 
- Summarize results for both of the above builds.

This would be "generic" in the sense that it just used "haxelib list" behind the scenes to get an configure the targets and active library versions, and would allow any lib to be specified in the configuration.

So definitely not done, but in progress ;-)

