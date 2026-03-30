<!--- 1. Lee informacion de flujo del requisito --->
<cfquery name="flujo" datasource="#session.tramites.dsn#">
	select modo_flujo, id_requisito_flujo
	from TPRReqTramite
	where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia.id_requisito#">
	and id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia.id_tramite#">
</cfquery>

<!--- Solo se trabaja el modo manual, pues es el unico que pide seleccionar un funcionario --->
<cfif flujo.modo_flujo eq 'M'>
	<cfset flujo_ventanilla = CreateObject('Component', 'home.tramites.componentes.ventanilla') >
	<cfset rsAbiertas = flujo_ventanilla.ventanillas_abiertas( session.tramites.id_sucursal ) > 

	<!--- Funcionarios de la misma sucursal --->
	<cfquery name="ventanillas" datasource="#session.tramites.dsn#">
		select f.id_funcionario, v.codigo_ventanilla, v.nombre_ventanilla, p.nombre, p.apellido1, p.apellido2 
		from TPFuncionario f
		
		inner join TPRFuncionarioVentanilla fv
		on fv.id_funcionario=f.id_funcionario
		<cfif rsAbiertas.recordcount gt 0>
			and fv.id_ventanilla in ( #valuelist(rsAbiertas.id_ventanilla)# )
		<cfelse>
			and fv.id_ventanilla = 0
		</cfif>
		
		inner join TPVentanilla v
		on v.id_ventanilla=fv.id_ventanilla
		and v.id_sucursal=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_sucursal#">
		
		inner join TPSucursal s
		on s.id_sucursal = v.id_sucursal
		
		inner join TPPersona p
		on p.id_persona=f.id_persona
		
		where f.id_inst=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_inst#">
		and f.id_funcionario != <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#">
	</cfquery>

	<!--- NO ME GUSTA ESTO, TALVEZ SERIA MEJOR UNA FUNCION QUE ME DEVUELVA LOS
	      FUNCIONARIOS, PARA SUCURSAL/INSTITUCION ESPECIFICOS, QUE TIENEN PERMISO
		  PARA VER UN REQUISITO EN ESPECIAL. ASI ME EVITO ESTE CICLO, QUE HACE LO MISMO
		  PERO VA FUNC. POR FUNC. VIENDO PERMISOS  --->
	<!--- *** FALTA VALIDAR QU ELA VENTANILLA ESTE ABIERTA --->		  
		  
	<cfset flujo_tramite = CreateObject('Component', 'home.tramites.componentes.tramites') >
	<cfset flujo_lista = '' >
	<cfloop query="ventanillas">
		<cfif flujo_tramite.permisos_obj(ventanillas.id_funcionario, instancia.id_requisito, 'R') >
			<cfset flujo_lista = ListAppend(flujo_lista, ventanillas.id_funcionario ) >
		</cfif>
	</cfloop>
	<cfif len(trim(flujo_lista)) >
		<cfquery name="flujo_ventanillas" dbtype="query">
			select *
			from ventanillas
			where id_funcionario in ( #flujo_lista# )
		</cfquery>
	</cfif>

	<cfoutput>
	<table cellpadding="0" cellspacing="0">
		<tr>
			<td>Funcionario:&nbsp;</td>
			<td>
				<select name="id_funcionario_flujo">
					<option value="">-seleccionar-</option>
					<cfif isdefined("flujo_ventanillas")>
						<cfloop query="flujo_ventanillas">
							<option value="#flujo_ventanillas.id_funcionario#">#flujo_ventanillas.nombre# #flujo_ventanillas.apellido1# #flujo_ventanillas.apellido2# </option>
						</cfloop>
					</cfif>
				</select>
			</td>
		</tr>
	</table>
	</cfoutput>
</cfif>
<cfoutput>
<input type="hidden" name="modo_flujo" value="#flujo.modo_flujo#">
<input type="hidden" name="id_requisito_flujo" value="#flujo.id_requisito_flujo#">
</cfoutput>