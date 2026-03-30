<cfquery name="rsEstados" datasource="#session.DSN#">
	select  -1 as value, 'Todos' as description from dual
	union all
	select  0 as value, 'Inactivo' as description from dual
	union all
	select 1 as value, 'Activo' as description from dual
	order by 1
</cfquery>
<cf_templateheader title="Factor Critico">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Factor Critico'>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr> 
				<td valign="top"> 
					<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
						tabla="MIGFCritico"
						columnas="MIGFCid, MIGFCcodigo, MIGFCdescripcion, case Dactiva when 0 then 'Inactivo' when 1 then 'Activo' end as Dactiva"
						desplegar="MIGFCcodigo, MIGFCdescripcion, Dactiva"
						etiquetas="C&oacute;digo, Descripci&oacute;n, Estado"
						formatos="S,S,S"
						filtro="Ecodigo=#session.Ecodigo# order by MIGFCcodigo"
						align="left,left,left"
						checkboxes="N"
						keys="MIGFCid"
						MaxRows="15"
						pageindex="1"
						filtrar_automatico="true"
						mostrar_filtro="true"
						filtrar_por="MIGFCcodigo, MIGFCdescripcion,Dactiva, &nbsp;, &nbsp;"
						ira="FactorCritico.cfm"
						showEmptyListMsg="true"
						rsDactiva="#rsEstados#"
						inactivecol="valido">
				</td>
				<td align="left" valign="top" width="50%">
					<cfinclude template="FactorCriticoForm.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>	
<cf_templatefooter>