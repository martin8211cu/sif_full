<cf_PleaseWait SERVER_NAME="/cfmx/sif/cg/consultas/SQLBalCompR2xPeriodo.cfm" >
<cfsetting enablecfoutputonly="yes">
<cfsetting requesttimeout="3600"> 
<cfparam name="url.IncluirOficina" default="N">
<cfparam name="url.chkCeros" default = "N">
<cfparam name="url.formato" default="HTML">

<cfif isdefined("form.IncluirOficina")>
	<cfset url.IncluirOficina = form.IncluirOficina>
</cfif>
<cfif isdefined("form.CMAYOR_CCUENTA1")>
	 <cfset url.CMAYOR_CCUENTA1 = form.CMAYOR_CCUENTA1>
</cfif>
<cfif isdefined("form.CMAYOR_CCUENTA2")>
	 <cfset url.CMAYOR_CCUENTA2 = form.CMAYOR_CCUENTA2>
</cfif>
<cfif isdefined("form.FORMATO")>
	 <cfset form.FORMATO = form.FORMATO>
</cfif>
<cfif isdefined("form.MCODIGO")>
	 <cfset url.MCODIGO = form.MCODIGO>
</cfif>
<cfif isdefined("form.MCODIGOOPT")>
	 <cfset url.MCODIGOOPT = form.MCODIGOOPT>
</cfif>
<cfif isdefined("form.MESDES")>
	<cfset url.MESDES = form.MESDES>
</cfif>
<cfif isdefined("form.MESHAS")>
	<cfset url.MESHAS = form.MESHAS>
</cfif>
<cfif isdefined("form.NIVEL")>
	<cfset url.NIVEL = form.NIVEL>
</cfif>
<cfif isdefined("form.PERIODODES")>
	<cfset url.PERIODODES = form.PERIODODES>
</cfif>
<cfif isdefined("form.PERIODOHAS")>
	<cfset url.PERIODOHAS = form.PERIODOHAS>
</cfif>
<cfif isdefined("form.UBICACION")>
	<cfset url.UBICACION = form.UBICACION>
</cfif>
<cfif isdefined("form.MostrarCeros")>
	<cfset url.chkCeros = form.MostrarCeros>
</cfif>

<cfset varMcodigo = "">
<cfset LvarIncluirOficina = false>
<cfif isdefined("url.IncluirOficina") and url.IncluirOficina EQ "S">
	<cfset LvarIncluirOficina = true>
</cfif>

<cfset LvarMostarCeros = "N">
<cfif isdefined("url.MostrarCeros") and url.MostrarCeros EQ "S">
	<cfset LvarMostarCeros = "S">
</cfif>
<cfif isdefined("url.ChkCeros") and url.ChkCeros EQ "S">
	<cfset LvarMostarCeros = "S">
</cfif>
<cfif isdefined("form.MostrarCeros") and form.MostrarCeros EQ "S">
	<cfset LvarMostarCeros = "S">
</cfif>

<cfif isdefined("url.mcodigoopt") and url.mcodigoopt EQ "0">
	<cfset varMcodigo = url.Mcodigo>
<cfelse>
	<cfset varMcodigo = url.mcodigoopt>
</cfif>

<cfset LvarIrA = 'BalCompRxPeriodo.cfm'>
<cfset LvarFile = 'BalanceComprobacion'>
<cfset Request.LvarTitle = 'Balanza de periódos'>


<cfset moneda ="">

<cfif isdefined("url.mcodigoopt") and url.mcodigoopt EQ "-2">
	<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
		select a.Mcodigo, b.Mnombre, b.Msimbolo, b.Miso4217
		from Empresas a, Monedas b 
		where a.Ecodigo = #Session.Ecodigo#
		  and a.Mcodigo = b.Mcodigo
	</cfquery>
	<cfset moneda =rsMonedaLocal.Mnombre>
<cfelseif isdefined("url.mcodigoopt") and url.mcodigoopt EQ "-3">
	<cfquery name="rsParam" datasource="#Session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = #Session.Ecodigo#
		and Pcodigo = 660
	</cfquery>
	<cfif rsParam.recordCount> 
		<cfquery name="rsMonedaConvertida" datasource="#Session.DSN#">
			select Mcodigo, Mnombre
			from Monedas
			where Ecodigo = #Session.Ecodigo#
			and Mcodigo = #rsParam.Pvalor#
		</cfquery>
	</cfif>
	<cfset moneda ='Convertida a ' & rsMonedaConvertida.Mnombre>
