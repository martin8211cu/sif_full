<cfsilent>

  <cfparam name="url.f_fecha" default="">
  <cfparam name="url.f_login" default="">
  <cfparam name="url.f_telefono" default="">
  <cfparam name="url.f_servidor" default="">
  <cfparam name="url.f_ip" default="">
  <cfparam name="url.f_duracion" default="">
  <cfparam name="url.f_monto" default="">
  <cfparam name="url.f_logid" default="">	
  <cfparam name="url.f_estado" default="">	
	
	<cfquery datasource="#session.dsn#" name="detalle" maxrows="50">
		select
			TOP 50
			log_id, EVinicio,
			EVloginName, EVtelefono, access_server, ipaddr, EVduracion, EVmonto, EVestado
		from ISBeventoMedio
		where LFlote = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.LFlote#">
		<cfif Len(url.f_fecha)>and EVinicio >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#url.f_fecha#"></cfif>
		<cfif Len(url.f_login)>and lower(EVloginName) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(url.f_login)#%"></cfif>
		<cfif Len(url.f_telefono)>and EVtelefono like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#url.f_telefono#%"></cfif>
		<cfif Len(url.f_servidor)>and lower(access_server) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(url.f_servidor)#%"></cfif>
		<cfif Len(url.f_ip)>and ipaddr like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#url.f_ip#%"></cfif>
		<cfif Len(url.f_duracion)>and EVduracion >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.f_duracion#"></cfif>
		<cfif Len(url.f_monto)>and EVmonto >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.f_monto#"></cfif>
		<cfif Len(url.f_logid)>and log_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.f_logid#"></cfif>
		<cfif Len(url.f_estado)>and EVestado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.f_estado#"></cfif>
		order by log_id asc
		AT ISOLATION READ UNCOMMITTED
	</cfquery>

</cfsilent>

<div id="div_detalle">
<form action="index.cfm" method="get" name="listaDetalle" style="margin:0">
<cfoutput>
<input type="hidden" name="tab" value="fact">
<input type="hidden" name="LFlote" value="#url.LFlote#">
<input type="hidden" name="trafico" value="1">
</cfoutput>
<table width="910" border="0" cellspacing="0" cellpadding="2">
  <tr class="tituloListas">
    <td>Fecha</td>
    <td>Login</td>
    <td>Teléfono</td>
    <td>Servidor</td>
    <td>Dirección IP </td>
    <td align="right">Duración</td>
    <td align="right">Monto</td>
    <td align="center">Estado</td>
    <td align="right">log_id</td>
  </tr>
  <cfoutput>
  <tr>
    <td valign="top"><input type="text" value="#HTMLEditFormat(url.f_fecha)#" name="f_fecha" id="f_fecha" style="width:95%" onfocus="this.select()" size="10" onkeypress="if((event.which?event.which:event.keyCode)==13){ return  filtrarlistaDetalles(); }"></td>
    <td valign="top"><input type="text" value="#HTMLEditFormat(url.f_login)#" name="f_login" id="f_login" style="width:95%" onfocus="this.select()" size="10" onkeypress="if((event.which?event.which:event.keyCode)==13){ return  filtrarlistaDetalles(); }"></td>
    <td valign="top"><input type="text" value="#HTMLEditFormat(url.f_telefono)#" name="f_telefono" id="f_telefono" style="width:95%" onfocus="this.select()" size="10" onkeypress="if((event.which?event.which:event.keyCode)==13){ return  filtrarlistaDetalles(); }"></td>
    <td valign="top"><input type="text" value="#HTMLEditFormat(url.f_servidor)#" name="f_servidor" id="f_servidor" style="width:95%" onfocus="this.select()" size="10" onkeypress="if((event.which?event.which:event.keyCode)==13){ return  filtrarlistaDetalles(); }"></td>
    <td valign="top"><input type="text" value="#HTMLEditFormat(url.f_ip)#" name="f_ip" id="f_ip" style="width:95%" onfocus="this.select()" size="10" onkeypress="if((event.which?event.which:event.keyCode)==13){ return  filtrarlistaDetalles(); }"></td>
    <td valign="top" align="right"><input type="text" value="#HTMLEditFormat(url.f_duracion)#" name="f_duracion" id="f_duracion" style="width:95%" onfocus="this.select()" size="10" onkeypress="if((event.which?event.which:event.keyCode)==13){ return  filtrarlistaDetalles(); }"></td>
    <td valign="top" align="right"><input type="text" value="#HTMLEditFormat(url.f_monto)#" name="f_monto" id="f_monto" style="width:95%" onfocus="this.select()" size="10" onkeypress="if((event.which?event.which:event.keyCode)==13){ return  filtrarlistaDetalles(); }"></td>
    <td valign="top" align="center">
	<select name="f_estado" id="f_estado" onchange="return  filtrarlistaDetalles();" >
	<option value="">(Todas)</option>
	<option value="E" <cfif url.f_estado is 'E'>selected</cfif>>Enviada</option>
	<option value="A" <cfif url.f_estado is 'A'>selected</cfif>>Aplicada</option>
	<option value="I" <cfif url.f_estado is 'I'>selected</cfif>>Inconsistente</option>
	<option value="M" <cfif url.f_estado is 'M'>selected</cfif>>Morosa</option>
	<option value="L" <cfif url.f_estado is 'L'>selected</cfif>>Liquidada</option>
	</select></td>
    <td valign="top"  align="right"><input type="text" value="#HTMLEditFormat(url.f_logid)#" name="f_logid" id="f_logid" style="width:95%" onfocus="this.select()" size="10" onkeypress="if((event.which?event.which:event.keyCode)==13){ return  filtrarlistaDetalles(); }"></td>
  </tr></cfoutput>
