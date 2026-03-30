<cfquery name="rsEstados" datasource="#session.DSN#">
	select  -1 as value, 'Todos' as description from dual
	union all
	select  0 as value, 'Inactivo' as description from dual
	union all
	select 1 as value, 'Activo' as description from dual
	order by 1
</cfquery>
<cf_templateheader title="Segmentos">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Segmentos'>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr> 
				<td valign="top"> 
					<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
						tabla="MIGProSegmentos"
						columnas="MIGProSegid, MIGProSegcodigo, MIGProSegdescripcion, case Dactiva when 0 then 'Inactivo' when 1 then 'Activo' end as Dactiva"
						desplegar="MIGProSegcodigo, MIGProSegdescripcion, Dactiva"
						etiquetas="C&oacute;digo, Descripci&oacute;n, Estado"
						formatos="S,S,S"
						filtro="Ecodigo=#session.Ecodigo# order by MIGProSegcodigo "
						align="left,left,left"
						checkboxes="N"
						keys="MIGProSegid"
						MaxRows="15"
						pageindex="1"
						filtrar_automatico="true"
						mostrar_filtro="true"
						filtrar_por="MIGProSegcodigo, MIGProSegdescripcion,Dactiva, &nbsp;, &nbsp;"
						ira="Segmento.cfm"
						showEmptyListMsg="true"
						rsDactiva="#rsEstados#"
						inactivecol="valido">
				</td>
				<td align="left" valign="top" width="50%">
					<cfinclude template="SegmentoForm.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>	
<cf_templatefooter>