<!---<cf_dump var = "#form#">
--->


<!---<cfquery datasource="#Session.DSN#">
	delete MensAplCompromiso where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
--->

<cfinclude template="../../Utiles/sifConcat.cfm">

<cfif isdefined("Form.CPformato")>
	<cfquery name="rs_desccta" datasource="#Session.DSN#">
    	select CPcuenta, CPformato,coalesce(CPdescripcionF,CPdescripcion) as Descripcion
        from CPresupuesto
		where 	Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        	and CPformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPformato#">
    </cfquery>
	<cfif rs_desccta.RecordCount gt 0>
    	<cfset Form.CPCuenta = #rs_desccta.CPcuenta#>
    </cfif>
</cfif>
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_ExistenCambiosApl = t.Translate('LB_ExistenCambiosNoApl','No se puede Eliminar, existen compromisos aplicados para la cuenta con fecha anterior al cierre, cuenta : ')>
<cfset LB_ExistenCambiosNoApl = t.Translate('LB_ExistenCambiosNoApl','No se puede Eliminar, existen cambios no aplicados en la cuenta, cuenta : ')>
<cfset LB_NoEncontrolaCuenta = t.Translate('LB_NoEncontrolaCuenta','No encontró la cuenta : ')>
<cfset LB_YaEstaCapturadalaCuenta = t.Translate('LB_YaEstaCapturadalaCuenta','Ya está capturada la cuenta : ')>

<cfquery datasource="#Session.DSN#" name="rsget_val">
	select ltrim(rtrim(Pvalor)) as Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Pcodigo = 50
</cfquery>
<cfset vs_periodo="#rsget_val.Pvalor#">

<cfquery datasource="#Session.DSN#" name="rsget_val">
	select ltrim(rtrim(Pvalor)) as Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Pcodigo = 60
</cfquery>
<cfset vs_mes="#rsget_val.Pvalor#">
<cfset vs_aniomesLinea = #vs_periodo# * 100 + #vs_mes#>

<cfset modo = "ALTA">
<cfset Msg_Err = "">

<cfif isdefined("Form.Alta")>
	<cfif isdefined("Form.CPCuenta")>
		<cfquery name="rs_desccta" datasource="#Session.DSN#">
	    	select CPcuenta, CPformato,coalesce(CPdescripcionF,CPdescripcion) as Descripcion
	        from CPresupuesto
			where 	Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	        	and CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPCuenta#">
	    </cfquery>

		<cfquery name="rs_meses" datasource="#Session.DSN#">
			select 	CPPid,
			case CPPtipoPeriodo
			when 1 then 1
			when 2 then 2
			when 3 then 3
			when 4 then 4
			when 6 then 6
			when 12 then 12
			else 0 end as Num_Meses,
			CPPanoMesDesde, CPPanoMesHasta,left(CPPanoMesDesde,4) as Anio,
			right(CPPanoMesDesde,2)as Mes
			from CPresupuestoPeriodo p
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
		</cfquery>
		<cfset Anio_ini = #rs_meses.Anio#>
		<cfset Mes_ini 	= #rs_meses.Mes#>

	    <cfquery name="rs_CPresupuestoComprAut" datasource="#Session.DSN#">
	    	select * from CPresupuestoComprAut
			where Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and CPPid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
	            and CPcuenta	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPcuenta#">
	    </cfquery>

		<cfif rs_CPresupuestoComprAut.RecordCount gt 0>
	    	<cfset Msg_Err = "#LB_YaEstaCapturadalaCuenta#">
	    <cfelse>
		<cftransaction>
			<cfquery name="rsInsertCPtipoCtas" datasource="#Session.DSN#">
				insert into CPresupuestoComprAut(CPPid, CPcuenta, Ecodigo, Cmayor, CPCCmascara, CPCCdescripcion, CPcambioAplicado, BMUsucodigo)
				values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPcuenta#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(Form.CPformato,4)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPformato#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rs_desccta.Descripcion,40)#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="0">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usucodigo#">
						)
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.DSN#" name="rsDocsProvision">
			<cfset CPCAid = rsDocsProvision.identity>

			<cfloop index= i from = "1" to = "#rs_meses.Num_Meses#">
			<cfquery name="rsInsertDet" datasource="#Session.DSN#">
					insert into CPresupuestoComprAutD
					(CPPid, CPCCid, CPperiodo, CPmes, CPComprOri, CPComprMod, BMUsucodigo)
					values
					(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#CPCAid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Anio_ini#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Mes_ini#">,
						0,0,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usucodigo#">
					)
				</cfquery>
				<cfset Mes_ini 	= #Mes_ini# + 1>
				<cfif Mes_ini gt 12>
					<cfset Mes_ini 	= 1>
					<cfset Anio_ini = #Anio_ini# + 1>
				</cfif>
			</cfloop>
		</cftransaction>
		</cfif>
	</cfif>
