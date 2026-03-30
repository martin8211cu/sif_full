<cfset imprimir = false >
<cfif isDefined("Url.RHAlinea") and not isDefined("Form.RHAlinea")>
	<cfset Form.RHAlinea = Url.RHAlinea >
	<cfset imprimir = true >
</cfif>

<!--- Obtiene el nombre de la BD --->
<!---
<cfquery name="rsBD" datasource="#Session.DSN#">
	select db_name() as BD
</cfquery>
--->

<cfquery name="rsActividadesParticipantes" datasource="#Session.DSN#">
	select convert(varchar,b.RHTid) as RHTid, b.RHTcodigo, b.RHTdesc, convert(varchar,a.RHAlinea) as RHAlinea
		, convert(varchar,a.DEid) as DEid, c.DEidentificacion, c.DEnombre, c.DEapellido1, c.DEapellido2
		, c.DEidentificacion, c.DEnombre + ' ' + c.DEapellido1 + ' ' + c.DEapellido2 as Nombre
		, a.DLfvigencia
		, g.StartTime, g.FinishTime
		, convert(varchar,g.ActivityInstanceId) as ActivityInstanceId
		, convert(varchar,d.ProcessInstanceId) as ProcessInstanceId
		, case g.State
			when 'INACTIVE' then 'INACTIVO'
			when 'SUSPENDED' then 'SUSPENDIDO'			
			when 'COMPLETED' then 'COMPLETO'			
			when 'ACTIVE' then 'ACTIVO'
		end as State
		, convert(varchar,h.ActivityId) as ActivityId
		, h.Name as Actividad		
	from RHAcciones a, RHTipoAccion b, DatosEmpleado c
		, WfxProcess d, WfProcess e, WfPackage f
		, WfxActivity g, WfActivity h
	where a.RHTid = b.RHTid
	  and a.Ecodigo = b.Ecodigo
	  and a.Ecodigo = c.Ecodigo
	  and a.DEid = c.DEid
	  and e.PackageId = f.PackageId
	  and d.ProcessId = e.ProcessId
	  and a.RHAidtramite = d.ProcessInstanceId
	  and g.ActivityId =* h.ActivityId
	  and d.ProcessInstanceId *= g.ProcessInstanceId
      and d.ProcessId = h.ProcessId	  
	  and a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">
	  and h.IsFinish = 0
	order by g.ActivityInstanceId, h.Ordering
</cfquery>
<!---<cfdump var="#rsActividadesParticipantes#">--->

<!--- Obtiene los participantes definidos para una actividad específica --->
<cffunction name="ObtenerParticipantesDefinidos" returntype="query">
	<cfargument name="idactividad" type="string" required="true">
	<cfquery name="rsParticipantes" datasource="#Session.DSN#">
		select distinct b.Usucodigo
		from WfActivityParticipant a, WfParticipant b
		where a.ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idactividad#">
		  and a.ParticipantId = b.ParticipantId
	</cfquery>
	
	<cfquery name="rs" datasource="asp">
		select (dp.Pnombre + ' ' + dp.Papellido1 + ' ' + dp.Papellido2) as Nombre 
		from Usuario c, DatosPersonales dp
		<cfif rsParticipantes.recordCount GT 0>
		where c.Usucodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" separator="," value="#ValueList(rsParticipantes.Usucodigo, ',')#">)
		<cfelse>
		where c.Usucodigo = 0
		</cfif>
		  and dp.datos_personales =* c.datos_personales
	</cfquery>
	<cfreturn #rs#>
</cffunction>

<!--- Obtiene los participantes asignados para una actividad específica --->
<cffunction name="ObtenerParticipantesAsignados" returntype="query">
	<cfargument name="idactividad" type="string" required="true">
	<!--- asp.. --->
	<cfquery name="rs" datasource="#Session.DSN#">
		select wp.Description as Nombre, 
		convert(varchar,b.ParticipantId) as ParticipantId
		from WfxActivity a, WfxActivityParticipant b, WfParticipant wp
		where a.ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idactividad#">
		  and a.ActivityInstanceId = b.ActivityInstanceId
		  and wp.ParticipantId = b.ParticipantId
	</cfquery>
	<cfreturn #rs#>
