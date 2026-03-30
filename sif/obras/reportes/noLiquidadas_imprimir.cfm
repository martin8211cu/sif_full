
<cfsetting enablecfoutputonly="yes" requesttimeout="36000" showdebugoutput="no">

<cfinclude template="../Componentes/functionsPeriodo.cfm">
<cfset LvarPeriodos = fnPeriodoContable ()>
<cfset LvarTitulo = "Reporte de Obras Retrasadas">

<cfset LvarTotales = arrayNew(1)>

<cfinclude template="../../Utiles/sifConcat.cfm">
<cftry>
	<!--- Obtiene las Obras no Liquidadas --->
	<cf_jdbcquery_open name="rsDatos" datasource="#session.DSN#">
	<cfoutput>
		select 
			  obp.OBPcodigo, 		<cf_dbfunction name="sPart"	args="obp.OBPdescripcion,1,40"> as OBPdescripcion
			, obo.OBOcodigo, 		<cf_dbfunction name="sPart"	args="obo.OBOdescripcion,1,40"> as OBOdescripcion
			, obo.OBOfechaInicio,	obo.OBOfechaFinal
			, <cf_dbfunction name="sPart"	args="obo.OBOresponsable,1,40"> as OBOresponsable,	u.Usulogin
			, obo.CFformatoObr
			, o.Oficodigo, <cf_dbfunction name="sPart"	args="o.Odescripcion,1,40"> as Odescripcion
			, c.Cformato, <cf_dbfunction name="sPart"	args="c.Cdescripcion,1,40"> as Cdescripcion
			, sum (SLinicial + DLdebitos - CLcreditos) as Saldo
		  from OBobra obo
		  	inner join OBproyecto obp
			   on obp.OBPid 	= obo.OBPid
			  and obp.OBTPid	= #form.OBTPid#
		  	 inner join Usuario u
			   on u.Usucodigo = obo.UsucodigoAbierto
			 left join CFinanciera cf
				inner join PCDCatalogoCuenta cubo <cf_dbforceindex name="PCDCatalogoCuenta_11">
					inner join CContables c
						 on c.Ccuenta = cubo.Ccuentaniv
				   on cubo.Ccuenta = cf.Ccuenta
				  and cubo.PCDCniv = #form.Cnivel#
				inner join SaldosContables s
					inner join Oficinas o
					   on o.Ecodigo = s.Ecodigo
					  and o.Ocodigo = s.Ocodigo
					  
				   on s.Ccuenta = cf.Ccuenta
				  and s.Ecodigo = #session.Ecodigo#
				  and s.Speriodo = #LvarPeriodos.Actual.Ano#
				  and s.Smes	 = #LvarPeriodos.Actual.Mes#
			   on cf.Ecodigo = obo.Ecodigo
			  and <cf_dbfunction name="like" args="cf.CFformato ¬ rtrim(obo.CFformatoObr) #_Cat# '%'" delimiters="¬">
		 where obo.Ecodigo = #session.Ecodigo#
		 <cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))>
			  and o.Ocodigo = #form.Ocodigo#
		  </cfif>
		 group by
			  obp.OBPcodigo, 		<cf_dbfunction name="sPart"	args="obp.OBPdescripcion,1,40">
			, obo.OBOcodigo, 		<cf_dbfunction name="sPart"	args="obo.OBOdescripcion,1,40">
			, obo.OBOfechaInicio,	obo.OBOfechaFinal
			, <cf_dbfunction name="sPart"	args="obo.OBOresponsable,1,40">,	u.Usulogin
			, obo.CFformatoObr
			, o.Oficodigo, <cf_dbfunction name="sPart"	args="o.Odescripcion,1,40">
			, c.Cformato,  <cf_dbfunction name="sPart"	args="c.Cdescripcion,1,40">
		order by
			  obp.OBPcodigo
			, obo.OBOcodigo
			, Oficodigo
			, Cformato
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
			<cfset LvarCols=5>
			<table border="0" cellpadding="0" cellspacing="0" align="center" style="border-collapse:collapse">
				<tr><td colspan="#LvarCols#" class="repHeader">#Session.Enombre#</td></tr>
				<tr><td colspan="#LvarCols#" class="repHeader">#LvarTitulo#</td></tr>
				<tr><td colspan="#LvarCols#" class="repHeader">Obras Retrasadas al mes de #fnNombreMes(form.Smes2)# de #form.Speriodo2#</td></tr>
				<tr><td colspan="#LvarCols#" class="repHeader">Sin Liquidar al mes de #fnNombreMes(dateFormat(now(),"mm"))# de #dateFormat(now(),"yyyy")#</td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td class="colHeader" width="100">Obra</td>
					<td class="colHeader">Cuenta</td>
					<td class="colHeader">Descripcion</td>
					<td class="colHeader">Saldo</td>
				</tr>
	</cfoutput>

	<cfset LvarTotales[1]=0>
	<cfoutput query="rsDatos" group="OBPcodigo">
		<cfset LvarTotales[2]=0>
		<TR>
			<TD class="colCortePry" colspan="4">
				Proyecto: <strong>#OBPcodigo#</strong> #OBPdescripcion#
			</TD>
		</TR>
		<cfoutput group="OBOcodigo">
			<cfset LvarTotales[3]=0>
			<TR>
				<TD class="colCorteObr" colspan="2">
					&nbsp;&nbsp;&nbsp;Obra: <strong>#OBOcodigo#</strong> #OBOdescripcion#
				</TD>
				<TD class="colCorteObr" style="font-weight:100" align="center">
					&nbsp;
					Inicio: #dateFormat(OBOfechaInicio,"DD/MM/YYYY")#
					&nbsp;
					Final: #dateFormat(OBOfechaFinal,"DD/MM/YYYY")#
					&nbsp;
				</TD>
				<TD class="colCorteObr" style="font-weight:100">
					&nbsp;Exceso: #dateDiff("d",OBOfechaFinal,now())#
				</TD>
			</TR>
			<TR>
				<TD>&nbsp;</TD>
				<TD class="colCorteObr" style="font-weight:100">
					Adm: #Usulogin#
				</TD>
				<TD class="colCorteObr" style="font-weight:100" colspan="2">
					Responsable: #OBOresponsable#
				</TD>
			</TR>
			<cfoutput group="Oficodigo">
				<cfset LvarTotales[4]=0>
				<tr>
					<td>&nbsp;
						
					</td>
					<TD class="colCorteObr" colspan="3">
						Oficina: #Oficodigo# - #Odescripcion#
					</td>
				</tr>
				<cfoutput group="Cformato">
					<tr>
						<td>&nbsp;
							
						</td>
						<td class="colData">
							#Cformato#
						</td>
						<td class="colData">
							#Cdescripcion#
						</td>
						<td class="colData" align="right">
							#NumberFormat(Saldo,",9.99")#
						</td>
					</tr>
					<cfif Saldo NEQ "">
						<cfset LvarTotales[4] = LvarTotales[4] + Saldo>
					</cfif>
				</cfoutput>
				<!--- Totales por Oficodigo --->
				<TR>
					<td>&nbsp;
						
					</td>
					<TD class="colCorteObr" colspan="2">
						Total Oficina #Oficodigo#
					</td>
						<td class="colData" align="right" style="font-weight:bold;">
							#NumberFormat(LvarTotales[4],",9.99")#
						</td>
				</TR>
				<cfset LvarTotales[3] = LvarTotales[3] + LvarTotales[4]>
			</cfoutput>
			<!--- Totales por OBOcodigo --->
			<TR>
				<TD class="colCorteObr" colspan="3">
					&nbsp;&nbsp;&nbsp;Total Obra #OBOcodigo#
				</td>
					<td class="colData" align="right" style="font-weight:bold;">
						#NumberFormat(LvarTotales[3],",9.99")#
					</td>
			</TR>
			<cfset LvarTotales[2] = LvarTotales[2] + LvarTotales[3]>
		</cfoutput>
		<!--- Totales por OBPcodigo --->
		<TR>
			<TD class="colCortePry" colspan="3">
				Total Proyecto #OBPcodigo#
			</td>
				<td class="colData" align="right" style="font-weight:bold;">
					#NumberFormat(LvarTotales[2],",9.99")#
				</td>
		</TR>
		<TR><TD>&nbsp;</TD></TR>
		<cfset LvarTotales[1] = LvarTotales[1] + LvarTotales[2]>
	</cfoutput>
	<cfoutput>
	<!--- Totales Generales --->
	<TR>
		<TD class="colCortePry" colspan="3">
			TOTALES GENERALES
		</td>
			<td class="colData" align="right" style="font-weight:bold;">
				#NumberFormat(LvarTotales[1],",9.99")#
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
