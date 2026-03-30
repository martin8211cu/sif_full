<cfparam name="action" default="ComponentesPagar.cfm">
<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<cfif isdefined("form.Alta")>
		<cfquery name="ABC_Plazas_INS" datasource="#session.DSN#">
			insert into RHComponentesPagarA ( RHTid, CSid, Ecodigo,  BMfalta, BMfmod, BMUsucodigo)
			 values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTid#" >,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#" >,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Now(),"DD/MM/YYYY")#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Now(),"DD/MM/YYYY")#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					)
		</cfquery >
	<cfelseif isdefined("form.Baja")>
		<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
					<cfinvokeargument  name="nombreTabla" value="RHComponentesPagarA">		
					<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
					<cfinvokeargument name="condicion" value="Ecodigo = #Session.Ecodigo# and RHTid = #form.RHTid# and CSid = #form.CSid#">
		</cfinvoke>
		
		<cfquery name="ABC_Plazas_DEL" datasource="#session.DSN#">
			delete from RHComponentesPagarA
			where Ecodigo	= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and RHTid 	= <cfqueryparam value="#form.RHTid#" cfsqltype="cf_sql_numeric">
			  and CSid = <cfqueryparam value="#form.CSid#" cfsqltype="cf_sql_numeric">
		</cfquery>
	</cfif>
</cfif>	

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo eq 'CAMBIO'><input name="RHCcodigo" type="hidden" value="#form.RHCcodigo#"></cfif>
	<input type="hidden" id="RHTid" name="RHtid" value="<cfif isdefined("form.RHTid") and len(trim(form.RHTid)) neq 0><cfoutput>#form.RHTid#</cfoutput></cfif>">
	<input type="hidden" id="RHTdesc" name="RHTdesc" value="<cfif isdefined("form.RHTdesc") and len(trim(form.RHTdesc)) neq 0><cfoutput>#form.RHTdesc#</cfoutput></cfif>">
</form>
</cfoutput>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>