<cfoutput query="detalle">
<cfset lista = ListGetAt('listaPar,listaNon', CurrentRow mod 2 + 1)>
  <tr class="#lista#" onmouseover="this.className='#lista#Sel';" onmouseout="this.className='#lista#';" style="cursor:default">
    <td valign="top"><div style="width:100;overflow:hidden;white-space:nowrap">#DateFormat(EVinicio,'dd-mmm')#&nbsp;#TimeFormat(EVinicio,'HH:mm')#</div></td>
    <td valign="top"><div style="width:75;overflow:hidden;white-space:nowrap" title="#HTMLEditFormat(EVloginName)#">#HTMLEditFormat(EVloginName)#</div></td>
    <td valign="top"><div style="width:100;overflow:hidden;white-space:nowrap">#HTMLEditFormat(EVtelefono)#</div></td>
    <td valign="top"><div style="width:150;overflow:hidden;white-space:nowrap">#HTMLEditFormat(Access_Server)#</div></td>
    <td valign="top"><div style="width:100;overflow:hidden;white-space:nowrap">#HTMLEditFormat(ipaddr)#</div></td>
    <td valign="top" align="right"><div style="width:75;overflow:hidden;white-space:nowrap">
	<cfif EVduracion GE 86400>
		#NumberFormat(Int(EVduracion/86400))# d
	</cfif>
	<cfif EVduracion GE 3600>
		#TimeFormat(EVduracion/86400, 'H:mm:ss')#
	<cfelse>
		#TimeFormat(EVduracion/86400, 'm:ss')#
	</cfif>	</div></td>
    <td valign="top" align="right"><div style="width:75;overflow:hidden;white-space:nowrap">#NumberFormat(EVmonto, ',0.00')#</div></td>
    <td valign="top" align="center"><div style="width:100;overflow:hidden;white-space:nowrap">#HTMLEditFormat(EVestado)#</div></td>
    <td valign="top"  align="right"><div style="width:100;overflow:hidden;white-space:nowrap">&nbsp;#NumberFormat(log_id)#</div></td>
  </tr>
</cfoutput>
</table>
</form>
<cfif detalle.RecordCount is 0>
<br /><strong>Nota: </strong>No hay llamadas por mostrar.  Quite los filtros usados para ver todos los detalles.
<cfelseif detalle.RecordCount is 50>
<br /><strong>Nota: </strong>Se muestran las primeras 50 llamadas.  Utilice los filtros o descarge el archivo para obtener más detalles.
</cfif>
</div>


<script type="text/javascript">
function filtrarlistaDetalles(){
	document.listaDetalle.submit();
	return false;
}
</script>