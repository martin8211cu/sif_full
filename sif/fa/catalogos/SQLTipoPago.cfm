<cfif not isdefined("Form.Nuevo")>			
	<cftry>
		<cfquery name="TipoPago" datasource="#Session.DSN#">
			set nocount on			
			<cfif isdefined("Form.Alta")>
				Insert 	FATipoPago(codigo_TipoPago,nombre_TipoPago,BMfechamod,Ecodigo,BMUsucodigo,TipoPagoSAT,MPid )
						values	(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.codigo_TipoPago#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre_TipoPago#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.tipoPagoSAT#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.metPago#">
						)
				Select 1
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Cambio")>
				Update 	FATipoPago
					set  codigo_TipoPago = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.codigo_TipoPago#">,
						 nombre_TipoPago = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre_TipoPago#">,
						 TipoPagoSAT     = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.tipoPagoSAT#">,
						 MPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.metPago#">
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				      and id_TipoPago = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.id_TipoPago#">
				<cfset modo="CAMBIO">
			<cfelseif isdefined("Form.Baja")>
				delete FATipoPago
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				     and id_TipoPago = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.id_TipoPago#">
				<cfset modo="BAJA">
			</cfif>
			set nocount off
		</cfquery>
	<cfcatch type="database">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<form action="TipoPagoFact.cfm" method="post" name="sql">
	<cfif isDefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="<cfoutput>#Form.Nuevo#</cfoutput>">
	</cfif>	
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="id_TipoPago" type="hidden" value="<cfif isdefined("Form.id_TipoPago")><cfoutput>#Form.id_TipoPago#</cfoutput></cfif>">
	<input name="codigo_TipoPago" type="hidden" value="<cfif isdefined("Form.codigo_TipoPago")><cfoutput>#Form.codigo_TipoPago#</cfoutput></cfif>">
	<input name="nombre_TipoPago" type="hidden" value="<cfif isdefined("Form.nombre_TipoPago")><cfoutput>#Form.nombre_TipoPago#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>