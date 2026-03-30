<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_Errores" default="Errores Presentados en el C&aacute;lculo de la N&oacute;omina Actual"	 returnvariable="LB_Errores" component="sif.Componentes.Translate" method="Translate"/>
<!--- Variables por URL --->
<cfif isdefined("url.RCNid") and len(trim(url.RCNid))>
	<cfset form.RCNid = url.RCNid>
</cfif>
<cfif isdefined("url.DEid") and len(trim(url.DEid))>
	<cfset form.DEid = url.DEid>
</cfif>

<!--- DATOS DE LA RELACION DE CALCULO --->
<cfquery name="CalendarioPagos" datasource="#session.DSN#">
	select CPtipo, CPdesde, CPhasta, Tcodigo,CPperiodo
	from CalendarioPagos
	where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
</cfquery>

<!--- VERIFICA SI DENTRO DE LA RELACIÓN HAY EMPLEADOS CON SALARIO LIQUIDO EN NEGATIVO --->
<cfquery name="rsSalNegativos" datasource="#session.DSN#">
	select DEidentificacion, {fn concat({fn concat({fn concat({ fn concat(b.DEapellido1, ' ') },b.DEapellido2)}, ' ')},b.DEnombre) } as nombreEmpl
	from SalarioEmpleado a
		inner join DatosEmpleado b
			on b.DEid = a.DEid
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
	<cfif isdefined('form.DEid') and len(trim(form.DEid))>
		and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	</cfif>
	and SEliquido < 0
</cfquery>



<!--- ljimenez verifica que para los empleados que calcula nomina tengan el SDI actualizado al bimestre que corresponde --->
<cfquery name="rsHSDI" datasource="#session.DSN#">
	select DEidentificacion, {fn concat({fn concat({fn concat({ fn concat(b.DEapellido1, ' ') },b.DEapellido2)}, ' ')},b.DEnombre) } as nombreEmpl
	from SalarioEmpleado a
		inner join DatosEmpleado b
			on b.DEid = a.DEid
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
	<cfif isdefined('form.DEid') and len(trim(form.DEid))>
		and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	</cfif>
    and a.DEid not in 
              (select se.DEid
                from SalarioEmpleado se
                    inner join RHHistoricoSDI b
                        on se.DEid = b.DEid
                        and RHHperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CalendarioPagos.CPperiodo#">
                        and b.RHHaplicado = 1 <!---SML. Modificacion para que valide que los SDI estan aplicados--->
                        and b.Bimestrerige = 
                        (select case when CPmes = 1 then 1
                                when CPmes = 2 then 1
                                when CPmes = 3 then 2
                                when CPmes = 4 then 2
                                when CPmes = 5 then 3
                                when CPmes = 6 then 3
                                when CPmes = 7 then 4
                                when CPmes = 8 then 4
                                when CPmes = 9 then 5
                                when CPmes = 10 then 5
                                when CPmes = 11 then 6
                                when CPmes = 12 then 6
                            end   
                         from CalendarioPagos
                            where CPid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
                        )
                    where se.RCNid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
                )
    
</cfquery>


