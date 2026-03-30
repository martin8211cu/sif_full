<cftimer label="select para grafico">
<cfquery datasource="#session.dsn#" name="grafico">
	select
		<cfif mostrar_periodo GT 1440>
		left (convert (varchar, EVregistro, 106), 7) ||
		</cfif>
		left(convert (varchar, 
			dateadd (mi,
				floor(
					datediff (mi, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#mostrar_zero#">, EVregistro)
					/ <cfqueryparam cfsqltype="cf_sql_integer" value="#mostrar_intervalo#">)
					* <cfqueryparam cfsqltype="cf_sql_integer" value="#mostrar_intervalo#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#mostrar_zero#">), 108), 5)
		as fecha,
		sum(EVcrudo) as sum_crudo,
		sum(EVmedio) as sum_medio,
		sum(EVlogin) as sum_login,
		sum(EVprepago) as sum_prepago,
		sum(EVsintasar) as sum_sintasar,
		sum(EVmillis) / sum(EVmedio+EVlogin+EVprepago+EVsintasar) as millis_reg,
		max(EVcola) as max_cola,
		min(EVmillisMin) as millis_min,
		min(EVmillisMax) as millis_max,
		count(distinct EVservicio) as count_servicio
	from ISBeventoBitacora
	where EVregistro >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#mostrar_inicio#">
	  and EVregistro <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#mostrar_zero#">
	group by
		<cfif mostrar_periodo GT 1440>
		left (convert (varchar, EVregistro, 106), 7) ||
		</cfif>
		left(convert (varchar, 
			dateadd (mi,
				floor(
					datediff (mi, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#mostrar_zero#">, EVregistro)
					/ <cfqueryparam cfsqltype="cf_sql_integer" value="#mostrar_intervalo#">)
					* <cfqueryparam cfsqltype="cf_sql_integer" value="#mostrar_intervalo#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#mostrar_zero#">), 108), 5)
	AT ISOLATION READ UNCOMMITTED
</cfquery>
</cftimer>

<cftimer label="charts"><table width="394" border="0" cellspacing="0" cellpadding="2">
      <tr>
        <td valign="top"><cfchart xaxistype="category" title="Número de registros por tasar" format="png" chartwidth="380" chartheight="300" >
          <cfchartseries query="grafico" valuecolumn="max_cola" type="line" itemcolumn="fecha" serieslabel="Tamaño de la cola"/>
        </cfchart></td></tr><tr>
        <td valign="top">
		
			<cfif mostrar_intervalo GT 60>
				<cfset titulo_grafico = Int (mostrar_intervalo / 60) & ' horas' >
				<cfif mostrar_intervalo Mod 60>
					<cfset titulo_grafico = titulo_grafico & ' ' & Int(mostrar_intervalo Mod 60) & ' minutos'>
				</cfif>
			<cfelseif mostrar_intervalo EQ 1>
				<cfset titulo_grafico = 'un minuto'>
			<cfelse>
				<cfset titulo_grafico = Int(mostrar_intervalo) & ' minutos'>
			</cfif>
		<cfchart xaxistype="category" title="Número de transacciones en #mostrar_intervalo# minutos" format="png"  chartwidth="380" chartheight="300" showlegend="yes">
          <cfchartseries query="grafico" valuecolumn="sum_crudo" type="line" itemcolumn="fecha" serieslabel="Tráfico crudo"/>
          <cfchartseries query="grafico" valuecolumn="sum_medio" type="line" itemcolumn="fecha" serieslabel="Por Medio"/>
          <cfchartseries query="grafico" valuecolumn="sum_login" type="line" itemcolumn="fecha" serieslabel="Por Login"/>
          <cfchartseries query="grafico" valuecolumn="sum_prepago" type="line" itemcolumn="fecha" serieslabel="Por Prepago"/>
          <cfchartseries query="grafico" valuecolumn="sum_sintasar" type="line" itemcolumn="fecha" serieslabel="Sin Tasar"/>
        </cfchart></td></tr><tr>
        <td valign="top"><cfchart xaxistype="category" title="Duración por evento (ms)" format="png" chartwidth="380" chartheight="300" showlegend="yes" >
          <cfchartseries query="grafico" valuecolumn="millis_reg" type="line" itemcolumn="fecha" serieslabel="Duración por evento (ms)"/>
          <cfchartseries query="grafico" valuecolumn="millis_min" type="line" itemcolumn="fecha" serieslabel="Min"/>
          <cfchartseries query="grafico" valuecolumn="millis_max" type="line" itemcolumn="fecha" serieslabel="Max"/>
        </cfchart></td></tr><tr>
        <td valign="top"><cfchart xaxistype="category" title="Procesos activos" format="png" chartwidth="380" chartheight="300" >
          <cfchartseries query="grafico" valuecolumn="count_servicio" type="line" itemcolumn="fecha" serieslabel="Procesos activos"/>
        </cfchart></td>
      </tr>
      
    </table></cftimer>