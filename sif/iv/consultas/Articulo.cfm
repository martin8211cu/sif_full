<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Articulos"
	Default="Art&iacute;culos "
	returnvariable="LB_Articulos"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Consultar"
	Default="Consultar"
	returnvariable="BTN_Consultar"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Limpiar"
	Default="Limpiar"
	returnvariable="BTN_Limpiar"/>	
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeSeleccionarUnArticulo"
	Default="Debe seleccionar un artículo"
	returnvariable="MSG_DebeSeleccionarUnArticulo"/>
				
<cfquery datasource="#session.DSN#" name="rsArticulos">
	select Aid, Acodigo, Acodalterno, Adescripcion
	from Articulos 
	where Ecodigo = #session.Ecodigo#
</cfquery> 	

<cf_templateheader title="#LB_Articulos#">
	<cfinclude template="../../portlets/pNavegacionIV.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_Articulos#">
			<form action="SQLArticulo.cfm" method="post" name="consulta">
				<table width="80%" border="0" cellpadding="0" cellspacing="0" align="center">
                	<tr> 
                    	<td width="25%" align="right" valign="middle" nowrap >
							<cf_translate  key="LB_ArticuloInicial">Art&iacute;culo Inicial</cf_translate>:&nbsp;
						</td>
                        <td valign="baseline" nowrap> 
							  <cf_sifarticulos form="consulta" frame="fri" id="Aid" name="Acodigo" desc="Adescripcion">
                        </td>
					    <td width="40%" align="right" valign="middle" nowrap>
							<cf_translate  key="LB_ArticuloFinal">Art&iacute;culo Final</cf_translate>:&nbsp;
						</td>
                        <td valign="baseline" nowrap> 
							  <cf_sifarticulos form="consulta" frame="frf" id="AidF" name="AcodigoF" desc="AdescripcionF">
                        </td>
                    </tr>  
					<tr> 
						<td width="25%" align="right" valign="middle" nowrap >
							<cf_translate  key="LB_ClasificacionInicial">Clasificaci&oacute;n Inicial</cf_translate>:&nbsp;
						</td>
						<td valign="baseline" nowrap> 
							<cf_sifclasificacion form="consulta" frame="cli" id="Ccodigo" name="Ccodigoclas" desc="Cdescripcion">
						</td>
						<td width="40%" align="right" valign="middle" nowrap>&nbsp;
							<cf_translate  key="LB_ClasificacionFinal">Clasificaci&oacute;n Final</cf_translate>:&nbsp;
						</td>
						<td valign="baseline" nowrap> 
							<cf_sifclasificacion form="consulta" frame="clf" id="CcodigoF" name="CcodigoclasF" desc="CdescripcionF">
						</td>
					</tr>
					<tr> 
                        <td width="25%" align="right" valign="middle" nowrap >
							<input type="checkbox" name="toExcel"/>
						</td>
                        <td  colspan="3" valign="baseline" nowrap> 
								<cf_translate  key="LB_ExpotarAExcel">Exportar a Excel</cf_translate>
                        </td>
                    </tr>
                    <tr>
						<td colspan="4">&nbsp;</td>
					</tr>
                    <tr> 
						<td colspan="4" align="center">
								<cfoutput>
									<input name="btnConsultarArticulo" type="submit" value="#BTN_Consultar#">
    	                      		<input type="reset" name="Reset" value="#BTN_Limpiar#">
								</cfoutput>
						</td>
					</tr>	
            	</table>
			</form>
		<cf_web_portlet_end>	
<cf_templatefooter>
<script language="JavaScript1.2">
	function valida() {
		if (document.consulta.Aid.value != '') 
			return true;					
		else {
			alert('<cfoutput>#MSG_DebeSeleccionarUnArticulo#</cfoutput>');
			return false;					
		}
	}
</script>