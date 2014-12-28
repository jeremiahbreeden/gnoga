﻿# The Gnoga User Guide
## Gnoga - The GNU Omnificent GUI for Ada
## The Ada Open-Source Mission-Critical Cloud, Desktop and Mobile Application Development Framework

(c) 2014 David Botton
    Permission is granted to copy, distribute and/or modify this document
    under the terms of the GNU Free Documentation License, Version 1.3
    or any later version published by the Free Software Foundation;
    with no Invariant Sections, no Front-Cover Texts, and no Back-Cover Texts.
    A copy of the license is included in the section entitled "GNU
    Free Documentation License".

For more information about Gnoga see http://www.gnoga.com

* * *

### Table of Contents

   * Introduction to Gnoga
      - What is Gnoga?
      - How does Gnoga work?
      - Where can I use Gnoga?
      - What can I do with Gnoga?
      - When would I not use Gnoga?
      - Who wrote Gnoga?
   * Getting Started
      - Setting up your development environment
      - Building Gnoga
      - Installing Gnoga
      - How to get help using Gnoga
   * Writing Applications in Gnoga
      - A Simple Hello World program
      - The gnoga_make Tool
      - A Singleton Application
      - A Multi Connect Application
      - Advanced: The Connection Parameter and GUI elements on the Stack
      - Advanced: Per Connection App Data
      - Multi Connect Applications for a Single User
   * Getting around Gnoga
      - The Gnoga directory structure
      - Directory structure when developing apps
      - Directory structure when deploying apps
      - Application, Types, Gui, Server, Client
      - Plugin, Modules
      - Tags bound in Gnoga
   * Gnoga concepts
      - Multi Connect, data and exceptions
      - Views
      - In and out of the DOM
      - Display, Visible, Hidden
      - Native applications
   
## Introduction to Gnoga
### What is Gnoga

Defining Gnoga is an important first step to using it. Gnoga is best defined as a framework and tools to develop GUI applications for the Ada language using web technologies as a rendering engine. Gnoga should not be confused with web development frameworks. While Gnoga is very capable of creating web applications, even more capable to do so than web development frameworks, using Gnoga for web applications is only one possible use that is a byproduct of using web technologies to render the GUI.

### How does Gnoga work?

A Gnoga application can be divided in to three parts:

1. The application code written in Ada using the Gnoga framework and tools
2. The communication layer
3. The GUI rendering surface, an HTML 5 compliant browser or an embedded widget.

The communication layer is not passive as in typical web programming using http and perhaps Ajax calls to simulate a live active connection. It is rather an active connection using HTML5 websockets or direct access at the API level to an embedded widget.

Since the communication layer is always active there is a stateful constant connection to the rendering surface as there is in traditional desktop GUI development even if the rendering surface is a remote HTML 5 compliant browser.

The idea of using publishing technologies to display a GUI is not new. Next used Postscript, Mac OS X PDF and Gnoga uses HTML 5.

### Where can I use Gnoga?

Gnoga applications can be run anywhere that a suitable gcc/ada compiler version 4.7 or above compiler can target that provides a Gnat.Socket implementation or has direct API access to am HTML 5 client widget.

Gnoga is already being used on every major operating system and even in some embedded systems. At least one commercial appliance is being developed using Raspberry Pi boards and Gnoga to provide the user interface.

### What can I do with Gnoga?

Gnoga's use of web technologies, lite requirements and flexible communication layer allows for an incredible variety of potential uses.

1. Traditional cross platform GUI development that normally would be done in Gtk, Qt
2. In place of native GUI development that is with in the scope of available web technologies.
3. Thin client multiuser applications
4. Remote GUIs to embedded systems
5. Web base applications
6. Web site development
7. Collaborative real-time update applications
8. and so much more...

### When would I not use Gnoga?

Gnoga is ideal for almost all GUI application development. however it wouldn't be the best choice for writing an application that required close integration with the operating system's native UI. That doesn't mean to say you can't combine native UI development with Gnoga or that even in this case often Gnoga is still the ideal solution. 

