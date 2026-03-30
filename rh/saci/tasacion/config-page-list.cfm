<cfif IsDefined('url.lista')>
<html><body>
</cfif>

<cfquery datasource="#session.dsn#">
	update ISBtasarStatus
	set estado = 'stopped'
	where estado not in ( 'runnable', 'stopped' )
	  and horaReporte < <cfqueryparam cfsqltype="cf_sql_timestamp" value="# DateAdd('s', -120, Now())#">
</cfquery>

<cfquery datasource="#session.dsn#" name="ISBtasarStatus">
	select c.hostname, c.procesos, c.maxFilas, c.httpHost, c.httpPort,
		s.servicio, s.datasource, s.estado, 
		coalesce (s.registrosTotal, 0) as registrosTotal, s.mensaje,
		s.bloqueInicio, s.bloqueFinal, s.bloqueCant, s.bloqueActual,
		s.horaInicio, s.horaFinal, s.horaMensaje, s.horaReporte,
		case when s.horaReporte is null then 0
			else datediff(ss, s.horaReporte, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">) 
		end as inactivo
	from ISBtasarStatus s
		right outer join ISBtasarConfig c
			on s.hostname = c.hostname
	order by c.hostname, s.servicio
	AT ISOLATION READ UNCOMMITTED
</cfquery>

<div id="contenedor_lista">


<table width="500" border="0" cellpadding="2" cellspacing="0">
    <cfoutput query="ISBtasarStatus" group="hostname">
      <tr class="listaCorte" style="cursor:pointer;"
			onmouseover="host_mouseover(&quot;#HTMLEditFormat(hostname)#&quot;,this);" 
			onmouseout="host_mouseout(this);" 
			onclick="host_click(&quot;#HTMLEditFormat(hostname)#&quot;,this);" >
        <td align="left" valign="top" colspan="7">Servidor: # HTMLEditFormat( hostname )#
          (# NumberFormat(procesos) # procesos de # NumberFormat(maxFilas) # filas)	
          <cfset sum_registrosTotal=0>	  </td>
            </tr>
      <cfif Len(servicio)>
        <tr class="tituloListas">
          <td width="35" align="center" valign="top">&nbsp;</td>
            <td width="62" align="center" valign="top">Proceso</td>
            <td width="87" align="center" valign="top">Datasource</td>
            <td colspan="2" align="center" valign="top">Status</td>
            <td width="73" align="center" valign="top">Procesado</td>
            <td width="144" align="center" valign="top">&nbsp;</td>
          </tr></cfif>
      <cfoutput><cfset sum_registrosTotal=sum_registrosTotal+registrosTotal><cfif Len(servicio)>
        <tr class="listaPar" style="cursor:pointer;"
			onmouseover="svc_mouseover(&quot;#HTMLEditFormat(servicio)#&quot;,this);" 
			onmouseout="svc_mouseout(this);" 
			onclick="svc_click(&quot;#HTMLEditFormat(servicio)#&quot;,this);" >
          <td align="center" valign="top">&nbsp;</td>
                <td align="center" valign="top"># HTMLEditFormat(servicio) #</td>
                <td align="center" valign="top"># HTMLEditFormat( datasource )#</td>
                <td width="72" align="center" valign="top">
                  # HTMLEditFormat( estado )#</td>
                <td width="48" align="center" valign="top"><cfif Len(Trim(mensaje))><a href="javascript:mostrar_servicio('#HTMLEditFormat(servicio)#')">
                  <img src="../images/warning16.png" width="16" height="16" border="0"/></a>
                  <cfelse>&nbsp;</cfif></td>
                <td align="center" valign="top"># NumberFormat( registrosTotal )#</td>
                <td align="center" valign="top">&nbsp;</td>
              </tr>
        </cfif></cfoutput> 
        <tr class="listaPar">
          <td align="center" valign="top">&nbsp;</td>
          <td colspan="6" align="left" valign="top"><a href="config.cfm?action=svc.inc&amp;hostname=#HTMLEditFormat( hostname ) #" target="proceso">Agregar un proceso... </a></td>
          </tr>
        <tr class="listaPar">
          <td align="center" valign="top">&nbsp;</td>
          <td colspan="6" align="left" valign="top"><a href="config.cfm?action=svc.dec&amp;hostname=#HTMLEditFormat( hostname ) #" target="proceso">Quitar un proceso... </a></td>
          </tr>
        <tr>
          <td align="center" valign="top" colspan="7">&nbsp;</td>
          </tr> </cfoutput>
        <tr class="tituloListas">
          <td colspan="7" align="left" valign="top"><a href="#" onClick="host_add()">Agregar nuevo servidor... </a></td>
          </tr>
        <tr>
          <td colspan="7" align="left" valign="top">&nbsp;</td>
          </tr>
  </table>
</div>

<cfif IsDefined('url.lista')>
<script type="text/javascript">
	window.parent.cp(window.parent.o(document, 'contenedor_lista'), 'contenedor_lista');
</script>
</body></html>
</cfif>