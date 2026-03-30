	<cf_templateheader title="Distribucion por Conductor">
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
		<cf_templatecss>
		<cfif isdefined("url.IDdistribucion") and len(trim(url.IDdistribucion)) and not isdefined("Form.IDdistribucion")>
			<cfset Form.IDdistribucion = url.IDdistribucion>
		</cfif>
		<cfif isdefined("url.Periodo") and len(trim(url.Periodo)) and not isdefined("Form.Periodo")>
			<cfset Form.Periodo = url.Periodo>
		</cfif>
		<cfif isdefined("url.Mes") and len(trim(url.Mes)) and not isdefined("Form.Mes")>
			<cfset Form.Mes = url.Mes>
		</cfif>
		<cfif isdefined("url.DCDid") and len(trim(url.DCDid)) and not isdefined("Form.DCDid")>
			<cfset Form.DCDid = url.DCDid>
		</cfif>
		<cfif isdefined("Form.Periodo") and Len(Trim(Form.Periodo)) and Form.Periodo NEQ -1 and isdefined("Form.IDdistribucion") and Len(Trim(Form.IDdistribucion)) and Form.IDdistribucion NEQ 0 and isdefined("Form.Mes") and Len(Trim(Form.Mes))>
				<cfif isdefined("url.DCDid") and len(trim(url.DCDid)) and not isdefined("form.DCDid")>
					<cfset form.DCDid = url.DCDid>
				</cfif>
				<table width="100%" border="0" cellpadding="4" cellspacing="0">
					<tr>
						<td align="right" width="100%">
							<cfoutput>
								<a href="Distribucion.cfm">Regresar</a>
								<cfif isdefined("form.DCDid")>
								 |
								<a href="javascript:printURL('Distribucion-report.cfm?DCDid=#form.DCDid#');">Imprimir</a>
								</cfif>
							</cfoutput>
						</td>
					</tr>
					<tr>
						<td align="left" width="100%">
						<cfif not isdefined("form.DCDid")>

							<link href="/cfmx/sif/js/xtree/xtree.css" rel="stylesheet" type="text/css">
							<script language="JavaScript" src="/cfmx/sif/js/xtree/xtree.js"></script>
							
							<cfquery name="rsDistribuciones" datasource="#Session.DSN#">
								select *
								from DCD_PCClasificacionD a
								where a.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#">
									and a.Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">
									and a.IDdistribucion = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.IDdistribucion#">
									and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								order by Distribuida ASC, Fecha DESC
							</cfquery>
							
							<cfquery name="rsDistribucion_Descripcion" datasource="#Session.DSN#">
								select Descripcion
								from DCDistribucion b
								where IDdistribucion = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.IDdistribucion#">
							</cfquery>

							<script language="javascript">
								var LimgRoot = "/cfmx/sif/js/xtree/images/blank.png";
								var LimgFolderClose = "/cfmx/sif/js/xtree/images/foldericon.png"; 
								var LimgFolderOpen = "/cfmx/sif/js/xtree/images/openfoldericon.png"; 
								var LimgFile = "/cfmx/sif/js/xtree/images/file.png"; 
								var tree = new WebFXTree("<strong><cfoutput>#rsDistribucion_Descripcion.Descripcion#</cfoutput> - Periodo: <cfoutput>#form.Periodo#/#form.Mes#</cfoutput></strong>", "");
								var padres = "";
								tree.setBehavior('classic');
								tree.icon = LimgFolderClose;
								tree.openIcon = LimgFolderOpen;	
								<cfset Temp_Dist = "-1">
								<cfif rsDistribuciones.recordcount>
									<cfoutput query="rsDistribuciones">
										<cfif rsDistribuciones.Distribuida NEQ Temp_Dist>
											<cfif rsDistribuciones.Distribuida EQ 1>
												<cfset Texto = "Finalizadas">
											<cfelse>
												<cfset Texto = "Pendientes">
											</cfif>
										var Lvartreeitem#rsDistribuciones.Distribuida# = new WebFXTreeItem("#Texto#", "Distribucion-sql.cfm?IDdistribucion=#Form.IDdistribucion#&Periodo=#Form.Periodo#&Mes=#Form.Mes#&DCDid=#rsDistribuciones.DCDid#",tree,LimgFolderClose,LimgFolderOpen);
											<cfset Temp_Dist = rsDistribuciones.Distribuida>
										</cfif>
										var Lvartreeitem#rsDistribuciones.DCDid# = new WebFXTreeItem("#Fecha#", "Distribucion-sql.cfm?IDdistribucion=#Form.IDdistribucion#&Periodo=#Form.Periodo#&Mes=#Form.Mes#&DCDid=#rsDistribuciones.DCDid#",Lvartreeitem#Distribuida#,LimgFolderClose,LimgFolderOpen);
									</cfoutput>
								<cfelse>
									var Lvartreeitem = new WebFXTreeItem("No existen distribuciones.", "",tree,LimgFolderClose,LimgFolderOpen)
								</cfif>
								document.write(tree);
								tree.expand();
							</script>

						<cfelse>
							<cfoutput>
							<!--- Pintar la matriz de la Distribucion por Conductor --->
							<cfinclude template="Distribucion-report.cfm">
							</cfoutput>
						</cfif>
						</td>
					</tr>
				</table>
			<!--- <cf_web_portlet_end>	 --->
		<cfelse>
			<script>
				history.go(-1);
			</script>
		</cfif>
	<cf_templatefooter>