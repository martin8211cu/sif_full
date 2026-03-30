<!--- 
Archivo:  cjc_formRDetalleTransFondo.cfm"
Creado:   Randall Colomer en el ICE.   
Fecha:    26 Octubre 2006.              
--->
<cfset session.sitio.template = "/plantillas/Fondos/Plantilla.cfm"> 

<cf_templateheader title="Detalle de Transacciones por Fondo">
 		<table width="100%" border="0">
			<tr>
				<td>
					<cfinclude template="../operacion/cjc_formRDetalleTransFondo.cfm">
 				</td>
			</tr>
		</table> 
<cf_templatefooter>

