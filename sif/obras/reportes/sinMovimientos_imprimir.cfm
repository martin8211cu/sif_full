<cfsetting enablecfoutputonly="yes" requesttimeout="36000" showdebugoutput="no">

<cfset LvarInactivas = isdefined("LvarInactivas")>
<cfif LvarInactivas>
	<!--- Obras Abiertas que dejaron de tener movimientos --->
	<cfset LvarTitulo = "Reporte de Obras Abiertas que dejaron de tener Movimientos">
<cfelse>
	<!--- Obras Abiertas que no nunca han tenido movimientos --->
	<cfset LvarTitulo = "Reporte de Obras Abiertas que nunca han tenido Movimientos">
</cfif>

<cfinclude template="../Componentes/functionsPeriodo.cfm">
<cfif form.Speriodo NEQ "">
	<cfset LvarPeriodos = fnPeriodoContable (form.Speriodo, form.Smes)>
<cfelse>
	<cfset LvarPeriodos = fnPeriodoContable ()>
</cfif>
<cfset LvarPeriodos.Actual.Emeses = LvarPeriodos.Actual.Ano * 12 + LvarPeriodos.Actual.Mes>
<cfset LvarEmesesInactivos = LvarPeriodos.Actual.Emeses - form.Cmeses>	
<cfset LvarTotales = arrayNew(1)>
<!---
	El filtro por Oficinas esta malo, por el momento se quitara la Funcionalidad, 
	si se agrega la funcionalidad quitar este comentario y las 3 lineas siguientes
	Revision: 10837 - gustavof-Se incluye el filtro por oficina.
--->
<cfif not LvarInactivas and isdefined("form.Ocodigo") and len(trim(form.Ocodigo))>
 	<cfthrow message="Filtro de Oficinas no Implementado">
</cfif>

