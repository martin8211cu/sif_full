<cfparam name="url.aspsessid" default=""> 

<cfif len(url.aspsessid)>
	
	<cfquery datasource="aspmonitor" name="hdr">
		select
			sessionid, login,
			desde, ip, Usucodigo, user_agent, http_host,
			cerrada, motivo_cierre
		from MonProcesos a
		where sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.aspsessid#">
		order by desde desc
	</cfquery>
</cfif>
<cfif IsDefined("hdr.RecordCount") and hdr.RecordCount neq 0>
	<cfquery datasource="asp" name="nombre">
		select
			Pnombre, Papellido1, Papellido2
		from Usuario u, DatosPersonales dp
		where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#hdr.Usucodigo#" null="#Len(hdr.Usucodigo) is 0#">
		  and dp.datos_personales = u.datos_personales
	</cfquery>
	
	<cfquery datasource="aspmonitor" name="mini">
		select min(desde) desde
		from MonHistoria a
		where sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.aspsessid#">
	</cfquery>
	
	<cfquery datasource="aspmonitor" name="maxi">
		select max(hasta) hasta
		from MonHistoria a
		where sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.aspsessid#">
	</cfquery>
	
	<cfquery datasource="aspmonitor" name="data">
		select
			a.historiaid, a.SScodigo ,a.SMcodigo, a.SPcodigo, a.desde, a.hasta,
			b.requestid, b.method, b.uri, b.args, b.requested, b.millis
		from MonHistoria a, MonRequest b
		where a.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.aspsessid#">
		  and b.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.aspsessid#">
		  and b.sessionid = a.sessionid
		  and b.historiaid = a.historiaid
		order by a.historiaid desc, b.requestid desc
	</cfquery>
	<cfoutput>
	<table  border="0" cellspacing="2" cellpadding="0" width="80%">
	  <tr>
		<td valign="top" nowrap>Sesi&oacute;n:</td>
		<td colspan="2" valign="top">#hdr.sessionid# (IP: #hdr.ip#)</td>
	  </tr>
	  <tr>
		<td valign="top" nowrap>Usuario:</td>
		<td colspan="2" valign="top">#hdr.Usucodigo# - #hdr.login# - #nombre.Pnombre#
			# HTMLEditFormat(nombre.Papellido1)# # HTMLEditFormat(nombre.Papellido2)# </td>
	  </tr>
	  <tr>
		<td valign="top" nowrap>Iniciada: </td>
		<td colspan="2" valign="top">#DateFormat(mini.desde,'DD/MM/YYYY')# #TimeFormat(mini.desde,'HH:mm:ss')#</td>
	  </tr>
	  <tr>
		<td valign="top" nowrap>Accesada: </td>
		<td colspan="2" valign="top">#DateFormat(maxi.hasta,'DD/MM/YYYY')# #TimeFormat(maxi.hasta,'HH:mm:ss')#</td>
	  </tr>
	  <tr>
	    <td valign="top" nowrap>User-Agent:</td>
	    <td colspan="2" valign="top">#hdr.user_agent#</td>
      </tr>
	  <tr>
	    <td valign="top" nowrap>Http_Host:</td>
	    <td colspan="2" valign="top">#hdr.http_host#</td>
      </tr>
	  <tr>
		<td valign="top" nowrap>Duraci&oacute;n: </td>
		<td valign="top">
		<cfif Len(mini.desde) and Len(maxi.hasta)>
		<cfset diff = DateDiff('s',mini.desde,maxi.hasta)>
		# Int (diff/3600)#h	# Int (diff/60) mod 60#m	# diff mod 60#s
		</cfif>
		</td>
	    <td rowspan="2" valign="top">
		<cfif hdr.cerrada NEQ 1>
		<form method="post" action="kill.cfm" style="margin:0 "><input type="hidden" name="victim" value="#hdr.sessionid#">
		<input type="submit" name="kill" id="kill" value="Desconectar usuario"></form>
		</cfif>
		</td>
	  </tr>
	  <tr>
		<td valign="top" nowrap>Inactiva: </td>
		<td valign="top">
		<cfif Len(maxi.hasta)>
		<cfset diff = DateDiff('s',maxi.hasta,Now())>
		<cfif diff gt 30*600><strong>M&aacute;s de diez horas</strong><cfelse>
		# Int (diff/3600)#h	# Int (diff/60) mod 60#m	# diff mod 60#s</cfif>
		</cfif></td>
      </tr>
	  <tr>
	    <td valign="top" nowrap>Estado</td>
	    <td colspan="2" valign="top"><cfif hdr.cerrada is 1>Desconectada
		<cfif hdr.motivo_cierre is 'K'> por el administrador
		<cfelseif hdr.motivo_cierre is 'L'> por el usuario (logout) <cfelse> por timeout</cfif>
		<cfelse>Conectada</cfif>&nbsp;</td>
      </tr>
	</table>
	</cfoutput>
