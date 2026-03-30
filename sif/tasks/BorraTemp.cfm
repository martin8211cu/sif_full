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
	<cfif   startTime - f.lastModified() GTE 432000000 <!--- 5 dias --->
	   OR ( startTime - f.lastModified() GTE 600000 <!--- 10 minutos ---> AND (
		  findnocase(".jpg",name) GT 0 or findnocase(".jpeg",name) GT 0 or findnocase(".gif",name) GT 0 
	   or findnocase(".bmp",name) GT 0 or findnocase("mail",name) EQ 1))>
		<cftry>
			<!--- mantener archivos por diez minutos 
			      Modificado por danim para que use java para la fecha
				  y funcione en todos los locales --->
			<cfif ucase(type) EQ 'DIR'>
				<cfdirectory action="delete" directory="#GetTempDirectory()##name#" recurse="yes">
			<cfelseif (startTime - f.lastModified()) GTE (600000)>
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

<cfapplication name="SIF_ASP">
<cfquery name="rsCaches" datasource="asp">
	select distinct c.Ccache
	from Empresa e, Caches c
	where c.Cid = e.Cid
</cfquery>
<cfset deleteTables = 0>
<cfset keptTables = 0>
<cfloop query="rsCaches">
	<cfif structKeyExists(Application.dsinfo,rsCaches.Ccache)>
		<cfset LvarDBtype = Application.dsinfo[rsCaches.Ccache].type>
		<cfset LvarDBschema = Application.dsinfo[rsCaches.Ccache].schema>
		
		<cfquery name="rsSQL" datasource="#rsCaches.Ccache#">
			<cfif ListFind('sybase,sqlserver', LvarDBtype)>
				select name, crdate
				  from sysobjects
				 where type = 'U'
				   and lower(name) like 'tm%'
			<cfelseif LvarDBtype is 'oracle'>
				select object_name as name, created as crdate
				  from all_objects
				 where object_type = 'TABLE'
				   and lower(object_name) like 'tm%'
			<cfelseif LvarDBtype is 'db2'>
				select tabname as name, create_time as crdate
				  from syscat.tables 
				 where tabschema = '#LvarDBschema#'
				   and lower(tabname) like 'tm%'
			<cfelse>
				<cf_errorCode	code = "50628"
								msg  = "DBMS no soportado: @errorDat_1@"
								errorDat_1="#LvarDBtype#"
				>
			</cfif>
		</cfquery>
		<cfloop query="rsSQL">
			<cfif reFindNocase('^tm[0-9]+$', rsSQL.name)>
				<cfif datediff("d",rsSQL.crdate, now()) GT 4>
					<cftry>
						<cfquery datasource="#rsCaches.Ccache#">
							drop table #rsSQL.name#
						</cfquery>
						<cfset deleteTables = deleteTables + 1>
					<cfcatch type="any"><cfoutput>#cfcatch.Message#<br></cfoutput>
					</cfcatch>
					</cftry>
				<cfelse>
					<cfset keptTables = keptTables + 1>
				</cfif>
			</cfif>
		</cfloop>
	</cfif>
</cfloop>

<cfset finished = Now()>
<cfoutput><br>Duracion: #System.currentTimeMillis() - startTime# ms <br>
Archivos eliminados: #deletedFiles#<br>
Archivos conservados: #keptFiles#<br>
<br>
Tablas temporales 'tm9999' eliminadas: #deleteTables#<br>
Tablas temporales 'tm9999' conservadas: #keptTables#<br>
</cfoutput>


