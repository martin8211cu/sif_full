<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
		<!--- Cuando veo el detalle del reporte y cambio de empresa,
			  me devuelve a la pantalla de filtro --->
		<cfif isdefined("url.Aid") and url.Aid neq "">
			<cfparam name="Form.Aid" default="#url.Aid#">
		</cfif>

		<cfif not isdefined("form.btnConsultarArticulo") and not isdefined("url.Aid")>
			<cflocation addtoken="no" url="Articulo.cfm">
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
        
		<cfif not  isdefined("form.toExcel")>
			<cf_templatecss>
			<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#DFDFDF">
			  <tr align="left"> 
				<td><a href="/cfmx/sif/">SIF</a></td>
				<td>|</td>
				<td nowrap><a href="../MenuIV.cfm">Inventarios</a></td>
				<td>|</td>
				<td><a href="javascript:funcRegresar();">Regresar</a></td>    
				<td align="right" width="100%">
				<cfoutput>
					<a href="javascript:printURL('ArticuloImpr.cfm?Aid=#form.Aid#');">Imprimir</a>
				</cfoutput>
				</td>
			  </tr>
			</table>
		</cfif>
		<cfinclude template="formArticulo.cfm">
		<iframe name="printerIframe" id="printerIframe" src="about:blank">
		</iframe>
		</td>	
	</tr>
</table>

<cfif isdefined("form.btnConsultarArticulo")>
	<form name="form1" method="post" action="Articulo.cfm" >
	</form>
<cfelse>
	<cfoutput>
        <cfif isdefined("form.almini") and not isdefined("url.almini")>
            <cfset url.almini = form.almini>
        </cfif>
        <cfif isdefined("form.almfin") and not isdefined("url.almfin")>
            <cfset url.almfin = form.almfin>
        </cfif>
        <cfif isdefined("form.Acodigo1") and not isdefined("url.Acodigo1")>
            <cfset url.Acodigo1 = form.Acodigo1>
        </cfif>
        <cfif isdefined("form.Acodigo2") and not isdefined("url.Acodigo2")>
            <cfset url.Acodigo2 = form.Acodigo2>
        </cfif>
        <cfif isdefined("form.perini") and not isdefined("url.perini")>
            <cfset url.perini = form.perini>
        </cfif>
        <cfif isdefined("form.perfin") and not isdefined("url.perfin")>
            <cfset url.perfin = form.perfin>
        </cfif>
        <cfif isdefined("form.mesini") and not isdefined("url.mesini")>
            <cfset url.mesini = form.mesini>
        </cfif>
        <cfif isdefined("form.mesfin") and not isdefined("url.mesfin")>
            <cfset url.mesfin = form.mesfin>
        </cfif>

        <form name="form1" method="post" action="SQLKardexResumido.cfm">
            <input name="almini" type="hidden" value="<cfif isdefined("url.almini")>#url.almini#</cfif>" />
            <input name="almfin" type="hidden" value="<cfif isdefined("url.almfin")>#url.almfin#</cfif>" />
            <input name="Acodigo1" type="hidden" value="<cfif isdefined("url.Acodigo1")>#url.Acodigo1#</cfif>" />
            <input name="Acodigo2" type="hidden" value="<cfif isdefined("url.Acodigo2")>#url.Acodigo2#</cfif>" />
            <input name="perini" type="hidden" value="<cfif isdefined("url.perini")>#url.perini#</cfif>" />
            <input name="perfin" type="hidden" value="<cfif isdefined("url.perfin")>#url.perfin#</cfif>" />
            <input name="mesini" type="hidden" value="<cfif isdefined("url.mesini")>#url.mesini#</cfif>" />
            <input name="mesfin" type="hidden" value="<cfif isdefined("url.mesfin")>#url.mesfin#</cfif>" />
            <input name="btnConsultar" type="hidden" value="consultar" />
        </form>
    </cfoutput>
</cfif>

<script type="text/javascript" language="javascript">
	function funcRegresar(){
		document.forms[1].submit();
	}
</script>	