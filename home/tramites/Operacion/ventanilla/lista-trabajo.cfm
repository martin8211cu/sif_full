<html><head><title>Lista de trabajo</title><meta http-equiv="refresh" content="30" /></head><body style="margin:0">
<!---
	se actualiza cada treinta segundos.
--->
<cfquery name="listadetrabajo" datasource="#session.tramites.dsn#">
	select  lt.id_persona, 
		it.id_tramite,
		t.nombre_tramite,
		lt.id_requisito, 
		lt.id_instancia, 
		lt.id_funcionario, 
		lt.fecha_asignacion,
		r.nombre_requisito,
		t.nombre_tramite || ' - ' ||r.nombre_requisito as tramite,
		p.identificacion_persona,
		p.nombre, 
		p.apellido1,
		p.apellido2
	from TPListaTrabajo lt
	
	inner join TPRequisito r
	on r.id_requisito = lt.id_requisito
	
	inner join TPInstanciaRequisito ir
	on ir.id_instancia = lt.id_instancia
	and ir.id_requisito=lt.id_requisito
	and ir.completado = 0

	inner join TPInstanciaTramite it
	on it.id_instancia=ir.id_instancia

	inner join TPTramite t
	on t.id_tramite=it.id_tramite
	
	inner join TPPersona p
	on p.id_persona=lt.id_persona
	
	where lt.id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#" null="#Len(session.tramites.id_funcionario) EQ 0#">
	  and lt.aceptado = 0
	
	order by nombre_tramite, r.nombre_requisito, nombre, apellido1, apellido2

</cfquery>
			
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td bgcolor="#CCCCCC" style="border:1px solid gray; padding:3px; "><font size="2"><strong>Lista de Trabajo</strong></font></td>
	</tr>

	<cfif listadetrabajo.recordcount gt 0 >
		<cfoutput query="listadetrabajo" group="tramite">
			<tr>
				<td style=" cursor:pointer; padding:3px; " title="#listadetrabajo.nombre_tramite# - #listadetrabajo.nombre_requisito#" bgcolor="##ECE9D8"><strong>#mid(listadetrabajo.nombre_tramite,1,40)#<cfif len(listadetrabajo.nombre_tramite) gt 40 >...</cfif><br><em>#mid(listadetrabajo.nombre_requisito,1,40)#</em><cfif len(listadetrabajo.nombre_requisito) gt 40 >...</cfif></strong></td>
			</tr>	
			<cfoutput>
				<tr style="cursor:pointer;" onClick="javascript: trabajar(#listadetrabajo.id_persona#, #listadetrabajo.id_instancia#, #listadetrabajo.id_requisito#);" onMouseOver="javascript:this.className='listaParSel'" onMouseOut="this.className='<cfif listadetrabajo.currentrow mod 2 >listaPar<cfelse>listaNon</cfif>'" class="<cfif listadetrabajo.currentrow mod 2 >listaPar<cfelse>listaNon</cfif>">
					<td>#listadetrabajo.nombre# #listadetrabajo.apellido1# #listadetrabajo.apellido2#</td>
				</tr>
			</cfoutput>
		</cfoutput>
	<cfelse>
		<tr><td>No se encontraron registros</td></tr>
	</cfif>
	<tr><td><em><cfoutput>&Uacute;ltima actualizaci&oacute;n: #LSTimeFormat(Now())#
	</cfoutput></em></td></tr>
</table>

<script language="javascript1.2" type="text/javascript">
	function trabajar(persona, instancia, requisito){
		var w = window;
		if (w.parent) w = w.parent;
		if (w.parent) w = w.parent;
		w.location.href = '/cfmx/home/tramites/Operacion/ventanilla/tramite.cfm?id_instancia='+instancia+'&id_persona='+ persona + '&id_requisito='+ requisito + '&tab=3';
	}
</script>


<cftry>
	<cfif isdefined("session.tramites.id_funcionario") and len(trim(session.tramites.id_funcionario)) and isdefined("session.tramites.id_ventanilla") and len(trim(session.tramites.id_ventanilla))>
		<cfset ventanilla = createobject('component', 'home.tramites.componentes.ventanilla') >
		<cfset ventanilla.ping(session.tramites.id_funcionario, session.tramites.id_ventanilla) >
</cfif>
<cfcatch type="any"># HTMLEditFormat(cfcatch.Message) # - # HTMLEditFormat(cfcatch.Detail) #</cfcatch>
</cftry>

</body></html>