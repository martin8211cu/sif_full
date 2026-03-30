<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Identificacion" Default="Identificaci&oacute;n" returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nombre" Default="Nombre" returnvariable="LB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DCdescripcion" Default="Descripción" returnvariable="LB_DCdescripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DCcodigo" Default="Codigo Carga" returnvariable="LB_DCcodigo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MontoEmpleado" Default="Monto Empleado" returnvariable="LB_MontoEmpleado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MontoPatrono" Default="Monto Patrono" returnvariable="LB_MontoPatrono"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Carga" Default="Tipo de Carga" returnvariable="LB_Carga"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PeriodoNom" Default="Periodo de N&oacute;mina" returnvariable="LB_PeriodoNom"/>


<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_GenerarArchivoDeTexto" Default="Generar archivo de texto" returnvariable="BTN_GenerarArchivoDeTexto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NoSeEncontraronRegistros" Default="No se encontraron registros" returnvariable="LB_NoSeEncontraronRegistros"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CargaTipo" Default="Deducci&oacute;n tipo" returnvariable="LB_CargaTipo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Mes" 		Default="Grupo Oficinas" 		returnvariable="LB_Oficina"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_del" Default="Del" returnvariable="LB_del"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_al" Default="al" returnvariable="LB_al"/>
 


<cfquery name="TotalCargasEmp" dbtype="query">
	select sum(MontoEmp) as total
	from rsCargas
</cfquery>
<cfquery name="TotalCargasPat" dbtype="query">
	select sum(MontoPat) as total
	from rsCargas
</cfquery>

