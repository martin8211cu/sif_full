<cfinvoke component="sif.Componentes.TranslateDB"
	method="Translate"
	vsvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
	default="Registro manual de Pagos"
	vsgrupo="103"
	returnvariable="nombre_proceso"/>
<!---=============== TRADUCCION =================--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="BTN_Filtrar"
	default="Filtrar"
	xmlfile="/rh/generales.xml"	
	returnvariable="LB_Filtrar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Identificacion"
	default="Identificaci&oacute;n"	
	xmlfile="/rh/generales.xml"		
	returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Fecha_Inicio"
	default="Fecha Inicio"	
	xmlfile="/rh/generales.xml"		
	returnvariable="LB_Fecha_Inicio"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Asociado"
	default="Asociado"
	xmlfile="/rh/asoc/general.xml"		
	returnvariable="LB_Asociado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Tipo_Credito"
	xmlfile="/rh/asoc/general.xml"			
	default="Tipo de Cr&eacute;dito"	
	returnvariable="LB_Tipo_Credito"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Monto"
	default="Monto"	
	xmlfile="/rh/asoc/general.xml"				
	returnvariable="LB_Monto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Amortizado"
	default="Amortizado"	
	xmlfile="/rh/asoc/general.xml"				
	returnvariable="LB_Amortizado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Saldo"
	default="Saldo"	
	xmlfile="/rh/asoc/general.xml"				
	returnvariable="LB_Saldo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Monto_Pago"
	default="Monto pago"	
	xmlfile="/rh/asoc/general.xml"				
	returnvariable="LB_Monto_Pago"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="BTN_Nuevo"
	default="Nuevo"	
	xmlfile="/rh/generales.xml"
	returnvariable="BTN_Nuevo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Todos"
	default="Todos"	
	xmlfile="/rh/generales.xml"
	returnvariable="LB_Todos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_No_Empleado"
	default="Error. Debe seleccionar un empleado para trabajar con esta operaci&oacute;n"	
	xmlfile="/rh/generales.xml"
	returnvariable="LB_No_Empleado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Informacion_del_Credito"
	default="Informaci&oacute;n del Cr&eacute;dito"	
	xmlfile="/rh/asoc/general.xml"				
	returnvariable="LB_Informacion_del_Credito"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Semanal"
	default="Semanal"
	xmlfile="/rh/asoc/operacion/creditos-lista.xml"	
	returnvariable="LB_Semanal"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Bisemanal"
	default="Bisemanal"	
	xmlfile="/rh/asoc/operacion/creditos-lista.xml"								
	returnvariable="LB_Bisemanal"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Quincenal"
	default="Quincenal"	
	xmlfile="/rh/asoc/operacion/creditos-lista.xml"								
	returnvariable="LB_Quincenal"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Mensual"
	default="Mensual"	
	xmlfile="/rh/asoc/operacion/creditos-lista.xml"								
	returnvariable="LB_Mensual"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Periodicidad"
	default="Periodicidad"
	xmlfile="/rh/asoc/operacion/creditos-lista.xml"									
	returnvariable="LB_Periodicidad"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Plazo"
	default="Plazo"	
	xmlfile="/rh/asoc/operacion/creditos-lista.xml"								
	returnvariable="LB_Plazo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Tasa"
	default="Tasa"	
	xmlfile="/rh/asoc/operacion/creditos-lista.xml"								
	returnvariable="LB_Tasa"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Tasa_mora"
	default="Tasa mora"	
	xmlfile="/rh/asoc/operacion/creditos-lista.xml"								
	returnvariable="LB_Tasa_mora"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Creditos_correspondientes_al_asociado"
	default="Cr&eacute;ditos correspondientes al asociado"
	xmlfile="/rh/asoc/general.xml"								
	returnvariable="LB_Creditos_correspondientes_al_asociado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Aplicar_Pago_cuotas"
	default="Aplicar Pago de Cuotas"
	xmlfile="/rh/asoc/general.xml"								
	returnvariable="LB_Aplicar_Pago"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Pagar_la_siguiente_cantidad_de_cuotas"
	default="Pagar la siguiente cantidad de cuotas"
	xmlfile="/rh/asoc/general.xml"								
	returnvariable="LB_Aplicar_pago2"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Num_Cuotas"
	default="N&uacute;mero de Cuotas"
	xmlfile="/rh/asoc/general.xml"								
	returnvariable="LB_Num_Cuotas"/>	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Esta_seguro_de_aplicar_el_pago_de_cuotas?"
	default="Esta seguro de aplicar el pago de cuotas?"
	xmlfile="/rh/asoc/general.xml"								
	returnvariable="LB_Confirmar_Cuotas"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Monto_Cuota"
	default="Monto Cuota"
	xmlfile="/rh/asoc/general.xml"								
	returnvariable="LB_Cuota"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Cuotas_Restantes"
	default="Cuotas sin pagar"
	xmlfile="/rh/asoc/general.xml"								
	returnvariable="LB_Cuotas_Restantes"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Aplicar_a_siguientes_pagos_del_plan"
	default="Aplicar a siguientes pagos del plan"
	xmlfile="/rh/asoc/general.xml"								
	returnvariable="LB_Siguientes"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Aplicar_a_ultimos_pagos_del_plan"
	default="Aplicar a &uacute;ltimos pagos del plan"
	xmlfile="/rh/asoc/general.xml"								
	returnvariable="LB_Ultimos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Orden_de_aplicacion"
	default="Orden de aplicaci&oacute;n"
	xmlfile="/rh/asoc/general.xml"								
	returnvariable="LB_Orden"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Se_presentaron_los_siguientes_errores"
	default="Se presentaron los siguientes errores"
	xmlfile="/rh/asoc/general.xml"								
	returnvariable="LB_Errores"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_El_numero_de_cuotas_debe_ser_mayor_que_cero"
	default="El numero de cuotas debe ser mayor que cero"
	xmlfile="/rh/asoc/general.xml"								
	returnvariable="LB_Num_cuotas1"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Se_registro_exitosamente_el_pago_de_cuotas"
	default="Se registro exitosamente el pago de cuotas"
	xmlfile="/rh/asoc/general.xml"								
	returnvariable="LB_Exito_Cuotas"/>

