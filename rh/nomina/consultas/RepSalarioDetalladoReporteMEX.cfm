
<cfif isdefined('url.FechaHasta') and not isdefined('form.FechaHasta')>
	<cfset form.FechaHasta = url.FechaHasta>
</cfif>	

<cfif not isdefined('form.dependencias')>
	<cfset form.dependencias = ''>
</cfif>	

<cfif isdefined('url.CFid') and not isdefined('form.CFid')>
	<cfset form.CFid = url.CFid>
</cfif>	

<cfif isdefined("form.CFid") and #form.CFid# NEQ ''  >
	<cfquery name="rsCFuncional" datasource="#session.DSN#">
		select CFpath
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
	</cfquery>
	<cfset vRuta = rsCFuncional.CFpath >
</cfif>	

<cfquery name="rsReporte" datasource="#session.DSN#">
	select  
		<cf_dbfunction name="concat" args="DE.DEapellido1,' ',DE.DEapellido2,'  ',DE.DEnombre"> as DEnombre,
		DE.DEidentificacion,
		CF.CFdescripcion,
		RHP.RHPdescpuesto,
		CF.CFcodigo,
		coalesce(ltrim(rtrim(RHP.RHPcodigoext)),ltrim(rtrim(RHP.RHPcodigo))) as RHPcodigo
         , coalesce((select d.DLTmonto
                from DatosEmpleado a
                inner join LineaTiempo l
                on a.DEid = l.DEid
                and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaHasta)#"> between l.LTdesde and l.LThasta
                inner join DLineaTiempo d
                on l.LTid = d.LTid
                inner join ComponentesSalariales c
                on d.CSid = c.CSid
                and CSsalariobase = 1
                where a.DEid = DE.DEid),0) as Salario 

		, DE.DEfechanac
		, coalesce(ve.EVfantig,ve.EVfecha) as Antiguedad
        , coalesce((select d.DLTmonto
                        from DatosEmpleado a
                        inner join LineaTiempo l
                        on a.DEid = l.DEid
                        and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaHasta)#"> between l.LTdesde and l.LThasta
                        inner join DLineaTiempo d
                        on l.LTid = d.LTid
                        where a.DEid = DE.DEid
                        and d.CIid in (SELECT
                                            c.CIid
                                        FROM  RHReportesNomina e
                                        INNER JOIN RHColumnasReporte d
                                        ON  e.RHRPTNid = d.RHRPTNid
                                        INNER JOIN RHConceptosColumna c
                                        ON d.RHCRPTid = c.RHCRPTid
                                        WHERE e.RHRPTNcodigo = 'MX001' 
                                            and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">)),0) as Vales
	from LineaTiempo LT
		inner join DatosEmpleado DE
			on DE.DEid = LT.DEid

		inner join RHPlazas RHPL
			inner join CFuncional CF
			on CF.CFid = RHPL.CFid
			on RHPL.RHPid = LT.RHPid
		inner join  RHPuestos RHP
			on RHP.RHPcodigo = LT.RHPcodigo
			and RHP.Ecodigo = LT.Ecodigo
		inner join EVacacionesEmpleado ve
			on ve.DEid = DE.DEid
	where LT.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaHasta)#"> between LTdesde and LThasta
	<cfif isdefined("form.CFid") and #form.CFid# NEQ ''  >
		<cfif #form.dependencias# NEQ ''>
			and (upper(CF.CFpath) like '#ucase(vRuta)#/%' or CF.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">)
		<cfelse>
			and CF.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">				
		</cfif>
	</cfif>
	order by  #form.OrderBy#
</cfquery>


<!----================ PINTA EL REPORTE ================---->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteGeneraldeEmpleadosResumido" Default="Reporte General de Empleados Resumido" returnvariable="LB_ReporteGeneraldeEmpleadosResumido"/>
<!---<cfinclude template="generalEmpleadosResumido-html.cfm">--->
<cfinvoke component="sif.Componentes.Translate"	method="Translate"	Key="LB_Listado_General_de_Empleados"	Default="Listado General de Empleados"	returnvariable="LB_Listado_General_de_Empleados"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CentroFuncional" Default="Centro Funcional" returnvariable="LB_CentroFuncional"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Puesto" Default="Puesto" returnvariable="LB_Puesto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha_de_ingreso" Default="Fecha ingreso" returnvariable="LB_Fecha_de_ingreso"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Cedula" Default="Identificaci&oacute;n" returnvariable="LB_Cedula"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nombre" Default="Nombre" returnvariable="LB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaNacimiento" Default="Fecha Nacimiento" returnvariable="LB_FechaNacimiento"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Salario" Default="Salario" returnvariable="LB_Salario"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ValesDespensa" Default="Vales Despensa" returnvariable="LB_ValesDespensa"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NoSeEncontraronRegistros" Default="No se encontraron registros" returnvariable="LB_NoSeEncontraronRegistros"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaDeCorte" Default="Fecha de Corte al" returnvariable="LB_FechaDeCorte"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_YDependencias" Default="y Dependencias" returnvariable="LB_YDependencias"/>

<cfset LvarFileName = "Lst_GeneralEmp_#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">

<cfif isdefined("form.CFid") and #form.CFid# NEQ ''  >
	<cfquery name="rsCFuncional" datasource="#session.DSN#">
		select CFdescripcion
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
	</cfquery>
</cfif>	


<cfquery name="rsColumnas" datasource="#session.DSN#">
    select 
        e.RHRPTNid,
        e.Ecodigo,
        e.RHRPTNcodigo,
        d.RHCRPTcodigo,
        d.RHCRPTdescripcion,
        c.CIid
    from  RHReportesNomina e
    inner join RHColumnasReporte d
    	on  e.RHRPTNid = d.RHRPTNid
    inner join RHConceptosColumna c
    	on d.RHCRPTid = c.RHCRPTid
    where e.RHRPTNcodigo = 'MX001' 
    and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>


<cfoutput>	
	<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
	<tr>
			<td align="center">
			<cf_htmlReportsHeaders 
				title="#LB_Listado_General_de_Empleados#" 
				filename="#LvarFileName#"
				param="&url.OrderBy=#form.OrderBy#&FechaHasta=#form.FechaHasta#" 
				irA="RepSalarioDetalladoMEX.cfm">
				
				<table width="98%" cellpadding="1" cellspacing="0" align="center" border="0">
					<tr>
						<td align="center" colspan="8"><strong><font size="2">
						<cfif isdefined("form.CFid") and #form.CFid# NEQ ''  >
									<cfset filtro_2 = "#LB_FechaDeCorte# : #form.FechaHasta# ">
									<cfset filtro_1 = "#LB_CentroFuncional# :#rsCFuncional.CFdescripcion#" >
									<cfif #form.dependencias# NEQ ''>
											<cfset filtro_1 = "#LB_CentroFuncional# :#rsCFuncional.CFdescripcion#  #LB_YDependencias#">
									</cfif>	
						<cfelse>
							<cfset filtro_1 = "#LB_FechaDeCorte# :#form.FechaHasta#">
							<cfset filtro_2 = "">
						</cfif>
							<cfsavecontent variable="ENCABEZADO_IMP">
								<cf_EncReporte
									Titulo="#LB_ReporteGeneraldeEmpleadosResumido#"
									filtro1="#filtro_1#"
									filtro2="#filtro_2#"
								>
								<tr class="tituloListas">
									<td><b>#LB_Cedula#</b></td>
									<td><b>#LB_Nombre#</b></td>
									<td><b>#LB_CentroFuncional#</b></td>
									<td><b>#LB_Puesto#</b></td>
									<td align="right"><b>#LB_Salario#</b></td>
                                    <td align="right"><b>#LB_ValesDespensa#</b></td>
									<td align="center"><b>#LB_FechaNacimiento#</b></td>
									<td align="center"><b>#LB_Fecha_de_ingreso#</b></td>
								</tr>
							</cfsavecontent>
							#ENCABEZADO_IMP#
						</td>
					</tr>
													
					<cfif rsReporte.RecordCount NEQ 0>
						
						<cfset contadorlineas = 8>
						<cfset primercorte = true>
						<cfloop query="rsReporte">
							<cfif (contadorlineas gte 40 and rsReporte.CurrentRow NEQ 1)>
								<tr><td><H1 class=Corte_Pagina></H1></td></tr>
								<td align="center" colspan="7"><strong><font size="2">
								#ENCABEZADO_IMP#
								<cfset contadorlineas = 8>  
							</td>
							</cfif>
                            
								<tr <cfif rsReporte.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
									<td align="left"><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.DEidentificacion)#</font></td>
									<td><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.DEnombre)#</font></td>
									<td><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.CFdescripcion)#</font></td>
									<td><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.RHPdescpuesto)#</font></td>
									<td align="right"><font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsReporte.Salario,'999,999,999.99')#</font></td>
                                    <td align="right"><font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsReporte.vales,'999,999,999.99')#</font></td>
									<td align="center"><font  style="font-size:11px; font-family:'Arial'">#LSDateFormat(rsReporte.DEfechanac,"dd/mm/yyyy")#</font></td>
									<td align="center"><font  style="font-size:11px; font-family:'Arial'">#LSDateFormat(rsReporte.Antiguedad,"dd/mm/yyyy")#</font></td>
								</tr>
								<cfset contadorlineas = contadorlineas + 1>
						</cfloop>
						<tr><td colspan="7" align="center" class="letra">--- <cf_translate key="MGS_FinDelReporte" xmlfile="/rh/generales.xml">Fin del Reporte</cf_translate> ---</td></tr>
					<cfelse>
						<tr><td colspan="7" align="center"><b>----- #LB_NoSeEncontraronRegistros# -----</b></td></tr>
					</cfif>
				</table>			
			</td>
		</tr>
	</table>
</cfoutput>