<cfelseif  isdefined("url.mcodigoopt") and url.mcodigoopt EQ "0">
	<cfquery name="rsMonedaSel" datasource="#Session.DSN#">
		select Mcodigo, Mnombre
		from Monedas
		where Ecodigo = #Session.Ecodigo#
		and Mcodigo = #url.Mcodigo#
	</cfquery>
	<cfset moneda ='Montos en ' & rsMonedaSel.Mnombre>
</cfif>

<cfif isdefined("url.cmayor_ccuenta1") and url.cmayor_ccuenta1 NEQ "">
	<cfset varCuentaini = url.cmayor_ccuenta1>
	<cfif isdefined("url.cformato1") and url.cformato1 NEQ "">
		<cfset varCuentaini = varCuentaini & "-" & url.cformato1>
	</cfif>
<cfelse>
	<cfset varCuentaini = "">
</cfif>	

<cfif isdefined("url.cmayor_ccuenta2") and url.cmayor_ccuenta2 NEQ "">
	<cfset varCuentafin = url.cmayor_ccuenta2>
	<cfif isdefined("url.cformato2") and url.cformato2 NEQ "">
		<cfset varCuentafin = varCuentafin & "-" & url.cformato2>
	</cfif>
<cfelse>
	<cfset varCuentafin = "">
</cfif>

<!--- Empresas u Oficinas --->
<cfif isDefined("url.ubicacion")>
	<cfset myEcodigo = IIf(len(trim(url.ubicacion)) EQ 0, session.Ecodigo,-1)>
	<cfset myGEid    = IIf(ListFirst(url.ubicacion) EQ 'ge', ListRest(url.ubicacion), -1)>
	<cfset myGOid    = IIf(ListFirst(url.ubicacion) EQ 'go', ListRest(url.ubicacion), -1)>
	<cfset myOcodigo = IIf(ListFirst(url.ubicacion) EQ 'of', ListRest(url.ubicacion), -1)>
<cfelse>
	<cfset myEcodigo = session.Ecodigo>
	<cfset myGEid = "-1">
	<cfset myGOid = "-1">
	<cfset myOcodigo = "-1">
</cfif>

<!--- Obtiene la Ubicación --->
<cfset ubiDescripcion = "- Todas -">
<cfif myOcodigo NEQ -1>
	<cfquery name="rsOficinas" datasource="#Session.DSN#">
		select Odescripcion
		from Oficinas 
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer"> 
		  and Ocodigo = <cfqueryparam value="#myOcodigo#" cfsqltype="cf_sql_integer"> 
	</cfquery>
	<cfif rsOficinas.recordCount EQ 1>
		<cfset ubiDescripcion = "- Oficina: " & #rsOficinas.Odescripcion# & " -">
	<cfelse><cfset ubiDescripcion = "- Todas las Oficinas -">
	</cfif>

<cfelseif myEcodigo NEQ -1>
	<cfset ubiDescripcion = "- Empresas: " & #HTMLEditFormat(session.Enombre)# & " -">

<cfelseif myGEid NEQ -1>
	<cfquery name="rsGE" datasource="#session.DSN#">
		select ge.GEnombre
		from AnexoGEmpresa ge
			join AnexoGEmpresaDet gd
				on ge.GEid = gd.GEid
		where ge.CEcodigo = #session.CEcodigo#
		  and gd.Ecodigo = #session.Ecodigo#
		  and ge.GEid = #myGEid#
		order by ge.GEnombre
	</cfquery>
	<cfif rsGE.recordCount EQ 1>
		<cfset ubiDescripcion = "- Grupo de Empresa: " & #rsGE.GEnombre# & " -">
	<cfelse><cfset ubiDescripcion = "- Todos las Grupos de Empresa -">
	</cfif>
	
<cfelseif myGOid NEQ -1>
	<cfquery name="rsGO" datasource="#session.DSN#">
		select GOid, GOnombre
		from AnexoGOficina
		where Ecodigo = #session.Ecodigo#
		  and GOid = #myGOid#
		order by GOnombre
	</cfquery>
	<cfif rsGO.recordCount EQ 1>
		<cfset ubiDescripcion = "- Grupo de Oficina: " & #rsGO.GOnombre# & " -">
	<cfelse><cfset ubiDescripcion = "- Todos las Grupos de Oficina -">
	</cfif>	
