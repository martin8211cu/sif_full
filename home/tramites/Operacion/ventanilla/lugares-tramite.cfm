<!--- Instituciones donde puede realizar el requisito --->
<cfquery datasource="#session.tramites.dsn#" name="tramit_info">
	select id_tramite
	from TPInstanciaTramite
	where id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_instancia#">
</cfquery>
<cfquery name="data" datasource="#session.tramites.dsn#">
	select i.id_inst, ir.id_objeto as id_requisito, i.codigo_inst, i.nombre_inst
	from TPPermiso  ir
	
	inner join TPInstitucion i
	on i.id_inst = ir.id_sujeto
	
	where ir.id_objeto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#tramit_info.id_tramite#">
	  and ir.tipo_objeto = 'T'
	  and ir.tipo_sujeto = 'I'
	  and (ir.puede_capturar = 1 or ir.puede_modificar = 1)

	<!--- 4. Tipo de Institucion del Funcionario puede procesar el requisito --->
	union

	select i.id_inst, ir.id_objeto as id_requisito, i.codigo_inst, i.nombre_inst
	from TPPermiso  ir
	
	inner join TPRTipoInst ti
	on ti.id_tipoinst = ir.id_sujeto
	
	inner join TPInstitucion i
	on i.id_inst = ti.id_inst
	
	where ir.id_objeto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#tramit_info.id_tramite#">
	  and ir.tipo_objeto = 'T'
	  and ir.tipo_sujeto = 'T'
	  and (ir.puede_capturar = 1 or ir.puede_modificar = 1)
	
	order by 2
</cfquery>

<!---
<!--- Averigua la sucursal donde esta el funcionario --->
<cfquery name="institucion" datasource="#session.tramites.dsn#" maxrows="1">
	select v.id_sucursal, s.nombre_sucursal, s.id_inst, i.nombre_inst
	from TPVentanilla v
	inner join TPSucursal s
	on s.id_sucursal=v.id_sucursal
	inner join TPInstitucion i
	on i.id_inst=s.id_inst
	where id_ventanilla = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_ventanilla#">
</cfquery>

<cfif institucion.recordcount gt 0 >
	<!--- otras ventanillas de la sucursal --->
	<cfquery name="ventanillas" datasource="#session.tramites.dsn#">
		select 	f.id_persona,
				p.nombre || ' ' || apellido1 || ' ' || apellido2 as nombre,
				f.id_funcionario, 
				v.id_ventanilla, 
				v.id_sucursal, 
				v.codigo_ventanilla, 
				v.nombre_ventanilla  
		from TPRFuncionarioVentanilla fv
		
		inner join TPVentanilla v
		on v.id_ventanilla=fv.id_ventanilla
		and id_sucursal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#institucion.id_sucursal#">
		
		inner join TPFuncionario f
		on f.id_funcionario=fv.id_funcionario
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between f.vigente_desde and f.vigente_hasta
		and id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#institucion.id_inst#"> 
		
		inner join TPPersona p
		on p.id_persona=f.id_persona 
		
		where v.id_ventanilla <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_ventanilla#"> 
	</cfquery>
</cfif>
--->

<table width="100%" border="0" cellpadding="2" cellspacing="0">
	<!---
	<cfif isdefined("ventanillas") and ventanillas.recordcount gt 0>
		<tr>
			<td colspan="2" bgcolor="#ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black; "><strong>Otras ventanillas donde puede realizar el tr&aacute;mite </strong></td>
		<cfoutput query="ventanillas" group="nombre">
			<tr class="<cfif ventanillas.currentrow mod 2>listaPar<cfelse>listaNon</cfif>" >
				<td>#ventanillas.nombre#</td>
				<td >#ventanillas.nombre_ventanilla#</td>
			</tr>
			<cfset pintar = false >
			<cfoutput>
				<cfif pintar >
				<tr class="<cfif ventanillas.currentrow mod 2>listaPar<cfelse>listaNon</cfif>" >
					<td></td>
					<td >#ventanillas.nombre_ventanilla#</td>		
				</tr>
				</cfif>
				<cfset pintar = true >
			</cfoutput>
		</cfoutput>
	</cfif>

	<tr><td>&nbsp;</td></tr>
	--->
	<cfset instituciones = valuelist( data.id_inst )>
	<cfif len(trim(instituciones))>
		<cfquery name="datos" datasource="#session.tramites.dsn#">
			select i.nombre_inst, nombre_sucursal
			from TPSucursal s
			inner join TPInstitucion i
			on i.id_inst=s.id_inst
			where s.id_inst in ( #instituciones# )
			order by 1, 2
		</cfquery>
	</cfif>
	
	<tr>
	<td colspan="2" bgcolor="#ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black; "><strong>Instituciones y Sucursales donde puede realizar el tr&aacute;mite </strong></td>
	<cfif isdefined("datos") and datos.recordcount gt 0>
		<!---
		<cfloop query="data">
			<tr class="<cfif data.currentrow mod 2>listaPar<cfelse>listaNon</cfif>" >
				<td colspan="2" >#data.nombre_inst#</td>
			</tr>
		</cfloop>
		--->
		
		<cfoutput query="datos" group="nombre_inst">
			<tr bgcolor="##E6E6E6"  ><td colspan="2" ><strong>#datos.nombre_inst#</strong></td></tr>
			<cfset i = 0 >
			<cfoutput>
				<tr class="<cfif i mod 2>listaPar<cfelse>listaNon</cfif>" ><td colspan="2" style="padding-left: 10px; " >#datos.nombre_sucursal#</td></tr>
				<cfset i = i + 1 >
			</cfoutput>
		</cfoutput>
		
	<cfelse>
		<tr>
			<td style="font-size:12px" >No se encontraron registros</td>
		</tr>
	</cfif>
	<tr><td>&nbsp;</td></tr>
	<!---
	<cfquery name="identificacion" datasource="#session.tramites.dsn#">
		select id_tipoident, identificacion_persona
		from TPPersona
		where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">
	</cfquery>
	--->
</table>
</script>
