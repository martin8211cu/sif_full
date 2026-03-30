<cf_templateheader title="Inventarios">
		
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Conciliaci&oacute;n de Art&iacute;culos'>
			<!--- Rodolfo Jimenez Jara, 12/02/2004, SOIN, CentroAmerica --->
			<cfquery datasource="#session.DSN#" name="rsTransforma">
				select count(d.Acodigo) as Acodigo
				from DTransformacion d, ETransformacion e
				where e.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and d.ETid = e.ETid
			</cfquery> 
		
			<cfquery name="rsTransforma" datasource="#Session.DSN#">
				select ETid from ETransformacion 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and ETfechaProc is null
			</cfquery>
		
			<cfif isdefined("rsTransforma") and len(trim(rsTransforma.ETid)) NEQ 0> 
				<cfset form.ETid = rsTransforma.ETid>
			</cfif>
			<style type="text/css">
				#printerIframe {
					position: absolute;
					width: 0px; height: 0px;
					border-style: none;
					/* visibility: hidden; */
				}
			</style>
			<script type="text/javascript">
				<!--//
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
						if (confirm('To print a page with this browser we need to open a window with the page. Do you want to continue?')) {
							var win = window.open('', 'printerWindow', 'width=600,height=300,resizable,scrollbars,toolbar,menubar');
							var html = '';
							html += '<html>';
							html += '<frameset rows="100%, *" onload="opener.printFrame(window.urlToPrint);">';
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
				//-->
			</script>
			<cfset vParam = "">
			<cfif isdefined("form.ckPend")>
				<cfset vParam =  vParam  & "ckPend=1">
			</cfif>
			<cfif isdefined("form.ETid")>
				<cfset vParam =  vParam  & "ETid="& form.ETid>
			</cfif>
			<cfif isdefined("url.ETid") and not isdefined("form.ETid")>
				<cfset vParam =  vParam  & "ETid="& Url.ETid>
			</cfif>
		
			<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#DFDFDF">
				<tr align="left"> 
					<td><a href="/cfmx/sif/">SIF</a></td>
					<td>|</td>
					<td nowrap><a href="../MenuIV.cfm">Inventarios</a></td>
					<td>|</td>
					<td><a href="/cfmx/sif/iv/operacion/Transforma-form3.cfm">Regresar</a></td>
					<td align="right" width="100%">
						<cfoutput>
						<a href="javascript:printURL('ConciliaTransitoImpr.cfm?<cfif len(trim(vParam)) NEQ 0>&#vParam#</cfif>');">Imprimir</a>
						</cfoutput>
						<cfoutput>
						<input name="ETid_" type="hidden" value="<cfif isdefined("Form.ETid")>#Form.ETid#</cfif>">
						</cfoutput>
					</td>
				</tr>
			</table>
			<cfinclude template="ConciliaTransito-form.cfm">
			<iframe name="printerIframe" id="printerIframe" src="about:blank">
			</iframe>
	<cf_web_portlet_end>
	<cf_templatefooter>