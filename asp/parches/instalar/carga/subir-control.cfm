<cfinvoke component="asp.parches.comp.parche" method="dirparches" returnvariable="dirparches" />
<cfparam name="form.nameconflict" default="skip">
<cfif Not ListFind('skip,overwrite', form.nameconflict)>
	<cfset form.nameconflict = "skip">
</cfif>
<cffile action="upload" filefield="jarfile"
	destination="#dirparches#" nameconflict="#form.nameconflict#">

<cfif cffile.FileExisted and Not cffile.FileWasSaved>
	<cflocation url="subir.cfm?jarfile=# URLEncodedFormat( ClientFile )#&existe=1">
</cfif>

<cfinvoke component="asp.parches.comp.jar" method="unjar" jarfile="#dirparches#/#cffile.serverfile#"
	destdir="#dirparches#/#cffile.serverfilename#"/>

<cffile action="read" file="#dirparches#/#cffile.serverfilename#/#cffile.serverfilename#.xml" variable="xml">

<cfset session.instala = StructNew()>

<cfinvoke component="asp.parches.comp.instala" method="cargar_parche_jar"
	nombre="#cffile.serverfilename#" xml="#XmlParse(xml)#" />
	
<cflocation url="ver.cfm">