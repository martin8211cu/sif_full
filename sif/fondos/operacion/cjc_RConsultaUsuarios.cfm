<!--- 
Archivo:  cjc_RConsultaUsuarios.cfm
Creado:   Randall Colomer en el ICE.   
Fecha:    18 Octubre 2006.              
--->
<cfset session.sitio.template = "/plantillas/Fondos/Plantilla.cfm"> 

<cf_templateheader title="Consulta de Usuarios">
 		<table width="100%" border="0">
			<tr>
				<td>
					<cfinclude template="../operacion/cjc_formRConsultaUsuarios.cfm">
 				</td>
			</tr>
		</table> 
<cf_templatefooter>
