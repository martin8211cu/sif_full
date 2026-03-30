<cfinclude template="LiquidacionAsociados-translate.cfm">
<!---QUERY PARA EL FILTRO DE LA LISTA, PARA EL CAMPO ESTADO--->
<cfquery datasource="#session.dsn#" name="rsEstado">
	select '' as value, '#LB_Todos#' as description, '0' as ord from dual
	union
	select '1' as value, '#LB_Aplicada#' as description, '1' as ord from dual 
	union
	select '0' as value, '#LB_EnProceso#' as description, '2' as ord from dual
	order by 3
</cfquery>
<cfif not isdefined('form.filtro_ACLestado')>
<cfset form.filtro_ACLestado = 0>
</cfif>
<cf_templateheader title="Recursos Humanos">
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cf_web_portlet_start titulo="#LB_LiquidacionDeAsociados#">
						<cf_dbfunction name="concat" args="c.DEapellido1,' ',c.DEapellido2,' ', c.DEnombre" returnvariable="vAsociado">
						<cfinvoke 
							component="rh.Componentes.pListas"
							method="pListaRH"
							mostrar_filtro="true"
							filtrar_automatico="true"
							columnas="a.ACLid, 
									  c.DEidentificacion,
									  #preservesinglequotes(vAsociado)# as Asociado,
									  ACLfecha,ACLestado as estado,
									  case ACLestado
											when 0 then '#LB_EnProceso#'
											when 1 then '#LB_Aplicada#'
										end ACLestado" 
							desplegar="DEidentificacion,Asociado,ACLestado,ACLfecha"
							filtrar_por="DEidentificacion,#preservesinglequotes(vAsociado)#,ACLestado,ACLfecha"    
							etiquetas="#LB_CodigoDeAsociado#,#LB_Asociado#, #LB_Estado#, #LB_Fecha#"
							align="left,left, left,left"
							formatos="S,S,S,D"
							tabla="ACLiquidacion a
									inner join ACAsociados b
										  on b.ACAid = a.ACAid
									inner join DatosEmpleado c
										  on c.DEid = b.DEid
										  and c.Ecodigo = #session.Ecodigo#"
							ira="LiquidacionAsociados.cfm"
							filtro= '1=1'
							showemptylistmsg="true"
							botones="#LB_Nuevo#"
							debug="N"
							rsACLestado="#rsEstado#"
						/>
 					<cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>