<cfset mostrar_zero_rs = fechabd.fecha>
<cfset mostrar_zero_rs = CreateDateTime(Year(mostrar_zero_rs), Month(mostrar_zero_rs), Day(mostrar_zero_rs),
																Hour(mostrar_zero_rs), Minute(mostrar_zero_rs), Second(mostrar_zero_rs))>

<cfset mostrar_inicio_rs = DateAdd('n', -mostrar_periodo, mostrar_zero_rs )>


<cftimer label="select para replication">
<cfquery datasource="#session.dsn#" name="grafico">
	select
		<cfif mostrar_periodo GT 1440>
		left (convert (varchar, EVfecha, 106), 7) ||
		</cfif>
		left(convert (varchar, 
			dateadd (mi,
				floor(
					datediff (mi, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#mostrar_zero_rs#">, EVfecha)
					/ <cfqueryparam cfsqltype="cf_sql_integer" value="#mostrar_intervalo#">)
					* <cfqueryparam cfsqltype="cf_sql_integer" value="#mostrar_intervalo#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#mostrar_zero_rs#">), 108), 5)
		as fecha,
		nombreRS,
		round (100. * sum(datDispMB)/sum(datTotalMB), 1) as datDisp,
		round (100. * sum(logDispMB)/sum(logTotalMB), 1) as logDisp,
		round (100. * sum(sdDispMB)/sum(sdTotalMB), 1) as sdDisp
	from ISBrsEvento
	where EVfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#mostrar_inicio_rs#">
	  and EVfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#mostrar_zero_rs#">
	group by
		nombreRS,
		<cfif mostrar_periodo GT 1440>
		left (convert (varchar, EVfecha, 106), 7) ||
		</cfif>
		left(convert (varchar, 
			dateadd (mi,
				floor(
					datediff (mi, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#mostrar_zero_rs#">, EVfecha)
					/ <cfqueryparam cfsqltype="cf_sql_integer" value="#mostrar_intervalo#">)
					* <cfqueryparam cfsqltype="cf_sql_integer" value="#mostrar_intervalo#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#mostrar_zero_rs#">), 108), 5)
	AT ISOLATION READ UNCOMMITTED
</cfquery>
</cftimer>

<cfquery datasource="#session.dsn#" name="listado">
	select s.nombreRS, e.tipoDSI, e.nombreDSI, e.espacio, e.activo, s.EVfecha
	from ISBrsServidor s
		left join ISBrsEventoDSI e
			on e.EVfecha = s.EVfecha
			and e.nombreRS = s.nombreRS
			and s.EVfecha = (select max(EVfecha) from ISBrsEventoDSI)
	order by e.nombreRS, e.nombreDSI
</cfquery>

<cftimer label="charts"><table width="500" border="0" cellspacing="0" cellpadding="2">
      <tr>
        <td valign="top">&nbsp;</td>
      </tr>
      <tr>
        <td valign="top" class="subTitulo">&nbsp;</td>
      </tr>
      <tr>
        <td valign="top" class="subTitulo">Estadísticas de replicación </td>
      </tr>
      <tr>
        <td valign="top"><cfchart xaxistype="category" title="Espacio libre para replicación (%)" format="png" chartwidth="490" chartheight="400" showlegend="yes">
		<cfoutput query="grafico" group="nombreRS">
          <cfchartseries type="line" serieslabel="#nombreRS# datos">
			  <cfoutput>
				<cfchartdata item="#fecha#" value="#datDisp#">
			  </cfoutput>
          </cfchartseries>
		  
          <cfchartseries type="line" serieslabel="#nombreRS# log">
			  <cfoutput>
				<cfchartdata item="#fecha#" value="#logDisp#">
			  </cfoutput>
          </cfchartseries>

          <cfchartseries type="line" serieslabel="#nombreRS# stable">
			  <cfoutput>
				<cfchartdata item="#fecha#" value="#sdDisp#">
			  </cfoutput>
          </cfchartseries>

		  </cfoutput>
        </cfchart></td></tr><tr>
        <td valign="top">
		
		<table cellspacing="1" cellpadding="2" width="100%" bgcolor="black">
		<tr class="tituloListas">
		<td colspan="5">Estado de los procesos de replicación. <cfoutput># TimeFormat( listado.EVfecha )#</cfoutput></td></tr>
  <tr class="tituloListas">
    <td>Activo</td>
    <td>Servidor</td>
    <td colspan="2">DSI</td>
    <td>Usado</td>
  </tr><cfoutput query="listado">
  <tr bgcolor="##<cfif activo EQ 1>D5FFD5<cfelse>FF9999</cfif>">
    <td align="center"><cfif activo EQ 1>S<cfelse>N</cfif></td>
    <td>#HTMLEditFormat(nombreRS)#</td>
    <td><cfif Len(tipoDSI)><img 
	src="rs-#HTMLEditFormat(tipoDSI)#.gif" height="24" width="48" /></cfif></td>
    <td><cfif Len(nombreDSI)>#HTMLEditFormat(nombreDSI)#<cfelse>-</cfif></td>
    <td><cfif Len(espacio)>#HTMLEditFormat(espacio)#<cfelse>-</cfif></td>
  </tr></cfoutput>
<!--- // dejar para pruebas del icono
  <tr bgcolor="#D5FFD5"><td align="center">S</td><td align="center">TYPE_DSI</td><td><img src="rs-dsi.gif" height="24" width="48" /></td><td>x1</td><td>1</td></tr>
  --->
</table>		</td></tr>
      
    </table>
</cftimer>
	