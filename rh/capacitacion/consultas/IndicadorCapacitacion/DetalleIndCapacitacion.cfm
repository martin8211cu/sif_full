<cfset R_RHPcodigo = #RHPcodigo#>

<cfset Faltante_empleado = 0>
<cfset PuntuacionFinal = 0>
<cfset TotalidadPuesto = 0>
<cfset Cpuntos_a_sumar = 0>
<cfset Porcentaje_Actual = 0>
<cfset Porcentaje_Faltante =0>

<cfquery name="desc_puesto" datasource="#session.DSN#">
Select coalesce(ltrim(rtrim(RHPcodigoext)),ltrim(rtrim(RHPcodigo))) as RHPcodigo,RHPdescpuesto 
from RHPuestos
where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#R_RHPcodigo#">
  and Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

<!--- Competencias requeridas del puesto --->
<!--- ********************************** --->

<cfquery name="habilidades_requeridas" datasource="#session.DSN#">
	select a.RHHid, b.RHHcodigo, b.RHHdescripcion, coalesce(a.RHNnotamin,0)*100 as nota
	from RHHabilidadesPuesto a
	
	inner join RHHabilidades b
	on a.Ecodigo=b.Ecodigo
	and a.RHHid=b.RHHid
	
	where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#R_RHPcodigo#">
	  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	order by b.RHHcodigo
</cfquery>
<cfset habilidades_puesto = valuelist(habilidades_requeridas.RHHid)>


<cfquery name="conocimientos_requeridos" datasource="#session.DSN#">
	select a.RHCid, b.RHCcodigo, b.RHCdescripcion, coalesce(a.RHCnotamin,0)*100 as nota
	from RHConocimientosPuesto a
	
	inner join RHConocimientos b
	on a.Ecodigo=b.Ecodigo
	and a.RHCid=b.RHCid
	
	where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#R_RHPcodigo#">
   	  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	order by b.RHCcodigo
</cfquery>
<cfset conocimientos_puesto = valuelist(conocimientos_requeridos.RHCid)>

<!--- Competencias requeridas del puesto --->
<!--- ********************************** --->


<!--- Empleados que estan compitiendo por el puesto --->
<!--- ********************************************* --->

<cfquery name="Empleados_para_puesto" datasource="#session.DSN#">
select lt.RHPcodigo, d.DEidentificacion, 
<cf_dbfunction name="concat" args="d.DEnombre,' ',d.DEapellido1,'  ',d.DEapellido2"> as DEnombre, lt.DEid, p.CFid, p.RHPdescripcion, c.CFdescripcion
from LineaTiempo lt

inner join RHPlazas p
 on p.Ecodigo=lt.Ecodigo
 and p.RHPid=lt.RHPid
 
 inner join CFuncional c
  on p.Ecodigo = c.Ecodigo
  and p.CFid = c.CFid

 inner join DatosEmpleado d
  on  lt.Ecodigo = d.Ecodigo
  and lt.DEid    = d.DEid

where getdate() between lt.LTdesde and lt.LThasta 
  and lt.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
  and lt.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#R_RHPcodigo#">
</cfquery>

<!--- Empleados que estan compitiendo por el puesto --->
<!--- ********************************************* --->

<table cellspacing=0 cellpadding=0 border=0 width=100%>
<tr><td><td></tr>
<tr>
        <td colspan="5" class="tituloListas">Evaluaci&oacute;n de Empleados por porcentaje</td>
</tr>
<tr><td><td></tr>
<tr>
	<td>&nbsp;</td>
	<td><strong>C&eacute;dula</strong></td>
	<td><strong>Nombre</strong></td>
	<td><strong>Actual (%)</strong></td>
	<td><strong>Falta  (%)</strong></td>
