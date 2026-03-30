<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Titulo" Default="Saldos y Movimientos" 
returnvariable="LB_Titulo" xmlfile = "saldosymov01.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TituloP" Default="Saldos y Movimientos por Cuenta Contable" 
returnvariable="LB_TituloP" xmlfile = "saldosymov01.xml"/>
<cfif not isdefined("url.toexcel")>
	<cf_templateheader title="#LB_Titulo#">
</cfif>
<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
<cfif isdefined("Url.ccuenta") and not isdefined("form.ccuenta")>
	<cfset form.ccuenta = url.ccuenta>
</cfif>
<cfif isdefined("Url.cdescripcion") and not isdefined("form.cdescripcion")>
	<cfset form.cdescripcion = url.cdescripcion>
</cfif>
<cfif isdefined("Url.cfcuenta") and not isdefined("form.cfcuenta")>
	<cfset form.cfcuenta = url.cfcuenta>
</cfif>
<cfif isdefined("Url.cformato") and not isdefined("form.cformato")>
	<cfset form.cformato = url.cformato>
</cfif>
<cfif isdefined("Url.cmayor") and not isdefined("form.cmayor")>
	<cfset form.cmayor = url.cmayor>
</cfif>

<cfif isdefined("Url.cmayor_id") and not isdefined("form.cmayor_id")>
	<cfset form.cmayor_id = url.cmayor_id>
</cfif>
<cfif isdefined("Url.cmayor_mask") and not isdefined("form.cmayor_mask")>
	<cfset form.cmayor_mask = url.cmayor_mask>
</cfif>

<cfif isdefined("Url.exportar") and not isdefined("form.exportar")>
	<cfset form.exportar = url.exportar>
</cfif>
<cfif isdefined("Url.mcodigo") and not isdefined("form.mcodigo")>
	<cfset form.mcodigo = url.mcodigo>
</cfif>
<cfif isdefined("Url.mcodigoopt") and not isdefined("form.mcodigoopt")>
	<cfset form.mcodigoopt = url.mcodigoopt>
</cfif>
<cfif isdefined("Url.periodos") and not isdefined("form.periodos")>
	<cfset form.periodos = url.periodos>
</cfif>

<cfquery name="rsCuenta" datasource="#session.DSN#">
	select Ccuenta, Cmayor, Cformato, Cdescripcion,Cmovimiento
	from CContables
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Ccuenta =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccuenta#">
</cfquery>
			
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
					</style>				<script type="text/javascript">
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
				<cfif not isdefined("url.toexcel")>
					  <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_tituloP#'>
				</cfif>	
		
				<cfset form.Cformato = trim(rsCuenta.Cformato) >
				<cfset form.Cmayor = trim(rsCuenta.Cmayor)>
				<cfset form.Cdescripcion = trim(rsCuenta.Cdescripcion)>
				<cfset url.Cformato = trim(rsCuenta.Cformato) >
				<cfset url.Cmayor = trim(rsCuenta.Cmayor)>
				<cfset url.Cdescripcion = trim(rsCuenta.Cdescripcion)>
				
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				 <tr> 
					<td colspan="4"> 
						<cfif not isdefined("url.toexcel")>
							<cfinclude template="../../portlets/pNavegacion.cfm">
						</cfif>&nbsp;
					</td>
					<td>&nbsp;</td>
				  </tr>
				  <tr> 
					<td>&nbsp;</td>
					<td>
						<cfinclude template="formsaldosymov01.cfm">
					</td>
					<td>&nbsp;</td>
				  </tr>
				  <tr> 
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				  </tr>
				</table>
				   	<cfif not isdefined("url.toexcel")>
					   	<cf_web_portlet_end>
				   </cfif>
					</td>	
				</tr>
			</table>	
	<cfif not isdefined("url.toexcel")>
		<cf_templatefooter>
	</cfif>
	