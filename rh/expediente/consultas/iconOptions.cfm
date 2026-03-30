<script type="text/javascript">

	function buttonOver(obj) {
		obj.className="botonDown";
	}

	function buttonOut(obj) {
		obj.className="botonUp";
	}
	
	function printURL (url) {
	  if (window.print && window.frames && window.frames.printerIframe) {
		var html = '';
		html += '<html>';
		html += '<body onload="parent.printFrame(window.frames.urlToPrint);">';
		html += '<iframe name="urlToPrint" src="' + url + '"><\/iframe>';
		html += '<\/body><\/html>';
		var ifd = window.frames.printerIframe.document;
		ifd.open();
		ifd.write(html);
		ifd.close();
	  }
	  else {
				var win = window.open('', 'printerWindow', 'width=600,height=300,resizable,scrollbars,toolbar,menubar');
				var html = '';
				html += '<html>';
				html += '<frameset rows="100%, *" ' 
					 +  'onload="opener.printFrame(window.urlToPrint);">';
				html += '<frame name="urlToPrint" src="' + url + '" \/>';
				html += '<frame src="about:blank" \/>';
				html += '<\/frameset><\/html>';
				win.document.open();
				win.document.write(html);
				win.document.close();
	  }
	}
	
	function printFrame (frame) {
	  if (frame.print) {
		frame.focus();
		frame.print();
		frame.src = "about:blank"
	  }
	}
</script>		
<cfoutput>

<table border="0" cellpadding="1" cellspacing="0" style="height: 24px;">
	<tr>
		<cfif Session.Params.ModoDespliegue EQ 1>
			<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript:location.href='/cfmx/home/menu/empresa.cfm'">
				<img src="/cfmx/rh/imagenes/number0_16.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Inicio">Inicio</cf_translate></font>
			</td>
		<cfelseif Session.Params.ModoDespliegue EQ 0>
			<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript:location.href='/cfmx/rh/autogestion/plantilla/menu.cfm'">
				<img src="/cfmx/rh/imagenes/number0_16.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Inicio">Inicio</cf_translate></font>
			</td>
		</cfif>
		<cfif (isdefined("Form.DEid") and Len(Trim(Form.DEid)) NEQ 0) or (isdefined("rsEmpleado") and isdefined("rsEmpleado.DEid") and Len(Trim(rsEmpleado.DEid)) NEQ 0)>
			<cfif  Session.Params.ModoDespliegue EQ 0 or acceso_uri(proceso & '/sa')>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: document.verHistorico.submit();">
					<img src="/cfmx/rh/imagenes/money.gif" border="0" align="top" hspace="2"><font size="+2">&nbsp;<cf_translate key="LB_Salarios">Salarios</cf_translate></font>
				</td>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript:document.verHistorico.action='HistoricoPagos.cfm'; document.verHistorico.submit();">
					<img src="/cfmx/rh/imagenes/Cfscript.gif" border="0" align="top" hspace="2"><font size="+2">&nbsp;<cf_translate key="LB_Pagos">Pagos</cf_translate></font>
				</td>
			</cfif>
		</cfif>
		<cfif Session.Params.ModoDespliegue EQ 1>
			<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid)) NEQ 0>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript:printURL('/cfmx/rh/expediente/consultas/expediente-all-print.cfm?DEid=#Form.DEid#&imprimir=true');">
					<img src="/cfmx/rh/imagenes/toolbar_print2.GIF" border="0" align="top" hspace="2"><font size="+2">&nbsp;<cf_translate key="LB_Imprimir">Imprimir</cf_translate></font>
				</td>
			</cfif>
		<cfelseif Session.Params.ModoDespliegue EQ 0>
			<!---<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid)) NEQ 0>---->
			<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid)) NEQ 0 or (isdefined("rsEmpleado") and isdefined("rsEmpleado.DEid") and Len(Trim(rsEmpleado.DEid)) NEQ 0)>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript:printURL('/cfmx/rh/expediente/consultas/expediente-all-print.cfm?DEid=#rsEmpleado.DEid#&imprimir=true');">
					<img src="/cfmx/rh/imagenes/iedit.gif" border="0" align="top" hspace="2"><font size="+2">&nbsp;<cf_translate key="LB_Imprimir">Imprimir</cf_translate></font>
				</td>
			</cfif>
		</cfif>
		<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid)) NEQ 0>
			<cfif Session.Params.ModoDespliegue EQ 1>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript:location.href='../../capacitacion/expediente/expediente.cfm?DEID=<cfoutput>#trim(form.DEID)#</cfoutput>';">
					<img src="/cfmx/rh/imagenes/iedit.gif" border="0" align="top" hspace="2"><font size="+2">&nbsp;<cf_translate key="LB_ExpDeCapacitacion">Exp. de capacitaci&oacute;n</cf_translate></font>
				</td>
				<cfif not isdefined("Form.toconcursantes")>
					 <td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript:location.href='/cfmx/rh/expediente/consultas/expediente-globalcons.cfm'">
						<img src="/cfmx/rh/imagenes/find.small.png" border="0" align="top" hspace="2"><font size="+2">&nbsp;<cf_translate key="LB_SeleccionarEmpleado">Seleccionar Empleado</cf_translate></font>
					</td>
				</cfif>		
			</cfif>
		</cfif>
	</tr>
	<tr style="display:none">
		<td>
			<cfset action = "">
			<cfif Session.Params.ModoDespliegue EQ 1>
				<cfset action = "lineaTiempo.cfm">
			<cfelseif Session.Params.ModoDespliegue EQ 0>
				<cfset action = "lineaTiempoEmp.cfm">
			</cfif>
			<form name="verHistorico" action="#action#" method="post" style="display:none">
				<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid)) NEQ 0>
					<input type="hidden" name="DEid" value="#Form.DEid#">
				<cfelseif isdefined("rsEmpleado") and isdefined("rsEmpleado.DEid") and Len(Trim(rsEmpleado.DEid)) NEQ 0>
					<input type="hidden" name="DEid" value="#rsEmpleado.DEid#">
				</cfif>
				<input type="hidden" name="o" value="<cfif isdefined("Form.o")>#Form.o#<cfelse>1</cfif>">
				<input type="hidden" name="sel" value="1">
				<input type="hidden" name="Regresar" value="#GetFileFromPath(GetTemplatePath())#">
			</form>	
		</td>
	</tr>
</table>
<form name="reqEmpl" action="expediente-globalcons.cfm" method="post" style="margin: 0;">
	<input type="hidden" name="o" value="">
	<input type="hidden" name="DEid" value="">
</form>

</cfoutput>
