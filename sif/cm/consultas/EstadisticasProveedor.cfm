<cfinvoke key="CMB_Enero" 			default="Enero" 	returnvariable="CMB_Enero" 		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Febrero" 		default="Febrero"	returnvariable="CMB_Febrero"	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Marzo" 			default="Marzo" 	returnvariable="CMB_Marzo" 		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Abril" 			default="Abril"		returnvariable="CMB_Abril"		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Mayo" 			default="Mayo"		returnvariable="CMB_Mayo"		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Junio" 			default="Junio" 	returnvariable="CMB_Junio" 		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Julio" 			default="Julio"		returnvariable="CMB_Julio"		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Agosto" 			default="Agosto" 	returnvariable="CMB_Agosto" 	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Setiembre"		default="Setiembre"	returnvariable="CMB_Setiembre"	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Octubre" 		default="Octubre"	returnvariable="CMB_Octubre"	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Noviembre" 		default="Noviembre" returnvariable="CMB_Noviembre" 	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Diciembre" 		default="Diciembre"	returnvariable="CMB_Diciembre"	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>

<cfquery name="rsPeriodos" datasource="#Session.DSN#">
    select distinct Speriodo
    from CGPeriodosProcesados
    where Ecodigo = #session.Ecodigo#
    order by Speriodo desc
</cfquery>

<cfquery name="rsTipoOrdenes" datasource="#Session.DSN#">
    SELECT * FROM CMTipoOrden 
    WHERE Ecodigo = #session.Ecodigo#
</cfquery>       
<cfparam name="form.EcodigoE" default="#session.Ecodigo#">

<cf_templateheader title="Compras - Estad&iacute;sticas de compras por Proveedor">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Rango de Proveedor'>
			<form name="form1" method="post" action="">
			<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
				<tr><td colspan="2"><cfinclude template="/sif/portlets/pNavegacion.cfm"></td></tr>
				<tr>
					<td width="40%" valign="top">
						<table width="100%">
							<tr>
								<td> 
									<cf_web_portlet_start border="true" titulo="Estad&iacute;sticas de compras por Proveedor" skin="info1">
										<div align="justify">
											<p> 
											&Eacute;ste reporte muestra las estad&iacute;sticas de compras por Proveedor. &Uacute;nicamente para las ordenes de compra surtidas parcialmente o totalmente.</p>
										</div>
									<cf_web_portlet_end> 
								</td>
							</tr>
						</table>
					</td>
					<td width="60%" valign="top"><cfinclude template="EstadisticasSNegocios.cfm"></td>
                </tr>
				<!--- Periodo  Fecha --->
                <tr>
                    <td align="center" colspan="4">
                        <input type="button" name="Consultar" class="btnNormal" value="Consultar" onclick="javascript: tipoReporte();">
                        <input type="reset"  name="Limpiar" class="btnNormal" value="Limpiar">
                    </td>
                </tr>
	    </table>
		</form>
		<iframe name="frComprador" id="frComprador" width="0" height="0" style="visibility:"></iframe>
		
		<cf_web_portlet_end>
	<cf_templatefooter>
<script language="JavaScript" type="text/javascript">
			var popUpWin = 0;
			function popUpWindow(URLStr, left, top, width, height){
				if(popUpWin){
					if(!popUpWin.closed) popUpWin.close();
				}
				popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			}

			function CambioRango(){
			if(document.getElementById('TipoRango1').checked){
				document.getElementById('PeriodoMes').style.display='none';
				document.getElementById('Fecha').style.display='';
				document.getElementById('Rango').value='Fecha';
			}
			else {
				document.getElementById('Fecha').style.display='none';
				document.getElementById('PeriodoMes').style.display='';
				document.getElementById('Rango').value='PeriodoMes';
			}
		}
		
		function mostrarCheckFechas(){
			if(document.getElementById('MostrarFechas').style.display == 'none')
			return document.getElementById('MostrarFechas').style.display = '';
			document.getElementById('MostrarFechas').style.display = 'none';
		}
		
		function tipoReporte()
			{
					document.form1.action = "EstadisticasProveedorDetallado-form.cfm";	
					document.forms["form1"].submit();
					document.form1.action = "";	
			}
		
		/*
			Funcion que realiza la carga de los tipos de ordenes de compra según 
			si es Local o Internacional
		*/
		function cambio_TiposOC(obj){
			var form = obj.form;
			var combo = form.TipoOrden;
			
			combo.length = 1;
			combo.options[0].text = '-- Todas --';
			combo.options[0].value = 'T';
			var i = 1;
			<cfoutput query="rsTipoOrdenes">
				var tmp = #rsTipoOrdenes.CMTOimportacion#;
				if (obj.value == 'T')
					{
						combo.length++;
						combo.options[i].text = '#rsTipoOrdenes.CMTOdescripcion#';
						combo.options[i].value = '#rsTipoOrdenes.CMTOcodigo#';
						i++;
					}else
					{
						if (obj.value == 'I' && tmp== 1) {
								combo.length++;
								combo.options[i].text = '#rsTipoOrdenes.CMTOdescripcion#';
								combo.options[i].value = '#rsTipoOrdenes.CMTOcodigo#';
								i++;
							}else{	
									if (obj.value == 'L' && tmp == 0) {	
										combo.length++;
										combo.options[i].text = '#rsTipoOrdenes.CMTOdescripcion#';
										combo.options[i].value = '#rsTipoOrdenes.CMTOcodigo#';
										i++;
									}
							}	
					}
			</cfoutput>
		}
		</script>