<cfelseif isdefined("Form.BorrarD") and len(trim(Form.BorrarD)) gt 0>
	<cfquery name="rsSelectCPcuenta" datasource="#session.DSN#">
		select CPcuenta from CPresupuestoComprAut a
        where a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
        and a.CPCCid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPCCid#">
	</cfquery>
	<cfquery name="rsSelectCtas" datasource="#session.DSN#">
        select * from CPresupuestoComprAut	a
        inner join CPresupuestoComprAutD b
        on a.CPCCid=b.CPCCid
        where b.CPNAPnum <> 0
        and a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
        and a.CPCCid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPCCid#">
	</cfquery>
    <cfif rsSelectCtas.RecordCount eq 0> <!---No tiene NAP aplicado--->
        <cfquery name="CPresupuestoComprAut" datasource="#session.DSN#">
            delete from CPresupuestoComprAutD
            where CPCCid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPCCid#">
        </cfquery>
        <cfquery name="rsDeleteCPtipoCtas" datasource="#session.DSN#">
            delete from CPresupuestoComprAut
            where Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
            and CPCCid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPCCid#"> <!---SML. Modificación para eliminar registro de acuerdo al CPCCid--->
        </cfquery>
        <cfquery name="CPresupuestoComprometidasNAPs" datasource="#session.DSN#">
            delete from CPresupuestoComprometidasNAPs
            where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
            and CPcuenta   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelectCPcuenta.CPcuenta#">
        </cfquery>
    <cfelse>
		<cfif isdefined("Form.CPCCid")>
            <cftransaction>
            <cfquery name="rsSelectCtas" datasource="#session.DSN#">
                select CPcuenta, CPCCmascara from CPresupuestoComprAut
                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                        and CPCCid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPCCid#">
            </cfquery>
            <cfset Form.CPCCmascara = #rsSelectCtas.CPCCmascara#>
            <cfset Form.CPformato 	= #rsSelectCtas.CPCCmascara#>
            <cfset BorraCta = False>
            <!---Verifica que no se hayan aplicado compromisos con fecha anterior al cierre--->
            <cfquery name="rsSelectCPtipoCtas" datasource="#session.DSN#">
                select *
                from dbo.CPNAPdetalle cd
                where cd.CPPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
                and cd.CPNAPDtipoMov = 'CC'
                and (cd.CPCano*100+cd.CPCmes) < #vs_aniomesLinea#
            </cfquery>
            <cfif rsSelectCPtipoCtas.RecordCount gt 0>
                <cfquery name="rsInsertError" datasource="#Session.DSN#">
                    insert MensAplCompromiso (Ecodigo, Linea, Mensaje)
                    values(<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
                        (select count(*) from MensAplCompromiso) +1,
                        '#LB_ExistenCambiosApl#')
                </cfquery>
                <cfset BorraCta = False>
                <cfset Msg_Err = "#LB_ExistenCambiosApl#">
            <cfelse>
            <!---Verifica que tenga aplicado todos los compromisos --->
                <cfquery name="rsCuentas" datasource="#Session.DSN#">
                    select count(*) as CuentasNA
                    from CPresupuestoComprAut a
                    where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                        and a.CPCCid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPCCid#">
                        and a.CPcambioAplicado = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                </cfquery>
                <cfif rsCuentas.CuentasNA gt 0>
                    <cfquery name="rsInsertError" datasource="#Session.DSN#">
                        insert MensAplCompromiso (Ecodigo, Linea, Mensaje)
                        values(<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
                            (select count(*) from MensAplCompromiso) +1,
                            '#LB_ExistenCambiosNoApl#')
                    </cfquery>
                    <cfset BorraCta = False>
                    <cfset Msg_Err = "#LB_ExistenCambiosNoApl#">
                <cfelse>
                    <cfset BorraCta = True>
                </cfif>
            </cfif>

            <cfif BorraCta>
                <cfset statusDesc = Descompromiso(Form.CPCCid,vs_aniomesLinea)>
                <cfif statusDesc>
                    <cfquery name="CPresupuestoComprAut" datasource="#session.DSN#">
                        delete CPresupuestoComprAutD
                        where CPCCid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPCCid#">
                    </cfquery>
                    <cfquery name="rsDeleteCPtipoCtas" datasource="#session.DSN#">
                        delete CPresupuestoComprAut
                        where Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
                        and CPCCid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPCCid#">
                    </cfquery>
                    <cfquery name="CPresupuestoComprometidasNAPs" datasource="#session.DSN#">
                        delete CPresupuestoComprometidasNAPs
                        where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
                        and CPcuenta   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelectCtas.CPcuenta#">
                    </cfquery>
                <cfelse>
                    <cfset BorraCta = False>
                    <cfquery name="rsInsertError" datasource="#Session.DSN#">
                        insert MensAplCompromiso (Ecodigo, Linea, Mensaje)
                        values(<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
                            (select count(*) from MensAplCompromiso) +1,
                            '#LB_NoEncontrolaCuenta#')
                    </cfquery>
                    <cfset Msg_Err = "#LB_NoEncontrolaCuenta#">
                </cfif>
            </cfif>
            </cftransaction>
        </cfif>
    </cfif>