</cfif>

<cftry>
	<cfinvoke returnvariable="rs_Res" component="sif.Componentes.sp_SIF_CG0004Periodo" method="balanzaPeriodo" 
		periododes="#url.periododes#"
        periodohas="#url.periodohas#"
		mesdes="#url.mesdes#"
        meshas="#url.meshas#"
		nivel="#url.nivel#"
		Mcodigo="#varMcodigo#"
		cuentaini="#varCuentaini#"
		cuentafin="#varCuentafin#"
		incluirOficina="#LvarIncluirOficina#"
		Ecodigo="#Session.Ecodigo#"
		Ocodigo="#myOcodigo#"
		myGEid="#myGEid#"
		myGOid="#myGOid#"
		ceros="#LvarMostarCeros#"
		mescierre="0"
		>
	</cfinvoke>			

<cfcatch type="any">
	<cfinclude template="../../errorPages/BDerror.cfm">
</cfcatch>
</cftry> 

<cfif not LvarIncluirOficina>
	<cf_dbfunction name="to_char" args="getdate()" returnvariable="LvarFecha">
	<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="15001">
		select
			min(Ecodigo) as Ecodigo,
			min(Ccuenta) as Ccuenta,
			min(#url.periododes#) as Periododes,
			min(#url.periodohas#) as Periodohas,
			min(#url.mesdes#) as Mesdes,
			min(#url.meshas#) as Meshas,
            min(#myOcodigo#) as Oficina,
			'#moneda#' as moneda,
			corte as corte,
			nivel as nivel, 
			tipo as tipo, 
			ntipo as ntipo, 
			mayor as mayor, 
			descrip as descrip, 
			formato as formato,
			sum(saldoini) as saldoini, 
			sum(saldofin) as saldofin, 
			sum(debitos) as debitos, 
			sum(creditos) as creditos, 
			sum(movmes) as movmes,
			Mcodigo as Mcodigo, 
			min(Edescripcion) as Edescripcion, 
			totdebitos, 
			totcreditos,
			totmovmes, 
			totsaldofin,
			rango as rango
		from DCGRBalanceComprobacion
		where CGRBCid = #rs_Res#
		group by
				<!--- Ecodigo, 
				Ccuenta, --->				
				corte,
				nivel, 
				tipo, 
				ntipo, 
				mayor, 
				descrip, 
				formato,
				Mcodigo, 
				<!--- Edescripcion, ---> 
				rango,
				totdebitos, 
				totcreditos,
				totmovmes, 
				totsaldofin
		order by mayor, formato
	</cfquery>
<cfelse>
	<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="15001">
		select
			a.Ecodigo as Ecodigo,
			a.Ccuenta as Ccuenta,
			#url.periododes# as Periododes,
			#url.periodohas# as Periodohas,
			#url.mesdes# as Mesdes,
			#url.meshas# as Meshas,
			#myOcodigo# as Oficina,
			'#moneda#' as moneda,
	 		a.corte as corte,
			a.nivel as nivel, 
			a.tipo as tipo, 
			a.ntipo as ntipo, 
			a.mayor as mayor, 
			a.descrip as descrip, 
			a.formato as formato,
			a.saldoini as saldoini, 
			a.saldofin as saldofin, 
			a.debitos as debitos, 
			a.creditos as creditos, 
			a.movmes as movmes,
			a.Mcodigo as Mcodigo, 
			a.Edescripcion as Edescripcion, 
			a.totdebitos as totdebitos, 
			a.totcreditos as totcreditos,
			a.totmovmes as totmovmes, 
			a.totsaldofin as totsaldofin,
			a.rango as rango,
			o.Oficodigo as Oficodigo,
			o.Odescripcion as Odescripcion
		from DCGRBalanceComprobacion a
			inner join Oficinas o
				on o.Ecodigo = a.Ecodigo
			   and o.Ocodigo = a.Ocodigo
		where CGRBCid = #rs_Res#
		order by o.Oficodigo, a.mayor, a.formato
	</cfquery>
</cfif>

<cfquery datasource="#session.DSN#">
	delete from DCGRBalanceComprobacion
	where CGRBCid = #rs_Res#
</cfquery>

<cfquery datasource="#session.DSN#">
	delete from CGRBalanceComprobacion
	where CGRBCid = #rs_Res#
</cfquery>

<cfif isdefined("rsReporte") and rsReporte.recordcount gt 15000 and url.formato NEQ "HTML">
	<cf_errorCode	code = "50239" msg = "Se han generado mas de 15000 registros para este reporte.">
	<cfabort>
</cfif>

<cfset strMesDes = "">
<cfswitch expression="#url.mesdes#">
	<cfcase value="1"><cfset strMesDes = "Enero"></cfcase>
	<cfcase value="2"><cfset strMesDes = "Febrero"></cfcase>
	<cfcase value="3"><cfset strMesDes = "Marzo"></cfcase>
	<cfcase value="4"><cfset strMesDes = "Abril"></cfcase>
	<cfcase value="5"><cfset strMesDes = "Mayo"></cfcase>
	<cfcase value="6"><cfset strMesDes = "Junio"></cfcase>
	<cfcase value="7"><cfset strMesDes = "Julio"></cfcase>
	<cfcase value="8"><cfset strMesDes = "Agosto"></cfcase>
	<cfcase value="9"><cfset strMesDes = "Setiembre"></cfcase>
	<cfcase value="10"><cfset strMesDes = "Octubre"></cfcase>
	<cfcase value="11"><cfset strMesDes = "Noviembre"></cfcase>										
	<cfcase value="12"><cfset strMesDes = "Diciembre"></cfcase>
</cfswitch>

<cfset strMesHas = "">
<cfswitch expression="#url.meshas#">
	<cfcase value="1"><cfset strMesHas = "Enero"></cfcase>
	<cfcase value="2"><cfset strMesHas = "Febrero"></cfcase>
	<cfcase value="3"><cfset strMesHas = "Marzo"></cfcase>
	<cfcase value="4"><cfset strMesHas = "Abril"></cfcase>
	<cfcase value="5"><cfset strMesHas = "Mayo"></cfcase>
	<cfcase value="6"><cfset strMesHas = "Junio"></cfcase>
	<cfcase value="7"><cfset strMesHas = "Julio"></cfcase>
	<cfcase value="8"><cfset strMesHas = "Agosto"></cfcase>
	<cfcase value="9"><cfset strMesHas = "Setiembre"></cfcase>
	<cfcase value="10"><cfset strMesHas = "Octubre"></cfcase>
	<cfcase value="11"><cfset strMesHas = "Noviembre"></cfcase>										
	<cfcase value="12"><cfset strMesHas = "Diciembre"></cfcase>
</cfswitch>

<cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
	select Pvalor as valParam
	from Parametros
	where Pcodigo = 20007
	and Ecodigo = #Session.Ecodigo#
</cfquery>
<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
<cfset typeRep = 1>
<cfif url.formato EQ "pdf">
	<cfset typeRep = 2>
</cfif>

<cfif url.formato NEQ "HTML">
	<cfsetting enablecfoutputonly="no">
	<cfif not LvarIncluirOficina>
	    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	        <cf_js_reports_service_tag queryReport = "#rsReporte#" 
			    isLink = False 
			    typeReport = #typeRep#
			    fileName = "cg.consultas.BalCompxPeriodo"/>
		<cfelse>
			<cfreport format="#url.formato#" template= "BalCompxPeriodo.cfr" query="rsReporte">
				<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
				<cfreportparam name="CGRBCid" value="#rs_Res#">	
				<cfreportparam name="periododes" value="#url.periododes#">
				<cfreportparam name="periodohas" value="#url.periodohas#">
				<cfreportparam name="mesdes" 	  value="#strMesDes#">	
				<cfreportparam name="meshas" 	  value="#strMesHas#">	
				<cfreportparam name="ofiDescripcion" value="#ubiDescripcion#">	
				<cfreportparam name="cuentades" value="#url.cmayor_ccuenta1#">	
				<cfreportparam name="cuentahas" value="#url.cmayor_ccuenta2#">	
			</cfreport> 
		</cfif>
	<cfelse>
	    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	        <cf_js_reports_service_tag queryReport = "#rsReporte#" 
			    isLink = False 
			    typeReport = #typeRep#
			    fileName = "cg.consultas.BalComp_OficinaxPeriodo"/>
		<cfelse>
			<cfreport format="#url.formato#" template= "BalComp_OficinaxPeriodo.cfr" query="rsReporte">
				<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
				<cfreportparam name="CGRBCid" value="#rs_Res#">	
				<cfreportparam name="periododes" value="#url.periododes#">
				<cfreportparam name="periodohas" value="#url.periodohas#">
				<cfreportparam name="mesdes" 	  value="#strMesDes#">	
				<cfreportparam name="meshas" 	  value="#strMesHas#">	
				<cfreportparam name="ofiDescripcion" value="#ubiDescripcion#">
				<cfreportparam name="cuentades" value="#url.cmayor_ccuenta1#">	
				<cfreportparam name="cuentahas" value="#url.cmayor_ccuenta2#">	
			</cfreport>
		</cfif>
	</cfif>
<cfelse>
		<cfquery name="rsNombreEmpresa" datasource="#session.dsn#">
			select e.Edescripcion
			from Empresas e
			where e.Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfoutput>
			<cf_htmlreportsheaders
				title="#request.LvarTitle#" 
				filename="#LvarFile#-#Session.Usucodigo#.xls" 
				ira="#LvarIrA#">
			<cfif not isdefined("btnDownload")>  
                <cf_templatecss>
            </cfif>	
		</cfoutput>
		<cfflush interval="20">
		<cfoutput>

				<style type="text/css" >
					.corte {
						font-weight:bold; 
					}
				</style>

				<table width="100%" cellpadding="0" cellspacing="0"  bgcolor="##99CCFF">
					<tr>
						<td colspan="2">&nbsp;</td>
						<td align="right">#DateFormat(now(),"DD/MM/YYYY")#</td>
					</tr>					
					<tr>
						<td style="font-size:16px" align="center" colspan="3">
						<strong>#rsNombreEmpresa.Edescripcion#</strong>	
						</td>
					</tr>
					<tr>
						<td style="font-size:16px" align="center" colspan="3">
							<strong>
								Balanza de Período
							</strong>
						</td>
					</tr>
					<tr>
						<td style="font-size:16px" align="center" colspan="3"><strong>Cifras en #rsReporte.Moneda#</strong></td>
					</tr>
					<tr>
						<td style="font-size:16px" align="center" colspan="3"><strong>Confidencial</strong></td>
					</tr>
					<tr>
						<td style="font-size:16px" align="center" colspan="3" nowrap="nowrap">
						<strong>Periódo desde:&nbsp;#url.periododes#&nbsp;#strMesDes#&nbsp; hasta:&nbsp;#url.periododes#&nbsp;#strMesHas#</strong>
						</td>
					</tr>
                    <tr>
                    	<td style="font-size:16px" align="center" colspan="3" nowrap="nowrap">
                        	<strong>#rsReporte.rango#</strong>
                        </td>
                    </tr>
					<tr>
						<td colspan="3">&nbsp;</td>
					</tr>
					</table>
					<table width="100%">
					<tr>
						
						<td nowrap><strong>Cuenta</strong></td>
						<td nowrap><strong>Descripci&oacute;n</strong></td>
						<td nowrap align="right"><strong>Saldo Inicial</strong></td>
						<td nowrap align="right">
							<strong>
								D&eacute;bitos
							</strong>
						</td>
						<td nowrap align="right">
							<strong>
								Cr&eacute;ditos
							</strong>
						</td>
						<td nowrap align="right">
							<strong>
								Movimientos
							</strong>
						</td>
						<td nowrap align="right"><strong>Saldo Final</strong></td>
					</tr>
					<tr><td colspan="7">&nbsp;</td></tr>
					<cfset LvarOficodigoControl = "-1">
					<cfset Total_Debitos = 0>
					<cfset Total_Creditos = 0>
					<cfset Total_Saldo = 0>
					<cfset TotalG_Debitos = 0>
					<cfset TotalG_Creditos = 0>
					<cfset TotalG_Saldo = 0>
					<cfloop query="rsReporte">
						<cfif LvarIncluirOficina>
							<cfif LvarOficodigoControl NEQ rsReporte.Oficodigo>
								<cfif LvarOficodigoControl NEQ "-1">
									<tr>
									<td nowrap><strong>Totales Oficina:</strong></td>
									<td nowrap>&nbsp;</td>
									<td nowrap>&nbsp;</td>
									<td nowrap align="right"><strong>#numberformat(Total_Debitos, ",9.00")#</strong></td>
									<td nowrap align="right"><strong>#numberformat(Total_Creditos, ",9.00")#</strong></td>
									<td nowrap align="right"><strong>#numberformat(Total_Debitos - Total_Creditos, ",9.00")#</strong></td>
									<td nowrap align="right"><strong>#numberformat(Total_Saldo, ",9.00")#</strong></td>
									</tr>
									<tr>
										<td colspan="7">&nbsp;</td>
									</tr>
									<cfset Total_Debitos = 0>
									<cfset Total_Creditos = 0>
									<cfset Total_Saldo = 0>
								</cfif>
								<cfset LvarOficodigoControl = rsReporte.Oficodigo>
								<tr>
								<td colspan="7"><strong>Oficina:#rsReporte.Oficodigo# #rsReporte.Odescripcion#</strong></td>
								</tr>
							</cfif>
						</cfif>
						<tr <cfif len(rsReporte.formato) LT 5 and (rsReporte.mayor EQ rsReporte.formato)>class="corte"</cfif>>
							
							<td nowrap >&nbsp;
								<cfif len(rsReporte.formato) GT 5>
									&nbsp;&nbsp;&nbsp;
								</cfif>
								#rsReporte.formato#
							</td>
							<td nowrap >#rsReporte.descrip#</td>
							<td nowrap align="right">#numberformat(rsReporte.saldoini, ",9.00")#</td>
							<td nowrap align="right">#numberformat(rsReporte.debitos, ",9.00")#</td>
							<td nowrap align="right">#numberformat(rsReporte.creditos, ",9.00")#</td>
							<td nowrap align="right">#numberformat(rsReporte.movmes, ",9.00")#</td>
							<td nowrap align="right">#numberformat(rsReporte.saldofin, ",9.00")#</td>
							<cfif (len(rsReporte.formato) LT 5 and (rsReporte.mayor EQ rsReporte.formato)) or url.nivel EQ -2>
								<cfset Total_Debitos = Total_Debitos + rsReporte.debitos>
								<cfset Total_Creditos = Total_Creditos + rsReporte.creditos>
								<cfset Total_Saldo = Total_Saldo + rsReporte.saldofin>
								<cfset TotalG_Debitos = TotalG_Debitos + rsReporte.debitos>
								<cfset TotalG_Creditos = TotalG_Creditos + rsReporte.creditos>
								<cfset TotalG_Saldo = TotalG_Saldo + rsReporte.saldofin>
							</cfif>
						</tr>
					</cfloop>
					<cfif LvarIncluirOficina>
						<cfif LvarOficodigoControl NEQ "-1">
							<tr>
							<td nowrap><strong>Totales Oficina:</strong></td>
							<td nowrap>&nbsp;</td>
							<td nowrap>&nbsp;</td>
							<td nowrap align="right"><strong>#numberformat(Total_Debitos, ",9.00")#</strong></td>
							<td nowrap align="right"><strong>#numberformat(Total_Creditos, ",9.00")#</strong></td>
							<td nowrap align="right"><strong>#numberformat(Total_Debitos - Total_Creditos, ",9.00")#</strong></td>
							<td nowrap align="right"><strong>#numberformat(Total_Saldo, ",9.00")#</strong></td>
							</tr>
							<tr>
								<td colspan="7">&nbsp;</td>
							</tr>
						</cfif>
					</cfif>
					<tr>
						<td nowrap><strong>Totales Finales:</strong></td>
						<td nowrap>&nbsp;</td>
						<td nowrap>&nbsp;</td>
						<td nowrap align="right"><strong>#numberformat(TotalG_Debitos, ",9.00")#</strong></td>
						<td nowrap align="right"><strong>#numberformat(TotalG_Creditos, ",9.00")#</strong></td>
						<td nowrap align="right"><strong>#numberformat(TotalG_Debitos - TotalG_Creditos, ",9.00")#</strong></td>
						<td nowrap align="right"><strong>#numberformat(TotalG_Saldo, ",9.00")#</strong></td>
					</tr>
		</cfoutput>
</cfif>


