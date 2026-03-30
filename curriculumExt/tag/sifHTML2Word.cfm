<!--- 
*** Genera un Archivo de Word con el HTML entre los TAGS
*** Para que el Archivo pueda ser abierto por Word, este debe de tener instalados los filtros para HTML.
*** Hecho por: Marcel de Mézerville L.
---> 
<style type="text/css">
	@media print {
	.noprint {
		display: none;
	}
	} 
</style>
<CFPARAM NAME="Attributes.Directory" DEFAULT="#GetTempDirectory()#">
<CFPARAM NAME="Attributes.FileName" DEFAULT="#session.Ecodigo#_#session.Usucodigo#_#Session.Ulocalizacion#_#DateFormat(Now(),'yyyymmdd')#_#Replace(Replace(TimeFormat(Now(),'medium'),':','_','all'),' ','_','all')#">
<CFPARAM NAME="Attributes.Titulo" DEFAULT="">  <!--- Titulo del portlet que se muestra si ocurre un error --->
<CFPARAM NAME="Attributes.DEBUG" DEFAULT="N">

<CFIF ThisTag.HasEndTag>
    <CFSWITCH EXPRESSION="#ThisTag.ExecutionMode#">
    
        <CFCASE VALUE="START">
            <CFSET HTMLFileName = Attributes.FileName>
            <CFSET HTMLFilePath = Attributes.Directory & HTMLFileName  & ".xls">
		
            <!--- Delete any files that have the same names --->
            <CFIF FileExists(HTMLFilePath)>
                <CFTRY>
                    <CFFILE ACTION="DELETE" FILE="#HTMLFilePath#">
                <CFCATCH TYPE="Any">            
                </CFCATCH>
                </CFTRY>
            </CFIF>
            <CFFILE ACTION="WRITE" FILE="#HTMLFilePath#"  nameconflict="overwrite" OUTPUT="<HTML><TITLE>#Attributes.FileName#<TITLE><HEAD>">
            <CFFILE ACTION="read" FILE="#ExpandPath(session.sitio.css)#" variable="salida">
			<CFFILE ACTION="Append" FILE="#HTMLFilePath#"  OUTPUT="<style>#salida#</style><meta http-equiv='content-type' content='text/html; charset=utf-8'></HEAD><BODY>">

			<cfif not isdefined("url.imprimir")>
				<div align="right">
				<A href="/UtilesExt/sifHTML2Wordcont.cfm<cfoutput>?Archivo=#Attributes.FileName#&Titulo=#Attributes.Titulo#</cfoutput>">
					<img src="/imagenes/Cfinclude.gif" border="0"  alt="Documento en Formato MS Excel">
				</A>
				</div>
			</cfif>
		
			<cfif Attributes.DEBUG EQ "S"><cfoutput>&nbsp;#HTMLFilePath#</cfoutput></cfif>

        </CFCASE>
        
        <CFCASE VALUE="END">
            <!--- write the HTML file to disk (contains the generated content) --->
			<!--- comentado danim;21-nov-2005 para que no consuma tanta memoria con contenidos grandes
			<cfset miHTML = REReplace(ThisTag.GeneratedContent,"<[aA] [^>]*>","","all")>
			<cfset miHTML = REReplace(mihtml,"</[aA]>","","all")>
			<CFFILE ACTION="append" FILE="#HTMLFilePath#" addnewline="yes" OUTPUT="#miHTML#">
			--->
			<CFFILE ACTION="append" FILE="#HTMLFilePath#" addnewline="yes" OUTPUT="#ThisTag.GeneratedContent#">
			<CFFILE ACTION="append" FILE="#HTMLFilePath#"  addnewline="yes" OUTPUT="</BODY></HTML>">
			<!--- OJO: Modificado por Marcel, esto hace que solamente se genere el archivo, no la salida a pantalla...--->
            <!--- <CFSET ThisTag.GeneratedContent = ""> --->
        </CFCASE>
    </CFSWITCH>
<CFELSE>
    <PRE>
    Error: Este tag requiere de un TAG de cierre!!!!
    Uso:
    <FONT COLOR="MAROON">&lt;CF_sifHTML2WORD&gt;</FONT>
    Codigo de HTML que se desea generar en Formato de Word...
    <FONT COLOR="MAROON">&lt;/CF_sifHTML2WORD</FONT>
    <BR>
    Problemas? Contacte al autor:&nbsp;<A HREF="mailto:marcelm@soin.co.cr?Subject=cf_sifhtml2word">marcelm@soin.co.cr</A>
    </PRE> 
</CFIF>

