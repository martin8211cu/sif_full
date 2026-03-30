<cfset modo = 'ALTA'>

<cfinvoke key="El_tipo_de_expediente_no_puede_ser_borrado_debido_a_que_posee_registros_asociados." default="El tipo de expediente no puede ser borrado debido a que posee Formatos o Conceptos asociados." returnvariable="LB_ErrorTipoExpediente" component="sif.Componentes.Translate" method="Translate"/>	

<cfif not isdefined("Form.Nuevo")>
	<!----<cfquery name="Tipos" datasource="#session.DSN#">---->
	<!--- Agregar Tipo de Expediente --->
	<cfif isdefined("Form.Alta")>		
		<cfquery name="Insert" datasource="#session.DSN#">	
			insert into TipoExpediente (TEcodigo, CEcodigo, TEdescripcion, Usucodigo, Ulocalizacion, TEfecha)
			values (
					<cfqueryparam value="#Form.TEcodigo#" cfsqltype="cf_sql_char">, 
					<cfqueryparam value="#Session.CEcodigo#" cfsqltype="cf_sql_numeric">, 
					<cfqueryparam value="#Form.TEdescripcion#" cfsqltype="cf_sql_varchar">, 
					<cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">, 
					'00',
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				)
		</cfquery>		
							
	<!--- Actualizar Tipo de Expediente --->
	<cfelseif isdefined("Form.Cambio")>
			
			<cf_dbtimestamp datasource="#session.dsn#"
				table="TipoExpediente"
				redirect="formTiposExpediente-form.cfm"
				timestamp="#form.ts_rversion#"
				field1="TEid" 
				type1="numeric" 
				value1="#form.TEid#"
				field2="CEcodigo" 
				type2="numeric" 
				value2="#Session.CEcodigo#"
			>
				
		<cfquery  name="Update" datasource="#session.DSN#">
			update TipoExpediente set
				TEcodigo = <cfqueryparam value="#Form.TEcodigo#" cfsqltype="cf_sql_char">, 
				TEdescripcion = <cfqueryparam value="#Form.TEdescripcion#" cfsqltype="cf_sql_varchar">,					
				Usucodigo = <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric"> 																			
			where CEcodigo = <cfqueryparam value="#Session.CEcodigo#" cfsqltype="cf_sql_numeric">
			  and TEid =  <cfqueryparam value="#Form.TEid#" cfsqltype="cf_sql_numeric">
		</cfquery>  
		<cfset modo = 'CAMBIO'>
			  
	<!--- Borrar Tipo de Expediente--->
	<cfelseif isdefined("form.Baja")>
		<cftry>
			<cfquery name="Delete" datasource="#session.DSN#">
				delete from TipoExpediente
				where CEcodigo = <cfqueryparam value="#session.CEcodigo#" cfsqltype="cf_sql_numeric">
				  and TEid =  <cfqueryparam value="#Form.TEid#" cfsqltype="cf_sql_numeric">
			</cfquery>
		<cfcatch type="any">
			 <cf_throw message="#LB_ErrorTipoExpediente#" errorcode="51">
		</cfcatch>
		
		</cftry>
	</cfif>
</cfif>

<cfoutput>

<form action="TiposExpediente.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo NEQ 'ALTA'>
		<input name="TEid" type="hidden" value="#Form.TEid#">
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