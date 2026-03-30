<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="Monedas" datasource="#Session.DSN#">
		set nocount on
			<cfif isdefined("Form.Alta")>
				insert Monedas (Ecodigo, Mnombre, Msimbolo, Miso4217)
				values
				(				
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
					 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Mnombre#">)),					 
					 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Msimbolo#">)),
					 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Miso4217#">))					 
				)													
			<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
				delete from Monedas
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and Mcodigo  = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">
				  <cfset modo="BAJA">
			<cfelseif isdefined("Form.Cambio")>
				update Monedas set 
					Msimbolo = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Msimbolo#">)),
					Miso4217 = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Miso4217#">))					 
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and Mcodigo = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">
				  and timestamp = convert(varbinary,#lcase(Form.timestamp)#)				
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
<form action="Monedas.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="Mcodigo" type="hidden" value="<cfif isdefined("Form.Mcodigo")><cfoutput>#Form.Mcodigo#</cfoutput></cfif>">
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">		
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


