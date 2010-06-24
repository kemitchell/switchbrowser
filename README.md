switchbrowser
=============

CLI utility for switching the default browser in OS X

Building and Installation
-------------------------

The source is hosted on [GitHub](http://github.com/kemitchell/switchbrowser).

In the OS X terminal:

    $ git clone git://github.com/kemitchell/switchbrowser.git
    $ cd switchbrowser
	$ make
	$ ./switchbrowser

If you would like to install the binary and manpage system-wide:
	
	$ sudo make install

Usage
-----

A sample session:

    $ switchbrowser
    Usage: switchbrowser <bundle identifier or shorthand>

    Bundle Identifier                                Shorthand
    ----------------------------------------------------------
    *com.apple.safari                                safari
     com.apple.mobilesafari                       
     com.fluidapp.FluidInstance.GMail             
     com.RealNetworks.RealPlayer                  
     com.operasoftware.Opera                         opera
     com.flock.Flock                                 flock
     org.webkit.nightly.WebKit                    
     net.habilis.validator-sac                    
     com.fluidapp.FluidInstance.Toodledo          
     com.mekentosj.papers                         
     com.fluidapp.FluidInstance.Google Docs       
     org.mozilla.firefox                             firefox
     org.derailer.Paparazzi!                      
     com.fluidapp.FluidInstance.Google Calendar   
     com.fluidapp.Fluid                           
     com.google.Chrome                               chrome
    

    $ switchbrowser some.other.App
    No such browser available: some.other.App
    
    $ switchbrowser org.mozilla.firefox
    HTTP/HTTPS browser set to: org.mozilla.firefox
    
“Shorthands” are available for the most common browsers:

    $ switchbrowser flock
    HTTP/HTTPS browser set to: com.flock.flock
    
    $ switchbrowser chrome
    HTTP/HTTPS browser set to: com.google.chrome
