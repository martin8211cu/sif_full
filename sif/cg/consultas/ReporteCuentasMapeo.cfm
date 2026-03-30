<cfinvoke key="LB_Titulo" default="Reporte de Cuentas de Mapeo" returnvariable="LB_Titulo" component="sif.Componentes.Translate" method="Translate" xmlfile="ReporteCuentasMapeo.xml"/>
<cfinvoke key="LB_ListaMapeoCuentas" default="Lista Mapeo de Cuentas" returnvariable="LB_ListaMapeoCuentas" component="sif.Componentes.Translate" method="Translate" xmlfile="ReporteCuentasMapeo.xml"/>
<cfinvoke key="LB_Codigo" default="C&oacute;digo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate" xmlfile="ReporteCuentasMapeo.xml"/>
<cfinvoke key="LB_Nombre" default="Nombre" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate" xmlfile="ReporteCuentasMapeo.xml"/>
<cfif isdefined("LvarInfo")>
	<cfset LvarAction     = 'ReporteCuentasMapeo_SQL_INFO.cfm'>
	<cfset LvarReporte1   = 'ReporteCuentasMapeo_SQL_INFO.cfm'>
	<cfset LvarReporte2   = 'ReporteCuentasMapDet_SQL_INFO.cfm'>
	<cfset LvarReporte3   = 'ReporteCuentasSinMapear_SQL_INFO.cfm'>
	<cfset LvarReporte4   = 'ReporteSalidaLayoutExterno_INFO.cfm'>
<cfelse>
	<cfset LvarAction     = 'ReporteCuentasMapeo_SQL.cfm'>
	<cfset LvarReporte1   = 'ReporteCuentasMapeo_SQL.cfm'>
	<cfset LvarReporte2   = 'ReporteCuentasMapDet_SQL.cfm'>
	<cfset LvarReporte3   = 'ReporteCuentasSinMapear_SQL.cfm'>
	<cfset LvarReporte4   = 'ReporteSalidaLayoutExterno.cfm'>
</cfif>

<!--- 	
	Creado por Gustavo Fonseca H.
		Fecha: 16-1-2007.
		Motivo: Nuevo reporte de Cuentas de Mapeo. 
--->

<cfquery name="rsPer" datasource="#Session.DSN#">
	select distinct Speriodo as Eperiodo
	from CGPeriodosProcesados
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Eperiodo desc
</cfquery>

<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, b.VSdesc 
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
		and a.Iid = b.Iid
		and b.VSgrupo = 1
	order by <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl">
</cfquery>

