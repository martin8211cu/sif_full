<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_RecursosHumanos"
	default="Recursos Humanos"
	xmlfile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_MovimientoDeIncidenciasEntreEmpresas"
	default="Movimiento de Incidencias entre Empresas"
	returnvariable="LB_MovimientoDeIncidenciasEntreEmpresas"/>

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_RecursosHumanos"
		default="Recursos Humanos"
		xmlfile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	
	<cf_web_portlet_start titulo="#LB_MovimientoDeIncidenciasEntreEmpresas#" >
		<cfinclude template="/rh/portlets/pNavegacion.cfm">	
		<cfquery name="rsP580" datasource="#session.DSN#"	>
			select Pvalor
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = 580
		</cfquery>

		<cfquery name="rsParametro" datasource="#session.DSN#"	>
			select Pvalor as Ecodigo
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = 590
		</cfquery>
		<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="Guardar"
						default="Guardar"
						xmlfile="/rh/generales.xml"
						returnvariable="Guardar"/>

		<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="Regresar"
						default="Regresar"
						xmlfile="/rh/generales.xml"
						returnvariable="Regresar"/>

		<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="Relacion_de_Calculo"
						default="Relación de Cálculo"
						returnvariable="RelacionCalculo"/>

		<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="Relacion_Aplicada"
						default="La relacion de Nomina ya fue aplicada anteriormente, desea volver a aplicarla?"
						returnvariable="RelacionAplicada"/>

		<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="Concepto_Incidente"
						default="Concepto Incidente"
						returnvariable="ConceptoIncidente"/>

		<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="Tipo_Cambio"
						default="Tipo de Cambio"
						returnvariable="TipoCambio"/>

		<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_El_siguiente_campo_debe_ser_mayor_que_cero"
						default="El siguiente campo debe ser mayor que cero"
						returnvariable="vErrores"/>

		<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Lista_de_Relaciones_de_Calculo"
						default="Lista de Relaciones de Cálculo"
						returnvariable="vListaRelacion"/>

		<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_No_se_encontraron_Relaciones_de_Calculo"
						default="No se encontraron Relaciones de C&aacute;lculo"
						returnvariable="vNoListaRelacion"/>

		<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_No_se_encontraron_Relaciones_de_Calculo"
						default="No se encontraron Relaciones de C&aacute;lculo"
						returnvariable="vNoListaRelacion"/>


		<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Tipo_Nomina"
						default="Tipo N&oacute;mina"
						returnvariable="vTipoNomina"/>

		<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Descripcion"
						default="Descripci&oacute;n"
						returnvariable="vDescripcion"/>

		<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Desde"
						default="Desde"
						returnvariable="vDesde"/>

		<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Hasta"
						default="Hasta"
						returnvariable="vHasta"/>

		<cfif rsP580.Pvalor eq 1 >
			<cfif len(trim(rsParametro.Ecodigo))>
				<cfif rsParametro.Ecodigo neq session.Ecodigo >
					<cfoutput>
					<cfparam name="form.tipo" default="C">
					<form name="form1" method="post" action="incidenciasEmpresas-sql.cfm" style="margin:0;" onsubmit="javascript:return funcAplicar();">
					<table width="98%" align="center" cellpadding="4" cellspacing="0">
						<!---
						<tr>
							<td colspan="2" align="center">
								<table width="30%" align="center" cellpadding="3" cellspacing="0" border="0" style="border: 1px solid gray;" >
									<tr><td colspan="2" bgcolor="##CCCCCC"><strong>Trabajar con:</strong></td></tr>
									<tr bgcolor="##F2F2F2">
										<td width="1%" style="padding-left:35px;" align="right" ><input type="radio" name="tipo" id="tipo" <cfif isdefined("form.tipo") and form.tipo eq 'C'>checked="checked" value="C"</cfif> /></td>
										<td width="50%" nowrap="nowrap"><label for="tipo">N&oacute;minas Cerradas</label></td>
									</tr>
									<tr bgcolor="##F2F2F2">
										<td width="1%" style="padding-left:35px;" align="right"><input type="radio" name="tipo" value="A" <cfif isdefined("form.tipo") and form.tipo eq 'A'>checked="checked" value="A"</cfif> /></td>
										<td width="50%" nowrap="nowrap"><label for="tipo">N&oacute;minas abiertas</label></td>
									</tr>
								</table>
							</td>
						</tr>
						--->
						
						<tr>
							<td align="right" width="40%" valign="top"><strong><cf_translate key="LB_Trabajar_con">Trabajar con</cf_translate>:&nbsp;</strong></td>
							<td colspan="2" >
								<table width="30%" cellpadding="1" cellspacing="0" border="0" >
									<tr>
										<td width="1%" align="right" ><input type="radio" name="tipo" id="tipo" value="C" onclick="jasvascript:this.form.action=''; this.form.submit();" <cfif isdefined("form.tipo") and form.tipo eq 'C'>checked="checked" value="C"</cfif> /></td>
										<td width="99%" nowrap="nowrap"><label ><cf_translate key="LB_Nominas_Ceradas">N&oacute;minas Cerradas</cf_translate></label></td>
									</tr>
									<tr>
										<td width="1%" align="right"><input type="radio" name="tipo" value="A" onclick="jasvascript:this.form.action=''; this.form.submit();" <cfif isdefined("form.tipo") and form.tipo eq 'A'>checked="checked" value="A"</cfif> /></td>
										<td width="99%" nowrap="nowrap"><label ><cf_translate key="LB_Nominas_Abiertas">N&oacute;minas abiertas</cf_translate></label></td>
									</tr>
								</table>
							</td>
						</tr>

						<tr>
							<td align="right" width="40%"><strong><cf_translate key="Relacion_de_Calculo">Relaci&oacute;n de C&aacute;lculo</cf_translate>:&nbsp;</strong></td>
							<td width="1%">
								<cfif isdefined("form.tipo") and form.tipo eq 'C'>
									<cf_conlis
										campos="RCNid,Tcodigo,Tdescripcion,RCDescripcion,RCdesde,RChasta,RCtc"
										desplegables="N,N,N,S,N,N,N"
										modificables="N,N,N,N,N,N,N"
										size="0,5,25,50,12,12,0"
										title="#vListaRelacion#"
										tabla="HRCalculoNomina a
												inner join TiposNomina b
												on b.Ecodigo=a.Ecodigo
												and b.Tcodigo=a.Tcodigo "
										columnas="a.RCNid, a.Tcodigo, b.Tdescripcion, a.RCDescripcion, a.RCdesde, a.RChasta, a.RCtc"
										filtro="a.Ecodigo=#rsParametro.Ecodigo# order by a.RCdesde  desc ,a.Tcodigo,a.RCDescripcion"
										desplegar="Tcodigo,Tdescripcion,RCDescripcion,RCdesde,RChasta"
										filtrar_por="a.Tcodigo,Tdescripcion,RCDescripcion,RCdesde,RChasta"
										etiquetas="#vTipoNomina#,#vDescripcion#,#RelacionCalculo#,#vDesde#,#vHasta#"
										formatos="S,S,S,D,D"
										align="left,left,left,left,left"
										asignar="RCNid,RCDescripcion,RCtc"
										asignarformatos="S,S,S"
										showEmptyListMsg="true"
										EmptyListMsg="-- #vNoListaRelacion# --"
										tabindex="1"
										width="900"
										funcion="validar" >
								<cfelse>		
									<cf_conlis
										campos="RCNid,Tcodigo,Tdescripcion,RCDescripcion,RCdesde,RChasta,RCtc"
										desplegables="N,N,N,S,N,N,N"
										modificables="N,N,N,N,N,N,N"
										size="0,5,25,50,12,12,0"
										title="#vListaRelacion#"
										tabla="RCalculoNomina a
												inner join TiposNomina b
												on b.Ecodigo=a.Ecodigo
												and b.Tcodigo=a.Tcodigo "
										columnas="a.RCNid, a.Tcodigo, b.Tdescripcion, a.RCDescripcion, a.RCdesde, a.RChasta, a.RCtc"
										filtro="a.Ecodigo=#rsParametro.Ecodigo# order by a.Tcodigo,a.RCDescripcion"
										desplegar="Tcodigo,Tdescripcion,RCDescripcion,RCdesde,RChasta"
										filtrar_por="a.Tcodigo,Tdescripcion,RCDescripcion,RCdesde,RChasta"
										etiquetas="#vTipoNomina#,#vDescripcion#,#RelacionCalculo#,#vDesde#,#vHasta#"
										formatos="S,S,S,D,D"
										align="left,left,left,left,left"
										asignar="RCNid,RCDescripcion,RCtc"
										asignarformatos="S,S,S"
										showEmptyListMsg="true"
										EmptyListMsg="-- #vNoListaRelacion# --"
										tabindex="1"
										width="900"
										funcion="validar" >
								</cfif>	
									
							</td>
							<td width="30%"></td>
						</tr>
	
						<tr>
							<td align="right" width="40%"><strong><cf_translate key="Concepto_Incidente">Concepto Incidente</cf_translate>:&nbsp;</strong></td>
							<td colspan="2">
								<cf_conlis
									campos="CIid, CIcodigo, CIdescripcion"
									desplegables="N,S,S"
									modificables="N,S,N"
									size="0,3,30"
									title="Lista de Conceptos Incidentes"
									tabla="CIncidentes a"
									columnas="a.CIid, a.CIcodigo, a.CIdescripcion"
									filtro="a.Ecodigo=#session.Ecodigo# and CIcarreracp = 0 order by a.CIcodigo"
									desplegar="CIcodigo,CIdescripcion"
									filtrar_por="a.CIcodigo,a.CIdescripcion"
									etiquetas="C&oacute;digo, Descripci&oacute;n"
									formatos="S,S"
									align="left,left"
									asignar="CIid, CIcodigo, CIdescripcion"
									asignarformatos="S,S,S"
									showEmptyListMsg="true"
									EmptyListMsg="-- No se encontraron Conceptos Incidentes --"
									tabindex="1" >
							</td>
						</tr>
	
						<tr>
							<td align="right"><strong><cf_translate key="Tipo_de_Cambio">Tipo de Cambio</cf_translate>:&nbsp;</strong></td>
							<td colspan="2"><cf_monto name="tipo_cambio" decimales="2" size="15" value="0"></td>
						</tr>
						
						<tr>
							<td align="center" colspan="3">
								<input type="submit" name="Aplicar" class="btnGuardar" value="#Guardar#" tabindex="2">
								<input type="button" name="Regresar" value="#Regresar#" class="btnAnterior" onclick="javascript:location.href='/cfmx/rh/expediente/MenuExpNom.cfm'" tabindex="2">
								<input type="hidden" name="EcodigoOrigen" value="#rsParametro.Ecodigo#">
								<input type="hidden" name="existe" value="N">
							</td>
						</tr>
					</table>
					</form>
					
					<cf_qforms>
					<script type="text/javascript" language="javascript1.2">
						objForm.RCNid.required = true;
						objForm.RCNid.description = '#RelacionCalculo#';
						objForm.CIid.required = true;
						objForm.CIid.description = '#ConceptoIncidente#';
						objForm.tipo_cambio.required = true;
						objForm.tipo_cambio.description = '#TipoCambio#';
						
						function validar(){
							document.form1.tipo_cambio.value = document.form1.RCtc.value;
							fm(document.form1.tipo_cambio,2);
							document.getElementById("framevalidar").src = 'incidenciasEmpresas-validar.cfm?RCNid='+document.form1.RCNid.value;
						}
	
	
						function funcAplicar(){
							if ( parseFloat(qf(document.form1.tipo_cambio.value)) <= 0){
								alert('#VErrores#: #TipoCambio#');
								return false;
							}
						
							
							if ( document.form1.existe.value != 'N' ){
								if ( confirm('#RelacionAplicada#') ) {
									return true;
								}
								else{
									return false;
								}
							}
							return true;
						}
	
					</script>
					</cfoutput>
				<cfelse>
					<cfoutput>
					<br />
					<table width="50%" border="0" align="center" cellpadding="2" class="areaFiltro">
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td align="center"><cf_translate key="Error_Misma_Empresa">Usted esta trabajando con la emprea origen para hacer movimientos de incidencias entre empresas (#session.Enombre#). No puede realizar movimientos a ella misma.</cf_translate></td>
						</tr>
						<tr><td align="center" valign="middle"><input type="button" name="Regresar" value="#Regresar#" class="btnAnterior" onclick="javascript:location.href='/cfmx/rh/expediente/MenuExpNom.cfm'"></td></tr>
						<tr><td>&nbsp;</td></tr>
					</table>
					<br />
					</cfoutput>
				</cfif>
			<cfelse>	
				<cfoutput>
				<br />
				<table width="50%" border="0" align="center" cellpadding="2" class="areaFiltro">
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td align="center"><cf_translate key="Error_Empresa_Origen_No_Definida">No ha sido definida la empresa origen para realizar movimientos de incidencias entre empresas.</cf_translate></td>
					</tr>
					<tr><td align="center" valign="middle">			<input type="button" name="Regresar" value="#Regresar#" class="btnAnterior" onclick="javascript:location.href='/cfmx/rh/expediente/MenuExpNom.cfm'"></td></tr>
					<tr><td>&nbsp;</td></tr>
				</table>
				<br />
				</cfoutput>
			</cfif>
		<cfelse>
			<cfoutput>
			<br />
			<table width="50%" border="0" align="center" cellpadding="2" class="areaFiltro">
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td align="center"><cf_translate key="Error_Empresa_No_Permite_Movimientos">La empresa con la que esta trabajando (#session.Enombre#) no permite realizar movimientos de incidencias.</cf_translate></td>
				</tr>
				<tr><td align="center" valign="middle">			<input type="button" name="Regresar" value="#Regresar#" class="btnAnterior" onclick="javascript:location.href='/cfmx/rh/expediente/MenuExpNom.cfm'"></td></tr>
				<tr><td>&nbsp;</td></tr>
			</table>
			<br />
			</cfoutput>
		</cfif>
		<iframe id="framevalidar" name="framevalidar" marginheight="0" marginwidth="0" frameborder="1" height="0" width="0" scrolling="no" style="display:none"  ></iframe>

	<cf_web_portlet_end>
<cf_templatefooter>