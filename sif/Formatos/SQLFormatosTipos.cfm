<cffunction name="fnUriNotExists" output="false" returntype="struct">
	<cfargument name="pUri" type="string" required="yes">
	<cfargument name="pTipo" type="string" required="yes">

	<cfset pUri = trim(pUri)>
	<cfif pTipo EQ 'O'>
		<cfset LvarUri.NotExists = 0>
		<cfset LvarUri.Uri = pUri>
		<cfreturn LvarUri>
	</cfif>

	<cfset LvarCFile = ExpandPath(pUri)>
	<cfset LvarJFile = CreateObject("java", "java.io.File")>
	<cfset LvarJFile.init(LvarCFile)>
	<cfif not LvarJFile.exists()>
		<cfset LvarUri.NotExists = 2>
		<cfset LvarUri.Uri = "">
	<cfelse>
		<cfset LvarUri.NotExists = 0>
		<cfif pTipo EQ 'P'>
			<cfif not FileExists(LvarCFile)>
				<cfset LvarUri.NotExists = 2>
				<cfset LvarUri.Uri = "">
			</cfif>
		<cfelse>
			<cfset LvarCFile = mid(LvarCFile,1,len(LvarCFile)-1)>
			<cfif not DirectoryExists(LvarCFile)>
				<cfset LvarUri.NotExists = 2>
				<cfset LvarUri.Uri = "">
			</cfif>
		</cfif>
		<cfif LvarUri.NotExists EQ 0>
			<cfset LvarIni = len(ExpandPath(""))+1>
			<cfset LvarJSFile = mid(LvarJFile.getCanonicalPath(),LvarIni,1000)>
			<cfset LvarCFile = mid(LvarCFile,LvarIni,1000)>
			<cfif LvarJSFile.equals(LvarCFile)>
				<cfset LvarUri.NotExists = 0>
			<cfelse>
				<cfset LvarUri.NotExists = 1>
			</cfif>
			<cfset LvarUri.Uri = replace(LvarJSFile,"\","/","ALL")>
		</cfif>
	</cfif>
	<cfreturn LvarUri>
</cffunction>

		<cfif isdefined("Form.Alta") or isdefined("Form.Cambio") >
			<cfif len(trim(form.TFcfm))>
				<cfset LvarUri = fnUriNotExists(form.TFcfm, 'P')>
				<cfif LvarUri.NotExists gt 0>
					<cfthrow detail="Error. El archivo cfm indicado para la consulta no existe, por favor verifique sus datos.">
				</cfif>
			</cfif>
		</cfif>


<cfif isdefined("Form.TFsql") and len(trim(Form.TFsql))>
	<cfset Form.TFsql = replaceNocase(Form.TFsql,"/SET","SET")>
</cfif>

<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfif isdefined("Form.Alta")>
			<cfquery name="rsConsecutivo" datasource="#Session.DSN#">
				select (coalesce(max(TFid), 0)+1) as consetivo from TFormatos
			</cfquery>

			<cfquery name="ABC_FormatosTipos" datasource="#Session.DSN#">
				insert into TFormatos(TFid,TFdescripcion, Usucodigo, Ulocalizacion, TFfecha, TFsql, TFcfm, Ecodigo, TFUso)
				values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsConsecutivo.consetivo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TFdescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Form.TFsql#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TFcfm#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.TFUso#">
					)
			</cfquery>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="ABC_FormatosTipos" datasource="#Session.DSN#">
				delete from TFormatos
				where TFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TFid#">
				and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="ABC_FormatosTipos" datasource="#Session.DSN#">
				update TFormatos
				   set TFdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TFdescripcion#">,
					   TFcfm = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TFcfm#">,
					   TFsql = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Form.TFsql#">,
					   TFfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
					   TFUso = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.TFUso#">
				where TFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TFid#">
				and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			<cfset modo = "Cambio">
		<cfelse>
			select 1
		</cfif>
	<cfcatch type="any">
		<cfinclude template="../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<form action="FormatosTipos.cfm" method="post" name="sql">
	<cfif isdefined("Form.TFid") and len(trim(Form.TFid))>
		<input name="TFid" type="hidden" value="<cfoutput>#Form.TFid#</cfoutput>">
	</cfif>
	<cfif isdefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="Nuevo">
	</cfif>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