<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
		<br>
		<cfoutput>
			<form name="form1" method="post" action="#LvarAction#" onsubmit="return Valida();">
				<table width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr>
						<td>
							<input type="radio" name="Reporte" value="1" id="Reporte1" onclick="document.form1.action='#LvarReporte1#'; funcDesVisualizar();">
							<label for="Reporte1"><cf_translate key=LB_MapeoCuentas>Mapeo de Cuentas</cf_translate></label>
						</td>
						<td>
							<input type="radio" name="Reporte" value="2" id="Reporte2" onclick="document.form1.action='#LvarReporte2#'; funcDesVisualizar();">
							<label for="Reporte2"><cf_translate key=LB_DetalleCuentas>Detalle Cuentas Mapeadas</cf_translate></label>
						</td>
						<td>
							<input type="radio" name="Reporte" value="3" id="Reporte3" onclick="document.form1.action='#LvarReporte3#'; funcDesVisualizar();">
							<label for="Reporte3"><cf_translate key=LB_CuentasSinMapear>Cuentas sin Mapear</cf_translate></label>
						</td>
						<td>
							<input type="radio" name="Reporte" value="4" id="Reporte4" onclick="document.form1.action='#LvarReporte4#'; funcVisualizar();">
							<label for="Reporte4"><cf_translate key=LB_SalidaDinammica>Salida Dinámica</cf_translate></label>
						</td>
					</tr>
					<tr>
						<td colspan="4">&nbsp;</td>
					</tr>
					<tr>
						<td align="right" style="width:25%"><strong><cf_translate key=LB_Mapeo>Mapeo</cf_translate>:</strong>&nbsp;</td>
						<td align="left" colspan="3">
							<cf_conlis
									Campos="CGICMid, CGICMcodigo, CGICMnombre"
									Desplegables="N,S,S"
									Modificables="N,S,N"
									Size="0,10,80"
									tabindex="1"
									Title="#LB_ListaMapeocuentas#"
									Tabla="CGIC_Mapeo tm"
									Columnas="CGICMid, CGICMcodigo, CGICMnombre"
									Filtro= "1=1" 
									Desplegar="CGICMcodigo, CGICMnombre"
									Etiquetas="#LB_Codigo#, #LB_Nombre#"
									filtrar_por="CGICMcodigo, CGICMnombre"
									Formatos="S,S"
									Align="left,left"
									form="form1"
									Asignar="CGICMid, CGICMcodigo, CGICMnombre"
									Asignarformatos="S,S,S"
									/><!--- exists(select 1 from CGIC_Layout lo where lo.CGICMid = tm.CGICMid) --->
						</td>	
					</tr>
					
					<tr id="SalidaExternaB" style="display:''">
						<td align="right"><strong><cf_translate key=LB_Periodo>Periodo</cf_translate>:&nbsp;</strong></td>
						<td colspan="3">
							<select name="Periodo" id="Periodo" tabindex="1">
								<option value="-1"><cf_translate key=LB_Selecciona1> Escoger uno </cf_translate></option>
								<cfloop query="rsPer">
									<option value="#Eperiodo#" <cfif isdefined("form.periodo") and form.periodo eq Eperiodo>selected</cfif>>#Eperiodo#</option>
								</cfloop>
							</select>
						</td>
					</tr>
					<tr id="SalidaExternaC" style="display:''">
						<td align="right"><strong><cf_translate key=LB_Mes>Mes</cf_translate>:&nbsp;</strong></td>
						<td colspan="3">
							<select name="Mes" id="Mes" tabindex="1">
								<option value="-1"> <cf_translate key=LB_Selecciona1>Escoger uno</cf_translate> </option>
								<cfloop query="rsMeses">
									<option value="#VSvalor#"<cfif isdefined("form.mes") and form.mes eq VSvalor>selected</cfif>>#VSdesc#</option>
								</cfloop>	
							</select>
						</td>
					</tr>
					
					<tr id="SalidaExternaD" style="display:''">
						<td>&nbsp;</td>
						<td colspan="2" align="left">
							<input type="checkbox" name="Utilidad" id="Utilidad" value="1" tabindex="1"> <label for="Utilidad"><strong><cf_translate key=LB_IncluirUtilidad>Incluir Utilidad</cf_translate></strong></label>
						</td>
						<td>&nbsp;</td>
					</tr>
					<tr id="SalidaExternaE" style="display:''">
						<td>&nbsp;</td>
						<td colspan="2" align="left">
							<input type="checkbox" name="SCero" id="SCero" value="1" tabindex="1"> <label for="SCero"><strong><cf_translate key=LB_InformacionSaldoCero>Información con Saldo Cero</cf_translate></strong></label>
						</td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td colspan="4">
							<cf_botones values="Generar" tabindex="1">
						</td>
					</tr>
				</table>	
			</form>
		</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>

<script language="javascript" type="text/javascript">
	document.getElementById("Reporte1").checked="true";
	document.form1.CGICMcodigo.focus();
	
	function funcVisualizar(){
		document.getElementById("SalidaExternaB").style.display = ''
		document.getElementById("SalidaExternaC").style.display = ''
		document.getElementById("SalidaExternaD").style.display = ''
		document.getElementById("SalidaExternaE").style.display = ''
		document.getElementById("SalidaExternaB").style.visibility = 'visible'
		document.getElementById("SalidaExternaC").style.visibility = 'visible'
		document.getElementById("SalidaExternaD").style.visibility = 'visible'
		document.getElementById("SalidaExternaE").style.visibility = 'visible'
	}
	function funcDesVisualizar(){
		document.getElementById("SalidaExternaB").style.display = 'none';
		document.getElementById("SalidaExternaC").style.display = 'none';
		document.getElementById("SalidaExternaD").style.display = 'none';
		document.getElementById("SalidaExternaE").style.display = 'none';
		document.getElementById("SalidaExternaB").style.visibility = 'hidden';
		document.getElementById("SalidaExternaC").style.visibility = 'hidden';
		document.getElementById("SalidaExternaD").style.visibility = 'hidden';
		document.getElementById("SalidaExternaE").style.visibility = 'hidden';
	}

	funcDesVisualizar();
	
	function Valida(){
		if (document.getElementById("Reporte4").checked){
			if (document.form1.CGICMid.value ==''){
				alert('Debe digitar el campo Mapeo');
				return false;
			}
			if (document.form1.Periodo.value ==-1){
				alert('Debe escoger un Periodo');
				return false;
			}
			if (document.form1.Mes.value == -1){
				alert('Debe escoger un Mes');
				return false;
			}
		}
	}
</script>