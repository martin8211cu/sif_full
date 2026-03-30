<cf_templateheader title="Tesorería">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Tipo de Gastos">
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan="3">
		</td>
	</tr>
	<tr>
		<td valign="top"> 
		   <cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="GEtipoGasto"/>
			<cfinvokeargument name="columnas" value="GETid, GETtipo, GETdescripcion"/>
			<cfinvokeargument name="desplegar" value="GETtipo, GETdescripcion"/>
			<cfinvokeargument name="etiquetas" value="Codigo, Descripcion Gasto"/>
			<cfinvokeargument name="formatos" value="S,S"/>
			<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo#"/> 
			<cfinvokeargument name="align" value="left,left"/>
			<cfinvokeargument name="ajustar" value="S"/>
			<cfinvokeargument name="keys" value="GETid"/>
			<cfinvokeargument name="irA" value="C_TipoGasto.cfm"/>
		  </cfinvoke> 
		</td>				
		<td valign="top">
		   <cfinclude template="C_TipoGastoform.cfm">
		</td>
	</tr>
</table>
	
<cf_web_portlet_end>
<cf_templatefooter> 