<cfelseif isdefined("Form.btnGuardarD") and len(trim(Form.btnGuardarD)) gt 0>
	<cfloop collection="#Form#" item="elem">
		<cfif FindNoCase('CPDDmonto_', elem) EQ 1 and Len(Trim(Form[elem])) and Form[elem] NEQ 0>
            <cfset CPDDid = Mid(elem, Len('CPDDmonto_')+1, Len(elem))>
            <cfquery name="rsMonto" datasource="#session.DSN#">
            	select CPComprMod, CPComp_Anterior from CPresupuestoComprAutD
                where CPCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPDDid#">
            </cfquery>

            <cfif rsMonto.CPComprMod neq Form[elem]>
				<cfquery name="rsUpdates" datasource="#session.DSN#">
                    update CPresupuestoComprAutD
                    set CPComprOri = <cfqueryparam cfsqltype="cf_sql_money" value="#LSParseNumber(Form[elem])#">
                    where CPComprOri = 0 and CPCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPDDid#">
                </cfquery>
                <cfquery name="rsUpdates" datasource="#session.DSN#">
                    update CPresupuestoComprAutD
                    set CPComprMod = <cfqueryparam cfsqltype="cf_sql_money" value="#LSParseNumber(Form[elem])#">
                    where CPCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPDDid#">
                </cfquery>
				<cfquery name="rsUpdatestatus" datasource="#session.DSN#">
	                update CPresupuestoComprAut
	                set CPcambioAplicado = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
	                where CPCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPCCid#">
	            </cfquery>
	         </cfif>
     	</cfif>
    </cfloop>
	<cfoutput>
    <form action="CPCompromisoAutD.cfm" method="post" name="sql">
        <input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
        <input type="hidden" name="CPCCid" 	value="#Form.CPCCid#">
        <input type="hidden" name="Periodo" 	value="#Form.Periodo#">
        <input type="hidden" name="CPCCmascara" value="#Form.CPCCmascara#">
    </form>
    </cfoutput>
