
<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("Form.Alta")>
			<cfquery name="rsNotificacionInsert" datasource="asp">
				insert into Notificaciones (email, nombre, activo, fechaalta, BMUsucodigo)
				values (<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.email#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre#">,
					<cfif isdefined('form.activo')>1<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				)
			</cfquery>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Baja")>			
			<cfquery name="rsNotificacionDelete" datasource="asp">
				delete from Notificaciones
				where NDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.NDid#">
			</cfquery>
			<cfset modo="BAJA">
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="rsNotificacionUpdate" datasource="asp">
				update Notificaciones set 
					email		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.email#">,
					nombre 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre#">,
					activo 		= <cfif isdefined('form.activo')>1<cfelse>0</cfif>,
					fechaalta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
					BMUsucodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				where NDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.NDid#">
			</cfquery>
			<cfset modo="CAMBIO">				
		</cfif>			
</cfif>

<form action="Notificaciones.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif isdefined("Form.NDid") and not isDefined("Form.Baja") and not isDefined("Form.Nuevo")>
		<input name="NDid" type="hidden" value="<cfoutput>#Form.NDid#</cfoutput>">
	</cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">	
</form>

<html>
	<head>
	</head>
	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>