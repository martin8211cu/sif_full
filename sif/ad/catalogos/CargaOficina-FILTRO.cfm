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
Key="LB_CARGA"
Default="Carga"
XmlFile="/rh/generales.xml"
returnvariable="LB_CARGA"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="BTN_Filtrar"
Default="Filtrar"
XmlFile="/rh/generales.xml"
returnvariable="BTN_Filtrar"/>

<cfif isdefined("url.fDCcodigo") and len(trim(url.fDCcodigo))>
	<cfset form.fDCcodigo = url.fDCcodigo>
</cfif>
<cfif isdefined("url.fDCdescripcion") and len(trim(url.fDCdescripcion))>
	<cfset form.fDCdescripcion = url.fDCdescripcion>
</cfif>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Oficina"
	Default="Oficina"
	XmlFile="/sif/generales.xml"
	returnvariable="LB_Oficina"/>

<cfoutput>
<form action="CargaOficina.cfm" method="post" name="formFiltroLista">
<input name="Ocodigo" type="hidden" value="<cfif isdefined("form.Ocodigo")><cfoutput>#form.Ocodigo#</cfoutput></cfif>">	
<input name="Oficodigo" type="hidden" value="<cfif isdefined("form.Oficodigo")><cfoutput>#form.Oficodigo#</cfoutput></cfif>">		
<input name="Odescripcion" type="hidden" value="<cfif isdefined("form.Odescripcion")><cfoutput>#form.Odescripcion#</cfoutput></cfif>">			
<table width="100%" border="0" cellspacing="1" cellpadding="1" class="AreaFiltro">
    <tr>
        <td colspan="2"><strong>#LB_Oficina#: #form.Oficodigo# #form.Odescripcion#</strong></td>
    </tr>
    <tr>   
        <td><strong>#LB_CODIGO#</strong></td>
        <td><strong>#LB_CARGA#</strong></td>
    </tr>
    <tr>
        <td><input name="fDCcodigo" type="text" value="<cfif isdefined("form.fDCcodigo")>#form.fDCcodigo#</cfif>" maxlength="40"></td>
        <td><input name="fDCdescripcion" type="text" value="<cfif isdefined("form.fDCdescripcion")>#form.fDCdescripcion#</cfif>" maxlength="40"></td>
        <td><cf_botones values="#BTN_Filtrar#" form="formFiltroLista"></td>
    </tr>
</table>
</form>
</cfoutput>