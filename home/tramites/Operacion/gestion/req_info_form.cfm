<cfinclude template="payment_header.cfm">

<cfquery name="data" datasource="#session.tramites.dsn#">
	select i.id_inst, ir.id_objeto as id_requisito, i.codigo_inst, i.nombre_inst
	from TPPermiso /*TPRInstitucionReq*/ ir
	
	inner join TPInstitucion i
	on i.id_inst = ir.id_sujeto
	
	where ir.id_objeto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_requisito#">
	  and ir.tipo_objeto = 'R'
	  and ir.tipo_sujeto = 'I'

	<!--- 4. Tipo de Institucion del Funcionario puede procesar el requisito --->
	union

	select i.id_inst, ir.id_objeto as id_requisito, i.codigo_inst, i.nombre_inst
	from TPPermiso /*TPRTipoInstReq*/ ir
	
	inner join TPRTipoInst ti
	on ti.id_tipoinst = ir.id_sujeto
	
	inner join TPInstitucion i
	on i.id_inst = ti.id_inst
	
	where ir.id_objeto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_requisito#">
	  and ir.tipo_objeto = 'R'
	  and ir.tipo_sujeto = 'T'
	
	order by 2
</cfquery>

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

<table width="100%" border="0" cellpadding="2" cellspacing="0">
	<cfif isdefined("ventanillas") and ventanillas.recordcount gt 0>
		<tr><td bgcolor="#ECE9D8" colspan="2" style="padding:3px; font-size:14px;"><strong>Otras ventanillas donde puede realizar el requisito</strong></td></tr>	
		<cfoutput query="ventanillas" group="nombre">
			<tr class="<cfif ventanillas.currentrow mod 2>listaPar<cfelse>listaNon</cfif>" >
				<td style="font-size:14px">#ventanillas.nombre#</td>
				<td style="font-size:14px">#ventanillas.nombre_ventanilla#</td>
			</tr>
			<cfset pintar = false >
			<cfoutput>
				<cfif pintar >
				<tr class="<cfif ventanillas.currentrow mod 2>listaPar<cfelse>listaNon</cfif>" >
					<td></td>
					<td style="font-size:14px">#ventanillas.nombre_ventanilla#</td>		
				</tr>
				</cfif>
				<cfset pintar = true >
			</cfoutput>
		</cfoutput>
	</cfif>

	<tr><td>&nbsp;</td></tr>

	<cfoutput>
	<tr><td bgcolor="##ECE9D8" colspan="2" style="padding:3px; font-size:14px;"><strong>Instituciones donde puede realizar el requisito</strong></td></tr>	
	<cfif data.recordcount gt 0>
		<cfloop query="data">
			<tr class="<cfif data.currentrow mod 2>listaPar<cfelse>listaNon</cfif>" >
				<td colspan="2" style="font-size:14px"><a href="req_info_sucursal.cfm?id_inst=#data.id_inst#&id_persona=#url.id_persona#&id_requisito=#url.id_requisito#&id_tramite=#url.id_tramite#">#data.nombre_inst#</a></td>
			</tr>
		</cfloop>
	<cfelse>
		<tr>
			<td style="font-size:12px" >No se encontraron registros</td>
		</tr>
	</cfif>
	</cfoutput>
	<tr><td>&nbsp;</td></tr>
	<cfquery name="identificacion" datasource="#session.tramites.dsn#">
		select id_tipoident, identificacion_persona
		from TPPersona
		where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#">
	</cfquery>
	<cfoutput>
	<tr><td><input type="button" name="Regresar" value="Regresar" onClick="javascript:location.href='gestion-form.cfm?id_instancia=#url.id_instancia#&id_persona=#url.id_persona#&id_requisito=#url.id_requisito#&id_tramite=#url.id_tramite#&identificacion_persona=#identificacion.identificacion_persona#&id_tipoident=#identificacion.id_tipoident#';"></td></tr>
	</cfoutput>
</table>
</script>
