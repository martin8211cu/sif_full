
<cfset tag_source = "#Form.chk#" />
<cfset aLineas = SplitDelimited(tag_source,",") />
<cfset aDatos = SplitDelimited(aLineas[1],"|") />
<cfset aNumLinea = ArrayNew(1)>
<cfloop from="1" index="i" to="#arrayLen(aLineas)#" step="1">
    <cfset aDatosLinea = SplitDelimited(aLineas[i],"|") />
	<cfset temp = ArrayAppend(aNumLinea, aDatosLinea[3])>
</cfloop>

<cfset listLineas = ArrayToList(aNumLinea, ",")>

<cfquery name="rsOficina" datasource="#Session.DSN#">
    select Ocodigo,Odescripcion,Oficodigo from Oficinas a
    where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="qry_monedaEmpresa" datasource="#session.dsn#">
    select Mcodigo
      from Empresas
     where Ecodigo = #session.Ecodigo#
</cfquery>

<!--- Obtiene el tipo de Periodo de Presupuesto del aprobacion_sql.cfm--->
<cfquery name="rsSQL" datasource="#session.dsn#">
	select 	v.CVid, v.CVtipo, v.CVdocumentoAprobo, p.CPPid, p.CPPfechaDesde, p.CPPfechaHasta, v.RHEid
	from CVersion v
			INNER JOIN CPresupuestoPeriodo p
				ON p.CPPid = v.CPPid
	where v.Ecodigo = #session.Ecodigo#
            and p.CPPid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#aDatos[1]#">
</cfquery>
<cfset url.CVid 	= rsSQL.CVid>
<cfset LvarCPPid 	= rsSQL.CPPid>
<cfset LvarFechaIni = rsSQL.CPPfechaDesde>
<cfset LvarFechaFin = rsSQL.CPPfechaHasta>

<cfset LvarFecha	= LvarFechaIni>

	<!--- <cfset LvarAno		= datepart("yyyy",LvarFechaIni)>
	<cfset LvarMes		= datepart("m",LvarFechaIni)> --->

	<cfquery name="rsAnoConta" datasource="#Session.DSN#">
		select Pvalor from Parametros where Pcodigo = 30 and Ecodigo = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>

	<cfquery name="rsMesConta" datasource="#Session.DSN#">
		select Pvalor from Parametros where Pcodigo = 40 and Ecodigo = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>

	<cfset LvarAno		= rsAnoConta.Pvalor>
	<cfset LvarMes		= rsMesConta.Pvalor>

<cfset LvarAprobacion = rsSQL.CVtipo EQ "1">

