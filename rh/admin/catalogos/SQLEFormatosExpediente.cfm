<cfparam name="action" default="FormatosPrincipal.cfm">
<cfparam name="ef_modo" default="ALTA">

<cfinvoke key="El_registro_no_puede_ser_borrado_debido_a_que_posee_dependencias_con_otros_registros_asociados."default="El registro no puede ser borrado debido a que posee dependencias con otros registros asociados." returnvariable="LB_ErrorEFormatos" component="sif.Componentes.Translate" method="Translate"/>	

<cftransaction>
	<cfif not isdefined("form.NuevoE") >
		<!--- Caso 1: Agregar Encabezado --->
		<cfif isdefined("Form.AltaEF")>
			<cfquery name="Insert" datasource="#Session.DSN#">
				insert into EFormatosExpediente ( TEid, EFEcodigo, EFEdescripcion, Usucodigo, Ulocalizacion, EFEfecha)
				values ( <cfqueryparam value="#form.TEid#"             cfsqltype="cf_sql_numeric">, 
						'#form.EFEcodigo#', 
						'#form.EFEdescripcion#', 
						<cfqueryparam value="#session.Usucodigo#"     cfsqltype="cf_sql_numeric">,
						<cfqueryparam value="#session.Ulocalizacion#" cfsqltype="cf_sql_numeric">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
						)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>	
			<cf_dbidentity2 datasource="#session.DSN#" name="Insert">
			
			<cfset ef_modo="CAMBIO">
			<cfset action = "FormatosPrincipal.cfm">
			
		<!--- Caso 2: Borrar un Encabezado de Formato de Expediente  --->
		<!--- Debe borrar los detalles,  acciones y usuarios --->
		<cfelseif isdefined("Form.BajaEF")>
			<cfquery name="DeleteDetalle" datasource="#session.DSN#">
				delete from DFormatosExpediente
				where EFEid = <cfqueryparam value="#form.EFEid#" cfsqltype="cf_sql_numeric">
			</cfquery>	
			
			<cftry>
				
				<cfquery name="DeleteEncab" datasource="#session.DSN#">
					delete from EFormatosExpediente
					where EFEid = <cfqueryparam value="#form.EFEid#" cfsqltype="cf_sql_numeric">
					  and TEid  = <cfqueryparam value="#form.TEid#" cfsqltype="cf_sql_numeric">
				</cfquery>
				
				<cfcatch type="any">
				 <cf_throw message="#LB_ErrorEFormatos#" errorcode="51">
				</cfcatch>
			
			</cftry>
			
		<!--- Caso 3: Agregar Detalle de Requisicion y opcionalmente modificar el encabezado --->
		<cfelseif isdefined("Form.CambioEF")>
			<!--- Modificar Encabezado, unicamente si se modifico alguno de los campos --->
			<cf_dbtimestamp datasource="#session.dsn#"
				table="EFormatosExpediente"
				redirect="form-EFormatosExpediente.cfm"
				timestamp="#form.ts_rversion#"
				field1="TEid" 
				type1="numeric" 
				value1="#form.TEid#"
				field2="EFEid" 
				type2="numeric" 
				value2="#form.EFEid#"
			>	
			
			<cfquery name="UpdateEncab" datasource="#session.dsn#">
				update EFormatosExpediente
				set EFEcodigo = <cfqueryparam value="#form.EFEcodigo#" cfsqltype="cf_sql_char">, 
					EFEdescripcion = <cfqueryparam value="#form.EFEdescripcion#"   cfsqltype="cf_sql_varchar"> 
				where EFEid = <cfqueryparam value="#form.EFEid#" cfsqltype="cf_sql_numeric">
				  and TEid  = <cfqueryparam value="#form.TEid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfset ef_modo="CAMBIO">
			<cfset action = "FormatosPrincipal.cfm">
		</cfif>
	<cfelse>
		<cfset action = "FormatosPrincipal.cfm" >
	</cfif>
</cftransaction>	

<!----	
<cfif isdefined("form.EFEid") and len(Trim(form.EFEid)) eq 0 >
	<cfset form.EFEid = "#abc_eformatosExpediente.id#">
</cfif>
--->
<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="ef_modo"   type="hidden" value="<cfif isdefined("ef_modo")>#ef_modo#</cfif>">
	<input name="TEid"   type="hidden" value="<cfif isdefined("form.TEid")>#form.TEid#</cfif>">
	<!---<input name="EFEid"   type="hidden" value="<cfif isdefined("form.EFEid") and ef_modo neq 'ALTA' >#form.EFEid#</cfif>">--->
	<input name="EFEid" type="hidden" value="<cfif isdefined("Insert")>#Insert.identity#<cfelse>#Form.EFEid#</cfif>">
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