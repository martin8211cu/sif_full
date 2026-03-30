<cfset modo = 'ALTA'>

<!--- <cf_dump var="#form#"> --->

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>		
		<cfquery name="RSValida" datasource="#session.DSN#">
			select RHOSid from RHObjetivosSeguimiento
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
			and RHOScodigo =  <cfqueryparam value="#Form.RHOScodigo#" cfsqltype="cf_sql_char">
		</cfquery>
		<cfif RSValida.recordCount eq 0>
			<cfquery name="Insert" datasource="#session.DSN#">	
				insert into RHObjetivosSeguimiento (RHOScodigo,RHOStexto,RHTOid,Ecodigo,RHOSporcentaje,RHOSpeso,BMUsucodigo ,BMfechaalta)
				values (
						<cfqueryparam value="#Form.RHOScodigo#" cfsqltype="cf_sql_char">, 
						<cfqueryparam value="#Form.RHOStexto#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#Form.RHTOid#" cfsqltype="cf_sql_numeric">, 
						<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">, 
						<cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHOSporcentaje, ',','','all')#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHOSpeso, ',','','all')#">,
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
				table="RHObjetivosSeguimiento"
				redirect="Objetivos.cfm"
				timestamp="#form.ts_rversion#"
				field1="RHOSid" 
				type1="numeric" 
				value1="#form.RHOSid#"
			>
				
		<cfquery  name="Update" datasource="#session.DSN#">
			update RHObjetivosSeguimiento set
				RHOScodigo 		=<cfqueryparam value="#Form.RHOScodigo#" cfsqltype="cf_sql_char">, 
				RHOStexto 		=<cfqueryparam value="#Form.RHOStexto#" cfsqltype="cf_sql_varchar">,	
				RHTOid 			=<cfqueryparam value="#Form.RHTOid#" cfsqltype="cf_sql_numeric">, 
				RHOSporcentaje	=<cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHOSporcentaje, ',','','all')#">,
				RHOSpeso 		=<cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHOSpeso, ',','','all')#">,
				BMUsucodigo 	=<cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric"> 																			
			where Ecodigo 		=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
			  and RHOSid 		=<cfqueryparam value="#Form.RHOSid#" cfsqltype="cf_sql_numeric">
		</cfquery>  
		<cfset modo = 'CAMBIO'>
			  
	<!--- Borrar Tipo de Expediente--->
	<cfelseif isdefined("form.Baja")>
		<cfquery name="Delete" datasource="#session.DSN#">
			delete from RHObjetivosSeguimiento
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
			  and RHOSid =  <cfqueryparam value="#Form.RHOSid#" cfsqltype="cf_sql_numeric">
		</cfquery>
	</cfif>
</cfif>

<cfoutput>
<form action="Objetivos.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo NEQ 'ALTA'>
		<input name="RHOSid" type="hidden" value="#Form.RHOSid#">
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

