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
	select 	pu.RHPcodigo, 
			coalesce(RHPcodigoext,pu.RHPcodigo) as RHPcodigoext,
			pu.RHPdescpuesto, 
			case pu.RHPactivo when 1 then '#LB_Activo#'
							else '#LB_Inactivo#'
			end as Estado,
			tp.RHTPid,
			{fn concat(ltrim(rtrim(tp.RHTPcodigo)),{fn concat(' - ',ltrim(rtrim(tp.RHTPdescripcion)))})} as TipoPuesto,
			pu.BMfecha,
			(select count(1)
			 from RHPuestos p
			 where p.RHTPid = tp.RHTPid
			    and p.Ecodigo = tp.Ecodigo) as cantidad 	

	from RHPuestos pu
		inner  join RHTPuestos tp
			on pu.RHTPid = tp.RHTPid
			<!---Filtro de tipo de puesto---->							
			<cfif isdefined("url.RHTPcodigo_desde") and len(trim(url.RHTPcodigo_desde)) and isdefined("url.RHTPcodigo_hasta") and len(trim(url.RHTPcodigo_hasta))>
				<cfif url.RHTPcodigo_hasta EQ url.RHTPcodigo_desde>
					and tp.RHTPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.RHTPcodigo_desde#">
				<cfelseif url.RHTPcodigo_hasta GT url.RHTPcodigo_desde>
					and tp.RHTPcodigo between <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.RHTPcodigo_desde#">
									  and <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.RHTPcodigo_hasta#">
				<cfelse>
					and tp.RHTPcodigo between <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.RHTPcodigo_hasta#"> 
									  and <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.RHTPcodigo_desde#">
				</cfif> 
			<cfelseif isdefined("url.RHTPcodigo_desde") and len(trim(url.RHTPcodigo_desde)) and not isdefined("url.RHTPcodigo_hasta") or len(trim(url.RHTPcodigo_hasta)) EQ 0>
				and tp.RHTPcodigo >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.RHTPcodigo_desde#">
			<cfelseif isdefined("url.RHTPcodigo_hasta") and len(trim(url.RHTPcodigo_hasta)) and not isdefined("url.RHTPcodigo_desde") or len(trim(url.RHTPcodigo_desde)) EQ 0>
				and tp.RHTPcodigo <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.RHTPcodigo_hasta#">
			</cfif>

	where pu.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif isdefined('url.RHPactivo') and url.RHPactivo GTE 0>
		and pu.RHPactivo = <cfqueryparam cfsqltype="cf_sql_bit" value="#url.RHPactivo#">
	</cfif>
	order by RHTPcodigo, tp.RHTPdescripcion, pu.RHPcodigo, pu.RHPdescpuesto
</cfquery>
<cfreport format="#url.formato#" template= "PuestosPorTipo.cfr" query="rsDatos">
	<cfreportparam name="Edescripcion" value="#session.enombre#">
</cfreport>
