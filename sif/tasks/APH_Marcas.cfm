<cfsetting enablecfoutputonly="yes">

<cfset destination = "c:/inetpub/ftproot/marcador">
<cfparam name="form.quien" default="nadie">

<cftry>
	<cfif form.quien NEQ 'yo'>
        <cfthrow message="No te conozco, ¿cómo te llamas?">
    </cfif>

    <cffile
        action = "upload"
        destination = "#destination#"
        fileField = "marcas"
        nameconflict="overwrite">

    <cfoutput>archivo recibido #DateFormat(Now(), "yyyy-mm-dd")#: #cffile.serverFile#, fileSize = #cffile.fileSize#, fileWasOverwritten = #cffile.fileWasOverwritten#</cfoutput>
<cfcatch type="any">
	<cfoutput>#cfcatch.message#</cfoutput>
</cfcatch></cftry>
