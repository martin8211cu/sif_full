<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_SIFAdministracionDelSistema"
Default="SIF - Administraci&oacute;n del Sistema"
XmlFile="/sif/generales.xml"
returnvariable="LB_SIFAdministracionDelSistema"/>
<cf_templateheader title="#LB_SIFAdministracionDelSistema#">
		

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
		
				<td valign="top">		<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>		
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='L&iacute;neas en Formatos'>
	
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
						<td valign="top">
<style type="text/css">
	.cuadro2{
		border: 1px solid #FFFFFF;
	}
</style>

							<cfset tabla = "FMT09CLR"& #_Cat# & " '<table align=''center'' bgcolor=''##'"& #_Cat# & " FMT09CLR"& #_Cat#& " ''' width=''50%'' heigth=''100%'' class=''cuadro2'' ><tr><td></td></tr></table>'"  >
							<cfinvoke 
							 component="sif.Componentes.pListas"
							 method="pListaRH"
							 returnvariable="pListaRet">
								<cfinvokeargument name="tabla" value="FMT009"/>
								<cfinvokeargument name="columnas" value="FMT01COD, FMT09LIN, FMT09FIL, FMT09COL, FMT09CLR, FMT09HEI, FMT09HEI, FMT09GRS, #tabla# as tabla"/>
								<cfinvokeargument name="desplegar" value="FMT09LIN, FMT09FIL, FMT09COL, tabla"/>
								<cfinvokeargument name="etiquetas" value="Línea,  Fila(X), Columna(Y), Color L&iacute;nea"/>
								<cfinvokeargument name="formatos" value="V, V, V, V"/>
								<cfinvokeargument name="filtro" value="FMT01COD='#form.FMT01COD#'" />
								<cfinvokeargument name="align" value="left, left, left, center"/>
								<cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="checkboxes" value="N"/>
								<cfinvokeargument name="Nuevo" value=""/>
								<cfinvokeargument name="irA" value="FMTLineas.cfm"/>
								<cfinvokeargument name="keys" value="FMT09LIN"/>
								<cfinvokeargument name="MaxRows" value="35"/>
							</cfinvoke>

						</td>
						<td valign="top"><cfinclude template="formFMTLineas.cfm"></td>
					</tr>
				</table>
            	
		<cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>