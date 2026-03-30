
<cfset vsPath_R = "#ExpandPath( GetContextRoot() )#">
<cfif REFind('(cfmx)$',vsPath_R) gt 0> 
	<cfset vsPath_R = "#Replace(vsPath_R,'cfmx','')#"> 
<cfelse> 
	<cfset vsPath_R = "#vsPath_R#\">
</cfif>

<cfif form.CODIGOSELECT neq '' && form.WhatToDo eq 'CTA' >

	<cfset dir = CheckDir("#vsPath_R#DocCortes")>
	
	
	<cfif form.Tipo eq 'TM'>
		<cfset dir = CheckDir("#vsPath_R#DocCortes\TM#corteAnno#_#form.CodigoSelect#")>
		<cfset dirPath="#vsPath_R#DocCortes\TM#corteAnno#_#form.CodigoSelect#\#corteAnno#">
	<cfelse>
		<cfset dir = CheckDir("#vsPath_R#DocCortes\#form.CodigoSelect#")>
		<cfset dirPath="#vsPath_R#DocCortes\#form.CodigoSelect#\">
	</cfif>


	<cfset fileName="#form.CodigoSelect#_#form.numeroCuenta#">
	<cfset filePath="#dirPath##fileName#.pdf">

	<cfset codigoCorte = form.CodigoSelect>
	<cfif form.Tipo eq 'TM'>
		<cfset codigoCorte = "#form.corteanno#,#form.CodigoSelect#">
	</cfif>
	
	<cfif !FileExists(filePath) || isDefined('form.regenerar')>
		<cfset objEstadoCuenta = createObject( "component","crc.Componentes.CRCEstadosCuenta")>
		<cfset pdf = objEstadoCuenta.createEstadoCuenta(
				CodigoSelect	= "#codigoCorte#"
			,	Tipo			= "#form.Tipo#"
			,	CuentaId		= "#form.id#"
			,	dsn				= "#session.dsn#"
			,	ecodigo			= session.ecodigo
			,	saveAs			= "#fileName#"
			)>
	</cfif>
	
	<cfheader name="Content-Disposition" value="attachment; filename=#fileName#.pdf">
	<cfcontent type="text/html" file="#filePath#" deletefile="no" reset="yes"> 

<cfelseif form.WhatToDo eq 'URP'>
	
	<cfquery name="q_ultCorteCerrado" datasource ="#session.dsn#">
		select codigo from CRCCortes where tipo = '#Trim(form.Tipo)#' and status = 1;
	</cfquery>

	<cfif q_ultCorteCerrado.RecordCount eq 0>
		<cfthrow message="No existen cortes cerrados para esta cuenta">
	</cfif>
	
	<cfset codCorte = q_ultCorteCerrado.codigo>
	<cfset dir = CheckDir("#vsPath_R#DocCortes")>
	<cfset dir = CheckDir("#vsPath_R#DocCortes\#codCorte#")>
	
	<cfset dirPath="#vsPath_R#DocCortes\#codCorte#\">

	<cfset fileName="#form.CodigoSelect#_#form.id#RP">
	<cfset filePath="#dirPath##fileName#.pdf">
	<cftry>
		<cfif FileExists(filePath)>
			<cffile action="delete" file="#filePath#">
		</cfif>
	<cfcatch type="any">
	</cfcatch>
	</cftry>
	<cfif !FileExists(filePath) || isDefined('form.regenerar')>
		<cfset objEstadoCuenta = createObject( "component","crc.Componentes.CRCEstadosCuenta")>
		
		<cfset pdf = objEstadoCuenta.createReciboPago(
				CodigoSelect	= "#form.CodigoSelect#"
			,	CuentaId		= "#form.id#"
			,	dsn				= "#session.dsn#"
			,	ecodigo			= session.ecodigo
			,	saveAs			= "#fileName#"
			)>
	</cfif>
	
	<cfheader name="Content-Disposition" value="attachment; filename=#fileName#.pdf">
	<cfcontent type="text/html" file="#filePath#" deletefile="no" reset="yes"> 
</cfif>

<cffunction  name="checkDir">
	<cfargument  name="path" required="true">
	<cfif !DirectoryExists("#arguments.path#") >
		<cfset DirectoryCreate("#arguments.path#")>
	</cfif>
</cffunction>