<!--- 
    PDFMX.cfm: Generate PDF files on the fly
    
	The general format for using cf_sifpdf is <cf_sifpdf action="action" parameter="paramval" ...>
    The actions outline for a generic 2-page document may be something like:
        init
            startpage
                addtext
                drawline
                startparagraph
                    addtoparagraph
                endparagraph
                (etc)
            endpage
            startpage
                drawrect
				addimage
                addlink
                (etc)
            endpage
        finish
		
		A more specific example of usage is as follows...

			<cf_sifpdf action="init" 
			        file="/pathname/pdfout.pdf" 
			        fonts="Arial|Arial,Bold|Arial,Italic">
			<cf_sifpdf action="startpage">
			<cf_sifpdf action="addtext" 
              		text="this is a test sentence" 
              		x="5" 
              		y="690" 
              		fontsize="16">
			<cf_sifpdf action="addtext" 
              		text="this is a test italic sentence"
		   	  		horizscale="110" 
              		fillcolor="0 0 1"
              		x="5" 
              		y="665" 
		   	  		fontnum="3"
              		fontsize="14">
			<cf_sifpdf action="addtext" 
              		text="this is a test bold sentence"
		   	  		x="5" 
              		y="640" 
		   	  		fontnum="2"
              		fontsize="12">	
			<cf_sifpdf action="drawrect" 
			        x1="0" 
			        y1="590" 
			        x2="55" 
			        y2="610" 
			        width="2" 
			        outlinecolor="1 0 0" 
			        fillcolor="0 1 0">
			<cf_sifpdf action="drawline" 
			        x1="0" 
			        y1="580" 
			        x2="400" 
			        y2="580" 
			        width="1" 
			        color="1 0 0">
			<cf_sifpdf action="addlink" 
			        x="0" 
			        y="560" 
			        href="http://www.yahoo.com" 
			        width="350" 
			        fontsize="12" 
			        outlinecolor="0 0 1" 
			        outlinewidth="5">
			<cf_sifpdf action="endpage">
			<cf_sifpdf action="finish">		
    
    
		The following actions and parameters are available for this tag:
    
		INIT           (file="absolute pathname", 
				        fonts="font1|font2|...",  (actually use the pipe character as separator!)
						producer="producername")
						
						BOLD AND ITALIC FONT NOTES

						to reference bold or italic fonts use the notation "fontname,italic" or "fontname,bold" 
						example...fonts="Arial|Arial,Italic|Arial,Bold"
						you would reference fontnum 2 for italic.
						
        STARTPAGE      [none]
        ENDPAGE        [none]
        ADDTEXT        (text="text string" 
				 		x|xinches="pixels(0-612)|inches(0-8.5)|cm(0-21.59)" portrait or "pixels(0-792)|inches(0-11)|cm(0-27.94)" landscape, 
				 		y|yinches="pixels(0-792)|inches(0-11)|cm(0-21.59)" portrait or "pixels(0-612)|inches(0-8.5)|cm(0-27.94)" landscape, 
				 		fontnum="number from order in fonts in init" default 1, 
				 		fontsize="point size" default 12, 
						spacing="number of pixels to space between characters in text" default 0, 
				 		rendermode="0|1|2" (Filled only (default)|Outlined only|Filled and outlined), 
				 		fillcolor="0-1,0-1,0-1"(red,green,blue values) default 0 0 0,
              			outlinecolor="0-1,0-1,0-1"(red,green,blue values) default 0 0 0, 
						width="line pixel width" (note, text will not be truncated to this width) default 1,
						horizscale="percent to scale chars, default 100")
        DRAWLINE	   (x1|x1inches="pixels(0-612)|inches(0-8.5)" portrait or "pixels(0-792)|inches(0-11)" landscape, 
						y1|y1inches="pixels(0-792)|inches(0-11)" portrait or "pixels(0-612)|inches(0-8.5)" landscape, 
						x2|x2inches="pixels(0-612)|inches(0-8.5)" portrait or "pixels(0-792)|inches(0-11)" landscape, 
						y2|y2inches="pixels(0-792)|inches(0-11)" portrait or "pixels(0-612)|inches(0-8.5)" landscape, 
						width="pixel width" default 1, 
						linecap="0|1|2" (Butt end|Round end|Projecting Square end), 
						color="0-1,0-1,0-1"(red,green,blue values) default 0 0 0,
                  		dashpattern="X Y" (X=single digit number dash on, Y=single digit number dash off)
        DRAWRECT 	   (x1|x1inches="pixels(0-612)|inches(0-8.5)" portrait or "pixels(0-792)|inches(0-11)" landscape, 
				        y1|y1inches="pixels(0-792)|inches(0-11)" portrait or "pixels(0-612)|inches(0-8.5)" landscape, 
						x2|x2inches="pixels(0-612)|inches(0-8.5)" portrait or "pixels(0-792)|inches(0-11)" landscape, 
						y2|y2inches="pixels(0-792)|inches(0-11)" portrait or "pixels(0-612)|inches(0-8.5)" landscape, 
						width="pixel width of outline", 
						linecap="0|1|2" (Butt end|Round end|Projecting Square end), 
                  		outlinecolor="0-1,0-1,0-1"(red,green,blue values) default 0 0 0, 
						fillcolor="0-1,0-1,0-1"(red,green,blue values) default 0 0 0)
        STARTPARAGRAPH (x|xinches="pixels(0-612)|inches(0-8.5)" portrait or "pixels(0-792)|inches(0-11)" landscape, 
				        y|yinches="pixels(0-792)|inches(0-11)" portrait or "pixels(0-612)|inches(0-8.5)" landscape, 
						fontnum="number from order in fonts in init" default 1, 
						fontsize="point size" default 12, 
						spacing="number of pixels to space between characters in text", 
						rendermode="0|1|2" (Filled only (default)|Outlined only|Filled and outlined), 
						fillcolor="0-1,0-1,0-1"(red,green,blue values) default 0 0 0,
                        outlinecolor="0-1,0-1,0-1"(red,green,blue values) default 0 0 0, 
						width="line pixel width" (note, text will not be truncated to this width), 
						horizscale="percent to scale chars" default 100, 
						leading="number of leading chars" default 2)
        ADDTOPARAGRAPH (text="text string")
        ENDPARAGRAPH   [none]
        ADDLINK 	   (x|xinches="pixels(0-612)|inches(0-8.5)" portrait or "pixels(0-792)|inches(0-11)" landscape, 
				        y|yinches="pixels(0-792)|inches(0-11)" portrait or "pixels(0-612)|inches(0-8.5)" landscape, 
						href="valid URL string", 
						name="text for link" default href, 
						width="line pixel width" (note, text will not be truncated to this width), 
						fontnum="number from order in fonts in init" default 1, 
						fontsize="point size" default 12, 
						spacing="number of pixels to space between characters in text" default 0, 
						rendermode="0|1|2" (Filled only (default)|Outlined only|Filled and outlined) default 0,
                 		fillcolor="0-1,0-1,0-1"(red,green,blue values) default 0 0 0, 
						outlinecolor="0-1,0-1,0-1"(red,green,blue values) default 0 0 0, 
						outlinewidth="pixel width" default 1)
				FINISH 	pageorientation="portrait|landscape|legal" default portrait

				ADDIMAGE
THIS ACTION IS NOT WORKING, code included for those who would like to try to complete it!	
There are notes at the bottom of this template concerning contstruction of graphics objects
within the PDF specification.	
				ADDIMAGE   (x/xinches, 
							y/yinches, 
							filename, 
							width, 
							height)
        
        
    * Useful Notes *
		
        - The difference between ADDTEXT and ADDTOPARAGRAPH is that for each ADDTEXT you
		  must specify all attributes (color, fontnum, etc...) for the text each time this
		  action is performed, whereas with each ADDTOPARAGRAPH you only need to specify 
		  the text and all attributes are inherited from the STARTPARAGRAPH action. 
		- x and y coordinate values are used for page positioning, with x going side to 
		  side on the page, and y going up and down.  you will need to have code in your 
		  calling template to track these values as appropriate for the font sizes you use.
		- A PORTRAIT page has coordinates (x=0, y=0) in the lower-left hand corner, and 
          (x=612, y=792) in the upper-right corner.  These raw pixel values can always be
          replaced with xinches and yinches values.  In the lower-left corner, 
          (xinches=0, yinches=0) and in the upper-right (xinches=8.5, yinches=11)	 		  
		- FOR LANDSCAPE, x goes to 792, y only goes to 612.  positioning is the same from lower left.
		- FOR LEGAL, x goes to 792, y goes to 1124
			
			TO MODIFY THIS TAG FOR MORE PAGE SIZES

				modify the "writepages" action, specifically the section of code that addresses the MediaBox (adobe's
				wonderful term for "page size").  as you can see, portrait, landscape and legal sizes are addressed 
				--but you can easily add in more.  just remember there are 72 units per inch for the MediaBox. 
		
        - In action="init", the file parameter must be an absolute path.
        - The PDF file is not done until you call action="finish"
        - Colors are always specified as a string of 3 decimal numbers 0-1 inclusive, 
          representing proportions of red-green-blue.  Example: "0 0 1" is blue,
          ".75 .75 .75" is grey
        - Most parameters will take default values if they're not specified.  Exceptions to this
          are obvious: x, y, text, href, etc
        - Fontnum refers to the number of the font to be used, as it was given in the fonts=
          line of ACTION="Init".  
            Example: <cf_sifpdf action="init" fonts="TimesNewRoman|Courier|Arial" ...>
                     <cf_sifpdf action="addtext" fontnum="2" ...> refers to Courier
        - Applicable text rendering modes:
            0 : Filled only (default)
            1 : Outlined only
            2 : Filled and outlined
           (there are more that are beyond the scope of cf_sifpdf)
        - Linecap modes (the area at each end of a line)
            0 :  |------|  Butt end caps - the stroke is squared at the endpoints (default)
            1 : (|------|) Rounded end caps - semicircular arc at endpoints with diameter
                           equal to line width
            2 : ||------|| Projecting square end caps - stroke extends beyond endpoints by
                           half the line's width
        - Dashpattern consists of 1 or 2 numbers describing the dashing of the line. Examples:
            "3"   (3 on, 3 off) ---   ---   ---   ---   ---
            "2 1" (2 on, 1 off) -- -- -- -- -- -- -- -- -- 
            "3 5" (3 on, 5 off) ---     ---     ---     ---

		further support for what this tag does is available at 
			  http://partners.adobe.com/asn/developer/technotes/acrobatpdf.html 
		and more specifically at
			  http://partners.adobe.com/asn/developer/acrosdk/docs/filefmtspecs/PDFReference.pdf

		THIS TAG PRODUCES UNENCODED PDF...MEANING THAT YOU CAN VIEW THE (resultant .pdf) FILE WITH 
		ANY	STANDARD TEXT FILE EDITOR.  FOR THOSE OF YOU WHO LIKE TO TINKER, THIS IS A VERY USEFUL 
		BIT OF KNOWLEDGE.
			  
		also...this tag was written to run everywhere, but a very simple modification will 
		make it run much better if you are able to use either client or session variables 
		in your environment. at the beginning and end of the tag there are cfsets to the 
		"pdf" structure which in effect pass this entire structure on each successive call 
		to the tag. if you declare "pdf" as a client or session variable (in the calling 
		template), you will avoid the overhead of passing the structure upon each call to 
		the tag. you will have to change each occurence of cfset within the tag to have a 
		"client." or "session." prefix. also, don't forget to delete the structure after 
		the pdf is generated. 
		
			SESSION VARIABLE SETUP

			1.  in the tag that calls cf_sifpdf, right before the first call, issue  a 
				<cfset session.pdf = structnew()>
			2.  modify the pdf.cfm template in the following manner...delete these lines

				<cfif IsDefined("caller.pdf")>
    				<cfset pdf=caller.pdf>    <!--- inherit variables for recursive calls --->
				</cfif>
	
				<cfset pdf = structnew()>
	
				<cfset caller.pdf=pdf> <!--- when going up the recursion ladder, give them our variables --->

			3.	change every occurrence of "pdf." to "session.pdf."
			4.  when you are done with the structure (after the cf_sifpdf action="finish" call), then issue a
				<cfset deleted = StructDelete(session, "pdf")>
		
--->

<cfif not IsDefined("attributes.action")>
	<em>in cf_sifpdf, no action specified!</em> <!--- must specify action --->
	<cfabort>
</cfif>

<cfswitch expression="#attributes.action#">
    
	 <!--- set up initial pdf structure, start file --->
	 <cfcase value="init">
        <cfif not IsDefined("attributes.file")>
            <em>Error: No file given for cf_sifpdf</em> <!--- must specify file --->
            <cfexit>
        </cfif>
        
        <cfif not IsDefined("attributes.fonts")>
            <em>Error: No fonts defined in cf_sifpdf</em> <!--- must have at least one font --->
            <cfexit>
        </cfif>
        
        <cfset session.pdf.file=attributes.file>     <!--- filename --->
        <cfset session.pdf.sections=ArrayNew(1)>     <!--- number of bytes for each obj --->
        <cfset session.pdf.bytes=0>                  <!--- byte counter during obj construction --->
        <cfset session.pdf.pagecontents=ArrayNew(1)> <!--- list of all obj's (1 0,2 0,etc..) on page --->
        <cfset session.pdf.annots=ArrayNew(1)>       <!--- used for hyperlink annotations on endpage --->
		<cfset session.pdf.curpage=0>                <!--- set on startpage, used in page info arrays --->
		<cfset session.pdf.fonts=attributes.fonts>   <!--- font list, separate by pipes! --->
		<cfset session.pdf.streamlen=0>              <!--- used on endpage, length of all text --->
		<cfset session.pdf.pageappend=''>            <!--- holds annotations for each page --->
		<cfset session.pdf.hasgraphics=ArrayNew(1)>  <!--- for incomplete ADDIMAGE --->
		<cfset session.pdf.graphics=ArrayNew(1)>     <!--- for incomplete ADDIMAGE --->
        
        <cffile action="write" file="#session.pdf.file#" output="" addnewline="no">
        
        <cfparam name="attributes.producer" default="The Producer">
        <cfset creationdate=DateFormat(Now(), "YYYYMMDD") & TimeFormat(Now(), "HHmmss")>
        
		<!--- pdf file marker --->
        <cf_sifpdf action="addtoobject" text="#chr(37)#PDF#chr(45)#1#chr(46)#0">
        
		<!--- producer, creation date obj --->
		<cf_sifpdf action="newobject">
        <cf_sifpdf action="addtoobject" text="<</Producer (#attributes.producer#) /CreationDate (D:#creationdate#) >>">
        <cf_sifpdf action="endobject">
        
		  <!--- obj's for each font --->
        <cfset i=1>
        <cfloop index="font" list="#attributes.fonts#" delimiters="|">
            <cf_sifpdf action="newobject">
            <cf_sifpdf action="addtoobject" text="<</Type /Font">
            <cf_sifpdf action="addtoobject" text="/Name /F#i#">
            <cf_sifpdf action="addtoobject" text="/Subtype /Type1">
            <cf_sifpdf action="addtoobject" text="/BaseFont /#font#">
            <cf_sifpdf action="addtoobject" text="/Encoding /PDFDocEncoding">
            <cf_sifpdf action="addtoobject" text=">>">
            <cf_sifpdf action="endobject">
            <cfset i = i + 1>
        </cfloop>
        
		  <!--- dummy outline obj --->
        <cf_sifpdf action="newobject">
            <cf_sifpdf action="addtoobject" text="<</Type /Outlines">
            <cf_sifpdf action="addtoobject" text="/Count 0">
            <cf_sifpdf action="addtoobject" text=">>">
        <cf_sifpdf action="endobject">
        <cfset session.pdf.outlines=ArrayLen(session.pdf.sections)>
        
        <!--- build Font Resource Dictionary object for indirect references --->
        <cf_sifpdf action="newobject">
	        <cf_sifpdf action="addtoobject" text="<<">
	        <cf_sifpdf action="addtoobject" text="/ProcSet [/PDF /Text]">
	        <cf_sifpdf action="addtoobject" text="/Font">
	        <cf_sifpdf action="addtoobject" text="<<">
	            
	        <cfset a=1>
	        <cfloop index="font" list="#attributes.fonts#" delimiters="|">
	            <cfset next_a = a + 1>
	            <cf_sifpdf action="addtoobject" text="/F#a# #next_a# 0 R">
	            <cfset a = a + 1>
	        </cfloop>
	        <cf_sifpdf action="addtoobject" text=">>">
	        <cf_sifpdf action="addtoobject" text=">>">
        <cf_sifpdf action="endobject">
		  <!--- set resources object name for later use --->
        <cfset session.pdf.resources=ArrayLen(session.pdf.sections)>
    </cfcase>
	 
	 <!--- done with previous obj, so update session.pdf.sections, then start new obj --->
    <cfcase value="newobject">
        <cfscript>ArrayAppend(session.pdf.sections, session.pdf.bytes);</cfscript>
        <cf_sifpdf action="addtoobject" text="#ArrayLen(session.pdf.sections)# 0 obj">
    </cfcase>
	 
	 <!--- keep session.pdf.bytes current, file appendage --->
    <cfcase value="addtoobject">
        <cfset session.pdf.bytes = session.pdf.bytes + Len(attributes.text) + 2>
        <cffile action="append" file="#session.pdf.file#" output="#attributes.text#" addnewline="yes">
    </cfcase>
	 
	 <!--- add endobj --->
    <cfcase value="endobject">
        <cf_sifpdf action="addtoobject" text="endobj">
    </cfcase>
	 
	 <!--- put font number and size into stream --->
    <cfcase value="setfont">
        <cfif IsDefined("attributes.num") and IsDefined("attributes.size")>
            <cf_sifpdf action="addtostream" text="/F#attributes.num# #attributes.size# Tf">
        </cfif>
    </cfcase>
    
	 <!--- initialize page-related structure elements --->
	 <cfcase value="startpage">
        <cf_sifpdf action="newobject">      
        <cfset nextsect=ArrayLen(session.pdf.sections) + 1>
        <cf_sifpdf action="addtoobject" text="<</Length #nextsect# 0 R >>">
        <cf_sifpdf action="addtoobject" text="stream">
        <cfset session.pdf.streamlen=0>
        <cfset session.pdf.curpage=session.pdf.curpage + 1>
        <cfset session.pdf.pagecontents[session.pdf.curpage]="#ArrayLen(session.pdf.sections)# 0 R">
        <cfset session.pdf.pageappend=''>
        <cfset session.pdf.annots[session.pdf.curpage]=''>
		<cfset session.pdf.hasgraphics[session.pdf.curpage]=0>
    </cfcase>
    
	 <!--- output endstream, length, and annotations for page --->
	 <cfcase value="endpage">
        <cf_sifpdf action="addtoobject" text="endstream">
        <cf_sifpdf action="endobject">
        
        <cf_sifpdf action="newobject">
            <cf_sifpdf action="addtoobject" text="#numberformat(session.pdf.streamlen,"0000000000")#">
        <cf_sifpdf action="endobject">

        <cfif session.pdf.pageappend is not ''>
            
				<cfset appendstring = session.pdf.pageappend>
				<cfset endappendposition = 0>
				<cfset endobjposition = 0>
				<cfset nomoreobjects = false>
				<!--- annotations (denoted by ">> >>" end of string) output as separate obj's --->
				<cfloop condition="nomoreobjects EQ false">
					<cfset endappendposition = findnocase(">> >>",appendstring,1)>					
					<cfif endappendposition EQ 0>						
						<cfset nomoreobjects = true>	
					<cfelse>
						<cfset endobjposition = endappendposition + 4>	
						<cfset objectstring = left(appendstring,endobjposition)>	
					</cfif>						
					
					<cfif nomoreobjects EQ false>
						<cf_sifpdf action="newobject">
						   <cf_sifpdf action="addtoobject" text="#objectstring#">
	            	<cf_sifpdf action="endobject">
						<cfset appendstring = mid(appendstring,endobjposition + 1,len(appendstring))>
						<cfset session.pdf.annots[session.pdf.curpage]=session.pdf.annots[session.pdf.curpage]&' #ArrayLen(session.pdf.sections)# 0 R'>
					</cfif>	
				</cfloop>	            
        
		  </cfif>
    </cfcase>
	 
	 <!--- used when adding text inside stream to keep streamlen updated --->
    <cfcase value="addtostream">
        <cf_sifpdf action="addtoobject" text="#attributes.text#">
        <cfset session.pdf.streamlen = session.pdf.streamlen + Len(attributes.text) + 2>
    </cfcase>
	 
	 <!--- finish document --->
    <cfcase value="finish">
        <cfparam name="attributes.pageorientation" default="portrait">
				<cfset session.pdf.pageorient = attributes.pageorientation>
        <cf_sifpdf action="writepages">
        <cf_sifpdf action="writecatalog">
        <cf_sifpdf action="writecrossref">
        <cf_sifpdf action="writetrailer">
    </cfcase>
	 
	 <!--- output all page-related obj's --->
    <cfcase value="writepages">
        <cfset masterpages=ArrayLen(session.pdf.pagecontents) + ArrayLen(session.pdf.sections) + ArrayLen(session.pdf.graphics) + 1>
        <cfset startpages=ArrayLen(session.pdf.sections) + ArrayLen(session.pdf.graphics) + 1>

		<!--- create any necessary graphics objects --->
		<cfloop index="i" from="1" to="#ArrayLen(session.pdf.graphics)#">
			<cf_sifpdf action="newobject">
				<cf_sifpdf action="addtoobject" text="<<">
				<cf_sifpdf action="addtoobject" text="/Type /XObject">
				<cf_sifpdf action="addtoobject" text="/Subtype /Image">
				<cf_sifpdf action="addtoobject" text="/Width #session.pdf.graphics[i].width#">
				<cf_sifpdf action="addtoobject" text="/Height #session.pdf.graphics[i].height#">
				<cf_sifpdf action="addtoobject" text="/BitsPerComponent 8"> 
				<cf_sifpdf action="addtoobject" text="/ColorSpace /DeviceRGB"> 
				<cf_sifpdf action="addtoobject" text="/Length #len(session.pdf.graphics[i].imagefile)#"> 
				<cf_sifpdf action="addtoobject" text="/Filter DCTDecode">
				<!---	<cf_sifpdf action="addtoobject" text="/F << /FS /URL /F (#session.pdf.graphics[i].filename#) >> >>"> --->
				<cf_sifpdf action="addtoobject" text="stream">
				<cf_sifpdf action="addtoobject" text="#session.pdf.graphics[i].imagefile#">
				<cf_sifpdf action="addtoobject" text="endstream">
			<cf_sifpdf action="endobject">
			<cfset session.pdf.graphics[i].sect = ArrayLen(session.pdf.sections)>
		</cfloop>
        
        <cfloop index="i" from="1" to="#ArrayLen(session.pdf.pagecontents)#">
            <cf_sifpdf action="newobject">
                <cf_sifpdf action="addtoobject" text="<</Type /Page">    
                <cf_sifpdf action="addtoobject" text="/Parent #masterpages# 0 R">
				
				<!--- if this page has graphics, build the resource dictionary by hand 
				<cfif session.pdf.hasgraphics[i] is 1>
		         <cf_sifpdf action="addtoobject" text="/Resources <<">
        		   <cf_sifpdf action="addtoobject" text="/ProcSet [/PDF /Text /ImageB]">
					
					<cfset graphlist=' '>
					<cfloop from="1" to="#ArrayLen(session.pdf.graphics)#" index="a">
						<cfif session.pdf.graphics[a].page is i>
							<cfset graphlist=graphlist & session.pdf.graphics[a].pdfname & " ">
							<cfset graphlist=graphlist & session.pdf.graphics[a].sect>
							<cfset graphlist=graphlist & " 0 R ">
						</cfif>
					</cfloop>
					<cf_sifpdf action="addtoobject" text="/XObject <<#graphlist#>>">

		         <cf_sifpdf action="addtoobject" text="/Font <<">
                
		          <cfset a=1>
        		    <cfloop index="font" list="#session.pdf.fonts#" delimiters="|">
		            <cfset next_a = a + 1>
                  <cf_sifpdf action="addtoobject" text="/F#a# #next_a# 0 R">
        		      <cfset a = a + 1>
		          </cfloop>
        		    <cf_sifpdf action="addtoobject" text=">>">
		          <cf_sifpdf action="addtoobject" text=">>">
				<cfelse> --->
					 <!--- otherwise, link to the predefined one --->
	             <cf_sifpdf action="addtoobject" text="/Resources #session.pdf.resources# 0 R">
				<!--- </cfif> --->
				<cfif session.pdf.pageorient eq 'landscape'> <!--- 8 1/2 x 11 --->
					 <cf_sifpdf action="addtoobject" text="/MediaBox [0 0 612 792]">
				<cfelseif session.pdf.pageorient eq 'landscape'> <!--- 11 x 8/12 --->				 	 
					 <cf_sifpdf action="addtoobject" text="/MediaBox [0 0 792 612]">
				<cfelseif session.pdf.pageorient eq 'legal'>  <!--- 11 x 17 --->	 
					 <cf_sifpdf action="addtoobject" text="/MediaBox [0 0 792 1224]">
				</cfif>
            <cf_sifpdf action="addtoobject" text="/Contents [#session.pdf.pagecontents[i]#]">
            <cfif session.pdf.annots[i] is not ''>
                <cf_sifpdf action="addtoobject" text="/Annots [#trim(session.pdf.annots[i])#]">
            </cfif>
            <cf_sifpdf action="addtoobject" text=">>">
            <cf_sifpdf action="endobject">
        </cfloop>
        
        <cf_sifpdf action="newobject">
        <cf_sifpdf action="addtoobject" text="<</Type /Pages">
        <cf_sifpdf action="addtoobject" text="/Count #ArrayLen(session.pdf.pagecontents)#">
            
        <cfset kids="[">
		  <cfset sections=ArrayLen(session.pdf.sections) - 1>
        <cfloop index="i" from="#startpages#" to="#sections#">
            <cfset kids = kids & " #i# 0 R">
        </cfloop>
            
        <cf_sifpdf action="addtoobject" text="/Kids #kids# ]">
        <cf_sifpdf action="addtoobject" text=">>">
        <cf_sifpdf action="endobject">
    </cfcase>
	 
	 <!--- for each obj, write stream length --->
    <cfcase value="writecrossref">
        <cfset session.pdf.xrefstart=session.pdf.bytes>
        <cf_sifpdf action="addtoobject" text="xref">
        <cfset sects=ArrayLen(session.pdf.sections) + 1>
        <cf_sifpdf action="addtoobject" text="0 #sects#">
        <cf_sifpdf action="addtoobject" text="0000000000 65535 f">
        
        <cfloop from="1" to="#ArrayLen(session.pdf.sections)#" index="i">
            <cfset num=NumberFormat(session.pdf.sections[i], "0000000000")>
            <cf_sifpdf action="addtoobject" text="#num# 00000 n">
        </cfloop>
    </cfcase>
	 
	 <!--- output catalog obj --->
    <cfcase value="writecatalog">
        <cf_sifpdf action="newobject">
            <cf_sifpdf action="addtoobject" text="<</Type /Catalog">
            <cfset sects=ArrayLen(session.pdf.sections)-1>
            <cf_sifpdf action="addtoobject" text="/Pages #sects# 0 R">
            <cf_sifpdf action="addtoobject" text="/Outlines #session.pdf.outlines# 0 R">
            <cf_sifpdf action="addtoobject" text=">>">
        <cf_sifpdf action="endobject">
    </cfcase>
	 
	 <!--- output trailer obj --->
    <cfcase value="writetrailer">
        <cf_sifpdf action="addtoobject" text="trailer">
        <cf_sifpdf action="addtoobject" text="<<">
        <cfset sects=ArrayLen(session.pdf.sections)+1>
        <cf_sifpdf action="addtoobject" text="/Size #sects#">
        <cf_sifpdf action="addtoobject" text="/Root #ArrayLen(session.pdf.sections)# 0 R">
        <cf_sifpdf action="addtoobject" text="/Info 1 0 R">
        <cf_sifpdf action="addtoobject" text=">>">
        <cf_sifpdf action="addtoobject" text="startxref">
        <cf_sifpdf action="addtoobject" text="#numberformat(session.pdf.xrefstart,"0000000000")#">
        <cf_sifpdf action="addtoobject" text="#chr(37)##chr(37)#EOF">
    </cfcase>
	 
	 <!--- all processing for adding text --->
    <cfcase value="addtext">
        <cfif not IsDefined("Attributes.text")><cfabort></cfif>

        <cfif IsDefined("attributes.xInches")>
            <cfset x=attributes.xinches*72>
        <cfelseif IsDefined("attributes.xcm")>
			<cfset x=attributes.xcm*28.34>
		<cfelse>
            <cfif IsDefined("attributes.x")>
                <cfset x=attributes.x>
            <cfelse>
                <em>In cf_sifpdf:AddText, x or xInches must be specified</em><br>
                <cfabort>
            </cfif>
        </cfif>
    
        <cfif IsDefined("attributes.yInches")>
            <cfset y=attributes.yinches*72>
        <cfelseif IsDefined("attributes.ycm")>
			<cfset y=attributes.ycm*28.34>
		<cfelse>
            <cfif IsDefined("attributes.y")>
                <cfset y=attributes.y>
            <cfelse>
                <em>In cf_sifpdf:AddText, y or yInches must be specified</em><br>
                <cfabort>
            </cfif>
        </cfif>

        <cfparam name="attributes.fontnum" default="1">
        <cfparam name="attributes.fontsize" default="12">
        <cfparam name="attributes.spacing" default="0">
        <cfparam name="attributes.rendermode" default="0">
        <cfparam name="attributes.fillcolor" default="0 0 0">
        <cfparam name="attributes.outlinecolor" default="0 0 0">
        <cfparam name="attributes.width" default="1">
        <cfparam name="attributes.horizscale" default="100">
        
        <cfset attributes.text=Replace(attributes.text, "\", "\\", "ALL")>
        <cfset attributes.text=Replace(attributes.text, "(", "\(", "ALL")>
        <cfset attributes.text=Replace(attributes.text, ")", "\)", "ALL")>
        <cf_sifpdf action="addtostream" text="BT #attributes.outlinecolor# RG #attributes.fillcolor# rg #attributes.width# w /F#val(attributes.fontnum)# #attributes.fontsize# Tf #attributes.spacing# Tc #attributes.horizScale# Tz #attributes.rendermode# Tr #x# #y# Td (#attributes.text#) Tj ET">
    </cfcase>
	 
	 <!--- all processing for drawing a line --->
    <cfcase value="drawline">
        <cfif IsDefined("attributes.x1Inches")>
            <cfset x1=attributes.x1inches*72>
		<cfelseif IsDefined("attributes.x1cm")>
			<cfset x1=attributes.x1cm*28.34>
        <cfelse>
            <cfif IsDefined("attributes.x1")>
                <cfset x1=attributes.x1>
            <cfelse>
                <em>In cf_sifpdf:DrawLine, x1 or x1Inches must be specified</em><br>
                <cfabort>
            </cfif>
        </cfif>
    
        <cfif IsDefined("attributes.y1Inches")>
            <cfset y1=attributes.y1inches*72>
		<cfelseif IsDefined("attributes.y1cm")>
			<cfset y1=attributes.y1cm*28.34>
        <cfelse>
            <cfif IsDefined("attributes.y1")>
                <cfset y1=attributes.y1>
            <cfelse>
                <em>In cf_sifpdf:DrawLine, y1 or y1Inches must be specified</em><br>
                <cfabort>
            </cfif>
        </cfif>

        <cfif IsDefined("attributes.x2Inches")>
            <cfset x2=attributes.x2inches*72>
		<cfelseif IsDefined("attributes.x2cm")>
			<cfset x2=attributes.x2cm*28.34>
        <cfelse>
            <cfif IsDefined("attributes.x2")>
                <cfset x2=attributes.x2>
            <cfelse>
                <em>In cf_sifpdf:DrawLine, x2 or x2Inches must be specified</em><br>
                <cfabort>
            </cfif>
        </cfif>
    
        <cfif IsDefined("attributes.y2Inches")>
            <cfset y2=attributes.y2inches*72>
		<cfelseif IsDefined("attributes.y2cm")>
			<cfset y2=attributes.y2cm*28.34>
        <cfelse>
            <cfif IsDefined("attributes.y2")>
                <cfset y2=attributes.y2>
            <cfelse>
                <em>In cf_sifpdf:DrawLine, y2 or y2Inches must be specified</em><br>
                <cfabort>
            </cfif>
        </cfif>

        <cfparam name="attributes.width" default="1">
        <cfparam name="attributes.linecap" default="0">
        <cfparam name="attributes.color" default="0 0 0">
        <cfparam name="attributes.dashpattern" default="">
        
        <cf_sifpdf action="addtostream" text="#attributes.width# w">
        <cf_sifpdf action="addtostream" text="[#attributes.dashpattern#] 0 d">
        <cf_sifpdf action="addtostream" text="#x1# #y1# m">
        <cf_sifpdf action="addtostream" text="#x2# #y2# l">
        <cf_sifpdf action="addtostream" text="#attributes.color# RG">
        <cf_sifpdf action="addtostream" text="#attributes.linecap# J">
        <cf_sifpdf action="addtostream" text="S">
    </cfcase>
	 
	 <!--- all processing for drawing a rectangle --->
    <cfcase value="DrawRect">
        <cfif IsDefined("attributes.x1Inches")>
            <cfset x1=attributes.x1inches*72>
		<cfelseif IsDefined("attributes.x1cm")>
		    <cfset x1=attributes.x1cm*28.34>
        <cfelse>
            <cfif IsDefined("attributes.x1")>
                <cfset x1=attributes.x1>
            <cfelse>
                <em>In cf_sifpdf:DrawRect, x1 or x1Inches must be specified</em><br>
                <cfabort>
            </cfif>
        </cfif>
    
        <cfif IsDefined("attributes.y1Inches")>
            <cfset y1=attributes.y1inches*72>
		<cfelseif IsDefined("attributes.y1cm")>
			<cfset y1=attributes.y1cm*28.34>
        <cfelse>
            <cfif IsDefined("attributes.y1")>
                <cfset y1=attributes.y1>
            <cfelse>
                <em>In cf_sifpdf:DrawRect, y1 or y1Inches must be specified</em><br>
                <cfabort>
            </cfif>
        </cfif>

        <cfif IsDefined("attributes.x2Inches")>
            <cfset x2=attributes.x2inches*72>
		<cfelseif IsDefined("attributes.x2cm")>
            <cfset x2=attributes.x2cm*28.34>
		<cfelse>
            <cfif IsDefined("attributes.x2")>
                <cfset x2=attributes.x2>
            <cfelse>
                <em>In cf_sifpdf:DrawRect, x2 or x2Inches must be specified</em><br>
                <cfabort>
            </cfif>
        </cfif>
    
        <cfif IsDefined("attributes.y2Inches")>
            <cfset y2=attributes.y2inches*72>
		<cfelseif IsDefined("attributes.y2cm")>
		    <cfset y2=attributes.y2cm*28.34>
        <cfelse>
            <cfif IsDefined("attributes.y2")>
                <cfset y2=attributes.y2>
            <cfelse>
                <em>In cf_sifpdf:DrawRect, y2 or y2Inches must be specified</em><br>
                <cfabort>
            </cfif>
        </cfif>

        <cfset width=x2-x1>
        <cfset height=y2-y1>

        <cfparam name="attributes.width" default="1">
        <cfparam name="attributes.linecap" default="0">
        <cfparam name="attributes.outlinecolor" default="0 0 0">
        <cfparam name="attributes.fillcolor" default="0 0 0">
        
        <cf_sifpdf action="addtostream" text="#x1# #y1# #width# #height# re">
        <cf_sifpdf action="addtostream" text="#attributes.width# w">
        <cf_sifpdf action="addtostream" text="#attributes.linecap# J">
        <cf_sifpdf action="addtostream" text="#attributes.outlinecolor# RG">
        <cf_sifpdf action="addtostream" text="#attributes.fillcolor# rg">
        <cf_sifpdf action="addtostream" text="B">
    </cfcase>
	 
	 <!--- all processing for drawing a link (note that href is stored in pageappend (annotations)) --->
    <cfcase value="addlink">
        <cfif not IsDefined("Attributes.href")><cfabort></cfif>

        <cfif IsDefined("attributes.xInches")>
            <cfset x=attributes.xinches*72>
		<cfelseif IsDefined("attributes.xcm")>
			<cfset x=attributes.xcm*28.34>
        <cfelse>
            <cfif IsDefined("attributes.x")>
                <cfset x=attributes.x>
            <cfelse>
                <em>In cf_sifpdf:AddLink, x or xInches must be specified</em><br>
                <cfabort>
            </cfif>
        </cfif>
    
        <cfif IsDefined("attributes.yInches")>
            <cfset y=attributes.yinches*72>
		<cfelseif IsDefined("attributes.ycm")>
            <cfset y=attributes.ycm*28.34>		
        <cfelse>
            <cfif IsDefined("attributes.y")>
                <cfset y=attributes.y>
            <cfelse>
                <em>In cf_sifpdf:AddLink, y or yInches must be specified</em><br>
                <cfabort>
            </cfif>
        </cfif>
        
        <cfparam name="attributes.fontsize" default="12">
        <cfparam name="attributes.fontnum" default="1">
        <cfparam name="attributes.name" default="#attributes.href#">
        <cfparam name="attributes.spacing" default="0">
        <cfparam name="attributes.rendermode" default="0">
        <cfparam name="attributes.fillcolor" default="0 0 0">
        <cfparam name="attributes.outlinecolor" default="0 0 0">
        <cfparam name="attributes.outlinewidth" default="1">

        <cfif not IsDefined("attributes.width")>
            <cfset defwidth=val(attributes.fontsize) * 0.5 * Len(Attributes.name)>
            <cfset attributes.width=defwidth>
        </cfif>
        
        <cfparam name="attributes.border" default="1">
        
        <cfset llx=x>
        <cfset lly=y-3>
        <cfset urx=x+attributes.width>
        <cfset ury=y+attributes.fontsize -3>
        <cf_sifpdf action="addtext" fontnum="#attributes.fontnum#" fontsize="#attributes.fontsize#"
                text="#attributes.name#" x="#x#" y="#y#" spacing="#attributes.spacing#"
                rendermode="#attributes.rendermode#" fillcolor="#attributes.fillcolor#"
                outlinecolor="#attributes.outlinecolor#" width="#attributes.outlinewidth#">

        <cfset session.pdf.pageappend=session.pdf.pageappend & "<</Type /Annot /Subtype /Link /Rect [#llx# #lly# #urx# #ury#] /Border [ 0 0 #attributes.border# ] /A << /Type /Action /S /URI /URI (#attributes.href#) >> >>">
    </cfcase>
	 
	 <!--- all processing for a paragraph --->
    <cfcase value="startparagraph">
        <cfif IsDefined("attributes.xInches")>
            <cfset x=attributes.xinches*72>
		<cfelseif IsDefined("attributes.xcm")>
		    <cfset x=attributes.xcm*28.34>
        <cfelse>
            <cfif IsDefined("attributes.x")>
                <cfset x=attributes.x>
            <cfelse>
                <em>In cf_sifpdf:AddText, x or xInches must be specified</em><br>
                <cfabort>
            </cfif>
        </cfif>
    
        <cfif IsDefined("attributes.yInches")>
            <cfset y=attributes.yinches*72>
		<cfelseif IsDefined("attributes.ycm")>
		    <cfset y=attributes.ycm*28.34>
        <cfelse>
            <cfif IsDefined("attributes.y")>
                <cfset y=attributes.y>
            <cfelse>
                <em>In cf_sifpdf:AddText, y or yInches must be specified</em><br>
                <cfabort>
            </cfif>
        </cfif>

        <cfparam name="attributes.fontnum" default="1">
        <cfparam name="attributes.fontsize" default="12">
        <cfparam name="attributes.spacing" default="0">
        <cfparam name="attributes.rendermode" default="0">
        <cfparam name="attributes.fillcolor" default="0 0 0">
        <cfparam name="attributes.outlinecolor" default="0 0 0">
        <cfparam name="attributes.width" default="1">
        <cfparam name="attributes.horizscale" default="100">
        <cfif not isdefined("attributes.leading")><cfset attributes.leading=attributes.fontsize+2></cfif>
        
        <cf_sifpdf action="addtostream" text="BT">
        <cf_sifpdf action="addtostream" text="#attributes.outlinecolor# RG">
        <cf_sifpdf action="addtostream" text="#attributes.fillcolor# rg">
        <cf_sifpdf action="addtostream" text="#attributes.width# w">
        <cf_sifpdf action="addtostream" text="/F#val(attributes.fontnum)# #attributes.fontsize# Tf">
        <cf_sifpdf action="addtostream" text="#attributes.spacing# Tc">
        <cf_sifpdf action="addtostream" text="#attributes.horizScale# Tz">
        <cf_sifpdf action="addtostream" text="#attributes.rendermode# Tr #attributes.leading# TL">
        <cf_sifpdf action="addtostream" text="#x# #y# Td">
    </cfcase>
    <cfcase value="endparagraph">
        <cf_sifpdf action="addtostream" text="ET">
    </cfcase>
    <cfcase value="addtoparagraph">
        <cfif isdefined("attributes.text")>
            <!--- escape metacharacters --->
            <cfset attributes.text=Replace(Replace(Replace(attributes.text, "\", "\\", "ALL"), "(", "\(", "ALL"), ")", "\)", "ALL")>

            <!--- strip extra whitespace --->
            <cfset attributes.text=Replace(Replace(attributes.text, chr(13), " ", "all"), chr(9), " ", "all")>
            <cfloop list="#attributes.text#" index="line" delimiters="#chr(10)#">
                <cf_sifpdf action="addtostream" text="(#trim(line)#) '">
            </cfloop>
        </cfif>
    </cfcase>
	 
	 <!---
	 <cfcase value="addimage">
		<cfif IsDefined("attributes.filename") and IsDefined("attributes.width") and IsDefined("attributes.height")>
	        <cfif IsDefined("attributes.xInches")>
        	    <cfset x=attributes.xinches*72>
    	    <cfelse>
	       	    <cfif IsDefined("attributes.x")>
    	            <cfset x=attributes.x>
	            <cfelse>
            	    <em>In cf_sifpdf:AddImage, x or xInches must be specified</em><br>
        	        <cfabort>
    	        </cfif>
	        </cfif>
    
        	<cfif IsDefined("attributes.yInches")>
    	        <cfset y=attributes.yinches*72>
	        <cfelse>
        	    <cfif IsDefined("attributes.y")>
    	            <cfset y=attributes.y>
	            <cfelse>
            	    <em>In cf_sifpdf:AddImage, y or yInches must be specified</em><br>
        	        <cfabort>
    	        </cfif>
	        </cfif>

			<cfset i=ArrayLen(session.pdf.graphics) + 1>
			<cfset session.pdf.graphics[i]=StructNew()>
			<cfset session.pdf.graphics[i].filename=attributes.filename>
			<cfset session.pdf.graphics[i].width=attributes.width>
			<cfset session.pdf.graphics[i].height=attributes.height>
			<cfset session.pdf.graphics[i].page=session.pdf.curpage>
			<cfset session.pdf.graphics[i].pdfname="/Im"&i>
			<cfset session.pdf.hasgraphics[session.pdf.curpage]=1>
			
			<cffile action="READ" file="#attributes.filename#" variable="session.pdf.graphics[i].imagefile">
 			
			<cf_sifpdf action="addtostream" text="q">
			<cf_sifpdf action="addtostream" text="132 0 0 132 #x# #y# cm">
			<cf_sifpdf action="addtostream" text="#session.pdf.graphics[i].pdfname# Do">
			<cf_sifpdf action="addtostream" text="Q">
 		</cfif>

		
Graphics notes/best guesses

for each array instance of session.pdf.graphics[i] we need this object	
X 0 obj (where X is the next available object)
<</Type /XObject 
/Subtype /Image 
/Name /#session.pdf.graphics[i].pdfname# 
/Width #session.pdf.graphics[i].width# 
/Height #pdfgraphics[i].height#
/BitsPerComponent 8 
/Length #lengthOfCffileReadInputVar#
/Filter /FlateDecode 
/ColorSpace /DeviceGray 
>> 
stream
--- Insert image data from CFFile here ---
endStream
endObj

in the Contents object for the page...
for each array instance of session.pdf.graphics, we need a q...Q 
stream...
q
132 0 0 132 #x# #y# cm
/#session.pdf.graphics[i].pdfname# Do
Q
...endstream	

in the Resource Dictionary object for the page...
for each array instance of session.pdf.graphics, we need the contents after /XObject
Y 0 obj
<< /ProcSet [/PDF /ImageB]
	/XObject << /#session.pdf.graphics[i].pdfname# X 0 R >>
				<< /#session.pdf.graphics[i].pdfname# Z 0 R >>....
>>
endobj

in the Page object we need the reference to the Resources object
...
/Resources Y 0 R
...		
  
	</cfcase> ---> 
	<cfdefaultcase>
        <em>No action="" specified for cf_sifpdf!</em>
        <cfabort>
    </cfdefaultcase>
</cfswitch>