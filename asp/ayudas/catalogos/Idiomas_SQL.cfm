<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("Form.Alta")>
			<cfquery name="ABC_Idiomas" datasource="sifcontrol">
				insert into Idiomas (Icodigo, Descripcion, Inombreloc)
				values (
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Icodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Descripcion#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Inombreloc#">
				)
			</cfquery>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Baja")>			
			<cfquery name="ABC_Idiomas" datasource="sifcontrol">
				delete from Idiomas
				where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Iid#">
			</cfquery>
			<cfset modo="BAJA">
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="ABC_Idiomas" datasource="sifcontrol">
				update Idiomas set 
					Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Icodigo#">, 
					Descripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Descripcion#">, 
					Inombreloc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Inombreloc#"> 
				where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Iid#">
			</cfquery>
			<cfset modo="CAMBIO">				  				  
		</cfif>			
</cfif>

<form action="Idiomas.cfm" method="post" name="sql">
	<cfif isdefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="Nuevo"> 
	</cfif>	
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif isdefined("Form.Iid") and not isDefined("Form.Baja")><input name="Iid" type="hidden" value="<cfoutput>#Form.Iid#</cfoutput>"></cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">	
</form>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>