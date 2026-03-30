
<cfset lvarReturn = "">

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_interno" Default="Int." returnvariable="LB_interno">
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Externo" Default="Ext." returnvariable="LB_Externo">

<cfif isdefined('form.GetConcursantes')>
	<cfquery name="rsListaConcursantes" datasource="#session.DSN#">							
		select a.RHCPid, b.DEidentificacion as identificacion, case a.RHCPtipo when 'I' then '#LB_interno#' else '#LB_Externo#' end as tipo, {fn concat(b.DEapellido1,{fn concat(' ',{fn concat(b.DEapellido2,{fn concat(', ',b.DEnombre)})})})} as Nombre, b.DEemail as email, a.DEid
		from RHConcursantes a
		inner join DatosEmpleado b
	    	on a.DEid = b.DEid
	    	<!---and a.Ecodigo = b.Ecodigo--->
		where a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
			<cfif isDefined("form.opcion")>
				<cfif form.opcion eq 2>
					and a.RHCdescalifica = 1
				<cfelseif form.opcion eq 3>	
					and a.DEid not in (select DEid 
										from RHAdjudicacion 
										where Ecodigo = a.Ecodigo 
										and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
									)
					and a.RHCdescalifica = 0
				<cfelseif form.opcion eq 4>	
					and a.DEid in (select DEid 
										from RHAdjudicacion 
										where Ecodigo = a.Ecodigo 
										and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
									)
					and a.RHCdescalifica = 0
				</cfif>
			</cfif>

		union
		select a.RHCPid, b.RHOidentificacion as identificacion, case a.RHCPtipo when 'I' then '#LB_interno#' else '#LB_Externo#' end as tipo, {fn concat(b.RHOapellido1,{fn concat(' ',{fn concat(b.RHOapellido2,{fn concat(', ',b.RHOnombre)})})})} as Nombre, b.RHOemail as email, a.DEid
		from RHConcursantes a
		inner join DatosOferentes b
			on b.RHOid = a.RHOid
			<!---and b.Ecodigo = a.Ecodigo--->
		where a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
			<cfif isDefined("form.opcion")>
				<cfif form.opcion eq 2>
					and a.RHCdescalifica = 1
				<cfelseif form.opcion eq 3>	
					and a.DEid not in (select DEid 
										from RHAdjudicacion 
										where Ecodigo = a.Ecodigo 
										and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
									)
					and a.RHCdescalifica = 0
				</cfif>
			</cfif>
		order by 2, 3
	</cfquery>

	<cfset lvarReturn = serializeJSON(rsListaConcursantes)>
</cfif>	

<cfoutput>#lvarReturn#</cfoutput>