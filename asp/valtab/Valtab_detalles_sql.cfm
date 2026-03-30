
<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("Form.Alta")>
			<cfquery name="rsNotificacionInsert" datasource="asp">
				insert into ValTabDetalle (codigo, descripcion, ValTabid)
				values (<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.codigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.descripcion#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.valtabId#">
				)
			</cfquery>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Baja")>			
			<cfquery name="rsNotificacionDelete" datasource="asp">
				delete from ValTabDetalle
				where id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
			</cfquery>
			<cfset modo="BAJA">
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="rsNotificacionUpdate" datasource="asp">
				update ValTabDetalle set 
					codigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.codigo#">,
					descripcion 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.descripcion#">
				where id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
			</cfquery>
			<cfset modo="CAMBIO">				
		</cfif>			
</cfif>

<form action="ValTab_detalles.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif isdefined("Form.id") and not isDefined("Form.Baja") and not isDefined("Form.Nuevo")>
		<input name="id" type="hidden" value="<cfoutput>#Form.id#</cfoutput>">
	</cfif>
	<input name="valtabId" type="hidden" value="<cfoutput>#Form.valtabId#</cfoutput>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">	
</form>

<html>
	<head>
	</head>
	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>