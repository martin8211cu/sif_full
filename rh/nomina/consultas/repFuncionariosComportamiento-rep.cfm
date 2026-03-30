<cfinvoke key="LB_FuncionariosPorTipoDeNombramiento" default="Funcionarios por Tipo de Comportamiento" returnvariable="LB_FuncionariosPorTipoDeNombramiento" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Del" default="Del" returnvariable="LB_Del" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_al" default="al" returnvariable="LB_al" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Indefinido" default="Indefinido" returnvariable="LB_Indefinido" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_hasta" default="Hasta" returnvariable="LB_hasta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_TodasLasFechas" default="Todas las fechas" returnvariable="LB_TodasLasFechas" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_CentroFuncional" default="Centro Funcional" returnvariable="LB_CentroFuncional" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Puesto" default="Puesto" returnvariable="LB_Puesto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_TipoNombramiento" default="Tipo Nombramiento" returnvariable="LB_TipoNombramiento" component="sif.Componentes.Translate" method="Translate"/>

<cfset filtro1 = ''>
<cfset filtro2 = ''>
<cfset filtro3 = ''>
<cfset filtro4 = ''>

<cfif isdefined("form.ffin") and len(trim(form.ffin)) EQ 0>
	<cfset form.ffin= LSDateFormat(Createdate('6100','01','01'),'dd/mm/yyyy')>
</cfif>
<cfif isdefined("form.CFidI") and len(trim(form.CFidI))>
	<cfquery name="CFuncional" datasource="#session.DSN#">
		select CFpath,CFcodigo,CFdescripcion from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFidI#">
	</cfquery>
	<cfset filtro2 = '#LB_CentroFuncional#: '& CFuncional.CFcodigo & ' - ' & CFuncional.CFdescripcion>
</cfif>
<cfif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo))>
	<cfquery name="rsPuesto" datasource="#session.DSN#">
		select RHPcodigo, RHPdescpuesto
		from RHPuestos
		where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.RHPcodigo)#">
	</cfquery>
	<cfset filtro3 = '#LB_Puesto#: '&rsPuesto.RHPcodigo&' - '&rsPuesto.RHPdescpuesto>
</cfif>
<cfif isdefined("form.RHTid") and len(trim(form.RHTid))>
	<cfquery name="rsTipoNomb" datasource="#session.DSN#">
		select RHTcodigo, RHTdesc
		from RHTipoAccion
		where RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTid#">
	</cfquery>
	<cfset filtro4 = '#LB_TipoNombramiento#: '&rsTipoNomb.RHTcodigo&' - '&rsTipoNomb.RHTdesc>
</cfif>
<cf_dbfunction name="to_date" args="#Createdate('6100','1','1')#" returnvariable="fechafin">

<cfquery name="rsDatos" datasource="#session.DSN#">
	select 	b.DEidentificacion,
			<cf_dbfunction name="concat" args="b.DEapellido1,' ',b.DEapellido2,' ',b.DEnombre"> as empleado,
			d.CFdescripcion as cfuncional,
			e.RHPdescpuesto as puesto,
			a.DLfvigencia as fingreso,
			a.DLffin as ffinalizacion,
			f.RHTdesc as nombramiento,
			d.CFid,
			a.RHTid

	from DLaboralesEmpleado a

		inner join DatosEmpleado b
			on a.DEid = b.DEid

		inner join RHPlazas c
			on a.RHPid = c.RHPid
			and a.Ecodigo = c.Ecodigo

		inner join CFuncional d
			on c.CFid = d.CFid
			and c.Ecodigo = d.Ecodigo
			<cfif isdefined("form.CFcodigoI") and len(trim(form.CFcodigoI)) and isdefined("form.dependencias") and len(trim(form.dependencias))>
				and (d.CFpath like <cfqueryparam cfsqltype="cf_sql_varchar" value="#CFuncional.CFpath#/%">
						or d.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFidI#">
					)
			<cfelseif isdefined("form.CFidI") and len(trim(form.CFidI)) and not isdefined("form.dependencias")>
				and d.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFidI#">
			</cfif>	

		inner join RHPuestos e
			on c.RHPpuesto = e.RHPcodigo
			and c.Ecodigo = e.Ecodigo
			<cfif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo))>
				and e.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPcodigo#">
			</cfif>

		inner join RHTipoAccion f	
			on a.RHTid = f.RHTid
			and RHTcomportam = 1 <!---Por si no se selecciono un tipo de comportamiento mostrar solo los de nombramiento---->	

	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined("form.RHTid") and len(trim(form.RHTid))>
			and a.RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTid#">
		</cfif>
				
		<cfif isdefined("form.finicio") and len(trim(form.finicio)) and isdefined("form.ffin") and len(trim(form.ffin))>
			<cfif DateCompare(LSParseDateTime(form.finicio), LSParseDateTime(form.ffin)) EQ -1>
				and a.DLfvigencia <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#">				
				and coalesce(a.DLffin,<cfqueryparam cfsqltype="cf_sql_date" value="#Createdate('6100','1','1')#">) >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.finicio#">
			<cfelse>
				and a.DLfvigencia <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#">
				and coalesce(a.DLffin, <cfqueryparam cfsqltype="cf_sql_date" value="#Createdate('6100','1','1')#">)  >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.ffin#">				
			</cfif>
		<cfelseif isdefined("form.finicio") and len(trim(form.finicio)) and (not isdefined("form.ffin") or len(trim(form.ffin)) EQ 0)>			
			and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#"> between a.DLfvigencia  and a.DLffin
		<cfelseif isdefined("form.ffin") and len(trim(form.ffin)) and (not isdefined("form.finicio") or len(trim(form.finicio)) EQ 0)>
					<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#"> 	between a.DLfvigencia and a.DLffin
		</cfif>
		
	order by d.CFid, a.RHTid, f.RHTdesc, <cf_dbfunction name="concat" args="b.DEapellido1,' ',b.DEapellido2,' ',b.DEnombre">,d.CFdescripcion, a.DLfvigencia asc
