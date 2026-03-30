<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_CODIGO"
Default="C&oacute;digo"
XmlFile="/rh/generales.xml"
returnvariable="LB_CODIGO"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_DESCRIPCION"
Default="Descripci&oacute;n"
XmlFile="/rh/generales.xml"
returnvariable="LB_DESCRIPCION"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="BTN_Filtrar"
Default="Filtrar"
XmlFile="/rh/generales.xml"
returnvariable="BTN_Filtrar"/>

<cfif isdefined("url.fRCcodigo") and len(trim(url.fRCcodigo))>
	<cfset form.fRCcodigo = url.fRCcodigo>
</cfif>
<cfif isdefined("url.fRCdescripcion") and len(trim(url.fRCdescripcion))>
	<cfset form.fRCdescripcion = url.fRCdescripcion>
</cfif>
<cfoutput>
<form action="RegimenContratacion.cfm" method="post" name="formFiltroLista">
<table width="100%" border="0" cellspacing="1" cellpadding="1" class="AreaFiltro">
  <tr>
    <td><strong>#LB_CODIGO#&nbsp;:&nbsp;</strong></td>
	<td><strong>#LB_DESCRIPCION#&nbsp;:&nbsp;</strong></td>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td><input name="fRCcodigo" type="text" value="<cfif isdefined("form.fRCcodigo")>#form.fRCcodigo#</cfif>" maxlength="5"></td>
	<td><input name="fRCdescripcion" type="text" value="<cfif isdefined("form.fRCdescripcion")>#form.fRCdescripcion#</cfif>" maxlength="40"></td>
	<td><cf_botones values="#BTN_Filtrar#" form="formFiltroLista"></td>
  </tr>
</table>
</form>
</cfoutput>