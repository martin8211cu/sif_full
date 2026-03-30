<cfset tipo = "" >
<cfif isDefined("Url.tipo") and Len(Trim(Url.tipo)) GT 0 >
	<cfset tipo = Url.tipo >
	<cfif trim(tipo) NEQ 1 and trim(tipo) NEQ 2 and trim(tipo) NEQ 3 and trim(tipo) NEQ 4>
		<cfset tipo = 1>
	</cfif>
<cfelse>
	<cfset tipo = 1>	
</cfif>

<!--- 

	si tipo = 1
		Aprobaci&oacute;n de Tr&aacute;mites
	si tipo = 2
		Mis Tr&aacute;mites Pendientes
	si tipo = 3
		Consulta de Mis Tr&aacute;mites Solicitados
	si tipo = 4
		Consulta de Tr&aacute;mites Pendientes
		
 --->


<!--- Filtrar por el id del empleado en sesión --->
<cfif tipo EQ "2">
	<!--- Obtiene el ID del empleado según el código de usuario conectado --->
	<cfquery name="rsReferencia" datasource="asp">
		select llave
		from UsuarioReferencia
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
		and STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="DatosEmpleado">
	</cfquery>
	
	<cfquery name="rsEmpleado" datasource="#Session.DSN#">
		select convert(varchar, a.DEid) as DEid, a.DEnombre, a.DEapellido1, a.DEapellido2
		from DatosEmpleado a, NTipoIdentificacion b, Monedas c
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReferencia.llave#">
		and a.NTIcodigo = b.NTIcodigo
		and a.Mcodigo = c.Mcodigo	
	</cfquery>
</cfif>

<!--- Obtiene los datos de una Actividad --->
<cffunction name="ObtenerActividad" returntype="query">
	<cfargument name="id" type="string" required="true">	
	<cfquery name="rs" datasource="#Session.DSN#">
		select b.Name, b.Description, a.StartTime, a.FinishTime ,
		case a.State
			when 'INITIATED' then 'INICIADO'
			when 'RUNNING' then 'EN PROCESO'
			when 'ACTIVE' then 'ACTIVO'
			when 'SUSPENDED' then 'SUSPENDIDO'
			when 'COMPLETE' then 'COMPLETO'
			when 'TERMINATED' then 'TERMINADO'
		end as State					
		from WfxActivity a, WfActivity b
		where a.ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id#">
		 and a.ActivityId = b.ActivityId
	</cfquery>
	<cfreturn #rs#>
</cffunction>

<!--- Lista las transiciones de una Actividad o pasos que puede realizar --->
<cffunction name="ObtenerTransiciones" returntype="query">
	<cfargument name="idactividad" type="string" required="true">	
	<cfquery name="rs" datasource="#Session.DSN#">
		select convert(varchar,TransitionId) as TransitionId, Name from WfTransition
		where FromActivity = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idactividad#">		 
	</cfquery>
	<cfreturn #rs#>
</cffunction>


<!--- Recupera el nombre del datasource de la sesión --->
<!---
<cfquery name="rsBD" datasource="#Session.DSN#">
	select db_name() as BD	
</cfquery>
--->

<!--- Lista de Trámites de las Acciones de Personal --->
<cfquery name="rsTramites" datasource="#Session.DSN#">
	select convert(varchar,b.RHTid) as RHTid, b.RHTcodigo, b.RHTdesc, convert(varchar,a.RHAlinea) as RHAlinea
		, convert(varchar,a.DEid) as DEid, c.DEidentificacion, c.DEnombre, c.DEapellido1, c.DEapellido2
		, a.DLfvigencia
		, g.StartTime
		, convert(varchar,g.ActivityInstanceId) as ActivityInstanceId
		, convert(varchar,d.ProcessInstanceId) as ProcessInstanceId 
		, g.State
		, convert(varchar,h.ActivityId) as ActivityId		
	from RHAcciones a, RHTipoAccion b, DatosEmpleado c
		, WfxProcess d, WfProcess e, WfPackage f
		, WfxActivity g, WfActivity h
	<cfif tipo EQ "1">
		, WfxActivityParticipant i
	</cfif>
	where a.RHTid = b.RHTid
	  and a.Ecodigo = b.Ecodigo
	  and a.Ecodigo = c.Ecodigo
	  and a.DEid = c.DEid
	  and e.PackageId = f.PackageId
	  and d.ProcessId = e.ProcessId
	  and a.RHAidtramite = d.ProcessInstanceId
	  and g.ActivityId = h.ActivityId
	  and d.ProcessInstanceId = g.ProcessInstanceId
	  and ( g.State != 'COMPLETED' 
		or not exists (select * from WfxTransition t where t.FromActivityInstance = g.ActivityInstanceId)  )
  <cfif tipo EQ "1">
	  and g.ActivityInstanceId = i.ActivityInstanceId
	  and i.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
  <cfelseif tipo EQ "2">
	  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleado.DEid#">
	  and b.RHTvisible = 1
  <cfelseif tipo EQ "3">
  	  and d.RequesterId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
<!---	  and d.RequesterLoc = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#"> --->
  </cfif>	
</cfquery>

<!---<cfdump var="#rsTramites#" label="rsTramites">--->

