<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_SIFAdministracionDelSistema"
Default="SIF - Administraci&oacute;n del Sistema"
XmlFile="/sif/generales.xml"
returnvariable="LB_SIFAdministracionDelSistema"/>
<cf_templateheader title="#LB_SIFAdministracionDelSistema#">
		

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
		            <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Im&aacute;genes
              del Formato de Impresi&oacute;n'>
	
		
		<table width="100%" border="0" cellpadding="1" cellspacing="0">
			
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


		  	<!--- Mantenimiento --->
			<tr>
				<td width="40%" valign="top">

					<cfinvoke 
					 component="sif.Componentes.pListas"
					 method="pListaRH"
					 returnvariable="pListaRet">
						<cfinvokeargument name="tabla" value="FMT003"/>
						<cfinvokeargument name="columnas" value="FMT01COD, FMT03LIN, FMT03FIL, FMT03COL, FMT03ALT, FMT03ANC, FMT03BOR, FMT03CFN, FMT03CBR"/>
						<cfinvokeargument name="desplegar" value="FMT03COL, FMT03FIL, FMT03ALT, FMT03ANC,"/>
						<cfinvokeargument name="etiquetas" value="Pos. X, Pos. Y, Alto, Ancho"/>
						<cfinvokeargument name="formatos" value="F,F,F,F"/>
						<cfinvokeargument name="filtro" value="FMT01COD = '#Form.FMT01COD#' "/>
						<cfinvokeargument name="align" value="left, left, left, left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="irA" value="ImagenesFormato.cfm"/>
					</cfinvoke>


		  		</td>

				<td width="60%" valign="top"><cfinclude template="formImagenesFormato.cfm"></td>
			</tr>
		</table>
		   
            	
		           <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>