<cfquery name="rsTipoCarga" datasource="#Session.DSN#">
	select DClinea, DCcodigo, DCdescripcion 
	from DCargas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		<cfif isdefined("form.DClinealist") and len(trim(form.DClinealist))>
            and DClinea  in (#form.DClinealist#)
        </cfif>
</cfquery>
	
<cfset vs_params = ''>
<cfif isdefined("form.Periodo") and len(trim(form.Periodo))>
	<cfset vs_params = vs_params & '&Periodo=#form.Periodo#'>
</cfif>
<cfif isdefined("form.Mes") and len(trim(form.Mes))>
	<cfset vs_params = vs_params & '&Mes=#form.Mes#'>
</cfif>
<cfif isdefined("form.DClinealist") and len(trim(form.DClinealist))>
	<cfset vs_params = vs_params & '&DClinealist=#form.DClinealist#'>
</cfif>	

<!---- pinta la info de oficinas--->
 <cfswitch expression="#arrayOfi[1]#"> 
	<cfcase value="of">
	   <cfset Oficina = 'Oficina #rsOficina.Oficodigo#-#rsOficina.Odescripcion#'>
	</cfcase>
	<cfcase value="go">
	<cfquery name = "rsgo" datasource="#session.dsn#">
	select GOcodigo, GOnombre

						from AnexoGOficina ct 
						where ct.Ecodigo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
							and ct.GOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arrayOfi[2]#">
	</cfquery>
							
	   <cfset Oficina = 'Grupo de Oficinas:#rsgo.GOnombre#'>
	</cfcase>
	<cfdefaultcase>
		<cfset Oficina = 'Todas las Oficinas'>
	</cfdefaultcase>
 </cfswitch>

<cfset LvarFileName = "CargasAplicadas#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
	<cfoutput>
	<tr>
		<td align="center">
		<cf_htmlReportsHeaders 
			title= "#LB_ReporteDeCargasNominasAplicadas#"
			filename="#LvarFileName#"
			irA="repCargasNominasAplicadas-filtro.cfm">

			<table width="98%" cellpadding="1" cellspacing="0" align="center" border="0">
				<tr>	
					<cfif isdefined("form.Id_Oficina") and len(trim(form.Id_Oficina))>					
	                    <cfset Filtro4="#LB_Oficina# : #form.Id_Oficina#">
	                <cfelse>
	                    <cfset Filtro4="">
	                </cfif>
					<cfsavecontent variable="ENCABEZADO_IMP">
					<td align="center" colspan="6"><strong><font size="2">
					<cf_EncReporte
						Titulo="#LB_ReporteDeCargasNominasAplicadas#"
						filtro2="#LB_del# #LSDateFormat(fdesde, "dd/mm/yyyy")# #LB_al# #LSDateFormat(fhasta, "dd/mm/yyyy")#"
						filtro3="#Oficina#"
	                    filtro4="#Filtro4#">
					</cfsavecontent>
					#ENCABEZADO_IMP#
				</tr>
				</cfoutput>
				<cfif (isdefined("form.Periodo") and len(trim(form.Periodo)) and isdefined("form.Mes") and len(trim(form.Mes)))
						or (isdefined("form.FechaDesde") and len(trim(form.FechaDesde)) and isdefined("form.FechaHasta") and len(trim(form.FechaHasta)))> 
					<cfif rsCargas.RecordCount NEQ 0>
						<cfset actualEmp = ''>
						<cfset actualCFEmp = ''>
						<cfset subtotalEmp = 0>
						<cfset subtotalcfEmp = 0>
						
						<cfset actualPat = ''>
						<cfset actualCFPat = ''>
						<cfset subtotalPat = 0>
						<cfset subtotalcfPat = 0>
						
						<cfif isDefined('form.ChkEmp')> 
							<cfset LvarGrupo = 'DEid'>
						<cfelse>
							<cfset LvarGrupo = 'DCdescripcion'>
						</cfif>

						<cfif isDefined('form.CFid')>
							<cfset LvarCF = ''>
						</cfif>
							

						<cfoutput  query="rsCargas" group="#LvarGrupo#">
							<cfset subtotalEmp = 0.00> 
		                    <cfset subtotalPat = 0.00> 

		                    <cfif isDefined('form.CFid') and LvarCF NEQ CFcodigo>
		                    	<cfset LvarCF = CFcodigo>
		                    	<tr>
									<td colspan="6" align="LEFT">
										<b><u><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:
											#CFcodigo# #CFdescripcion#</u></b>
									</td>
								</tr>
		                    </cfif>

							<cfif isdefined("form.ChkEmp")>
								<tr class="tituloListas">
		                            <td><b>#LB_Identificacion#</b></td>
		                            <td><b>#LB_Nombre#</b></td>
		                        </tr>
		                        <tr <cfif rsCargas.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
		                        <td><font  style="font-size:14px; font-family:'Arial'">#rsCargas.DEidentificacion#</font></td>
		                        <td><font  style="font-size:14px; font-family:'Arial'">#rsCargas.Nombre#</font></td>
		                        </tr>
		                        <tr class="tituloListas">
		                            <td><b>#LB_Carga#</b></td>
		                            <td align="center"><b>#LB_PeriodoNom#</b></td>
		                            <td align="right"><b>#LB_MontoEmpleado#</b></td>
									<td align="right"><b>#LB_MontoPatrono#</b></td>
		                        </tr>
		                    <cfelse>
		                        <tr class="tituloListas">
		                            <td><b>#LB_DCcodigo#</b></td>
		                            <td><b>#LB_DCdescripcion#</b></td>
		                        </tr>
		                        <tr <cfif rsCargas.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
		                        <td><font  style="font-size:14px; font-family:'Arial'">#rsCargas.DCcodigo#</font></td>
		                        <td><font  style="font-size:14px; font-family:'Arial'">#rsCargas.DCdescripcion#</font></td>
		                        </tr>
								
		                        <tr class="tituloListas">
		                            <td><b>#LB_Nombre#</b></td>
		                            <td align="center"><b>#LB_PeriodoNom#</b></td>
		                            <td align="right"><b>#LB_MontoEmpleado#</b></td>
									<td><b>#LB_MontoPatrono#</b></td>
		                        </tr>
		                    </cfif>
		                    <cfoutput> <!--- Detalle ---> 
								<tr>
		                        	<cfif isdefined("form.ChkEmp")>
		                            	<td><font  style="font-size:11px; font-family:'Arial'">#rsCargas.DCdescripcion#	</font></td>
		                            <cfelse>
		                                <td><font  style="font-size:11px; font-family:'Arial'">#rsCargas.DEidentificacion# - #rsCargas.Nombre#</font></td>
		                             </cfif>
									<td align="center">
										<font  style="font-size:11px; font-family:'Arial'">
											<cfif isDefined('form.DetallarNominas')>
												<cf_locale name="date" value="#rsCargas.RCdesde#"/> - <cf_locale name="date" value="#rsCargas.RChasta#"/>
											<cfelse >
												#form.Mes# - #form.Periodo#
											</cfif>
											</font></td>
		                            <td align="right"><font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsCargas.MontoEmp,'999,999,999.99')#</td>
									<td align="right"><font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsCargas.MontoPat,'999,999,999.99')#</td></font>
		                        </tr>
		                        <cfset subtotalEmp = subtotalEmp + rsCargas.MontoEmp> 
		                        <cfset subtotalPat = subtotalPat + rsCargas.MontoPat> 
		                    </cfoutput>

		                    <tr><td colspan="6"><hr></td></tr>
		                    <tr>
		                        <td colspan="2" align="right"><b><cf_translate key="LB_SubTotal">SubTotal</cf_translate>:</b>&nbsp;</td>
		                        <td align="right">#LSNumberFormat(subtotalEmp,'999,999,999.99')#</font></td>
								<td align="right">#LSNumberFormat(subtotalPat,'999,999,999.99')#</font></td>
		                    </tr>
						</cfoutput>

						<cfoutput>
		                    <tr><td colspan="6"><br /><br /><br /><hr></td></tr>
		                    <tr>
								<td colspan="2" align="right"><b><cf_translate key="LB_Total">Total</cf_translate>:</b>&nbsp;</td>
								<td align="right">#LSNumberFormat(TotalCargasEmp.total,'999,999,999.99')#</font></td>
								<td align="right">#LSNumberFormat(TotalCargasPat.total,'999,999,999.99')#</font></td>
							</tr>
							<tr><td colspan="4" align="center" class="letra">--- <cf_translate key="MGS_FinDelReporte" xmlfile="/rh/generales.xml">Fin del Reporte</cf_translate> ---</td></tr>
						</cfoutput>
					<cfelse>
						<cfoutput><tr><td colspan="4" align="center"><b>----- #LB_NoSeEncontraronRegistros# -----</b></td></tr></cfoutput>
					</cfif>
				</cfif>
			</table>			
		</td>
	</tr>
</table>