<table width="100%"><tr><td width="60%" valign="top">
	<div style="height:250px;overflow:auto;width:100%;border:1px solid black ">
	
	<table  border="0" cellspacing="0" cellpadding="2" width="100%">
		  <tr  class="tituloListas">
			<td ><strong>Hora</strong></td>
			<td ><strong>Duraci&oacute;n</strong></td>
			<td ><strong>Servicio</strong></td>
		  </tr>
	</table>
	<table  border="0" cellspacing="0" cellpadding="2" width="100%">
		  <cfoutput query="data" group="historiaid">
		  <tr>
			<td valign="top"><a onClick="showhide('rowdet#CurrentRow#')" style="cursor:pointer;font-weight:bold">#TimeFormat(desde,'HH:mm:ss')#</a></td>
			<td valign="top"><cfset diff = DateDiff('s',desde,hasta)>
				<a onClick="showhide('rowdet#CurrentRow#')" style="cursor:pointer;font-weight:bold"># NumberFormat(Int (diff/3600),'0')#:# NumberFormat(Int (diff/60) mod 60,'00')#:# NumberFormat(diff mod 60,'00')#</a>
			</td>
			<td valign="top"><a onClick="showhide('rowdet#CurrentRow#')" style="cursor:pointer;font-weight:bold">#HTMLEditFormat(SScodigo)# #HTMLEditFormat(SMcodigo)# #HTMLEditFormat(SPcodigo)#</a></td>
		  </tr>
		  <tr >
			<td valign="top"></td>
			<td valign="top" nowrap colspan="2"><div id="rowdet#CurrentRow#" style="display:none ">
			<cfoutput><cfif millis ge 0>
			<cfset duracion=NumberFormat(Int (millis/3600000),'0') & ':' & 
				NumberFormat(Int (millis/60000) mod 60,'00') & ':' & NumberFormat(Int (millis/1000) mod 60,'00') & '.' &
				NumberFormat(millis mod 1000)>
			<cfelse>
				<cfset duracion='N/D'>
			</cfif>
			
			<!--- esto es para que vea el password --->
			<cfset secargs = REReplaceNoCase(args, '(J_PASSWORD)=([^&]+)', '\1=*****',  'all')>
			<div><a style="cursor:pointer " onClick="detrequest('#JSStringFormat(TimeFormat(requested,'HH:mm:ss'))
				#','#JSStringFormat(duracion)
				#','#JSStringFormat(method)#','#JSStringFormat(uri)#','#JSStringFormat(secargs)#',#requestid#,this)">
		  
			<cfif ListLen(uri,'/') gt 2>
				<cfset uri2 = ListGetAt(uri, ListLen(uri,'/')-1,'/') & '/' & ListLast(uri,'/')>
			<cfelse>
				<cfset uri2 = uri>
			</cfif>#HTMLEditFormat(method)# #HTMLEditFormat(uri2)#
			</a></div>
			</cfoutput>
			</div>
			</td>
			
		  </tr></cfoutput>
	  </table></div>
	  
</td><td width="40%" valign="top">

	<form name="formdet" id="formdet" action="" onSubmit="return false;" method="get">
	  <table  border="0" cellspacing="0" cellpadding="0" width="100%">
	  <tr><td colspan="3" class="subTitulo">Request ID #<input type="text" name="requestid" id="requestid" style="border:0 none white"></td></tr>
	<tr>
	<td width="35%">Hora	  </td>
	<td width="35%">Duraci&oacute;n	  </td>
	<td width="30%">M&eacute;todo	  </td>
	</tr>
	<tr>
	  <td><input readonly name="hora" type="text" id="hora2" style="width:100%"></td>
	  <td><input readonly name="duracion" type="text" id="duracion2" style="width:100%"></td>
	  <td><input readonly name="metodo" type="text" id="metodo" style="width:100%"></td>
	</tr>
	<tr>
	<td colspan="3">URI</td>
	</tr>
	<tr>
	  <td colspan="3">
	  <textarea readonly wrap="soft" name="uri" type="text" id="uri" rows="4" style="width:100%;font-family:Arial, Helvetica, sans-serif;font-size:10px"></textarea>
	  </td>
	  </tr>
	<tr>
	<td colspan="3">Args</td>
	</tr>
	<tr>
	  <td colspan="3"><textarea readonly wrap="soft" name="argumentos" rows="6" type="text" id="argumentos" style="width:100%;font-family:Arial, Helvetica, sans-serif;font-size:10px"></textarea></td>
	  </tr>
	</table>
	  </form>

</td></tr></table>	  
	  

<script type="text/javascript">
detrequest_sel = null;
function detrequest(hora,duracion,metodo,uri,argumentos,requestid,obj){
	document.formdet.hora.value = hora;
	document.formdet.duracion.value = duracion;
	document.formdet.metodo.value = metodo;
	document.formdet.uri.value = uri;
	document.formdet.argumentos.value = argumentos.split('&').join('\r\n');
	document.formdet.requestid.value = requestid;
	if (detrequest_sel != null) {
		detrequest_sel.style.backgroundColor = 'white';
	}
	detrequest_sel = obj;
	detrequest_sel.style.backgroundColor = 'skyblue';
}
function showhide(rowid){
	var r = document.getElementById(rowid);
	r.style.display = r.style.display == 'none' ? 'block' : 'none';
}
</script>

</cfif>
