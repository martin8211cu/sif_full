<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Baja")>
		<cfquery name="MePagodel" datasource="#Session.DSN#">
			select * from FATipoPago
			where MPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.MPid#">
		</cfquery>
		<cfif isdefined("MePagodel") and MePagodel.Recordcount gt 0>
			<cfthrow message = "El método de Pago tiene referencía con una Forma de Pago" type = "custom_type"> 
		</cfif>
	</cfif>
	<cftry>
		<cfquery name="MePago" datasource="#Session.DSN#">
			set nocount on			
			<cfif isdefined("Form.Alta")>
				Insert 	CSATMetPago(CSATcodigo,CSATdescripcion)
						values	(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.codigo_MetodoPago#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.des_MetodoPago#">
						)
				Select 1
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Cambio")>
				Update 	CSATMetPago
					set  CSATcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.codigo_MetodoPago#">,
						 CSATdescripcion     = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.des_MetodoPago#">
				where MPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.MPid#">
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
				delete CSATMetPago
				where MPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.MPid#">
				<cfset modo="CAMBIO">
			</cfif>
			set nocount off
		</cfquery>
	<cfcatch type="database">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<form action="MetodoPagoFact.cfm" method="post" name="sql">
	<cfif isDefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="<cfoutput>#Form.Nuevo#</cfoutput>">
	</cfif>	
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="MPid" type="hidden" value="<cfif isdefined("Form.MPid")><cfoutput>#Form.MPid#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>