<cfparam name="action" default="TipoDeduccionPermiso.cfm">
<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<!---<cftry>--->
		
		
			<!---set nocount on--->
	
			<cfif isdefined("form.Alta")>
			<cfquery name="ABC_Plazas_in" datasource="#session.DSN#">
				insert into RHUsuarioTDeduccion (TDid, Usucodigo, Ecodigo,  BMfalta, BMfmod, BMUsucodigo)
				 values(<cfqueryparam value="#form.TDid#" cfsqltype="cf_sql_numeric">,
				 		<cfqueryparam value="#form.Usuario#" cfsqltype="cf_sql_numeric">,
				 		<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
						<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
						<cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
						)
			</cfquery>

			<cfelseif isdefined("form.Baja")>
			<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
						<cfinvokeargument  name="nombreTabla" value="RHUsuarioTDeduccion">		
						<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
						<cfinvokeargument name="condicion" value="Ecodigo = #session.Ecodigo# and TDid =#form.TDid# and Usucodigo=#form.Usuario#">
			</cfinvoke>
			
			<cfquery name="ABC_Plazas_de" datasource="#session.DSN#">
				delete from RHUsuarioTDeduccion
				where Ecodigo	= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and TDid 	= <cfqueryparam value="#form.TDid#" cfsqltype="cf_sql_numeric">
				  and Usucodigo = <cfqueryparam value="#form.Usuario#" cfsqltype="cf_sql_numeric">
			</cfquery>
			</cfif>
</cfif>	

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
	<input type="hidden" id="TDid" name="TDid" value="<cfif isdefined("form.TDid") and len(trim(form.TDid)) neq 0><cfoutput>#form.TDid#</cfoutput></cfif>">
	<input type="hidden" id="TDdescripcion" name="TDdescripcion" value="<cfif isdefined("form.TDdescripcion") and len(trim(form.TDdescripcion)) neq 0><cfoutput>#form.TDdescripcion#</cfoutput></cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>