<!--- VALIDACIONES DE CALENDARIOS DE PAGO ANTERIORES --->
	<cfif CalendarioPagos.CPtipo EQ 2> <!--- SI ES ANTICIPO DE SALARIO LA COMPARACION ES DIFERENTE --->
		<cfquery name="rsTipoNomina" datasource="#session.DSN#">
			select Ttipopago as CodTipoPago
			from TiposNomina
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and rtrim (Tcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(CalendarioPagos.Tcodigo)#">
		</cfquery>
		<cfif rsTipoNomina.CodTipoPago EQ "0"> 		<!--- Semanal --->
			<cfset Lvar_Fecha = DateAdd("d", -6, "#CalendarioPagos.CPdesde#")>
		<cfelseif rsTipoNomina.CodTipoPago EQ "1">	<!--- Bisemanal --->
			<cfset Lvar_Fecha = DateAdd("d", -13, "#CalendarioPagos.CPdesde#")>
		<cfelseif rsTipoNomina.CodTipoPago EQ "2">	<!--- Quincenal --->
			<cfset Lvar_Fecha = DateAdd("d", -14, "#CalendarioPagos.CPdesde#")>
		<cfelseif rsTipoNomina.CodTipoPago EQ "3">	<!--- Mensual --->	
			<cfset Lvar_Fecha = DateAdd("d", -(DaysInMonth(CalendarioPagos.CPdesde) - 1)	, "#CalendarioPagos.CPdesde#")>
		</cfif>
		<cfset Periodo = DatePart('yyyy',Lvar_Fecha)>
		<cfset Mes = DatePart('m',Lvar_Fecha)>
		<cfquery datasource="#session.DSN#" name="CPidant">
			select a.CPid
			from CalendarioPagos a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			  and a.CPdesde = (select min(CPdesde)
								from CalendarioPagos
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								  and CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">
								  and CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">
								  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CalendarioPagos.Tcodigo#">)
			  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CalendarioPagos.Tcodigo#">
		</cfquery>
		
	<cfelseif CalendarioPagos.CPtipo EQ 0>
		<!--- VERIFICA SI HAY UNA NOMINA DE ANTICIPO PARA EL MISMO PERIODO DE LA NOMINA NORMAL QUE SE ESTA CALCULANDO
			SI HAY UNA NOMINA DE ANTICIPO SE VERIFICA QUE TIENE Q ESTAR EN HISTORICOS PARA PODER GENERARLA.
		 --->
		<cfset Periodo = DatePart('yyyy',"#CalendarioPagos.CPdesde#")>
		<cfset Mes = DatePart('m',"#CalendarioPagos.CPdesde#")>
		<cfquery name="CPidant" datasource="#session.DSN#">
			select a.CPid
			from CalendarioPagos a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			  and a.CPdesde = (
			  	select max(b.CPdesde) from CalendarioPagos b
				where b.Ecodigo = a.Ecodigo 
				  and b.Tcodigo = a.Tcodigo
				  and b.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#"> 
				  and b.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#"> 
				  and CPtipo = 2
				 )
			  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CalendarioPagos.Tcodigo#">
			  and CPtipo = 2
		</cfquery>
        
		<cfif CPidant.RecordCount EQ 0 or CalendarioPagos.CPtipo eq 1 >		<!--- Se agrego la segunda parte del or, pues las nominas especiales no deben considerar el query anterior. --->
			<cfquery datasource="#session.DSN#" name="CPidant">
				select a.CPid
				from CalendarioPagos a
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
				  and a.CPdesde = (
				  	select max(b.CPdesde) from CalendarioPagos b
					where b.Ecodigo = a.Ecodigo 
					and b.Tcodigo = a.Tcodigo
					 and b.CPdesde < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CalendarioPagos.CPdesde#">
					 )
				  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CalendarioPagos.Tcodigo#">
			</cfquery>
		</cfif>
	</cfif>
	<cfif isdefined('CPidant') and Len(CPidant.CPid)>
		<cfquery datasource="#session.DSN#" name="existsHRCalculoNomina">
			select 1 from HRCalculoNomina
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CalendarioPagos.Tcodigo#">
			and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPidant.CPid#">
		</cfquery>
		<cfif existsHRCalculoNomina.REcordCount eq 0>
			<cfset Lvar_Error = 1>
		</cfif>
	</cfif>
	<cfif CalendarioPagos.CPtipo EQ 1>
		<cfquery name="rsEspeciales" datasource="#session.DSN#">
			select 1
			from SalarioEmpleado a, CalendarioPagos b
			where a.RCNid = b.CPid
				and a.SEcalculado = 0
				and a.SEliquido >= 0.00
				and b.CPtipo = 1	<!----Calendario de pago de tipo especial---->
				<!---Cuando no exista un calendario abierto (RCalculoNomina) con fecha hasta < a fecha hasta del calendario de la nomina aplicando---->
				and not exists(	select 1 
								from CalendarioPagos c, RCalculoNomina y
								where c.CPid = y.RCNid
									and b.Tcodigo = c.Tcodigo
									and c.CPid <> b.CPid
									and c.CPhasta < b.CPhasta)
			
		</cfquery>
		<cfif isdefined('rsEspeciales') and rsEspeciales.REcordCount EQ 0>
			<cfset Lvar_ErrorEsp = 1>
		</cfif>
	</cfif>
	
	
	<!---CarolRS Verifica si debe realizarse la validacion para los centros funcionales inactivos--->
	<cfquery name="rsVerificaCFActivos" datasource="#session.DSN#">
		select Pvalor from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> and Pcodigo = 2500
	</cfquery>
	
	<cfif isdefined("rsVerificaCFActivos") and rsVerificaCFActivos.Pvalor EQ 1>
		
		<!---CarolRS Verificar los Centros Funcionales para los salarios e Incidencias generadados en la nómina al momente de Crear o Restaurar la Nómina, 
		indicando las personas que se encuentran en un Centro Funcional inactivo.--->
	
		<!---CarolRS  Incidencias registradas en Centros Funcionales inactivos:--->
		<cfquery name="rsIncidendenciasCF" datasource="#session.DSN#"> 
			Select distinct a.DEid, a.CFid, e.CFcodigo,e.CFdescripcion, e.CFestado,
			f.DEidentificacion, {fn concat({fn concat({fn concat({ fn concat(f.DEapellido1, ' ') },f.DEapellido2)}, ' ')},f.DEnombre) } as nombreEmpl
			, b.CIcodigo, b.CIdescripcion, a.ICfecha
			from IncidenciasCalculo a, CIncidentes b, CalendarioPagos c, CFuncional e, DatosEmpleado f
			Where RCNid=#form.RCNid#
			and a.CIid=b.CIid
			and a.DEid=f.DEid
			and c.CPid=a.RCNid
			and a.ICfecha between c.CPdesde and c.CPhasta
			and a.CFid is not null
			and a.CFid = e.CFid
			and e.CFestado = 0 <!---inactivo--->
			<cfif isdefined('form.DEid') and len(trim(form.DEid))>
				and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			</cfif>
		</cfquery>
		
		<!---CarolRS Pagos registrados en Centros Funcionales inactivos:--->
		<cfquery name="rsPagosCF" datasource="#session.DSN#">	 
			Select distinct a.DEid,c.CFid, c.CFcodigo,c.CFdescripcion,c.CFestado,f.DEidentificacion, {fn concat({fn concat({fn concat({ fn concat(f.DEapellido1, ' ') },f.DEapellido2)}, ' ')},f.DEnombre) } as nombreEmpl
			from PagosEmpleado a, RHPlazas b, CFuncional c, DatosEmpleado f
			Where a.RCNid=#form.RCNid#
			and a.DEid=f.DEid
			and a.PEtiporeg=0
			and b.RHPid=a.RHPid
			and c.CFid = b.CFid
			and c.CFestado = 0 <!---inactivo--->
			and a.PEhasta = (select max(x.PEhasta) from PagosEmpleado x where x.RCNid=#form.RCNid# and x.DEid=a.DEid)
			<cfif isdefined('form.DEid') and len(trim(form.DEid))>
				and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			</cfif>
		</cfquery>
	</cfif> 



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><cfoutput>#LB_Errores#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<cf_templatecss>
</head>

<body>
	<cfoutput>
	
		<!--- Pintado de la Pantalla --->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="center">
					<table width="98%" cellpadding="5" cellspacing="5" border="0" >
						<tr>
							<td align="Center" class="areaFiltro" colspan="2">
								<font size="2"><strong><cf_translate key="LB_ErroresPresentadosEnElCalculoDeLaNominaActual">
									Errores presentados en la n&oacute;mina actual.
								</cf_translate></strong></font>
							</td>
						</tr>
						<cfif isdefined('rsSalNegativos') and rsSalNegativos.RecordCount>
							<tr>	
								<td align="left" colspan="2"><cf_translate key="LB_LasSiguientesPersonasTieneSalarioNegativo">Las siguientes personas tienen el salario Negativo</cf_translate></td>
							</tr>
							<cfloop query="rsSalNegativos">
								<tr>
									<td width="5%">&nbsp;</td>
									<td align="left">#DEidentificacion#&nbsp;&nbsp;-&nbsp;&nbsp;#nombreEmpl# </td>
								</tr>
							</cfloop>
						</cfif>

                        <cfif isdefined('rsHSDI') and rsHSDI.RecordCount>
							<tr>	
								<td align="left" colspan="2">
                                	<cf_translate key="LB_LasSiguientesPersonasNOTieneSDIactualizado">Las siguientes personas NO tienen el SDI actualizado para el bimestre actual</cf_translate>
                                </td>
							</tr>
							<cfloop query="rsHSDI">
								<tr>
									<td width="5%">&nbsp;</td>
									<td align="left">#DEidentificacion#&nbsp;&nbsp;-&nbsp;&nbsp;#nombreEmpl# </td>
								</tr>
							</cfloop>
						</cfif>
                        
                        
                        
						<cfif isdefined('Lvar_Error') and Lvar_Error EQ 1>
							<tr>	
								<td align="left" colspan="2">
									<cf_translate key="LB_Error1">
										Existe una nómina anterior que no ha sido cerrada o no ha sido generada. Favor verifique.
									</cf_translate>
								</td>
							</tr>
						</cfif>
						<cfif isdefined('Lvar_ErrorEsp') and Lvar_ErrorEsp EQ 1>
							<tr>	
								<td align="left" colspan="2">
									<cf_translate key="LB_Error2">
										Existe un calendario del mismo tipo de nomina abierto y con fecha hasta menor a la fecha  
									  hasta del calendario especial que se esta generando. Favor verifique.
									</cf_translate>
								</td>
							</tr>
						</cfif>
						
						
						
						<cfif isdefined('rsIncidendenciasCF') and rsIncidendenciasCF.RecordCount GT 0>
							<tr>	
								<td align="left" colspan="2">
									<cf_translate key="LB_Error2">
										Las Siguientes personas registran incidencias bajo centros funcionales inactivos.
									</cf_translate>
								</td>
							</tr>
							<tr>
									<td width="5%">&nbsp;</td>
									<td align="left">
									<table cellpadding="0" cellspacing="2" border="0" width="100%">
									<tr><td align="left" style="font-size:11px; background-color:##F5F5F5">Empleado</td>
									<td align="left" style="font-size:11px; background-color:##F5F5F5">Centro Funcional</td>
									<td align="left" style="font-size:11px; background-color:##F5F5F5">Detalle Incidencia</td>
									<td align="left" style="font-size:11px; background-color:##F5F5F5">Fecha Incidencia</td>
									</tr>
									<cfloop query="rsIncidendenciasCF">
									<tr><td style="font-size:11px">#rsIncidendenciasCF.DEidentificacion#&nbsp;&nbsp;-&nbsp;&nbsp;#rsIncidendenciasCF.nombreEmpl# </td>
									<td align="left" style="font-size:10px">#rsIncidendenciasCF.CFcodigo#-#rsIncidendenciasCF.CFdescripcion# </td>
									<td align="left" style="font-size:10px">#rsIncidendenciasCF.CIcodigo#-#rsIncidendenciasCF.CIdescripcion# </td>
									<td align="left" style="font-size:10px">#lsdateformat(rsIncidendenciasCF.ICfecha,'dd-mm-yyyy')# </td></tr>
									</cfloop>
									</table>
									
									</td>
							</tr>
						</cfif>
						
						<cfif isdefined('rsPagosCF') and rsPagosCF.RecordCount GT 0>
							<tr>	
								<td align="left" colspan="2">
									<cf_translate key="LB_Error2">
										Las Siguientes personas se registran pago de salario bajo centros funcionales inactivos.
									</cf_translate>
								</td>
							</tr>
							<tr>
									<td width="5%">&nbsp;</td>
									<td align="left">
									<table cellpadding="0" cellspacing="2" border="0" width="100%">
									<tr><td align="left" style="font-size:11px; background-color:##F5F5F5">Empleado</td>
									<td align="left" style="font-size:11px; background-color:##F5F5F5">Centro Funcional</td></tr>
									<cfloop query="rsPagosCF">
									<tr><td style="font-size:11px">#rsPagosCF.DEidentificacion#&nbsp;&nbsp;-&nbsp;&nbsp;#rsPagosCF.nombreEmpl# </td>
									<td align="left" style="font-size:10px">#rsPagosCF.CFcodigo#-#rsPagosCF.CFdescripcion# </td></tr>
									</cfloop>
									</table>
									
									</td>
							</tr>
							
						</cfif>
						
					</table>
				</td>
			</tr>
		</table>
	</cfoutput>
</body>
</html>
