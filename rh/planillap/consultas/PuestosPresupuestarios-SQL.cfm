<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Activo"
	Default="Activo"
	returnvariable="LB_Activo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Inactivo"
	Default="Inactivo"
	returnvariable="LB_Inactivo"/>
 

<cfquery name="rsDatos" datasource="#session.DSN#">
	select 
		{fn concat(ltrim(rtrim(coalesce(pu.RHPcodigoext,pu.RHPcodigo))),{fn concat(' - ',ltrim(rtrim(pu.RHPdescpuesto)))})} as PuestoRH, 
		case pu.RHPactivo when 1 then '#LB_Activo#' else '#LB_Inactivo#' end as Estado,
		pu.BMfecha,
		{fn concat(ltrim(rtrim(pp.RHMPPcodigo)),{fn concat(' - ',ltrim(rtrim(pp.RHMPPdescripcion)))})} as PuestoP,
		pp.RHMPPid,
		(select count(1)
		 from RHPuestos p
		 where p.RHMPPid = pp.RHMPPid
		   and p.Ecodigo = pp.Ecodigo) as cantidad 	

	from RHPuestos pu
		inner join RHMaestroPuestoP pp
			on pu.RHMPPid = pp.RHMPPid 
			<!---Filtro de tipo de puesto---->							
			<cfif isdefined("url.RHMPPcodigo_desde") and len(trim(url.RHMPPcodigo_desde)) and isdefined("url.RHMPPcodigo_hasta") and len(trim(url.RHMPPcodigo_hasta))>
				<cfif url.RHMPPcodigo_hasta EQ url.RHMPPcodigo_desde>
					and pp.RHMPPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.RHMPPcodigo_desde#">
				<cfelseif url.RHMPPcodigo_hasta GT url.RHMPPcodigo_desde>
					and pp.RHMPPcodigo between <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.RHMPPcodigo_desde#">
									  and <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.RHMPPcodigo_hasta#">
				<cfelse>
					and pp.RHMPPcodigo between <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.RHMPPcodigo_hasta#"> 
									  and <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.RHMPPcodigo_desde#">
				</cfif> 
			<cfelseif isdefined("url.RHMPPcodigo_desde") and len(trim(url.RHMPPcodigo_desde)) and not isdefined("url.RHMPPcodigo_hasta") or len(trim(url.RHMPPcodigo_hasta)) EQ 0>
				and pp.RHMPPcodigo >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.RHMPPcodigo_desde#">
			<cfelseif isdefined("url.RHMPPcodigo_hasta") and len(trim(url.RHMPPcodigo_hasta)) and not isdefined("url.RHMPPcodigo_desde") or len(trim(url.RHMPPcodigo_desde)) EQ 0>
				and pp.RHMPPcodigo <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.RHMPPcodigo_hasta#">
			</cfif>
			
	where pu.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by pp.RHMPPcodigo, pu.RHPcodigo, pp.RHMPPdescripcion,  pu.RHPdescpuesto
</cfquery>


<cfreport format="#url.formato#" template= "PuestosPresupuestarios.cfr" query="rsDatos">
	<cfreportparam name="Edescripcion" value="#session.enombre#">
</cfreport>
