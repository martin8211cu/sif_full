<cf_templateheader title="Cat&aacute;logo interno de pol&iacute;ticas del Portal">

<cf_web_portlet_start titulo="Pol&iacute;ticas del Portal">
<cfinclude template="/home/menu/pNavegacion.cfm">

<table>
<tr><td valign="top">

<cfinvoke component="commons.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
	<cfinvokeargument name="tabla" value="PLista"/>
	<cfinvokeargument name="columnas" value="parametro,pnombre"/>
	<cfinvokeargument name="desplegar" value="parametro,pnombre"/>
	<cfinvokeargument name="etiquetas" value="Par&aacute;metro,Nombre"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="1=1 order by parametro"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="irA" value="index.cfm"/>
	<cfinvokeargument name="maxRows" value="20"/>
	<cfinvokeargument name="keys" value="parametro"/>
	<cfinvokeargument name="cortes" value=""/>
	<cfinvokeargument name="conexion" value="asp"/>
	<cfinvokeargument name="navegacion" value=""/>
	<cfinvokeargument name="MaxRows" value="80"/>
	<cfinvokeargument name="showEmptyListMsg" value="#true#"/>
</cfinvoke>

</td>


<td valign="top">
<cfinclude template="plista-form.cfm">
</td>

</tr>
</table>


<cf_web_portlet_end>
<cf_templatefooter>