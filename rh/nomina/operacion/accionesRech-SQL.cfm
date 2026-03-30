<!--- 
<cfdump var="#session#">
<cfdump var="#form#">

<cfabort>
 --->
<cfset action = "accionesRech.cfm">
			
<cfif Session.Params.ModoDespliegue EQ 1>
	<cfif isdefined("Form.o") and isdefined("Form.sel")>
		<cfset action = "/cfmx/rh/expediente/catalogos/expediente-cons.cfm">
	<cfelse>
		<cfif isdefined("Form.PosteoAccion")>
			<cfset action = "/cfmx/rh/nomina/operacion/Acciones.cfm">
		<cfelse>
			<cfset action = "/cfmx/rh/nomina/operacion/Acciones-lista.cfm">
		</cfif>
	</cfif>
<cfelseif Session.Params.ModoDespliegue EQ 0>
	<cfset action = "/cfmx/rh/autogestion/autogestion.cfm">
</cfif>

<cfif isdefined("Form.btnReintentar")>
	<cfset acciones = ListToArray(Form.chk)>
	
	<cfloop from="1" to="#ArrayLen(acciones)#" index="i">
		<cfquery name="UPD_accion" datasource="#session.dsn#">
			update RHAcciones set RHAidtramite = null
			where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#acciones[i]#">
		</cfquery>
	</cfloop>
<cfelseif isdefined("Form.btnBorrar")>		
	<cfset acciones = ListToArray(Form.chk)>
	
	<cfloop from="1" to="#ArrayLen(acciones)#" index="i">
		<cfquery name="DEL_accionA" datasource="#session.dsn#">
			delete RHConceptosAccion
			where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#acciones[i]#">
		</cfquery>
	
		<cfquery name="DEL_accionA" datasource="#session.dsn#">
			delete RHDAcciones
			where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#acciones[i]#">
		</cfquery>

		<cfquery name="DEL_accionB" datasource="#session.dsn#">
			delete RHAcciones
			where RHAlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#acciones[i]#">			
		</cfquery>
	</cfloop>
<cfelseif not isdefined("Form.btnAplicar")>
	<cfif Session.Params.ModoDespliegue EQ 1>
		<cfset action = "/cfmx/rh/nomina/operacion/tramites/ConsultaAcciones.cfm">
	<cfelseif Session.Params.ModoDespliegue EQ 0>
		<cfset action = "/cfmx/rh/autogestion/autogestion.cfm">
	</cfif>	
</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<cfif isdefined("Form.RHAlinea") and Len(Trim(Form.RHAlinea)) NEQ 0>
		<input name="RHAlinea" type="hidden" value="#Form.RHAlinea#">
	</cfif>
	<input name="modo" type="hidden" value="ALTA">
	<input name="atrasAccRech" type="hidden" value="/cfmx/rh/nomina/operacion/accionesRech.cfm">
	<input name="Usuario" type="hidden" value="<cfif isdefined("Form.Usuario")>#Form.Usuario#</cfif>">
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