</cfif>

<cfoutput>
<form action="CPCompromisoAut.cfm" method="post" name="sql">
    <input name="modo"	 type="hidden" 	value="<cfif isdefined("modo")>#modo#</cfif>">
    <input type="hidden" name="Msg_Err" value="#Msg_Err#">
    <cfif isdefined("Form.CPformato")>
    	<input type="hidden" name="CPCCmascara" value="#Form.CPformato#">
    </cfif>
    <cfif isdefined("Form.btnFiltrar")>
		<input name="CPcuenta" type="hidden" value="<cfif isdefined("form.CPcuenta")>#form.CPcuenta#</cfif>">
		<input name="CPPid" type="hidden" value="<cfif isdefined("form.CPPid")>#form.CPPid#</cfif>">
		<input name="CPFiltro" type="hidden" value="<cfif isdefined("form.CPFiltro")>#form.CPFiltro#</cfif>">
	</cfif>
</form>
</cfoutput>

<cffunction name="Descompromiso" output="yes" returntype="boolean">
    <cfargument name="CPCCid" 		type="numeric" 	required="yes">
    <cfargument name='AnoMesCierre' type='numeric' 	required='true'>

<cfquery name="rsSQL" datasource="#session.dsn#">
	select 	p.CPPid, v.CVtipo, p.CPPfechaDesde, p.CPPfechaHasta
	from CVersion v
			INNER JOIN CPresupuestoPeriodo p
				ON p.CPPid = v.CPPid
	where p.Ecodigo = #session.Ecodigo#
            and p.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
</cfquery>

<cfset LvarFechaIni = rsSQL.CPPfechaDesde>

<cfset LvarFecha	= LvarFechaIni>
<cfset LvarAno		= datepart("yyyy",LvarFechaIni)>
<cfset LvarMes		= datepart("m",LvarFechaIni)>
<cfset LvarAprobacion = rsSQL.CVtipo EQ "1"> <!---Tipo de presupuesto 1Ord, 2Extraord--->

<!---<cftry>--->
	<cfquery name="rsOficina" datasource="#Session.DSN#">
        select Ocodigo,Odescripcion,Oficodigo from Oficinas a
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    </cfquery>

    <cfquery name="qry_monedaEmpresa" datasource="#session.dsn#">
        select Mcodigo
          from Empresas
         where Ecodigo = #session.Ecodigo#
    </cfquery>

    <cfquery name="rsSQL" datasource="#session.dsn#">
        select count(*) as ultimo
          from CPNAP
         where Ecodigo 				= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
           and EcodigoOri		 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
           and CPNAPmoduloOri 		= 'PRFO'
           and left(CPNAPdocumentoOri,2)	= 'CC'
    </cfquery>
    <cfif rsSQL.ultimo EQ "">
        <cfset LvarDocumentoAprobo = 1>
    <cfelse>
        <cfset LvarDocumentoAprobo = rsSQL.ultimo + 1>
    </cfif>
	<cfset LvarDocumentoAprobo = "CC-"&#LvarDocumentoAprobo#>

