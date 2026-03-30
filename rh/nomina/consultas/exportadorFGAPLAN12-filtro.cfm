<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_GeneracionDeArchivoParaAsociacionSolidarista" Default="Generaci&oacute;n de Archivo para el Fondo de Garantías de Ahorro" returnvariable="LB_GeneracionDeArchivoParaAsociacionSolidarista"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Generar" Default="Generar" XmlFile="/rh/generales.xml"returnvariable="BTN_Generar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CODIGO" Default="Codigo" XmlFile="/rh/generales.xml"returnvariable="LB_CODIGO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DESCRIPCION" Default="Descripcion" XmlFile="/rh/generales.xml"returnvariable="LB_DESCRIPCION"/>											
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_DebeSeleccionarUnaNominaOUnPeriodoMes" Default="Debe seleccionar una nomina o un periodo/mes" returnvariable="MSG_DebeSeleccionarUnaNominaOUnPeriodoMes"/>

<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	and a.Iid = b.Iid
	order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
</cfquery>
<cf_templateheader>
	<cf_web_portlet_start>
		<cfinclude template="/rh/portlets/pNavegacion.cfm">		
		<cfoutput>
		<form name="form1" method="post" action="exportadorFGAPLAN12-form.cfm" onSubmit="javascript: return funcValidar();">
			<table width="98%" cellpadding="3" cellspacing="0" align="center" border="0">			
				<tr><td width="22%">&nbsp;</td></tr>			
				<tr>
					<td align="right" nowrap>
						<b><cf_translate key="LB_NominasAplicadas">N&oacute;minas Aplicadas</cf_translate></b>		
					</td>
					<td>					
						<input name="TipoNomina" id="TipoNomina" type="checkbox" tabindex="1" onclick="javascript: funcCambioNomina();" checked>				
					</td>
				</tr>					
				<tr id="NAplicadas">
					<td nowrap align="right"> <strong><cf_translate  key="LB_Nomina">N&oacute;mina</cf_translate> :&nbsp;</strong></td>
					<td colspan="3">
						<cf_rhcalendariopagos form="form1" historicos="true" tcodigo="true" index="1" tabindex="1" pintaRCDescripcion="true">
					</td>
				</tr>
				<tr id="NNoAplicadas" style="display:none">
					<td nowrap align="right"> <strong><cf_translate  key="LB_Nomina">N&oacute;mina</cf_translate> :&nbsp;</strong></td>
					<td colspan="3">
						<cf_rhcalendariopagos form="form1" historicos="false" tcodigo="true" index="2" tabindex="1" pintaRCDescripcion="true">
					</td>
				</tr>
							<tr>
					<td align="right"><b><cf_translate key="LB_Periodo">Periodo</cf_translate>:&nbsp;</b></td>
					<td width="21%">
						<select name="periodo" onchange="javascript: funcLimpiaConlis();">
							<option value=""></option> 
							<option value="#year(DateAdd("yyyy", -1, now()))#">#year(DateAdd("yyyy", -1, now()))#</option>
							<cfloop index="i" from="0" to="2">
								<cfset vn_anno = year(DateAdd("yyyy", i, now()))>
								<option value="#vn_anno#">#vn_anno#</option>
							</cfloop>
						</select>
				  </td>
				  <td width="4%" align="right" nowrap="nowrap"><b><cf_translate key="LB_Mes">Mes</cf_translate>:&nbsp;</b></td>
				  <td width="53%">
					<select name="mes" onchange="javascript: funcLimpiaConlis();">
						<option value=""></option> 						
						<cfloop query="rsMeses">
							<option value="#rsMeses.Pvalor#">#rsMeses.Pdescripcion#</option>
						</cfloop>
					</select>
				  </td>				
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>				
					<td colspan="4" align="center">
						<input type="submit" name="btnGenerar" value="#BTN_Generar#" class="BTNAplicar">
					</td>
				</tr>		
				<tr><td>&nbsp;</td></tr>				
			</table>	
			<input type="hidden" name="LastOneCalendario" id="LastOneCalendario" value="ListaNon" tabindex="1">
			<input type="hidden" name="TDidlist" id="TDidlist" value="" tabindex="1">
			<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
		</form>
		<script type="text/javascript" language="javascript1.2">
			function funcValidar(){
				if (document.form1.CPid1.value != '' || document.form1.CPid2.value != ''){ //Si se selecciono Calendario de pago se limpia periodo/mes
					document.form1.periodo.value = '';
					document.form1.mes.value = '';
				}
				if (document.form1.periodo.value == '' && document.form1.mes.value == ''){
					if (document.form1.CPid1.value == '' && document.form1.CPid2.value == ''){
						alert('#MSG_DebeSeleccionarUnaNominaOUnPeriodoMes#');
						return false;
					}					
				}
				else					
				{
					if (document.form1.periodo.value == '' || document.form1.mes.value == ''){
						alert('#MSG_DebeSeleccionarUnaNominaOUnPeriodoMes#');
						return false;
					}
				}							
				return true;
			}
			
			function funcLimpiaConlis(){
				document.form1.CPid1.value = '';
				document.form1.CPcodigo1.value='';
				document.form1.CPdescripcion1.value = '';
				document.form1.CPid2.value = '';
				document.form1.CPcodigo2.value='';
				document.form1.CPdescripcion2.value = '';
			}
						
			function funcCambioNomina(){				
				funcLimpiaConlis();
				document.form1.periodo.value = '';
				document.form1.mes.value = '';				
				if (document.getElementById("TipoNomina").checked == true){
					document.getElementById("NAplicadas").style.display=''
					document.getElementById("NNoAplicadas").style.display='none'; 
				}
				else{
					document.getElementById("NAplicadas").style.display='none'
					document.getElementById("NNoAplicadas").style.display=''; 
				}
			}	
					
			funcCambioNomina();	
		</script>
		</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>
