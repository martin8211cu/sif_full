<cf_PleaseWait SERVER_NAME="/cfmx/sif/cg/consultas/SQLBalCompR2_Moneda.cfm" >
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
<cfif isdefined("form.MESD")>
	<cfset url.MESD = form.MESD>
</cfif>
<cfif isdefined("form.MESH")>
	<cfset url.MESH = form.MESH>
</cfif>
<cfif isdefined("form.NIVEL")>
	<cfset url.NIVEL = form.NIVEL>
</cfif>
<cfif isdefined("form.PERIODOD")>
	<cfset url.PERIODOD = form.PERIODOD>
</cfif>
<cfif isdefined("form.PERIODOH")>
	<cfset url.PERIODOH = form.PERIODOH>
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

<cfset LvarIrA = 'BalCompR_Moneda.cfm'>
<cfset LvarFile = 'BalanceComprobacion'>
<cfset Request.LvarTitle = 'Balance de Comprobación'>

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
	<cfif isdefined("url.Mcodigo") and url.Mcodigo EQ "-1">
		<cfset moneda ="Todas las Monedas">
	<cfelse>
		<cfquery name="rsMonedaSel" datasource="#Session.DSN#">
			select Mcodigo, Mnombre
			from Monedas
			where Ecodigo = #Session.Ecodigo#
			and Mcodigo = #url.Mcodigo#
		</cfquery>
		<cfset moneda ='Montos en ' & rsMonedaSel.Mnombre>
	</cfif>
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
	<cfinvoke returnvariable="rs_Res" component="sif.Componentes.sp_SIF_CG0004_Moneda" method="balanceComprob" 
		periodoD="#url.periodoD#"
		mesD="#url.mesD#"
		periodoH="#url.periodoH#"
		mesH="#url.mesH#"
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
		>
	</cfinvoke>			

<cfcatch type="any">
	<cfinclude template="../../errorPages/BDerror.cfm">
</cfcatch>
</cftry> 
<cfquery name="rsRango" dbtype="query" datasource="#session.DSN#">
	select distinct rango
	from DCGRBalanceComprobacion
	where CGRBCid = #rs_Res#
