<!--- 
	Módulo    : Contabilidad General
	Nombre    : Reporte de Asientos Por Interfaz
	Hecho por : Randall Colomer en SOIN
	Creado    : 25/07/2006
 --->

<cfsavecontent variable="queryControlInterfaz">
	<cfoutput>
		select 
			a.PeriodoOri, 	a.MesOri, 		a.ConceptoOri, 	a.DocumentoOri, 
			a.NumLineasOri, a.CreditosOri, 	a.DebitosOri, 	a.UsuarioOri,    
			a.NumLineasInt, a.DebitosInt, 	a.CreditosInt,	a.Cconcepto, 
			a.Edocumento, 	a.NumLineas, 	a.Creditos, 	a.Debitos,  
			a.Usuario
		from ControlInterfaz18 a
		where a.PeriodoOri = #form.periodo#
			and a.MesOri = #form.mes#
			
			<!--- Se valida el rango de Conceptos seleccionados --->
			<cfif isdefined("form.conceptoini") and len(trim(form.conceptoini)) and isdefined("form.conceptofin") and len(trim(form.conceptofin)) >
				<cfif form.conceptoini EQ form.conceptofin>
					and a.ConceptoOri = #form.conceptoini#
				<cfelse>
					and a.ConceptoOri between #form.conceptoini# and #form.conceptofin#
				</cfif>
			</cfif>
			<cfif isdefined("form.conceptoini") and len(trim(form.conceptoini)) and  not ( isdefined("form.conceptofin") and len(trim(form.conceptofin)) ) >
				and a.ConceptoOri >= #form.conceptoini#
			</cfif>
			<cfif isdefined("form.conceptofin") and len(trim(form.conceptofin)) and  not ( isdefined("form.conceptoini") and len(trim(form.conceptoini)) ) >
				and a.ConceptoOri <= #form.conceptofin#
			</cfif>
			
			<!--- Se valida el rango de Fechas de Generación --->
			<cfif isdefined("form.fechaIni") and len(trim(form.fechaIni)) and isdefined("form.fechaFin") and len(trim(form.fechaFin))>
				<cfif form.fechaIni EQ form.fechaFin >
					and a.FechaOri = '#LSDateFormat(LSParseDateTime(form.fechaIni),'yyyymmdd')#'
				<cfelse>
					and a.FechaOri between '#LSDateFormat(LSParseDateTime(form.fechaIni),'yyyymmdd')#'
					and '#LSDateFormat(LSParseDateTime(form.fechaFin),'yyyymmdd')#'
				</cfif>
			</cfif>
			<cfif isdefined("form.fechaIni") and len(trim(form.fechaIni)) and not ( isdefined("form.fechaFin") and len(trim(form.fechaFin)) )>
				and a.FechaOri >= '#LSDateFormat(LSParseDateTime(form.fechaIni),'yyyymmdd')#'
			</cfif>
			<cfif isdefined("form.fechaFin") and len(trim(form.fechaFin)) and not ( isdefined("form.fechaIni") and len(trim(form.fechaIni)) )>
				and a.FechaOri <= '#LSDateFormat(LSParseDateTime(form.fechaFin),'yyyymmdd')#'
			</cfif>
	</cfoutput>
</cfsavecontent>

<!--- Obtiene la descripción del Concepto Inicial --->
<cfif isdefined("form.conceptoini") and trim(form.conceptoini) GTE 0>
	<cfquery name="rsConceptoIni" datasource="#session.DSN#">
		select a.Cconcepto, Cdescripcion as Cdescripcion
		from ConceptoContableE a
		where  a.Ecodigo = #Session.Ecodigo# 
			and a.Cconcepto = #form.conceptoini#
	</cfquery>
	<cfif isdefined("rsConceptoIni") and rsConceptoIni.recordcount GT 0>
		<cfset conceptoInicial = rsConceptoIni.Cdescripcion>
	</cfif>
<cfelse>
	<cfset conceptoInicial = "Todos">
</cfif>

<!--- Obtiene la descripción del Concepto Final --->
<cfif isdefined("form.conceptofin") and trim(form.conceptofin) GTE 0>
	<cfquery name="rsConceptoFin" datasource="#session.DSN#">
		select a.Cconcepto, Cdescripcion as Cdescripcion
		from ConceptoContableE a
		where  a.Ecodigo = #Session.Ecodigo# 
			and a.Cconcepto = #form.conceptofin#
	</cfquery>
	<cfif isdefined("rsConceptoFin") and rsConceptoFin.recordcount GT 0>
		<cfset conceptoFinal = rsConceptoFin.Cdescripcion>
	</cfif>
<cfelse>
	<cfset conceptoFinal = "Todos">
</cfif>

<!--- Obtiene la descripción del Mes Inicial --->
<cfif isdefined("form.mes") and len(trim(form.mes))>
	<cfquery name="rsMes" datasource="#session.dsn#">
		select <cf_dbfunction name="to_number" args="b.VSvalor"> as v, VSdesc as descMes
		from Idiomas a
			inner join VSidioma b
			on b.Iid = a.Iid
			and b.VSgrupo = 1
		where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.idioma#">
			and b.VSvalor = '#form.mes#'
		order by <cf_dbfunction name="to_number" args="b.VSvalor">
	</cfquery>
	<cfif isdefined("rsMes") and rsMes.recordcount GT 0>
		<cfset mes = rsMes.descMes>
	</cfif>
