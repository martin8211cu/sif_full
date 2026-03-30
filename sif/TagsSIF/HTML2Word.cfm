<!--- 
Peter Stolz
Pegasus Internet 10/22/2000
Last Modified 01/17/2001
Email: see end of file
Check out http://www.coldfusionnet.com for updates to this tag.

!!! CREATE DYNAMIC MS WORD FILES WITH CUSTOM FORMATTING: TABLES, COLORS, BORDERS, FONTS ETC.!!!
This custom tag creates a dynamic  Word file from the generated content of a block of ColdFusion code.
The generated content is first saved as an HTML file,
Then it is opened in Word and saved with the .doc extension.

!!!--------
Do you need to generate colorful MS Excel documents on the fly?
Check out CF_HTML2Excel in the Allaire Tag gallery.
!!!--------

!!!PLEASE NOTE THAT THIS TAG IS A 'BETA' VERSION - USE AT YOUR OWN RISK!!!

System Requirements:
- This tag will only work on WindowsNT/2000
- MS Word or OSE (Office Server Extensions/ requires IIS) MUST BE INSTALLED on the server
- Office HTML filters must also be installed (try to open a simple HTML file manually in Word - on the server - to check this. You should NOT see the HTML source.)
- ColdFusion must have permissions to access/use Word COM objects 
(Download OLEView from www.microsoft.com and check the launch and access permissions of the "Microsoft Word Application" COM object) 
 
Usage:
<CF_HTML2Word 
    DIRECTORY="C:\InetPub\wwwroot\"
    TEMPDIRECTORY="C:\Temp\"
    FILENAME="myWordFile"
    LEAVEOPEN="YES/NO">
 
Any static or dynamically generated HTML goes here 

</CF_HTML2Word>

Input Parameters:
DIRECTORY(optional): the directory path where the Word file will be created; default is the current template directory
TEMPDIRECTORY(optional): the directory path where the temporary HTML files are stored: default is the current template directory
FILENAME(optional): the name of the Word file that will be created (without the extension); default is a random number preceded by HTML2Word(eg. HTML2Word5545678.doc)
LEAVEOPEN(optional/use carefully): leaves the Word application open in the background after it finishes one request. Use this option if you expect multiple requests in a short period of time. It can save Word start-up time but it uses server resources.

Output Parameters:
WORDFILE : The absolute path to the just-created Word File

Note: If another Word file with same name exists the tag will overwrite it without prompting!!

Note about creating Word documents with embedded images:   
It is posible to create such Word documents in one of two ways:
    - resolve all img src paths like so <IMG SRC="http://www.myserver.com/myimage.gif">(the images must reside on the web server..)
    - make all image paths relative to a 'images' directory - similar to what MS IE does when you save an HTML page as 'Web Page Complete'
The bottom line is: if you can manually open the HTML file in Word and see the images you can also do it in CF through scripting
End Note

Please send constructive comments to: pstolz@usa.net (after you have read System Requirements and Usage sections above)


/**************/
Modificacion por: Marcel de Mézerville
Se agrega la opcion de generar en archivo y pantralla a la vez. El archivo se graba mas bien en la carpeta de temporales del Servidor.
--->

<CFPARAM NAME="Attributes.Directory" DEFAULT="#GetDirectoryFromPath(GetTemplatePath())#">
<CFPARAM NAME="Attributes.TempDirectory" DEFAULT="#GetDirectoryFromPath(GetTemplatePath())#">
<CFPARAM NAME="Attributes.FileName" DEFAULT="HTML2Word#RandRange(1000,100000000)#">
<CFPARAM NAME="Attributes.LeaveOpen" DEFAULT="No">