</cfquery>
<cfif not LvarIncluirOficina>
	<cf_dbfunction name="to_char" args="getdate()" returnvariable="LvarFecha">
	<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="15001">
		select
			a.Ecodigo as Ecodigo,
			Ccuenta as Ccuenta,
			min(#url.periodoD#) as Periodo,
			min(#url.mesD#) as Mes,
			min(#myOcodigo#) as Oficina,
			'#moneda#' as moneda,
			corte as corte,
			nivel as nivel, 
			tipo as tipo, 
			ntipo as ntipo, 
			mayor as mayor, 
			descrip as descrip, 
			formato as formato,
			sum(a.saldoini) as saldoini, 
			sum(a.saldofin) as saldofin, 
			sum(a.debitos) as debitos, 
			sum(a.creditos) as creditos, 
			sum(a.movmes) as movmes,
			a.Mcodigo as Mcodigo, 
			(select Mnombre from Monedas where Mcodigo = a.Mcodigo) as Mnombre,
			Edescripcion as Edescripcion, 
			totdebitos, 
			totcreditos,
			totmovmes, 
			totsaldofin
		from DCGRBalanceComprobacion a
		where CGRBCid = #rs_Res#
		group by
				a.Ecodigo, 
				Ccuenta,				
				corte,
				nivel, 
				tipo, 
				ntipo, 
				mayor, 
				descrip, 
				formato,
				a.Mcodigo, 
				Edescripcion,
				a.Mcodigo,
				totdebitos, 
				totcreditos,
				totmovmes, 
				totsaldofin
		order by a.Mcodigo, mayor,formato
	</cfquery>
<cfelse>
	<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="15001">
		select
			a.Ecodigo as Ecodigo,
			a.Ccuenta as Ccuenta,
			#url.periodoD# as Periodo,
			#url.mesD# as Mes,
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
			m.Mnombre as Mnombre,
			a.Edescripcion as Edescripcion, 
			a.totdebitos as totdebitos, 
			a.totcreditos as totcreditos,
			a.totmovmes as totmovmes, 
			a.totsaldofin as totsaldofin,
			o.Oficodigo as Oficodigo,
			o.Odescripcion as Odescripcion
		from DCGRBalanceComprobacion a
			inner join Oficinas o
				on o.Ecodigo = a.Ecodigo
			   and o.Ocodigo = a.Ocodigo
			left outer join Monedas m
				on m.Mcodigo = a.Mcodigo
		where CGRBCid = #rs_Res#
		order by o.Oficodigo ,a.Mcodigo , a.mayor, a.formato
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



<!--- ********************************************************* Todas las monedas ************************************************************************************* --->
<cfif isdefined("url.mcodigoopt") and url.mcodigoopt EQ "0" and isdefined("url.Mcodigo") and url.Mcodigo eq -1> <!--- Origen: y monedas Todas --->
    <cftry>
        <cfinvoke returnvariable="rs_ResLocal" component="sif.Componentes.sp_SIF_CG0004_Moneda" method="balanceComprob" 
            periodoD="#url.periodoD#"
            mesD="#url.mesD#"
            periodoH="#url.periodoH#"
            mesH="#url.mesH#"
            nivel="#url.nivel#"
            Mcodigo="-2"
            cuentaini="#varCuentaini#"
            cuentafin="#varCuentafin#"
            incluirOficina="#LvarIncluirOficina#"
            Ecodigo="#Session.Ecodigo#"
            Ocodigo="#myOcodigo#"
            myGEid="#myGEid#"
            myGOid="#myGOid#"
            ceros="#LvarMostarCeros#"
            >
        </cfinvoke>			
    
    <cfcatch type="any">
        <cfinclude template="../../errorPages/BDerror.cfm">
    </cfcatch>
    </cftry> 

	<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
		select a.Mcodigo, b.Mnombre, b.Msimbolo, b.Miso4217
		from Empresas a, Monedas b 
		where a.Ecodigo = #Session.Ecodigo#
		  and a.Mcodigo = b.Mcodigo
	</cfquery>
	<cfset monedaLocal =rsMonedaLocal.Mnombre>
    <cfquery name="rsRango" dbtype="query" datasource="#session.DSN#">
		select distinct rango
		from DCGRBalanceComprobacion
		where CGRBCid = #rs_Res#
	</cfquery>
	<cfif not LvarIncluirOficina>
        <cf_dbfunction name="to_char" args="getdate()" returnvariable="LvarFecha">
        <cfquery name="rsReporteLocal" datasource="#session.DSN#" maxrows="15001">
            select
                min(a.Ecodigo) as Ecodigo,
                min(Ccuenta) as Ccuenta,
                min(#url.periodoD#) as Periodo,
                min(#url.mesD#) as Mes,
                min(#myOcodigo#) as Oficina,
                '#moneda#' as moneda,
                corte as corte,
                nivel as nivel, 
                tipo as tipo, 
                ntipo as ntipo, 
                mayor as mayor, 
                descrip as descrip, 
                formato as formato,
                sum(a.saldoini) as saldoini, 
                sum(a.saldofin) as saldofin, 
                sum(a.debitos) as debitos, 
                sum(a.creditos) as creditos, 
                sum(a.movmes) as movmes,
                a.Mcodigo as Mcodigo, 
                (select Mnombre from Monedas where Mcodigo = a.Mcodigo) as Mnombre,
                min(Edescripcion) as Edescripcion, 
                totdebitos, 
                totcreditos,
                totmovmes, 
                totsaldofin
            from DCGRBalanceComprobacion a
            where CGRBCid = #rs_ResLocal#
            group by
                    <!--- a.Ecodigo, 
                    Ccuenta, --->
                    corte,
                    nivel, 
                    tipo, 
                    ntipo, 
                    mayor, 
                    descrip, 
                    formato,
                    a.Mcodigo, 
                    <!--- Edescripcion,  --->
                    a.Mcodigo,
					totdebitos, 
					totcreditos,
					totmovmes, 
					totsaldofin
		order by a.Mcodigo, mayor,formato
	</cfquery>
    <cfelse>
        <cfquery name="rsReporteLocal" datasource="#session.DSN#" maxrows="15001">
            select
                a.Ecodigo as Ecodigo,
                a.Ccuenta as Ccuenta,
                #url.periodoD# as Periodo,
                #url.mesD# as Mes,
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
                m.Mnombre as Mnombre,
                a.Edescripcion as Edescripcion, 
                a.totdebitos as totdebitos, 
                a.totcreditos as totcreditos,
                a.totmovmes as totmovmes, 
                a.totsaldofin as totsaldofin,
                o.Oficodigo as Oficodigo,
                o.Odescripcion as Odescripcion
            from DCGRBalanceComprobacion a
                inner join Oficinas o
                    on o.Ecodigo = a.Ecodigo
                   and o.Ocodigo = a.Ocodigo
                left outer join Monedas m
                    on m.Mcodigo = a.Mcodigo
            where CGRBCid = #rs_ResLocal#
            order by o.Oficodigo ,a.Mcodigo , a.mayor, a.formato
        </cfquery>
    </cfif>
    <cfquery datasource="#session.DSN#">
        delete from DCGRBalanceComprobacion
        where CGRBCid = #rs_ResLocal#
    </cfquery>
    
    <cfquery datasource="#session.DSN#">
        delete from CGRBalanceComprobacion
        where CGRBCid = #rs_ResLocal#
    </cfquery>
    
    <cfif isdefined("rsReporteLocal") and rsReporteLocal.recordcount gt 15000 and url.formato NEQ "HTML">
        <cf_errorCode	code = "50239" msg = "Se han generado mas de 15000 registros para este reporte.">
        <cfabort>
    </cfif>
</cfif>
<!--- ********************************************************* Todas las monedas ************************************************************************************* --->

<cfset strMesD = "">
<cfswitch expression="#url.mesD#">
	<cfcase value="1"><cfset strMesD = "Enero"></cfcase>
	<cfcase value="2"><cfset strMesD = "Febrero"></cfcase>
	<cfcase value="3"><cfset strMesD = "Marzo"></cfcase>
	<cfcase value="4"><cfset strMesD = "Abril"></cfcase>
	<cfcase value="5"><cfset strMesD = "Mayo"></cfcase>
	<cfcase value="6"><cfset strMesD = "Junio"></cfcase>
	<cfcase value="7"><cfset strMesD = "Julio"></cfcase>
	<cfcase value="8"><cfset strMesD = "Agosto"></cfcase>
	<cfcase value="9"><cfset strMesD = "Setiembre"></cfcase>
	<cfcase value="10"><cfset strMesD = "Octubre"></cfcase>
	<cfcase value="11"><cfset strMesD = "Noviembre"></cfcase>										
	<cfcase value="12"><cfset strMesD = "Diciembre"></cfcase>
</cfswitch>

<cfset strMesH = "">
<cfswitch expression="#url.mesH#">
	<cfcase value="1"><cfset strMesH = "Enero"></cfcase>
	<cfcase value="2"><cfset strMesH = "Febrero"></cfcase>
	<cfcase value="3"><cfset strMesH = "Marzo"></cfcase>
	<cfcase value="4"><cfset strMesH = "Abril"></cfcase>
	<cfcase value="5"><cfset strMesH = "Mayo"></cfcase>
	<cfcase value="6"><cfset strMesH = "Junio"></cfcase>
	<cfcase value="7"><cfset strMesH = "Julio"></cfcase>
	<cfcase value="8"><cfset strMesH = "Agosto"></cfcase>
	<cfcase value="9"><cfset strMesH = "Setiembre"></cfcase>
	<cfcase value="10"><cfset strMesH = "Octubre"></cfcase>
	<cfcase value="11"><cfset strMesH = "Noviembre"></cfcase>										
	<cfcase value="12"><cfset strMesH = "Diciembre"></cfcase>
</cfswitch>


<cfif url.formato NEQ "HTML">
	<cfsetting enablecfoutputonly="no">
	<cfif not LvarIncluirOficina>
		<cfreport format="#url.formato#" template= "BalComp_Moneda.cfr" query="rsReporte">
			<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
			<cfreportparam name="CGRBCid" value="#rs_Res#">	
			<cfreportparam name="periodoD" value="#trim(url.periodoD)#">
			<cfreportparam name="mesD" 	  value="#trim(strMesD)#">	
			<cfreportparam name="periodoH" value="#trim(url.periodoH)#">
			<cfreportparam name="mesH" 	  value="#trim(strMesH)#">	
			<cfreportparam name="ofiDescripcion" value="#ubiDescripcion#">
			<cfreportparam name="nivel" value="#url.nivel#">
			<cfreportparam name="rango" value="#rsRango.rango#">		
		</cfreport> 
	<cfelse>
		<cfreport format="#url.formato#" template= "BalComp_Oficina_Moneda.cfr" query="rsReporte">
			<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
			<cfreportparam name="CGRBCid" value="#rs_Res#">	
			<cfreportparam name="periodoD" value="#url.periodoD#">
			<cfreportparam name="mesD" 	  value="#strMesD#">	
			<cfreportparam name="periodoH" value="#url.periodoH#">
			<cfreportparam name="mesH" 	  value="#strMesH#">
			<cfreportparam name="ofiDescripcion" value="#ubiDescripcion#">	
			<cfreportparam name="nivel" value="#url.nivel#">
			<cfreportparam name="rango" value="#rsRango.rango#">	
		</cfreport> 
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
									Balance de Comprobaci&oacute;n Por Moneda
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
						<table border="0" cellpadding="0" cellspacing="0"><tr>
							<td>
							<strong>Período Desde:&nbsp;#url.periodoD# &nbsp;&nbsp; Período Hasta:&nbsp;#url.periodoH#</strong>
							</td>
							</tr>
							<tr>
							<td style="font-size:16px" align="center" colspan="3" nowrap="nowrap">
							<strong>Mes Desde:&nbsp;#strMesD# &nbsp;&nbsp; Mes Hasta:&nbsp;#strMesH#</strong>
							</td>
						</tr></table>
						</td>
					</tr>
					<tr>
						<td colspan="3">&nbsp;</td>
					</tr>
					</table>
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<cfset LvarOficodigoControl = "-1">
					<cfset Total_Debitos = 0>
					<cfset Total_Creditos = 0>
					<cfset Total_Saldo = 0>
					<cfset TotalG_Debitos = 0>
					<cfset TotalG_Creditos = 0>
					<cfset TotalG_Saldo = 0>
					<cfset TotalM_Creditos = 0>
					<cfset TotalM_Debitos = 0>
					<cfset TotalM_Saldo = 0>
					<cfset monedaID = -1>
					<cfset LvarCambioOficina = false>
					<cfloop query="rsReporte">
						<cfif monedaID neq Mcodigo>
							<cfif monedaID neq '-1' or (LvarIncluirOficina and LvarOficodigoControl NEQ "-1" and LvarOficodigoControl NEQ rsReporte.Oficodigo)>
								<tr>
									<td nowrap><strong>Total por Moneda</strong></td>
									<td nowrap>&nbsp;</td>
									<td nowrap align="right">&nbsp;</td>
									<td nowrap align="right">
											<strong>#numberformat(TotalM_Debitos, ",9.00")#</strong>
									</td>
									<td nowrap align="right">
										<strong>#numberformat(TotalM_Creditos, ",9.00")#</strong>
									</td>
									<td nowrap align="right">
										<strong>#numberformat(TotalM_Debitos - TotalM_Creditos, ",9.00")#</strong>
									</td>
									<td nowrap align="right"><strong>#numberformat(TotalM_Saldo, ",9.00")#</strong> </td>
								</tr>
								<cfset TotalM_Debitos = 0>
								<cfset TotalM_Creditos = 0>
								<cfset TotalM_Saldo = 0>
							</cfif>
						</cfif>
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
								<cfset LvarCambioOficina = true>
								<cfset LvarOficodigoControl = rsReporte.Oficodigo>
								<tr>
								<td colspan="7" bgcolor="##666666"><strong>Oficina:#rsReporte.Oficodigo# #rsReporte.Odescripcion#</strong></td>
								</tr>
							</cfif>
						</cfif>
						<cfif monedaID neq Mcodigo or (LvarIncluirOficina and LvarCambioOficina)>
							<cfset monedaID = Mcodigo>
							<cfset LvarCambioOficina = false>
							<tr><td colspan="7">&nbsp;</td></tr>
							<tr>
								<td colspan="7" bgcolor="##DDDEE1">
									<strong>Moneda:&nbsp; #Mnombre# </strong>
								</td>
								</tr>
							</tr>
							<tr bgcolor="##DDDEE1">
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
								<cfset TotalM_Debitos = TotalM_Debitos + rsReporte.debitos>
                                <cfset TotalM_Creditos = TotalM_Creditos + rsReporte.creditos>
                                <cfset TotalM_Saldo = TotalM_Saldo + rsReporte.saldofin>
                                
								<cfset Total_Debitos = Total_Debitos + rsReporte.debitos>
								<cfset Total_Creditos = Total_Creditos + rsReporte.creditos>
								<cfset Total_Saldo = Total_Saldo + rsReporte.saldofin>
								<cfset TotalG_Debitos = TotalG_Debitos + rsReporte.debitos>
								<cfset TotalG_Creditos = TotalG_Creditos + rsReporte.creditos>
								<cfset TotalG_Saldo = TotalG_Saldo + rsReporte.saldofin>
							</cfif>
						</tr>
					</cfloop>
                    
					<cfif monedaID NEQ "-1">
						<tr><td colspan="7">&nbsp;</td></tr>
						<tr>
							<td nowrap><strong>Total por Moneda</strong></td>
							<td nowrap>&nbsp;</td>
							<td nowrap align="right">&nbsp;</td>
							<td nowrap align="right">
								<strong>#numberformat(TotalM_Debitos, ",9.00")#</strong>
							</td>
							<td nowrap align="right">
								<strong>#numberformat(TotalM_Creditos, ",9.00")#</strong>
							</td>
							<td nowrap align="right">
								<strong>#numberformat(TotalM_Debitos - TotalM_Creditos, ",9.00")#</strong>
							</td>
							<td nowrap align="right"><strong>#numberformat(TotalM_Saldo, ",9.00")#</strong></td>
						</tr>
                        <cfset TotalM_Debitos = 0>
						<cfset TotalM_Creditos = 0>
                        <cfset TotalM_Saldo = 0>
					</cfif>
					<tr><td colspan="7">&nbsp;</td></tr>
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
<!--- ********************************************************* Todas las monedas ************************************************************************************* --->                    

					<cfif isdefined("url.mcodigoopt") and url.mcodigoopt EQ "0" and isdefined("url.Mcodigo") and url.Mcodigo eq -1> <!--- Origen: monedas Todas --->
                    	<cfset LvarOficodigoControl = "-1">
						<cfset Total_Debitos = 0>
                        <cfset Total_Creditos = 0>
                        <cfset Total_Saldo = 0>
                        <cfset TotalG_Debitos = 0>
                        <cfset TotalG_Creditos = 0>
                        <cfset TotalG_Saldo = 0>
                        <cfset TotalM_Creditos = 0>
                        <cfset TotalM_Debitos = 0>
                        <cfset TotalM_Saldo = 0>
                        <cfset monedaID = -1>
                        <cfset LvarCambioOficina = false>
                        <cfloop query="rsReporteLocal">
                            <cfif monedaID neq Mcodigo>
                                <cfif monedaID neq '-1' or (LvarIncluirOficina and LvarOficodigoControl NEQ "-1" and LvarOficodigoControl NEQ rsReporteLocal.Oficodigo)>
                                    <tr>
                                        <td nowrap><strong>Total por Moneda Local</strong></td>
                                        <td nowrap>&nbsp;</td>
                                        <td nowrap align="right">&nbsp;</td>
                                        <td nowrap align="right">
                                                <strong>#numberformat(TotalM_Debitos, ",9.00")#</strong>
                                        </td>
                                        <td nowrap align="right">
                                            <strong>#numberformat(TotalM_Creditos, ",9.00")#</strong>
                                        </td>
                                        <td nowrap align="right">
                                            <strong>#numberformat(TotalM_Debitos - TotalM_Creditos, ",9.00")#</strong>
                                        </td>
                                        <td nowrap align="right"><strong>#numberformat(TotalM_Saldo, ",9.00")#</strong> </td>
                                    </tr>
                                    <cfset TotalM_Debitos = 0>
                                    <cfset TotalM_Creditos = 0>
                                    <cfset TotalM_Saldo = 0>
                                </cfif>
                            </cfif>
                            <cfif LvarIncluirOficina>
                                <cfif LvarOficodigoControl NEQ rsReporteLocal.Oficodigo>
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
                                    <cfset LvarCambioOficina = true>
                                    <cfset LvarOficodigoControl = rsReporteLocal.Oficodigo>
                                    <tr>
                                    <td colspan="7" bgcolor="##666666"><strong>Oficina:#rsReporteLocal.Oficodigo# #rsReporteLocal.Odescripcion#</strong></td>
                                    </tr>
                                </cfif>
                            </cfif>
                            <cfif monedaID neq Mcodigo or (LvarIncluirOficina and LvarCambioOficina)>
                                <cfset monedaID = Mcodigo>
                                <cfset LvarCambioOficina = false>
                                <tr><td colspan="7">&nbsp;</td></tr>
                                <tr>
                                    <td colspan="7" bgcolor="##DDDEE1">
                                        <strong>Moneda Local:&nbsp; #Mnombre# </strong>
                                    </td>
                                    </tr>
                                </tr>
                                <tr bgcolor="##DDDEE1">
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
                            </cfif>
                            <tr <cfif len(rsReporteLocal.formato) LT 5 and (rsReporteLocal.mayor EQ rsReporteLocal.formato)>class="corte"</cfif>>
                                <td nowrap >&nbsp;
                                    <cfif len(rsReporteLocal.formato) GT 5>
                                        &nbsp;&nbsp;&nbsp;
                                    </cfif>
                                    #rsReporteLocal.formato#
                                </td>
                                <td nowrap >#rsReporteLocal.descrip#</td>
                                <td nowrap align="right">#numberformat(rsReporteLocal.saldoini, ",9.00")#</td>
                                <td nowrap align="right">#numberformat(rsReporteLocal.debitos, ",9.00")#</td>
                                <td nowrap align="right">#numberformat(rsReporteLocal.creditos, ",9.00")#</td>
                                <td nowrap align="right">#numberformat(rsReporteLocal.movmes, ",9.00")#</td>
                                <td nowrap align="right">#numberformat(rsReporteLocal.saldofin, ",9.00")#</td>
                                
                                <cfif (len(rsReporteLocal.formato) LT 5 and (rsReporteLocal.mayor EQ rsReporteLocal.formato)) or url.nivel EQ -2>
                        			<cfset TotalM_Debitos = TotalM_Debitos + rsReporteLocal.debitos>
                                    <cfset TotalM_Creditos = TotalM_Creditos + rsReporteLocal.creditos>
                                    <cfset TotalM_Saldo = TotalM_Saldo + rsReporteLocal.saldofin>

                                    <cfset Total_Debitos = Total_Debitos + rsReporteLocal.debitos>
                                    <cfset Total_Creditos = Total_Creditos + rsReporteLocal.creditos>
                                    <cfset Total_Saldo = Total_Saldo + rsReporteLocal.saldofin>
                                    <cfset TotalG_Debitos = TotalG_Debitos + rsReporteLocal.debitos>
                                    <cfset TotalG_Creditos = TotalG_Creditos + rsReporteLocal.creditos>
                                    <cfset TotalG_Saldo = TotalG_Saldo + rsReporteLocal.saldofin>
                                </cfif>
                            </tr>
                        </cfloop>
                        
                        <cfif monedaID NEQ "-1">
                            <tr><td colspan="7">&nbsp;</td></tr>
                            <tr>
                                <td nowrap><strong>Total por Moneda Local</strong></td>
                                <td nowrap>&nbsp;</td>
                                <td nowrap align="right">&nbsp;</td>
                                <td nowrap align="right">
                                    <strong>#numberformat(TotalM_Debitos, ",9.00")#</strong>
                                </td>
                                <td nowrap align="right">
                                    <strong>#numberformat(TotalM_Creditos, ",9.00")#</strong>
                                </td>
                                <td nowrap align="right">
                                    <strong>#numberformat(TotalM_Debitos - TotalM_Creditos, ",9.00")#</strong>
                                </td>
                                <td nowrap align="right"><strong>#numberformat(TotalM_Saldo, ",9.00")#</strong></td>
                            </tr>
                        </cfif>
                        <tr><td colspan="7">&nbsp;</td></tr>
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
                            <td nowrap><strong>Totales Finales Local:</strong></td>
                            <td nowrap>&nbsp;</td>
                            <td nowrap>&nbsp;</td>
                            <td nowrap align="right"><strong>#numberformat(TotalG_Debitos, ",9.00")#</strong></td>
                            <td nowrap align="right"><strong>#numberformat(TotalG_Creditos, ",9.00")#</strong></td>
                            <td nowrap align="right"><strong>#numberformat(TotalG_Debitos - TotalG_Creditos, ",9.00")#</strong></td>
                            <td nowrap align="right"><strong>#numberformat(TotalG_Saldo, ",9.00")#</strong></td>
                        </tr>
					</cfif>                    
<!--- ********************************************************* Todas las monedas ************************************************************************************* --->                    
				</table>
		</cfoutput>
</cfif>