</cfif>

<!--- Estilo para los titulos de las columnas del Reporte --->
<!--- Título del Reporte y Nombre del Archivo xls y txt --->
<cfset Title = "Asientos Por Interfaz">
<cfset FileName = "AsientosPorInterfaz">
<cfset FileName = FileName & Session.Usucodigo & "-" & DateFormat(Now(),'yyyymmdd') & "-" & TimeFormat(Now(),'hhmmss') & ".xls">
<cfset FileNameTab = "AsientosPorInterfaz">
<cfset FileNameTab = FileNameTab & Session.Usucodigo & "-" & DateFormat(Now(),'yyyymmdd') & "-" & TimeFormat(Now(),'hhmmss')>

<!--- Pinta los botones de regresar, impresión y exportar a excel. --->
<cf_htmlreportsheaders 
	title="#Title#" 
	filename="#FileName#" 
	ira="AsientosPorInterfaz.cfm">

<!--- Empieza a pintar el reporte en el usuario cada 512 bytes. --->
<cfif not isdefined("form.toExcel")>
	<cfflush interval="512">
</cfif>

<cf_templatecss>

<cfoutput>
<style type="text/css">
	.encabReporteLine {
		background-color: ##006699;
		color: ##FFFFFF;
		padding-top: 2px;
		padding-bottom: 2px;
		font-size: 11px; 
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: ##CCCCCC;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: ##CCCCCC;
	}
	.imprimeDatos {
		font-size: 10px;	
		padding-left: 5px; 
	}
	.imprimeDatosLinea {
		color: ##FF0000;
		font-size: 10px;
		font-weight: bold;
		padding-left: 5px; 
	}
	.imprimeMonto {
		font-size: 10px;
		text-align: right;
	}
	.imprimeMontoLinea {
		color: ##FF0000;
		font-size: 10px;
		text-align: right;
		font-weight: bold;
	}
</style>
</cfoutput>

