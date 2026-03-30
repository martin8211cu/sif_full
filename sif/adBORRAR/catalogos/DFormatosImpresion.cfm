<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_SIFAdministracionDelSistema"
Default="SIF - Administraci&oacute;n del Sistema"
XmlFile="/sif/generales.xml"
returnvariable="LB_SIFAdministracionDelSistema"/>
		
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">						<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>						
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Detalle de Formatos de Impresi&oacute;n'>
					
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td colspan="2">
									<cfoutput>
										<table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="##DFDFDF">
										    <tr align="left"> 
												<td><cfinclude template="../../portlets/pNavegacion.cfm"></td>
										    </tr>
										</table>
									</cfoutput>
								</td>
							</tr>
							<tr>
								<td></td>
								<td><cfinclude template="formDFormatosImpresion.cfm"></td>
							</tr>
							<tr>
								<td colspan="2">
									<cfinvoke 
											 component="sif.Componentes.pListas"
											 method="pListaRH"
											 returnvariable="pListaRet">
										<cfinvokeargument name="tabla" value="FMT002"/>
										<cfinvokeargument name="columnas" value="FMT01COD, FMT02LIN, FMT02DES, (case FMT02STS when 1 then 'No' when 0 then 'Sí' end ) as FMTSTS, (case FMT02POS when '1' then 'Encabezado' when '2' then 'Detalle' when '3' then 'PostDetalle' end ) as FM02TPOS, FMT02FIL, FMT02COL, (case FMT02TIP when 1 then 'Etiquetas' when 2 then 'Datos' when 3 then 'Sin Definir' end ) as FMT02TIP"/>
										<cfinvokeargument name="desplegar" value="FMT02DES, FMTSTS, FM02TPOS, FMT02FIL, FMT02COL"/>
										<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, Visible, Posici&oacute;n, Pos. X (cm), Pos. Y (cm)"/>
										<cfinvokeargument name="formatos" value="V, V, V, N, N"/>
										<cfinvokeargument name="filtro" value="FMT01COD='#form.FMT01COD#' order by FMT02TIP,FMT02POS, FMT02DES" />
										<cfinvokeargument name="align" value="left, left, left, left, left"/>
										<cfinvokeargument name="ajustar" value="N"/>
										<cfinvokeargument name="checkboxes" value="N"/>
										<cfinvokeargument name="Nuevo" value=""/>
										<cfinvokeargument name="irA" value="DFormatosImpresion.cfm"/>
										<cfinvokeargument name="Cortes" value="FMT02TIP"/>
										<cfinvokeargument name="MaxRows" value="100"/>
									</cfinvoke>
								</td>
							</tr>
						</table>
								
				<cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>
