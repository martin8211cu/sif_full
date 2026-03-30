<cfsetting requesttimeout="8600">
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate"	method="Translate" Key="LB_Reporte_de_Resumen_de_Pagos" Default="Reporte de Resúmen de Pagos" returnvariable="LB_Reporte_de_Resumen_de_Pagos"/> <cfinvoke key="BTN_Consultar" default="Consultar" returnvariable="BTN_Consultar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke Key="MSG_DebeSeleccionarElConceptoDePago" Default="Debe seleccionar el Concepto de Pago" returnvariable="MSG_DebeSeleccionarElConceptoDePago" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">

<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
	<!--
	function MM_reloadPage(init) {  //reloads the window if Nav4 resized
	  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
		document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
	  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
	}
	MM_reloadPage(true);
	//-->
</script>

	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>
		<cfoutput>
		<cf_web_portlet_start titulo="#LB_Reporte_de_Resumen_de_Pagos#" >
		<cfinclude template="/rh/portlets/pNavegacionPago.cfm">
		<form style="margin:0 " name="form1" id="form1" method="post" action="RepResumenPagos-rep.cfm">
	
	<cfquery name="Periodos" datasource="#Session.DSN#">
		select distinct CPperiodo as Pvalor
		from CalendarioPagos cp
			inner join HRCalculoNomina rn
			on cp.CPid=rn.RCNid
		Where cp.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by CPperiodo desc
	</cfquery>
	
	<cfquery name="rsMeses" datasource="sifControl">
		select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
		from Idiomas a, VSidioma b 
		where a.Icodigo = '#Session.Idioma#'
		and b.VSgrupo = 1
		and a.Iid = b.Iid
		order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
	</cfquery>
					
		<table width="60%" cellpadding="1" cellspacing="1" border="0" align="center">
			<tr><td colspan="6">&nbsp;</td></tr>
			<tr>
				<td nowrap="nowrap">
					<table>
						<tr><td><input type="radio" name="rdFiltro" value="1" onclick="javascript:activarFiltros(this);" checked="checked"/></td><td nowrap="nowrap"><b><cf_translate  key="LB_Periodo_Y_Mes" xmlFile="/rh/generales.xml">Periodo y Mes</cf_translate></b></td></tr>
						<tr><td><input type="radio" name="rdFiltro" value="2" onclick="javascript:activarFiltros(this);" /></td><td nowrap="nowrap"><b><cf_translate  key="LB_RangoDeFechas" xmlFile="/rh/generales.xml">Rango de Fechas</cf_translate></b></td></tr>
						<tr><td><input type="radio" name="rdFiltro" value="3" onclick="javascript:activarFiltros(this);" /></td><td><b><cf_translate  key="LB_Nomina" xmlFile="/rh/generales.xml">Nómina</cf_translate></b></td></tr>
					</table>
				</td>		
				<td colspan="4">
					<table>
						<!---- periodo y mes---->
						<tr  id="divFiltro1">
							<td>
							<fieldset>
							<legend><cf_translate  key="LB_Filtro" xmlFile="/rh/generales.xml">Filtro</cf_translate></legend>
								<table>
									<tr>
										<td>										
											<select name="periodo">
												<cfloop query="Periodos">
													<option value="#Pvalor#" <cfif Year(Now()) eq Pvalor> selected </cfif>>#Pvalor#</option>
												</cfloop>
											</select>
										</td>
										<td>
											<select name="mes">
											<cfloop query="rsMeses">
												<option value="#Pvalor#" <cfif Month(Now()) eq Pvalor>selected</cfif>>#Pdescripcion#</option>
											</cfloop>
											</select>
										</td>
									</tr>		
								</table>
							</td>
							</fieldset>
						</tr>	
						<!---- rango de fechas---->
						<tr id="divFiltro2" style="display:none">
							<td>
							<fieldset>
							<legend><cf_translate  key="LB_Filtro" xmlFile="/rh/generales.xml">Filtro</cf_translate></legend>
								<table>
									<tr>
										<td nowrap="nowrap">										
											<b><cf_translate  key="LB_Fecha_Desde" xmlFile="/rh/generales.xml">Fecha Desde</cf_translate>:</b>
										</td>
										<td>
											<cf_sifcalendario name="FechaDesde" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="6" form="form1">	
										</td>
										<td nowrap="nowrap">										
											<b><cf_translate  key="LB_Fecha_Hasta" xmlFile="/rh/generales.xml">Fecha Hasta</cf_translate>:</b>
										</td>
										<td>
											<cf_sifcalendario name="FechaHasta" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="7" form="form1">	
										</td>
									</tr>
									<tr>
										<td colspan="4">
											<cf_rhtiponomina form="form1"  AgregarEnLista="true" index="10">
										</td>
									</tr>		
								</table>
							</td>
							</fieldset>
						</tr>	
						<!---- Nómina ---->
						<tr id="divFiltro3" style="display:none">
							<td>
								<fieldset>
								<legend><cf_translate  key="LB_Filtro" xmlFile="/rh/generales.xml">Filtro</cf_translate></legend>
								<table>
									<tr>
										<td nowrap="nowrap">										
											<b><cf_translate  key="LB_Nomina" xmlFile="/rh/generales.xml">Nómina</cf_translate>:</b>
										</td>
										<td>										
											<cf_rhcalendariopagos historicos="true" agregarEnLista="true" form="form1" index="11"> 
										</td>
									</tr>		
								</table>
								</fieldset>
							</td>
						</tr>
						
					</table>
				</td>										
			</tr>
			
			<tr>
				<td align="right" nowrap="nowrap"><strong><cf_translate  key="LB_Empleado">Empleado</cf_translate>:&nbsp;</strong></td>										
				<td>
					<cf_rhempleado form="form1" AgregarEnLista="true">
				</td>
			</tr>
			<tr>
				<td align="right" nowrap="nowrap"><strong><cf_translate  key="LB_Mostrar_Salario_Bruto">Mostrar Salario Bruto</cf_translate>:&nbsp;</strong></td>
				<td align="left"><input type="checkbox" name="chkIncluirSB" /></td>
			</tr>
			<tr>
				<td align="right" nowrap="nowrap"><strong><cf_translate  key="LB_Concepto_de_Pago">Concepto de Pago</cf_translate>:&nbsp;</strong></td>										
				<td>
					<cf_rhcincidentes form="form1" AgregarEnLista="true" index="20">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>								

			<tr>
				<td colspan="3" align="center">
					<input type="submit" name="btn_consultar" value="#BTN_Consultar#" class="btnNormal"/>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>

		</form>
		<cf_web_portlet_end>
		<script type="text/javascript">
			function activarFiltros(e){
				var div1=document.getElementById("divFiltro1");
				var div2=document.getElementById("divFiltro2");
				var div3=document.getElementById("divFiltro3");
		 
				if(e.value == 1){
							div2.style.display='none';
							div3.style.display='none';
							div1.style.display='';
				}
				if(e.value == 2){
							div1.style.display='none';
							div3.style.display='none';
							div2.style.display='';
				}			
				if(e.value == 3){
							div1.style.display='none';
							div2.style.display='none';
							div3.style.display='';	
				}
			}
		</script>
		</cfoutput>					
	<cf_templatefooter>