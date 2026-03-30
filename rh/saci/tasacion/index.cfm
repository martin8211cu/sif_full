<cf_templateheader title="Consola de tasación">

<cf_web_portlet_start titulo="Consola de tasación">

<!--- url.mostrar, mostrar_periodo y mostrar_intervalo están expresados en minutos --->
<cfset mostrar_list = "60-1,480-10,1440-30,10080-240,43200-1440">
<cfset mostrar_opt = "60-1,1 hora / 1 min;480-10,8 horas / 10 min;1440-30,24 horas / 30 min;10080-240,7 días / 4 horas;43200-1440,30 días / 1 día">
<cfparam name="url.mostrar" default="#ListFirst(mostrar_list)#">
<cfif not ListFind(mostrar_list, url.mostrar)>
	<cfoutput>
		<div style="color:red;font-weight:bold">
		Parámetro inválido: # HTMLEditFormat( url.mostrar )#</div></cfoutput>
	<cfset url.mostrar = ListFirst(mostrar_list)>
</cfif>
<cfset mostrar_periodo = ListFirst(url.mostrar, '-')>
<cfset mostrar_intervalo = ListRest(url.mostrar, '-')>

<cfquery datasource="#session.dsn#" name="mostrar_zero">
	select max(EVregistro) as mostrar_zero
	from ISBeventoBitacora
	AT ISOLATION READ UNCOMMITTED
</cfquery>

<cfquery datasource="#session.dsn#" name="fechabd">
	select getdate() as fecha
</cfquery>

<cfif Len(mostrar_zero.mostrar_zero) And (DateDiff('n', mostrar_zero.mostrar_zero, fechabd.fecha) GT 1)>
	<cfset mostrar_zero = DateAdd('n', 1, mostrar_zero.mostrar_zero)>
<cfelse>
	<cfset mostrar_zero = DateAdd('n', -1, fechabd.fecha)>
</cfif>
<cfset mostrar_zero = CreateDateTime(Year(mostrar_zero), Month(mostrar_zero), Day(mostrar_zero),
																Hour(mostrar_zero), Minute(mostrar_zero), Second(mostrar_zero))>

<cfset mostrar_inicio = DateAdd('n', -mostrar_periodo, mostrar_zero )>

<cfinvoke component="home.Componentes.aspmonitor" method="GetHostName" returnvariable="hostname"/>

<cftimer label="select from ISBeventoBitacora por tipo">
<cfquery datasource="#session.dsn#" name="count_tipo">
	select 
		coalesce ( sum(EVcrudo), 0) as sum_crudo,
		coalesce ( sum(EVmedio), 0) as sum_medio,
		coalesce ( sum(EVlogin), 0) as sum_login,
		coalesce ( sum(EVprepago), 0) as sum_prepago,
		coalesce ( sum(EVsintasar), 0) as sum_sintasar
	from ISBeventoBitacora
	where EVregistro >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#mostrar_inicio#">
	AT ISOLATION READ UNCOMMITTED
</cfquery>
</cftimer>

<cfquery datasource="#session.dsn#" name="ISBtasarGlobal">
	select TGultimoId
	from ISBtasarGlobal
	AT ISOLATION READ UNCOMMITTED
</cfquery>

<cfquery datasource="#session.dsn#" name="ISBtasarConfig">
	select hostname, procesos, maxFilas
	from ISBtasarConfig
	order by hostname
	AT ISOLATION READ UNCOMMITTED
</cfquery>

<cfquery datasource="#session.dsn#" name="ISBtasarStatus">
	select c.hostname, c.procesos, c.maxFilas,
		s.servicio, s.datasource, s.estado, 
		s.registrosTotal, s.mensaje,
		s.bloqueInicio, s.bloqueFinal, s.bloqueCant, s.bloqueActual,
		s.horaInicio, s.horaFinal, s.horaMensaje, s.horaReporte
	from ISBtasarStatus s
		right outer join ISBtasarConfig c
			on s.hostname = c.hostname
	order by c.hostname, s.servicio
	AT ISOLATION READ UNCOMMITTED
</cfquery>

<cftimer label="select from cs_accounting_log">
<cfquery datasource="#session.dsn#" name="acctlog">
	<!---
	select count(1) as cant
	from cs_accounting_log
	AT ISOLATION READ UNCOMMITTED
	--->	
	select coalesce (sum (rowcnt(i.doampg)), 0) as cant
	from sysindexes i
	where i.id = object_id ('cs_accounting_log')
</cfquery>
</cftimer>

