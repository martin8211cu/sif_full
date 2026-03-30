
<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="CuentasConceptos" datasource="#Session.DSN#">
		set nocount on
			<cfif isdefined("Form.Alta")>
				if not exists (select Ccodigo from CuentasConceptos  
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
  				  and Ccodigo = <cfqueryparam value="#Form.Ccodigo#" cfsqltype="cf_sql_char">
				  and Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">
				  and Cid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(Form.Cid)#">
				)
				insert CuentasConceptos (Ecodigo, Ccodigo, Dcodigo, Ccuenta, Ccuentadesc, Cid)
        		values 
				(	
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> , 				
					rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ccodigo#">)),
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuentadesc#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">					
				 )
				 else 
				  	select 1
				 
			<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
				delete from CuentasConceptos
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			      and Ccodigo = <cfqueryparam value="#Form.Ccodigo#" cfsqltype="cf_sql_char">
				  and Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">
				  and Cid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">
				  <cfset modo="BAJA">
			<cfelseif isdefined("Form.Cambio")>
				update CuentasConceptos  set 
					Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">,
					Ccuentadesc = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuentadesc#">
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			      and Ccodigo = <cfqueryparam value="#Form.Ccodigo#" cfsqltype="cf_sql_char">
				  and Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">
				  and Cid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">
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

<form action="CtasConcepto.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="Cid" type="hidden" value="<cfif isdefined("Form.Cid")><cfoutput>#Form.Cid#</cfoutput></cfif>">
 	<input name="Ccodigo" type="hidden" value="<cfif isdefined("Form.Ccodigo")><cfoutput>#Form.Ccodigo#</cfoutput></cfif>">
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


