<cfoutput>
<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
<form name="form1" method="post" action="repPTU-sql.cfm" style="margin: 0">
	<table width="100%"  border="0" cellspacing="0" cellpadding="2" align="center">
    	<tr >
        	<td rowspan="5" width="30">
            	<cf_web_portlet_start border="true" titulo="Descripci&oacute;n" skin="info1">
					<div align="justify">
						<p>
							<cf_translate  key="LB_Reporte">
								Reporte de Datos Emplado para el C&aacute;lculo de PTU
							</cf_translate>
						</p>
					</div>
				<cf_web_portlet_end>
            </td>
        	<td width="20%" align="center">
            </td>
            <td width="20%" align="left">
            </td>
        </tr>
        <tr>
        	<td width="20%" align="center">
            	<strong>Fecha Inicio PTU:</strong>
            </td>
            <td width="20%" align="left">
            	<cf_sifcalendario form="form1" tabindex="1" name="FechaDesde" >
            </td>
        </tr>
        <tr>
        	<td width="20%" align="center">
            	<strong>Fecha Final PTU:</strong>
            </td>
            <td width="20%" align="left">
            	<cf_sifcalendario form="form1" tabindex="2" name="FechaHasta" >
            </td>
        </tr>
        <tr>
        	<td width="20%" align="center">
            	<strong>Fecha Corte PTU:</strong>
            </td>
            <td width="20%" align="left">
            	<cf_sifcalendario form="form1" tabindex="3" name="FechaCorte" >
            </td>
        </tr>
        <tr>
        	<td colspan = "3" align="center">
            	<input type="submit" name="Generar" value="Generar">            
            </td>
        </tr>
       
     </table>
</cfoutput>