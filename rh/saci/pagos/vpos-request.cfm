<cfparam name="url.datos" default="0,0">
<cfparam name="url.validar" default="">

<cfsavecontent variable="style">
<style type="text/css">
<!--
table.pleasewait {
	background-color: #FFFF99;
	border: 2px solid #FFCC00;
	font-size:12px;
	font-weight: bold;
	font-family: Arial, Helvetica, sans-serif;
	padding-right:10px;
}
.style1 {
	color: #003399;
	font-weight: bold;
}
.BlackText { 
	color:#000000;
	font-size: 12px;
	font-family: Arial, Helvetica, sans-serif;
}
.style2 {color: #000000; font-size: 12px; font-family: Arial, Helvetica, sans-serif; font-weight: bold; }

.detalle { 
	border:solid 2px #b6b6b6;
}

-->
</style></cfsavecontent>
<cfhtmlhead text='#style#'>
<cfinvoke component="vpos" method="sendData" returnvariable="vpos_struct"
	datos="#url.datos#" validar="#url.validar#" />
<cfquery datasource="#session.dsn#" name="pago">
	select p.PTid, p.PTmonto,
		p.POorigen, p.POtran,
		po.POdescripcion,
		p.PTlogin,
		p.PTdescripcion,
		p.PTnombre,
		p.PTcuenta,
		p.PTcorreo,
		pa.Miso4217a
	from ISBpago p
		join ISBpagoOrigen po
			on po.POorigen = p.POorigen
			and po.POtran = p.POtran
		join ISBpagoAutorizador pa
			on pa.PAautoriza = p.PAautoriza
	where PTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vpos_struct.PTid#">
</cfquery>

<cfif isdefined("pago.POorigen") and pago.POorigen eq "SACI">
<cf_templateheader title="Transacción segura de pago">
</cfif>

<cfif isdefined("pago.POorigen") and pago.POorigen eq "SACI">
<cf_web_portlet_start titulo="Transacción segura de pago">
</cfif>
<cfoutput>
<form name="frmSolicitudPago" method="post" action="#HTMLEditFormat(vpos_struct.NEXTURL)#" onsubmit="return sendmsg();">
<input type="hidden" name="XMLREQ" value="#HTMLEditFormat(vpos_struct.XMLREQ)#" />
<input type="hidden" name="DIGITALSIGN" value="#HTMLEditFormat(vpos_struct.DIGITALSIGN)#" />
<input type="hidden" name="IDACQUIRER" value="2" />
<input type="hidden" name="IDCOMMERCE" value="1900" />
<input type="hidden" name="SESSIONKEY" value="#HTMLEditFormat(vpos_struct.SESSIONKEY)#" />

<table width="500" border="0" cellspacing="0" cellpadding="1" align="center">
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="center" class="style1">Transacción segura de pago</td>
	</tr>

</table>

<table width="500" border="0" cellspacing="0" cellpadding="1" align="center">  
  <tr>
    <td class="style1">Realizar pago </td>
  </tr>
  <tr>
	<td class="detalle" valign="top" >
		<table border="0"  cellspacing="2" cellpadding="1" align="left">
			  <td class="style2"> Importe:</td>
			    <td class="BlackText">#NumberFormat(pago.PTmonto, ',0.00')# # HTMLEditFormat(pago.Miso4217a) #</td>
		  </tr>
		  <tr>
		  <tr>
			<td class="style2">Número de orden:</td>
			<td class="BlackText">#NumberFormat(pago.PTid, '0')#</td>
		  </tr>
			<cfif Len(pago.PTcuenta)>
		  <tr>
			<td class="style2">Número de Cuenta:</td>
			<td class="BlackText">#NumberFormat(pago.PTcuenta, '0')#</td>
		  </tr>
		  </cfif>
		 
			<cfif Len(pago.PTnombre)>
		  <tr>
			<td class="style2">Nombre de Cliente:</td>
			<td class="BlackText">#HTMLEditFormat(pago.PTnombre)#</td>
		  </tr>
		  </cfif>
		
		 <cfif Len(pago.PTcorreo)>
		  <tr>
			<td class="style2">Correo Electr&oacute;nico:</td>
			<td class="BlackText">#HTMLEditFormat(pago.PTcorreo)#</td>
		  </tr>
		  </cfif>
		
		
		  <tr>
			<td class="style2">Concepto:</td>
			<td class="BlackText">#HTMLEditFormat(pago.POdescripcion)#</td>
		  </tr><cfif Len(Trim(pago.PTdescripcion))>
		  <tr>
			<td>&nbsp;</td>
			<td class="BlackText">#HTMLEditFormat(pago.PTdescripcion)#</td>
		  </tr></cfif>
		  <tr>
			<td colspan="2" align="center">&nbsp;</td>
		  </tr>
		</table>
		  <tr>
			<td colspan="2" align="center"><input type="submit" name="continuar" class="btnSiguiente" value="Continuar con el pago" /></td>
		  </tr>	
	</td>
</table>
</form>
</cfoutput>
<form name="form2" action="javascript:void(0)" style="margin:60px;display:none">
<table cellpadding="7" class="pleasewait" align="center"><tr><td>
<img src="loading.gif" width="16" height="16" border="0">
</td>
<td>
Preparando su pago...</td>
</tr></table></form>
<script type="text/javascript">
<!--
<!---<cfif Arguments.sendform>
document.frmSolicitudPago.submit();
</cfif>--->
function sendmsg(){
	document.form2.style.display='';
	document.frmSolicitudPago.continuar.disabled = true;
	document.frmSolicitudPago.style.display='none';
	return true;
}
//-->
</script>
<cfif isdefined("pago.POorigen") and pago.POorigen eq "SACI">
<cf_web_portlet_end>
<cf_templatefooter>
</cfif>