<cfparam name="modo" default="ALTA">
		
<cfif not isdefined("Form.Nuevo")>
	
		<cfif isdefined("Form.Alta")>
			<cfquery name="insClienteDetallistaTipoDoc" datasource="#Session.DSN#">			
				insert into ClienteDetallistaTipoDoc (CEcodigo, TDdescripcion)
        		values 
				(				
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#"> , 
					 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TDdescripcion#">)) 
				)
			</cfquery>
			<cfset modo="ALTA">

		<cfelseif isdefined("Form.Baja")>
				<cfquery name="delClienteDetallistaTipoDoc" datasource="#Session.DSN#">
					delete from ClienteDetallistaTipoDoc
					where CEcodigo = <cfqueryparam value="#Session.CEcodigo#" cfsqltype="cf_sql_integer">
					  and TDid = <cfqueryparam value="#Form.TDid#" cfsqltype="cf_sql_integer">
					  <cfset modo="ALTA">
				</cfquery>
			<cfelseif isdefined("Form.Cambio")>
				<cf_dbtimestamp datasource="#Session.DSN#"
							table="ClienteDetallistaTipoDoc"
							redirect="TipoDoc.cfm"
							timestamp="#Form.ts_rversion#"
							field1="CEcodigo" 		type1="integer"  value1="#Session.CEcodigo#"
							field2="TDid" 			type2="varchar"  value2="#Form.TDid#">
							
				<cfquery name="updClienteDetallistaTipoDoc" datasource="#Session.DSN#">
					update ClienteDetallistaTipoDoc set 
						TDdescripcion=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TDdescripcion#">
					where CEcodigo = <cfqueryparam 	value="#Session.CEcodigo#" 	cfsqltype="cf_sql_integer">
					  and TDid = <cfqueryparam 		value="#Form.TDid#" 		cfsqltype="cf_sql_integer">			
 				</cfquery>
				<cfset modo="CAMBIO">
			</cfif>
</cfif>
<form action="TipoDoc.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif modo neq 'ALTA'>
		<input name="TDid" type="hidden" value="<cfif isdefined("Form.TDid")><cfoutput>#Form.TDid#</cfoutput></cfif>">
	</cfif>
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">		
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

