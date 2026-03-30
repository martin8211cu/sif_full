<cfcomponent>

<cfset BorrarTabla_row = 0>

<cffunction name="BorrarTabla" access="private">
	<cfargument name="nombre_tabla" type="string">
	<cfargument name="campo_fecha" type="string">
	<cfargument name="fecha_desde" type="date">
	
	<cfquery datasource="aspmonitor" name="cant_antes">
		select count(1) as cant_reg from #Arguments.nombre_tabla#
	</cfquery>
	
	<cfoutput>
	<cfset inicio_tabla = Now()>
	<cfset BorrarTabla_row = BorrarTabla_row + 1>
	<table border=1 cellspacing=0 cellpadding=1 <cfif BorrarTabla_row mod 3 is 0>bgcolor=##B4F5C9 bordercolor=##B4F5C9 <cfelse>bordercolor=white </cfif>>
	  <tr>
		<td width="166">#Arguments.nombre_tabla#</td>
		<td width="150">#DateFormat(inicio_tabla,'dd/mm/yy')# #TimeFormat(Now(),'HH:mm:ss.ll')#</td>
	<cfquery datasource="aspmonitor">
		delete #Arguments.nombre_tabla#
		where #Arguments.campo_fecha# < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha_desde#">
	</cfquery>

	<cfquery datasource="aspmonitor" name="cant_despues">
		select count(1) as cant_reg from #Arguments.nombre_tabla#
	</cfquery>
	
		<cfset fin_tabla = Now()>
		<td width="60" align="right">#NumberFormat(fin_tabla.getTime() - inicio_tabla.getTime(),',0')# ms</td>
		<td width="60" align="right">#NumberFormat(cant_antes.cant_reg,',0')#</td>
		<td width="60" align="right">#NumberFormat(cant_despues.cant_reg,',0')#</td>
		<td width="60" align="right">#NumberFormat(cant_antes.cant_reg - cant_despues.cant_reg,',0')#</td>
	</tr></table>
	</cfoutput>
	
</cffunction>


<cffunction name="BorrarHistoria">
	
	<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")>
	<cfset monitor_historia = Politicas.trae_parametro_global("monitor.historia")>
	
	<cfif monitor_historia is 0>
		<cfoutput>La politica global 'monitor.historia' es 0.<br>No se realiza el borrado autom&aacute;tico de historia.</cfoutput>
		<cfreturn>
	</cfif>
	<cfset fecha_desde = DateAdd( 'd', - monitor_historia - 1, Now() )>
	<cfoutput>La politica global 'monitor.historia' es de #monitor_historia# d&iacute;as.<br>
		Borrando informaci&oacute;n hist&oacute;rica previa a #DateFormat(fecha_desde, 'dd/mm/yyyy')#.<br><br>


	<table border=1 bgcolor=##ededed bordercolor=white cellspacing=0 cellpadding=1>
	  <tr>
		<td width="166" valign="bottom" rowspan="2"><strong>Tabla</strong></td>
		<td width="150" valign="bottom" rowspan="2"><strong>Inicio</strong></td>
		<td width="60" valign="bottom" align="right" rowspan="2"><strong>Duraci&oacute;n</strong></td>
		<td valign="bottom" align="center" colspan="3"><strong>Registros</strong></td>
		</tr>
	  <tr>
	    <td width="60" valign="bottom" align="center"><strong>Antes</strong></td>
	    <td width="60" valign="bottom" align="center"><strong>Despu&eacute;s</strong></td>
	    <td width="60" valign="bottom" align="center"><strong>Borrados</strong></td>
	  </tr>
	</table>
	</cfoutput>
	
	<cfset BorrarTabla ( 'MonBitacora', 'fecha',  fecha_desde ) >
	<cfset BorrarTabla ( 'MonProcesos', 'acceso',  fecha_desde ) >
	<cfset BorrarTabla ( 'MonHistoria', 'hasta',  fecha_desde ) >
	<cfset BorrarTabla ( 'MonRequest', 'requested',  fecha_desde ) >
	<cfset BorrarTabla ( 'MonRequestTemplate', 'requested',  fecha_desde ) >
	<cfset BorrarTabla ( 'MonServerProcess', 'last_access',  fecha_desde ) >
	<cfset BorrarTabla ( 'MonServerStats', 'fecha',  fecha_desde ) >
	<cfset BorrarTabla ( 'MonDatabaseStats', 'fecha',  fecha_desde ) >
	<cfset BorrarTabla ( 'KillSession', 'fecha',  fecha_desde ) >

	<cfset BorrarTabla ( 'MonErrores', 'cuando',  fecha_desde ) >

	<cfset BorrarTabla ( 'AccesoDenegado', 'fecha',  fecha_desde ) >
	<cfset BorrarTabla ( 'LoginIncorrecto', 'LIcuando',  fecha_desde ) >
	<cfset BorrarTabla ( 'UsuarioBloqueo', 'bloqueo',  fecha_desde ) >
	
</cffunction>

</cfcomponent>