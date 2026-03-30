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

<cfif isdefined("url.fCScodigo") and len(trim(url.fCScodigo))>
	<cfset form.fCScodigo = url.fCScodigo>
</cfif>
<cfif isdefined("url.fCSdescripcion") and len(trim(url.fCSdescripcion))>
	<cfset form.fCSdescripcion = url.fCSdescripcion>
</cfif>
<cfoutput>
<form action="ConceptosSAT.cfm" method="post" name="formFiltroLista">
<table width="100%" border="0" cellspacing="1" cellpadding="1" class="AreaFiltro">
  <tr>
    <td><strong>#LB_CODIGO#&nbsp;:&nbsp;</strong></td>
	<td><strong>#LB_DESCRIPCION#&nbsp;:&nbsp;</strong></td>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td><input name="fCScodigo" type="text" width="10" value="<cfif isdefined("form.fCScodigo")>#form.fCScodigo#</cfif>" maxlength="5"></td>
	<td><input name="fCSdescripcion" type="text" width="40" value="<cfif isdefined("form.fCSdescripcion")>#form.fCSdescripcion#</cfif>" maxlength="40"></td>
	<td><cf_botones values="#BTN_Filtrar#" form="formFiltroLista"></td>
  </tr>
</table>
</form>
</cfoutput>