<CFIF ThisTag.HasEndTag>
    <CFSWITCH EXPRESSION="#ThisTag.ExecutionMode#">
    
        <CFCASE VALUE="START">
            <!---  HTML file name is random --->
            <CFSET HTMLFileName = "HTML2Word" & RandRange(1000,100000000)>
            <CFSET HTMLFilePath = Attributes.TempDirectory & HTMLFileName  & ".html">
            <CFSET WordFilePath = Attributes.Directory & Attributes.FileName & ".doc">
            
            <!--- Delete any files that have the same names --->
            <CFIF FileExists(HTMLFilePath)>
                <CFTRY>
                    <CFFILE ACTION="DELETE" FILE="#HTMLFilePath#">
                <CFCATCH TYPE="Any">            
                    <CFABORT SHOWERROR="<FONT COLOR='RED'>Error Occured!!<BR>Cannot delete file <B>#HTMLFilePath#.</B><BR>It may be locked by Word. Close Word and try again.<BR></FONT><B>Error Details:</B>  #CFCATCH.MESSAGE#">
                </CFCATCH>
                </CFTRY>
            </CFIF>
            
            <CFIF FileExists(WordFilePath)>
                <CFTRY>
                    <CFFILE ACTION="DELETE" FILE="#WordFilePath#">
                <CFCATCH TYPE="Any">
                    
                </CFCATCH>
                </CFTRY>
            </CFIF>
            <!--- End file delete --->
        </CFCASE>
        
        <CFCASE VALUE="END">
            <!--- write the HTML file to disk (contains the generated content) --->
            <CFFILE ACTION="WRITE" FILE="#HTMLFilePath#" OUTPUT="#ThisTag.GeneratedContent#">
            
            <!--- discard the generated content so it does not show on the page --->
			<!--- OJO: Modificado por Marcel --->
            <!--- <CFSET ThisTag.GeneratedContent = ""> --->
                               
            <!--- try to connect to Word --->
            <CFTRY>
                <CFOBJECT 
                    ACTION="CONNECT" 
                    CLASS="Word.Application" 
                    NAME="objWord" 
                    TYPE="COM">
              <CFCATCH>
                    <CFTRY>
                        <CFOBJECT 
                            ACTION="CREATE" 
                            CLASS="Word.Application" 
                            NAME="objWord" 
                            TYPE="COM">
                        
                    <CFCATCH TYPE="ANY">
                            <CFABORT SHOWERROR="<FONT COLOR='RED'>Cannot create Word Object<BR>Make sure Word is installed and that ColdFusion has permissions to use the Word COM objects</FONT><BR><B>Error Details:</B>  #CFCATCH.MESSAGE#">                    
                        </CFCATCH>
                    </CFTRY>
              </CFCATCH>
            </CFTRY>
   
        <CFTRY>
            <CFSCRIPT>
                // open Word in the background
                objWord.Visible = false;  
                
                 // disable Alerts such as: 'Save this document?'
                objWord.DisplayAlerts =false;
                
                // get the 'Documents' collection
                objDoc = objWord.Documents;
                  
                //open the HTML document
                newDoc = objDoc.open(HTMLFilePath);
                
               
                // save it as a new document 
                newDoc.SaveAs(WordFilePath,Val(1));
                
                // close the document
                newDoc.Close();
                
                if(Attributes.LeaveOpen IS "No"){
                    // quit Word
                    objWord.Quit();
                }
                
                //release the object 
                objWord = "Nothing";
            </CFSCRIPT>
            
            <CFCATCH TYPE="ANY">
                <CFSCRIPT>
                    objWord.Quit();
                </CFSCRIPT> 
                <CFABORT SHOWERROR="<FONT COLOR='RED'>Error occured while connected to the Word object!</FONT><BR>Error Details:  #CFCATCH.MESSAGE#"> 
            </CFCATCH>
        </CFTRY>  
            
            <!--- delete intermediary HTML file --->
            <CFTRY>
                <CFFILE ACTION="DELETE" FILE="#HTMLFilePath#">
                <CFCATCH TYPE="Any">
                </CFCATCH>
            </CFTRY>
            
            <!--- pass the generated file name to the calling template--->
            <CFSET Caller.WordFile = WordFilePath>
                           
        </CFCASE>
    </CFSWITCH>
<CFELSE>
    <PRE>
    Error: This tag requires an end tag!!
    Usage:
    <FONT COLOR="MAROON">&lt;CF_HTML2WORD&gt;</FONT>
    Dynamically generated HTML to convert to MS Word format
    <FONT COLOR="MAROON">&lt;/CF_HTML2WORD</FONT>
    <BR>
    Problems? Contact the author at:&nbsp;<A HREF="mailto:pstolz@usa.net?Subject=cf_html2word">pstolz@usa.net</A>
    </PRE> 
</CFIF>
<cfoutput><A HREF="#Attributes.FileName#.doc">Download Word File</A> </cfoutput>