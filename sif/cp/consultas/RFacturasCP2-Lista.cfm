<cf_templateheader title="SIF - Cuentas por Cobrar">
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
		            <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Lista de Documentos">
						<cfset regresar = "/cfmx/sif/cc/consultas/RFacturasCC2.cfm"> 
						<cfinclude template="/sif/portlets/pNavegacionCC.cfm">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
						  <tr valign="top"> 
							<td>&nbsp;</td>
						  </tr>
						  
						  <tr valign="top"> 
							<td align="center">
							<!---  <cfinvoke
									component="sif.Componentes.pListas"
									method="pListaQuery"
									returnvariable="pLista"
									query="#rsDocumentos#"
									formname="listaDocum"
									desplegar="Tipo, Ddocumento, SNnumero, SNidentificacion,SNnombre, Dfecha, DVencimiento, Moneda, monto, Oficodigo"
									etiquetas="Tipo Transaccin, Documento, Socio, Cdula, Nombre, Fecha Doc, Fecha Venc., Moneda, Monto, Oficina"
									formatos="S, S, S, S, S, D, D, S, M, S"
									align="left, left, left, left, left, center, center, center, right, right"
									showlink="true"
									maxrows="0"
									pageindex=""
									ira="RFacturasCC2-DetalleDoc.cfm"/>  --->
									
									
							</td>
						  </tr>
						 
						</table>	
		
		            <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>
