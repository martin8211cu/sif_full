<cfinvoke component="sif.Componentes.TranslateDB"
	method="Translate"
	vsvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
	default="Cr&eacute;ditos por Asociado"
	vsgrupo="103"
	returnvariable="nombre_proceso"/>
<!---=============== TRADUCCION =================--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Proceso_de_Cierre_de_Mes_para_Asociacion_Solidarista"
	default="Proceso de Cierre de Mes para Asociaci&oacute;n Solidarista"
	returnvariable="LB_Proceso_Cierre"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Mes_y_Periodo_de_Cierre"
	default="Mes y Per&iacute;odo de Cierre"
	returnvariable="LB_Periodo_Mes"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Error._No_se_definido_el_mes_de_trabajo_para_la_asociacion"
	default="Error. No se ha definido el mes de trabajo para la asociaci&oacute;n"
	returnvariable="LB_No_mes"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Error._No_se_ha_el_periodo_de_trabajo_para_la_asociacion"
	default="Error. No se ha definido el periodo de trabajo para la asociaci&oacute;n"
	returnvariable="LB_No_periodo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="BTN_Cerrar_Mes"
	default="Cerrar Mes"
	returnvariable="BTN_Cerrar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="BTN_Regresar"
	default="Regresar"
	xmlfile="/rh/generales.xml"
	returnvariable="BTN_Regresar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_Va_a_ejecutar_el_proceso_de_cierre_de_mes_para_la_asociacion._Desea_continuar?"
	default="Va a ejecutar el proceso de cierre de mes para la Asociacion. Desea continuar?"
	returnvariable="lb_Cerrar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_Proceso_de_Cierre_de_Mes_para_la_Asociacion_ejecutado_exitosamente"
	default="Proceso de Cierre de Mes para la Asociaci&oacute;n ejecutado exitosamente"
	returnvariable="lb_exito"/>

<cfquery name="rs_parametro_10" datasource="#session.DSN#">
	select Pvalor as periodo
	from ACParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 10
</cfquery>
<cfquery name="rs_parametro_20" datasource="#session.DSN#">
	select Pvalor as mes
	from ACParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 20
</cfquery>

<cfset var_mes = rs_parametro_20.mes>
<cfif isdefined("url.cierre") and isdefined("url.periodo") and isdefined("url.mes")>
	<cfset var_mes = url.mes>
<cfelse>
	<cfif len(trim(rs_parametro_10.periodo)) eq 0 >
		<cfthrow detail="#LB_No_periodo#" >
	</cfif>
	<cfif len(trim(rs_parametro_20.mes)) eq 0 >
	
		<cfthrow detail="#LB_No_mes#" >
	</cfif>
</cfif>

<cfquery name="rs_mes_traduccion" datasource="#session.DSN#">
	select VSdesc as mes
	from Idiomas a
		inner join VSidioma b
		on b.Iid = a.Iid
		and b.VSgrupo = 1
	where Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.idioma#">
	and VSvalor = <cfqueryparam cfsqltype="cf_sql_char" value="#var_mes#">
</cfquery>
<cfif len(trim(rs_mes_traduccion.mes)) eq 0 >
	<cfset lista_meses = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre'>
	<cfif isdefined("url.cierre") and isdefined("url.periodo") and isdefined("url.mes")>
		<cfif var_mes+1 gt 12><cfset var_mes = 0 ></cfif>
		<cfset v_mes = listgetat(lista_meses, var_mes+1) >
	<cfelse>
		<cfset v_mes = listgetat(lista_meses, var_mes) >
	</cfif>
<cfelse>
	<cfset v_mes = rs_mes_traduccion.mes >
</cfif>

<cf_templateheader title="Recursos Humanos">
<cf_web_portlet_start titulo="#nombre_proceso#">
<cfoutput>
<cfif isdefined("url.cierre") and isdefined("url.periodo") and isdefined("url.mes")>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr><td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
		<tr><td valign="top" align="center"><strong>#lb_exito#</strong></td></tr>
		<tr><td valign="top" align="center"><strong>#LB_Periodo_Mes#: #v_mes# #url.periodo#</strong></td></tr>
		<tr><td align="center"><input type="button" name="Regresar" value="#BTN_Regresar#" class="btnAnterior" onclick="location.href='cierreMes.cfm'"></td></tr>
	</table>
<cfelse>
	<form name="form1" method="post" action="cierreMes-sql.cfm" style="margin:0;">
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr><td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
			<tr><td valign="top" align="center"><strong>#LB_Proceso_Cierre#</strong></td></tr>
			<tr><td valign="top" align="center"><strong>#LB_Periodo_Mes#: #v_mes# #rs_parametro_10.periodo#</strong></td></tr>
			<tr><td align="center"><input type="submit" name="Cerrar" value="#BTN_Cerrar#" class="btnAplicar" onclick="return cerrar();"></td></tr>
		</table>
		<input type="hidden" name="periodo" value="#rs_parametro_10.periodo#">
		<input type="hidden" name="mes" 	value="#rs_parametro_20.mes#">	
	</form>
</cfif>
</cfoutput>

<script language="javascript1.2" type="text/javascript">
	function cerrar(){
		return confirm('<cfoutput>#lb_cerrar#</cfoutput>');
	}
</script>



<cf_web_portlet_end>
<cf_templatefooter>