<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cftry>
	<!--- Obtiene las Obras no Liquidadas --->
	<cf_jdbcquery_open name="rsDatos" datasource="#session.DSN#">
	<cfoutput>
		select 
			  obo.OBOid, obp.OBPcodigo, obo.OBOcodigo, obo.OBOfechaInicio,	obo.OBOfechaFinal, u.Usulogin,obo.CFformatoObr,c.Cformato, 
			  <cf_dbfunction name="sPart"	args="obp.OBPdescripcion,1,40"> as OBPdescripcion, 
			  <cf_dbfunction name="sPart"	args="obo.OBOdescripcion,1,40"> as OBOdescripcion, 
			  <cf_dbfunction name="sPart"	args="obo.OBOresponsable,1,40"> as OBOresponsable,	
			  <cf_dbfunction name="sPart"	args="c.Cdescripcion,1,40">     as Cdescripcion,
			  coalesce((
						select max(Eperiodo*12 + Emes)
						  from OBobra obo2 
							inner join CFinanciera cf2
								inner join HDContables m2
								   on m2.Ccuenta	= cf2.Ccuenta
								  and m2.Ecodigo	= cf2.Ecodigo
							   on cf2.Ecodigo = obo2.Ecodigo
							  and  <cf_dbfunction name="like" args="cf2.CFformato ¬ rtrim(obo2.CFformatoObr) #_Cat# '%'" delimiters="¬">
						 where obo2.OBOid = obo.OBOid
					), 0) as Emeses
		<cfif LvarInactivas>
			, o.Oficodigo,  <cf_dbfunction name="sPart"	args="o.Odescripcion,1,40"> as Odescripcion
			, coalesce(sum(s.SLinicial + s.DLdebitos - s.CLcreditos), 0) as Saldo
		<cfelse>
			, ' ' as Oficodigo, 0 as Saldo
		</cfif>
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
			<cfif LvarInactivas>
				left join SaldosContables s
					inner join Oficinas o
					   on o.Ecodigo = s.Ecodigo
					  and o.Ocodigo = s.Ocodigo
				   on s.Ccuenta = cf.Ccuenta
				  and s.Ecodigo = #session.Ecodigo#
				  and s.Speriodo = #LvarPeriodos.Actual.Ano#
				  and s.Smes	 = #LvarPeriodos.Actual.Mes#
			</cfif>
			   on cf.Ecodigo = obo.Ecodigo
			  and <cf_dbfunction name="like" args="cf.CFformato ¬ rtrim(obo.CFformatoObr) #_Cat# '%'" delimiters="¬">
		 where obo.Ecodigo = #session.Ecodigo#
		 	 <cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))>
			  	and o.Ocodigo = #form.Ocodigo#
		  	</cfif><!--- --->
		<cfif form.Speriodo NEQ "">
		   and obo.OBOestado in ('1', '2')
			<cfset LvarFecha = createdate(LvarPeriodos.FechaIni.Ano,LvarPeriodos.FechaIni.Mes,1)>
		   and obo.OBOfechaInicio >= #LvarFecha#
			<cfset LvarFecha = createdate(LvarPeriodos.FechaFin.Ano,LvarPeriodos.FechaFin.Mes,1)>
			<cfset LvarFecha = createdate(LvarPeriodos.FechaFin.Ano,LvarPeriodos.FechaFin.Mes,daysinmonth(LvarFecha))>
		   and obo.OBOfechaInicio <= #LvarFecha#
		</cfif>
		<cfif NOT LvarInactivas>
			and <cf_dbfunction name="date_part" args="YY,obo.OBOfechaInicio"> * 12 + <cf_dbfunction name="date_part" args="MM,obo.OBOfechaInicio">
				<= #LvarEmesesInactivos#
		</cfif>
		 group by
			 obo.OBOid
			,  obp.OBPcodigo, 		<cf_dbfunction name="sPart"	args="obp.OBPdescripcion,1,40">
			, obo.OBOcodigo, 		<cf_dbfunction name="sPart"	args="obo.OBOdescripcion,1,40">
			, obo.OBOfechaInicio,	obo.OBOfechaFinal
			, <cf_dbfunction name="sPart" args="obo.OBOresponsable,1,40">,	u.Usulogin
			, obo.CFformatoObr
		<cfif LvarInactivas>
			, o.Oficodigo,  <cf_dbfunction name="sPart" args="o.Odescripcion,1,40">
		</cfif>
			, c.Cformato,   <cf_dbfunction name="sPart" args="c.Cdescripcion,1,40">
		<cfif LvarInactivas>
		having 
			  coalesce((
						select max(Eperiodo*12 + Emes)
						  from OBobra obo2 
							inner join CFinanciera cf2
								inner join HDContables m2
								   on m2.Ccuenta	= cf2.Ccuenta
								  and m2.Ecodigo	= cf2.Ecodigo
							   on cf2.Ecodigo = obo2.Ecodigo
							  and <cf_dbfunction name="like" args="cf2.CFformato ¬ rtrim(obo2.CFformatoObr) #_Cat# '%'" delimiters="¬">
						 where obo2.OBOid = obo.OBOid
					), 0)
			<cfif isdefined ("form.chkIncluirSin")>
				between 0 and #LvarEmesesInactivos#
			<cfelse>
				between 1 and #LvarEmesesInactivos#
			</cfif>
		<cfelse>
		having	
					coalesce((
						select count(1)
						  from OBobra obo2 
							inner join CFinanciera cf2
								inner join HDContables m2
								   on m2.Ccuenta	= cf2.Ccuenta
								  and m2.Ecodigo	= cf2.Ecodigo
							   on cf2.Ecodigo = obo2.Ecodigo
							  and <cf_dbfunction name="like" args="cf2.CFformato ¬ rtrim(obo2.CFformatoObr) #_Cat# '%'" delimiters="¬">
						 where obo2.OBOid = obo.OBOid
					), 0)
				= 0
		</cfif>
		order by
			  obp.OBPcodigo
			, obo.OBOcodigo
			<cfif LvarInactivas>
			, Oficodigo
			</cfif>
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
				<tr><td colspan="#LvarCols#" class="repHeader">Obras Inactivas con #form.Cmeses# o más meses al #LvarPeriodos.Actual.Dia# de #fnNombreMes(LvarPeriodos.Actual.Mes)# de #LvarPeriodos.Actual.Ano#</td></tr>
				<cfif form.Speriodo NEQ "">
				<tr><td colspan="#LvarCols#" class="repHeader">Abiertas durante el Periodo #fnNombrePeriodo(LvarPeriodos.FechaIni, LvarPeriodos.FechaFin)#</td></tr>
				</cfif>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td class="colHeader" width="100">Obra</td>
					<td class="colHeader">Cuenta</td>
					<td class="colHeader">Descripcion</td>
				<cfif LvarInactivas>
					<td class="colHeader">Saldo</td>
				<cfelse>
					<td class="colHeader">Dias de Apertura</td>
				</cfif>
				</tr>
	</cfoutput>

	<cfset LvarTotales[1]=0>
	<cfoutput query="rsDatos" group="OBPcodigo">
		<cfset LvarTotales[2]=0>
		<TR>
			<TD class="colCortePry" colspan="2">
				Proyecto: <strong>#OBPcodigo#</strong> #OBPdescripcion#
			</TD>
		</TR>
		<cfoutput group="OBOcodigo">
			<cfset LvarTotales[3]=0>
			<TR>
				<TD class="colCorteObr" colspan="2">
					&nbsp;&nbsp;&nbsp;Obra: <strong>#OBOcodigo#</strong> #OBOdescripcion#
				</TD>
				<TD class="colCorteObr" style="font-weight:100" <cfif LvarInactivas>colspan="2"</cfif>>
					&nbsp;
					Inicio: #dateFormat(OBOfechaInicio,"DD/MM/YYYY")#
					&nbsp;
					Final: #dateFormat(OBOfechaFinal,"DD/MM/YYYY")#
				<cfif LvarInactivas>
					&nbsp;Ultimo Mov: 
					<cfif Emeses EQ 0>
					N/A	Inactivo: #dateDiff("m",OBOfechaInicio,LvarPeriodos.Actual.Fecha)# meses
					<cfelse>
					#int(Emeses/12)#/#Emeses mod 12# &nbsp;Inactivo: #LvarPeriodos.Actual.Emeses-Emeses# meses
					</cfif>
					
				</cfif>
					&nbsp;
				</TD>
			<cfif NOT LvarInactivas>
				<TD class="colCorteObr" style="font-weight:100" align="center">
					#dateDiff("d",OBOfechaInicio,LvarPeriodos.Actual.Fecha)# 
				</TD>
			</cfif>
			</TR>
			<TR>
				<TD>&nbsp;</TD>
				<TD class="colCorteObr" style="font-weight:100">
					Adm: #Usulogin#
				</TD>
				<TD class="colCorteObr" style="font-weight:100" colspan="2">
					&nbsp;
					Responsable: #OBOresponsable#
				</TD>
			</TR>
			<cfoutput group="Oficodigo">
				<cfset LvarTotales[4]=0>
				<cfif LvarInactivas>
				<tr>
					<td>&nbsp;
						
					</td>
					<TD class="colCorteObr" colspan="3">
						<cfif Oficodigo NEQ "">
						Oficina: #Oficodigo# - #Odescripcion#
						<cfelse>
						Cuentas sin Movimientos
						</cfif>
					</td>
				</tr>
				</cfif>
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
						<cfif LvarInactivas>
							#NumberFormat(Saldo,",9.99")#
						</cfif>
						</td>
					</tr>
					<cfif Saldo NEQ "">
						<cfset LvarTotales[4] = LvarTotales[4] + Saldo>
					</cfif>
				</cfoutput>
				<!--- Totales por Oficodigo --->
			<cfif LvarInactivas AND Oficodigo NEQ "">
				<TR>
					<td>&nbsp;
						
					</td>
					<TD class="colCorteObr" colspan="2">
						Total Oficina #Oficodigo#
					</td>
					<td class="colData" align="right" style="font-weight:bold;">
					<cfif LvarInactivas>
						#NumberFormat(LvarTotales[4],",9.99")#
					</cfif>
					</td>
				</TR>
			</cfif>
				<cfset LvarTotales[3] = LvarTotales[3] + LvarTotales[4]>
			</cfoutput>
			<!--- Totales por OBOcodigo --->
			<cfif LvarInactivas>
			<TR>
				<TD class="colCorteObr" colspan="3">
					&nbsp;&nbsp;&nbsp;Total Obra #OBOcodigo#
				</td>
					<td class="colData" align="right" style="font-weight:bold;">
						#NumberFormat(LvarTotales[3],",9.99")#
					</td>
			</TR>
			<cfset LvarTotales[2] = LvarTotales[2] + LvarTotales[3]>
			</cfif>
		</cfoutput>
		<!--- Totales por OBPcodigo --->
		<cfif LvarInactivas>
		<TR>
			<TD class="colCortePry" colspan="3">
				Total Proyecto #OBPcodigo#
			</td>
				<td class="colData" align="right" style="font-weight:bold;">
					#NumberFormat(LvarTotales[2],",9.99")#
				</td>
		</TR>
		</cfif>
		<TR><TD>&nbsp;</TD></TR>
		<cfset LvarTotales[1] = LvarTotales[1] + LvarTotales[2]>
	</cfoutput>
	<cfoutput>
	<!--- Totales Generales --->
	<cfif LvarInactivas>
	<TR>
		<TD class="colCortePry" colspan="3">
			TOTALES GENERALES
		</td>
			<td class="colData" align="right" style="font-weight:bold;">
				#NumberFormat(LvarTotales[1],",9.99")#
			</td>
	</TR>
	</cfif>
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
