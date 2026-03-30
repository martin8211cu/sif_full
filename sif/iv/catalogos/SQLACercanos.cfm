<cfif isdefined("Form.Accion")>
	<cftry>
		<cfif Form.Accion eq 'Alta'>
			<cfquery name="insert" datasource="#session.DSN#">
				insert into AlmacenCercano(Aid ,Alm_Aid)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AidCercano#">
					)
			</cfquery>
			
		<cfelseif Form.Accion eq 'Baja'>
			<cfquery name="delete" datasource="#session.DSN#">
				delete from AlmacenCercano
				where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">
					and Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Alm_Aid#">
			</cfquery>

		</cfif>
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
<cfelse>
	<cfset modo = 'ALTA'>
</cfif>

<cfoutput>
<form action="Almacen.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="CAMBIO">
	<input name="Aid" type="hidden" value="#Form.Aid#">
	<input name="AidCercano" type="hidden" value="#Form.AidCercano#">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>