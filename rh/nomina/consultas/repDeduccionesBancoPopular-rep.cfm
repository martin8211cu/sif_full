<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Identificacion" Default="Identificaci&oacute;n" returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nombre" Default="Nombre" returnvariable="LB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Monto" Default="Monto" returnvariable="LB_Monto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_GenerarArchivoDeTexto" Default="Generar archivo de texto" returnvariable="BTN_GenerarArchivoDeTexto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NoSeEncontraronRegistros" Default="No se encontraron registros" returnvariable="LB_NoSeEncontraronRegistros"/>
<cfoutput>
	<cfquery name="TotalDeducciones" dbtype="query">
		select sum(MontoB) as total
		from rsDeducciones
	</cfquery>
	<cfset vs_params = ''>
	<cfif isdefined("form.Periodo") and len(trim(form.Periodo))>
		<cfset vs_params = vs_params & '&Periodo=#form.Periodo#'>
	</cfif>
	<cfif isdefined("form.Mes") and len(trim(form.Mes))>
		<cfset vs_params = vs_params & '&Mes=#form.Mes#'>
	</cfif>
	<cfif isdefined("form.TDidlist") and len(trim(form.TDidlist))>
		<cfset vs_params = vs_params & '&TDidlist=#form.TDidlist#'>
	</cfif>
	<cfif isdefined("form.TipoNomina") and len(trim(form.TipoNomina))>
		<cfset vs_params = vs_params & '&TipoNomina=#form.TipoNomina#'>
	</cfif>
	<cfset vn_cpid = ''>
	<cfif isdefined("form.CPid1") and len(trim(form.CPid1))>
		<cfset vs_params = vs_params & '&CPid1=#form.CPid1#'>
		<cfset vn_cpid = form.CPid1>
	<cfelseif isdefined("form.CPid2") and len(trim(form.CPid2))>	
		<cfset vs_params = vs_params & '&CPid2=#form.CPid2#'>
		<cfset vn_cpid = form.CPid2>
	</cfif>	
	<cfif isdefined("vn_cpid") and len(trim(vn_cpid))>
		<cfquery name="rsCalendario" datasource="#session.DSN#">
			select a.CPdesde, a.CPhasta, b.RCDescripcion
			from CalendarioPagos a
				inner join #vs_tablaCalculo# b
					on a.CPid = b.RCNid					
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
				and a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vn_cpid#">
		</cfquery>
	</cfif>

	<cfset LvarFileName = "DeduccionesBPopular#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
	<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
		<cfif isdefined("rsDeducciones") and rsDeducciones.RecordCount NEQ 0>
			<tr>
				<td align="center">
					<input type="button" name="btnGenerar" value="#BTN_GenerarArchivoDeTexto#" class="btnAplicar" onClick="javascript: funcGenerar();">
				</td>
			</tr>
		</cfif>
		<tr>
			<td align="center">
				<cf_htmlReportsHeaders 
				title="#LB_ReporteDeDeduccionesDelBancoPopular#" 
				filename="#LvarFileName#"
				irA="repDeduccionesBancoPopular-filtro.cfm">
				<table width="98%" cellpadding="1" cellspacing="0" align="center" border="0">
					<cfif isdefined("form.Periodo") and len(trim(form.Periodo)) and isdefined("form.Mes") and len(trim(form.Mes))>
						<tr>
							<td colspan="3">
								<table border="0">
									<tr>
										<td align="right"><b><cf_translate key="LB_Periodo">Periodo</cf_translate>:</b>&nbsp;</td>
										<td>#form.Periodo#&nbsp;&nbsp;</td>
										<td align="right"><b><cf_translate key="LB_Mes">Mes</cf_translate>:&nbsp;</b></td>
										<td>
											<cfif len(trim(form.Mes)) LT 2>
												0
											</cfif>
											#form.Mes#
											<!----#IIf(len(trim(form.Mes)) LT 2,'0','') & form.Mes#----->
										</td>
									</tr>
								</table>
							</td>
						</tr>
					<cfelseif isdefined("rsCalendario") and rsCalendario.RecordCount NEQ 0>
						<tr>
							<td colspan="3">
								<table>
									<tr>
										<td><b><cf_translate key="LB_Nomina">N&oacute;mina</cf_translate>:&nbsp;</b></td>
										<td>
											#trim(rsCalendario.RCDescripcion)# (#LSDateFormat(rsCalendario.CPdesde,'dd/mm/yyyy')# - #LSDateFormat(rsCalendario.CPhasta,'dd/mm/yyyy')#)
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</cfif>
					<tr class="tituloListas">
						<td><b>#LB_Identificacion#</b></td>
						<td><b>#LB_Nombre#</b></td>
						<td align="right"><b>#LB_Monto#</b></td>
					</tr>								
					<cfif rsDeducciones.RecordCount NEQ 0>
						<cfloop query="rsDeducciones">
							<tr <cfif rsDeducciones.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
								<td>#rsDeducciones.DEidentificacion#</td>
								<td>#rsDeducciones.Nombre#</td>
								<td align="right">#LSNumberFormat(rsDeducciones.MontoB,'999,999,999.99')#</td>
							</tr>
						</cfloop>
						<tr>
							<td colspan="2" align="right"><b><cf_translate key="LB_Total">Total</cf_translate>:</b>&nbsp;</td>
							<td align="right" style="border-top:1px solid black;">#LSNumberFormat(TotalDeducciones.total,'999,999,999.99')#</td>
						</tr>
					<cfelse>
						<tr><td colspan="3" align="center"><b>----- #LB_NoSeEncontraronRegistros# -----</b></td></tr>
					</cfif>
				</table>			
			</td>
		</tr>
	</table>	
	<script type="text/javascript">
		function funcGenerar(){
			location.href = 'repDeduccionesBancoPopular-form.cfm?Generar=1#vs_params#';
		}
	</script>
</cfoutput>

