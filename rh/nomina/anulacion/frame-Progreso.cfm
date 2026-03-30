<cfif not isdefined("Form.paso")>
	<cfset Form.paso = 1>
</cfif>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Pasos"
	xmlfile="/rh/generales.xml"	
	Default="Pasos"
	returnvariable="vPasos"/>

<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#vpasos#'>
	<table border="0" cellpadding="2" cellspacing="0" width="100%">
	  <!--- 1 --->
	  <tr>
		<td width="1%" align="right">
		  <cfif isdefined("Form.paso") and Compare(Form.paso,"1") GT 0 >
			<img src="/cfmx/rh/imagenes/w-check.gif" border="0">
		  <cfelseif Form.paso EQ "1">
			<img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		  </cfif>
		</td>
		<td width="1%" align="right"> <img src="/cfmx/rh/imagenes/num1_small.gif" border="0"> </td>
		<td class="etiquetaProgreso" nowrap><cf_translate key="LB_Seleccionar_Empleado" xmlfile="/rh/generales.xml">Seleccionar Empleado</cf_translate></td>
	  </tr>
	  <!--- 2 --->
	  <tr>
		<td width="1%" align="right">
		  <cfif isdefined("Form.paso") and Compare(Form.paso,"2") GT 0>
			<img src="/cfmx/rh/imagenes/w-check.gif" border="0">
			<cfelseif Form.paso EQ "2">
			<img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		  </cfif>
		</td>
		<td align="right"><img src="/cfmx/rh/imagenes/num2_small.gif" border="0"></td>
		<td class="etiquetaProgreso" nowrap><cf_translate key="LB_Seleccionar_Accion" xmlfile="/rh/generales.xml">Seleccionar Acci&oacute;n</cf_translate></td>
	  </tr>
	  <!--- 3 --->
	  <tr>
		<td width="1%" align="right">
		  <cfif isdefined("Form.paso") and Compare(Form.paso,"3") GT 0>
			<img src="/cfmx/rh/imagenes/w-check.gif" border="0">
			<cfelseif Form.paso EQ "3">
			<img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		  </cfif>
		</td>
		<td align="right"><img src="/cfmx/rh/imagenes/num3_small.gif" border="0"></td>
		<td class="etiquetaProgreso" nowrap><cf_translate key="LB_Anular_Accion" >Anular Acci&oacute;n</cf_translate></td>
	  </tr>
	</table>
<cf_web_portlet_end> 
