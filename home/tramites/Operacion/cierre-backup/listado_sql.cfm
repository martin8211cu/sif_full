<!--- 
	Creado por Gustavo Fonseca Hernández.
		Fecha: 10-8-2005.
		Motivo: Nuevo porlet de Cierre de trámites.
 --->

<!--- <cfdump var="#form#">
 <cfdump var="#url#">
 <cf_dump var="#session#">
 --->

<cfif isdefined("Form.chk")>
	<cfset pagos = #ListToArray(Form.chk, ',')#>
	<cfloop index="Lvar_id_instancia" list="#Form.chk#" delimiters=",">
		<cfset LvarTPInstanciaTramite = #ListToArray(Lvar_id_instancia, "|")#>
		<cfset LvarPos1 = LvarTPInstanciaTramite[1]>
		<cftransaction>
			<cfquery datasource="#session.tramites.dsn#">
				update TPInstanciaTramite
					set completo = 1,
						id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#">,
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
						BMfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					where id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1#">
			</cfquery>
		</cftransaction>
	</cfloop>
</cfif>

<cflocation url="/cfmx/home/tramites/Operacion/cierre/listado_form.cfm">