<!---<cf_dump var ="LvarDocumentoAprobo = #LvarDocumentoAprobo#">
--->
    <cfquery name="rsLineas" datasource="#Session.DSN#">
        select  a.CPPid,a.Cmayor, a.CPCCmascara,a.CPcuenta, d.CPperiodo,d.CPmes,d.CPComprMod
            from CPresupuestoComprAut a
            inner join CPresupuestoComprAutD d
            on a.CPCCid=d.CPCCid
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            and a.CPCCid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPCCid#">
            and (d.CPperiodo*100+d.CPmes) > <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AnoMesCierre#">
    </cfquery>


	<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
    <cfset LobjControl.CreaTablaIntPresupuesto(#session.dsn#,true,true,true)>
  	<cfoutput>
    <cfloop query="rsLineas">
		<cfset vs_aniomesLinea = #rsLineas.CPperiodo# * 100 + #rsLineas.CPmes#>

        <cfquery name="rstipoCuenta" datasource="#Session.DSN#">
            select CPcuenta,CPCPtipoControl,
            CPCPcalculoControl
              from CPCuentaPeriodo
             where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
           and CPPid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineas.CPPid#">
           and CPcuenta = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineas.CPcuenta#">
        </cfquery>

        <cfquery name="rsPresControl" datasource="#Session.DSN#">
            select	CPcuenta, CPCcomprometido
              from CPresupuestoControl
             where Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
               and CPPid 	= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineas.CPPid#">
               and CPcuenta = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineas.CPcuenta#">
               and CPCano 	= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineas.CPperiodo#">
               and CPCmes 	= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineas.CPmes#">
               and Ocodigo  = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsOficina.Ocodigo#">
        </cfquery>

        <cfif rsPresControl.recordCount gt 0>
<!---        	<cfif rsPresControl.CPCcomprometido le rsLineas.CPComprMod>
        		<cfset MontoDesc = 0 - #rsPresControl.CPCcomprometido# >
        	<cfelse>
        		<cfset MontoDesc = 0 - #rsLineas.CPComprMod#>
        	</cfif>
--->
            <cfquery name="rsSQLCNAP" datasource="#Session.DSN#">
                select  top(1) CPNAPnum, CPNAPDlinea,0-CPNAPDmonto as NAPMonto, CPNAPDmonto
                from CPNAPdetalle
                 where Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                   and CPPid 	= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineas.CPPid#">
                   and CPcuenta = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineas.CPcuenta#">
                   and CPCano 	= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineas.CPperiodo#">
                   and CPCmes 	= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineas.CPmes#">
                   and CPNAPDtipoMov = 'CC'
                   order by CPNAPnum desc, CPNAPDlinea desc
            </cfquery>
            <cfif rsSQLCNAP.recordCount neq 0>
           <!--- <cf_dump var ="rsSQLCNAP = #rsSQLCNAP.recordCount#">--->

<!---			<cfdump var ="varNAPMonto = #varNAPMonto#">
            <cfdump var ="varCPNAPDmonto = #varCPNAPDmonto#">
            <cfdump var ="LvarLINreferencia = #rsSQLCNAP.CPNAPDlinea#">
            <cf_dump  var ="LvarNAPreferencia = #rsSQLCNAP.CPNAPnum#">

--->
			<!--- Reverso Todo el NAP --->
                <cfquery name="rsInsertintPresupuesto" datasource="#session.dsn#">
                    insert into #request.intPresupuesto#
                        (
                            ModuloOrigen,
                            NumeroDocumento,
                            NumeroReferencia,
                            FechaDocumento,
                            AnoDocumento,
                            MesDocumento,
                            NAPreversado,
                            CPPid,
                            CPCano, CPCmes, CPCanoMes,
                            CPcuenta, Ocodigo,
                            CuentaPresupuesto, CodigoOficina,
                            TipoControl, CalculoControl, SignoMovimiento,
                            TipoMovimiento,
                            Mcodigo, MontoOrigen,
                            TipoCambio, Monto, NAPreferencia,LINreferencia
                        )
                    values ('PRFO', '#LvarDocumentoAprobo#', 'MODIFICACION',
                            <cf_dbfunction name="now">,
                            <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineas.CPperiodo#">,
                            <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineas.CPmes#">,
                            #rsSQLCNAP.CPNAPnum#,
                            <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineas.CPPid#">,
                            #rsLineas.CPperiodo#, #rsLineas.CPmes#, #vs_aniomesLinea#,
                            <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineas.CPcuenta#">,
                            <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsOficina.Ocodigo#">,
                            '#rsLineas.CPCCmascara#',
                            '#rsOficina.Oficodigo#',
                            #rstipoCuenta.CPCPtipoControl#,
                            #rstipoCuenta.CPCPcalculoControl#, +1,
                            'CC',
                            #qry_monedaEmpresa.Mcodigo#,
                            #rsSQLCNAP.NAPMonto#,
                            1,
                            #rsSQLCNAP.NAPMonto#, #rsSQLCNAP.CPNAPnum#,#rsSQLCNAP.CPNAPDlinea#)
                </cfquery>

<!---			<cfdump var ="varNAPMonto = #rsSQLCNAP.NAPMonto#">
            <cfdump var ="varCPNAPDmonto = #rsSQLCNAP.CPNAPDmonto#">
            <cfdump var ="LvarLINreferencia = #rsSQLCNAP.CPNAPDlinea#">
            <cf_dump var ="LvarNAPreferencia = #rsSQLCNAP.CPNAPnum#">
--->
			<!---Comprometo lo que queda si el monto del NAP es mayor al monto del compromiso de la pantalla--->
				<cfset MontoDesc = #rsSQLCNAP.CPNAPDmonto# - #rsLineas.CPComprMod# >
                <cfif MontoDesc gt 0>
                    <cfset LvarLINreferencia = "NULL">
                    <cfset LvarNAPreferencia = "NULL">

                    <cfquery name="rsInsertintPresupuesto" datasource="#session.dsn#">
                        insert into #request.intPresupuesto#
                            (
                                ModuloOrigen,
                                NumeroDocumento,
                                NumeroReferencia,
                                FechaDocumento,
                                AnoDocumento,
                                MesDocumento,
                                CPPid,
                                CPCano, CPCmes, CPCanoMes,
                                CPcuenta, Ocodigo,
                                CuentaPresupuesto, CodigoOficina,
                                TipoControl, CalculoControl, SignoMovimiento,
                                TipoMovimiento,
                                Mcodigo, 	MontoOrigen,
                                TipoCambio, Monto, NAPreferencia,LINreferencia
                            )
                        values ('PRFO', '#LvarDocumentoAprobo#', 'MODIFICACION',
                                <cf_dbfunction name="now">,
                                <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineas.CPperiodo#">,
                                <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineas.CPmes#">,
                                <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineas.CPPid#">,
                                #rsLineas.CPperiodo#, #rsLineas.CPmes#, #vs_aniomesLinea#,
                                <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineas.CPcuenta#">,
                                <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsOficina.Ocodigo#">,
                                '#rsLineas.CPCCmascara#',
                                '#rsOficina.Oficodigo#',
                                #rstipoCuenta.CPCPtipoControl#,
                                #rstipoCuenta.CPCPcalculoControl#, +1,
                                'CC',
                                #qry_monedaEmpresa.Mcodigo#,
                                #MontoDesc#,
                                1,
                                #MontoDesc#, #LvarNAPreferencia#,#LvarLINreferencia#)
                    </cfquery>
                </cfif>
            </cfif>
        <cfelse>
            <cfreturn "False">
        </cfif>
	</cfloop>
    </cfoutput>
    <!---<cf_dump var="FIN">--->
<!---    <cfquery name="rsA" datasource="#session.dsn#">
    	select * from #request.intPresupuesto#
    </cfquery>
    <cf_dump var="#rsA#">--->

	<cfset LvarNAP = LobjControl.ControlPresupuestario("PRFO", LvarDocumentoAprobo, "MODIFICACION", LvarFecha, LvarAno, LvarMes)>
	<!---<cf_dump var="LvarNAP  #LvarNAP#">--->

	<cfif LvarNAP LT 0>
    	<cfreturn "False">
    <cfelse>
    	<cfreturn "True">
    </cfif>
<!---<cfcatch type="any">
    <cfreturn "False">
</cfcatch>
</cftry>
--->
<cfreturn "False">
</cffunction>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>