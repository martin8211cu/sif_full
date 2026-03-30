 
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_GeneracionDeArchivoParaAsociacionSolidarista" Default="Generaci&oacute;n de Archivo para Asociaci&oacute;n Solidarista" returnvariable="LB_GeneracionDeArchivoParaAsociacionSolidarista"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Generar" Default="Generar" XmlFile="/rh/generales.xml"returnvariable="BTN_Generar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CODIGO" Default="Codigo" XmlFile="/rh/generales.xml"returnvariable="LB_CODIGO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DESCRIPCION" Default="Descripcion" XmlFile="/rh/generales.xml"returnvariable="LB_DESCRIPCION"/>											
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Periodo" Default="Periodo" XmlFile="/rh/generales.xml"returnvariable="LB_Periodo"/>											
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Mes" Default="Mes" XmlFile="/rh/generales.xml"returnvariable="LB_Mes"/>											
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nomina" Default="Nómina" XmlFile="/rh/generales.xml"returnvariable="LB_Nomina"/>											

<cfoutput>
<form name="form1" method="post" action="#LvarDestino#">
	
	<table width="50%" cellpadding="3" cellspacing="0" align="center" border="0">			
		<tr>
			<td align="right" nowrap>
				<b><cf_translate key="LB_NominasAplicadas">N&oacute;minas Aplicadas</cf_translate></b>		
			</td>
			<td>					
				<input name="TipoNomina" id="TipoNomina" type="checkbox" tabindex="1" onclick="CambioNomina();" checked>				
			</td>
		</tr>	 
		<tr>
			<td nowrap align="left"><strong><cf_translate  key="LB_Nomina">N&oacute;mina</cf_translate> :&nbsp;</strong></td>
			<td colspan="3" id="NAplicadas"  name="NAplicadas">
				<cf_rhcalendariopagos form="form1" historicos="true" tcodigo="true" index="1" tabindex="1" pintaRCDescripcion="true">
			</td>
			<td colspan="3" id="NNoAplicadas" name="NNoAplicadas" style="display:none">
				<cf_rhcalendariopagos form="form1" historicos="false" tcodigo="true" index="2" tabindex="1" pintaRCDescripcion="true">
			</td>
		</tr>
		<tr>				
			<td colspan="4" align="center">
				<input type="submit" name="btnGenerar" value="#BTN_Generar#" class="BTNAplicar" onclick="validar();">
			</td>
		</tr>		
		<tr><td>&nbsp;</td></tr>				
	</table>
</form>
<cf_qforms> 
<script type="text/javascript" language="javascript1.2">
	
	validar=function(){ 
		objForm.CPid1.required = false;
		objForm.CPid2.required = false;
		objForm.CPid1.description = '#LB_Nomina#';
		objForm.CPid2.description = '#LB_Nomina#';


		if(document.form1.TipoNomina.checked){
			objForm.CPid1.required = true;	
		}
		else{
			objForm.CPid2.required = true;
		}
	}

	CambioNomina=function(){
		if(!document.form1.TipoNomina.checked){
			$("##NNoAplicadas").show();
			$("##NAplicadas").hide();
		}
		else{
			$("##NAplicadas").show();
			$("##NNoAplicadas").hide();
		}
		validar();
	}

	validar();

</script>	
</cfoutput>