<!--- Faltan validaciones de indices alternos --->
<cfset modo = "ALTA">

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		
		<cfif isdefined("form.PRJPPid1") and form.PRJPPid1 neq "">
			
			<cfif isdefined("form.PRJPPid1")><cfset form.PRJPPid = form.PRJPPid1></cfif>
			<cfquery name="ABC_VerObrasProductos" datasource="#Session.DSN#">
			Select count(1) as cant
			from PRJPobraProducto
			where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and PRJPACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(Form.PRJPACid)#">
			  and PRJPPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(Form.PRJPPid)#">
			</cfquery>
			
			<cfif ABC_VerObrasProductos.cant eq 0 and Val(Trim(Form.PRJPPcantidad)) gt 0>
			
				<cftransaction>
		
					<cfquery name="ABC_ObrasProductos" datasource="#Session.DSN#">
						insert into PRJPobraProducto (Ecodigo, PRJPACid, PRJPPid, PRJPPcantidad, BMUsucodigo)
						values (
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(Form.PRJPACid)#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(Form.PRJPPid)#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(Form.PRJPPcantidad)#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
						)
					</cfquery>
					<!--- <cfset modo="ALTA"> --->
				
				</cftransaction>
			
			<cfelse>
				<script>
				alert("No es posible agregar el producto. Verifique que haya elegido un producto y la cantidad sea mayor a cero.")
				</script>
			</cfif> 
		
		<cfelse>
				<script>
				alert("Es necesario seleccionar el producto.")
				</script>		
		</cfif>
		<cfset modo="ALTA">

	<cfelseif isdefined("Form.Baja")>
		<cfquery name="ABC_ObrasProductos" datasource="#Session.DSN#">
			delete PRJPobraProducto
			where PRJPACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJPACid#">
			  and PRJPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJPPid#">
		</cfquery>
		<cfset modo="BAJA">

	<cfelseif isdefined("Form.Cambio")>

		<cftransaction>
			
			<cfquery name="ABC_ObrasProductos" datasource="#Session.DSN#">
				update PRJPobraProducto set 
					PRJPPcantidad = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(Form.PRJPPcantidad)#">
				where PRJPACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJPACid#">
				  and PRJPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJPPid#">
				  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
			</cfquery>
		</cftransaction>
		<cfset modo="ALTA">  				  
	</cfif>
	
</cfif>

<cfoutput>
<form action="PRJPobraProducto.cfm?PRJPOid=#PRJPOid#&PRJPAid=#PRJPAid#&PRJPACid=#PRJPACid#" method="post" name="sql">
	<input name="PageNum" type="hidden" value="<cfif isdefined("Form.PageNum")><cfoutput>#Form.PageNum#</cfoutput></cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

