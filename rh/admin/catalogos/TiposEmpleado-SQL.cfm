
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="El_codigo_del_registro_que_desea_insertar_ya_existe"
Default="El c&oacute;digo del registro que desea insertar ya existe."
returnvariable="MG_CodigoYaExiste"/> 

<cfset modo = "ALTA">
<cfset modoDet = "ALTA">
<cfif not isdefined("Form.btnNuevoD") and  not isdefined("Form.btnNuevoE")>
	<cftransaction>
		<cftry>
			<cfset modo="CAMBIO">
			<!--- Caso 1: Agregar Tipo de Empleado --->
			<cfif isdefined("Form.btnAgregarE")>
				<cfquery name="rs" datasource="#session.DSN#">
					select 1
					from TiposEmpleado
					where TEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.TEcodigo#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>
	
				<cfif not rs.RecordCount gt 0 >
					<cfquery name="ABC_TiposEmpleadoInsert" datasource="#Session.DSN#">
						insert into TiposEmpleado (Ecodigo, TEcodigo, TEdescripcion)
						values (
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#Form.TEcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TEdescripcion#">
						)
						<cf_dbidentity1 datasource="#session.DSN#">
	<!--- 					select @@identity as TEid --->
					</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="ABC_TiposEmpleadoInsert">
				<cfelse>
					<cf_throw message="#MG_CodigoYaExiste#" errorcode="2140">
				</cfif>
	
				<cfif ABC_TiposEmpleadoInsert.identity NEQ 0>
					<cfset Form.TEid = ABC_TiposEmpleadoInsert.identity>
					<cfset modo = "CAMBIO">
				<cfelse>
					<cfset modo = "ALTA">
				</cfif>
				<cfset modoDet = "ALTA">
					
			<!--- Caso 1.1: Modifica Tipo de Empleado --->
			<cfelseif isdefined("Form.btnCambiarE")>
				<cfquery name="ConsultaTEmpleados" datasource="#session.DSN#">
					select 1
					from TiposEmpleado
					where TEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.TEcodigo#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and TEid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">				
				</cfquery>
				<cfif isdefined("ConsultaTEmpleados") and (ConsultaTEmpleados.RecordCount EQ 0)>
					<cfquery name="UpdateTEmpleados" datasource="#session.DSN#">
						update TiposEmpleado
						set TEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.TEcodigo#">,
							TEdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TEdescripcion#">
						where TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">		
					</cfquery>
				</cfif>
<!--- 				<cfquery name="ABC_TiposEmpleado" datasource="#Session.DSN#">
					if not exists (
						select 1
						from TiposEmpleado
						where TEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.TEcodigo#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and TEid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
					)
					update TiposEmpleado
					set TEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.TEcodigo#">,
						TEdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TEdescripcion#">
					where TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery> --->
				<cfset modo = "CAMBIO">
				<cfset modoDet = "ALTA">
					
			<!--- Caso 2: Borrar Tipo de Empleado --->
			<cfelseif isdefined("Form.btnBorrarE")>			
				<cfif isdefined("Form.TEid") AND Len(Trim(Form.TEid)) >
					<cfquery name="ExcepcionesPersonalesDelete" datasource="#Session.DSN#">
						delete from ExcepcionesPersonales 
						where TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
					</cfquery>
					<cfquery name="TiposEmpleadoDelete" datasource="#Session.DSN#">
						delete from TiposEmpleado
						where TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					</cfquery>
					<cfset modo = "ALTA">
					<cfset modoDet = "ALTA">
				</cfif>
	
			<!--- Caso 3: Agregar Excepciones Personales --->
			<cfelseif isdefined("Form.btnAgregarD")>
				<cfif isdefined("Form.TEid") AND Len(Trim(Form.TEid)) >
					<cfquery name="ABC_TiposEmpleado" datasource="#Session.DSN#">
						insert into ExcepcionesPersonales (TEid, Ttipopago, IRcodigo, EPmonto, EPmontomultiplicador, EPmontodependiente)
						values (
							<cfqueryparam value="#Form.TEid#" cfsqltype="cf_sql_numeric">,
							<cfqueryparam value="#Form.Ttipopago#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#Form.IRcodigo#" cfsqltype="cf_sql_char">,
							<cfqueryparam value="#Form.EPmonto#" cfsqltype="cf_sql_money">,
							<cfqueryparam value="#Form.EPmontomultiplicador#" cfsqltype="cf_sql_money">,
							<cfqueryparam value="#Form.EPmontodependiente#" cfsqltype="cf_sql_money">
						)
					</cfquery>
					<cfset modo = "CAMBIO">
					<cfset modoDet = "ALTA">
				</cfif>
					
			<!--- Caso 4: Modificar Detalle de Tabla de Evaluacion y modificar el encabezado --->			
			<cfelseif isdefined("Form.btnCambiarD")>
				<cfquery name="ABC_TiposEmpleado" datasource="#Session.DSN#">
					update ExcepcionesPersonales
					set	IRcodigo = <cfqueryparam value="#Form.IRcodigo#" cfsqltype="cf_sql_char">,
						EPmonto = <cfqueryparam value="#Form.EPmonto#" cfsqltype="cf_sql_money">,
						EPmontomultiplicador = <cfqueryparam value="#Form.EPmontomultiplicador#" cfsqltype="cf_sql_money">,
						EPmontodependiente = <cfqueryparam value="#Form.EPmontodependiente#" cfsqltype="cf_sql_money">
					where TEid = <cfqueryparam value="#Form.TEid#" cfsqltype="cf_sql_numeric">
					and EPid = <cfqueryparam value="#Form.EPid_del#" cfsqltype="cf_sql_numeric">
				</cfquery>
				<cfset modo = "CAMBIO">
				<cfset modoDet = "ALTA">
				
			<!--- Caso 5: Borrar detalle de tabla de Evaluacion --->
			<cfelseif isdefined("Form.btnBorrarD")>
				<cfquery name="ABC_TiposEmpleado" datasource="#Session.DSN#">
					delete from ExcepcionesPersonales 
					where TEid = <cfqueryparam value="#Form.TEid#" cfsqltype="cf_sql_numeric">
					and EPid = <cfqueryparam value="#Form.EPid_del#" cfsqltype="cf_sql_numeric">
				</cfquery>
				<cfset modo = "CAMBIO">
				<cfset modoDet = "ALTA">
				
			</cfif>
		<cfcatch type="any">
			<cfinclude template="/sif/errorPages/BDerror.cfm">
			<cfabort>
		</cfcatch>
		</cftry>		
	</cftransaction>	
<cfelse> 
	<cfif isdefined("Form.btnNuevoE")>
		<cfset modo = "ALTA" >
		<cfset modoDet = "ALTA">
	<cfelseif isdefined("Form.btnNuevoD")>
		<cfset modo = "CAMBIO" >
		<cfset modoDet = "ALTA">
	</cfif>

</cfif>

<cfoutput>
	<form action="TiposEmpleado.cfm" method="post" name="sql">
		<cfif modo EQ "CAMBIO">
			<input name="TEid" type="hidden" value="#Form.TEid#">
		<cfelseif not isdefined("Form.TEid") or isdefined("Form.btnNuevoE")>
			<input name="btnNuevo" type="hidden" value="1">
		</cfif>
		<cfif modo EQ "CAMBIO" and modoDet EQ "CAMBIO">
			<input name="EPid" type="hidden" value="#Form.EPid#">
		<cfelseif modo EQ "CAMBIO" and not isdefined("Form.EPid")>
			<input name="btnNuevoD" type="hidden" value="1">
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
