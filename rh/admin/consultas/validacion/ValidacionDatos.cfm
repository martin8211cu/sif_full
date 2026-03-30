<cf_templatecss>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_PuestosPeso"
	Default="Pesos por Puesto"
	returnvariable="LB_PuestosPeso"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_PuestosCuestionarios"
	Default="Cuestionarios por Puesto"
	returnvariable="LB_PuestosCuestionarios"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_PuestosCuestionarioPesoHabilidad"
	Default="Puestos Cuestionario Peso Habilidad"
	returnvariable="LB_PuestosCuestionarioPesoHabilidad"/>	


<cffunction name="getCentrosFuncionalesDependientes" returntype="query">
	<cfargument name="cfid" required="yes" type="numeric">
	<cfset nivel = 1>
	<cfquery name="rs1" datasource="#session.dsn#">
		select CFid, #nivel# as nivel, null as CFidresp
		from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.cfid#">
	</cfquery>
	<cfquery name="rs2" datasource="#session.dsn#">
		select CFid, CFidresp
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfloop condition="1 eq 1">
		<cfquery name="rs3" dbtype="query">
			select rs2.CFid, #nivel# + 1 as nivel, rs2.CFidresp
			from rs1, rs2
			where rs1.nivel = #nivel#
			   and rs2.CFidresp = rs1.cfid
		</cfquery>
		<cfif rs3.RecordCount gt 0>
			<cfset nivel = nivel + 1>
			<cfquery name="rs0" dbtype="query">
				select CFid, nivel, CFidresp from rs1
				union
				select CFid, nivel, CFidresp from rs3
			</cfquery>
			<cfquery name="rs1" dbtype="query">
				select * from rs0
			</cfquery>
		<cfelse>
			<cfbreak>
		</cfif>
	</cfloop>
	<cfreturn rs1>
</cffunction>

<cfif isdefined("url.CFid") and len(trim(url.CFid)) >
	<cfif isdefined("url.dependencias") >
		<cfset cf = getCentrosFuncionalesDependientes(url.CFid) >
		<cfset cf_lista = valuelist(cf.CFid) >
	<cfelse>
		<cfset cf_lista = url.CFid >
	</cfif>
</cfif>

<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<cf_tabs width="100%">
					<cf_tab text="#LB_PuestosPeso#" selected="true">
						<cfinclude template="ValidacionPuestosPeso.cfm"> 
					</cf_tab>
					<cf_tab text="#LB_PuestosCuestionarios#" >
						 <cfinclude template="ValidacionTipos.cfm">
					</cf_tab>
					<cf_tab text="#LB_PuestosCuestionarioPesoHabilidad#" >
						<cfinclude template="ValidacionPCuestionario.cfm">
					</cf_tab>
				</cf_tabs>		
			</td>
		</tr>
	</table>
</cfoutput>