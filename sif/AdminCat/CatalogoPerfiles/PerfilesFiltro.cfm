
<cfset filtro = "">
<cfset navegacion = "">
<cfset addCols = "">

	<!--
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_CODIGO"
			Default="C&oacute;digo"
			XmlFile="/sif/rh/generales.xml"
			returnvariable="LB_CODIGO"/>

			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_DESCRIPCION"
			Default="Descripci&oacute;n"
			returnvariable="LB_DESCRIPCION"/>
		</td>---->
<cfif isdefined("Form.ADSPcodigoF") and Len(Trim(Form.ADSPcodigoF)) NEQ 0>
	<cfset filtro = filtro & " and upper(ADSPcodigo) like '%" & #UCase(Form.ADSPcodigoF)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ADSPcodigoF=" & Form.ADSPcodigoF>
	<cfset addCols = addCols & ", '#Form.ADSPcodigoF#' as ADSPcodigoF">
</cfif>
<cfif isdefined("Form.ADSPdescripcionF") and Len(Trim(Form.ADSPdescripcionF)) NEQ 0>
	<cfset filtro = filtro & " and upper(ADSPdescripcion) like '%" & #UCase(Form.ADSPdescripcionF)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ADSPdescripcionF=" & Form.ADSPdescripcionF>
	<cfset addCols = addCols & ", '#Form.ADSPdescripcionF#' as ADSPdescripcionF">
</cfif>

	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
        <cfoutput>
			<form name="filtroPerfiles" method="post" action="#CurrentPage#">
            	<table  border="0" cellspacing="0" cellpadding="0" class="areafiltro" width="100%">
                    <tr>
                        <td align="left" ><strong>#LB_CODIGO#</strong></td>
                        <td align="left" ><strong>#LB_DESCRIPCION#</strong></td>
                    </tr>
                    <tr>
                        <td><input name="ADSPcodigoF" type="text" size="20" tabindex="1" maxlength="30"
                            <cfif isdefined("form.ADSPcodigoF") and len(trim(form.ADSPcodigoF)) gt 0>value="#form.ADSPcodigoF#"</cfif> />
                        </td>
                        <td align="left">
                            <input name="ADSPdescripcionF" type="text" size="40" tabindex="1" maxlength="70"
							<cfif isdefined("form.ADSPdescripcionF") and len(trim(form.ADSPdescripcionF)) gt 0>value="#form.ADSPdescripcionF#"</cfif>>
                        </td>

                        <td align="center">
                            <input name="Filtrar" class="BtnFiltrar" type="submit" value="Filtrar" tabindex="1">
                        </td>
                    </tr>
				</table>
			</form>
    	</cfoutput>

