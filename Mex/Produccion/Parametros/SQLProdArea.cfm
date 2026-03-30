<cfparam  name="modo" default="ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfif isdefined("Form.Alta")>
			<cfquery name="ABC_TiposTransaccion" datasource="#Session.DSN#">
				insert into Prod_Area (ECodigo, APcodigo, APDescripcion, Dcodigo, APinterno)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.APcodigo#">, 										
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Descripcion#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">,                    
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Reporte#"> 
				)								
			</cfquery>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Baja")>						
			<cfquery name="ABC_TiposTransaccion" datasource="#Session.DSN#">
				delete from Prod_Area 
				where ECodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and APcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.APcodigo#">			
			</cfquery> 	  
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Cambio")>
			<cf_dbtimestamp datasource="#session.dsn#"
					table="Prod_Area"
					redirect="formProdArea.cfm"
					timestamp="#form.ts_rversion#"
					field1="APcodigo" 
					type1="numeric" 
					value1="#Form.APcodigo#"
					>
			<cfquery name="ABC_TiposTransaccion" datasource="#Session.DSN#">
				update Prod_Area set
					APDescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Descripcion#">,
                    Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">,                    
                    APinterno = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Reporte#"> 	
				where ECodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and APcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.APcodigo#">
			</cfquery>	
			<cfset modo="CAMBIO">				  				  
		</cfif>			
	<cfcatch type="any">
		<cfinclude template="../../sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<form action="ProdArea.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif modo neq 'ALTA'>
		<input name="APcodigo" type="hidden" value="<cfif isdefined("Form.APcodigo")><cfoutput>#Form.APcodigo#</cfoutput></cfif>">	
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


