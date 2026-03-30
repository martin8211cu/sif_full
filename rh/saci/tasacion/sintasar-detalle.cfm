<cfsilent>

	<cfquery datasource="#session.dsn#" name="mostrar_zero">
		select max(EVregistro) as mostrar_zero
		from ISBeventoBitacora
		AT ISOLATION READ UNCOMMITTED
	</cfquery>
	
	<cfquery datasource="#session.dsn#" name="fechabd">
		select getdate() as fecha
	</cfquery>

	<cfif Len(mostrar_zero.mostrar_zero)>
		<cfset mostrar_zero = mostrar_zero.mostrar_zero>
	<cfelse>
		<cfset mostrar_zero = DateAdd('n', -1, fechabd.fecha)>
	</cfif>
	<cfset mostrar_zero = CreateDateTime(Year(mostrar_zero), Month(mostrar_zero), Day(mostrar_zero),
																	Hour(mostrar_zero), Minute(mostrar_zero), Second(mostrar_zero))>

	<cfparam name="url.t" default="S">
	<cfset tabl = ListGetAt('ISBeventoSinTasar,ISBeventoLogin,ISBeventoPrepago,ISBeventoMedio', 1+ListFind('L,P,M', url.t))>
	
	<cfset cols = "EVloginName,EVtelefono,access_server,ipaddr">
	<cfset hdrs = "Login,Teléfono,Servidor,Dirección IP">
	<cfparam name="url.colname">
	<cfparam name="url.elem">
	<cfparam name="url.ma" type="numeric">
	<cfif Not ListFind(cols, url.colname)>
		<cfset url.colname = ListFirst(cols)>
	</cfif>
	
	<cfquery datasource="#session.dsn#" name="detalle" maxrows="50">
		select
			TOP 50
			log_id, EVinicio,
			EVloginName, EVtelefono, access_server, ipaddr, EVduracion,
			<cfif tabl neq 'ISBeventoSinTasar'>''  as </cfif>EVblob_data
		from #tabl#
		where EVtasacion > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('n', - url.ma , mostrar_zero)#">
		and #colname# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.elem#">
		order by EVduracion desc
		AT ISOLATION READ UNCOMMITTED
	</cfquery>


</cfsilent><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>

</head>

<body>
<div id="div_detalle">
<table width="973" border="0" cellspacing="0" cellpadding="2">
  <tr class="tituloListas">
    <td width="188">Fecha y Hora </td>
    <td width="80">Login</td>
    <td width="121">Teléfono</td>
    <td width="115">Servidor</td>
    <td width="182">Dirección IP </td>
    <td width="169">Duración (s)</td>
    <td width="90">log_id</td>
  </tr>
<cfoutput query="detalle">
<cfset lista = ListGetAt('listaPar,listaNon', CurrentRow mod 2 + 1)>
  <tr class="#lista#" onclick="mostrar('tr_det_#CurrentRow#')" style="cursor:pointer">
    <td valign="top">#DateFormat(EVinicio,'dd-mmm')#&nbsp;#TimeFormat(EVinicio,'HH:mm')#</td>
    <td valign="top">#HTMLEditFormat(EVloginName)#</td>
    <td valign="top">#HTMLEditFormat(EVtelefono)#</td>
    <td valign="top">#HTMLEditFormat(Access_Server)#</td>
    <td valign="top">#HTMLEditFormat(ipaddr)#</td>
    <td valign="top">#HTMLEditFormat(EVduracion)#</td>
    <td valign="top" >#NumberFormat(log_id)#</td>
  </tr>
  <tr class="#lista#" id="tr_det_#CurrentRow#" style="display:none">
    <td colspan="7" valign="top" class="ayuda" style="padding-left:30px">#HTMLEditFormat(EVblob_data)#</td>
    </tr>
</cfoutput>
</table>
</div>
<script type="text/javascript">
<!--
function ge(d,i){return d.all?document.all[i]:d.getElementById(i);}

ge(window.parent.document,'div_detalle').innerHTML = 
ge(document,'div_detalle').innerHTML;
//-->
</script>
</body>
</html>
