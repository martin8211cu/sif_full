<!--- 
	Módulo    : Contabilidad General
	Nombre    : Reporte de Asientos Aplicados y Pendientes
	Hecho por : Randall Colomer en SOIN
	Creado    : 21/07/2006
 --->
 <cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo" default="Resumen de Asientos Aplicados" 
returnvariable="LB_Titulo" xmlfile="AsientosAplicadosResumido.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Archivo" default="ResumenAsientosAplicados" 
returnvariable="LB_Archivo" xmlfile="AsientosAplicadosResumido.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ConceptoIni" default="Concepto Inicial" 
returnvariable="LB_ConceptoIni" xmlfile="AsientosAplicadosResumido.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ConceptoFin" default="Concepto Final" 
returnvariable="LB_ConceptoFin" xmlfile="AsientosAplicadosResumido.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PeriodoMesIni" default="Periodo Mes Inicial" 
returnvariable="LB_PeriodoMesIni" xmlfile="AsientosAplicadosResumido.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PeriodoMesFin" default="Periodo Mes Final" 
returnvariable="LB_PeriodoMesFin" xmlfile="AsientosAplicadosResumido.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PolizaIni" default="P&oacute;liza Inicial" 
returnvariable="LB_PolizaIni" xmlfile="AsientosAplicadosResumido.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PolizaFin" default="P&oacute;liza Final" 
returnvariable="LB_PolizaFin" xmlfile="AsientosAplicadosResumido.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FechaGIni" default="Fecha Generaci&Oacute;n Inicial" 
returnvariable="LB_FechaGIni" xmlfile="AsientosAplicadosResumido.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FechaGFin" default="Fecha Generaci&Oacute;n Final" 
returnvariable="LB_FechaGFin" xmlfile="AsientosAplicadosResumido.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FechaAIni" default="Fecha Aplicaci&Oacute;n Inicial" 
returnvariable="LB_FechaAIni" xmlfile="AsientosAplicadosResumido.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FechaAFin" default="Fecha Aplicaci&Oacute;n Final" 
returnvariable="LB_FechaAFin" xmlfile="AsientosAplicadosResumido.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Periodo" default="Periodo" 
returnvariable="LB_Periodo" xmlfile="AsientosAplicadosResumido.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mes" default="Mes" 
returnvariable="LB_Mes" xmlfile="AsientosAplicadosResumido.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Concepto" default="Concepto" 
returnvariable="LB_Concepto" xmlfile="AsientosAplicadosResumido.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" default="Descripci&oacute;n" 
returnvariable="LB_Descripcion" xmlfile="AsientosAplicadosResumido.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Documento" default="Documento" 
returnvariable="LB_Documento" xmlfile="AsientosAplicadosResumido.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Debitos" default="D&eacute;bitos" 
returnvariable="LB_Debitos" xmlfile="AsientosAplicadosResumido.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Creditos" default="Cr&eacute;ditos" 
returnvariable="LB_Creditos" xmlfile="AsientosAplicadosResumido.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FechaCreacion" default="Fecha Creaci&oacute;n" 
returnvariable="LB_FechaCreacion" xmlfile="AsientosAplicadosResumido.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FechaAplicacion" default="Fecha Aplicaci&oacute;n" 
returnvariable="LB_FechaAplicacion" xmlfile="AsientosAplicadosResumido.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_SinRegistros" default="No se encontraron registros que con cumplan los filtros" returnvariable="LB_SinRegistros" xmlfile="AsientosAplicadosResumido.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FinConsulta" default="Fin de la consulta" 
returnvariable="LB_FinConsulta" xmlfile="AsientosAplicadosResumido.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Tipo" default="Type" 
returnvariable="LB_Tipo" xmlfile="AsientosAplicadosResumido.xml"/>
 
 
<cfsavecontent variable="queryAplicadoResumido">
	<cfoutput>
		select 
			a.Eperiodo,
			a.Emes,
			a.Cconcepto,
			min(b.Cdescripcion) as Cdescripcion,
			coalesce(sum(Case when hd.Dmovimiento = 'D' then 
				hd.Dlocal else 0.00
			end), 0.00) as Debitos,
			coalesce(sum(Case when hd.Dmovimiento = 'C' then 
				hd.Dlocal else 0.00
			end), 0.00) as Creditos
		from HEContables a
			inner join HDContables hd
				on a.IDcontable  = hd.IDcontable 
			inner join ConceptoContableE b
				on a.Ecodigo = b.Ecodigo
				and a.Cconcepto = b.Cconcepto
		where a.Ecodigo = #Session.Ecodigo#
			<!--- Se valida el rango de Conceptos seleccionados --->
			<cfif isdefined("form.conceptoini") and len(trim(form.conceptoini)) and isdefined("form.conceptofin") and len(trim(form.conceptofin)) >
				<cfif form.conceptoini EQ form.conceptofin>
					and a.Cconcepto = #form.conceptoini#
				<cfelse>
					and a.Cconcepto between #form.conceptoini# and #form.conceptofin#
				</cfif>
			</cfif>
			<cfif isdefined("form.conceptoini") and len(trim(form.conceptoini)) and  not ( isdefined("form.conceptofin") and len(trim(form.conceptofin)) ) >
				and a.Cconcepto >= #form.conceptoini#
			</cfif>
			<cfif isdefined("form.conceptofin") and len(trim(form.conceptofin)) and  not ( isdefined("form.conceptoini") and len(trim(form.conceptoini)) ) >
				and a.Cconcepto <= #form.conceptofin#
			</cfif>
			
			<!--- Se valida el rango de Pólizas seleccionados --->
			<cfif isdefined("form.EdocumentoI") and len(trim(form.EdocumentoI)) and isdefined("form.EdocumentoF") and len(trim(form.EdocumentoF)) >
				<cfif form.EdocumentoI EQ form.EdocumentoF>
					and a.Edocumento = #form.EdocumentoI#
				<cfelse>
					and a.Edocumento between #form.EdocumentoI# and #form.EdocumentoF#
				</cfif>
			</cfif>
			<cfif isdefined("form.EdocumentoI") and len(trim(form.EdocumentoI)) and  not ( isdefined("form.EdocumentoF") and len(trim(form.EdocumentoF)) ) >
				and a.Edocumento >= #form.EdocumentoI#
			</cfif>
			<cfif isdefined("form.EdocumentoF") and len(trim(form.EdocumentoF)) and  not ( isdefined("form.EdocumentoI") and len(trim(form.EdocumentoI)) ) >
				and a.Edocumento <= #form.EdocumentoF#
			</cfif>
			
			<!--- Se valida el rango de periodos y meses --->
			and (a.Eperiodo > #form.periodoini# or (a.Eperiodo = #form.periodoini# and a.Emes >= #form.mesini#))
			and (a.Eperiodo < #form.periodofin# or (a.Eperiodo = #form.periodofin# and a.Emes <= #form.mesfin#))
			
			<!--- Se valida el rango de Fechas de Generación --->
			<cfif isdefined("form.fechaGeneIni") and len(trim(form.fechaGeneIni)) and isdefined("form.fechaGeneFin") and len(trim(form.fechaGeneFin))>
				<cfif form.fechaGeneIni EQ form.fechaGeneFin>
					and <cf_dbfunction name="to_date00" args="a.ECfechacreacion"> = #LSParseDateTime(form.fechaGeneIni)#
				<cfelse>
					and <cf_dbfunction name="to_date00" args="a.ECfechacreacion"> between #LSParseDateTime(form.fechaGeneIni)# and #LSParseDateTime(form.fechaGeneFin)#
				</cfif>
			</cfif>
			<cfif isdefined("form.fechaGeneIni") and len(trim(form.fechaGeneIni)) and not ( isdefined("form.fechaGeneFin") and len(trim(form.fechaGeneFin)) )>
				and <cf_dbfunction name="to_date00" args="a.ECfechacreacion"> >= #LSParseDateTime(form.fechaGeneIni)#
			</cfif>
			<cfif isdefined("form.fechaGeneFin") and len(trim(form.fechaGeneFin)) and not ( isdefined("form.fechaGeneIni") and len(trim(form.fechaGeneIni)) )>
				and <cf_dbfunction name="to_date00" args="a.ECfechacreacion"> <= #LSParseDateTime(form.fechaGeneFin)#
			</cfif>

			<!--- Se valida el rango de Fechas de Aplicación --->
			<cfif isdefined("form.fechaApliIni") and len(trim(form.fechaApliIni)) and isdefined("form.fechaApliFin") and len(trim(form.fechaApliFin))>
				<cfif form.fechaApliIni EQ form.fechaApliFin>
					and <cf_dbfunction name="to_date00" args="a.ECfechaaplica"> = #LSParseDateTime(form.fechaApliIni)#
				<cfelse>
					and <cf_dbfunction name="to_date00" args="a.ECfechaaplica"> between #LSParseDateTime(form.fechaApliIni)# and #LSParseDateTime(form.fechaApliFin)#
				</cfif>
			</cfif>
			<cfif isdefined("form.fechaApliIni") and len(trim(form.fechaApliIni)) and not ( isdefined("form.fechaApliFin") and len(trim(form.fechaApliFin)) )>
				and <cf_dbfunction name="to_date00" args="a.ECfechaaplica"> >= #LSParseDateTime(form.fechaApliIni)#
			</cfif>
			<cfif isdefined("form.fechaApliFin") and len(trim(form.fechaApliFin)) and not ( isdefined("form.fechaApliIni") and len(trim(form.fechaApliIni)) )>
				and <cf_dbfunction name="to_date00" args="a.ECfechaaplica"> <= #LSParseDateTime(form.fechaApliFin)#
			</cfif>
			
		group by a.Eperiodo, a.Emes, a.Cconcepto
		order by a.Eperiodo, a.Emes, a.Cconcepto
	</cfoutput>
</cfsavecontent>

<!--- Validaciones para poner el encabezado del Reporte --->
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

<!--- Valida el campo de Póliza Inicial --->
<cfif isdefined("form.EdocumentoI") and len(trim(form.EdocumentoI))>
	<cfset documentoInicial = form.EdocumentoI>
<cfelse>
	<cfset documentoInicial = "Todos">
</cfif>

<!--- Valida el campo de Póliza Final --->
<cfif isdefined("form.EdocumentoF") and len(trim(form.EdocumentoF))>
	<cfset documentoFinal = form.EdocumentoF>
<cfelse>
	<cfset documentoFinal = "Todos">
</cfif>

<!--- Obtiene la descripción del Mes Inicial --->
<cfif isdefined("form.mesini") and len(trim(form.mesini))>
	<cfquery name="rsMesIni" datasource="#session.dsn#">
		select <cf_dbfunction name="to_number" args="b.VSvalor"> as v, VSdesc as descMes
		from Idiomas a
			inner join VSidioma b
			on b.Iid = a.Iid
			and b.VSgrupo = 1
		where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.idioma#">
			and b.VSvalor = '#form.mesini#'
		order by <cf_dbfunction name="to_number" args="b.VSvalor">
	</cfquery>
	<cfif isdefined("rsMesIni") and rsMesIni.recordcount GT 0>
		<cfset mesInicial = rsMesIni.descMes>
	</cfif>
</cfif>

<!--- Obtiene la descripción del Mes Final --->
<cfif isdefined("form.mesfin") and len(trim(form.mesfin))>
	<cfquery name="rsMesFin" datasource="#session.dsn#">
		select <cf_dbfunction name="to_number" args="b.VSvalor"> as v, VSdesc as descMes
		from Idiomas a
			inner join VSidioma b
			on b.Iid = a.Iid
			and b.VSgrupo = 1
		where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.idioma#">
			and b.VSvalor = '#form.mesfin#'
		order by <cf_dbfunction name="to_number" args="b.VSvalor">
	</cfquery>
	<cfif isdefined("rsMesFin") and rsMesFin.recordcount GT 0>
		<cfset mesFinal = rsMesFin.descMes>
	</cfif>
</cfif>

<cfset Title = "#LB_Titulo#">
<cfset FileName = "#LB_Archivo#">
<cfset FileName = FileName & Session.Usucodigo & "-" & DateFormat(Now(),'yyyymmdd') & "-" & TimeFormat(Now(),'hhmmss') & ".xls">
<cfset FileNameTab = "#LB_Archivo#">
<cfset FileNameTab = FileNameTab & Session.Usucodigo & "-" & DateFormat(Now(),'yyyymmdd') & "-" & TimeFormat(Now(),'hhmmss')>

<!--- Pinta los botones de regresar, impresión y exportar a excel. --->
<cf_htmlreportsheaders
	title="#Title#" 
	filename="#FileName#" 
	ira="AsientosContabilizados.cfm">

<!--- 
Empieza a pintar el reporte en el usuario cada 512 bytes.
Los bytes que toma en cuenta son de aquí en adelante omitiendo lo que hay antes
y la información de los headers de la cantidad de byte
--->
<cfif not isdefined("form.toExcel")>
	<cfflush interval="512">
</cfif>

<cf_templatecss>
	
<cfset Lvar_nrecordcount = 0>
<cfoutput>
<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
	<tr><td align="center" colspan="5"><cfinclude template="RetUsuario.cfm"></td></tr>
	<tr><td align="center" colspan="5"><font size="3"><strong>#session.Enombre#</strong></font></td></tr>
	<tr><td align="center" colspan="5"><font size="2"><strong>#Title#</strong></font></td></tr>
	<tr><td align="center" colspan="5"><font size="2"><strong>#LB_ConceptoIni#:</strong>&nbsp;&nbsp;#conceptoInicial#&nbsp;&nbsp;<strong>#LB_ConceptoFin#:</strong>&nbsp;&nbsp;#conceptoFinal#</font></td></tr>
	<cfif isdefined("form.EdocumentoI") and len(trim(form.EdocumentoI)) or isdefined("form.EdocumentoF") and len(trim(form.EdocumentoI)) >
		<tr><td align="center" colspan="5"><font size="2"><strong>#LB_PolizaIni#:</strong>&nbsp;&nbsp;#documentoInicial#&nbsp;&nbsp;<strong>#LB_PolizaFin#:</strong>&nbsp;&nbsp;#documentoFinal#</font></td></tr>
	</cfif>
	<tr><td align="center" colspan="5"><font size="2"><strong>#LB_PeriodoMesIni#:</strong>&nbsp;&nbsp;#mesInicial#/#form.periodoini#&nbsp;&nbsp;<strong>#LB_PeriodoMesFin#:</strong>&nbsp;&nbsp;#mesFinal#/#form.periodofin#</font></td></tr>
	<cfif isdefined("form.fechaApliIni") and len(trim(form.fechaApliIni)) or isdefined("form.fechaApliFin") and len(trim(form.fechaApliFin)) >
		<tr><td align="center" colspan="5"><font size="2"><strong>#LB_FechaAIni#:</strong>&nbsp;&nbsp;#form.fechaApliIni#&nbsp;&nbsp;<strong>#LB_FechaAFin#:</strong>&nbsp;&nbsp;#form.fechaApliFin#</font></td></tr>
	</cfif>
	<cfif isdefined("form.fechaGeneIni") and len(trim(form.fechaGeneIni)) or isdefined("form.fechaGeneFin") and len(trim(form.fechaGeneFin)) >
		<tr><td align="center" colspan="5"><font size="2"><strong>#LB_FechaGIni#:</strong>&nbsp;&nbsp;#form.fechaGeneIni#&nbsp;&nbsp;<strong>#LB_FechaGFin#:</strong>&nbsp;&nbsp;#form.fechaGeneFin#</font></td></tr>
	</cfif>
	<tr><td align="center" colspan="5"><hr></td></tr>		
</cfoutput>

	<cfif isdefined("queryAplicadoResumido") and len(trim(queryAplicadoResumido)) gt 0>	
		<cftry>
			<cf_jdbcquery_open datasource="#session.dsn#" name="rsAplicadoResumido">
				<cfoutput>#PreserveSingleQuotes(queryAplicadoResumido)#</cfoutput>
			</cf_jdbcquery_open>
		
			<cfif isdefined("form.toExcel")>
				<cf_exportQueryToFile query="#rsAplicadoResumido#" separador="#chr(9)#" filename="#FileNameTab#.txt" jdbc="true">
			</cfif>
			
			<cfset Lvar_bx = false>
			<cfoutput query="rsAplicadoResumido">
				<cfif not Lvar_bx>
					<cfset Lvar_bx = true>
					<tr>
						<td nowrap bgcolor="##CCCCCC"><strong>#LB_Periodo#</strong></td>
						<td nowrap bgcolor="##CCCCCC"><strong>#LB_Mes#</strong></td>
						<td nowrap bgcolor="##CCCCCC"><strong>#LB_Concepto#</strong></td>
						<td nowrap bgcolor="##CCCCCC" align="right"><strong>#LB_Debitos#</strong></td>
						<td nowrap bgcolor="##CCCCCC" align="right"><strong>#LB_Creditos#</strong></td>
					</tr>
				</cfif>
				
				<cfset Lvar_nrecordcount = Lvar_nrecordcount + 1>
				<tr>
					<td nowrap style="padding-left: 10px;">#Eperiodo#</td>
					<td nowrap style="padding-left: 10px;">#Emes#</td>
					<td nowrap style="padding-left: 10px;">#Cconcepto# - #Cdescripcion#</td>
					<td nowrap align="right">#LSCUrrencyFormat(Debitos,'none')#</td>
					<td nowrap align="right">#LSCUrrencyFormat(Creditos,'none')#</td>
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
		<cfset Lvar_smsg = "#LB_FinConsulta#">
	<cfelse>
		<cfset Lvar_smsg = "#LB_SinRegistros#">
	</cfif>
	
<cfoutput>
	<tr><td align="center" colspan="5">&nbsp;</td></tr>		
	<tr><td align="center" colspan="5"><strong> --- #Lvar_smsg# ---  </strong></td></tr>
</table> 
</cfoutput>
