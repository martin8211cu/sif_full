<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="Departamentos" datasource="#Session.DSN#">
		set nocount on
			<cfif isdefined("Form.Alta")>
				declare @cont int
				select @cont = isnull(max(Dcodigo),0)+1 from Departamentos 
				insert Departamentos (Ecodigo, Dcodigo, Ddescripcion)
				values
				(				
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> , 
					 @cont,
					 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ddescripcion#">))
				 )
			<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
				delete from Departamentos
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and Dcodigo  = <cfqueryparam value="#Form.Dcodigo#" cfsqltype="cf_sql_integer">
				  <cfset modo="BAJA">
			<cfelseif isdefined("Form.Cambio")>
				update Departamentos set 
					Ddescripcion = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ddescripcion#">))
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and Dcodigo = <cfqueryparam value="#Form.Dcodigo#" cfsqltype="cf_sql_integer">
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
<form action="Departamentos.cfm<cfif isdefined('url.desde') and Trim(url.desde) eq 'rh'>?desde=rh</cfif>" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="Dcodigo" type="hidden" value="<cfif isdefined("Form.Dcodigo")><cfoutput>#Form.Dcodigo#</cfoutput></cfif>">
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">		
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


