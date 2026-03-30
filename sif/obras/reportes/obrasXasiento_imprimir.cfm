<cfsetting enablecfoutputonly="yes" requesttimeout="36000" showdebugoutput="no">

<cfinclude template="../Componentes/functionsPeriodo.cfm">
<cfset LvarPeriodos = fnPeriodoContable ()>
<cfset LvarTitulo = "Reporte de Obras por Asiento">

<cfset LvarTotales = arrayNew(1)>

<cfinclude template="../../Utiles/sifConcat.cfm">
<cftry>
	<!--- Obtiene las Obras no Liquidadas --->
	<cf_jdbcquery_open name="rsDatos" datasource="#session.DSN#">
	<cfoutput>
		select 
			obp.OBPcodigo, obo.OBOcodigo, c.Cformato, o.Oficodigo, d.Dmovimiento, d.Eperiodo, d.Emes, d.Eperiodo*100+d.Emes as EanoMes
			,e.Efecha, cc.Cdescripcion as Cconcepto, e.Edocumento, Edescripcion, d.Doriginal, m.Miso4217 , d.Dlocal    
			
			,<cf_dbfunction name="sPart" args="obp.OBPdescripcion,1,40"> as OBPdescripcion
			,<cf_dbfunction name="sPart" args="o.Odescripcion,1,40">     as Odescripcion
			,<cf_dbfunction name="sPart" args="obo.OBOdescripcion,1,40"> as OBOdescripcion
			,<cf_dbfunction name="sPart" args="c.Cdescripcion,1,40">     as Cdescripcion
			
		  from OBobra obo
		  	inner join OBproyecto obp
			   on obp.OBPid 	= obo.OBPid
			  and obp.OBTPid	= #form.OBTPid#
		  	 inner join Usuario u
			   on u.Usucodigo = obo.UsucodigoAbierto
			 inner join CFinanciera cf
				inner join PCDCatalogoCuenta cubo <cf_dbforceindex name="PCDCatalogoCuenta_11">
					inner join CContables c
						 on c.Ccuenta = cubo.Ccuentaniv
				   on cubo.Ccuenta = cf.Ccuenta
				  and cubo.PCDCniv = #form.Cnivel#
				inner join HDContables d
					inner join HEContables e
						inner join ConceptoContableE cc
						   on cc.Ecodigo = e.Ecodigo
						  and cc.Cconcepto = e.Cconcepto
					   on e.IDcontable = d.IDcontable
					inner join Monedas m
					   on m.Ecodigo = d.Ecodigo
					  and m.Mcodigo = d.Mcodigo
					inner join Oficinas o
					   on o.Ecodigo = d.Ecodigo
					  and o.Ocodigo = d.Ocodigo
				   on d.Ccuenta = cf.Ccuenta
				  and d.Ecodigo = #session.Ecodigo#
			<cfif form.Speriodo1 EQ form.Speriodo2>
				  and d.Eperiodo = #form.Speriodo1#
				  and d.Emes	 >= #form.Smes1#
				  and d.Emes	 <= #form.Smes2#
			<cfelse>
				  and 
				  	(
							d.Eperiodo 	= #form.Speriodo1#
						and d.Emes	 	>= #form.Smes1#
					OR
							d.Eperiodo 	= #form.Speriodo2#
						and d.Emes	 	<= #form.Smes2#
					OR
							d.Eperiodo 	> #form.Speriodo1#
						and d.Eperiodo 	< #form.Speriodo2#
					)
			</cfif>
			   on cf.Ecodigo = obo.Ecodigo
			  and <cf_dbfunction name="like" args="cf.CFformato, rtrim(obo.CFformatoObr) #_Cat# '%'">
			<cfif form.Cformato1 NEQ "">
				<cfif form.Cformato2 EQ "">
					<cfset form.Cformato2=form.Cformato1 & chr(255)>
				<cfelse>
					<cfset form.Cformato2=form.Cformato2 & chr(255)>
				</cfif>
			  and cf.CFformato >= '#form.Cformato1#'
			  and cf.CFformato <= '#form.Cformato2#'
			</cfif>
		 where obo.Ecodigo = #session.Ecodigo#
		order by
			  obp.OBPcodigo
			, obo.OBOcodigo
			, Cformato
			, d.Eperiodo, d.Emes
			, Oficodigo
			, Efecha
	</cfoutput>
	</cf_jdbcquery_open>
	
	<cfflush interval="512">
	<cfif isdefined("form.btnDownload") or form.btnName EQ "btnDownload">
		<cfheader name="Content-Disposition" value="attachment;filename=rptCedula.xls">
		<cfcontent type="application/vnd.ms-excel">
	</cfif>
	<cfoutput>
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
	"http://www.w3.org/TR/html4/loose.dtd">
	<html>
		<head>
			<title>#LvarTitulo#</title>
	
			<style type="text/css">
			<!--
				.repHeader {
					font-family: Arial, Helvetica, sans-serif;
					font-weight:bold;
					text-align:center;
					font-size: 14px;
				}
				.colHeader {
					font-family: Arial, Helvetica, sans-serif;
					font-weight:bold;
					text-align:center;
					border:solid 1px ##000000;
					font-size: 10px;
					padding-left:2px;
					padding-right:2px;
					background-color: ##EBEBEB;
				}
				.colData {
					font-family: Arial, Helvetica, sans-serif;
					font-size: 10px;
					padding-left:1px;
				}
				.colCortePry {
					font-family: Arial, Helvetica, sans-serif;
					font-size: 12px;
					font-weight:bold;
					padding-left:1px;
				}
				.colCorteObr {
					font-family: Arial, Helvetica, sans-serif;
					font-size: 11px;
					font-weight:bold;
					padding-left:1px;
				}
			-->
			</style>
		</head>

		<body style="size:portrait; page:'letter';">
			<cfset LvarCols=10>
			<table border="0" cellpadding="0" cellspacing="0" align="center" style="border-collapse:collapse">
				<tr><td colspan="#LvarCols#" class="repHeader">#Session.Enombre#</td></tr>
				<tr><td colspan="#LvarCols#" class="repHeader">#LvarTitulo#</td></tr>
				<tr>
					<td colspan="#LvarCols#" class="repHeader">
						<cfif form.Speriodo1 EQ form.Speriodo2>
							<cfif form.Smes1 EQ form.Smes2>
								de #fnNombreMes(form.Smes1)# de #form.Speriodo1#
							<cfelse>
								de #fnNombreMes(form.Smes1)# a #fnNombreMes(form.Smes2)# de #form.Speriodo1#
							</cfif>
						<cfelse>
							de #fnNombreMes(form.Smes1)# de #form.Speriodo1# a #fnNombreMes(form.Smes2)# de #form.Speriodo2#
						</cfif>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td class="colHeader" width="50">Cuenta</td>
					<td class="colHeader">Fecha</td>
					<td class="colHeader">Concepto</td>
					<td class="colHeader">Póliza</td>
					<td class="colHeader">Descripción</td>
					<td class="colHeader">Tipo</td>
					<td class="colHeader">Monto Origen</td>
					<td class="colHeader">Moneda</td>
					<td class="colHeader">Debitos</td>
					<td class="colHeader">Creditos</td>
				</tr>
	</cfoutput>

	<cfset LvarTotales[1] = structNew()>
	<cfset LvarTotales[2] = structNew()>
	<cfset LvarTotales[3] = structNew()>
	<cfset LvarTotales[4] = structNew()>
	<cfset LvarTotales[5] = structNew()>
	<cfset LvarTotales[6] = structNew()>
	<cfset LvarTotales[1].DBs=0>
	<cfset LvarTotales[1].CRs=0>
	<cfoutput query="rsDatos" group="OBPcodigo">
		<cfset LvarTotales[2].DBs=0>
		<cfset LvarTotales[2].CRs=0>
		<TR>
			<TD class="colCortePry" colspan="8">
				Proyecto: <strong>#OBPcodigo#</strong> #OBPdescripcion#
			</TD>
		</TR>
		<cfoutput group="OBOcodigo">
			<cfset LvarTotales[3].DBs=0>
			<cfset LvarTotales[3].CRs=0>
			<TR>
				<TD class="colCorteObr" colspan="8">
					&nbsp;&nbsp;&nbsp;Obra: <strong>#OBOcodigo#</strong> #OBOdescripcion#
				</TD>
			</TR>
			<cfoutput group="Cformato">
				<cfset LvarTotales[4].DBs=0>
				<cfset LvarTotales[4].CRs=0>
				<TR>
					<TD>&nbsp;</TD>
				</TR>
				<TR>
					<TD class="colCorteObr" colspan="8">
						&nbsp;&nbsp;&nbsp;&nbsp;Cuenta: <strong>#Cformato#: #Cdescripcion#</strong> 
					</TD>
				</TR>
				<cfoutput group="EanoMes">
					<cfset LvarTotales[5].DBs=0>
					<cfset LvarTotales[5].CRs=0>
					<TR>
						<TD class="colCorteObr" colspan="8">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mes: <strong>#Eperiodo# - #Emes#</strong>
						</TD>
					</TR>
					<cfoutput group="Oficodigo">
						<cfset LvarTotales[6].DBs=0>
						<cfset LvarTotales[6].CRs=0>
						<tr>
							<TD class="colCorteObr" colspan="8">
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Oficina: #Oficodigo# - #Odescripcion#
							</TD>
						</tr>
						<cfoutput>
							<tr>
								<td class="colData">&nbsp;</td>
								<td class="colData">
									#dateFormat(Efecha, "DD/MM/YY")#&nbsp;
								</td>
								<td class="colData">
									#Cconcepto#&nbsp;
								</td>
								<td class="colData">
									#Edocumento#&nbsp;
								</td>
								<td class="colData">
									#Edescripcion#&nbsp;
								</td>
								<td class="colData" align="center">
									#Dmovimiento#
								</td>
								<td class="colData" align="right">
									#NumberFormat(Doriginal,",9.99")#
								</td>
								<td class="colData">
									&nbsp;#Miso4217#s&nbsp;
								</td>
								<td class="colData" align="right">
									<cfif Dmovimiento EQ "D">
									&nbsp;#NumberFormat(Dlocal,",9.99")#
									</cfif>
								</td>
								<td class="colData" align="right">
									<cfif Dmovimiento EQ "C">
									&nbsp;#NumberFormat(Dlocal,",9.99")#
									</cfif>
								</td>
							</tr>
							<cfif Dlocal NEQ "">
								<cfif Dmovimiento EQ "D">
									<cfset LvarTotales[6].DBs = LvarTotales[6].DBs + Dlocal>
								<cfelse>
									<cfset LvarTotales[6].CRs = LvarTotales[6].CRs + Dlocal>
								</cfif>
							</cfif>
						</cfoutput>
						<!--- Totales por Oficodigo --->
						<TR>
							<TD class="colCorteObr" colspan="8">
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Total Oficina #Oficodigo#
							</td>
							<td class="colData" align="right" style="font-weight:bold;">
								#NumberFormat(LvarTotales[6].DBs,",9.99")#
							</td>
							<td class="colData" align="right" style="font-weight:bold;">
								#NumberFormat(LvarTotales[6].CRs,",9.99")#
							</td>
						</TR>
						<cfset LvarTotales[5].DBs = LvarTotales[5].DBs + LvarTotales[6].DBs>
						<cfset LvarTotales[5].CRs = LvarTotales[5].CRs + LvarTotales[6].CRs>
					</cfoutput>
					<!--- Totales por OBOcodigo --->
					<TR>
						<TD class="colCorteObr" colspan="8">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Total Mes #Eperiodo# - #Emes#
						</td>
						<td class="colData" align="right" style="font-weight:bold;">
							#NumberFormat(LvarTotales[5].DBs,",9.99")#
						</td>
						<td class="colData" align="right" style="font-weight:bold;">
							#NumberFormat(LvarTotales[5].CRs,",9.99")#
						</td>
					</TR>
					<cfset LvarTotales[4].DBs = LvarTotales[4].DBs + LvarTotales[5].DBs>
					<cfset LvarTotales[4].CRs = LvarTotales[4].CRs + LvarTotales[5].CRs>
				</cfoutput>
				<!--- Totales por OBOcodigo --->
				<TR>
					<TD class="colCorteObr" colspan="8">
						&nbsp;&nbsp;&nbsp;&nbsp;Total Cuenta #Cformato#
					</td>
					<td class="colData" align="right" style="font-weight:bold;">
						#NumberFormat(LvarTotales[4].DBs,",9.99")#
					</td>
					<td class="colData" align="right" style="font-weight:bold;">
						#NumberFormat(LvarTotales[4].CRs,",9.99")#
					</td>
				</TR>
				<cfset LvarTotales[3].DBs = LvarTotales[3].DBs + LvarTotales[4].DBs>
				<cfset LvarTotales[3].CRs = LvarTotales[3].CRs + LvarTotales[4].CRs>
			</cfoutput>
			<TR>
				<TD class="colCorteObr" colspan="8">
					&nbsp;&nbsp;&nbsp;Total Obra #OBOcodigo#
				</td>
				<td class="colData" align="right" style="font-weight:bold;">
					#NumberFormat(LvarTotales[3].DBs,",9.99")#
				</td>
				<td class="colData" align="right" style="font-weight:bold;">
					#NumberFormat(LvarTotales[3].CRs,",9.99")#
				</td>
			</TR>
			<cfset LvarTotales[2].DBs = LvarTotales[2].DBs + LvarTotales[3].DBs>
			<cfset LvarTotales[2].CRs = LvarTotales[2].CRs + LvarTotales[3].CRs>
		</cfoutput>
		<!--- Totales por OBPcodigo --->
		<TR>
			<TD class="colCortePry" colspan="8">
				Total Proyecto #OBPcodigo#
			</td>
			<td class="colData" align="right" style="font-weight:bold;">
				#NumberFormat(LvarTotales[2].DBs,",9.99")#
			</td>
			<td class="colData" align="right" style="font-weight:bold;">
				#NumberFormat(LvarTotales[2].CRs,",9.99")#
			</td>
		</TR>
		<TR><TD>&nbsp;</TD></TR>
		<cfset LvarTotales[1].DBs = LvarTotales[1].DBs + LvarTotales[2].DBs>
		<cfset LvarTotales[1].CRs = LvarTotales[1].CRs + LvarTotales[2].CRs>
	</cfoutput>
	<cfoutput>
	<!--- Totales Generales --->
	<TR>
		<TD class="colCortePry" colspan="8">
			TOTALES GENERALES
		</td>
		<td class="colData" align="right" style="font-weight:bold;">
			#NumberFormat(LvarTotales[1].DBs,",9.99")#
		</td>
		<td class="colData" align="right" style="font-weight:bold;">
			#NumberFormat(LvarTotales[1].CRs,",9.99")#
		</td>
	</TR>
		</table>
	</body>
</html>
	</cfoutput>
	<cf_jdbcquery_close>
<cfcatch>
	<cf_jdbcquery_close>
	<cfrethrow>
</cfcatch>
</cftry>
