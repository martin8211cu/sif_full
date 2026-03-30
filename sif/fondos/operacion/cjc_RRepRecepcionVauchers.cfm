<!--- 
Archivo:  cjc_RRepRecepcionVauchers.cfm
Creado:   Randall Colomer en el ICE.   
Fecha:    23 Agosto 2006.              
--->
<cfset session.sitio.template = "/plantillas/Fondos/Plantilla.cfm"> 
<cf_templateheader title="Reporte de Recepci&oacute;n Vouchers de Banco">
 		<table width="100%" border="0">
			<tr>
				<td>
					<cfinclude template="../operacion/cjc_formRRepRecepcionVauchers.cfm">
 				</td>
			</tr>
		</table> 
<cf_templatefooter>