<cfquery name="rsLineas" datasource="#Session.DSN#">
		select n.CPNAPmoduloOri,n.CPCano, n.CPCmes, n.CPNAPDlinea, n.CPNAPnum,
			n.CPPid, n.CPcuenta, n.NAPMonto, n.CPNAPDtipoMov,
			cpp.CPCPtipoControl, cpp.CPCPcalculoControl,
			cpc.CPcuenta as CPCCPCuenta, cpc.Ocodigo,
			cpc.CPCpresupuestado, cpc.CPCmodificado,
			cpc.CPCmodificacion_Excesos, cpc.CPCvariacion,
			cpc.CPCtrasladado, cpc.CPCtrasladadoE, cpc.CPCreservado_Anterior,
			cpc.CPCcomprometido_Anterior, cpc.CPCreservado_Presupuesto,
			cpc.CPCreservado, cpc.CPCcomprometido,
			cpc.CPCejecutado, cpc.CPCejecutadoNC, cpc.CPCnrpsPendientes,
			cpt.CPformato, n.CPNAPDtipoMov 
	    	from (select f.CPNAPnum, CPNAPDlinea, e.Ecodigo, f.CPPid, f.CPcuenta,
							f.CPCano, f.CPCmes, f.CPNAPnumRef, f.CPNAPDtipoMov, e.CPNAPmoduloOri,
							f.CPNAPDmonto-f.CPNAPDutilizado as NAPMonto
					from dbo.CPNAPdetalle	f
						inner join dbo.CPNAP e
							on f.CPNAPnum = e.CPNAPnum

			)n
			left join CPresupuesto cpt
				on cpt.CPcuenta = n.CPcuenta
				and cpt.Ecodigo  = n.Ecodigo
			left JOIN CPCuentaPeriodo cpp
				on cpp.Ecodigo = n.Ecodigo
	            and cpp.CPPid = n.CPPid
	            and cpp.CPcuenta = n.CPcuenta
			left join CPresupuestoControl cpc
				on cpc.Ecodigo = n.Ecodigo
	            and cpc.CPPid = n.CPPid
	            and cpc.CPcuenta = n.CPcuenta
			where cpc.CPCano = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#aDatos[4]#">
				and cpc.CPCmes 	= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#aDatos[5]#">
				and n.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			    and n.CPPid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#aDatos[1]#">
			    and n.CPNAPnum = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#aDatos[2]#">
				and n.CPNAPDlinea in  (#listLineas#)
				<!--- and n.NAPMonto > 0 --->
</cfquery>

<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
<cfset LobjControl.CreaTablaIntPresupuesto(#session.dsn#,true)>

<cftransaction>

	<cfloop query="rsLineas">
		<cfset vs_aniomesLinea = #rsLineas.CPCano# * 100 + #rsLineas.CPCmes#>

		<cfquery name="rsSQLNAP" datasource="#session.dsn#">
			select count(*) as ultimo
			from CPNAP
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and EcodigoOri =<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and CPNAPmoduloOri = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#rsLineas.CPNAPmoduloOri#">
				and left(CPNAPdocumentoOri,3) = 'REV'
		</cfquery>
		<cfif rsSQLNAP.ultimo EQ "">
			<cfset LvarDocumentoAprobo = 1 />
		<cfelse>
			<cfset LvarDocumentoAprobo = rsSQLNAP.ultimo + 1 />
		</cfif>
		<cfset LvarDocumentoAprobo = "REV-"&#LvarDocumentoAprobo# />

		<!---<cfif rsLineas.NAPMonto GT 0>--->
		<cfquery name="rsInsertintPresupuesto" datasource="#session.dsn#">
			insert into #request.intPresupuesto#
		    	(
		        	ModuloOrigen,
		            NumeroDocumento,
		            NumeroReferencia,
		            FechaDocumento,
		            AnoDocumento,
		            MesDocumento,
					NumeroLinea,
					NAPreversado,
		            CPPid,
		            CPCano, CPCmes, CPCanoMes,
		            CPcuenta, Ocodigo,
		            CuentaPresupuesto, CodigoOficina,
		            TipoControl, CalculoControl, SignoMovimiento,
		            TipoMovimiento,
		            Mcodigo, 	MontoOrigen,
		            TipoCambio, Monto, NAPreferencia,LINreferencia
		        )
		        values (<cfqueryparam  cfsqltype="cf_sql_varchar" value="#rsLineas.CPNAPmoduloOri#">,
					'#LvarDocumentoAprobo#',
					'MODIFICACION',
		            <cf_dbfunction name="now">,
		            <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineas.CPCano#">,
		            <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineas.CPCmes#">,
					-<cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineas.CPNAPnum * 10000 + rsLineas.CPNAPDlinea#">, <!----HAY QUE CHECAR--->
					#rsLineas.CPNAPnum#,
		            <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineas.CPPid#">,
		            #rsLineas.CPCano#, #rsLineas.CPCmes#, #vs_aniomesLinea#,
		            <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineas.CPcuenta#">,
		            <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsOficina.Ocodigo#">,
		            '#rsLineas.CPformato#', '#rsOficina.Oficodigo#',
		            #rsLineas.CPCPtipoControl#, #rsLineas.CPCPcalculoControl#, +1,
		            <cfqueryparam  cfsqltype="cf_sql_varchar" value="#rsLineas.CPNAPDtipoMov#">,
		            #qry_monedaEmpresa.Mcodigo#, -1 * <cfqueryparam cfsqltype="cf_sql_money" value="#rsLineas.NAPMonto#">,
		            1, -1 * <cfqueryparam cfsqltype="cf_sql_money" value="#rsLineas.NAPMonto#">, #rsLineas.CPNAPnum#,#rsLineas.CPNAPDlinea#
		        )
		   </cfquery>
		   <!---</cfif>--->
	</cfloop>


<cfquery name="rs_regporCompr" datasource="#session.dsn#">
	select top 1 * from #request.intPresupuesto#
</cfquery>
<cfif rs_regporCompr.recordCount NEQ 0>
	<cfset LvarNAP = LobjControl.ControlPresupuestario(ModuloOrigen=aDatos[6], NumeroDocumento=LvarDocumentoAprobo, NumeroReferencia="MODIFICACION", FechaDocumento=LvarFecha,
															AnoDocumento=LvarAno, MesDocumento=LvarMes,ConciliaML="true", validaComp= "true") />
<cfelse>
	<cfset LvarNAP = -1 />
</cfif>

<cfif LvarNAP LT 0>
	<!--- to do --->
<cfelse>
	<!--- <cfquery name="actCPresupuestoComprometidasNAPs" datasource="#session.dsn#">
			update compnaps
            	set	CPNAPnum = cpnapd.CPNAPnum ,CPNAPDlinea = cpnapd.CPNAPDlinea
			from CPresupuestoComprometidasNAPs compnaps
	        inner join CPNAPdetalle cpnapd
				 	on compnaps.Ecodigo 	= <cfqueryparam  cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	                and compnaps.CPPid	= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#aDatos[1]#">
	                and compnaps.CPcuenta	= cpnapd.CPcuenta
	                and compnaps.Ocodigo	= cpnapd.Ocodigo
	                and compnaps.CPCano 	= cpnapd.CPCano
	                and compnaps.CPCmes		= cpnapd.CPCmes
	        where cpnapd.Ecodigo			= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	        	and cpnapd.CPNAPnum			= #LvarNAP#
	            and cpnapd.CPNAPDtipoMov	= 'CC'
	            <!--- and cpnapd.CPNAPDmonto		> 0 --->
	    </cfquery>

		<cfquery name="insCPresupuestoComprometidasNAPs" datasource="#session.dsn#">
	        insert into CPresupuestoComprometidasNAPs
	                    (
	                            Ecodigo,
	                            CPPid,
	                            CPcuenta, Ocodigo, CPCano, CPCmes,
	                            CPNAPnum, CPNAPDlinea
	                    )
	                    SELECT <cfqueryparam  cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, <cfqueryparam  cfsqltype="cf_sql_numeric" value="#aDatos[1]#">,
							cpnapd.CPcuenta, cpnapd.Ocodigo,
							cpnapd.CPCano,cpnapd.CPCmes,
							cpnapd.CPNAPnum, cpnapd.CPNAPDlinea
	                    from CPNAPdetalle cpnapd
		        left join CPresupuestoComprometidasNAPs compnaps
					 	on compnaps.Ecodigo 	= <cfqueryparam  cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		                and compnaps.CPPid	= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#CPPid#">
		                and compnaps.CPcuenta	= cpnapd.CPcuenta
		                and compnaps.Ocodigo	= cpnapd.Ocodigo
		                and compnaps.CPCano 	= cpnapd.CPCano
		                and compnaps.CPCmes		= cpnapd.CPCmes
		        where cpnapd.Ecodigo			= <cfqueryparam  cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		        	and cpnapd.CPNAPnum			= #LvarNAP#
		            and cpnapd.CPNAPDtipoMov	= 'CC'
		            <!--- and cpnapd.CPNAPDmonto		> 0 --->
			        and compnaps.CPcuenta	is null
		            and compnaps.Ocodigo is null
		            and compnaps.CPCano is null
		            and compnaps.CPCmes	is null
		</cfquery> --->

	</cfif>

</cftransaction>

<cfoutput>
<form action="LiberaNAP.cfm" method="post" name="sql">
    <input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
</form>
</cfoutput>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


<cffunction name="SplitDelimited" output="no" returntype="array" access="public">
	<cfargument name='tag_source' type='string' required='true' />
	<cfargument name='delimiter' type='string' required='true' />
	<cfset comma_pos = -1 />
	<cfset index = 1 />
	<cfset tag_array = ArrayNew(1) />
	<cfloop condition= "comma_pos NEQ 0 AND len(tag_source) GT 0">
		<cfset comma_pos = #find(delimiter, tag_source)# />
		<cfif comma_pos NEQ 0>
			<cfif comma_pos EQ 1>
				<cfset tag_source_n = #left(tag_source, comma_pos)# />
			<cfelse>
				<cfset tag_source_n = #left(tag_source, comma_pos-1)# />
			</cfif>
			<cfset tag_source = #removechars(tag_source, 1, comma_pos)# />
			<cfset tagArray[index] = trim(tag_source_n) />
		<cfelseif comma_pos EQ 0 AND len(tag_source) GT 0>
			<cfset tagArray[index] = trim(tag_source) />
		</cfif>
		<cfset index = index+1 />
	</cfloop>
	<cfreturn tagArray>
</cffunction>
