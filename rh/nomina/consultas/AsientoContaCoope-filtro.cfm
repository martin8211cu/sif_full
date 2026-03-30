<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Consulta_de_Asiento_de_Conta" Default="Consulta de Asiento de Contabilidad" returnvariable="LB_Titulo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Consultar" Default="Consultar" XmlFile="/rh/generales.xml" returnvariable="LB_Consultar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_SeleccionarFechas" Default="Debe seleccionar una fecha desde y fecha hasta" returnvariable="MSG_Fechas"/>
<cfoutput>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<table width="100%" cellpadding="1" cellspacing="0">
		<tr>
			<td valign="top">	
				<cf_web_portlet_start border="true" titulo="#LB_Titulo#" skin="#Session.Preferences.Skin#"> 
					<form name="form1" method="get" action="AsientoContaCoope.cfm" style="margin:0;" onSubmit="return funcValidar();">
						<table width="75%" align="center" cellpadding="2">
							<tr>
								<td align="right"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_FechaDesde">Fecha desde</cf_translate>:</strong></td>
								<td><cf_sifcalendario name="desde"></td>
							</tr>
							<tr>
								<td align="right"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_FechaHasta">Fecha hasta</cf_translate>:</strong></td>
								<td><cf_sifcalendario name="hasta"></td>
							</tr>
							<tr>
								<td colspan="2" align="center"><input type="submit" class="btnFiltrar" name="Consultar" value="#LB_Consultar#"></td>
							</tr>
						</table>
					</form>
				<cf_web_portlet_end> 
			</td>	
		</tr>
	</table>	
<cf_templatefooter>
<script type="text/javascript" language="javascript1.2">
	function funcValidar(){
		if (document.form1.desde.value=='' || document.form1.hasta.value==''){
			alert('#MSG_Fechas#');
			return false;
		}	
	}
</script>
</cfoutput>