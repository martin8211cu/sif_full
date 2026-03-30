<cfset modo = 'ALTA'>

<cfif not isdefined("Form.Nuevo")>
	<!----<cfquery name="Tipos" datasource="#session.DSN#">---->
	<!--- Agregar Tipo de EDExpediente --->
	<cfif isdefined("Form.Alta")>		
		<cfquery name="Insert" datasource="#session.DSN#">	
			insert into EDExpediente (EDEXcod, EDEXdes, BMUsucodigo, BMfalta)
			values (
					<cfqueryparam value="#Form.EDEXcod#" cfsqltype="cf_sql_numeric">, 
					<cfqueryparam value="#Form.EDEXdes#" cfsqltype="cf_sql_varchar">, 
					<cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				)
				<cf_dbidentity1 datasource="#session.dsn#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.dsn#" name="Insert">	
							
	<!--- Actualizar Tipo de EDExpediente --->
	<cfelseif isdefined("Form.Cambio")>
			
			<cf_dbtimestamp datasource="#session.dsn#"
				table="EDExpediente"
				redirect="formTiposExpediente-form.cfm"
				timestamp="#form.ts_rversion#"
				field1="EDEXid" 
				type1="numeric" 
				value1="#form.EDEXid#"
			>
				
		<cfquery  name="Update" datasource="#session.DSN#">
			update EDExpediente set
				EDEXid = <cfqueryparam value="#Form.EDEXid#" cfsqltype="cf_sql_char">, 
				EDEXdes = <cfqueryparam value="#Form.EDEXdes#" cfsqltype="cf_sql_varchar">,					
				BMUsucodigo = <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric"> 																			
			where EDEXid =  <cfqueryparam value="#Form.EDEXid#" cfsqltype="cf_sql_numeric">
		</cfquery>  
		<cfset modo = 'CAMBIO'>
			  
	<!--- Borrar Tipo de EDExpediente--->
	<cfelseif isdefined("form.Baja")>
		<cfquery name="Delete" datasource="#session.DSN#">
			delete EDExpediente
			where EDEXid =  <cfqueryparam value="#Form.EDEXid#" cfsqltype="cf_sql_numeric">
		</cfquery>
	</cfif>
</cfif>


<cfif isdefined("form.popup") and form.popup eq "s">  
<cfoutput>
<script>
var obj = window.parent.opener.document.getElementById('TiposExpediente');
obj.options[obj.length] = new Option("#form.EDEXcod# - #form.EDEXdes#", "#Insert.identity#");
obj.selectedIndex=obj.length-1;
window.close();
</script>
</cfoutput>
<cfelse>

<cfoutput>
<form action="TiposExpediente.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo NEQ 'ALTA'>
		<input name="EDEXid" type="hidden" value="#Form.EDEXid#">
	</cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>
</cfif> 
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>