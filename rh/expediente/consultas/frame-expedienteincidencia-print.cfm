
<html>
<head>
<title><cf_translate key="LB_Expediente">Expediente</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../../../css/web_portlet.css" rel="stylesheet" type="text/css">
<cf_templatecss>
</head>
<body>
	
	<cfif isdefined("Url.TEid") and not isdefined("Form.TEid")>
		<cfset Form.TEid = Url.TEid>
	</cfif>
	<cfif isdefined("Url.IEid") and not isdefined("Form.IEid")>
		<cfset Form.IEid = Url.IEid>
	</cfif>
	<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
		<cfset Form.DEid = Url.DEid>
	</cfif>

	<cfif isdefined("Form.TEid") and Len(Trim(Form.TEid))>
		<!--- Modo Autogestion --->
		<cfif Session.Params.ModoDespliegue EQ 0>
			<!--- Solo se tiene permisos si corresponde al usuario autenticado en el portal --->
			<cfif rsEmpleado.Usucodigo EQ Session.Usucodigo>
				<cfquery name="rsPermisos" datasource="#Session.DSN#">
					select 1
					from TipoExpediente a
					where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
					and a.TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
				</cfquery>
			</cfif>
		<!--- Modo Administrador --->
		<cfelseif Session.Params.ModoDespliegue EQ 1>
			<cfquery name="rsPermisos" datasource="#Session.DSN#">
				select 1
				from UsuariosTipoExpediente a
				where a.TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
				and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			</cfquery>
		</cfif>
	</cfif>
	
	<cfif not (isdefined("rsPermisos") and rsPermisos.recordCount)>
		<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_UstedNoTieneAccesoAEsteExpediente"
				Default="Usted no tiene acceso a este expediente"
				returnvariable="MSG_UstedNoTieneAccesoAEsteExpediente"/>
		<cfthrow detail="#MSG_UstedNoTieneAccesoAEsteExpediente#">
		<cfabort>
	</cfif>
	<cfinclude template="/rh/expediente/consultas/consultas-frame-header.cfm">
	<cfinclude template="/rh/expediente/consultas/frame-infoEmpleado.cfm">
	<cfinclude template="/rh/expediente/consultas/frame-expedienteincidencia.cfm">
</body>
</html>
