<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">

<cf_templatecss>
	<cf_htmlReportsHeaders
		irA="cursos-perdidos.cfm"
		FileName="CobroCursos.xls"
		title="Cobro de Cursos">

<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2108" default="" returnvariable="LvarCant"/>

	<cfoutput>
		<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<cfinvoke key="LB_FechaDesde" default="<b>Fecha Desde</b>" returnvariable="LB_FechaDesde" component="sif.Componentes.Translate"  method="Translate"/>
					<cfinvoke key="LB_FechaHasta" default="<b>Fecha Hasta</b>" returnvariable="LB_FechaHasta" component="sif.Componentes.Translate"  method="Translate"/>
					<cfset filtro1 = LB_FechaDesde&': #ucase(form.fdesde)# '>
					<cfset filtro2 = LB_FechaHasta&': #ucase(Form.fhasta)#'>
						<cf_EncReporte
						Titulo="REPORTE DE DEDUCCIONES A FUNCIONARIOS POR CONCEPTO DE PERDIDA O ABANDONO DE ACTIVIDADES DE CAPACITACIÓN"
						Color="##E3EDEF"
						filtro1="#filtro1#"
						filtro2="#filtro2#"
						Cols= 11>
				</td>
			</tr>
		</table>
	</cfoutput>
	
	<cfquery name="rsRep" datasource="#session.dsn#">	
		select c.RHCid,d.DEidentificacion,c.RHECtotempleado,
		<cfif isdefined('LvarCant') and LvarCant gt 0>
		#LvarCant# as cant,
		(c.RHECtotempleado/#LvarCant#) as cuotas,
		<cfelse>
		'-' as cant,
		'-' as cuotas,
		</cfif>
		d.DEnombre #LvarCNCT# ' ' #LvarCNCT# d.DEapellido1 #LvarCNCT# ' ' #LvarCNCT#d.DEapellido2 as nombre
		from RHEmpleadoCurso ec
			inner join DatosEmpleado d
			on ec.DEid=d.DEid
			inner join RHCursos c
			on c.RHCid=ec.RHCid
			and c.RHECcobrar=1
		where ec.RHEMestado = 20
		and ec.RHEStatusCurso = 1
		and c.Ecodigo=#session.Ecodigo#
		<cfif isdefined('form.fdesde') and len(trim(form.fdesde)) gt 0>
			and c.RHCfdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fdesde#">
		</cfif>
		<cfif isdefined('form.fhasta') and len(trim(form.fhasta)) gt 0>
			and c.RHCfhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fhasta#">
		</cfif>		
		order by d.DEapellido1,d.DEapellido2,d.DEnombre
	</cfquery>
	
	<cfoutput>
		<table width="85%" align="center">
			<tr  class="tituloListas">
				<td>Identificación</td>
				<td>Nombre</td>
				<td>Monto</td>
				<cfif isdefined('LvarCant') and LvarCant gt 0>
					<td>Cantidad de Cuotas</td>
					<td>Monto de Cuota</td>
				</cfif>
			</tr>
		<cfloop query="rsRep">
			<tr>
				<td>#rsRep.DEidentificacion#</td>
				<td>#rsRep.nombre#</td>
				<td>#LSNumberFormat(rsRep.RHECtotempleado,',0.00')#</td>
				<cfif isdefined('LvarCant') and LvarCant gt 0>
					<td>#LSNumberFormat(rsRep.cant,',0.00')#</td>
					<td>#LSNumberFormat(rsRep.cuotas,',0.00')#</td>
				</cfif>
			</tr>
		</cfloop>
		</table>
	</cfoutput>


