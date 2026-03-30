<!--- 
Archivo:  cjc_RLiquidacionesRecibidas.cfm
Creado:   Randall Colomer en el ICE.   
Fecha:    09 Noviembre 2006.              
--->
<cfset session.sitio.template = "/plantillas/Fondos/Plantilla.cfm"> 

<cf_templateheader title="Reporte de Recepci&oacute;n de Liquidaciones">	
 		<table width="100%" border="0">
			<tr>
				<td>
					<cfinclude template="../operacion/cjc_formRLiquidacionesRecibidas.cfm">
 				</td>
			</tr>
		</table> 
<cf_templatefooter>
