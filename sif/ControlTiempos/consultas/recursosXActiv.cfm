<cf_template>
	<cf_templatearea name="title">
		Recursos por Actividad
	</cf_templatearea>
	<cf_templatearea name="body">
		<cf_web_portlet titulo="Recursos por Actividad">
			<cfinclude template="../../portlets/pNavegacion.cfm">
			<br>
			<cfif isdefined("Url.CTAcodigo") and not isdefined("Form.CTAcodigo")>
				<cfparam name="Form.CTAcodigo" default="#Url.CTAcodigo#">
			</cfif> 
			<cfif isdefined("Url.CTPcodigo") and not isdefined("Form.CTPcodigo")>
				<cfparam name="Form.CTPcodigo" default="#Url.CTPcodigo#">
			</cfif> 
			<cfif isdefined("Url.fecDesde") and not isdefined("Form.fecDesde")>
				<cfparam name="Form.fecDesde" default="#Url.fecDesde#">
			</cfif> 
			<cfif isdefined("Url.fecHasta") and not isdefined("Form.fecHasta")>
				<cfparam name="Form.fecHasta" default="#Url.fecHasta#">
			</cfif>
			<cfif isdefined("Url.Empresa") and not isdefined("Form.Empresa")>
				<cfparam name="Form.Empresa" default="#Url.Empresa#">
			</cfif>
			<cfif isdefined("Url.Proy") and not isdefined("Form.Proy")>
				<cfparam name="Form.Proy" default="#Url.Proy#">
			</cfif>		
			<cfif isdefined("Url.nombreAct") and not isdefined("Form.nombreAct")>
				<cfparam name="Form.nombreAct" default="#Url.nombreAct#">
			</cfif>		  
			
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
			
			function dosubmit(form){
				if (form == 0){
					document.form0.submit();
				}else{
					document.form1.proyecto.value="";
					document.form1.submit();
				}
			}			
			
		</script>	
		
<form action="ChartHorasXPry.cfm" method="post" name="form0">
			<table width="100%" >
			  <tr align="left"> 
				<td>
					<cfoutput>
						<input name="fecDesde" type="hidden" value="#form.fecDesde#">
						<input name="fecHasta" type="hidden" value="#form.fecHasta#">
 						<input name="proyecto" type="hidden" value="#form.CTPcodigo#">
					</cfoutput>
				</td>
			  </tr>
			</table>
			</form>			


 			<cfinclude template="formRecursosXActiv.cfm">		
			
		</cf_web_portlet>
	</cf_templatearea>	
</cf_template>