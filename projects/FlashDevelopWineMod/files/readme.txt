BY THANH TRAN 
Email: trongthanh@gmail.com
Home page: http://int3ractive.com

DISCLAIMER:
I guarantee no virus and malware in my compilation. However, I will take no responsibility for any damages / issues (if any) caused by this mod. Use the program at your own risks.

---------------------------------------------------------------------------------------------------------
							CHANGES LOG
---------------------------------------------------------------------------------------------------------
2011-08-22 FD r2044
- Create installation script
- Build current WineMod against FD4 Beta 2 r2044

2011-08-16 FD4 r2039
- Merge and adapt current Wine Mod into FD4 Beta r2039

2011-06-18 FD4 r1944
- Fix: FD crashes when trying to compile project (without starting from terminal)
- Fix: If FD is minimized and restored, the box Debug/Release on tool bar disappear
- Downloads: 
	+ FD4 R1944 official build: http://www.flashdevelop.org/downloads/builds/FlashDevelop-4.0.0-R1944.exe
	+ FD4 R1944 mod for Wine/Linux: http://code.google.com/p/thanhtran-sources/downloads/detail?name=fd4r1944_winemod.zip&can=2&q=

2011-06-14 FD4 r1906
- First release
- Downloads:
	+ FD4 R1906 official build: http://www.flashdevelop.org/downloads/builds/FlashDevelop-4.0.0-R1906.exe
	+ FD4 R1906 mod for Wine/Linux: http://code.google.com/p/thanhtran-sources/downloads/detail?name=fd4r1906_winemod.zip&can=2&q=
	+ JRE 1.6 portable: http://code.google.com/p/thanhtran-sources/downloads/detail?name=jre_portable.zip&can=2&q= 

---------------------------------------------------------------------------------------------------------
						HOW TO INSTALL
---------------------------------------------------------------------------------------------------------
My tutorial is based on Ubuntu 11.04 32-bit. Please adapt if your Linux distro is different.
1. Install Wine 1.3+ (by the time of this post, latest beta Wine version is 1.3.21)
Visit http://www.winehq.org/download/ for download and install instruction. For Ubuntu users, I recommend install it via PPA.

2. Create a fresh wine prefix. I.e. delete or rename the folder .wine (hidden) in your home folder. A new .wine folder will be created automatically in subsequent steps

3. Install required winetricks: Open terminal, type
$winetricks dotnet20 gdiplus
(Recently wine is bundled with winetricks. If the command not found, visit http://wiki.winehq.org/winetricks to get it mannually)

4. Download official FlashDevelop 4 build. (link below)

5. Install FD4 by double-click on the .exe file. Install it as stand-alone version with default path.
After install FD4, DO NOT run it yet.

6. Download my modification files. (link below)

7. Copy mod files to overwrite ones in FD4 installation folder. If you install it with default wineprefix and default path, FD installation folder can be found in /home/$USER/.wine/drive_c/Program Files/FlashDevelop
(replace $USER with your own user name)

After this step, you can already start FD4 (using the launcher which Wine creates for you on desktop) and use it to manage projects and edit code. However, if you want to be able to compile and test your app, there’s some complicated steps ahead:
	 	
8. Install Java Runtime Environment. I tried to install JRE with the official Java offline installer. However, I cannot compile with Flex SDK. The workaround for this is to use a portable JRE. If you’re using Flash CS5, you can find a standalone copy of JRE in this folder:
[Windows 7] C:\Users\All Users\Application Data\Adobe\CS5.
For convenience, you can download my share of a portable JRE from the link below.
After downloading JRE, place it in your Wine’s C: root equivalent folder (i.e. /home/$USER/.wine/drive_c/).
Open registry editor ($wine regedit), add “C:\jre\bin” to environment PATH (find it in: HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment) and create JAVA_HOME variable with value “C:\jre”.
For convenience, you can import my registry file with command:
$wine regedit jre.reg
(Be warned, your PATH variable will be overwritten with default paths plus path to jre)
To try if your jre works, start wine’s command line:
$wine cmd
Z:\home\user>java -version
If you should see some output telling about Java’s version.

9. Download Flex SDK of your choice and set it up in FD.

10. [FIXED, NO NEED TO USE STEP 10]

After previous step, you can now build projects with Flex SDK. Next will show you how to test and debug with FD:

11a. To test and debug with Flash Player for Windows, just open FlashViewer plugin settings and browse to the Windows’ FlashPlayerDebugger.exe in your Flex SDK for External Player Path.

11b. To test and debug with Flash Player for Linux (native):
- Do not perform 11a step, i.e leave External Player Path blank so that FD will you associate application to open swf file.
- Extract flashplayerdebugger.tar.gz in Flex SDK (likely in: {flex_sdk}/runtimes/player/{player_version}/lnx/flashplayerdebugger.tar.gz)
- In Linux, make the extracted Flash Player as default application to open swf file. (From Nautilus, right-click on an swf, select Open with > Other Application > type in full custom command to the flashplayerdebugger binary > select Remember this...)
- Import the file swf.reg to registry by executing:
$wine regedit swf.reg
This will make Wine call default native application for swf file.

Now you can try compiling an AS3 project. 

---------------------------------------------------------------------------------------------------------

What work (all basic functions):
- Code editing
- Code hinting & completion
- Create, manage projects
- Search & replace
- Plugins
- Compile & debug (advanced)
- Drag drop files from Nautilus to project manager (currently not the other way around)

What have been patched/fixed:
- Set default layout with floating panels to work around docking issue
- Fix tooltip’s height and blank issues
- Fix missing tool bar issue (although tool bar now will appear on top of menu)
- Fix document editor resize issue (when you resize the main windows or just start FD, the opened documents don’t update with new size)
- Open native command prompts (on tool bar)
- Explore folders with Nautilus (can open from tool bar and project manager)

What doesn’t work / known issues:
Of course there are a lot of issues when running on non-native environment. Below are just some remarkable:
- Docking panels on main windows (That why I detach all of them via LayoutData.fdl)
- Scrolling for long tool tips (because the patch deliberately disables scroll bars of tool tip)
- Shell menu (DO NOT try to access it)
- Create new folders via folder tree view dialog (this is Wine’s incomplete component)
(What features are not listed here can be considered not tested yet)
- If FD is minimized for a while and then restored, the floating panels doesn’t seem to remember its last normal size and appear very small.

---------------------------------------------------------------------------------------------------------

Plan for next patches:
- Write automate script to reduce hassle of setting up for newbie.
- Try to fix some of the above know issues.
- Investigate if ToirtoseSVN & source control plugin work 
- Investigate ways to improve project manager’s folder and file handling. (May consider using Linux bridge)

---------------------------------------------------------------------------------------------------------

