<!--- 
	Mdulo    : Contabilidad General
	Nombre    : Reporte de Asientos Por Interfaz
	Hecho por : Randall Colomer en SOIN
	Creado    : 24/07/2006
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




	<cf_templateheader title="Asientos Por Interfaz"> 
		<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
		<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
		<cfinclude template="Funciones.cfm">
		
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Asientos Por Interfaz'>
			<cfinclude template="../../portlets/pNavegacion.cfm">
						
			<form action="AsientosPorInterfaz-sql.cfm" method="post" name="formfiltro" style="margin:0;" >
				<cfoutput>
				<table width="100%"  border="0" cellspacing="1" cellpadding="1" class="AreaFiltro" style="margin:0;">
					<!--- Lnea No. 1 --->
					<tr>
						<td nowrap><strong>&nbsp;</strong></td> 
						<td nowrap><strong>Concepto Inicial</strong></td>
						<td nowrap><strong>Per&iacute;odo</strong></td>
						<td nowrap><strong>Fecha Inicial</strong></td>
						<td nowrap><strong>&nbsp;</strong></td>
						<td nowrap><strong>&nbsp;</strong></td>
					</tr>
					<!--- Lnea No. 2 --->
					<tr> 
						<td nowrap>&nbsp;</td>
						<td nowrap> 
							<select name="conceptoini">
								<option value="">Todos</option>
								<cfloop query="rsConceptos"> 
									<option value="#Cconcepto#"<cfif isdefined("form.conceptoini") and form.conceptoini eq Cconcepto>selected</cfif>>#Cdescripcion#</option>
								</cfloop> 
							</select>
						</td> 
						<td nowrap>
							<select name="periodo">
								<cfloop query="rsPeriodo">
									<option value="#Eperiodo#" <cfif isdefined("form.periodo") and form.periodo eq Eperiodo>selected</cfif>>#Eperiodo#</option>
								</cfloop>
							</select>
                        </td>
						<td nowrap>
							<cfparam name="form.fechaIni" default="">
							<cf_sifcalendario name="fechaIni" value="#LSDateFormat(form.fechaIni,'dd/mm/yyyy')#" form="formfiltro">
						</td>
						<td nowrap>&nbsp;</td>
						<td nowrap>&nbsp;</td>
					</tr>
					<!--- Lnea No. 3 --->
					<tr>
						<td nowrap><strong>&nbsp;</strong></td> 
						<td nowrap><strong>Concepto Final</strong></td>
						<td nowrap><strong>Mes</strong></td>
						<td nowrap><strong>Fecha Final</strong></td>
						<td nowrap><strong>&nbsp;</strong></td>
						<td nowrap align="center"><input type="submit" name="bGenerar" value="Consultar" ></td>
					</tr>
					<!--- Lnea No. 4 --->
					<tr>
						<td nowrap>&nbsp;</td>
						<td nowrap>
							<select name="conceptofin">
								<option value="">Todos</option>
								<cfloop query="rsConceptos">
									<option value="#Cconcepto#"<cfif isdefined("form.conceptofin") and  form.conceptofin eq Cconcepto>selected</cfif>>#Cdescripcion#</option>
								</cfloop>
							</select>
                      	</td>
						<td nowrap>
							<select name="mes">
								<cfloop query="rsMes">
									<option value="#VSvalor#"<cfif  isdefined("form.mes") and  form.mes eq VSvalor>selected</cfif>>#VSdesc#</option>
								</cfloop>
							</select>
                        </td>
						<td nowrap>
							<cfparam name="form.fechaFin" default="">
							<cf_sifcalendario name="fechaFin" value="#LSDateFormat(form.fechaFin,'dd/mm/yyyy')#" form="formfiltro">
						</td>
						<td nowrap>
							<input type="checkbox" name="toExcel">&nbsp;<strong>Exportar a Excel</strong>
						</td>
						<td nowrap>&nbsp;</td>
					</tr>
					<!--- Lnea No. 5 --->
					<tr>
						<td nowrap colspan="6" align="center">&nbsp;</td>
					</tr>
					
				</table>
				</cfoutput>
			</form>
 		<cf_web_portlet_end>
	<cf_templatefooter> 


