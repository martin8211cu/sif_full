<cfset LvarIrA     = 'BalGralConvMon.cfm'>

<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
			<style type="text/css">
				#printerIframe {
		  			position: absolute;
		  			width: 0px; height: 0px;
		 			border-style: none;
		  			/* visibility: hidden; */
				}

			</style>
			<cfset LvarFileName = "BalGralConvMon#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
			<cf_htmlReportsHeaders 
				title="Balance General" 
				filename="#LvarFileName#"
				irA="#LvarIrA#"	>
				<cfif not isdefined("form.btnDownload")>
					<cf_templatecss>
				</cfif>	
				<cfinclude template="formBalGralCM.cfm">
		</td>	
	</tr>
</table>

<script language="javascript1.2" type="text/javascript">
	function imprimir() {
		var tablabotones = document.getElementById("tablabotones");
        tablabotones.style.display = 'none';
		window.print()	
        tablabotones.style.display = ''
	}
</script>