For example, On Mac OS X, native Gnoga applications often use Mac Gap 2 (http://macgapproject.github.io/). Using Mac Gap Gnoga applications have direct access to most of the native GUI as well. It is also possible to create on any platform a native application with an embedded html 5 widget such as webkit and then have the best of both worlds.

### Who wrote Gnoga?

Gnoga's author is [David Botton](http://botton.com). Gnoga's http and websocket implementation is from Simple Components by [Dmitry A. Kazakov](http://www.dmitry-kazakov.de/).

However with out the good people on the [Gnoga e-mail list](https://lists.sourceforge.net/lists/listinfo/gnoga-list) using, testing and pushing for more Gnoga would not be a reality. I'm sorry for not mentioned everyone by name but the e-mail archives will bear your fame forever.

## Getting Started
### Setting up your development environment

Gnoga requires a development environment with gcc/ada 4.7 or above that also implements GNAT.Sockets. Just about every OS, platform and target is supported.

For most environments the instructions to get started can be found at GetAdaNow.com

Once you have set up a gcc/ada compiler you will need to install the git version control system. This is installed by default on Mac OS X and some versions of Linux. For Windows there are excellent free versions available on Sourceforge.net

Use the following command with git to check out the latest version of Gnoga:

```
git clone git://git.code.sf.net/p/gnoga/code gnoga
```

Once you have cloned gnoga we are ready to starting building it.

### Building Gnoga

If your development environment includes gprtools then run:

```
make
```

If your development environment does now, open the Makefile and follow the directions in the Makefile to switch to use gnatmake in its place. Then run as above:

```
make
```

This should build the Gnoga framework a demo or two and the tutorials. You can give a try out now by typing:

```
bin/snake
```

This will run the snake demo. Open a browser and type http://127.0.0.1:8080 this will connect you to the demo and you can play the classic snake game.

### Installing Gnoga

There are many ways to incorporate Gnoga in to new projects. In environments with GPR tools it is possible install Gnoga as a "standard" library using:

```
make install
```

Once done it is possible to incorporate Gnoga in to projects by just adding with "gnoga". It also installs gnoga_make in to the same directory as the gcc/ada executable gnat.

It is not necessary though to install Gnoga to use it. Only to place the correct path to gnoga in to the "with" in your gpr file. For example:

``` ada
with "../../gnoga/src/gnoga.gpr";

project Gnoga_Web is
   for Languages use ("Ada");
   for Source_Dirs use (".");
   for Object_Dir use "../obj";
   for Exec_Dir use "../bin";
   for Main use ("gnoga_web-main.adb","source_view.adb");

   package Binder is
     for Default_Switches ("ada") use ("-E");
   end Binder;

   package Builder is
      for Executable ("gnoga_web-main.adb") use "gnoga_web";
   end Builder;
end Gnoga_Web;
```

### How to Get Help Using Gnoga?

There is a great community around Gnoga and the Ada language. Here are a few good resources for reaching out for help:

1. The Gnoga E-Mail Support List
   https://lists.sourceforge.net/lists/listinfo/gnoga-list

2. The Usenet Group - Comp.Lang.Ada
   https://groups.google.com/forum/#!forum/comp.lang.ada

3. The Freenode #Ada group

## Hello World in Gnoga

### A Simple Hello World Program

Gnoga provides a tool for setting basic Gnoga projects but for this chapter we are going to manually create our hello world application to learn the details about how a Gnoga application is structured and works.

We are going to assume for this little tutorial that you have checked out or unarchived gnoga in the same directory that we will be building this project.

So lets say it is ~/workspace

We can checkout and make gnoga using:

```
cd ~/workspace
git clone git://git.code.sf.net/p/gnoga/code gnoga
cd gnoga
make
```


Next lets create our directory structure, we will call our application hello.

```
cd ~/workspace
mkdir hello
cd hello
mkdir bin
mkdir src
mkdir html
mkdir js
```

Our root directory for our project we are calling hello after the name of our program, any name of course could be used.

Under our root directory we create a bin directory for our application. The binary for Gnoga applications can be in the bin director or in the root but it is cleaner to have everything in its own place.

We will be place our src files in the src directory, there is no rule that the source files need to be in their own directory, but again it is cleaner.

The additional two directories, html and js, are required. They will contain our "boot" html file in the html directory and the js directory will contain our boot.js and jquery.min.js files.

Let's copy the needed boot files now:

```
cd ~/workspace/hello
cp ../gnoga/html/* html/
cp ../gnoga/js/* js/
```

Next let's writ our "hello world" application in the src directory. We will create two files, our hello.adb file containing our application and hello.gpr a project file that describes what the compiler should do.

hello.adb:

``` ada
with Gnoga.Application.Singleton;
with Gnoga.Gui.Window;
with Gnoga.Gui.View.Console;

procedure hello is
   Main_Window : Gnoga.Gui.Window.Window_Type;
   Main_View   : Gnoga.Gui.View.Console.Console_View_Type;
begin
   Gnoga.Application.Singleton.Initialize (Main_Window, Port => 8080);
   --   Initialize Gnoga for a single connection application that will
   --   respond to port 8080
   
   Main_View.Create (Main_Window);
   --   Views are containers of elements and are the basic layout mechanism
   --   for UI objects in Gnoga. In this case our view lays out UI elements
   --   top to bottom left to right as they are created and offers some
   --   console like methods for easy output.
   
   Main_View.Put_Line ("Hello World!");
   --   The console view offers a convenient way to write text out to the UI
   --   as if it was a console application.
   
   Gnoga.Application.Singleton.Message_Loop;
   --   This tells Gnoga to wait until the user has closed the browser window
   --   or our application notifies it otherwise.
end hello;
```

hello.gpr

```
with "../../gnoga/src/gnoga.gpr";

project hello is
   for Languages use ("Ada");
   for Source_Dirs use (".");
   for Exec_Dir use "../bin";
   for Main use ("hello.adb");
end hello;
```

To build our application we simple run:

```
gprbuild
```

or if you do not have gprtools use

```
gnatmake -P hello.gpr
```

We can now execute our application

```
cd ~/workspace/hello
bin/hello
```

Open a browser and go to the URL: http://127.0.0.1:8080

### The gnoga_make tool

In order to make it easier to get started writing gnoga applications, a tool called gnoga_make is provided to quickly create the needed directories and provide the initial program structure including Makefile, etc.

The syntax for creating a new project is:

```
gnoga_make new NAME_OF_PROJECT NAME_OF_TEMPLATE
```

The templates current available are:

- hello_world
- singleton
- multi_connect


So to to create a simple hello_world program we can do (assuming gnoga was checked out or unarchived at ~/workspace/gnoga):

```
cd ~/workspace
gnoga/bin/gnoga_make new hello hello_world
```

If gnoga was installed use make install then you can skip the next step.

In our gpr file, let's modify where to find gnoga by editting ~/workspace/hello/src/hello.gpr and setting the first line to read

```
with "../../gnoga/src/gnoga.gpr";
```

now we can make and run our hello world application:

```
cd ~/workspace/hello
make
bin/hello
```

It will open a browser to http://127.0.0.1:8080

### A singelton Application

There are two basic application types in Gnoga, Singleton applications and Multi Connect applications. Singleton applications are ideal for desktop applications. They allow only a single connection and then exit when that connection is lost. Since the application will not be accessed in parallel by other connections there is no need to protect data except from parallel incoming events.

To demonstrate the use of a singleton application we will create a simple utility that will allow executing and display the results of a command to the operating system. This example is purposely going to be a bit more complex to help demonstrate various UI concepts with in Gnoga.

First let us generate the skeleton of our singleton application.

```
gnoga_make new GnogaCMD singleton
```

If Gnoga was not installed as a default library, we need to modify gnogacmd/src/gnogacmd.gpr with the path to the gnoga.gpr file.

```
with "../../gnoga/src/gnoga.gpr";
```

In the gnogacmd directory let's run make which since the first time will create our obj directory for our compiler temporaries and run our application.

```
cd ~/workspace/gnogacmd
make
bin/gnogacmd
```

Everything should build and your default browser should open with the application. Now let's close the browser window and that should cause the application to stop running as well. If your development environment does not include gprtools, you can replace gprbuild in the Makefile with gnatmake.

We can now get started with creating our application.

First let's discuss how we would like our application to work. Let's mimic the way a shell works by displaying a command prompt, then the results of the command and once the results are returned offer another command prompt.

In Gnoga the top most user interface object is the Window. This represents the physical browser window and connection to it. While it would be possible to place user interface elements directly in the browser window Gnoga applications usually use a container of a View_Type or child of it that will fill the entire window. View_Types are designed to help making the layout of user elements easier and more efficient and also make it easier to reuse the entire interface as a user interface element itself and to make it easy to switch the entire contents of the browser window to another view if desired and eliminate the need to create new connections to the browser.

The singelton skeleton application creates a custom view called Default_View_Type and in our application that is contained in GnogaCMD.View. We are going to change the base View_Type for Default_View_Type to a Console_View_Type which automatically provides a scroll bar and scrolls to the end of the last added elements to the Console_View_Type.

To do this we will switch to "with" Gnoga.Gui.View.Console in place of Gnoga.Gui.View and then change the base type of Defaul_View_Type to Gnoga.View.Console.Console_View_Type.

The skeleton provided a generic label and button type, but we are going to replace those with form types for a label, text input and a default submit button. So we will replace the with for Gnoga.Gui.Element.Common with Gnoga.Gui.Element.Form and add a form type to our view the and form elements.

The resulting file should look like this now:

``` ada
with Gnoga.Gui.Base;
with Gnoga.Gui.View.Console;
with Gnoga.Gui.Element.Form;

package GnogaCMD.View is
   
   type Default_View_Type is new Gnoga.Gui.View.Console.Console_View_Type with
      record
         Entry_Form : Gnoga.Gui.Element.Form.Form_Type;
         Prompt     : Gnoga.Gui.Element.Form.Label_Type;
         Cmd_Line   : Gnoga.Gui.Element.Form.Text_Type;
         Go_Button  : Gnoga.Gui.Element.Form.Submit_Button_Type;
      end record;
   type Default_View_Access is access all Default_View_Type;
   type Pointer_to_Default_View_Class is access all Default_View_Type'Class;

   overriding
   procedure Create
     (View    : in out Default_View_Type;
      Parent  : in out Gnoga.Gui.Base.Base_Type'Class;
      Attach  : in     Boolean := True;
      ID      : in     String  := "");
   
end GnogaCMD.View;
```

In gnogacmd-view.adb will set up the user elements in the create procedure and
handle our new view's functionality.

``` ada
with GNAT.OS_Lib;
with GNAT.Expect;

with Gnoga.Gui.Base;

package body GnogaCMD.View is
   
   procedure On_Submit (Object : in out Gnoga.Gui.Base.Base_Type'Class);
   --  Handle submit of command line from either hitting the submit button
   --  or pressing enter with in the command line.
      
   ------------
   -- Create --
   ------------

   overriding
   procedure Create
     (View    : in out Default_View_Type;
      Parent  : in out Gnoga.Gui.Base.Base_Type'Class;
      Attach  : in     Boolean := True;
      ID      : in     String  := "")
   is
   begin
      Gnoga.Gui.View.Console.Console_View_Type
        (View).Create (Parent, Attach, ID);
      
      View.Entry_Form.Create (Parent => View);
      
      View.Cmd_Line.Create (Form  => View.Entry_Form,
                            Size  => 40);
      
      View.Prompt.Create (Form       => View.Entry_Form,
                          Label_For  => View.Cmd_Line,
                          Contents   => "Command >",
                          Auto_Place => True);
      --  Labels can automatically place themselves before the associated
      --  control they are labeling. This is the default if Auto_Place not
      --  specified.
      
      View.Go_Button.Create (Form  => View.Entry_Form,
                             Value => "Go");
      --  The "value" of a button is the button's text. Go_Button is a submit
      --  button and will cause it's Form to submit.
      
      View.On_Submit_Handler (On_Submit'Access);
      --  The submit event will bubble up if not handled at the form itself.
      --  In our case instead of placing On_Submit on the View.Entry_Form
      --  we have placed it on the parent view.
   end Create;
   
   
   ---------------
   -- On_Submit --
   ---------------
   
   procedure On_Submit (Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      View : Default_View_Type renames Default_View_Type (Object);
      --  Renaming is a convenient way to "upcast"
      
      --  Our tutorial is focusing on Gnoga not the GNAT packages in gcc/ada
      --  so will will not go in to length about using GNAT.Expect, it is
      --  left as an exercise to the reader to look at the specs.
      
      Args   : GNAT.OS_Lib.Argument_List_Access;
      Status : aliased Integer;
   begin
      Args := GNAT.OS_Lib.Argument_String_To_List (View.Cmd_Line.Value);
      
      declare
         Result : String := Gnat.Expect.Get_Command_Output
           (Command    => Args (Args'First).all,
            Arguments  => Args (Args'First + 1 .. Args'Last),
            Input      => "",
            Status     => Status'Access,
            Err_To_Out => True);
      begin
         View.Put_HTML ("<pre>" & Result & "</pre>");
         --  Put_HTML is a convenient way to dump pure html in to a view at
         --  the bottom of the view.
         
         View.New_Line;
      end;
      
      View.Entry_Form.Place_Inside_Bottom_Of (View);
      --  This will move entire Entry_Form (all of its children as well) to
      --  the bottom of the View.
      
      View.Cmd_Line.Focus;
      --  Place the entry focus on Cmd_Line
      
      View.Cmd_Line.Select_Text;
      --  Select the entire contents of Cmd_Line
   end On_Submit;   

end GnogaCMD.View;
```

In addition we need to remove from gnoga-controller.adb the On_Click procedure and related parts as they no longer are needed.

We can now make and run our singleton example:

```
cd ~/workspace/gnogacmd
make
bin/gnogacmd
```

### A Multi Connect Application

Just like with the creation of the Singleton application we will start off using gnoga_make to generate a skelleton project. In this case we will build a multi user white board.

```
gnoga_make new GnogaBoard multi_connect
```

As with the Singleton application example we will assume our project is now in ~/workspace/gnogaboard

Modify, if needed, as per the Singleton example gnogaboard/src/gnogaboard.gpr to "with" in the location of gnoga.gpr

Compile the project to make sure your changes (if you needed to make any) are correct:

```
cd ~/workspace/gnogaboard
make
bin/gnogaboard
```

When you are done testing the skelleton, press Ctr-C from the command line to close the application.

The actual layout of the files and basic structure is the same as the Singleton application. The most important difference is in the "controller".

In gnogaboard-controller.adb you will notice the procedure Default as an additional parameter called Connection and at the end of the body of the package there is a call to On_Connect_Handler.

The On_Connect_Handler associates URLs with "controllers" procedures that will handle each incoming connection from the browser. The special URL of "default" tells Gnoga to call that handler as the default, i.e. for any URL not handled by another On_Connect_Handler. Is this case it is our procedure called Default.

### Advanced: The "Connection" Parameter and GUI elements on the Stack

The extra parameter "Connection" in our controller procedure "Default" can be used when you wish to block the connection procedure until the connection is closed. While not often used, the two common uses of Connection.Hold to block until connection loss are:

1. To add code clean up on connection loss to the connection procedure, this could also have been added to the On_Destroy event for Main_Window.

2. To prevent finalization of staticly defined GUI elements with in the connection procedure until the connection has been lost.

An example of this second method would allow us to rewrite the skelleton procedure as:

``` ada
   procedure Default
     (Main_Window : in out Gnoga.Gui.Window.Window_Type'Class;
      Connection  : access
        Gnoga.Application.Multi_Connect.Connection_Holder_Type)
   is
      View : GnogaBoard.View.Default_View_Type;
   begin
      View.Create (Main_Window);
      View.Click_Button.On_Click_Handler (On_Click'Access);
      
      Connection.Hold;
   end Default;
```

### Advanced: Per Connection App Data

In the multi connect example above we use the connections main view to store data specific for each user connection. It is often more convenient to have a data structure containing the data specific to a connection. Gnoga offers a way to associate data to a connection and allow access to that data through any GUI element on that connection.

The following is an example 

``` ada
   type App_Data is new Connection_Data_Type with
      record
         Main_Window : Window.Pointer_To_Window_Class;
         Hello_World : aliased Common.DIV_Type;
      end record;
   type App_Access is access all App_Data;

   procedure On_Click (Object : in out Gnoga.Gui.Base.Base_Type'Class;
                       Event  : in     Gnoga.Gui.Base.Mouse_Event_Record)
   is
      App : App_Access := App_Access (Object.Connection_Data);
   begin
      App.Hello_World.Text ("I've been clicked");
   end On_Click;

   procedure On_Connect
     (Main_Window : in out Gnoga.Gui.Window.Window_Type'Class;
      Connection  : access
        Gnoga.Application.Multi_Connect.Connection_Holder_Type)
   is
      App : App_Access := new App_Data;
   begin
      Main_Window.Connection_Data (App);
      --  By default Connection_Data is assumened to be a dynamic object
      --  and freed when the connection is closed. To use static app
      --  data pass Dynamic => False
      ...
   end On_Connect;
```

### Multi Connect Applications for a Single User

A Multi Connect application allows multiple connections to the same application at the same time. This does not always imply multiple users, it could even be the same user with multiple browser windows connected to the same application. When use a multi connect application as a single user desktop application you simply need to restrict access to the application to the local machine and provide someway for the application to know it is time to shutdown.

Some tips:

1. In the On_Connect procedure check if there has already been a connection and if a reconnect is tried return a view that indicates application is already running.

2. If limitting to only one main window, use that windows On_Destroy event to tell the application to shut down using Gnoga.Application.Multi_Connect.End_Application if not provide some other way to exit the application or track if all connections are closed.

3. Limit connections to the local machine only, In initialize use Initialize (Host => "127.0.0.1");

## Getting around Gnoga

### The Gnoga directory structure

At the Gnoga distribution root directory there are a number of ALL CAPS files that contain licensing information, the FAQ and build and installation information.

The following is the layout of files in the Gnoga distribution:

```
Root Dir
  |
  |___ bin - gnoga_make, demo and tuturial executables
  |
  |___ css - css files used by demos
  |
  |___ demo - Gnoga demos
  |
  |___ deps - Gnoga dependancies from other projects
  |    |
  |    |_ simple_components - Dmitry A. Kazakov - see components.htm
  |
  |___ docs - Gnoga documentation
  |
  |___ html - boot.html and other sample files useful for web Gnoga apps.
  |
  |___ img - image files for demos
  |
  |___ js - jquery.min.js and boot.js (required for all Gnoga apps)
  |
  |___ lib - after make - libgnoga.a for linking to Gnoga applications
  |
  |___ obj - intermediate build objects created during make
  |
  |___ src - Gnoga source files
  |
  |___ templates - templated for gnoga_make and demo template files
  |
  |___ test - files used to test gnoga during Gnoga's development
  |
  |___ tools - source code for gnoga_make
  |
  |___ tutorial - tutorials for using Gnoga features
  |
  |___ upload - upload directory for demos and tests

```

### Directory structure when developing apps

If you use the gnoga_make tool it will setup a development directory structure in addition to creating a skelleton application. (see the Singleton and Multi Connect examples in the chapters above)

For reference the following directory structure is the basic structure during development:

```
During development the following directory structure works well:

App Dir
  |
  |___ bin - your gnoga app binary
  |
  |___ html - boot.html (or other boot loader used)
  |
  |___ js - must contain jquery.min.js and boot.js
  |
  |___ css - optional, all files served as css files
  |
  |___ img - optional, a directory of serving graphics.
  |
  |___ src - Source code for your gnoga app
  |
  |___ obj - Build objects
  |
  |___ templates - option, if using Gnoga.Server.Template_Parser
  |
  |___ upload - option, optional directory for incoming files

```

### Directory structure when deploying apps

The ideal structure to deploy your apps for production is the following
directory structure:

```
App Dir
  |
  |___ bin - your gnoga app binary
  |
  |___ html - boot.html (or other boot loader used)
  |
  |___ js - must contain jquery.min.js
  |
  |___ css - optional, a directory for serving css files
  |
  |___ img - optional, a directory of serving graphics.
  |
  |___ templates - optional, if using Gnoga.Server.Template_Parser
  |
  |___ upload - option, optional directory for incoming files
```

If any of the subdirectories is missing html is assumed and if html is
missing the App Dir is assumed. The executable can be in the bin directory or
in App Dir.

### Application, Types, Gui, Server, Client

The Gnoga framework's root package is Gnoga. There are five child packages making up the five areas of development connected to Gnoga development.

   * Gnoga.Application and its children are related initializing and managing the lifecycle of Gnoga applications.
   * Gnoga.Types contains Gnoga specific types used through out the framework
   * Gnoga.Gui contains the user interface portions of Gnoga. It is further divided in to the following child packages:
     - Gnoga.Gui.Base - Common base functionality and events to all UI objects
     - Gnoga.Gui.Document - Binding to root element of DOM in a window
     - Gnoga.Gui.Element - General binding to all UI objects
     - Gnoga.Gui.Element.Common - Commond UI elements
     - Gnoga.Gui.Element.Form - Form related UI elements
     - Gnoga.Gui.Ekement.Canvas - Binding to a drawing canvas
     - Gnoga.Gui.Element.Multimedia - Multimedia bindings
     - Gnoga.Gui.Element.SVG - SVG canvas binding
     - Gnoga.Gui.Location - Browser window location control
     - Gnoga.Gui.Navigator - Browser application control
     - Gnoga.Gui.Screen - Desktop screen properties
     - Gnoga.Gui.View - Layout control of UI elements
     - Gnoga.Gui.Window - Control of connection to UI
   * Gnoga.Server - Server side bindings and features
     - Gnoga.Server - Application settings and directories
     - Gnoga.Server.Connection - Low level control of connection to UI
     - Gnoga.Server.Database - Database bindings (MySQL and SQLite3)
     - Gnoga.Server.Migration - Datbase schema migration interface
     - Gnoga.Server.Model - Active Record implementation for Database access
     - Gnoga.Server.Template_Parser - Template parsing (Pythong or simple text)
   * Gnoga.Client - Non GUI client side bindings
     - Gnoga.Client.Storage - Local storage on client side
     - Gnoga.Client.Bind_Page - Dynanicly create Gnoga objects for an HTML page

### Plugin, Modules

Users can write and publish to the Gnoga Marketplace two Gnoga specific UI extension types, Plugins and Modules.

Plugins such as the include jQuery, jQueryUI, Boot_Strap and Ace_Editor are bindings to JavaScript libraries for use on client side.

Modules are unique Gnoga based UI elements written with Gnoga.


### Tags Bound in Gnoga

While Gnoga is not exactly HTML in Ada, knowing the relationships may be of assistance in developing your application:

```
*  HTML5 Tags Bound as Gui Elements in Gnoga

   <a>,<hr>,<br>,<button>,<div>,<img>,<meter>,<progress>,<p>
               - Element.Common, also see Gui.View for <div> and <span>
   <canvas>
               - Element.Canvas
   <svg>
               - Element.SVG

   <form>,<input>,<textarea>,<select>,<datalist>,<legend>,<label>,<option>
   <optgroup>
               - Element.Form,
   <fieldset>
               - Element.Form.Fieldset

   <audio>,<video>,<source>*,<track>*
               - Element.Multimedia, * Not needed

   <iframe>
               - Element.IFrame

   <html>,<body>,<head>
               - Access through Window_Type.Document

   <ul>,<ol>,<li>,<dl>,<dd>,<dt>
               - Element.List

   <address>, <article>, <aside>, <header>, <main>, <nav>, <p>, <pre>,
   <section>
               - Element.Section

   <code>,<strong>,<em>,<dfn>,<samp>,<kbd>,<var>,<marked>,<del>,<ins>,
   <s>,<q>,<big>,<small>,<time>,<tt>,<wbr>
               - Element.Phrase

   <link>,<style>,<title>
               - Element.Style_Block, The Style property on Element_Type
               - Document.Load_CSS, Document.Title
               - Since content is generated by code

   <table>,<caption>,<td>,<tr>,<th>,<col>,<colgroup>,<tfoot>,<thead>
               - Element.Table


*  HTML5 Tags Unbound as Gui Elements in Gnoga
       Note: All tags can be bound and used with
             Element_Type.Create_With_HTML
             For various reasons as desribed here,
             they are not bound specifically.


   <map>,<area>
               - No spefic bindings currently for image maps, best
               - generated with an automated tool as regular HTML.

   <bdi>,<bdo>,<ruby>,<rp>,<rt>
   <details>,<output>,<figure>,<flgcaption>
               - Text formatting tags are not bound. Have no application
               - specific use. Span_Type should be used to contain text
               - that needs interaction or interactive styling.

   <object>,<embed>,<script>,<noscript>,<param>,<applet>
               - No bindings are made for external plugins or scripting
               - tags

   <base>, <meta>
               - base and meta only makes sense for static pages

   <dialog>,<keygen>,<menu>,<menuitem>
               - No broswers support tags in a way worth binding yet

   <frameset>,<frame>,<noframes>
               - No window level frame support, see Element.IFrame
```

## Gnoga Concepts
   * Gnoga concepts
      - Multi Connect, data and exceptions
      - Views
      - In and out of the DOM
      - Display, Visible, Hidden
      - Native applications