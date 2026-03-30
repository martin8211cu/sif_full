<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="ABC_Idiomas" datasource="#Session.Edu.DSN#">
			set nocount on			
			<cfif isdefined("Form.Alta")>
				insert Idiomas (Icodigo, Descripcion, Inombreloc)
				values (
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Icodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Descripcion#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Inombreloc#">
				)
				select convert(varchar,@@identity) as ID															
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>			
				delete Idiomas
				where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Iid#">
				<cfset modo="BAJA">
			<cfelseif isdefined("Form.Cambio")>
				update Idiomas set 
					Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Icodigo#">, 
					Descripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Descripcion#">, 
					Inombreloc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Inombreloc#"> 
				where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Iid#">
				<cfset modo="CAMBIO">				  				  
			<cfelse>
				select 1
			</cfif>			
			set nocount off
		</cfquery>		
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<form action="Idiomas.cfm" method="post" name="sql">
	<cfif isdefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="Nuevo"> 
	</cfif>	
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif isdefined("ABC_Idiomas.ID")>
	   	<input name="Iid" type="hidden" value="<cfif isdefined("ABC_Idiomas.Iid")><cfoutput>#ABC_Idiomas.Iid#</cfoutput></cfif>">
	<cfelse>
	   	<input name="Iid" type="hidden" value="<cfif isdefined("Form.Iid") and not isDefined("Form.Baja")><cfoutput>#Form.Iid#</cfoutput></cfif>">		
	</cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">	
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>