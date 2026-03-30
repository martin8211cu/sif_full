<cfquery name="rsAnotaciones" datasource="#Session.DSN#">
	select RHAid, 
		   DEid, 
		   RHAfecha as FechaAnotacion,
		   RHAfsistema, 
		   RHAdescripcion, 
		   case RHAtipo when 1 then '<cf_translate key="Positiva">Positiva</cf_translate>' when 2 then '<cf_translate key="Negativa">Negativa</cf_translate>' end as TipoAnotacion, 
		   Usucodigo, 
		   Ulocalizacion
	from RHAnotaciones
	where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleado.DEid#">
	order by RHAfecha, RHAfsistema
</cfquery>

<cfif rsAnotaciones.recordCount GT 0>
<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0">
<tr> 
  <td class="tituloListas" align="center" nowrap><cf_translate key="NumExp">No.</cf_translate></td>
  <td class="tituloListas" align="center" nowrap><cf_translate key="FechaAnotacionExp">Fecha de Anotaci&oacute;n</cf_translate></td>
  <td class="tituloListas" align="center" nowrap><cf_translate key="TipoAnotacionExp">Tipo de Anotaci&oacute;n</cf_translate></td>
  <td class="tituloListas" nowrap><cf_translate key="Anotacion">Anotacion</cf_translate></td>
</tr>

<cfloop query="rsAnotaciones">
	<tr> 
	  <td  align="center" <cfif #rsAnotaciones.CurrentRow# MOD 2><cfoutput>class="listaNon"</cfoutput><cfelse><cfoutput>class="listaPar"</cfoutput></cfif>>#currentRow#.</td>
	  <td  align="center" <cfif #rsAnotaciones.CurrentRow# MOD 2><cfoutput>class="listaNon"</cfoutput><cfelse><cfoutput>class="listaPar"</cfoutput></cfif>><cfif len(trim(rsAnotaciones.FechaAnotacion))>#LSDateFormat(rsAnotaciones.FechaAnotacion,'dd/mm/yyyy')#<cfelse>&nbsp;</cfif></td>
	  <td  align="center" <cfif #rsAnotaciones.CurrentRow# MOD 2><cfoutput>class="listaNon"</cfoutput><cfelse><cfoutput>class="listaPar"</cfoutput></cfif>>#TipoAnotacion#</td>
	  <td <cfif #rsAnotaciones.CurrentRow# MOD 2><cfoutput>class="listaNon"</cfoutput><cfelse><cfoutput>class="listaPar"</cfoutput></cfif>>#RHAdescripcion#</td>
	</tr>
</cfloop>

</table>

</cfoutput>
<cfelse>
	<cf_translate key="MSG_ElEmpleadoNoTieneAnotacionesAsociadasActualmente">El empleado no tiene anotaciones asociadas actualmente</cf_translate>
</cfif>
