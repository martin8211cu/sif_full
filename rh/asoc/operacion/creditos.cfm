<cfinvoke 	default="Cr&eacute;ditos por Asociado" vsgrupo="103" returnvariable="nombre_proceso" component="sif.Componentes.TranslateDB" method="Translate" vsvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"/>
<!---=============== TRADUCCION =================--->
<cfinvoke key="LB_Semanal" default="Semanal" returnvariable="LB_Semanal" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/asoc/operacion/creditos-lista.xml"/>
<cfinvoke key="LB_Bisemanal" default="Bisemanal" returnvariable="LB_Bisemanal" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/asoc/operacion/creditos-lista.xml"/>
<cfinvoke key="LB_Quincenal" default="Quincenal"	returnvariable="LB_Quincenal" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/asoc/operacion/creditos-lista.xml"/>
<cfinvoke key="LB_Mensual" default="Mensual"	 returnvariable="LB_Mensual" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/asoc/operacion/creditos-lista.xml"/>
<cfinvoke key="LB_Todos" default="Todos"	 returnvariable="LB_Todos" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/asoc/operacion/creditos-lista.xml"/>
<cfinvoke key="LB_Filtrar" default="Filtrar"	 returnvariable="LB_Filtrar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/asoc/operacion/creditos-lista.xml"/>
<cfinvoke key="LB_Identificacion" default="Identificaci&oacute;n"	 returnvariable="LB_Identificacion" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/asoc/operacion/creditos-lista.xml"	/>
<cfinvoke key="LB_Asociado" default="Asociado"	 returnvariable="LB_Asociado" component="sif.Componentes.Translate" xmlfile="/rh/asoc/operacion/creditos-lista.xml" method="Translate"/>
<cfinvoke key="LB_Tipo_Credito" default="Tipo de Cr&eacute;dito"	 returnvariable="LB_Tipo_Credito" component="sif.Componentes.Translate" xmlfile="/rh/asoc/operacion/creditos-lista.xml" method="Translate"/>
<cfinvoke key="LB_Tipo_Nomina" default="Tipo N&oacute;mina"	 returnvariable="LB_Tipo_Nomina" component="sif.Componentes.Translate" xmlfile="/rh/asoc/operacion/creditos-lista.xml" method="Translate"/>
<cfinvoke key="LB_Periodicidad" default="Periodicidad" returnvariable="LB_Periodicidad" component="sif.Componentes.Translate" xmlfile="/rh/asoc/operacion/creditos-lista.xml" method="Translate"/>
<cfinvoke key="LB_Monto" default="Monto"	 returnvariable="LB_Monto" component="sif.Componentes.Translate" xmlfile="/rh/asoc/operacion/creditos-lista.xml" method="Translate"/>
<cfinvoke key="LB_Amortizado" default="Amortizado"	 returnvariable="LB_Amortizado" component="sif.Componentes.Translate" xmlfile="/rh/asoc/operacion/creditos-lista.xml" method="Translate"/>
<cfinvoke key="LB_Planilla" default="Planilla"	 returnvariable="LB_Planilla" component="sif.Componentes.Translate" xmlfile="/rh/asoc/operacion/creditos-lista.xml" method="Translate"/>
<cfinvoke key="LB_Fecha_Inicio" default="Fecha de Inicio" returnvariable="LB_Fecha_Inicio" component="sif.Componentes.Translate" xmlfile="/rh/asoc/operacion/creditos-lista.xml" method="Translate"/>
<cfinvoke key="LB_Plazo" default="Plazo" returnvariable="LB_Plazo" component="sif.Componentes.Translate" xmlfile="/rh/asoc/operacion/creditos-lista.xml" method="Translate"/>
<cfinvoke key="LB_Tasa" default="Tasa"	 returnvariable="LB_Tasa" component="sif.Componentes.Translate" xmlfile="/rh/asoc/operacion/creditos-lista.xml" method="Translate"/>
<cfinvoke key="LB_Tasa_mora" default="Tasa mora"	 returnvariable="LB_Tasa_mora" component="sif.Componentes.Translate" xmlfile="/rh/asoc/operacion/creditos-lista.xml" method="Translate"/>
<cfinvoke key="LB_Tipo_Nomina" default="Tipo N&oacute;mina"	 returnvariable="LB_Tipo_Nomina" component="sif.Componentes.Translate" xmlfile="/rh/asoc/operacion/creditos-lista.xml" method="Translate"/>
<cfinvoke key="LB_Empleado_sin_planilla" default=" Empleado sin planilla"	 returnvariable="LB_Empleado_sin_planilla" component="sif.Componentes.Translate" xmlfile="/rh/asoc/operacion/creditos-lista.xml" method="Translate"/>	
<cfinvoke key="LB_Informacion_del_Credito" default="Informaci&oacute;n del Cr&eacute;dito"	 returnvariable="LB_Informacion_del_Credito" component="sif.Componentes.Translate" xmlfile="/rh/asoc/operacion/creditos-lista.xml" method="Translate"/>	
<cfinvoke key="LB_Saldo" default="Saldo"	 returnvariable="LB_Saldo" component="sif.Componentes.Translate" xmlfile="/rh/asoc/operacion/creditos-lista.xml" method="Translate"/>

<cfif isdefined ('form.btnImportar')>
	<cflocation url="importarRegistroOperacionesCredito.cfm" >
</cfif>
<cfif isdefined("url.ACCAid") and not isdefined("form.ACCAid")>
	<cfset form.ACCAid = url.ACCAid >
</cfif>
<cfset modo = 'ALTA'>
<cfif isdefined("form.ACCAid") and len(trim(form.ACCAid)) >
	<cfset modo = 'CAMBIO'>
</cfif>

<cfset modificable = true >
<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="#session.DSN#">
		select ACCAid, ACAid, ACCTid, Ecodigo, Tcodigo, ACCTcapital, ACCTamortizado, ACCTplazo, ACCTtasa, ACPTtasaMora, ACCTfechaInicio, ACCAperiodicidad, ACCTcuotas
		from ACCreditosAsociado
		where ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACCAid#">
	</cfquery>
	<cfquery name="data_credito" datasource="#session.DSN#">
		select ACCTid,ACCTcodigo, ACCTdescripcion, ACCTplazo, ACCTtasa, ACCTtasaMora, ACCTmodificable 
		from ACCreditosTipo
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and ACCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.ACCTid#">
	</cfquery>
	
	<cfquery name="data_plan" datasource="#session.DSN#">
		select count(1) as registros
		from ACPlanPagos
		where ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACCAid#">
		and ACPPestado = 'S'
	</cfquery>

	<cfif data_plan.registros gt 0>
		<cfset modificable = false >
	</cfif>
	<cfset form.ACAid = data.ACAid >
</cfif>


<cf_templateheader title="Recursos Humanos">
<cf_web_portlet_start titulo="#nombre_proceso#">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr><td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
	<cfif modo neq 'ALTA' >
	<cfset Lvar_Activo = 0>
	<tr><td>
  		<tr><td colspan="4"><cfinclude template="../portlets/pAsociado.cfm"></td></tr>	
	</td></tr>
	</cfif>
	<tr>
	<td valign="top">
		<cf_tabs width="99%">
			<cf_tab text="#LB_Informacion_del_Credito#" selected="true">
				<cfinclude template="creditos-form.cfm">
			</cf_tab>
		</cf_tabs>	
		</td>	
	</tr>
</table>	
<cf_web_portlet_end>
<cf_templatefooter>