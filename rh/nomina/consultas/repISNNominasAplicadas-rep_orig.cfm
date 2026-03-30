<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteImpuestoEstatalSobreNomina" Default="Reporte Impuesto Estatal Sobre N&oacute;mina" returnvariable="LB_ReporteImpuestoEstatalSobreNomina"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TipoNomina" Default="N&oacute;mina:" returnvariable="LB_TipoNomina"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_del" Default="Del" returnvariable="LB_del"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_al" Default="al" returnvariable="LB_al"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Mes" Default="Mes:" returnvariable="LB_Mes"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Periodo" Default="Peri&oacute;do:" returnvariable="LB_Periodo"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Trabajador" Default="Trabajador" returnvariable="LB_Trabajador"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_AcumuladoSueldo" Default="Acumulado Sueldos" returnvariable="LB_AcumuladoSueldo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ParteVariableGravable" Default="Parte Variable Gravable" returnvariable="LB_ParteVariableGravable"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MontoISN" Default="Monto ISN" returnvariable="LB_MontoISN"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_GenerarArchivoDeTexto" Default="Generar archivo de texto" returnvariable="BTN_GenerarArchivoDeTexto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NoSeEncontraronRegistros" Default="No se encontraron registros" returnvariable="LB_NoSeEncontraronRegistros"/>

