<form style="margin:0 " name="filtro" method="post" action="" onSubmit="return validar();" >
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td align="right" width="25%"><strong><cf_translate  key="LB_CalendarioDePago">Calendario de Pago</cf_translate>:&nbsp;</strong></td>
			<td><cf_rhcalendariopagos form="filtro" historicos="true" tcodigo="true"></td>
		</tr>
		<tr>
			<td align="right"><strong><cf_translate  key="LB_CCentroFuncional">Centro Funcional</cf_translate>:&nbsp;</strong></td>
			<td><cf_rhcfuncional form="filtro" codigosize='15' size='60' ></td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center">
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Consultar"
				Default="Consultar"
				XmlFile="/rh/generales.xml"
				returnvariable="BTN_Consultar"/>
				
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Limpiar"
				Default="Limpiar"
				XmlFile="/rh/generales.xml"
				returnvariable="BTN_Limpiar"/>
				<cfoutput>
				<input type="submit" name="Consultar" value="#BTN_Consultar#">
				<input type="reset" name="Limpiar" value="#BTN_Limpiar#">
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
	</table>
</form>
<script type="text/javascript" language="javascript1.2">
	function validar(){
		
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_SePpresentaronLosSiguientesErrores"
		Default="Se presentaron los siguientes errores"
		returnvariable="MSG_SePpresentaronLosSiguientesErrores"/>
		
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_ElCampoCalendarioDePagoEsRequerido"
		Default="El Campo Calendario de Pago es requerido"
		returnvariable="MSG_ElCampoCalendarioDePagoEsRequerido"/>
		
		
		if ( document.filtro.CPid.value == '' ){
			<cfoutput>
				alert('#MSG_SePpresentaronLosSiguientesErrores#:\n - #MSG_ElCampoCalendarioDePagoEsRequerido#.');
			</cfoutput>
			return false;
		}
		return true;
	}
</script>