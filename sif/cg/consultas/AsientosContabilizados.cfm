<!--- 
	Mdulo    : Contabilidad General
	Nombre    : Reporte de Asientos Aplicados y Pendientes
	Hecho por : Randall Colomer en SOIN
	Creado    : 21/07/2006
 --->
 
<!--- Consultas --->
<!--- Consulta para obtener los Conceptos --->
<cfquery name="rsConceptos" datasource="#Session.DSN#">
	select a.Cconcepto, Cdescripcion as Cdescripcion
	from ConceptoContableE a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and not exists (select 1 
						from UsuarioConceptoContableE b 
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and a.Cconcepto = b.Cconcepto
							and a.Ecodigo = b.Ecodigo)
	UNION
	select a.Cconcepto, Cdescripcion as Cdescripcion
	from ConceptoContableE a,UsuarioConceptoContableE b
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.Cconcepto = b.Cconcepto
		and a.Ecodigo = b.Ecodigo
		and b.Usucodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">
	
	order by 1
</cfquery>

<!--- Consulta para obtener el Periodo --->
<cfquery name="rsPeriodo" datasource="#Session.DSN#">
	select distinct Speriodo as Eperiodo
	from CGPeriodosProcesados
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Speriodo desc
</cfquery>

<!--- Consulta para obtener el Mes --->
<cfquery name="rsMes" datasource="sifControl">
	select <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, b.VSdesc 
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
		and a.Iid = b.Iid
		and b.VSgrupo = 1
	order by <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl">
</cfquery>

