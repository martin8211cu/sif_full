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

<cfif isdefined("url.fTIcodigo") and len(trim(url.fTIcodigo))>
	<cfset form.fTIcodigo = url.fTIcodigo>
</cfif>
<cfif isdefined("url.fTIdescripcion") and len(trim(url.fTIdescripcion))>
	<cfset form.fTIdescripcion = url.fTIdescripcion>
</cfif>
<cfoutput>
<form action="TipoIncapacidad.cfm" method="post" name="formFiltroLista">
<table width="100%" border="0" cellspacing="1" cellpadding="1" class="AreaFiltro">
  <tr>
    <td><strong>#LB_CODIGO#&nbsp;:&nbsp;</strong></td>
	<td><strong>#LB_DESCRIPCION#&nbsp;:&nbsp;</strong></td>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td><input name="fTIcodigo" type="text" value="<cfif isdefined("form.fTIcodigo")>#form.fTIcodigo#</cfif>" maxlength="5"></td>
	<td><input name="fTIdescripcion" type="text" value="<cfif isdefined("form.fTIdescripcion")>#form.fTIdescripcion#</cfif>" maxlength="40"></td>
	<td><cf_botones values="#BTN_Filtrar#" form="formFiltroLista"></td>
  </tr>
</table>
</form>
</cfoutput>