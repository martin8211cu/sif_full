<cfparam  name="modo" default="ALTA">
<!--- <cf_dump var="entre a SQL"> 
<cf_dump var="#modo#"> --->
<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfif isdefined("Form.Alta")>
        <!---	<cf_dump var="aqui Alta">  --->
			<cfquery name="ABC_TiposTransaccion" datasource="#Session.DSN#">
				insert into Prod_ClasificacionAlmacen (ECodigo, Ccodigo, Almid)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ccodigo#">, 										
			    	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">                    
				)								
			</cfquery>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Baja")>
        <!---	<cf_dump var="aqui Baja"> --->
			<cfquery name="ABC_TiposTransaccion" datasource="#Session.DSN#">
				delete from Prod_ClasificacionAlmacen 
				where ECodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">			
			</cfquery> 	  
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Cambio")>
<!---        	<cf_dump var="#form#">--->
			<cf_dbtimestamp datasource="#session.dsn#"
					table="Prod_ClasificacionAlmacen"
					redirect="formAlmacenesXCateg.cfm"
					timestamp="#form.ts_rversion#"
					field1="Ccodigo" 
					type1="integer" 
					value1="#form.Ccodigo#"
					field2="Ecodigo" 
					type2="integer" 
					value2="#session.Ecodigo#"
					>
                          
			<cfquery name="ABC_TiposTransaccion" datasource="#Session.DSN#">
				update Prod_ClasificacionAlmacen set
					Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ccodigo#">,
                    Almid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">
				where ECodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ccodigo#">
			</cfquery>	
			<cfset modo="CAMBIO">				  				  
		</cfif>			
	<cfcatch type="any">
		<cfinclude template="../../sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<form action="AlmacenesXCateg.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif modo neq 'ALTA'>
		<input name="Ccodigo" type="hidden" value="<cfif isdefined("Form.Ccodigo")><cfoutput>#Form.Ccodigo#</cfoutput></cfif>">	
   		<input name="Aid" type="hidden" value="<cfif isdefined("Form.Aid")><cfoutput>#Form.Aid#</cfoutput></cfif>">	
	</cfif>

	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">	
	<input name="desde" type="hidden" value="<cfif isdefined("session.modulo")><cfoutput>#session.modulo#</cfoutput></cfif>">	
</form>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


