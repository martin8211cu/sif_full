<cf_web_portlet_start titulo="Consulta de Actualización a los Modelos de Base de Datos" width="100%">
<cf_templatecss>
	<cf_dbfunction name="OP_Concat" returnvariable="CAT" datasource="asp">
	<cfif isdefined("url.IDdsn")>
		<cfquery name="rsSQL" datasource="asp">
			select s.IDsch, s.sch, m.IDmod, m.modelo, d.dsn, coalesce(d.IDverUlt,0) as IDverUlt			
			  from DBMdsn d
			  	inner join DBMmodelos m
					on m.IDmod = d.IDmod
				inner join DBMsch s
					on s.IDsch = m.IDsch
			 where IDdsn = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IDdsn#">
		</cfquery>
	<cfelseif isdefined("url.IDgen")>
		<cfquery name="rsSQL" datasource="asp">
			select s.IDsch, s.sch, m.IDmod, m.modelo, d.dsn, coalesce(d.IDverUlt,0) as IDverUlt, g.fcreacion
										,case p.stsP
											when 0 then 
												case g.sts
													when 0 then '<strong>GENERACION INICIADA</strong>'
													when 1 then '<strong>GENERACION SCRIPT</strong>'
													when 2 then '<strong>SCRIPT GENERADO</strong>'
													when 3 then '<strong>BASE DATOS ACTUALIZADA</strong>'
												end
											when 3  then 'Cargando Version...'
											when 4  then 'Cargando Base Datos...'
											when 5  then 'Comparando Base Datos...'
											when 21 then 'Generando Script...'
											when 22 then 'Ejecutando Script...'
											when 23 then 'Errores de Base Datos'
										end as status,
										p.msg
			  from DBMgen g
				left join DBMgenP p
					on p.IDgen = g.IDgen
			  	inner join DBMdsn d
					on d.IDdsn = g.IDdsn
			  	inner join DBMmodelos m
					on m.IDmod = d.IDmod
				inner join DBMsch s
					on s.IDsch = m.IDsch
			 where g.IDgen = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IDgen#">
		</cfquery>
	</cfif>
	<cfoutput>
	<table border="0">
		<tr>
			<td colspan="2"><strong>SCHEMA:</strong></td>
			<td colspan="2">#rsSQL.sch#</td>
		</tr>
		<tr>
			<td colspan="2"><strong>MODELO:</strong></td>
			<td colspan="2">#rsSQL.modelo#</td>
		</tr>
		<tr>
			<td colspan="2"><strong>DSN:</strong></td>
			<td colspan="2">#rsSQL.dsn#</td>
		</tr>
		<tr>
			<td colspan="2"><strong>DBM GENERADO:</strong></td>
			<td colspan="2">#rsSQL.IDverUlt#</td>
		</tr>
	<cfset LvarDSN = rsSQL.dsn>
	<cfset LvarIDmod = rsSQL.IDmod>
	<cfset LvarIDverUlt = rsSQL.IDverUlt>
	<cfif isdefined("url.IDgen")>
		<tr>
			<td colspan="2"><strong>INICIO GENERACION:</strong></td>
			<td colspan="2">#rsSQL.fcreacion#</td>
		</tr>
		<tr>
			<td colspan="2"><strong>STATUS:</strong></td>
			<td colspan="2">#rsSQL.status#&nbsp;&nbsp;<font color="##FF0000">#rsSQL.msg#</font></td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;</td>
		</tr>
		<cfset LvarTAB1 = "DBMs EN PROCESO">
	<cfelse>
		<tr>
			<td colspan="4">&nbsp;</td>
		</tr>
		<cfset LvarTAB1 = "DBMs PENDIENTES">
	</cfif>
	</table>
	<cf_tabs>
		<cfquery name="rsSQL" datasource="asp">
			select IDver, fec, des, parche
			  from DBMversiones
			 where IDmod = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarIDmod#">
			   and IDver > <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarIDverUlt#">
			 order by IDver
		</cfquery>
		<cfif rsSQL.recordCount GT 0>
			<cf_tab id="1" text="<strong>#LvarTAB1# (#LvarDSN#)</strong>">
				<table>
					<cfif isdefined("url.IDgen")>
						<cfset LvarScript = expandPath("/asp/parches/DBmodel/scripts/") & "G" & numberFormat(url.IDgen,"0000000000") & ".sql">
						<cfset LvarScriptExe = replace(LvarScript,".sql","_exe.txt")>
						<cfset LvarScriptErr = replace(LvarScript,".sql","_err.txt")>
						<cfset LvarScriptHtml = replace(LvarScript,".sql",".htm")>
						<tr>
							<td colspan="4">&nbsp;</td>
						</tr>
						<cfif fileExists(LvarScript)>
						<tr>
							<td colspan="4" nowrap>
								<img src="/cfmx/asp/parches/images/Script.gif" style="cursor:pointer" onclick="location.href = 'DBMupgrades_sql.cfm?OP=40&IDgen=#url.IDgen#';" alt="Script de Base de Datos">
								Script de base de datos
							</td>
						</tr>
						</cfif>
						<cfif fileExists(LvarScriptExe)>
							<tr>
								<td colspan="4" nowrap>
									<img src="/cfmx/asp/parches/images/Script.gif" style="cursor:pointer" onclick="location.href = 'DBMupgrades_sql.cfm?OP=41&IDgen=#url.IDgen#';" alt="Resultado Script de Base de Datos">
									Resultado de la ejecución del Script de base de datos
								</td>
							</tr>
							</cfif>
							<cfif fileExists(LvarScriptErr)>
							<tr>
								<td colspan="4" nowrap>
									'<img src="/cfmx/asp/parches/images/Cferror.gif" style="cursor:pointer" onclick="location.href = 'DBMupgrades_sql.cfm?OP=42&IDgen=#url.IDgen#';" alt="Reporte de Errores">
									Errores en la ejecución del Script de base de datos
								</td>
							</tr>
							<tr>
								<td colspan="4" nowrap>
									<img src="/cfmx/asp/parches/images/ok16.png" onclick="sbIrVerificar()" style="cursor:pointer;"/>
									<a href="javascript:sbIrVerificar()">
									Verficar la Integridad de Base de Datos
									</a>
								</td>
								<script language="javascript">
									function sbIrVerificar()
									{
										popUpWindow_1("DBMintegrity.cfm",0,0,1200,"100%");
									}
									
									var popUpWin=null;
									function popUpWindow_1(URLStr, left, top, width, height){
									  if(popUpWin){
										if(!popUpWin.closed)
											popUpWin.close();
									  }
									  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no,width='+(screen.width-50)+',height='+(screen.height-150)+',left=10, top=10');
									}
								</script>
							</tr>
							<tr><td>&nbsp;</td></tr>
						</cfif>
					</cfif>
					<tr>
						<td colspan="4">
							<table>
								<tr>
									<td align="right"><strong>DBM&nbsp;ID.</strong>&nbsp;&nbsp;</td>
									<td><strong>FECHA</strong>&nbsp;&nbsp;</td>
									<td><strong>DESCRIPCION</strong>&nbsp;&nbsp;</td>
									<td><strong>PARCHE</strong></td>
								</tr>
								<cfloop query="rsSQL">
								<tr>
									<td align="right">#rsSQL.IDver#&nbsp;&nbsp;</td>
									<td>#dateFormat(rsSQL.fec,"DD/MM/YYYY")#&nbsp;&nbsp;</td>
									<td>#rsSQL.des#&nbsp;&nbsp;</td>
									<td>#rsSQL.parche#</td>
								</tr>
								</cfloop>
							</table>
						</td>
					</tr>
					<cfif isdefined("url.IDgen")>
						<cfset sbModificaciones()>
					</cfif>
				</table>
			</cf_tab>
		</cfif>

		<cfquery name="rsSQL" datasource="asp">
			select IDver, fec, des, parche,
					case 
						when IDver <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarIDverUlt#">
						then '<strong>OK (#LvarDSN#)</strong>'
					<cfif isdefined("url.IDgen")>
						else '<strong style="color: ##00FF00">DBM EN PROCESO (#LvarDSN#)</strong>'
					<cfelse>
						else '<strong style="color:##FF0000">DBM DESACTUALIZADO (#LvarDSN#)</strong>'
					</cfif>
					end as status
			  from DBMversiones
			 where IDmod = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarIDmod#">
			 order by IDver desc
		</cfquery>
		<cfif rsSQL.recordCount GT 0>
			<cf_tab id="2" text="<strong>STATUS DBM (#LvarDSN#)</strong>">
				<table>
					<tr>
						<td colspan="4">
							<table>
								<tr>
									<td align="right"><strong>DBM&nbsp;ID.</strong>&nbsp;&nbsp;</td>
									<td><strong>FECHA</strong>&nbsp;&nbsp;</td>
									<td><strong>DESCRIPCION</strong>&nbsp;&nbsp;</td>
									<td><strong>PARCHE</strong></td>
									<td><strong>STATUS</strong></td>
								</tr>
								<cfloop query="rsSQL">
								<tr>
									<td align="right">#rsSQL.IDver#&nbsp;&nbsp;</td>
									<td>#dateFormat(rsSQL.fec,"DD/MM/YYYY")#&nbsp;&nbsp;</td>
									<td>#rsSQL.des#&nbsp;&nbsp;</td>
									<td>#rsSQL.parche#</td>
									<td>#rsSQL.status#</td>
								</tr>
								</cfloop>
							</table>
						</td>
					</tr>
				</table>
			</cf_tab>
		</cfif>

		<cfquery name="rsSQL" datasource="asp">
			select IDparche, parche, fechaParche, fechaAlta
			  from DBMcontrolParches
			 order by parche desc
		</cfquery>
		<cfif rsSQL.recordCount GT 0>
			<cf_tab id="3" text="<strong>FUENTES INSTALADOS</strong>">
				<table>
					<tr>
						<td colspan="4">
							<table>
								<tr>
									<td><strong>PARCHE</strong></td>
									<td><strong>FECHA PARCHE</strong>&nbsp;&nbsp;</td>
									<td><strong>FECHA INSTALADO</strong>&nbsp;&nbsp;</td>
								</tr>
								<cfloop query="rsSQL">
								<tr>
									<td>#rsSQL.parche#&nbsp;&nbsp;</td>
									<td>#dateFormat(rsSQL.fechaParche,"DD/MM/YYYY")#&nbsp;&nbsp;</td>
									<td>#dateFormat(rsSQL.fechaAlta,"DD/MM/YYYY")#&nbsp;&nbsp;</td>
								</tr>
								</cfloop>
							</table>
						</td>
					</tr>
				</table>
			</cf_tab>
		</cfif>
	</cf_tabs>
	</cfoutput>
<cf_web_portlet_end>
<cfabort>
<cffunction name="sbModificaciones">
	<cfoutput>
		<cfif fileExists(LvarScriptHtml)>
		<tr>
			<td colspan="4">
				<BR><BR><BR>
				<div style="font-size:24px" align="center" style="color:##000099; font-weight:bolder">
				MODIFICACIONES A LA BASE DE DATOS
				</div>
				<BR><BR><BR>
				<cfinclude template="/asp/parches/DBmodel/scripts/G#numberFormat(url.IDgen,"0000000000")#.htm">
			</td>
		</tr>
		</cfif>
	</cfoutput>
</cffunction>