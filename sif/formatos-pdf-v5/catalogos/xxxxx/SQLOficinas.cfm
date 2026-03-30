<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="Oficinas" datasource="#Session.DSN#">
			<cfif isdefined("Form.Alta")>
			set nocount on
				declare @cont int
				select @cont = isnull(max(Ocodigo),0)+1 from Oficinas 
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">				
				insert Oficinas (Ecodigo, Ocodigo, Odescripcion)
				values
				(				
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> , 
					 @cont,
					 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Odescripcion#">))
				 )
			<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
			set nocount on
				delete from Oficinas
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and Ocodigo  = <cfqueryparam value="#Form.Ocodigo#" cfsqltype="cf_sql_integer">
			set nocount off
				  
				  <cfset modo="BAJA">
			<cfelseif isdefined("Form.Cambio")>
			set nocount on
				update Oficinas set 
					Odescripcion = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Odescripcion#">))
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and Ocodigo = <cfqueryparam value="#Form.Ocodigo#" cfsqltype="cf_sql_integer">
				  and timestamp = convert(varbinary,#lcase(Form.timestamp)#)				
				  <cfset modo="CAMBIO">
			set nocount off
			</cfif>
			set nocount off
		</cfquery>
	<cfcatch type="database">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>
<form action="Oficinas.cfm<cfif isdefined('url.desde') and Trim(url.desde) eq 'rh'>?desde=rh</cfif>" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="Ocodigo" type="hidden" value="<cfif isdefined("Form.Ocodigo")><cfoutput>#Form.Ocodigo#</cfoutput></cfif>">
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">		
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


