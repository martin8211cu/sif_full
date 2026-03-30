<cfif not isdefined("form.formato") >
	<cfset tipoformato = "html">
<cfelse>
	<cfset tipoformato = #form.formato#>
</cfif>

<cfif  isDefined("Form.Tcodigo1") and len(trim(form.Tcodigo1)) NEQ 0>
	<cfset Form.Tcodigo1=#Form.Tcodigo1#>
<cfelseif isDefined("Form.Tcodigo1") and len(trim(form.Tcodigo1)) EQ 0>
	<cfset Form.Tcodigo1='-'>
</cfif>

<cfif  isDefined("Form.Tcodigo2") and len(trim(form.Tcodigo2)) NEQ 0>
	<cfset Form.Tcodigo2=#Form.Tcodigo2#>
<cfelseif isDefined("Form.Tcodigo2") and len(trim(form.Tcodigo2)) EQ 0>
	<cfset Form.Tcodigo2='-'>
</cfif>

<cfif  isDefined("Form.CFid") and len(trim(form.CFid)) NEQ 0>
	<cfset Form.CFid=#Form.CFid#>
<cfelseif isDefined("Form.CFid") and len(trim(form.CFid)) EQ 0>
	<cfset Form.CFid=0>
</cfif>
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">

<cfquery name="rsSQL" datasource="#session.dsn#">
select 	c.Tcodigo, 
		c.Tdescripcion, 
		a.DEidentificacion, 
		a.DEapellido1 #LvarCNCT#
 ' ' #LvarCNCT#
 a.DEapellido2 #LvarCNCT#
 ', ' #LvarCNCT#
 a.DEnombre as Nombre, 
		convert(varchar,d.CFid) #LvarCNCT#
 ' - ' #LvarCNCT#
 e.CFdescripcion as CFuncional, 
		convert(varchar,d.RHPid) #LvarCNCT#
 ' - ' #LvarCNCT#
 d.RHPdescripcion as Puesto,
		convert(varchar,getdate(),103) as fecha,
		f.Ecodigo, 
		f.Edescripcion as Empresa,

		convert(varchar,(select max(DLfvigencia) 
		 from DLaboralesEmpleado dle	
			inner join RHTipoAccion ta
				on dle.RHTid=ta.RHTid
				and dle.Ecodigo=ta.Ecodigo
				and ta.RHTcomportam=1
		 where dle.DEid = a.DEid 
		 	and dle.Ecodigo = #session.Ecodigo#),103) as Ingreso,

		(select sum(la.DDLmontores) 
		 from DDLaboralesEmpleado la
		 	inner join ComponentesSalariales cs
   				on la.CSid = cs.CSid		
		 where la.DLlinea = (select max(dla.DLlinea) 
						 from DLaboralesEmpleado dla 
						 where dla.DEid = a.DEid
							and dla.DLffin = (	select max(dla.DLffin) 
											from DLaboralesEmpleado dla 
											where dla.DEid = a.DEid))) as Salario 

from DatosEmpleado a
	inner join LineaTiempo b
  		on a.DEid = b.DEid
		and (getdate() between b.LTdesde and b.LThasta)
	inner join TiposNomina c
	  	on a.Ecodigo = c.Ecodigo 
 		and b.Tcodigo = c.Tcodigo
  		and (c.Tcodigo between (case when '#Form.Tcodigo1#' = '-' then a.Tcodigo else '#Form.Tcodigo1#' end) 
			and (case when  '#Form.Tcodigo2#' = '-' then a.Tcodigo else '#Form.Tcodigo2#' end))
	inner join  RHPlazas d
		on d.RHPid = b.RHPid
	inner join CFuncional e
  		on d.CFid = e.CFid
		and e.CFid = (case when #form.CFid# = 0 then e.CFid else #form.CFid# end)
	inner join Empresas f
  		on a.Ecodigo =  f.Ecodigo

where a.Ecodigo = #session.Ecodigo#
order by b.Tcodigo, Nombre
</cfquery>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_titulo" Default="Consulta de Empleados Activos" returnvariable="LB_titulo"/>
<cfinvoke key="LB_Inicial" default="<b>Nómina Inicial</b>" returnvariable="LB_Inicial" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Final" default="<b>Nómina Final</b>" returnvariable="LB_Final" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_CF" default="<b>Centro Funcional</b>" returnvariable="LB_CF" component="sif.Componentes.Translate"  method="Translate"/>

<cfif isdefined ('form.Tcodigo1') and len(trim(form.Tcodigo1)) gt 0 and form.Tcodigo1 neq '-'>
	<cfquery name="rsTN1" datasource="#session.dsn#">
		select Tdescripcion from TiposNomina where Tcodigo='#form.Tcodigo1#'
	</cfquery>
</cfif>
<cfif isdefined ('form.Tcodigo2') and len(trim(form.Tcodigo2)) gt 0 and form.Tcodigo2 neq '-'>
	<cfquery name="rsTN2" datasource="#session.dsn#">
		select Tdescripcion from TiposNomina where Tcodigo='#form.Tcodigo2#'
	</cfquery>
</cfif>
<cfif isdefined ('form.CFid') and len(trim(form.CFid)) gt 0 and form.CFid neq 0>
	<cfquery name="rsCF" datasource="#session.dsn#">
		select CFdescripcion from CFuncional where CFid=#form.CFid#
	</cfquery>
</cfif>

<cfif isdefined ('rsTN1') and len(trim(rsTN1.Tdescripcion)) gt 0>
	<cfset filtro1 = LB_Inicial&': #rsTN1.Tdescripcion# '>
<cfelse>
	<cfset filtro1 =''>
</cfif>
<cfif isdefined ('rsTN2') and len(trim(rsTN2.Tdescripcion)) gt 0>
	<cfset filtro2 = LB_Final&': #rsTN2.Tdescripcion# '>
<cfelse>
	<cfset filtro2 =''>
</cfif>
<cfif isdefined ('rsCF') and len(trim(rsCF.CFdescripcion)) gt 0>
	<cfset filtro3 = LB_CF&': #rsCF.CFdescripcion#'>
<cfelse>
	<cfset filtro3 =''>
</cfif>



	<cf_htmlReportsHeaders
		irA="ConsultaEmpleados.cfm"
		FileName="EmpleadosActivos#session.Usuario#_#lsdateformat(now(),'yyyymmdd')#.xls"
		title="Consulta de Empleados Activos">
		
	<cf_EncReporte
		Titulo="#LB_titulo#"
		Color="##E3EDEF"
		filtro1="#filtro1#"
		filtro2="#filtro2#"
		filtro3="#filtro3#"
		Cols= 11>
  
<table>
	<tr bgcolor="CCCCCC">
		<td><strong>Identificación</strong></td>
		<td><strong>Nombre</strong></td>
		<td><strong>Nomina</strong></td>
		<td><strong>Centro Funcional</strong></td>
		<td><strong>Fecha de Ingreso</strong></td>
		<td><strong>Puesto</strong></td>
		<td><strong>Salario</strong></td>
	</tr>
	<cfloop query="rsSQL">
	<cfoutput>
		<tr>
			<td>#rsSQL.DEidentificacion#</td>
			<td>#rsSQL.Nombre#</td>
			<td>#rsSQL.Tcodigo#-#rsSQL.Tdescripcion#</td>
			<td>#rsSQL.CFuncional#</td>
			<td>#rsSQL.Ingreso#</td>
			<td>#rsSQL.Puesto#</td>
			<td align="left">#NumberFormat(rsSQL.Salario,",0.00")#</td>
		</tr>
	</cfoutput>
	</cfloop>
</table>














