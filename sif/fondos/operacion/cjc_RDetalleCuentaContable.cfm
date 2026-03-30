<!--- 
Archivo:  cjc_formRDetalleCuentaContable.cfm"
Creado:   Randall Colomer en el ICE.   
Fecha:    19 Octubre 2006.              
--->
<cfset session.sitio.template = "/plantillas/Fondos/Plantilla.cfm"> 

<cf_templateheader title="Detalle de Cuenta Contable">
 		<table width="100%" border="0">
			<tr>
				<td>
					<cfinclude template="../operacion/cjc_formRDetalleCuentaContable.cfm">
 				</td>
			</tr>
		</table> 
<cf_templatefooter>
