
<cfset modo = "ALTA">
<cfif not isdefined("Form.btnNuevo")>
		<!--- Agregar Accion a Seguir --->
		<cfif isdefined("Form.Alta")>
			<cfquery name="ABC_AccionesSeguir" datasource="#Session.DSN#">
				insert into RHAccionesSeguir (Ecodigo, RHAScodigo, RHASdescripcion, BMUsucodigo, BMfecha, BMfmod, RHASnegativo)
				values (	<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">, 
							<cfqueryparam value="#Form.RHAScodigo#" cfsqltype="cf_sql_char">, 
							<cfqueryparam value="#Form.RHASdescripcion#" cfsqltype="cf_sql_varchar" null="#Len(Trim(Form.RHASdescripcion)) EQ 0#">,
							<cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cfif isdefined("form.RHASnegativo") and len(trim(form.RHASnegativo))><cfqueryparam cfsqltype="cf_sql_bit" value="#form.RHASnegativo#"><cfelse>0</cfif>)
			</cfquery>
			<cfset modo = 'ALTA'>
			
		<!--- Actualizar Accion a Seguir --->
		<cfelseif isdefined("Form.Cambio")>
			<cf_dbtimestamp datasource="#session.dsn#"
							table="RHAccionesSeguir"
							redirect="Acciones.cfm"
							timestamp="#form.ts_rversion#"
							field1="RHASid" 
							type1="numeric" 
							value1="#Form.RHASid#">

			<cfquery name="ABC_AccionesSeguir" datasource="#Session.DSN#">
				update RHAccionesSeguir set 
					RHAScodigo = <cfqueryparam value="#Form.RHAScodigo#" cfsqltype="cf_sql_char">, 
					RHASdescripcion = <cfqueryparam value="#Form.RHASdescripcion#" cfsqltype="cf_sql_varchar" null="#Len(Trim(Form.RHASdescripcion)) EQ 0#">,
					BMUsucodigo = <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">,
					BMfmod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					RHASnegativo = <cfif isdefined("form.RHASnegativo") and len(trim(form.RHASnegativo))><cfqueryparam cfsqltype="cf_sql_bit" value="#form.RHASnegativo#"><cfelse>0</cfif>
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHASid =  <cfqueryparam value="#Form.RHASid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfset modo = 'CAMBIO'>
				  
		<!--- Borrar una Jornada --->
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="ABC_AccionesSeguir" datasource="#Session.DSN#">
				delete from RHAccionesSeguir
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHASid =  <cfqueryparam value="#Form.RHASid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfset modo = 'ALTA'>
		</cfif>
</cfif>	

<cfoutput>
<form action="Acciones.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo eq 'CAMBIO'>
		<input name="RHASid" type="hidden" value="#Form.RHASid#">
	</cfif>
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
