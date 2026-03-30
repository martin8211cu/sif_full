<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
			<cfquery name="ABC_Ayuda" datasource="sifcontrol">
				insert into Ayuda (Acodigo, Iid, Adesc, Atipo)
				values (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Acodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Iid#">, 
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Form.Adesc#">,
					<cfif isdefined("Form.Atipo")>1<cfelse>0</cfif>
				)
			</cfquery>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="ABC_Ayuda" datasource="sifcontrol">
				delete from Ayuda
				where Ayid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ayid#"> 
			</cfquery>
			<cfset modo="BAJA">
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="ABC_Ayuda" datasource="sifcontrol">
				update Ayuda set 
					Adesc = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Form.Adesc#">,
					Acodigo = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Form.Acodigo#">,
					Atipo = <cfif isdefined("Form.Atipo")>1<cfelse>0</cfif>
				where Ayid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ayid#">
			</cfquery>
			<cfset modo="CAMBIO">				  				  
		</cfif>			
</cfif>

<form action="Ayudas.cfm" method="post" name="sql">
	<cfif isdefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="Nuevo"> 
	</cfif>	
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
  <input name="Ayid" type="hidden" value="<cfif isdefined("modo") and modo neq "ALTA" and isdefined("Form.Ayid")><cfoutput>#Form.Ayid#</cfoutput></cfif>">		
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">
</form>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>