<cfoutput>
    <cfquery name="rsTnomina" datasource="#session.DSN#">
		select Tcodigo, Tdescripcion
        from TiposNomina
        where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
       		and Tcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Tcodigo#">
	</cfquery>
	<!--- Si aplica Calculo especial --->
	<cfif isDefined('TCalculoEspecial')>
		<cfquery name="rsDatosT" datasource="#session.DSN#">
			select sum(MontoSalario) as TMontoSalario,  sum(MontoVariable) as TMontoVariable, sum(MontoISN) as TMontoISN, sum(MontoISNE) as TMontoISNE
			from #RepISNE# a
				<cfif (codOf gt 0 OR (isDefined('codOfs') and codOfs neq '')) and FechaDesde eq "" and FechaHasta eq "">
					<cfif codOf gt 0 >
					where (
							select top 1 lt.Ocodigo from LineaTiempo lt
							where lt.DEid = a.DEid and
							DATEPART(YYYY, lt.LThasta) >= #periodo# and (DATEPART(MM, lt.LThasta) >= #mes# or lt.LThasta = '6100-01-01 00:00:00.000')
							order by lt.LTdesde desc
						) = #codOf#
					</cfif>
					<cfif isDefined('codOfs') and  codOfs neq ''>
						where (
							select top 1 lt.Ocodigo from LineaTiempo lt
							where lt.DEid = a.DEid and
							DATEPART(YYYY, lt.LThasta) >= #periodo# and (DATEPART(MM, lt.LThasta) >= #mes# or lt.LThasta = '6100-01-01 00:00:00.000')
							order by lt.LTdesde desc
						) in (#codOfs#)
					</cfif>
				</cfif>
		</cfquery>

		<cfquery name="rsDatos" datasource="#session.DSN#">
			<cfif TAgrupacion eq 1>
			select a.DEid, sum(a.Dias) Dias, sum(MontoSalario) MontoSalario ,Sum(a.MontoVariable) MontoVariable,sum(a.MontoISN)MontoISN,sum(MontoISNE) MontoISNE, <cf_dbfunction name="concat" args="de.DEidentificacion,' ',de.DEapellido1,'  ',de.DEapellido2,' ',de.DEnombre" > as DEnombre
				from #RepISNE# a
				inner join DatosEmpleado de
				on de.DEid = a.DEid and de.Ecodigo = #session.Ecodigo#
				
				<cfif (codOf gt 0 OR (isDefined('codOfs') and codOfs neq '')) and FechaDesde eq "" and FechaHasta eq "">
					
					where 
					<cfif codOf gt 0 >
						(
							select top 1 lt.Ocodigo from LineaTiempo lt
							where lt.DEid = a.DEid and
							DATEPART(YYYY, lt.LThasta) >= #periodo# and (DATEPART(MM, lt.LThasta) >= #mes# or lt.LThasta = '6100-01-01 00:00:00.000')
							order by lt.LTdesde desc
					) = #codOf#
					</cfif>
					<cfif isDefined('codOfs') and  codOfs neq ''>
						(
							select top 1 lt.Ocodigo from LineaTiempo lt
							where lt.DEid = a.DEid and
							DATEPART(YYYY, lt.LThasta) >= #periodo# and (DATEPART(MM, lt.LThasta) >= #mes# or lt.LThasta = '6100-01-01 00:00:00.000')
							order by lt.LTdesde desc
					) in (#codOfs#)
					</cfif>
				</cfif>
				
				group by a.DEid,<cf_dbfunction name="concat" args="de.DEidentificacion,' ',de.DEapellido1,'  ',de.DEapellido2,' ',de.DEnombre" >
				order by DEnombre
				</cfif>
				<cfif TAgrupacion eq 2>
					select DEnombre,sum(MontoSalario) MontoSalario,sum(MontoVariable) MontoVariable,sum(MontoISN) MontoISN,sum(MontoISNE) MontoISNE from (
							select (select Odescripcion from Oficinas 
									where Ocodigo=a.Ocodigo and Ecodigo = #session.Ecodigo#) DEnombre,
					 sum(MontoSalario) MontoSalario ,Sum(a.MontoVariable) MontoVariable,sum(a.MontoISN) MontoISN,sum(MontoISNE) MontoISNE
				from #RepISNE# a
				inner join DatosEmpleado de
				on de.DEid = a.DEid and de.Ecodigo = #session.Ecodigo#
				<cfif (codOf gt 0 OR (isDefined('codOfs') and codOfs neq '')) and FechaDesde eq "" and FechaHasta eq "">
					where 
					<cfif codOf gt 0 >
						(
							select top 1 lt.Ocodigo from LineaTiempo lt
							where lt.DEid = a.DEid and
							DATEPART(YYYY, lt.LThasta) >= #periodo# and (DATEPART(MM, lt.LThasta) >= #mes# or lt.LThasta = '6100-01-01 00:00:00.000')
							order by lt.LTdesde desc
					) = #codOf#
					</cfif>
					<cfif isDefined('codOfs') and  codOfs neq ''>
						(
							select top 1 lt.Ocodigo from LineaTiempo lt
							where lt.DEid = a.DEid and
							DATEPART(YYYY, lt.LThasta) >= #periodo# and (DATEPART(MM, lt.LThasta) >= #mes# or lt.LThasta = '6100-01-01 00:00:00.000')
							order by lt.LTdesde desc
					) in (#codOfs#)
					</cfif>
				</cfif>
				group by a.DEid,a.Ocodigo ) as T1 group by DEnombre 
				</cfif>
		</cfquery>
	
			<cfset nomOficina= ''>
			<cfif Tconsulta eq 2>
			   <cfquery name="nomGrupoOf" datasource="#session.DSN#">
				   select GOnombre from AnexoGOficina 
				   where Ecodigo = #Session.Ecodigo# 
				   and GOcodigo=#codGrupoOf#
			   </cfquery>
			   <cfset nomOficina= #nomGrupoOf.GOnombre#>
		   <cfelse>
			   <cfquery name="nomOficina" datasource="#session.DSN#">
				   select o.Odescripcion from oficinas o 
				   where o.Ocodigo = #codOf#
			   </cfquery>
			   <cfset nomOficina= #nomOficina.Odescripcion#>
		   </cfif>
	   
		   <cfif #form.Tfiltro# EQ 2>
			   <cfset vfiltro2 = "#LB_del# #LsDateFormat(form.fechadesde,'dd/mm/yyyy')# #LB_al# #LsDateFormat(form.fechahasta,'dd/mm/yyyy')#">
		   <cfelse>
			   <cfset vfiltro2 ="#LB_Mes# #form.mes# #LB_Periodo# #form.periodo#">
		   </cfif>
		   
		   <cfsavecontent variable="ENCABEZADO_IMP">
			<tr>
			<td align="center" colspan="6">
			<cf_EncReporte
				Titulo="#LB_ReporteImpuestoEstatalSobreNomina#"
				filtro1="#LB_TipoNomina# #rsTnomina.Tdescripcion#"
				filtro2=#vfiltro2#
				filtro3=#nomOficina#
			>
			</td></tr>
			<tr class="tituloListas">
				<td><b>#LB_Trabajador#</b></td>
				<td align="right"><b>#LB_AcumuladoSueldo#</b></td>
				<td align="right"><b>#LB_ParteVariableGravable#</b></td>
				<td align="right"><b>#LB_ImpuestoPorcE#</b></td>
				<td align="right"><b>#LB_PorceISNE#</b></td>
			</tr>
			</cfsavecontent>
			<cfset LvarFileName = "ImpuestoSobreNomina-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
			<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
			<tr>
					<td align="center">
					<cf_htmlReportsHeaders
						title= "#LB_ReporteImpuestoEstatalSobreNomina#"
						filename="#LvarFileName#"
						irA="repISNNominasAplicadas-filtro.cfm">
		
						<table width="98%" cellpadding="1" cellspacing="0" align="center" border="0">
							<tr>
								#ENCABEZADO_IMP#
							</tr>
							<cfif (isdefined("form.Periodo") and len(trim(form.Periodo)) and isdefined("form.Mes") and len(trim(form.Mes)))
									or (isdefined("form.FechaDesde") and len(trim(form.FechaDesde)) and isdefined("form.FechaHasta") and len(trim(form.FechaHasta)))>
								<cfif rsDatos.RecordCount NEQ 0>
									<cfloop query="rsDatos">
										<tr <cfif rsDatos.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
											<td align="left"><font  style="font-size:11px; font-family:'Arial'">#rsDatos.DEnombre#</font></td>
											<td align="right"><font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsDatos.MontoSalario,'999,999,999.99')#</font></td>
											<td align="right"><font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsDatos.MontoVariable,'999,999,999.99')#</font></td>
											<td align="right"><font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsDatos.MontoISNE,'999,999,999.99')#</font></td>
											<td align="right"><font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsDatos.MontoISN,'999,999,999.99')#</font></td>
										</tr>
									</cfloop>
									<tr>
										<td colspan="1" align="right"><b><cf_translate key="LB_Total">Totales</cf_translate>:</b>&nbsp;</td>
										<td align="right" style="border-top:1px solid black;">#LSNumberFormat(rsDatosT.TMontoSalario,'999,999,999.99')#</font></td>
										<td align="right" style="border-top:1px solid black;">#LSNumberFormat(rsDatosT.TMontoVariable,'999,999,999.99')#</font></td>
										<td align="right" style="border-top:1px solid black;">#LSNumberFormat(rsDatosT.TMontoISNE,'999,999,999.99')#</font></td>
										<td align="right" style="border-top:1px solid black;">#LSNumberFormat(rsDatosT.TMontoISN,'999,999,999.99')#</font></td>
									</tr>
									<tr><td colspan="5" align="center" class="letra">--- <cf_translate key="MGS_FinDelReporte" xmlfile="/rh/generales.xml">Fin del Reporte</cf_translate> ---</td></tr>
								<cfelse>
									<tr><td colspan="5" align="center"><b>----- #LB_NoSeEncontraronRegistros# -----</b></td></tr>
								</cfif>
							</cfif>
						</table>
					</td>
				</tr>
			</table>
			<!--- Fin de Calculo Especial --->

	<cfelse>
		<cfquery name="rsDatosT" datasource="#session.DSN#">
			select sum(MontoSalario) as TMontoSalario,  sum(MontoVariable) as TMontoVariable, sum(MontoISN) as TMontoISN
			from #RepISN# a
			inner join DatosEmpleado de
				on de.DEid = a.DEid and de.Ecodigo = #session.Ecodigo#
			<!--- ************************* Mi c�digo MAFP ********************************* --->
				<cfif (codOf gt 0 OR (isDefined('codOfs') and codOfs neq '')) and FechaDesde eq "" and FechaHasta eq "">
					<!--- En esta consulta busco todos los regitros que existen en la linea del tiempo
					respecto al periodo que se esta consultando y lo limito al ultimo registro que se tiene
					en la linea del tiempo respecto a este periodo, para as� saber cual es la ultima oficina
					en la que est� el empleado --->
					<cfif codOf gt 0 >
					where (
							select top 1 lt.Ocodigo from LineaTiempo lt
							where lt.DEid = a.DEid and
							DATEPART(YYYY, lt.LThasta) >= #periodo# and (DATEPART(MM, lt.LThasta) >= #mes# or lt.LThasta = '6100-01-01 00:00:00.000')
							order by lt.LTdesde desc
						) = #codOf#
					</cfif>
					<cfif isDefined('codOfs') and  codOfs neq ''>
						where (
							select top 1 lt.Ocodigo from LineaTiempo lt
							where lt.DEid = a.DEid and
							DATEPART(YYYY, lt.LThasta) >= #periodo# and (DATEPART(MM, lt.LThasta) >= #mes# or lt.LThasta = '6100-01-01 00:00:00.000')
							order by lt.LTdesde desc
						) in (#codOfs#)
					</cfif>
				</cfif>
				<!--- ************************* Mi c�digo ********************************* --->
		</cfquery>
		
		<cfquery name="rsDatos" datasource="#session.DSN#">
			<cfif TAgrupacion eq 1>
				select a.DEid, sum(a.Dias) Dias, sum(MontoSalario) MontoSalario ,Sum(a.MontoVariable) MontoVariable,sum(a.MontoISN)MontoISN, <cf_dbfunction name="concat" args="de.DEidentificacion,' ',de.DEapellido1,'  ',de.DEapellido2,' ',de.DEnombre" > as DEnombre
				from #RepISN# a
				inner join DatosEmpleado de
				on de.DEid = a.DEid and de.Ecodigo = #session.Ecodigo#
				<!--- ************************* Mi c�digo ********************************* --->
				<cfif (codOf gt 0 OR (isDefined('codOfs') and codOfs neq '')) and FechaDesde eq "" and FechaHasta eq "">
					<!--- En esta consulta busco todos los regitros que existen en la linea del tiempo
					respecto al periodo que se esta consultando y lo limito al ultimo registro que se tiene
					en la linea del tiempo respecto a este periodo, para as� saber cual es la ultima oficina
					en la que est� el empleado --->
					where 
					<cfif codOf gt 0 >
						(
							select top 1 lt.Ocodigo from LineaTiempo lt
							where lt.DEid = a.DEid and
							DATEPART(YYYY, lt.LThasta) >= #periodo# and (DATEPART(MM, lt.LThasta) >= #mes# or lt.LThasta = '6100-01-01 00:00:00.000')
							order by lt.LTdesde desc
					) = #codOf#
					</cfif>
					<cfif isDefined('codOfs') and  codOfs neq ''>
						(
							select top 1 lt.Ocodigo from LineaTiempo lt
							where lt.DEid = a.DEid and
							DATEPART(YYYY, lt.LThasta) >= #periodo# and (DATEPART(MM, lt.LThasta) >= #mes# or lt.LThasta = '6100-01-01 00:00:00.000')
							order by lt.LTdesde desc
					) in (#codOfs#)
					</cfif>
				</cfif>
				<!--- ************************* Mi c�digo ********************************* --->
				group by a.DEid,<cf_dbfunction name="concat" args="de.DEidentificacion,' ',de.DEapellido1,'  ',de.DEapellido2,' ',de.DEnombre" >
				order by DEnombre
				</cfif>
				<cfif TAgrupacion eq 2>
					 select DEnombre,sum(MontoSalario) MontoSalario,sum(MontoVariable) MontoVariable,sum(MontoISN) MontoISN from ( 
							select (select Odescripcion from Oficinas 
									where Ocodigo=a.Ocodigo and Ecodigo = #session.Ecodigo#) DEnombre,
					 sum(MontoSalario) MontoSalario ,Sum(a.MontoVariable) MontoVariable,sum(a.MontoISN) MontoISN
				from #RepISN# a
				inner join DatosEmpleado de
				on de.DEid = a.DEid and de.Ecodigo = #session.Ecodigo#
				<cfif (codOf gt 0 OR (isDefined('codOfs') and codOfs neq '')) and FechaDesde eq "" and FechaHasta eq "">
					where 
					<cfif codOf gt 0 >
						(
							select top 1 lt.Ocodigo from LineaTiempo lt
							where lt.DEid = a.DEid and
							DATEPART(YYYY, lt.LThasta) >= #periodo# and (DATEPART(MM, lt.LThasta) >= #mes# or lt.LThasta = '6100-01-01 00:00:00.000')
							order by lt.LTdesde desc
					) = #codOf#
					</cfif>
					<cfif isDefined('codOfs') and  codOfs neq ''>
						(
							select top 1 lt.Ocodigo from LineaTiempo lt
							where lt.DEid = a.DEid and
							DATEPART(YYYY, lt.LThasta) >= #periodo# and (DATEPART(MM, lt.LThasta) >= #mes# or lt.LThasta = '6100-01-01 00:00:00.000')
							order by lt.LTdesde desc
					) in (#codOfs#)
					</cfif>
				</cfif>
				group by a.DEid,a.Ocodigo ) as T1 group by DEnombre
			</cfif>
		</cfquery>

		<cfset nomOficina= ''>
		 <cfif Tconsulta eq 2>
			<cfquery name="nomGrupoOf" datasource="#session.DSN#">
				select GOnombre from AnexoGOficina 
				where Ecodigo = #Session.Ecodigo# 
				and GOcodigo=#codGrupoOf#
			</cfquery>
			<cfset nomOficina= #nomGrupoOf.GOnombre#>
		<cfelse>
			<cfquery name="nomOficina" datasource="#session.DSN#">
				select o.Odescripcion from oficinas o 
				where o.Ocodigo = #codOf#
			</cfquery>
			<cfset nomOficina= #nomOficina.Odescripcion#>
		</cfif>
	
		<cfif #form.Tfiltro# EQ 2>
	
			<cfset vfiltro2 = "#LB_del# #LsDateFormat(form.fechadesde,'dd/mm/yyyy')# #LB_al# #LsDateFormat(form.fechahasta,'dd/mm/yyyy')#">
		<cfelse>
			<cfset vfiltro2 ="#LB_Mes# #form.mes# #LB_Periodo# #form.periodo#">
		</cfif>
	
	
	
	<!---
		<cfquery name="rsTipoDeduccion" datasource="#Session.DSN#">
			select TDid, TDcodigo, TDdescripcion
			from TDeduccion
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TDid#">
		</cfquery>
	
		<cfset vs_params = ''>
		<cfif isdefined("form.Periodo") and len(trim(form.Periodo))>
			<cfset vs_params = vs_params & '&Periodo=#form.Periodo#'>
		</cfif>
		<cfif isdefined("form.Mes") and len(trim(form.Mes))>
			<cfset vs_params = vs_params & '&Mes=#form.Mes#'>
		</cfif>
	
		<cfif isdefined("form.deduccion") and len(trim(form.deduccion))>
			<cfset vs_params = vs_params & '&deduccion=#form.deduccion#'>
		</cfif>--->
		<cfsavecontent variable="ENCABEZADO_IMP">
			<tr>
			<td align="center" colspan="6">
			<cf_EncReporte
				Titulo="#LB_ReporteImpuestoEstatalSobreNomina#"
				filtro1="#LB_TipoNomina# #rsTnomina.Tdescripcion#"
				filtro2=#vfiltro2#
				filtro3=#nomOficina#
			>
			</td></tr>
			<tr class="tituloListas">
				<td><b>#LB_Trabajador#</b></td>
				<td align="right"><b>#LB_AcumuladoSueldo#</b></td>
				<td align="right"><b>#LB_ParteVariableGravable#</b></td>
				<td align="right"><b>#LB_MontoISN#</b></td>
			</tr>
		</cfsavecontent>
	
		<cfset LvarFileName = "ImpuestoSobreNomina-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
		<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
		<tr>
				<td align="center">
				<cf_htmlReportsHeaders
					title= "#LB_ReporteImpuestoEstatalSobreNomina#"
					filename="#LvarFileName#"
					irA="repISNNominasAplicadas-filtro.cfm">
	
					<table width="98%" cellpadding="1" cellspacing="0" align="center" border="0">
						<tr>
							#ENCABEZADO_IMP#
						</tr>
						<cfif (isdefined("form.Periodo") and len(trim(form.Periodo)) and isdefined("form.Mes") and len(trim(form.Mes)))
								or (isdefined("form.FechaDesde") and len(trim(form.FechaDesde)) and isdefined("form.FechaHasta") and len(trim(form.FechaHasta)))>
							<cfif rsDatos.RecordCount NEQ 0>
								<cfloop query="rsDatos">
									<tr <cfif rsDatos.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
										<td align="left"><font  style="font-size:11px; font-family:'Arial'">#rsDatos.DEnombre#</font></td>
										<td align="right"><font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsDatos.MontoSalario,'999,999,999.99')#</font></td>
										<td align="right"><font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsDatos.MontoVariable,'999,999,999.99')#</font></td>
										<td align="right"><font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsDatos.MontoISN,'999,999,999.99')#</font></td>
									</tr>
								</cfloop>
								<tr>
									<td colspan="1" align="right"><b><cf_translate key="LB_Total">Totales</cf_translate>:</b>&nbsp;</td>
									<td align="right" style="border-top:1px solid black;">#LSNumberFormat(rsDatosT.TMontoSalario,'999,999,999.99')#</font></td>
									<td align="right" style="border-top:1px solid black;">#LSNumberFormat(rsDatosT.TMontoVariable,'999,999,999.99')#</font></td>
									<td align="right" style="border-top:1px solid black;">#LSNumberFormat(rsDatosT.TMontoISN,'999,999,999.99')#</font></td>
								</tr>
								<tr><td colspan="4" align="center" class="letra">--- <cf_translate key="MGS_FinDelReporte" xmlfile="/rh/generales.xml">Fin del Reporte</cf_translate> ---</td></tr>
							<cfelse>
								<tr><td colspan="4" align="center"><b>----- #LB_NoSeEncontraronRegistros# -----</b></td></tr>
							</cfif>
						</cfif>
					</table>
				</td>
			</tr>
		</table>
	</cfif>
    
</cfoutput>

