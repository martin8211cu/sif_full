
<!--- 
	Implementacion para Control de Concurrencia: Multiusuario
	
	Se borran todos los directorios que no sean del dia (para no llenar el disco duro)
	Se crea un directorio para el da YYYYMMDD
	Se crea un archivo XML con nombre unico 
	Se invoca al flash movie
	Se fuerza a que se recargue con el nuevo archivo
--->
<cfparam name="Attributes.movie" 		type="String">
<cfparam name="Attributes.XMLfilename" 	type="String">
<cfparam name="Attributes.XMLvalue" 	type="String">
<cfparam name="Attributes.name" 		type="String" default="myMovieName">
<cfset Attributes.movie = replace(Attributes.movie, ".swf", "", "ALL")>
<cfif not find(".xml",Attributes.XMLfilename)>
	<cfset Attributes.XMLfilename = Attributes.XMLfilename & ".xml">
</cfif>

<cfset LvarDir	= GetDirectoryFromPath(GetCurrentTemplatePath())>
<cfset LvarDir1 = dateFormat(now(),"YYYYMMDD")>
<cfset LvarHoy 	= createDate(mid(LvarDir1,1,4),mid(LvarDir1,5,2), mid(LvarDir1,7,2))>
<cfset LvarDir2 = LvarDir& "/" & LvarDir1>


<!---
	BORRA DEL DISCO DURO LOS ARCHIVOS GENERADOS 2 DIAS ATRAS
	con el fin de que no se llene el disco duro del servidor
--->
<cfdirectory action="LIST" directory="#LvarDir#" name="rsDir" recurse="no">
<!---
	#rsDir.name#				Nombre del Archivo o Directorio
	#rsDir.directory#			Directorio al que pertenece el Archivo o Directorio
	#rsDir.size#				Tamao 
	#rsDir.type#				File o Dir
	#rsDir.dateLastModified#	Ultima modificacion
	#rsDir.Attributes#			Atributos
	#rsDir.mode# 				N/A
--->
<cfoutput>
<cfloop query="rsDir">
	<cfif rsDir.type EQ "Dir">
		<cftry>
			<cfset LvarDate = "">
			<cfset LvarDate = createDate(mid(rsDir.Name,1,4),mid(rsDir.Name,5,2), mid(rsDir.Name,7,2))>
			
			<cfif DateDiff("d",LvarDate,LvarHoy) GT 1>
				<cfdirectory action="delete" directory="#LvarDir##rsDir.Name#" recurse="yes">
			</cfif>
		<cfcatch type="any">
			<cfif LvarDate NEQ "">
				ERROR Borrando Directorio #rsDir.Name#:&nbsp;: #cfcatch.Message#<BR />
			</cfif>
		</cfcatch>
		</cftry>
	</cfif>
</cfloop>
</cfoutput>


<!---
	CREA EN EL DISCO DURO UN DIRECTORIO CON LA FECHA DE HOY
	con el fin de guardar los archivos generados hoy
--->
<cfif NOT DirectoryExists(LvarDir2)>
	<cfdirectory action="create" directory="#LvarDir2#">
</cfif>

<!---
	GENERA EN EL DISCO EL ARCHIVO XML con nombre unico
	Unicamente una persona puede generar el archivo al mismo tiempo, 
	una segunda persona utiliza el mismo archivo generado por la primera
--->
<cflock scope="application" type="exclusive" timeout="1" throwontimeout="no">
	<cfset LvarFileName = "#LvarDir2#/#Attributes.XMLfilename#">
	<cffile 
		action		= "write"
		nameconflict= "overwrite" 
		file		= "#LvarFileName#"
		output		= "#Attributes.XMLvalue#"
	>
</cflock>

<!---

	CREA LA INVOCACION AL FLASH, recargando el XML generado
--->
<cfset LvarFileName = "#LvarDir1#/#Attributes.XMLfilename#">
<cfoutput>
<script type="text/javascript">
	AC_FL_RunContent( 'codebase','http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab##version=7,0,19,0','width','100%','height','90%','id','#Attributes.name#','src','Brecha','quality','high','bgcolor','##FFFFFF','name','#Attributes.name#','align','','pluginspage','http://www.macromedia.com/go/getflashplayer','movie','#Attributes.movie#','_xmlurl','#LvarFileName#' ); //end AC code
</script>
<noscript>
	<OBJECT classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
		codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab##version=7,0,19,0"
		WIDTH="100%" HEIGHT="90%" id="#Attributes.name#"
	>
		<PARAM NAME=movie VALUE="#Attributes.movie#.swf"> 
		<PARAM NAME=quality VALUE=high>
		<PARAM NAME=bgcolor VALUE=##FFFFFF>
		<PARAM NAME=_xmlUrl VALUE="#LvarFileName#">
		<EMBED  src="#Attributes.movie#.swf" quality=high bgcolor=##FFFFFF WIDTH="100%" HEIGHT="100%" 
				NAME="#Attributes.name#" ALIGN="" TYPE="application/x-shockwave-flash" 
				PLUGINSPAGE="http://www.macromedia.com/go/getflashplayer">
		</EMBED>
	</OBJECT>
</noscript>
<script type="text/javascript">
	<cfoutput>
	document.#Attributes.name#.SetVariable("_xmlUrl", "#LvarFileName#");
	document.#Attributes.name#.TCallLabel("/","LoadXML");
	</cfoutput>
</script>
</cfoutput>
