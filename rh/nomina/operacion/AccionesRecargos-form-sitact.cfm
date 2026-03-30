<style type="text/css">
	.Completo { 
		background:#F5F5F5;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
</style>
<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
	  <tr>
		<td class="#Session.Preferences.Skin#_thcenter" colspan="2"><div align="center"><cf_translate key="LB_Situacion_Actual">Situaci&oacute;n Actual</cf_translate></div></td>
	  </tr>
	  <tr>
		<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Plaza">Plaza</cf_translate></td>
		<td height="25" nowrap>#rsEstadoActual.RHPPcodigo# -  #rsEstadoActual.RHPPdescripcion#</td>
	  </tr>
	  <tr>
		<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Oficina" XmlFile="/rh/generales.xml">Oficina</cf_translate></td>
		<td height="25" nowrap>#rsEstadoActual.Odescripcion#</td>
	  </tr>
	  <tr>
		<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Departamento">Departamento</cf_translate></td>
		<td height="25" nowrap>#rsEstadoActual.Ddescripcion#</td>
	  </tr>
	  <tr>
	  	<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Centro_Funcional">Centro Funcional</cf_translate></td>
		<td>#rsEstadoActual.Ctrofuncional#</td>
	  </tr>
	  <cfif usaEstructuraSalarial EQ 1>		 
		  <cf_rhcategoriapuesto form="form1" query="#rsEstadoActual#" tablaReadonly="true" categoriaReadonly="true" puestoReadonly="true" incluyeTabla="false" incluyeHiddens="false">
	  </cfif>
	  <tr>
		<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Puesto_RH">Puesto RH</cf_translate></td>
		<td height="25" nowrap>#rsEstadoActual.Puesto#</td>
	  </tr>	
	  <tr>
		<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Porcentaje_de_Plaza">Porcentaje de Plaza</cf_translate></td>
		<td height="25" nowrap><cfif rsEstadoActual.LTporcplaza NEQ "">#LSCurrencyFormat(rsEstadoActual.LTporcplaza,'none')# %<cfelse>0.00 %</cfif></td>
	  </tr>
	  <tr>
		<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Porcentaje_de_Salario_Fijo">Porcentaje de Salario Fijo</cf_translate></td>
		<td height="25" nowrap><cfif rsEstadoActual.LTporcsal NEQ "">#LSCurrencyFormat(rsEstadoActual.LTporcsal,'none')# %<cfelse>0.00 %</cfif></td>
	  </tr>
	</table>
</cfoutput>