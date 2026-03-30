<!--- 
Archivo:  cjc_RVouchersDigitados.cfm
Creado:   Randall Colomer en el ICE.   
Fecha:    28 Agosto 2006.              
--->
<cfset session.sitio.template = "/plantillas/Fondos/Plantilla.cfm"> 

<cf_templateheader title="Reporte de Vouchers Digitados">
 		<table width="100%" border="0">
			<tr>
				<td>
					<cfinclude template="../operacion/cjc_formRVouchersDigitados.cfm">
 				</td>
			</tr>
		</table> 
<cf_templatefooter>
