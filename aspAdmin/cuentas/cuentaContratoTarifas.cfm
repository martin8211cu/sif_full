<cfif (isdefined("url.COcodigo") and not isdefined("form.COcodigo"))>
	<cfset form.COcodigo = url.COcodigo>
</cfif> 	
<cfif (isdefined("url.cliente_empresarial") and not isdefined("form.cliente_empresarial"))>
	<cfset form.cliente_empresarial = url.cliente_empresarial>
</cfif> 

<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
	<td width="35%" valign="top">
 		<cfinvoke component="aspAdmin.Componentes.pListasASP" 
				  method="pLista" 
				  returnvariable="pListaTarifasXContrato">
			<cfinvokeargument name="tabla" value="
					ClienteContratoTarifas cct
					, ClienteContrato cc
					, TarifaCalculoIndicador tci"/>
			<cfinvokeargument name="columnas" value="
					 convert(varchar,cliente_empresarial ) as cliente_empresarial 
					, convert(varchar,cct.COcodigo) as COcodigo
					, convert(varchar,cct.TCcodigo) as TCcodigo
					, case COTmeses
						when 1 then 'Mes vencido'
						when 12 then 'Año vencido'
						when 0 then 'Pago Inicial'
						when 2 then 'Bimestre vencido'
						when 3 then 'Trimestre vencido'
						when 4 then 'Cuatrimestre vencido'
						when 6 then 'Semestre vencido'
					end COTmeses
					, TCnombre"/>
			<cfinvokeargument name="desplegar" value="TCnombre,COTmeses"/>
			<cfinvokeargument name="etiquetas" value="Indicador&nbsp;Tarifario, Periodicidad"/>
			<cfinvokeargument name="formatos"  value=""/>
			<cfinvokeargument name="filtro" value="
					cliente_empresarial = #form.cliente_empresarial#
					and cct.COcodigo=#form.COcodigo#
					and cct.COcodigo=cc.COcodigo
					and cct.TCcodigo=tci.TCcodigo
					order by TCnombre"/>
			<cfinvokeargument name="align" value="left,left"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="keys" value="COcodigo,TCcodigo"/>
			<cfinvokeargument name="irA" value="CuentaPrincipal_tabs.cfm"/>
			<cfinvokeargument name="formName" value="form_listaPaqueteTarifas"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>				
	</td>
	<td width="65%" valign="top">
		<cfinclude template="cuentaContratoTarifas_form.cfm">
	</td>
  </tr>
</table>	
