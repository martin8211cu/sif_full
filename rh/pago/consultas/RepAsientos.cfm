<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ReporteDeAsientos"
	Default="Reporte de asientos"	
	returnvariable="LB_ReporteDeAsientos"/>	

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cf_web_portlet_start titulo="<cfoutput>#LB_ReporteDeAsientos#</cfoutput>">
			<cfoutput>#pNavegacion#</cfoutput>
			<cfquery name="rsRelCalculo" datasource="#Session.DSN#">
				select a.RCNid, a.RCDescripcion, T.Tdescripcion
				from HRCalculoNomina a
					inner join TiposNomina T
					  on a.Ecodigo = T.Ecodigo 
					  and a.Tcodigo = T.Tcodigo
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and exists (
					select 1
					from RCuentasTipo x
					where x.Ecodigo = a.Ecodigo
					and x.RCNid = a.RCNid
				)
				order by T.Tdescripcion, a.RCNid, a.RCDescripcion
			</cfquery>
			
			<!---
			<cfquery name="rsRelCalculo" datasource="#Session.DSN#">
				select a.RCNid, a.ERNdescripcion as RCDescripcion, T.Tdescripcion
				from ERNomina a
					inner join TiposNomina T
					  on a.Ecodigo = T.Ecodigo 
					  and a.Tcodigo = T.Tcodigo
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and a.RCNid is not null
				group by T.Tdescripcion, a.RCNid, a.ERNdescripcion
			</cfquery>
			--->
			
			<!---=================== TRADUCCION ======================---->
			
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Lista_de_Relaciones_de_Calculo"
				Default="Lista de Relaciones de C&aacute;lculo"	
				returnvariable="LB_Lista_de_Relaciones_de_Calculo"/>

				
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Relacion_de_Calculo"
				Default="Relaci&oacute;n de C&aacute;lculo"	
				returnvariable="LB_Relacion_de_Calculo"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Tipo_de_Nomina"
				Default="Tipo de N&oacute;mina"	
				returnvariable="LB_Tipo_de_Nomina"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_No_se_encotraron_relaciones_de_calculo"
				Default="No se encotraron relaciones de cálculo"	
				returnvariable="LB_No_se_encotraron_relaciones_de_calculo"/>			
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Generar_Reporte"
				Default="Generar Reporte"
				returnvariable="BTN_Generar_Reporte"/>	
			
			<form name="form1" action="RepAsientos-rpt.cfm" method="get">
				<table width="98%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="45%" valign="top">															
							<cf_web_portlet_start border="true" titulo="#LB_ReporteDeAsientos#" skin="info1">
								<div align="justify">
								  <p><cf_translate key="LB_ConsultaDeAsientosAGenerarApartirDeUnaRelacionDeCalculoPagada">Consulta de asientos a generar a partir de una relaci&oacute;n de c&aacute;lculo pagada.</cf_translate></p>
								</div>
							<cf_web_portlet_end>
						</td>
						<td width="55%" valign="top">
							<table width="98%" cellpadding="2" cellspacing="0" align="center">
								<tr>
								  <td colspan="2" align="center">&nbsp;</td>
							    </tr>
								<tr>
									<td align="right" nowrap><strong><cf_translate key="Relacion_de_calculo">Relaci&oacute;n de C&aacute;lculo:</cf_translate>&nbsp;</strong></td>
									<td>  
										<!---
										<select name="RCNid">
										<cfoutput query="rsRelCalculo" group="Tdescripcion">
											<optgroup label="#Tdescripcion#">
												<cfoutput>
												<option value="#RCNid#">#RCDescripcion#</option>
												</cfoutput>
											</optgroup>
										</cfoutput>
										</select>
										--->

									<cf_conlis 
										campos="RCNid, RCDescripcion, Tdescripcion"
										size="0,40,0"
										desplegables="N,S,N"
										modificables="N,N,N"
										title="#LB_Lista_de_Relaciones_de_Calculo#"
										tabla="HRCalculoNomina a
												inner join TiposNomina T
												  on a.Ecodigo = T.Ecodigo 
												  and a.Tcodigo = T.Tcodigo"
										columnas="a.RCNid, a.RCDescripcion, T.Tdescripcion"
										filtro="a.Ecodigo = #Session.Ecodigo#
													and exists (
														select 1
														from RCuentasTipo x
														where x.Ecodigo = a.Ecodigo
														and x.RCNid = a.RCNid
													)
													order by a.RCNid desc, T.Tdescripcion, a.RCDescripcion"
										filtrar_por="a.RCDescripcion, T.Tdescripcion"
										desplegar="RCDescripcion, Tdescripcion"
										etiquetas="#LB_Relacion_de_Calculo#,#LB_Tipo_de_Nomina#"
										formatos="S,S"
										align="left,left"
										asignar="RCNid, RCDescripcion"
										asignarFormatos="S,S"
										form="form1"
										showEmptyListMsg="true"
										EmptyListMsg=" --- #LB_No_se_encotraron_relaciones_de_calculo# --- "/>
								   </td>
								</tr>
								<tr>
								  <td colspan="2" align="center">&nbsp;</td>
							    </tr>
								<tr>
									<td colspan="2" align="center">
										<cfoutput><input type="submit" name="btn_consultar" value="#BTN_Generar_Reporte#"/></cfoutput>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</form>
		<cf_web_portlet_end>
	<cf_templatefooter>	
