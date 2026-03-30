<cf_templateheader title="	Consumo por Centro Funcional">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Consumo por Centro Funcional'>
		<cfoutput>
            <form style="margin:0;" action="Consumo_X_CF_main.cfm" name="consulta" method="post">
                <table width="100%" cellpadding="0" cellspacing="1">
                    <!---►►Tipo de Reporte◄◄--->
                    <tr>
                    	<td align="right">Tipo de Reporte:&nbsp;</td>
                        <td>
                            <input type="radio" name="TipoReporte" id="TipoReporte1" value="1" onclick="funcDisable();" checked="checked" /> <label for="TipoReporte1">Detallado</label>
                        </td>
                        <td>
                            <input type="radio" name="TipoReporte" id="TipoReporte2" value="2" onclick="funcEnable();" /> <label for="TipoReporte2">Resumido</label>
                        </td>
                    </tr>
                    <!---►►Filtro por Centro Funcionales◄◄--->
                    <tr>
                        <td align="right" nowrap>Centro Funcional Desde&nbsp;:&nbsp;</td>
                        <td nowrap>
                           <cf_rhcfuncional form="consulta" id="CFidDes" tabindex="1" name="CFcodigoDes" desc="CFdescripcionDes" size="25">
                        </td>
                        <td align="right" nowrap>&nbsp;Centro Funcional Hasta&nbsp;:&nbsp;</td>
                        <td nowrap>
                            <cf_rhcfuncional form="consulta" id="CFidHas" tabindex="1" name="CFcodigoHas" desc="CFdescripcionHas" size="25">
                        </td>
                    </tr>
                    <!---►►Filtro por Almacen◄◄--->
                    <tr>
                        <td align="right" nowrap><cf_translate  key="LB_AlmacenDesde">Almac&eacute;n Desde</cf_translate>:&nbsp;</td>
                        <td nowrap>
                            <cf_conlis
                                campos="AidIni, AlmcodigoIni, BdescripcionIni"
                                desplegables="N,S,S"
                                modificables="N,S,N"
                                size="0,10,25"
                                title="Lista de Almacenes"
                                tabla="Almacen"
                                columnas="Aid as AidIni, Almcodigo as AlmcodigoIni, Bdescripcion as BdescripcionIni "
                                filtro="Ecodigo=#session.Ecodigo# order by 2"
                                desplegar="AlmcodigoIni, BdescripcionIni"
                                filtrar_por="Almcodigo, Bdescripcion"
                                etiquetas="Código, Descripción"
                                formatos="S,S"
                                align="left,left"
                                asignar="AidIni, AlmcodigoIni, BdescripcionIni"
                                form="consulta"
                                asignarformatos="S, S, S"
                                showEmptyListMsg="true"
                                EmptyListMsg="-- No se encontraron Almacenes --"
                                tabindex="1">

                        </td>
                        <td align="right" nowrap><cf_translate  key="LB_AlmacenHasta">Almac&eacute;n Hasta</cf_translate>:&nbsp;</td>
                        <td nowrap>
                         <cf_conlis
                                campos="AidFin, AlmcodigoFin, BdescripcionFin"
                                desplegables="N,S,S"
                                modificables="N,S,N"
                                size="0,10,25"
                                title="Lista de Almacenes"
                                tabla="Almacen"
                                columnas="Aid as AidFin, Almcodigo as AlmcodigoFin, Bdescripcion as BdescripcionFin "
                                filtro="Ecodigo=#session.Ecodigo# order by 2"
                                desplegar="AlmcodigoFin, BdescripcionFin"
                                filtrar_por="Almcodigo, Bdescripcion"
                                etiquetas="Código, Descripción"
                                formatos="S,S"
                                align="left,left"
                                asignar="AidFin, AlmcodigoFin, BdescripcionFin"
                                form="consulta"
                                asignarformatos="S, S, S"
                                showEmptyListMsg="true"
                                EmptyListMsg="-- No se encontraron Almacenes --"
                                tabindex="1">
                        </td> 
                    </tr>
                    <!---►►Filtro por Fechas◄◄--->
                    <tr>
                        <td width="1%" nowrap align="right">Fecha Desde :&nbsp;</td>
                        <td width="1%" nowrap><cf_sifcalendario tabindex="1" name="FechaDes" form="consulta"></td>
                        <td width="1%" nowrap align="right">Fecha Hasta :&nbsp;</td>
                        <td nowrap><cf_sifcalendario tabindex="1" name="FechaHas" form="consulta"></td>
                    </tr>
                    <!---►►Corte por Almacén◄◄--->
                    <tr> 
                        <td  align="right" valign="middle" nowrap ><input type="checkbox" name="chk_CorteAlmacen"/></td>
                        <td  colspan="3" nowrap> 
                            Corte por Almacén
                        </td>
                    </tr>
                   <!---►►Corte por Objeto de Gasto◄◄--->
                    <tr> 
                        <td  align="right" valign="middle" nowrap ><input type="checkbox" name="chk_CorteOgasto"/></td>
                        <td  colspan="3" nowrap> 
                            Corte por Objeto de Gasto
                        </td>
                    </tr>
                    <tr>
                    	<td colspan="4" align="center">
                    		<input type="submit" name="Consultar" value="Consultar" tabindex="1" class="btnNormal">
                        </td>
                   	</tr>
                </table>
            </form>
        </cfoutput>
    <cf_web_portlet_end>	
<cf_templatefooter>

<script language="javascript" type="text/javascript">
	funcDisable();
	function funcEnable(){
		document.consulta.chk_CorteAlmacen.disabled="";
	}
	function funcDisable(){
		document.consulta.chk_CorteAlmacen.disabled="True";
		document.consulta.chk_CorteAlmacen.checked="";
	}
</script>

<cf_qforms form="consulta">
	<cf_qformsRequiredField args="CFidDes,Centro Funcional Desde">
	<cf_qformsRequiredField args="CFidHas,Centro Funcional Hasta">
</cf_qforms>