<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ListPolizasDesalmacenaje" Default="Lista de P&oacute;lizas de Desalmacenaje" returnvariable="LB_ListPolizasDesalmacenaje"/>
<cf_templateheader title="#LB_ListPolizasDesalmacenaje#">
	<cfinclude template="../../portlets/pNavegacionCM.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_ListPolizasDesalmacenaje#">
				<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
					<tr><td colspan="4">&nbsp;</td></tr>
					<tr>
                    	<!--- Poliza desde --->
                    	<td width="40%" align="right" valign="baseline">P&oacute;liza Desde:&nbsp; </td>
                        <form action="" method="post" name="listaPolizasDes">
                            <td valign="baseline" nowrap>
                                <cf_conlis 
                                    title		   				="P&oacute;liza Desde"
                                    campos 				= "EPDnumero" 
                                    desplegables 	= "S" 
                                    modificables 		= "S"
                                    size 					= "0"
                                    tabla					="EPolizaDesalmacenaje" 
                                    columnas			="EPDid, EPDnumero"
                                    filtro						="Ecodigo 	= #session.Ecodigo#"
                                    filtrar_por				="EPDnumero"
                                    desplegar			="EPDnumero"
                                    etiquetas			="N&uacute;mero"
                                    formatos				="V"
                                    align						="left"
                                    tabindex				= "1"
                                    form						="listaPolizasDes"
                                    asignar				="EPDid, EPDnumero"
                                    asignarformatos	="S">
                            </td>
                        </form>
                   </tr>
                   <tr>     
						<!--- Poliza hasta--->
                    	<td width="40%" align="right" valign="baseline">P&oacute;liza Hasta:&nbsp; </td>
						 <form action="" method="post" name="listaPolizasHast">
                            <td valign="baseline" nowrap>
                                <cf_conlis 
                                    title		   				="P&oacute;liza Hasta"
                                    campos 				= "EPDnumero" 
                                    desplegables 	= "S" 
                                    modificables 		= "S"
                                    size 					= "0"
                                    tabla					="EPolizaDesalmacenaje" 
                                    columnas			="EPDid, EPDnumero"
                                    filtro						="Ecodigo 	= #session.Ecodigo#"
                                    filtrar_por				="EPDnumero"
                                    desplegar			="EPDnumero"
                                    etiquetas			="N&uacute;mero"
                                    formatos				="V"
                                    align						="left"
                                    tabindex				= "2"
                                    form						="listaPolizasHast"
                                    asignar				="EPDid, EPDnumero"
                                    asignarformatos	="S">
                            </td>
                        </form>
					</tr>
                    <form action="listaPolizaDesalmacenaje-sql.cfm" name="procesarForm" method="post">
                        <tr>
                            <td align="right" valign="baseline" nowrap>Formato:&nbsp;</td>
                            <td valign="baseline" nowrap colspan="3">
                                <select name="Formato" id="Formato" tabindex="1">
                                    <option value="3">Excel</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" align="center"> 
                                <input type="hidden" name="EPDnumeroDesde" value="" />
                                <input type="hidden" name="EPDnumeroHasta" value="" />
                                <input style="background-color: #FFF" name="btnProcesar" type="button" value="Procesar" onclick="javascript: procesarConsulta();">
                                <input style="background-color: #FFF" name="Reset"  type="button" value="Limpiar" onclick="javascript: limpiar();"> </td>
                        </tr>
                    </form>    
				</table>
	<cf_web_portlet_end>	
<cf_templatefooter>
<script language="javascript1.2">
	var LvarAction = 'listaPolizaDesalmacenaje-sql.cfm';
	
	function procesarConsulta()
	{
		document.procesarForm.EPDnumeroDesde.value	 = document.listaPolizasDes.EPDnumero.value;
		document.procesarForm.EPDnumeroHasta.value	 	 = document.listaPolizasHast.EPDnumero.value; 
		document.procesarForm.submit();
	}
	
	function limpiar()
	{
		document.listaPolizasDes.reset();
		document.listaPolizasHast.reset();
	}
</script> 