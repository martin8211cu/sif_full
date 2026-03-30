<cfset LvarIMG = ExpandPath(url.f)>
<cfif REFindNoCase("^(/[A-Z_0-9]+)+(\.GIF)|(\.JPG)|(\.JPEG)|(\.BMP)|(\.PNG)|(\.TIF)|(\.TIFF)$",url.f,1,"false") EQ 0 
   OR NOT FileExists(LvarIMG)>
	<cfcontent type="image/gif" file="xxx" deletefile="no">
	<!--- <cflocation url="not_avail.gif" addtoken="no"> --->
<cfelse>
	<!--- nunca expira, invocar con ts_rversion como parte del url --->
	<cfset getPageContext().getResponse().setHeader("Expires","Thu, 31 Dec 2099 00:00:00 GMT")>
	<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
	<cfcontent type="image/gif" file="#LvarIMG#" deletefile="no">
</cfif>
