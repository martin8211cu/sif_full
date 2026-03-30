<!--- 
	<cf_templateheader title="Contabilidad General"> --->

		<style type="text/css">
		#printerIframe {
		  position: absolute;
		  width: 0px; height: 0px;
		  border-style: none;
		  /* visibility: hidden; */
		}
		</style>
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

		<!--- <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='&nbsp;'>
			<cfinclude template="../../portlets/pNavegacion.cfm"> 
			<cf_templatecss>--->
			<cfif isdefined("form.CGARepid") and trim(form.CGARepid) eq 2>
				<cfinclude template="EstadoResultadosA-form.cfm">
			<cfelse>	
				<cfinclude template="gastosA-form.cfm">
			</cfif>
			<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe>
		<!--- <cf_web_portlet_end>
		
	<cf_templatefooter> --->