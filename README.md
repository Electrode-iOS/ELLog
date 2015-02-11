# Shrubbery
Let's not beat around the bush, we need a logging solution but we don't want to write our own, so put Cocoa Lumberjack behind the fence of a good shrubbery

Shrubbery is the codename for THGLog.

# Using Shrubbery

Shrubbery comes set up to be used with modulo (https://github.com/setdirection/modulo). Modulo will pull down Cocoa Lumberjacks for you and install it. If your parent project uses modulo, then there is no chance that Cocoa Lumberjack will be installed twice.

You do not need to clone this repository if you simply want to use Shrubbery

We recommend the following steps to install Shrubbery:

* In the root directory of your project:
	* modulo init
	* This creates modulo.spec
* Change the dependencies path:
	* edit modulo.spec and change the value of "dependenciesPath" from "dependencies" to "modules"
* Add Shrubbery to your project:
	* modulo add git@github.com:TheHolyGrail/Shrubbery.git

The modulo command will:
	* Add Shrubbery as a git submodule and check it out into modules/Shrubbery
	* Add CocoaLumberjack as a git submodule and check it out into modules/CocoaLumberjack