<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo" default="Asientos Contables Pendientes/Aplicados" 
returnvariable="LB_Titulo" xmlfile="AsientosContabilizados.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ConceptoIni" default="Concepto Inicial" 
returnvariable="LB_ConceptoIni" xmlfile="AsientosContabilizados.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ConceptoFin" default="Concepto Final" 
returnvariable="LB_ConceptoFin" xmlfile="AsientosContabilizados.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PolizaIni" default="P&oacute;liza Inicial" 
returnvariable="LB_PolizaIni" xmlfile="AsientosContabilizados.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PolizaFin" default="P&oacute;liza Final" 
returnvariable="LB_PolizaFin" xmlfile="AsientosContabilizados.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PeriodoIni" default="Per&iacute;odo Inicial" 
returnvariable="LB_PeriodoIni" xmlfile="AsientosContabilizados.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PeriodoFin" default="Per&iacute;odo Final" 
returnvariable="LB_PeriodoFin" xmlfile="AsientosContabilizados.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MesIni" default="Mes Inicial" 
returnvariable="LB_MesIni" xmlfile="AsientosContabilizados.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MesFin" default="Mes Final" 
returnvariable="LB_MesFin" xmlfile="AsientosContabilizados.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FechaGIni" default="Fecha Generaci&oacute;n Inicial" 
returnvariable="LB_FechaGIni" xmlfile="AsientosContabilizados.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FechaGFin" default="Fecha Generaci&oacute;n Final" 
returnvariable="LB_FechaGFin" xmlfile="AsientosContabilizados.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FechaAIni" default="Fecha Aplicaci&oacute;n Inicial" 
returnvariable="LB_FechaAIni" xmlfile="AsientosContabilizados.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FechaAFin" default="Fecha Aplicaci&oacute;n Final" 
returnvariable="LB_FechaAFin" xmlfile="AsientosContabilizados.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TipoRpte" default="Tipo de Reporte" 
returnvariable="LB_TipoRpte" xmlfile="AsientosContabilizados.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Aplicado" default="Aplicados" 
returnvariable="LB_Aplicado" xmlfile="AsientosContabilizados.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PendienteDeAplicar" default="Pendiente de Aplicar" 
returnvariable="LB_PendienteDeAplicar" xmlfile="AsientosContabilizados.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_VerReporte" default="Ver Reporte" 
returnvariable="LB_VerReporte" xmlfile="AsientosContabilizados.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Resumido" default="Resumido" 
returnvariable="LB_Resumido" xmlfile="AsientosContabilizados.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Detallado" default="Detallaado" 
returnvariable="LB_Detallado" xmlfile="AsientosContabilizados.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="CHK_ExportarExcel" default="Exportar a Excel" 
returnvariable="CHK_ExportarExcel" xmlfile="AsientosContabilizados.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Limpiar" default="Limpiar" returnvariable="BTN_Limpiar" 
xmlfile="AsientosContabilizados.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Consultar" default="Consultar" returnvariable="BTN_Consultar" 
xmlfile="AsientosContabilizados.xml"/>
<cfinvoke key="LB_Todos" 		default="Todos"			returnvariable="LB_Todos"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>


	<cf_templateheader title="#LB_Titulo#"> 
		<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
		<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
		<cfinclude template="Funciones.cfm">
		
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
			<cfinclude template="../../portlets/pNavegacion.cfm">
						
			<form action="AsientosContabilizados-sql.cfm" method="post" name="formfiltro" style="margin:0;" >
				<cfoutput>
				<table width="100%"  border="0" cellspacing="1" cellpadding="1" class="AreaFiltro" style="margin:0;">
					<tr>
						<td nowrap><strong>&nbsp;</strong></td> 
						<td nowrap><strong>#LB_ConceptoIni#</strong></td>
						<td nowrap><strong>#LB_PolizaIni#</strong></td>
						<td nowrap><strong>#LB_PeriodoIni#</strong></td>
						<td nowrap><strong>#LB_MesIni#</strong></td>
					</tr>
					
					<tr> 
						<td nowrap>&nbsp;</td>
						<td nowrap> 
							<select name="conceptoini">
								<option value="">#LB_Todos#</option>
								<cfloop query="rsConceptos"> 
									<option value="#Cconcepto#"<cfif isdefined("form.conceptoini") and form.conceptoini eq Cconcepto>selected</cfif>>#Cdescripcion#</option>
								</cfloop> 
							</select>
						</td> 
						<td nowrap>
							<input tabindex="1" type="text" name="EdocumentoI" value="<cfif isdefined("form.EdocumentoI") >#form.EdocumentoI#</cfif>"  size="10" maxlength="10" style="text-align: right;" onblur="javascript:fm(this);"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event)){ if(Key(event)=='13') {this.blur();}}" >
						</td>
						<td nowrap>
							<select name="periodoini">
								<cfloop query="rsPeriodo">
									<option value="#Eperiodo#" <cfif isdefined("form.periodoini") and form.periodoini eq Eperiodo>selected</cfif>>#Eperiodo#</option>
								</cfloop>
							</select>
                        </td>
						<td nowrap>
						<select name="mesini">
							<cfloop query="rsMes">
								<option value="#VSvalor#"<cfif  isdefined("form.mesini") and  form.mesini eq VSvalor>selected</cfif>>#VSdesc#</option>
							</cfloop>
						</select>
                        </td>
					</tr>
					
					<tr>
						<td nowrap><strong>&nbsp;</strong></td> 
						<td nowrap><strong>#LB_ConceptoFin#</strong></td>
						<td nowrap><strong>#LB_PolizaFin#</strong></td>
						<td nowrap><strong>#LB_PeriodoFin#</strong></td>
						<td nowrap><strong>#LB_MesFin#</strong></td>
					</tr>
					
					<tr>
						<td nowrap>&nbsp;</td>
					  	<td nowrap>
							<select name="conceptofin">
								<option value="">#LB_Todos#</option>
								<cfloop query="rsConceptos">
									<option value="#Cconcepto#"<cfif isdefined("form.conceptofin") and  form.conceptofin eq Cconcepto>selected</cfif>>#Cdescripcion#</option>
								</cfloop>
							</select>
                      	</td>
						<td nowrap>
							<input tabindex="1" type="text" name="EdocumentoF" value="<cfif isdefined("form.EdocumentoF")>#form.EdocumentoF#</cfif>"  size="10" maxlength="10" style="text-align: right;" onblur="javascript:fm(this);"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event)){ if(Key(event)=='13') {this.blur();}}" >
						</td>
						<td nowrap>
							<select name="periodofin">
								<cfloop query="rsPeriodo">
									<option value="#Eperiodo#" <cfif isdefined("form.periodofin") and  form.periodofin eq Eperiodo>selected</cfif>>#Eperiodo#</option>
								</cfloop>
                        	</select>
                      	</td>
					  	<td nowrap>
							<select name="mesfin">
								<cfloop query="rsMes">
									<option value="#VSvalor#"<cfif isdefined("form.mesfin") and  form.mesfin  eq VSvalor>selected</cfif>>#VSdesc#</option>
								</cfloop>
							</select>
                      	</td>
					</tr>
					
					<tr>
						<td nowrap><strong>&nbsp;</strong></td> 
						<td nowrap><strong>#LB_FechaGIni#</strong></td>
						<td nowrap><strong>#LB_FechaGFin#</strong></td>
						<td nowrap><strong>#LB_TipoRpte#</strong></td>
						<td nowrap><strong>#LB_VerReporte#</strong></td>
					</tr>
					
					<tr>
						<td nowrap>&nbsp;</td>
						<td nowrap>
							<cfparam name="form.fechaGeneIni" default="">
							<cf_sifcalendario name="fechaGeneIni" value="#LSDateFormat(form.fechaGeneIni,'dd/mm/yyyy')#" form="formfiltro">
						</td>
						<td nowrap>
							<cfparam name="form.fechaGeneFin" default="">
							<cf_sifcalendario name="fechaGeneFin" value="#LSDateFormat(form.fechaGeneFin,'dd/mm/yyyy')#" form="formfiltro">
						</td>
						<td nowrap>
							<select name="tipoReporte">
								<option value="1" <cfif isdefined("form.tipoReporte") and form.tipoReporte eq 1>selected</cfif>>#LB_Aplicado#</option>
								<option value="2" <cfif isdefined("form.tipoReporte") and form.tipoReporte eq 2>selected</cfif>>#LB_PendienteDeAplicar#</option>
							</select>
						</td>
						<td nowrap>
							<select name="verReporte">
							   <option value="1" <cfif isdefined("form.verReporte") and form.verReporte eq 1>selected</cfif>>#LB_Resumido#</option>
							  <option value="2" <cfif isdefined("form.verReporte") and form.verReporte eq 2>selected</cfif>>#LB_Detallado#</option>
							</select>
						</td>
					</tr>
					
					<tr>
						<td nowrap><strong>&nbsp;</strong></td> 
						<td nowrap><strong>#LB_FechaAIni#</strong></td>
						<td nowrap><strong>#LB_FechaAFin#</strong></td>
						<td nowrap><strong>&nbsp;</strong></td>
						<td nowrap><strong>&nbsp;</strong></td>
					</tr>

					<tr>
						<td nowrap>&nbsp;</td>
						<td nowrap>
							<cfparam name="form.fechaApliIni" default="">
							<cf_sifcalendario name="fechaApliIni" value="#LSDateFormat(form.fechaApliIni,'dd/mm/yyyy')#" form="formfiltro">
						</td>
						<td nowrap>
							<cfparam name="form.fechaApliFin" default="">
							<cf_sifcalendario name="fechaApliFin" value="#LSDateFormat(form.fechaApliFin,'dd/mm/yyyy')#" form="formfiltro">
						</td>
						<td nowrap>
							<input type="checkbox" name="toExcel">&nbsp;<strong>#CHK_ExportarExcel#</strong>
						</td>
						<td nowrap>&nbsp;</td>
					</tr>
					
					<tr>
						<td nowrap colspan="5" align="center">&nbsp;</td>
					</tr>	
					
					<tr>
						<td nowrap colspan="5" align="center">
							<input type="reset" name="bLimpiar" value="#BTN_Limpiar#">
							<input type="submit" name="bGenerar" value="#BTN_Consultar#" >
						</td>
					</tr>
					
				</table>
				</cfoutput>
			</form>
 		<cf_web_portlet_end>
	<cf_templatefooter> 

