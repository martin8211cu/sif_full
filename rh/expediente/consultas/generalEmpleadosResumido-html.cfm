<cfinvoke component="sif.Componentes.Translate"	method="Translate"	Key="LB_Listado_General_de_Empleados"	Default="Listado General de Empleados"	returnvariable="LB_Listado_General_de_Empleados"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CentroFuncional" Default="Centro Funcional" returnvariable="LB_CentroFuncional"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Puesto" Default="Puesto" returnvariable="LB_Puesto"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TipoCuenta" Default="Tipo Cuenta" returnvariable="LB_TipoCuenta"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Banco" Default="Banco" returnvariable="LB_Banco"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Cuenta" Default="Cuenta" returnvariable="LB_Cuenta"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CuentaCliente" Default="Cuenta Cliente" returnvariable="LB_CuentaCliente"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha_de_ingreso" Default="Fecha de ingreso" returnvariable="LB_Fecha_de_ingreso"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Cedula" Default="C&eacute;dula" returnvariable="LB_Cedula"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nombre" Default="Nombre" returnvariable="LB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaNacimiento" Default="Fecha Nacimiento" returnvariable="LB_FechaNacimiento"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Salario" Default="Salario" returnvariable="LB_Salario"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NoSeEncontraronRegistros" Default="No se encontraron registros" returnvariable="LB_NoSeEncontraronRegistros"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaDeCorte" Default="Fecha de Corte al" returnvariable="LB_FechaDeCorte"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_YDependencias" Default="y Dependencias" returnvariable="LB_YDependencias"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Sdi" Default="SDI" returnvariable="LB_Sdi"/>


<cfset LvarFileName = "Lst_GeneralEmp_#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">

<cfif isdefined("form.CFid") and #form.CFid# NEQ ''  >
	<cfquery name="rsCFuncional" datasource="#session.DSN#">
		select CFdescripcion
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
	</cfquery>
</cfif>	

<cfoutput>	
	<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
	<tr>
			<td align="center">
			<cf_htmlReportsHeaders 
				title="#LB_Listado_General_de_Empleados#" 
				filename="#LvarFileName#"
				param="&url.OrderBy=#form.OrderBy#&FechaHasta=#form.FechaHasta#" 
				irA="generalEmpleadosResumido.cfm">
				
				<table width="98%" cellpadding="1" cellspacing="0" align="center" border="0">
					<tr>
						<td align="center" colspan="12"><strong><font size="2">
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
									filtro2="#filtro_2#">
									
								<tr class="tituloListas">
									<td><b>#LB_Cedula#</b></td>
									<td><b>#LB_Nombre#</b></td>
									<td><b>#LB_CentroFuncional#</b></td>
									<td><b>#LB_Puesto#</b></td>
									<td align="center"><b>#LB_Banco#</b></td>
									<td align="center"><b>#LB_Cuenta#</b></td>
									<td align="center"><b>#LB_TipoCuenta#</b></td>
									<td align="center"><b>#LB_CuentaCliente#</b></td>
									<td align="center"><b>#LB_Salario#</b></td>
									<td align="center"><b>#LB_Sdi#</b></td>
									<td align="center" ><b>#LB_FechaNacimiento#</b></td>
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
								<td align="center" colspan="11"><strong><font size="2">
								#ENCABEZADO_IMP#
								<cfset contadorlineas = 8>  
							</td>
							</cfif>
								<tr <cfif rsReporte.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
									<td align="left"><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.DEidentificacion)#</font></td>
									<td><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.DEnombre)#</font></td>
									<td><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.CFdescripcion)#</font></td>
									<td><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.RHPdescpuesto)#</font></td>
									
									<td><font  style="font-size:11px; font-family:'Arial'">#trim(ucase(rsReporte.Banco))#</font></td>
									<td align="center"><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.Cuenta)#</font></td>
									<td align="center"><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.TipoCuenta)#</font></td>
									<td align="center"><font  style="font-size:11px; font-family:'Arial'">#trim(rsReporte.cuentaCliente)#</font></td>
									<td align="right"><font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsReporte.Salario,'999,999,999.99')#</font></td>
									<td align="right"> <font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsReporte.SDI,'999,999,999.99')#</font> </td>
									<td align="center"><font  style="font-size:11px; font-family:'Arial'">#LSDateFormat(rsReporte.DEfechanac,"dd/mm/yyyy")#</font></td>
									<td align="center"><font  style="font-size:11px; font-family:'Arial'">#LSDateFormat(rsReporte.Antiguedad,"dd/mm/yyyy")#</font></td>
								</tr>
								<cfset contadorlineas = contadorlineas + 1>
						</cfloop>
						<tr><td colspan="11" align="center" class="letra">--- <cf_translate key="MGS_FinDelReporte" xmlfile="/rh/generales.xml">Fin del Reporte</cf_translate> ---</td></tr>
					<cfelse>
						<tr><td colspan="11" align="center"><b>----- #LB_NoSeEncontraronRegistros# -----</b></td></tr>
					</cfif>
				</table>			
			</td>
		</tr>
	</table>
</cfoutput>