</tr>
<cfoutput query="Empleados_para_puesto">

	<cfset idempleado = #DEid#>

	<!--- Competencias del puesto que posee el colaborador --->
	<!--- ************************************************ --->
	<cfif isdefined("habilidades_puesto") and  len(trim(habilidades_puesto))>
		<cfquery name="habilidades_poseidas" datasource="#session.DSN#">
			select a.idcompetencia, b.RHHcodigo, b.RHHdescripcion, a.RHCEdominio as nota
			from RHCompetenciasEmpleado a
			
			inner join RHHabilidades b
			on a.Ecodigo=b.Ecodigo
			and a.idcompetencia=b.RHHid
			
			where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#idempleado#">
			and tipo='H'
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between RHCEfdesde and RHCEfhasta
			and idcompetencia in (#habilidades_puesto#)
		</cfquery>
		<cfset habilidades_posee = valuelist(habilidades_poseidas.idcompetencia) >
	</cfif>

	<cfif  isdefined("conocimientos_puesto") and len(trim(conocimientos_puesto))>
		<cfquery name="conocimientos_poseidos" datasource="#session.DSN#">
			select a.idcompetencia, b.RHCcodigo, b.RHCdescripcion, a.RHCEdominio as nota
			from RHCompetenciasEmpleado a
			
			inner join RHConocimientos b
			on a.Ecodigo=b.Ecodigo
			and a.idcompetencia=b.RHCid
			
			where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#idempleado#">
			and tipo='C'
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between RHCEfdesde and RHCEfhasta
			and idcompetencia in (#conocimientos_puesto#)
		</cfquery>
		<cfset conocimientos_posee = valuelist(conocimientos_poseidos.idcompetencia) >
	</cfif>

	<!--- Competencias del puesto que posee el colaborador --->
	<!--- ************************************************ --->


	<!--- Competencias del puesto que no posee el colaborador --->
	<!--- *************************************************** --->
	<!---

	<cfquery name="habilidades_no_poseidas" datasource="#session.DSN#">
		select SUM(coalesce(a.RHNnotamin,0)*100) as HPuntos_Menos <!--- a.RHHid, b.RHHcodigo, b.RHHdescripcion, coalesce(a.RHNnotamin,0)*100 as nota --->
		from RHHabilidadesPuesto a
		
		inner join RHHabilidades b
		on a.Ecodigo=b.Ecodigo
		and a.RHHid=b.RHHid
		
		where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#R_RHPcodigo#">
		  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and a.RHHid not in (#habilidades_posee#)
	</cfquery>

	<cfquery name="conocimientos_no_poseidos" datasource="#session.DSN#">
		select SUM(coalesce(a.RHCnotamin,0)*100) as CPuntos_Menos
		from RHConocimientosPuesto a
		
		inner join RHConocimientos b
		on a.Ecodigo=b.Ecodigo
		and a.RHCid=b.RHCid
		
		where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#R_RHPcodigo#">
		  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and a.RHHid not in (#conocimientos_posee#)
	</cfquery>

	--->
	<!--- Competencias del puesto que no posee el colaborador --->
	<!--- *************************************************** --->


	<!--- Inicia el proceso de cálculo para saber cuanto porcentaje tiene el empleado sumando las habilidades que tiene --->
	<!--- ************************************************************************************************************* --->
	<cfset puntos_a_sumar = 0>
	<cfif isdefined("habilidades_poseidas") and habilidades_poseidas.recordcount gt 0>
				

		<!--- Calcula los puntos de acuerdo a las notas que obtuvo el empleado --->
		<cfloop query="habilidades_poseidas">

			<cfset notaobtenida = #nota#>
			<cfset Chabilidad = #idcompetencia#>

			<cfquery name="H_Puntos_Sumados" datasource="#session.DSN#">
			select coalesce(a.RHNnotamin,0)*100 as nota_minima
			from RHHabilidadesPuesto a	
			inner join RHHabilidades b
			on a.Ecodigo=b.Ecodigo
			and a.RHHid=b.RHHid
			where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#R_RHPcodigo#">
			  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and b.RHHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Chabilidad#">			
			</cfquery>

			<cfloop query="H_Puntos_Sumados">
				<cfset notamin = #nota_minima#>
				<cfif notaobtenida gte notamin>
					<!--- Obtuvo el 100% --->
					<cfset puntos_a_sumar = puntos_a_sumar + notamin>
				<cfelse>
					<!--- Obtuvo menos de lo requerido --->
					<cfset puntos_a_sumar = puntos_a_sumar + notaobtenida>
				</cfif>

			</cfloop>

		</cfloop>

	</cfif>

	<cfset Cpuntos_a_sumar = 0>	
	<cfif isdefined("conocimientos_poseidos") and conocimientos_poseidos.recordcount gt 0>

		
		<!--- Calcula los puntos de acuerdo a las notas que obtuvo el empleado --->
		<cfloop query="conocimientos_poseidos">

			<cfset notaobtenida = #nota#>
			<cfset Chabilidad = #idcompetencia#>

			<cfquery name="C_Puntos_Sumados" datasource="#session.DSN#">
			select coalesce(a.RHCnotamin,0)*100 as nota_minima
			from RHConocimientosPuesto a	
				inner join RHConocimientos b
				on a.Ecodigo=b.Ecodigo
				and a.RHCid=b.RHCid	
			where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#R_RHPcodigo#">
			  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and b.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Chabilidad#">				
			</cfquery>

			<cfloop query="C_Puntos_Sumados">
				<cfset notamin = #nota_minima#>
				<cfif notaobtenida gte notamin>
					<!--- Obtuvo el 100% --->
					<cfset Cpuntos_a_sumar = Cpuntos_a_sumar + notamin>
				<cfelse>
					<!--- Obtuvo menos de lo requerido --->
					<cfset Cpuntos_a_sumar = Cpuntos_a_sumar + notaobtenida>
				</cfif>

			</cfloop>

		</cfloop>


	</cfif>

	<!--- Finaliza el proceso de cálculo para saber cuanto porcentaje tiene el empleado sumando las habilidades que tiene --->
	<!--- *************************************************************************************************************** --->


	<!--- Totaliza lo que requiere el puesto --->
	<!--- ********************************** --->

	<cfset TotalidadPuesto = 0>
	<cfloop query="habilidades_requeridas">
		<cfset TotalidadPuesto = TotalidadPuesto + #nota#>
	</cfloop>
	<cfloop query="conocimientos_requeridos">
		<cfset TotalidadPuesto = TotalidadPuesto + #nota#>
	</cfloop>

	<!--- Totaliza lo que requiere el puesto --->
	<!--- ********************************** --->

	<!--- Calcula la totalidad de puntos del empleado y el faltante --->
	<!--- ********************************************************* --->
	<cfset PuntuacionFinal = Cpuntos_a_sumar + puntos_a_sumar>
	<cfset Faltante_empleado = TotalidadPuesto - PuntuacionFinal>

	<!--- Calcula la totalidad de puntos del empleado y el faltante --->
	<!--- ********************************************************* --->


	<!--- Conversion a porcentajes de los resultados --->
	<!--- ****************************************** --->
	<cfif TotalidadPuesto EQ 0>
		<cfset TotalidadPuesto = 1>
	</cfif>

	<cfset Porcentaje_Actual = (PuntuacionFinal * 100) / TotalidadPuesto>
	<cfset Porcentaje_Faltante = (Faltante_empleado * 100) / TotalidadPuesto>

	<!--- Conversion a porcentajes de los resultados --->
	<!--- ****************************************** --->


	<!--- Despliegue de los datos --->

	<tr>
		<td>&nbsp;</td>
		<td>#DEidentificacion# </td>
		<td>#DEnombre#</td>
		<td>#round(Porcentaje_Actual)#%</td>
		<td>#round(Porcentaje_Faltante)#%</td>
	</tr>	

</cfoutput>
</table>