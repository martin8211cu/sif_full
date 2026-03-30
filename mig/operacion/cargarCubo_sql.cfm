<cfif isdefined("url.btnDims") OR isdefined("url.btnMets") OR isdefined("url.btnInds")>
	<cfset LvarOBJ=createObject("component", "mig.Componentes.utils")>
	<cfset DSNorigen	= "#session.dsn#">
	<cfset DSNdestino	= "#session.dsn#">
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select Pvalor from Parametros where Pcodigo = 2000
	</cfquery>
	<cfif rsSQL.Pvalor NEQ "">
		<cfset DSNdestino = rsSQL.Pvalor>
	</cfif>
	<cfif isdefined("url.btnMets")>
		<cfset LvarOBJ.sbCalcularAcumulados(session.dsn)>
	<cfelseif isdefined("url.btnInds")>
		<cfset LvarOBJ.sbCalcularResumenes(session.dsn)>
	</cfif>
	<cfthread name="mig_Dimensiones" action="run">
		<cftry>
			<cfif isdefined("url.btnDims")>
				<cfset sbBorrar("Dimensiones.html")>
				<cfset sbBorrar("Metricas.html")>
				<cfset sbBorrar("Indicadores.html")>

				<cfset LvarOBJ.start("Dimensiones")>
				<cfinclude template="cargarCubo_sql_dims.cfm">
			<cfelseif isdefined("url.btnMets")>
				<cfset sbBorrar("Metricas.html")>
				<cfset sbBorrar("Indicadores.html")>

				<cfset LvarOBJ.start("Metricas")>
				<cfinclude template="cargarCubo_sql_facts.cfm">
			<cfelseif isdefined("url.btnInds")>
				<cfset sbBorrar("Indicadores.html")>

				<cfset LvarOBJ.start("Indicadores")>
				<cfinclude template="cargarCubo_sql_facts.cfm">
			</cfif>
		<cfcatch type="any">
			<cfset LvarError = "">
			<cfif isdefined("cfcatch.TagContext")>
				<cfset LvarError = cfcatch.TagContext[1].Template>
				<cfset LvarError = REReplace(mid(LvarError,find(expandPath("/"),LvarError),100),"[/\\]","/ ","ALL") & ": " & cfcatch.TagContext[1].Line>
			</cfif>
			<cffile action="append" file="#Application.mig_prcs.Err#" output="Proceso de Carga cancelado por un Error de Ejecución, #DateFormat(now(),"DD/MM/YYYY")# #TimeFormat(now(),"HH:MM:SS")#" addnewline="yes">
			<cffile action="append" file="#Application.mig_prcs.Err#" output="#cfcatch.Message#: #cfcatch.Detail# #LvarError#" addnewline="yes">
		</cfcatch>
		</cftry>
		<cfset LvarOBJ.end()>
	</cfthread>
<cfelseif isdefined("form.btnCANCEL")>
	<cfset createObject("component", "mig.Componentes.utils").cancel()>

<cfelseif isdefined("url.ERR_D")>
	<!--- Download de Errores del Script --->
	<cfset LvarErrD = expandPath("/mig/operacion/Dimensiones_err.txt")>
	<cfheader name="Content-Disposition"	value="attachment;filename=Dimensiones_Err.txt">
	<cfcontent type="text/plain" reset="yes" file="#LvarErrD#" deletefile="no">
<cfelseif isdefined("url.ERR_M")>
	<!--- Download de Errores del Script --->
	<cfset LvarErrM = expandPath("/mig/operacion/Metricas_err.txt")>
	<cfheader name="Content-Disposition"	value="attachment;filename=Metricas_Err.txt">
	<cfcontent type="text/plain" reset="yes" file="#LvarErrM#" deletefile="no">
<cfelseif isdefined("url.ERR_I")>
	<!--- Download de Errores del Script --->
	<cfset LvarErrI = expandPath("/mig/operacion/Indicadores_err.txt")>
	<cfheader name="Content-Disposition"	value="attachment;filename=Indicadores_Err.txt">
	<cfcontent type="text/plain" reset="yes" file="#LvarErrI#" deletefile="no">
</cfif>

<cflocation url="cargarCubo.cfm">
<cffunction name="sbBorrar" output="no" access="private">
	<cfargument name="html">

	<cfset LvarHtml = expandPath("/mig/operacion/#arguments.html#")>
	<cfif FileExists(LvarHtml)>
		<cffile action="delete" file="#LvarHtml#">
	</cfif>
</cffunction>