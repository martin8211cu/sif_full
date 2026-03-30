
<cfif isdefined("Form.IEid") and Len(Trim(Form.IEid)) NEQ 0>
	<cfquery name="rsExpediente" datasource="#Session.DSN#">
		select 	a.IEcontenido, 
				b.EFEcodigo, 
				b.EFEdescripcion, 
				a.IEfecha
		from IncidenciasExpediente a
		
		inner join EFormatosExpediente b
		on a.EFEid = b.EFEid
		
		where a.IEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IEid#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">

	</cfquery>
	<cfset contenido = Replace(rsExpediente.IEcontenido, 'etiquetaCampo', '#Session.preferences.Skin#_thcenter', 'all')>

	<cfif not isdefined("Url.Imprimir")>
		<script language="javascript" type="text/javascript">
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
			function funcRegresar2() {
				document.form1.btnHistorial.value = '1';
			}
	
			function imprimirExpediente() {
				<cfoutput>
				printURL('/cfmx/rh/expediente/consultas/frame-expedienteincidencia-print.cfm?TEid=#Form.TEid#&DEid=#Form.DEid#&IEid=#Form.IEid#&imprimir=true');
				</cfoutput>
			}
		</script>
	</cfif>
	
	<cfoutput>
	<input type="hidden" name="btnHistorial" value="1">
	<cfif IsDefined('Form.EFEid')>
		<input type="hidden" name="EFEid" value="#form.EFEid#">
	</cfif>
	<cfif IsDefined('Form.Fecha')>
		<input type="hidden" name="IEFecha" value="#form.Fecha#">
	</cfif>
	
	
	<table width="98%"  border="0" cellspacing="0" cellpadding="2" align="center">
	  <cfif not isdefined("Url.Imprimir")>
	  <tr>
	  	<td colspan="2" align="right">
				<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab##version=5,0,0,0" width="100" height="20">
                	<param name="BGCOLOR" value="">
                	<param name="movie" value="/cfmx/rh/imagenes/btnImprimir_expediente.swf">
                	<param name="quality" value="high">
                	<embed src="/cfmx/rh/imagenes/btnImprimir_expediente.swf" quality="high" pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="100" height="20" ></embed>
                	</object>
		</td>
      </tr>
	  </cfif>
	  <tr>
		<td class="#Session.preferences.Skin#_thcenter">
			#rsExpediente.EFEcodigo# - #rsExpediente.EFEdescripcion#
		</td>
	    <td class="#Session.preferences.Skin#_thcenter" align="right">
			#LSDateFormat(rsExpediente.IEfecha, 'dd/mm/yyyy')#
		</td>
	  </tr>
	  <tr>
		<td colspan="2">
			#contenido#
		</td>
      </tr>
	  <tr>
	  	<td colspan="2">&nbsp;</td>
      </tr>
	  <cfif not isdefined("Url.Imprimir")>
	  <tr>
	  	<td colspan="2" align="center">
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Regresar"
				Default="Regresar"
				XmlFile="/rh/generales.xml"
				returnvariable="BTN_Regresar"/>
		
			<input type="submit" name="btnRegresar" class="btnAnterior" value="<cfoutput>#BTN_Regresar#</cfoutput>" onClick="javascript: return funcRegresar2();">
		</td>
      </tr>
	  </cfif>
	  <tr>
	  	<td colspan="2">&nbsp;</td>
      </tr>
	</table>
	</cfoutput>
</cfif>