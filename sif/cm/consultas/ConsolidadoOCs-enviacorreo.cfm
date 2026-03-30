<!--- Obtiene los datos del proveedor --->
<cfquery name="rsInfoProveedor" datasource="#session.dsn#">
	select sn.SNnombre
	from SNegocios sn
	where sn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and sn.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
</cfquery>

<!--- Crea el encabezado del correo --->
<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")>
<cfset email_from = Politicas.trae_parametro_global("correo.cuenta")>
<cfif len(trim(email_from)) eq 0>
	<cf_errorCode	code = "50267" msg = "La cuenta origen de los correos de salida del portal no está definida">
</cfif>

<cfset email_subject = form.Asunto>

<cfset email_to = '"' & rsInfoProveedor.SNnombre & '" <' & form.email & '>'>
<cfset email_cc = '"' & rsInfoProveedor.SNnombre & '" <' & form.Ccemail & '>'>

<!--- Contenido del correo --->
<cfsavecontent variable="email_body" >
	<html>
		<head>
			<style type="text/css">
				.tituloIndicacion {
					font-size: 10pt;
					font-variant: small-caps;
					background-color: #CCCCCC;
				}
				.tituloListas {
					font-weight: bolder;
					vertical-align: middle;
					padding: 2px;
					background-color: #F5F5F5;
				}
				.listaNon { 
					background-color:#FFFFFF; 
					vertical-align:middle; 
					padding-left:5px;
				}
				.listaPar { 
					background-color:#FAFAFA; 
					vertical-align:middle; 
					padding-left:5px;
				}
				body,td {
					font-size: 12px;
					background-color: #f8f8f8;
					font-family: Verdana, Arial, Helvetica, sans-serif;
				}
			</style>
		</head>
		<body>
			<cfif form.TipoReporte eq 'R'>
				<cfinclude template="ConsolidadoOCs-represum.cfm">
			<cfelseif form.TipoReporte eq 'D'>
				<cfinclude template="ConsolidadoOCs-repdet.cfm">
			</cfif>
		</body>
	</html>
</cfsavecontent>

<!--- Envía el correo --->
<cfif isdefined("form.Ccemail") and len(trim(form.Ccemail)) gt 0>
	<cfmail from="#email_from#" to="#email_to#" cc="#email_cc#" subject="#email_subject#" type="html">
		<cfoutput>
			#email_body#
		</cfoutput>
	</cfmail>
<cfelse>
	<cfmail from="#email_from#" to="#email_to#" subject="#email_subject#" type="html">
		<cfoutput>
			#email_body#
		</cfoutput>
	</cfmail>
</cfif>

<!--- Actualiza el consolidado para indicar que el reporte ya fue enviado por correo --->
<cfquery name="rsUpdateDConsolidadoOrdenCM" datasource="#session.dsn#">
	update DConsolidadoOrdenCM
	<cfif form.TipoReporte eq 'R'>
		set DCOCrrenviado = 1
	<cfelseif form.TipoReporte eq 'D'>
		set DCOCrdenviado = 1
	</cfif>
	where ECOCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECOCid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif form.TipoReporte eq 'R'>
			and DCOCrrenviado = 0
		<cfelseif form.TipoReporte eq 'D'>
			and DCOCrdenviado = 0
		</cfif>
		and exists (
			select eo.EOidorden
			from EOrdenCM eo
			where eo.EOidorden = DConsolidadoOrdenCM.EOidorden
				and eo.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
				and eo.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
				and eo.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		)
</cfquery>

<!--- Abre la página indicando que el correo fue enviado --->
<cflocation url="ConsolidadoOCs-correoenviado.cfm?ECOCid=#form.ECOCid#&SNcodigo=#form.SNcodigo#&Mcodigo=#form.Mcodigo#&email=#form.email#&Ccemail=#form.Ccemail#&Asunto=#URLEncodedFormat(form.Asunto)#&TipoReporte=#form.TipoReporte#">


