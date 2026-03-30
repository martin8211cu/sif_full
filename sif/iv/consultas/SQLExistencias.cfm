<!---►►Estilos◄◄--->
<style type="text/css">
	#printerIframe {
		  position: absolute;
		  width: 0px; height: 0px;
		  border-style: none;
		}
</style>

<!---►►Si se esta Viendo el reporte reporte y se hace cambio de empresa, se direcciona pantalla de filtro◄◄--->
<cfif not isdefined("form.btnConsultar")>
	<cflocation addtoken="no" url="Existencias.cfm">
</cfif>

<!---►►Inicializacion de Variables◄◄--->        
<cfparam name="form.almaceni" default="">	
<cfparam name="form.almacenf" default="">

<!---►►Funciones Javascrip◄◄--->
<script type="text/javascript">
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
			if (confirm('To print a page with this browser ' +
						'we need to open a window with the page. Do you want to continue?')) {
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
	}
		
	function printFrame (frame) {
	  if (frame.print) {
		frame.focus();
		frame.print();
		frame.src = "about:blank"
	  }
	}
		
</script>
	
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
		<cfif not  isdefined("form.toExcel")>
			<cf_templatecss>
			<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#DFDFDF">
			  <tr align="left"> 
				<td><a href="/cfmx/sif/">SIF</a></td>
				<td>|</td>
				<td nowrap><a href="../MenuIV.cfm">Inventarios</a></td>
				<td>|</td>
				<td><a href="../consultas/Existencias.cfm">Regresar</a></td>
				<td align="right" width="100%">
				<cfoutput>
					<a href="javascript:printURL('ExistenciasImpr.cfm?almaceni=#form.almaceni#&almacenf=#form.almacenf#&articuloi=#form.articuloi#&articulof=#form.articulof#');">Imprimir</a>
				</cfoutput>
				</td>
			  </tr>
			</table>
		</cfif>	
		<cfinclude template="formExistencias.cfm">
		<iframe name="printerIframe" id="printerIframe" src="about:blank">
		</iframe>
		</td>	
	</tr>
</table>