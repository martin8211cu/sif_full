<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="ABC_Ayuda" datasource="sifcontrol">
			set nocount on
			<cfif isdefined("Form.Alta")>
				insert Ayuda (Acodigo, Iid, Adesc, Atipo)
				values (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Acodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Iid#">, 
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Form.Adesc#">,
					<cfif isdefined("Form.Atipo")>1<cfelse>0</cfif>
				)
				select @@identity as ID
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
				delete Ayuda
				where Ayid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ayid#"> 
				<cfset modo="BAJA">
			<cfelseif isdefined("Form.Cambio")>
				update Ayuda set 
					Adesc = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Form.Adesc#">,
					Acodigo = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Form.Acodigo#">,
					Atipo = <cfif isdefined("Form.Atipo")>1<cfelse>0</cfif>
				where Ayid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ayid#">
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

<form action="Ayudas.cfm" method="post" name="sql">
	<cfif isdefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="Nuevo"> 
	</cfif>	
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
   	<input name="Ayid" type="hidden" value="<cfif isdefined("modo") and modo eq "ALTA" and isdefined("ABC_Ayuda.ID") and not isDefined("Form.Baja")><cfoutput>#ABC_Ayuda.ID#</cfoutput><cfelseif isdefined("modo") and modo neq "ALTA"><cfoutput>#Form.Ayid#</cfoutput></cfif>">		
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">	
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>