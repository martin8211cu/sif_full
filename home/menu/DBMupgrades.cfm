<cfif isdefined("url._")>
	<cfset session.Refrescar = false>
</cfif>
<cf_templateheader title="Consola de Actualización a los Modelos de Base de Datos">
<cf_web_portlet_start titulo="Actualizaciones a los Modelos de Base de Datos">
<cf_templatecss>
	<cf_dbfunction name="OP_Concat" returnvariable="CAT" datasource="asp">
	<cfinclude template="DBMupgrades_load.cfm">
    <cfif not directoryExists(expandPath("/asp/parches/DBmodel/scripts"))>
    	<cfdirectory action="create" directory="#expandPath("/asp/parches/DBmodel/scripts")#">
    </cfif>
	<cfquery name="rsSQL" datasource="asp">
		select count(1) as cantidad from DBMdsn
	</cfquery>
	<cfif rsSQL.cantidad EQ 0>
		<cfthrow message="No se han configurado los Datasources para la Generación DBM. Ir a la opción: Inicio  > Portal  > Operación y Administración del Portal > Parches de Base de Datos > Configuración de Datasources">
	</cfif>
	<cfquery name="rsDSNs" datasource="asp">
		select 	m.IDsch, d.IDdsn, m.IDmod, d.IDdsn, d.activo, s.sch, m.modelo, d.dsn, coalesce(v.IDver,0) as IDverUltDsn
				, coalesce((select max(IDver) 
					 from DBMversiones
					where IDmod = m.IDmod
				  ),0) as IDverUltMod
				, (select count(1) 
					 from DBMgen
					where IDdsn = d.IDdsn
					  and sts <> 3
				  ) as pendientes
			  from DBMmodelos m
		  	inner join DBMsch s
			 on s.IDsch = m.IDsch
		  	left join DBMdsn d
			  	left join DBMversiones v
					on v.IDver = d.IDverUlt
			 on d.IDmod = m.IDmod
	</cfquery>

	<script language="javascript">
		var dis = false;
		var LvarWnd = null;
		function sbOP (op, ID)
		{
			if (dis) 
			{
				return false;
			}
			if (op == 1)
			{
				dis = true;
				location.href = "DBMdsn.cfm?IDmod=" + ID;
			}
			else if ( (op == 2) || (op == 5) )
			{
				dis = false;
				if (op == 2)
					LvarURL = "DBMupgrades_sql.cfm?OP=" + op + "&IDdsn=" + ID;
				else
					LvarURL = "DBMupgrades_sql.cfm?OP=" + op + "&IDgen=" + ID;
				{
				  if(LvarWnd && !LvarWnd.closed)
				  {
					LvarWnd.close();
				  }
					  LvarWnd = open(LvarURL, "DBMupgrade", "toolbar=no,location=no,directories=no,status=no,menubar=yes,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=700,left=10px, top=10px");
				  if (! LvarWnd && !document.LvarWnd) {
					alert("Aviso: Su bloqueador de ventanas emergentes (popup blocker) \nestá evitando que se abra la ventana.\nPor favor revise las opciones de su navegador (browser), y \nacepte las ventanas emergentes de este sitio: " + location.hostname);
					document.popupblockerwarning = 1;
				  }
				  else
					if(LvarWnd.focus) LvarWnd.focus();
				}
			}
			else if ( (op == 3) || (op == 4) )
			{
				dis = true;
				location.href = "DBMupgrades_sql.cfm?OP=" + op + "&IDdsn=" + ID;
			}
			else if ( (op == 6) || (op == 7) )
			{
				dis = true;
				location.href = "DBMupgrades_sql.cfm?OP=" + op + "&IDgen=" + ID;
			}
		}
	
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

	<cfif Application.dsinfo["asp"].type EQ "db2">
		<cfparam name="session.DB2_REORG" default="false">
		<cfif session.DB2_REORG>
			<input type="checkbox" id="DB2_REORG" checked="checked" onclick="location.href='DBMupgrades_sql.cfm?DB2_REORG=0';"/> 
			<script language="javascript">setTimeout("document.getElementById('DB2_REORG').checked = true;",1000);</script>
		<cfelse>
			<input type="checkbox" id="DB2_REORG" onclick="location.href='DBMupgrades_sql.cfm?DB2_REORG=1';"/> 
			<script language="javascript">setTimeout("document.getElementById('DB2_REORG').checked = false;",1000);</script>
		</cfif>
		Reorganizar Todas las tablas DB2
	</cfif>

	<table width="100%" cellpadding="0"  cellspacing="0">
		<tr>
			<td><strong>SCHEMA&nbsp;&nbsp;&nbsp;</strong></td>
			<td width="120"><strong>MODELO</strong></td>
			<td align="center"><strong>ULTIMO&nbsp;&nbsp;<BR>DBM&nbsp;&nbsp;</strong></td>
			<td><strong>Datasource</strong></td>
			<td align="left" colspan="2"><strong>&nbsp;ULTIMO&nbsp;<BR>&nbsp;DBM&nbsp;&nbsp;<BR>&nbsp;GENERADO&nbsp;</strong></td>
			<td><strong>&nbsp;STATUS&nbsp;</strong></td>
			<td align="center"><strong>&nbsp;AVANCE&nbsp;<BR>%</strong></td>
			<td><strong>&nbsp;TABLAS&nbsp;</strong></td>
			<td><strong>&nbsp;MSG</strong></td>
		</tr>
	<cfparam name="session.Refrescar" default="false">
	<cfset LvarRefrescar = false>
	<cfoutput query="rsDSNs" group="IDsch">
		<cfset LvarSchTD = sch>
		<cfoutput group="IDmod">
		<tr>	
			<cfif LvarSchTD NEQ "">
				<td colspan="12" style="border-top:solid ##CCCCCC 1px; height:1px; font-size:1px;">&nbsp;</td>
			<cfelse>
				<td></td>
				<td colspan="12" style="border-top:solid ##CCCCCC 1px; height:1px; font-size:1px;">&nbsp;</td>
			</cfif>
		</tr>
			<cfset LvarMod = replace(modelo,".pdm","")>
			<cfset LvarModTD 	= LvarMod>
			<cfset LvarIDverTD	= IDverUltMod>
			<cfif dsn EQ "">
				<tr>
					<td>#LvarSchTD#&nbsp;&nbsp;&nbsp;</td>
					<td>&nbsp;#LvarModTD#&nbsp;</td>
					<td align="center">&nbsp;#LvarIDverTD#&nbsp;</td>
					<td colspan="2">
					</td>
					<td colspan="1" nowrap>
						<img src="/cfmx/asp/parches/images/iindex.gif" style="cursor:pointer" onclick="return sbOP(1,#IDmod#);" title="Configurar nuevos DSNs para generar '#LvarMod#'">
						&nbsp;&nbsp;
					</td>
					<td colspan="4">
						<font color="##FF0000"><strong>FALTA ESPECIFICAR DSNs</strong></font>
					</td>
				</tr>
			</cfif>
			<cfoutput>
				<cfif dsn NEQ "">
					<cfset LvarERR = "">
					<cfif activo EQ "0">
						<cfset LvarERR = "<font color='##FF0000'>DSN inactivo</font>">
					<cfelseif NOT isdefined("application.dsinfo.#dsn#")>
						<cfset LvarERR = "<font color='##FF0000'>DSN no definido en Coldfusion</font>">
					<cfelseif application.dsinfo[dsn].schemaError NEQ "">
						<cfset LvarERR = "<font color='##FF0000'>#application.dsinfo[dsn].schemaError#</font>">
					<cfelse>
						<cf_dbcreate name="DBMgens" returnvariable="DBMgens" datasource="#dsn#">
							<cf_dbcreatecol name="IDgen"		    	type="numeric"		mandatory="yes">
							<cf_dbcreatecol name="IDmod"		    	type="numeric"		mandatory="yes">
							<cf_dbcreatecol name="IDverFin"		    	type="numeric"		mandatory="yes">
							<cf_dbcreatecol name="fgeneracion"	    	type="datetime"		mandatory="yes">
						
							<cf_dbcreatekey cols="IDgen">
						</cf_dbcreate>
	
						<cfset LvarPendientes	= pendientes>

						<cfset LvarNuevas = IDverUltMod GT IDverUltDsn>
						
						<!--- Debe verificar ultima versión generada en cada base de datos para saber si bajaron un respaldo --->
						<cfquery name="rsGens" datasource="#dsn#">
							select coalesce(max(IDverFin),0) as IDverFin
							  from DBMgens
							 where IDmod = #IDmod#
						</cfquery>

						<cfquery name="rsSQL" datasource="asp">
							select IDver from DBMversiones where IDver=#rsGens.IDverFin#
						</cfquery>
						<cfset LvarIDverGens = rsSQL.IDver>
						<cfif LvarIDverGens EQ "">
							<cfset LvarIDverGens = "0">
						</cfif>

						<cfif IDverUltDsn NEQ LvarIDverGens>
							<cfset LvarNuevas = IDverUltMod GT LvarIDverGens>
							<cfquery datasource="asp">
								update DBMdsn
								   set IDverUlt = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarIDverGens#" null="#LvarIDverGens EQ "0"#">
								 where IDdsn = #IDdsn#
							</cfquery>
							<cfset QuerySetCell(rsDSNs, "IDverUltDsn", LvarIDverGens, rsDSNs.currentRow)>
						</cfif>

						<cfif LvarNuevas>
							<cfif LvarPendientes>
								<!--- Borra pendientes que no están en proceso cuando hay nuevas actualizaciones --->
								<cfquery name="rsSQL" datasource="asp">
									select IDgen, IDverFin
									  from DBMgen
									 where IDdsn = #IDdsn#
									   and IDmod = #IDmod#
									   and sts in (1,2)
									   and (
									   		select count(1)
											  from DBMgenP
											 where IDgen = DBMgen.IDgen
											   and stsP in (0,22)
											) > 0
								</cfquery>
								<cfif rsSQL.IDgen NEQ "" AND rsSQL.IDverFin NEQ IDverUltMod>
									<cfset LvarPendientes = false>
									<cfquery datasource="asp">
										delete from DBMgenP
										 where IDgen = #rsSQL.IDgen#
									</cfquery>
									<cfquery datasource="asp">
										delete from DBMgen
										 where IDgen = #rsSQL.IDgen#
									</cfquery>
								</cfif>
							</cfif>
						</cfif>
					</cfif>

					<cfif LvarModTD EQ "">
					<tr>
						<td colspan="3"></td>
						<td colspan="12" style="border-top:solid ##CCCCCC 1px; height:1px; font-size:1px;">&nbsp;</td>
					</tr>
					</cfif>
					<tr>
						<td>#LvarSchTD#&nbsp;&nbsp;&nbsp;</td>
						<td>&nbsp;#LvarModTD#&nbsp;</td>
						<td align="center">&nbsp;#LvarIDverTD#&nbsp;</td>
						<cfset LvarSchTD 	= "">
						<cfset LvarModTD 	= "">
						<cfset LvarIDverTD	= "">

						<td><strong>#lcase(dsn)#</strong>&nbsp;</td>
						<td align="center">&nbsp;#IDverUltDsn#&nbsp;</td>

						<cfif LvarErr NEQ "">
							<td nowrap>
								<img src="/cfmx/asp/parches/images/iindex.gif" style="cursor:pointer" onclick="return sbOP(1,#IDmod#);" title="Configuracion de DSNs">
								&nbsp;&nbsp;
							</td>
							<td>#LvarErr#</td>
						<cfelseif LvarPendientes>
							<cfquery name="rsGen" datasource="asp">
								select 	g.IDgen, g.IDverFin, p.stsP, g.sts,
										case p.stsP
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
										case 
											when p.tabs=0 then 0 
											when p.tabs=1 then 1
											when p.stsP in (3,5) then p.tabsP 
											else round(p.tabsP*100.0/p.tabs,2)
										end as prc,
										p.msg,
										p.tabs
								  from DBMgen g
								 	inner join DBMgenP p
										on p.IDgen = g.IDgen
								 where g.IDdsn = #IDdsn#
								   and g.sts <> 3
							</cfquery>
							<cfset LvarErr = rsGen.msg>
							<cfset LvarErrores = expandPath("/asp/parches/DBmodel/scripts/") & "G" & numberFormat(rsGen.IDgen,"0000000000") & ".err">
							<cfif fileExists(LvarErrores)>
								<cffile action="read" file="#LvarErrores#" variable="LvarErr">
								<cftry>
									<cfquery datasource="asp">
										update DBMgenP
										   set stsP	= 0
										     , msg	= <cfqueryparam cfsqltype="cf_sql_clob" value="#left(LvarErr,500)#">
										 where IDgen = #rsGen.IDgen#
									</cfquery>
									<cffile action="delete" file="#LvarErrores#">
								<cfcatch type="database">
								</cfcatch>
								</cftry>
							</cfif>
							<cfset LvarStyle= "background-color: ##66FF66">
							<td nowrap="nowrap" style="#LvarStyle#">
							<cfif rsGen.stsP EQ 0 or rsGen.stsP EQ 23>
								<img src="/cfmx/asp/parches/images/findsmall.gif" 	style="cursor:pointer" onclick="return sbOP(5,#rsGen.IDgen#);" title="Consultar Resultados de la Generación">
								<cfset LvarScript = expandPath("/asp/parches/DBmodel/scripts/") & "G" & numberFormat(rsGen.IDgen,"0000000000") & ".sql">
								<cfif NOT FileExists(LvarScript) OR rsGen.sts NEQ 2>
									<img src="/cfmx/asp/parches/images/genScriptDL.gif" 	style="cursor:pointer" onclick="return sbOP(6,#rsGen.IDgen#);" title="Generar Script para revisión">
									<img src="/cfmx/asp/parches/images/genScript.gif" 	style="cursor:pointer" onclick="return sbOP(7,#rsGen.IDgen#);" title="Generar y Ejecutar Script en '#lcase(dsn)#'">
								<cfelse>
									<img src="/cfmx/asp/parches/images/genScript.gif" 	style="cursor:pointer" onclick="return sbOP(7,#rsGen.IDgen#);" title="Ejecutar Script en '#lcase(dsn)#'">
								</cfif>
							<cfelse>
								<font style="font-size:1px">
								&nbsp;<br>&nbsp;
								</font>
								<img src="/cfmx/asp/parches/images/working.gif"  height="16" width="16" style="top:10px;">
								<cfset LvarRefrescar = true>
							</cfif>
								&nbsp;&nbsp;
							</td>
							<td style="#LvarStyle#" nowrap="nowrap">
								#rsGen.status#
							</td>
							<td align="center" style="#LvarStyle#">
								&nbsp;#NumberFormat(rsGen.prc,",9.99")#&nbsp;
							</td>
							<td align="center" style="#LvarStyle#">
								&nbsp;#NumberFormat(rsGen.tabs,",9")#&nbsp;
							</td>
							<td style="#LvarStyle#">
								&nbsp;<font color="##FF0000"><strong>#LvarErr#</strong></font>
							</td>
						<cfelseif LvarNuevas>
							<cfset LvarStyle= "background-color: ##FFFF00">
							<td nowrap="nowrap" style="#LvarStyle#">
								<img src="/cfmx/asp/parches/images/findsmall.gif" 	style="cursor:pointer" onclick="return sbOP(2,#IDdsn#);" title="Consultar Parches">
								<img src="/cfmx/asp/parches/images/genScriptDL.gif" 	style="cursor:pointer" onclick="return sbOP(3,#IDdsn#);" title="Generar Script para revisión">
								<img src="/cfmx/asp/parches/images/genScript.gif" 	style="cursor:pointer" onclick="return sbOP(4,#IDdsn#);" title="Generar y Ejecutar Script en '#lcase(dsn)#'">
								&nbsp;&nbsp;
							</td>
							<td nowrap colspan="4" style="#LvarStyle#"><strong style="color:##CC0000">Debe Actualizar el DBM</strong></td>
						<cfelse>
							<td nowrap>
								<img src="/cfmx/asp/parches/images/findsmall.gif" 	style="cursor:pointer" onclick="return sbOP(2,#IDdsn#);" title="Consultar Parches">
								&nbsp;&nbsp;
							</td>
							<td>OK</td>
						</cfif>
					</tr>
				</cfif>
			</cfoutput>
		</cfoutput>
	</cfoutput>
	</table>
<cfif LvarRefrescar OR session.Refrescar>
	<cfif LvarRefrescar>
		<cfset session.Refrescar = false>
	</cfif>
	<script language="javascript">
		setTimeout("location.href = 'DBMupgrades.cfm';",5000);
	</script>		
</cfif>
<cf_web_portlet_end>
<img src="/cfmx/asp/parches/images/ok16.png" onclick="sbIrVerificar()" style="cursor:pointer;"/>
<a href="javascript:sbIrVerificar()">
Verficar la Integridad de Base de Datos
</a>
<cf_templatefooter>