<cfset Lvar_nrecordcount = 0>
<cfoutput>
<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="1">
	<tr><td align="center" colspan="17"><cfinclude template="RetUsuario.cfm"></td></tr>
	<tr><td align="center" colspan="17"><font size="3"><strong>#session.Enombre#</strong></font></td></tr>
	<tr><td align="center" colspan="17"><font size="2"><strong>#Title#</strong></font></td></tr>
	<tr><td align="center" colspan="17"><font size="2"><strong>Del Concepto:</strong> #conceptoInicial# <strong>al Concepto:</strong> #conceptoFinal#</font></td></tr>
	<tr><td align="center" colspan="17"><font size="2"><strong>Mes:</strong> #mes# - <strong>Periodo:</strong> #form.periodo#</font></td></tr>
	<cfif isdefined("form.fechaIni") and len(trim(form.fechaIni)) or isdefined("form.fechaFin") and len(trim(form.fechaFin)) >
		<tr><td align="center" colspan="17"><font size="2"><strong>Del</strong>&nbsp;&nbsp;#form.fechaIni#&nbsp;&nbsp;<strong>al</strong>&nbsp;&nbsp;#form.fechaFin#</font></td></tr>
	</cfif>
	<tr><td align="center" colspan="17"><hr></td></tr>		
	</cfoutput>
	
	<cfif isdefined("queryControlInterfaz") and len(trim(queryControlInterfaz)) gt 0>	
		<cftry>
			<cf_jdbcquery_open datasource="sifinterfaces" name="rsControlInterfaz">
				<cfoutput>#PreserveSingleQuotes(queryControlInterfaz)#</cfoutput>
			</cf_jdbcquery_open>
			
			<cfif isdefined("form.toExcel")>
				<cf_exportQueryToFile query="#rsControlInterfaz#" separador="#chr(9)#" filename="#FileNameTab#.txt" jdbc="true">
			</cfif>

			<cfset Lvar_bx = false>
			<cfoutput query="rsControlInterfaz">
				<cfif not Lvar_bx>
					<cfset Lvar_bx = true>
					<tr>
						<td nowrap class="encabReporteLine" colspan="2" align="center">&nbsp;</td>
						<td nowrap class="encabReporteLine" colspan="6" align="center">Origen</td>
						<td nowrap class="encabReporteLine" colspan="3" align="center">Interfaz</td>
						<td nowrap class="encabReporteLine" colspan="6" align="center">Contabilidad</td>
					</tr>
					<tr>
						<td nowrap class="encabReporteLine">Periodo</td>
						<td nowrap class="encabReporteLine">Mes</td>
						<td nowrap class="encabReporteLine">Concepto</td>
						<td nowrap class="encabReporteLine">Documento</td>
						<td nowrap class="encabReporteLine">L&iacute;neas</td>
						<td nowrap class="encabReporteLine">Cr&eacute;ditos</td>
						<td nowrap class="encabReporteLine">D&eacute;bitos</td>
						<td nowrap class="encabReporteLine">Usuario</td>
						<td nowrap class="encabReporteLine">L&iacute;neas</td>
						<td nowrap class="encabReporteLine">Cr&eacute;ditos</td>
						<td nowrap class="encabReporteLine">D&eacute;bitos</td>
						<td nowrap class="encabReporteLine">Concepto</td>
						<td nowrap class="encabReporteLine">Documento</td>
						<td nowrap class="encabReporteLine">L&iacute;neas</td>
						<td nowrap class="encabReporteLine">Cr&eacute;ditos</td>
						<td nowrap class="encabReporteLine">D&eacute;bitos</td>
						<td nowrap class="encabReporteLine">Usuario</td>
					</tr>
				</cfif>
				
				<cfset Lvar_nrecordcount = Lvar_nrecordcount + 1>
				<tr>
					<cfif ((NumLineasOri EQ NumLineasInt) and (NumLineasOri EQ NumLineas)) 
						and ((CreditosOri EQ CreditosInt) and (CreditosOri EQ Creditos)) 
						and ((DebitosOri EQ DebitosInt) and (DebitosOri EQ Debitos)) >
						
						<td nowrap class="imprimeDatos">#PeriodoOri#</td>
						<td nowrap class="imprimeDatos">#MesOri#</td>
						<td nowrap class="imprimeDatos">#ConceptoOri#</td>
						<td nowrap class="imprimeDatos">#DocumentoOri#</td>
						<td nowrap class="imprimeDatos">#NumLineasOri#</td>					
						<td nowrap class="imprimeMonto">#LSCUrrencyFormat(CreditosOri,'none')#</td>
						<td nowrap class="imprimeMonto">#LSCUrrencyFormat(DebitosOri,'none')#</td>
						<td nowrap class="imprimeDatos">#UsuarioOri#</td>
						<td nowrap class="imprimeDatos">#NumLineasInt#</td>
						<td nowrap class="imprimeMonto">#LSCUrrencyFormat(CreditosInt,'none')#</td>
						<td nowrap class="imprimeMonto">#LSCUrrencyFormat(DebitosInt,'none')#</td>
						<td nowrap class="imprimeDatos">#Cconcepto#</td>
						<td nowrap class="imprimeDatos">#Edocumento#</td>
						<td nowrap class="imprimeDatos">#NumLineas#</td>
						<td nowrap class="imprimeMonto">#LSCUrrencyFormat(Creditos,'none')#</td>
						<td nowrap class="imprimeMonto">#LSCUrrencyFormat(Debitos,'none')#</td>
						<td nowrap class="imprimeDatos">#Usuario#</td>
						
					<cfelse>
					
						<td nowrap class="imprimeDatosLinea">#PeriodoOri#</td>
						<td nowrap class="imprimeDatosLinea">#MesOri#</td>
						<td nowrap class="imprimeDatosLinea">#ConceptoOri#</td>
						<td nowrap class="imprimeDatosLinea">#DocumentoOri#</td>
						<td nowrap class="imprimeDatosLinea">#NumLineasOri#</td>					
						<td nowrap class="imprimeMontoLinea">#LSCUrrencyFormat(CreditosOri,'none')#</td>
						<td nowrap class="imprimeMontoLinea">#LSCUrrencyFormat(DebitosOri,'none')#</td>
						<td nowrap class="imprimeDatosLinea">#UsuarioOri#</td>
						<td nowrap class="imprimeDatosLinea">#NumLineasInt#</td>
						<td nowrap class="imprimeMontoLinea">#LSCUrrencyFormat(CreditosInt,'none')#</td>
						<td nowrap class="imprimeMontoLinea">#LSCUrrencyFormat(DebitosInt,'none')#</td>
						<td nowrap class="imprimeDatosLinea">#Cconcepto#</td>
						<td nowrap class="imprimeDatosLinea">#Edocumento#</td>
						<td nowrap class="imprimeDatosLinea">#NumLineas#</td>
						<td nowrap class="imprimeMontoLinea">#LSCUrrencyFormat(Creditos,'none')#</td>
						<td nowrap class="imprimeMontoLinea">#LSCUrrencyFormat(Debitos,'none')#</td>
						<td nowrap class="imprimeDatosLinea">#Usuario#</td>
						
					</cfif>
				</tr>
			</cfoutput>	
		<cfcatch type="any">
			<cf_jdbcquery_close>
			<cfrethrow>
		</cfcatch>
		</cftry>
		<cf_jdbcquery_close>
	</cfif>
	
	<cfif Lvar_nrecordcount gt 0>
		<cfset Lvar_smsg = "Fin de la Consulta">
	<cfelse>
		<cfset Lvar_smsg = "No se encontraron registros que con cumplan los filtros">
	</cfif>
	
	<cfoutput>
	<tr><td align="center" colspan="17">&nbsp;</td></tr>		
	<tr><td align="center" colspan="17"><strong> --- #Lvar_smsg# ---  </strong></td></tr>
</table> 
</cfoutput>


