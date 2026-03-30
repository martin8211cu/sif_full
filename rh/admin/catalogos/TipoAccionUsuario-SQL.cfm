<cfparam name="action" default="TipoAccionUsuario.cfm">
<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<cfif isdefined("form.Alta")>
		<cfquery name="ABC_Plazas_INS" datasource="#session.DSN#">
			insert into RHUsuarioTipoAccion ( RHTid, Usucodigo, Ecodigo,  BMfalta, BMfmod, BMUsucodigo)
			 values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTid#" >,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#" >,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Now(),"DD/MM/YYYY")#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Now(),"DD/MM/YYYY")#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					)
		</cfquery >
	<cfelseif isdefined("form.Baja")>
		<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
					<cfinvokeargument  name="nombreTabla" value="RHCargasRebajar">		
					<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
					<cfinvokeargument name="condicion" value="Ecodigo = #Session.Ecodigo# and RHTid = #form.RHTid# and Usucodigo = #form.Usucodigo#">
					<cfinvokeargument name="necesitaTransaccion" value="false">
		</cfinvoke>
		<cfquery name="ABC_Plazas_DEL" datasource="#session.DSN#">
			delete from RHUsuarioTipoAccion
			where Ecodigo	= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and RHTid 	= <cfqueryparam value="#form.RHTid#" cfsqltype="cf_sql_numeric">
			  and Usucodigo = <cfqueryparam value="#form.Usucodigo#" cfsqltype="cf_sql_numeric">
		</cfquery>
	</cfif>
</cfif>	

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	
	<cfif modo eq 'CAMBIO'><input name="RHCcodigo" type="hidden" value="#form.RHCcodigo#"></cfif>
	<input name="especial" type="hidden" value="<cfif isdefined("Form.especial")>#Form.especial#</cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
	<input type="hidden" id="RHTid" name="RHtid" value="<cfif isdefined("form.RHTid") and len(trim(form.RHTid)) neq 0><cfoutput>#form.RHTid#</cfoutput></cfif>">
	<input type="hidden" id="RHTdesc" name="RHTdesc" value="<cfif isdefined("form.RHTdesc") and len(trim(form.RHTdesc)) neq 0><cfoutput>#form.RHTdesc#</cfoutput></cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>