<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteDeSalariosPorBanco" Default="Reporte de Salarios por Banco" returnvariable="LB_ReporteDeSalariosPorBanco"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Generar" Default="Generar" XmlFile="/rh/generales.xml"returnvariable="BTN_Generar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CODIGO" Default="Codigo" XmlFile="/rh/generales.xml"returnvariable="LB_CODIGO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DESCRIPCION" Default="Descripcion" XmlFile="/rh/generales.xml"returnvariable="LB_DESCRIPCION"/>											
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_DebeSeleccionarUnaNomina" Default="Debe seleccionar una nomina" returnvariable="MSG_DebeSeleccionarUnaNomina"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ListaDeBancos" Default="Lista de Bancos" returnvariable="LB_ListaDeBancos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_LugarDePago" Default="Lugar de pago" returnvariable="LB_LugarDePago"/>											

<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	and a.Iid = b.Iid
	order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
</cfquery>

<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_ReporteDeSalariosPorBanco#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">		
		<cfoutput>
		<form name="form1" method="post" action="repSalarioLugarPago-rep.cfm">
			<table width="98%" cellpadding="3" cellspacing="0" align="center" border="0">			
				<tr><td width="15%">&nbsp;</td>
				</tr>			
				<tr>
					<td align="right" nowrap width="15%">
						<b><cf_translate key="LB_NominasAplicadas">N&oacute;minas Aplicadas</cf_translate></b>					</td>
					<td>					
						<input name="TipoNomina" id="TipoNomina" type="checkbox" tabindex="1" onclick="javascript: funcCambioNomina();" checked>				
					</td>
				</tr>					
				<tr id="NAplicadas">
					<td nowrap align="right"> <strong><cf_translate  key="LB_Nomina">N&oacute;mina</cf_translate> :&nbsp;</strong></td>
					<td colspan="3">
						<cf_rhcalendariopagos form="form1" historicos="true" tcodigo="true" index="1" tabindex="1" pintaRCDescripcion="true" descsize="35" size="15">
					</td>
				</tr>
				<tr id="NNoAplicadas" style="display:none">
					<td nowrap align="right"> <strong><cf_translate  key="LB_Nomina">N&oacute;mina</cf_translate> :&nbsp;</strong></td>
					<td colspan="3">
						<cf_rhcalendariopagos form="form1" historicos="false" tcodigo="true" index="2" tabindex="1" pintaRCDescripcion="true" descsize="35" size="15">
					</td>
				</tr>
				<tr>
					<td align="right"><b>#LB_LugarDePago#:&nbsp;</b></td>
					<td width="85%">
						<cf_conlis title="#LB_ListaDeBancos#"
							campos = "Bid,Bdescripcion" 
							desplegables = "N,S" 
							modificables = "N,S" 
							size = "0,60"
							asignar="Bid,Bdescripcion"
							asignarformatos="I,S"
							tabla="	Bancos "																	
							columnas="Bid,Bdescripcion"
							filtro=" Ecodigo =#session.Ecodigo#"
							desplegar="Bdescripcion"
							etiquetas="	#LB_LugarDePago#"
							formatos="S"
							align="left"
							showEmptyListMsg="true"
							debug="false"
							form="form1"
							width="800"
							height="500"
							left="70"
							top="20"
							filtrar_por="Bdescripcion">						
				  </td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>				
					<td colspan="4" align="center">
						<input type="button" name="btnGenerar" value="#BTN_Generar#" class="btnAplicar" onclick="javascript: funcValidar();">
					</td>
				</tr>		
				<tr><td>&nbsp;</td></tr>				
			</table>	
			<input type="hidden" name="LastOneCalendario" id="LastOneCalendario" value="ListaNon" tabindex="1">
			<input type="hidden" name="TDidlist" id="TDidlist" value="" tabindex="1">
			<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
		</form>
		<script language="javascript" type="text/javascript">
			function funcValidar(){
				if (document.form1.CPid1.value == '' && document.form1.CPid2.value == ''){ 
					alert('#MSG_DebeSeleccionarUnaNomina#');
				}
				else{
					document.form1.submit();
				}
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