<table width="900" border="0" cellpadding="2" cellspacing="0">
  <tr>
    <td width="396" valign="top" height="1300"><cfinclude template="graficos.cfm"></td>
    <td width="500" valign="top"><cfoutput><form id="form2" name="form2" method="get" action="index.cfm">
      <table width="50%" border="0" cellspacing="0" cellpadding="2">
        <tr>
          <td colspan="2" class="subTitulo">&nbsp;</td>
          <td>&nbsp;</td>
          <td class="subTitulo">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class="subTitulo">Estadísticas</td>
          <td>&nbsp;</td>
          <td class="subTitulo"><cfif count_tipo.sum_medio And count_tipo.sum_login And count_tipo.sum_prepago And count_tipo.sum_sintasar>Distribución por tipo</cfif></td>
        </tr>
        <tr>
          <td colspan="2"># LSDateFormat( mostrar_inicio )# #LSTimeFormat( mostrar_zero ) #</td>
          <td width="301" align="right">&nbsp;</td>
          <td width="301" rowspan="10" align="right">
		  <div style="height:200px;width:250px;">
		  <cfif count_tipo.sum_medio And count_tipo.sum_login And count_tipo.sum_prepago And count_tipo.sum_sintasar>
		  <cfchart chartheight="200" chartwidth="250" showlegend="yes" format="png" pieslicestyle="sliced" url="javascript:detalle('$ITEMLABEL$')">
			<cfchartseries type="pie">
			<cfchartdata item="Medio" value="#count_tipo.sum_medio#">
			<cfchartdata item="Login" value="#count_tipo.sum_login#">
			<cfchartdata item="Prepago" value="#count_tipo.sum_prepago#">
			<cfchartdata item="Sin Tasar" value="#count_tipo.sum_sintasar#">
			</cfchartseries>
			</cfchart></cfif></div></td>
        </tr>
        <tr>
          <td width="68">Last ID</td>
          <td width="301" align="right">#NumberFormat(ISBtasarGlobal.TGultimoId)#</td>
          <td align="right">&nbsp;</td>
        </tr>
        <tr>
          <td>En cola </td>
          <td align="right"># NumberFormat( acctlog.cant)# reg </td>
          <td align="right">&nbsp;</td>
        </tr>
          <tr>
            <td>Medio</td>
            <td align="right"># NumberFormat( count_tipo.sum_medio )# reg</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr>
            <td>Login</td>
            <td align="right"># NumberFormat( count_tipo.sum_login )# reg</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr>
            <td>Prepago</td>
            <td align="right"># NumberFormat( count_tipo.sum_prepago )# reg</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr>
            <td><a href="sintasar.cfm">Sin&nbsp;Tasar</a></td>
            <td align="right"># NumberFormat( count_tipo.sum_sintasar )# reg</td>
            <td align="right">&nbsp;</td>
          </tr>
        <tr>
          <td>Gráfico </td>
          <td align="right"><select name="mostrar" id="mostrar" style="width:150px">
			<cfloop list="#mostrar_opt#" index="opt" delimiters=";">
	            <option value="#ListFirst(opt)#" <cfif  ListFirst(opt) eq url.mostrar>selected="selected"</cfif>># HTMLEditFormat(ListRest(opt)) #</option>
			</cfloop>
          </select>          </td>
          <td align="right">&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td align="right">&nbsp;</td>
          <td align="right">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="3" align="right"><input type="submit" name="accion" class="btnFiltrar" value="Actualizar" /></td>
          </tr>
      </table>
          </form></cfoutput>
      <table border="0" cellpadding="2" cellspacing="0" width="100%">
        <tr>
          <td colspan="8" valign="top" >&nbsp;</td>
        </tr>
        <tr>
          <td colspan="8" valign="top" class="subTitulo">Estado de los procesos de tasación </td>
        </tr>
          <cfoutput query="ISBtasarStatus" group="hostname">
        <tr class="listaCorte">
          <td align="left" valign="top" colspan="7">Servidor: # HTMLEditFormat( hostname )#
		  	(configurado para # NumberFormat(procesos) # procesos de # NumberFormat(maxFilas) # filas)	
			<cfset sum_registrosTotal=0>	  </td>
          </tr>
		  <cfif Len(servicio)>
        <tr class="tituloListas">
          <td align="center" valign="top">&nbsp;</td>
          <td align="center" valign="top">Servicio</td>
          <td align="center" valign="top">Datasource</td>
          <td colspan="2" align="center" valign="top">Status</td>
          <td align="center" valign="top">Procesado</td>
          <td align="center" valign="top">&nbsp;</td>
        </tr></cfif>
		<cfoutput><cfif Len(registrosTotal)><cfset sum_registrosTotal=sum_registrosTotal+registrosTotal></cfif><cfif Len(servicio)>
			<cfif Len(horaReporte)>
				<cfset inactivo = DateDiff('s', horaReporte, fechabd.fecha )>
			<cfelse>
				<cfset inactivo = 0>
			</cfif>
            <tr>
              <td align="center" valign="top">&nbsp;</td>
              <td align="center" valign="top"><a href="javascript:mostrar_servicio('#JSStringFormat(servicio)#')"># HTMLEditFormat(servicio) #</a></td>
              <td align="center" valign="top"># HTMLEditFormat( datasource )#</td>
              <td align="center" valign="top">
			  <cfif (inactivo GT 10) And Not ListFind('runnable,stopped', estado)><strong>inactivo</strong>
				<cfelse># HTMLEditFormat( estado )#
				</cfif></td>
              <td align="center" valign="top"><cfif Len(Trim(mensaje))><a href="javascript:mostrar_servicio('#JSStringFormat(servicio)#')">
			  <img src="../images/warning16.png" width="16" height="16" border="0"/></a>
			  <cfelse>&nbsp;</cfif></td>
              <td align="center" valign="top"># NumberFormat( registrosTotal )#</td>
              <td align="center" valign="top">&nbsp; </td>
            </tr>
            <tr id="tr# HTMLEditFormat( servicio  )#" style="display:none">
              <td align="center" valign="top">&nbsp;</td>
              <td colspan="6" align="center" valign="top">
			    <cf_web_portlet_start titulo="Detalle de la tarea" tipo="mini" width="380" >
			      <table border="0" width="380" cellspacing="0" cellpadding="2">
			        
			        <tr>
			          <td valign="top">Crudo procesado</td>
      <td valign="top"># NumberFormat( registrosTotal )#</td>
      </tr>
			        <tr>
			          <td valign="top">Tamaño del bloque </td>
      <td valign="top"># NumberFormat( bloqueCant )#</td>
      </tr>
			        <tr>
			          <td valign="top">Inicio del bloque </td>
      <td valign="top"># NumberFormat( bloqueInicio )#</td>
      </tr>
			        <tr>
			          <td valign="top">Fin del bloque </td>
      <td valign="top"># NumberFormat( bloqueFinal )#</td>
      </tr>
			        <tr>
			          <td valign="top">Valor actual </td>
	  <td valign="top"># NumberFormat( bloqueActual )#</td>
      </tr>
			        <tr>
			          <td valign="top">Hora de inicio </td>
      <td valign="top"># DateFormat( horaInicio, 'dd-MMM' )# # TimeFormat( horaInicio, 'h:mm:ss tt' )#</td>
      </tr>
			        <tr>
			          <td valign="top">Timestamp </td>
      <td valign="top"># DateFormat( horaReporte, 'dd-MMM' )# # TimeFormat( horaReporte, 'h:mm:ss tt' )#</td>
      </tr>
			          <td valign="top">Tiempo inactivo </td>
      <td valign="top"># NumberFormat(inactivo) # s</td>
      </tr>
			        <cfif Len(Trim(mensaje))>
			          <tr>
			            <td valign="top" colspan="2">Mensaje </td>
      </tr>
			          <tr>
			            <td valign="top" colspan="2"><cfloop list="#mensaje#" index="msgline" delimiters="#Chr(13)##Chr(10)#">
			              # HTMLEditFormat( msgline )#<br /></cfloop></td>
      </tr></cfif>
  </table>
			      <cf_web_portlet_end> 			  </td>
              </tr>
          </cfif></cfoutput> 
		  <cfif Len(servicio)>
        <tr class="tituloListas">
          <td align="center" valign="top">&nbsp;</td>
          <td align="center" valign="top">&nbsp;</td>
          <td align="center" colspan="3" valign="top"><em>Total  "# HTMLEditFormat( LCase( hostname ))#"</em></td>
          <td align="center" valign="top">#NumberFormat(sum_registrosTotal)#</td>
          <td align="center" valign="top">&nbsp;</td>
        </tr></cfif>         </cfoutput>
      </table>
	  
	  <cfinclude template="consulta-rs.cfm">
	  </td>
  </tr>
</table>
<cf_web_portlet_start tipo="mini" width="350"><cf_web_portlet_end> 

<cf_web_portlet_end> 


<script type="text/javascript">
function mostrar_servicio(servicio) {
	var tr = document.all ? document.all['tr'+servicio] : document.getElementById('tr'+servicio);
	if (tr == document.tr_servicio) {
		tr.style.display = 'none';
		document.tr_servicio = null;
	} else {
		if(document.tr_servicio)document.tr_servicio.style.display = 'none';
		tr.style.display = '';
		document.tr_servicio = tr;
	}
}
function detalle(s) {
	if (s == 'Sin Tasar') {
		location.href = 'sintasar.cfm?mp=<cfoutput>#mostrar_periodo#</cfoutput>';
	}
}
</script>
<iframe name="proceso" id="proceso" width="2" height="5" frameborder="0" style="display:none"></iframe>
<cf_templatefooter>