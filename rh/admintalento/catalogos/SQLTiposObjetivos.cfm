<cfset modo = 'ALTA'>

<!--- <cf_dump var="#form#"> --->

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>		
		<cfquery name="RSValida" datasource="#session.DSN#">
			select RHTOid from RHTipoObjetivo
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
			and RHTOcodigo =  <cfqueryparam value="#Form.RHTOcodigo#" cfsqltype="cf_sql_char">
		</cfquery>
		<cfif RSValida.recordCount eq 0>
			<cfquery name="Insert" datasource="#session.DSN#">	
				insert into RHTipoObjetivo (RHTOcodigo, Ecodigo, RHTOdescripcion, BMUsucodigo,BMfechaalta)
				values (
						<cfqueryparam value="#Form.RHTOcodigo#" cfsqltype="cf_sql_char">, 
						<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">, 
						<cfqueryparam value="#Form.RHTOdescripcion#" cfsqltype="cf_sql_varchar">, 
						<cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
					)
			</cfquery>		
		<cfelse>
		    <cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Mensaje"
			Default="El c&oacute;digo digitado ya existe."
			returnvariable="LB_Mensaje"/>
			<cfthrow message="#LB_Mensaje#">
		</cfif>					
	<!--- Actualizar Tipo de Expediente --->
	<cfelseif isdefined("Form.Cambio")>
			
			<cf_dbtimestamp datasource="#session.dsn#"
				table="RHTipoObjetivo"
				redirect="TiposObjetivos.cfm"
				timestamp="#form.ts_rversion#"
				field1="RHTOid" 
				type1="numeric" 
				value1="#form.RHTOid#"
			>
				
		<cfquery  name="Update" datasource="#session.DSN#">
			update RHTipoObjetivo set
				RHTOcodigo = <cfqueryparam value="#Form.RHTOcodigo#" cfsqltype="cf_sql_char">, 
				RHTOdescripcion = <cfqueryparam value="#Form.RHTOdescripcion#" cfsqltype="cf_sql_varchar">,					
				BMUsucodigo = <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric"> 																			
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
			  and RHTOid =  <cfqueryparam value="#Form.RHTOid#" cfsqltype="cf_sql_numeric">
		</cfquery>  
		<cfset modo = 'CAMBIO'>
			  
	<!--- Borrar Tipo de Expediente--->
	<cfelseif isdefined("form.Baja")>
		<cfquery name="Delete" datasource="#session.DSN#">
			delete from RHTipoObjetivo
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
			  and RHTOid =  <cfqueryparam value="#Form.RHTOid#" cfsqltype="cf_sql_numeric">
		</cfquery>
	</cfif>
</cfif>

<cfoutput>

<form action="TiposObjetivos.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo NEQ 'ALTA'>
		<input name="RHTOid" type="hidden" value="#Form.RHTOid#">
	</cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

