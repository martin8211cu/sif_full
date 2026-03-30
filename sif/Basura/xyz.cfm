<script type="text/javascript">
	function printURL (url) {
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
	
	function printFrame (frame) {
	  if (frame.print) {
		frame.focus();
		frame.print();
		frame.src = "about:blank"
	  }
	}

</script>
<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td align="right">
			<a href="javascript:printURL('xyzw.cfm');">Imprimir</a>
		</td>
	</tr>
</table>
</cfoutput>
<cfinclude template="xyzw.cfm">
<iframe name="printerIframe" id="printerIframe" src="about:blank" width="0" height="0"></iframe>