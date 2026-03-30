<cfsetting enablecfoutputonly="yes">
<cfobject action="create" type="java" class="java.lang.System" name="System">
<cfset deletedFiles = 0>
<cfset keptFiles = 0>
<cfset startTime = System.currentTimeMillis()>
<cfoutput>GetTempDirectory: #GetTempDirectory()#<br>
Fecha: #LSDateFormat(Now())# #LSTimeFormat(Now())#<br>
System.currentTimeMillis (startTime): #NumberFormat(startTime)#<br></cfoutput>

<!--- Vaciar carpeta de documentos sin enviar cfmail --->
<cfset Undelivr = ExpandPath('/WEB-INF/cfusion/Mail/Undelivr/')>
<cfdirectory action="list" directory="#Undelivr#" name="lista">
<cfloop query="lista">
	<cftry>
		<cfset deletedFiles = deletedFiles + 1>
		<cffile action="delete" file="#Undelivr##lista.name#">
		<cfcatch type="any"><cfoutput>#cfcatch.Message#<br></cfoutput>
		</cfcatch>
	</cftry>
</cfloop>

<!--- Vaciar carpeta de imagenes y archivos temporales --->
<cfdirectory action="list" directory="#GetTempDirectory()#" name="lista">
<cfloop query = "lista">
	<cfobject action="create" type="java" class="java.io.File" name="f">
	<cfset f.init(GetTempDirectory() & lista.name)>
	<cfif findnocase(".jpg",name) GT 0 or findnocase(".jpeg",name) GT 0 or findnocase(".gif",name) GT 0 
	   or findnocase(".bmp",name) GT 0 or findnocase(".doc",name) GT 0 or findnocase(".html",name) GT 0
	   or findnocase(".xls",name) GT 0 or findnocase(".csv",name) GT 0 or findnocase(".txt",name) GT 0 
	   or findnocase("mail",name) EQ 1>
		<cftry>
			<!--- mantener archivos por diez minutos 
			      Modificado por danim para que use java para la fecha
				  y funcione en todos los locales --->
			<cfif (startTime - f.lastModified()) GTE (600*1000)>
				<cfset deletedFiles = deletedFiles + 1>
				<cfset f.delete()> 
			<cfelse>
				<cfset keptFiles = keptFiles + 1>
			</cfif>
			<cfcatch type="any"><cfoutput>#cfcatch.Message#<br></cfoutput>
			</cfcatch>
		</cftry>
	<cfelse>
		<cfset keptFiles = keptFiles + 1>
	</cfif>
</cfloop>

<cfset finished = Now()>
<cfoutput><br>Duracion: #System.currentTimeMillis() - startTime# ms <br>
Archivos eliminados: #deletedFiles#<br>
Archivos conservados: #keptFiles#<br>
</cfoutput>
