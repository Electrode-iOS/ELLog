# Shrubbery
Let's not beat around the bush, we need a logging solution but we don't want to write our own, so put Cocoa Lumberjack behind the fence of a good shrubbery

Shrubbery is the codename for THGLog.

# Using Shrubbery

Shrubbery comes set up to be used with modulo (https://github.com/setdirection/modulo). Modulo will pull down Cocoa Lumberjacks for you and install it. If your parent project uses modulo, then there is no chance that Cocoa Lumberjack will be installed twice.

You do not need to clone this repository if you simply want to use Shrubbery

We recommend the following steps to install Shrubbery:

* Install modulo
	* Check out https://github.com/setdirection/modulo
	* build
	* modulo is located in ~/modulo for now
* In the root directory of your project:
	* ~/modulo init
	* This creates modulo.spec
* Add Shrubbery to your project:
	* ~/modulo add git@github.com:TheHolyGrail/Shrubbery.git
	* This command will:
		* Add Shrubbery as a git submodule and check it out into modules/Shrubbery
		* Add CocoaLumberjack as a git submodule and check it out into modules/CocoaLumberjack

* Add the project modules/Shrubbery/THGLog.xcodeproj to a "modules" group within your project.  Do *not* add CocoaLumberJack to your project.
* In your target's Build Phases -> Target Dependencies, add THGLog
* In your target's Build Phases -> Link Binary With Libraries, add libTHGlog.a
* In your target's Build Settings -> User Header Search Paths, add modules/Shrubbery
* You should now be able to #import "THGLog.h" and have it autocomplete