</cfquery>

<cfset LvarFileName = "FuncionariosTComportamiento#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">

<cf_htmlReportsHeaders 
	title="#LB_FuncionariosPorTipoDeNombramiento#" 
	filename="#LvarFileName#"
	irA="repFuncionariosComportamiento-filtro.cfm">
	
<table width="98%" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td>
			<table width="98%" cellpadding="0" cellspacing="0" align="center">
				<tr><td>
					<cfif isdefined("form.finicio") and len(trim(form.finicio)) and isdefined("form.ffin") and len(trim(form.ffin))>
						<cfset filtro1 = ' #LB_Del#: '&LSDateFormat(form.finicio,'dd/mm/yyyy') & ' #LB_al#: '&LSDateFormat(form.ffin,'dd/mm/yyyy')>
					<cfelseif isdefined("form.finicio") and len(trim(form.finicio)) and not isdefined("form.ffin") or len(trim(form.ffin)) EQ 0>		
						<cfset filtro1 = ' #LB_Del#: '&LSDateFormat(form.finicio,'dd/mm/yyyy') & ' a #LB_Indefinido#'>
					<cfelseif isdefined("form.ffin") and len(trim(form.ffin)) and not isdefined("form.finicio") or len(trim(form.finicio)) EQ 0>
						<cfset filtro1 = '#LB_hasta#: '&LSDateFormat(form.ffin,'dd/mm/yyyy')>
					<cfelse>
						<cfset filtro1 = '#LB_TodasLasFechas#'>
					</cfif>
					<cf_EncReporte
						Titulo="#LB_FuncionariosPorTipoDeNombramiento#"
						Color="##E3EDEF"
						filtro1="#filtro1#"
						filtro2="#filtro2#"
						filtro3="#filtro3#"
						filtro4="#filtro4#"
					>
				</td></tr>
			</table>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<cfif rsDatos.RecordCount NEQ 0>
		<tr>
			<td>
				<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
					<tr>
						<cfoutput>
						<TD>&nbsp;</TD>
						<TD>&nbsp;</TD>
						<td valign="top"><strong><cf_translate key="LB_Cedula">C&eacute;dula</cf_translate></strong></td>
						<td valign="top"><strong><cf_translate key="LB_NombreFuncionario">Nombre Funcionario</cf_translate></strong></td>
						<td valign="top"><strong>#LB_Puesto#</strong></td>
						<td valign="top" width="10%" nowrap="nowrap"><strong><cf_translate key="LB_FechaIngreso">Fecha Ingreso</cf_translate></strong></td>
						<td valign="top" width="10%" nowrap="nowrap"><strong><cf_translate key="LB_FechaFinalizacion">Fecha Finalizaci&oacute;n</cf_translate></strong></td>
						</cfoutput>
					</tr>
					<cfoutput query="rsDatos" group="CFid">
						<tr>							
							<td colspan="7" bgcolor="##F1F1F1"><strong>#LB_CentroFuncional#:&nbsp;#rsDatos.cfuncional#</strong></td>
						</tr>
						<cfoutput group="RHTid">
							<tr>
								<td>&nbsp;</td>
								<td colspan="6"><strong><i>#rsDatos.nombramiento#</i></strong></td>
							</tr>
							<cfoutput>
								<tr>
									<td width="1%">&nbsp;</td>
									<TD width="2%">&nbsp;</TD>
									<td valign="top">#rsDatos.DEidentificacion#</td>
									<td valign="top">#rsDatos.empleado#</td>
									<td valign="top">#rsDatos.puesto#</td>
									<td valign="top" align="center">#LSDateFormat(rsDatos.fingreso,'dd/mm/yyyy')#</td>
									<td valign="top" align="center">
										<cfif LSDateFormat(rsDatos.ffinalizacion,'dd/mm/yyyy') EQ '01/01/6100'>
											#LB_Indefinido#
										<cfelse>	
											#LSDateFormat(rsDatos.ffinalizacion,'dd/mm/yyyy')#
										</cfif>
									</td>
								</tr>
							</cfoutput>
						</cfoutput>
					</cfoutput>
				</table>
			</td>
		</tr>
	<cfelse>
		<tr><td align="center"><strong>---- <cf_translate key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> ----</strong></td></tr>	
	</cfif>
</table>	
