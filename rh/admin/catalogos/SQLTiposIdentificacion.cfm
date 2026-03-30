<cfparam name="action" default="TiposIdentificacion.cfm">
<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfquery name="ABC_TiposIdentificacion" datasource="#session.DSN#">
			<!--- Caso 1: Agregar Tipo de Accion --->
			<cfif isdefined("form.Alta")>
				insert into NTipoIdentificacion ( NTIcodigo, NTIdescripcion, NTIcaracteres, NTImascara,Ecodigo )
							 values ( <cfqueryparam value="#form.NTIcodigo#"       cfsqltype="cf_sql_char">,
									  <cfqueryparam value="#form.NTIdescripcion#"  cfsqltype="cf_sql_varchar">,
									  <cfqueryparam value="#form.NTIcaracteres#"   cfsqltype="cf_sql_integer">,
									  <cfqueryparam value="#form.NTImascara#"      cfsqltype="cf_sql_varchar">,
									  <cfqueryparam value="#session.Ecodigo#"		cfsqltype="cf_sql_numeric">
									)

			<!--- Caso 2: Borrar un Encabezado de Requisicion --->
			<cfelseif isdefined("form.Cambio")>
				update NTipoIdentificacion
				set NTIdescripcion = <cfqueryparam value="#form.NTIdescripcion#"    cfsqltype="cf_sql_varchar">,
					NTIcaracteres = <cfqueryparam value="#form.NTIcaracteres#" cfsqltype="cf_sql_integer">,
					NTImascara = <cfqueryparam value="#form.NTImascara#" cfsqltype="cf_sql_varchar">
				where NTIcodigo =  <cfqueryparam value="#form.NTIcodigo#" cfsqltype="cf_sql_char">
				and Ecodigo = <cfqueryparam value="#session.Ecodigo#"		cfsqltype="cf_sql_numeric">

			<!--- Caso 3: Agregar Detalle de Solicitud y opcionalmente modificar el encabezado --->
			<cfelseif isdefined("form.Baja")>
				delete from NTipoIdentificacion
				where NTIcodigo =  <cfqueryparam value="#form.NTIcodigo#" cfsqltype="cf_sql_char">
				and Ecodigo = <cfqueryparam value="#session.Ecodigo#"		cfsqltype="cf_sql_numeric">
			</cfif>
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>