</cffunction>

<form name="form1" method="post">

<table width="100%" border="0" cellspacing="0" cellpadding="0">

<cfoutput>


<cfif rsActividadesParticipantes.RecordCount GT 0>

  <tr>
    <td><font size="2">&nbsp;<strong>Tr&aacute;mite: </strong>#rsActividadesParticipantes.ProcessInstanceId#&nbsp;</font></td>
    <td><font size="2">#rsActividadesParticipantes.RHTdesc# &nbsp;</font></td>
    <td><font size="2"><strong>Solicitado por: </strong> #rsActividadesParticipantes.DEidentificacion# #rsActividadesParticipantes.Nombre#&nbsp;</font></td>
    <td><font size="2">&nbsp;</font></td>
    <td><font size="2">&nbsp;</font></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>

	<cfloop query="rsActividadesParticipantes">
	  <tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif> onMouseOver="style.backgroundColor='##E4E8F3';" onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
		<td colspan="5">

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			
		  <tr>
		    <td colspan="2">&nbsp;<strong><font size="2">#CurrentRow#. #Actividad#</font></strong></td>
			<td width="24%">&nbsp;</td>
		    <td width="18%">&nbsp;</td>
		    <td width="34%">&nbsp;</td>
		  </tr>

		  <tr class="TituloListas">
		    <td width="2%">&nbsp;</td>
			<td width="22%"><strong>Estado</strong></td>
			<td><strong>Responsables&nbsp;</strong></td>
		    <td><strong>Fecha Inicio</strong>&nbsp;</td>
		    <td><strong><cfif Len(Trim(State)) GT 0 >Fecha Conclusi&oacute;n</cfif></strong></td>
		  </tr>
			
		  <tr valign="top">
		    <td>&nbsp;</td>
			<td>&nbsp;<cfif Len(Trim(State)) GT 0 >#rsActividadesParticipantes.State#<cfelse>PENDIENTE</cfif></td>
			<td valign="top">
			<cfif Len(Trim(ActivityInstanceId)) GT 0 >
				<cfset rs1 = ObtenerParticipantesAsignados(ActivityInstanceId)>
				<table border="0" cellpadding="0" cellspacing="0" align="">
				<cfloop query="rs1">
					<tr valign="top"><td>#rs1.Nombre#</td></tr>
				</cfloop></table>
			<cfelse>			
				<cfset rs2 = ObtenerParticipantesDefinidos(ActivityId)>
				<table border="0" cellpadding="0" cellspacing="0" align="">
				<cfloop query="rs2">
					<tr valign="top"><td>#rs2.Nombre#</td></tr>
				</cfloop></table>
			</cfif>
			
			</td>
		    <td>
				<table border="0" cellpadding="0" cellspacing="0">
					<tr><td ><cfif Len(Trim(State)) GT 0 >
					  <cfif Len(Trim(StartTime)) GT 0 >#LSDateFormat(StartTime,'dd/mm/yyyy')# #LSTimeFormat(StartTime, 'hh:mm tt')#</cfif></cfif></td></tr>
					<tr><td>&nbsp;</td></tr>
				</table>			
			</td>
		    <td>
              <cfif Len(Trim(FinishTime)) GT 0 >
                #LSDateFormat(FinishTime,'dd/mm/yyyy')# #LSTimeFormat(FinishTime,
                  'hh:mm tt')#
              </cfif></td>
		  </tr>
		</table>

		</td>
	  </tr>
	  <tr><td colspan="5">&nbsp;</td></tr>	  
	</cfloop>
	
	<tr><td colspan="5" align="center">&nbsp;</td></tr>		
	<tr>
	<td colspan="5" align="center">----------------- FIN DEL TR&Aacute;MITE----------------</td>
	</tr>	

<cfelse>
	<tr><td colspan="5" align="center">----------------- NO HAY DATOS DEL SEGUIMIENTO ----------------</td></tr>
</cfif>
	<tr><td colspan="5">&nbsp;</td></tr>
	<tr><td colspan="5" align="center"><cfif not imprimir ><input type="button" name="Regresar" value="Regresar" tabindex="1" onClick="javascript:history.back();"></cfif></td></tr>
</cfoutput>  
</table>

</form>
