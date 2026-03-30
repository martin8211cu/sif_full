<html><head></head><body>
<cfquery datasource="#session.dsn#" name="ISBtasarStatus">
	select 
		s.servicio, s.datasource, s.estado, 
		s.registrosTotal, s.mensaje,
		s.bloqueInicio, s.bloqueFinal, s.bloqueCant, s.bloqueActual,
		s.horaInicio, s.horaFinal, s.horaMensaje, s.horaReporte,
		case when s.horaReporte is null then 0
			else datediff(ss, s.horaReporte, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">) 
		end as inactivo
	from ISBtasarStatus s
	where s.servicio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.servicio#">
	AT ISOLATION READ UNCOMMITTED
</cfquery>
<div id="contenedor">
	<cf_web_portlet_start titulo="Detalle del proceso" tipo="mini" width="380" >
	<table border="0" width="380" cellspacing="0" cellpadding="2">
<cfoutput>
	<tr>
	<td valign="top">Proceso</td>
	<td valign="top" id="svc_dat_servicio">#HTMLEditFormat(ISBtasarStatus.servicio)#</td>
	</tr>
	<tr>
	<td valign="top">Datasource</td>
	<td valign="top" id="svc_dat_datasource">#HTMLEditFormat(ISBtasarStatus.datasource)#</td>
	</tr>
	<tr>
	<td valign="top">Estado</td>
	<td valign="top" id="svc_dat_estado">#HTMLEditFormat(ISBtasarStatus.estado)#</td>
	</tr>
	<tr>
	<td valign="top">Crudo procesado</td>
	<td valign="top" id="svc_dat_registrosTotal">#NumberFormat(ISBtasarStatus.registrosTotal)#</td>
	</tr>
	<tr>
	<td valign="top">Tamaño del bloque </td>
	<td valign="top" id="svc_dat_bloqueCant">#NumberFormat(ISBtasarStatus.bloqueCant)#</td>
	</tr>
	<tr>
	<td valign="top">Inicio del bloque </td>
	<td valign="top" id="svc_dat_bloqueInicio">#NumberFormat(ISBtasarStatus.bloqueInicio)#</td>
	</tr>
	<tr>
	<td valign="top">Fin del bloque </td>
	<td valign="top" id="svc_dat_bloqueFinal">#NumberFormat(ISBtasarStatus.bloqueFinal)#</td>
	</tr>
	<tr>
	<td valign="top">Valor actual </td>
	<td valign="top" id="svc_dat_bloqueActual">#NumberFormat(ISBtasarStatus.bloqueActual)#</td>
	</tr>
	<tr>
	<td valign="top">Hora de inicio </td>
	<td valign="top" id="svc_dat_horaInicio"># DateFormat( ISBtasarStatus.horaInicio, 'dd-MMM' )# #TimeFormat( ISBtasarStatus.horaInicio, 'h:mm:ss tt' )#</td>
	</tr>
	<tr>
	<td valign="top">Timestamp </td>
	<td valign="top" id="svc_dat_horaReporte">#   DateFormat( ISBtasarStatus.horaReporte, 'dd-MMM' )# #TimeFormat( ISBtasarStatus.horaReporte, 'h:mm:ss tt' ) #</td>
	</tr>
	<td valign="top">Tiempo inactivo </td>
	<td valign="top" id="svc_dat_inactivo"><cfif ISBtasarStatus.inactivo GT 86400>#NumberFormat( Int (ISBtasarStatus.inactivo/86400),'0')#d</cfif> #NumberFormat(Int(ISBtasarStatus.inactivo / 3600) mod 24, '0')#h #NumberFormat(Int(ISBtasarStatus.inactivo / 60) mod 60, '0')#m #NumberFormat(Int(ISBtasarStatus.inactivo) mod 60, '0')#s</td>
	</tr>
	<tr>
	<td valign="top" colspan="2" id="svc_dat_mensaje">&nbsp;</td>
	</tr>
</cfoutput>
	</table>
	<cf_web_portlet_end> 
</div>
<script type="text/javascript">
	window.parent.cp(window.parent.o(document, 'contenedor'));
	<!--- actualizar cada cinco segundos --->
	setTimeout('  window.open(\'config.cfm?servicio=<cfoutput>#JSStringFormat( URLEncodedFormat( url.servicio ))#</cfoutput>\', \'proceso\'); ', 5000);
</script>
</body></html>