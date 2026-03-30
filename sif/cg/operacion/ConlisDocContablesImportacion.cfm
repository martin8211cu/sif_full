<cfsetting requesttimeout="#24*3600#">

<cfif isdefined("Url.ECIid") and Len(Trim(Url.ECIid)) and not isdefined("Form.ECIid")>
	<cfparam name="Form.ECIid" default="#Url.ECIid#">
<cfelseif isdefined("Session.ImportarAsientos") and isdefined("Session.ImportarAsientos.ECIid") and Len(Trim(Session.ImportarAsientos.ECIid)) and not isdefined("Form.ECIid")>
	<cfparam name="Form.ECIid" default="#Session.ImportarAsientos.ECIid#">
</cfif>
<style type="text/css">
	#printerIframe {
	  position: absolute;
	  width: 0px; height:  0px;
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
	
<table width="100%" border="0" cellpadding="4" cellspacing="0" >
	<tr align="left"> 
		<td align="right" width="100%">
		<cfoutput>
		<a href="javascript:printURL('DocsContablesImportacionImpr.cfm?ECIid=#Form.ECIid#');">Imprimir</a>
		</cfoutput>
		</td>
	</tr>
	<tr>
		<td><cfinclude template="ConlisDocContablesImportacion-form.cfm"></td>
	</tr>
	
</table>

<iframe name="printerIframe" id="printerIframe" src="about:blank">
	</iframe> 