<cfif isdefined("url.ACAid") and not isdefined("form.ACAid")>
	<cfset form.ACAid = url.ACAid >
</cfif>
<cfif isdefined("url.ACCAid") and not isdefined("form.ACCAid")>
	<cfset form.ACCAid = url.ACCAid >
</cfif>

<cfif not isdefined("form.ACAid")>
	<cfthrow detail="#LB_No_Empleado#">
</cfif>

<cfset modo = 'ALTA'>
<cfif isdefined("form.ACAid") and len(trim(form.ACAid)) and isdefined("form.ACCAid") and len(trim(form.ACCAid)) >
	<cfset modo = 'CAMBIO'>
</cfif>

<cfinvoke component="rh.asoc.Componentes.RH_PlanPagos" method="init" returnvariable="plan">
<cfif modo neq 'ALTA'>
	<cfset data = plan.obtenerCredito( form.ACCAid, session.DSN ) >
	<cfset data_credito = plan.obtenerTipoCredito(data.ACCTid, session.DSN ) >
	<cfset monto_cuota = plan.obtenerCuota( form.ACCAid, session.DSN ) >
	<cfset cuotas_por_pagar = plan.existenPagos( form.ACCAid, session.DSN, '', 'P' ) > <!--- P: incluye cuotas tipo N(nomina) y M(manual) --->
	<cfset parametro = plan.obtenerParametro(session.Ecodigo, 40, session.DSN) > 
</cfif>

<cf_templateheader title="Recursos Humanos">
<cf_web_portlet_start titulo="#nombre_proceso#">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr><td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
	<tr><td>
		<cfset Lvar_Activo = 0>
  		<tr><td colspan="4"><cfinclude template="/rh/portlets/pAsociado.cfm"></td></tr>	
	</td></tr>
	<tr>
	<td valign="top">
		<cf_tabs width="99%">
			<cf_tab text="#LB_Informacion_del_Credito#" selected="true">
				<cfinclude template="pagomanual-form.cfm">
			</cf_tab>
		</cf_tabs>	
		</td>	
	</tr>
</table>	
<cf_web_portlet_end>
<cf_templatefooter>