<cfinclude template="CierreIntereses-Etiquetas.cfm">
<!--- PERIODO ACTUAL --->
<cfquery name="rs_parametro_10" datasource="#session.DSN#">
	select Pvalor as periodo
	from ACParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 10
</cfquery>
<!--- MES ACTUAL --->
<cfquery name="rs_parametro_20" datasource="#session.DSN#">
	select Pvalor as mes
	from ACParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 20
</cfquery>
<!--- PERIODO DE INTERESES LIQUIDADO --->
<cfquery name="rs_parametro_150" datasource="#session.DSN#">
	select Pvalor as Periodo
	from ACParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 150
</cfquery>
<!--- MES DE INTERESES LIQUIDADO --->
<cfquery name="rs_parametro_160" datasource="#session.DSN#">
	select Pvalor as Mes
	from ACParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 160
</cfquery>
<cfif rs_parametro_150.recordcount and rs_parametro_160.recordcount>
<cfset FechaLiquidacion = CreateDate(rs_parametro_150.periodo,rs_parametro_160.mes,1)>
<cfelse>
	<cfthrow message="#MSG_Parametros#">
</cfif>
<cfset FechaActual = CreateDate(rs_parametro_10.periodo,rs_parametro_20.mes,1)>

<!--- VERIFICA SI SE HA REALIZADO ALGUN PROCESO DE CIERRE DE INTERESES, 
	  VERIFICANDO SI HAY ALGUN REGISTRO EN APORTES SALDO DONDE LOS INTERESES DEL MES ESTAN EN NEGATIVO
	  Y EL ACUMULADO DEL APORTE, ACUMULADO DE INTERÉS Y APORTE MES ESTAN EN CERO.
 --->
<cfquery name="rsVerifLiquidacion" datasource="#session.DSN#">
	select 1
	from ACAportesSaldos
	where ACAStipo = 'L'
</cfquery>


<cfif DateCompare(FechaActual,FechaLiquidacion) LTE 0>
	<cfset var_mes = rs_parametro_160.mes>
<cfelse>
	<cfset var_mes = rs_parametro_20.mes>
</cfif>
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
<!--- PROCESO TERMINADO CON EXITO --->
<cfif isdefined("url.cierre") and isdefined("url.periodo") and isdefined("url.mes")>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr><td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
		<tr><td valign="top" align="center"><strong>#lb_exito#</strong></td></tr>
		<tr><td valign="top" align="center"><strong>#LB_Periodo_Mes#: #v_mes# #url.periodo#</strong></td></tr>
		<tr><td align="center"><input type="button" name="Regresar" value="#BTN_Regresar#" class="btnAnterior" onclick="location.href='cierreIntereses.cfm'"></td></tr>
	</table>
<cfelseif DateCompare(FechaActual,FechaLiquidacion) LTE 0>
	<cfif DateCompare(FechaActual,FechaLiquidacion) GTE 0 and rsVerifLiquidacion.RecordCount EQ 0>
		<!--- NUNCA SE HA REALIZADO EL PROCESO --->
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr><td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
			<tr><td valign="top" align="center"><strong>#MSG_PrimerProceso#</strong></td></tr>
			<tr><td valign="top" align="center"><strong>#LB_Periodo_Mes#: #v_mes# #rs_parametro_150.periodo#</strong></td></tr>
		</table>
	<cfelse>
		<!--- EL PROCESO SE REALIZÓ Y NO HAY INTERESES POR LIQUIDAR --->
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr><td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
			<tr><td valign="top" align="center"><strong>#MSG_ProcesoRealizado#</strong></td></tr>
			<tr><td valign="top" align="center"><strong>#LB_Periodo_Mes#: #v_mes# #rs_parametro_150.periodo#</strong></td></tr>
		</table>
	</cfif>
<cfelse>
	<!--- HAY INTERESES POR LIQUIDAR --->
	<form name="form1" method="post" action="cierreIntereses-sql.cfm" style="margin:0;">
		<table width="50%" cellpadding="2" cellspacing="2" class="ayuda" align="center">
			<tr><td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
			<tr><td valign="top" align="center"><strong>#LB_Proceso_Cierre#</strong></td></tr>
			<tr><td valign="top"><strong>#LB_Periodo_Mes# #v_mes# #rs_parametro_10.periodo#</strong></td></tr>
			<tr>
				<td valign="top">
					<cf_translate key="DescProceso">
						Este proceso va a generar el cierre de Intereses para el Periodo/Mes anterior al Periodo/Mes actual. 
						Generando el registro de liquidaci&oacute;n de intereses y actualizando los saldos iniciales de inter&eacute;s del Periodo/Mes actual en cero.
					</cf_translate>
				</td>
			</tr>
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