<form name="form1" method="post" action="SQLConTramites.cfm"> 

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<cfoutput>
  <tr class="#Session.Preferences.Skin#_thcenter">
    <td width="8%"><strong>Tr&aacute;mite</strong></td>
    <td width="25%"><strong>&nbsp;Tipo Acci&oacute;n</strong></td>
    <td width="33%"><strong>Empleado</strong></td>
    <td width="11%"><strong>Rige</strong></td>
    <td width="18%"><strong>Asignado</strong></td>
    <td width="5%" align="center"><strong><cfif tipo EQ "1">Acci&oacute;n</cfif></strong></td>
    <td width="5%">&nbsp;</td>
  </tr>

<cfif rsTramites.RecordCount GT 0>

	<cfloop query="rsTramites">
		<!--- Esto es para guardar el id de la actividad y en cual línea está --->

	  <tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif> onMouseOver="style.backgroundColor='##E4E8F3';" onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
		<td><a href="javascript: detalleAccion('#rsTramites.DEid#', '#rsTramites.RHAlinea#');" title="Ver Detalle">#ProcessInstanceId#</a></td>
		<td nowrap><a href="javascript: detalleAccion('#rsTramites.DEid#', '#rsTramites.RHAlinea#');" title="Ver Detalle">#RHTcodigo# #RHTdesc#</a></td>
		<td nowrap><a href="javascript: detalleAccion('#rsTramites.DEid#', '#rsTramites.RHAlinea#');" title="Ver Detalle">#DEidentificacion# #DEnombre# #DEapellido1# #DEapellido2#</a></td>
		<td><a href="javascript: detalleAccion('#rsTramites.DEid#', '#rsTramites.RHAlinea#');" title="Ver Detalle">#LSDateFormat(DLfvigencia,'dd/mm/yyyy')#</a></td>
		<td nowrap><a href="javascript: detalleAccion('#rsTramites.DEid#', '#rsTramites.RHAlinea#');" title="Ver Detalle">#LSDateFormat(StartTime,'dd/mm/yyyy')# #LSTimeFormat(StartTime, 'hh:mmtt')#</a></td>
		<td align="center">&nbsp;
		
		<cfset CurrentProcessInstanceId = rsTramites.ProcessInstanceId>
		<cfset CurrentActivityInstanceId = rsTramites.ActivityInstanceId>
		
		<!--- Botones de Acciones a ejecutar para las actividades del responsable --->
		<cfif tipo EQ "1">
			<cfif State EQ "INACTIVE" or State EQ "SUSPENDED">
								
				<input type="submit" name="btnIniciar" value="INICIAR"
				onClick="javascript: ponerValores(#CurrentProcessInstanceId#,#CurrentActivityInstanceId#,0);">&nbsp;
				
			<cfelseif State EQ "ACTIVE">
				
				<input type="submit" name="btnCompletar" value="COMPLETAR"
				onClick="javascript: ponerValores(#CurrentProcessInstanceId#,#CurrentActivityInstanceId#,0);" >&nbsp;				
			
			<cfelseif State EQ "COMPLETED">				
			
				<cfset rsTrans = ObtenerTransiciones(ActivityId) >
				<cfloop query="rsTrans">
					<!--- Esto es para guardar el id de la transición y en cual de los botones está --->		
					
					<input type="submit" name="btnTrans" value= "#Ucase(Name)#"
					onClick="javascript: ponerValores(#CurrentProcessInstanceId#,#CurrentActivityInstanceId#,#rsTrans.TransitionId#);">&nbsp;

				</cfloop>
			
			</cfif>
		</cfif>
				
		
		</td>
		<td><input name="imageField2" type="image" src="/cfmx/rh/imagenes/find.small.png" width="16" height="16" border="0" onclick="javascript: Seguimiento('#rsTramites.RHAlinea#');" title="Seguimiento del Trámite"></td>
	  </tr>
	  
	</cfloop>

	<tr><td colspan="7" align="center">	
		<!--- Parámetros para el ejb de trámites --->
		<input type="hidden" name="ProcessInstanceId" value="">		
		<input type="hidden" name="ActivityInstanceId" value="">		
		<input type="hidden" name="TransitionId" value="">
</td></tr>		
	<tr><td colspan="7" align="center">&nbsp;</td></tr>
	<tr><td colspan="7" align="center">----------------- FIN DE LA CONSULTA ----------------</td></tr>	

<cfelse>
	<tr><td colspan="7" align="center">----------------- NO HAY DATOS ----------------</td></tr>
</cfif>
	<tr><td colspan="7"><input type="hidden" name="DEid" value=""><input type="hidden" name="RHAlinea" value=""><input type="hidden" name="Cambio" value=""><input type="hidden" name="tipo" value="#tipo#"></td></tr>
</cfoutput>  
</table>

</form>

<script language="JavaScript1.2">

	function ponerValores(ProcessInstanceId,ActivityInstanceId,TransitionId) {
		document.form1.ProcessInstanceId.value  = ProcessInstanceId;
		document.form1.ActivityInstanceId.value = ActivityInstanceId;
		document.form1.TransitionId.value       = TransitionId;
	}

	function detalleAccion(dato1, dato2){
		document.form1.DEid.value = dato1;
		document.form1.RHAlinea.value = dato2;
		document.form1.action = "ConsultaAcciones.cfm";
		document.form1.submit();				
	}

	function Seguimiento(dato){
		document.form1.RHAlinea.value = dato;
		document.form1.action = "SeguimientoAccion.cfm";
		<cfif Session.Params.ModoDespliegue EQ 0 >
		document.form1.action = "SeguimientoAccionAuto.cfm";
		</cfif>
		document.form1.submit();				
	}
	
</script>		  
