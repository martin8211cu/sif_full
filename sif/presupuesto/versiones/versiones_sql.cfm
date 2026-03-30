<cfsetting requesttimeout="36000">
<cfquery name="rsSQL" datasource="#session.dsn#">
	select Pvalor
	  from Parametros
	 where Ecodigo = #Session.Ecodigo#
	   and Pcodigo = 50
</cfquery>
<cfset LvarAuxAno = rsSQL.Pvalor>
<cfquery name="rsSQL" datasource="#session.dsn#">
	select Pvalor
	  from Parametros
	 where Ecodigo = #Session.Ecodigo#
	   and Pcodigo = 60
</cfquery>
<cfset LvarAuxMes = rsSQL.Pvalor>
<cfset LvarAuxAnoMes = LvarAuxAno*100+LvarAuxMes>

<cfif not isdefined("form.Nuevo")>
	<cfif isdefined("form.btnAgregarCta")>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select min(Ocodigo) as Ocodigo from Oficinas where Ecodigo=#session.Ecodigo#
		</cfquery>
		
		<cftransaction>
			<cfinvoke 
			 component="sif.Componentes.PC_GeneraCuentaFinanciera"
			 method="fnGeneraCuentaFinanciera"
			 returnvariable="LvarMSG">
				<cfinvokeargument name="Lprm_Cmayor" value="#form.Cmayor#"/>
				<cfinvokeargument name="Lprm_Cdetalle" value="#form.CPdetalle#"/>
				<cfinvokeargument name="Lprm_fecha" value="#now()#"/>
				<cfinvokeargument name="Lprm_Ocodigo" value="#rsSQL.Ocodigo#"/>
				<cfinvokeargument name="Lprm_Cdescripcion" value="#form.CPdescripcion#"/>
				<cfinvokeargument name="Lprm_EsDePresupuesto" value="true"/>
				<cfinvokeargument name="Lprm_CrearPresupuesto" value="true"/>
				<cfinvokeargument name="Lprm_CVid" value="#form.CVid#"/>
				<cfinvokeargument name="Lprm_debug" value="no"/>
				<cfinvokeargument name="Lprm_TransaccionActiva" value="yes"/>
				<cfinvokeargument name="Lprm_CVPtipoControl" value="#form.CVPtipoControl#"/>
				<cfinvokeargument name="Lprm_CVPcalculoControl" value="#form.CVPcalculoControl#"/>
			</cfinvoke>
			<cfset LvarMSG = replace(LvarMSG,'"',"'","ALL")>
			<cfset LvarMSG = replace(LvarMSG,chr(13)," ","ALL")>
			<cfset LvarMSG = replace(LvarMSG,chr(10)," ","ALL")>
			<cfif LvarMSG EQ "NEW">
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select CPformato
					  from CVPresupuesto b
					 where Ecodigo=#Session.Ecodigo#
					   and CVid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
					   and Cmayor=<cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#">
					   and CPformato = '#form.Cmayor#-#form.CPdetalle#'
						<cf_CPSegUsu_where Formulacion="true" aliasCuentas="b">
				</cfquery>
				<cfif rsSQL.recordCount EQ 0>
					<cfset LvarMSG="ERROR DE SEGURIDAD: el usuario no tiene autorización para la cuenta a agregar">
					<cftransaction action="rollback" />
				</cfif>		
			</cfif>		
		</cftransaction>
		<script language="javascript">
		<cfif LvarMSG EQ "NEW">
			alert("La cuenta se creó exitosamente en la Versión");
		<cfelseif LvarMSG EQ "OLD">
			alert("PRECAUCIÓN: La cuenta ya existe en la versión. No se creó ni se modificó");
			window.history.back();
		<cfelse>
			alert("ERROR: <cfoutput>#LvarMSG#</cfoutput>");
			window.history.back();
		</cfif>
		</script>
		<cfthread	name="CreacionCPresupuesto" 
					action="run" 
					priority="LOW" 
		> 
			<cfinvoke 
				component="sif.Componentes.PC_GeneraCuentaFinanciera"
				method="sbCreaCPresupuestoDeVersion"
				Lprm_CVid="#form.CVid#"
				Lprm_Verificar="true"
			/>
		</cfthread> 
		<cfif LvarMSG NEQ "NEW">
			<cfabort>
		</cfif>
	<cfelseif isdefined("form.btnModificaCta")>
		<cfquery name="update" datasource="#session.dsn#">
			update CVPresupuesto
			set CPdescripcion	    = <cf_jdbcQuery_param  cfsqltype="cf_sql_varchar" value="#form.CPdescripcion#" len="50">
				, CVPtipoControl    = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CVPtipoControl#">
                , CVPcalculoControl	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CVPcalculoControl#">
			where Ecodigo		= #Session.Ecodigo#
				and CVid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
				and CVPcuenta	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVPcuenta#">
		</cfquery>
        
		<cfquery name="update" datasource="#session.dsn#">
			update CVMayor
			set  CVMtipoControl    = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CVPtipoControl#">
                , CVMcalculoControl	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CVPcalculoControl#">
			where Ecodigo		= #Session.Ecodigo#
				and CVid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
				and Cmayor	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cmayor#">
		</cfquery>
	<cfelseif isdefined("form.Alta")>
		<cftransaction>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				insert into CVersion
				(Ecodigo, CVtipo, CVdescripcion, CPPid, CVestado, CVaprobada)
				values(#Session.Ecodigo#,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.CVtipo#">,
					<cf_jdbcQuery_param cfsqltype="cf_sql_varchar" value="#form.CVdescripcion#" len="50">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVestado#">,
					0)
				<cf_dbidentity1 datasource="#session.dsn#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.dsn#" name="rsSQL">
			<cfset LvarCVid = rsSQL.identity>
			<!--- Alta de las cuentas de Mayor para esta Versión --->
            <cfinclude template="../../Utiles/sifConcat.cfm">
			<cfquery datasource="#session.dsn#">
				insert into CVMayor
					(Ecodigo, 
					CVid, 
					Cmayor, 
					Ctipo, 
					CPVidOri, 
					PCEMidOri, 
					Cmascara,
					CVMtipoControl,
					CVMcalculoControl)
				select distinct
					a.Ecodigo, 
					#LvarCVid#, 
					a.Cmayor, 
					a.Ctipo, 
					b.CPVid as CPVidOri, 
					b.PCEMid as PCEMidOri, 
					d.PCEMformatoP as Cmascara,
					(case Ctipo when 'A' then 1 when 'G' then 1 else 0 end),
					2
				from CtasMayor a
					inner join CPVigencia b	<!--- Primera Vigencia del Inicio del Periodo o que empiece despues del Inicio --->
							inner join PCEMascaras d
							  on d.PCEMid = b.PCEMid
							 <cfif form.CVtipo EQ "2">
							 and coalesce(rtrim(d.PCEMformatoP) #_Cat# ' ',' ') <> ' '
							 </cfif>
						 ON b.Ecodigo = a.Ecodigo
						and b.Cmayor  = a.Cmayor
						
				where a.Ecodigo = #Session.Ecodigo#
                and b.CPVdesde =
							(select min(v.CPVdesde)
							   from CPVigencia v, CPresupuestoPeriodo p
							  where v.Ecodigo = a.Ecodigo
								and v.Cmayor  = a.Cmayor
							    and p.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
							    and (
										p.CPPfechaDesde between v.CPVdesde 		and v.CPVhasta
									OR 
										v.CPVdesde		between p.CPPfechaDesde and p.CPPfechaHasta
									)
							)
			</cfquery>

			<cfif form.TipoCarga EQ 1>
				<cfsetting requesttimeout="36000">
				<cfquery datasource="#session.dsn#">
					insert into CVPresupuesto
						 (Ecodigo,
						 CVid,
						 CVPcuenta,
						 Cmayor,
						 CPcuenta,
						 CPformato,
						 CPdescripcion,
						 CVPtipoControl,
						 CVPcalculoControl
						 )
					select 	a.Ecodigo, 
							#LvarCVid#, 
							a.CPcuenta,
							a.Cmayor, 
							a.CPcuenta, 
							a.CPformato,
							coalesce(a.CPdescripcionF, a.CPdescripcion),
							b.CPCPtipoControl, 
							b.CPCPcalculoControl
					  from CPresupuesto a
						inner join CPCuentaPeriodo b
							 ON b.Ecodigo 	= a.Ecodigo
							and b.CPPid  	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
							and b.CPcuenta	= a.CPcuenta
					 where a.Ecodigo = #Session.Ecodigo#
					   and exists
					   		(
								select 1
								  from CPControlMoneda c
								 where c.Ecodigo 	= a.Ecodigo
								   and c.CPPid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
								   and c.CPCano*100+c.CPCmes>=#LvarAuxAnoMes#
								   and c.CPcuenta	= a.CPcuenta
							)
				</cfquery>
				<cfquery datasource="#session.dsn#">
					insert into CVFormulacionTotales
						 (
							Ecodigo,
							CVid,
							CPCano,
							CPCmes,
							CVPcuenta,
							Ocodigo,
							CVFTmontoSolicitado,
							CVFTmontoAplicar
						)
					select 	a.Ecodigo, 
							#LvarCVid#, 
							a.CPCano,
							a.CPCmes,
							a.CPcuenta,
							a.Ocodigo,
							sum((CPCMpresupuestado+CPCMmodificado)*CPCMtipoCambioAplicado),
							0
					  from CPControlMoneda a
					 where a.Ecodigo 	= #Session.Ecodigo#
					   and a.CPPid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
					   and a.CPCano*100+a.CPCmes >= #LvarAuxAnoMes#
					 group by a.Ecodigo, a.CPCano, a.CPCmes, a.CPcuenta, a.Ocodigo
				</cfquery>
				<cfquery datasource="#session.dsn#">
					insert into CVFormulacionMonedas
						 (
						     Ecodigo,
							 CVid,
							 CPCano,
							 CPCmes,
							 CVPcuenta,
							 Ocodigo,
							 Mcodigo,
							 CVFMtipoCambio,
							 CVFMmontoBase,
							 CVFMmontoAplicar
						)
					select 	a.Ecodigo, 
							#LvarCVid#, 
							a.CPCano,
							a.CPCmes,
							a.CPcuenta,
							a.Ocodigo,
							a.Mcodigo,
							CPCMtipoCambioAplicado,
							CPCMpresupuestado+CPCMmodificado,
							0
					  from CPControlMoneda a
					 where a.Ecodigo 	= #Session.Ecodigo#
					   and a.CPPid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
					   and a.CPCano*100+a.CPCmes >= #LvarAuxAnoMes#
				</cfquery>
			<cfelseif form.TipoCarga EQ 2>
			</cfif>
		</cftransaction>
	<cfelseif isdefined("form.btnRecargar")>
		<cfquery name="update_mayor" datasource="#session.dsn#">
			insert into CVMayor
				(Ecodigo, 
				CVid, 
				Cmayor, 
				Ctipo, 
				CPVidOri, 
				PCEMidOri, 
				Cmascara,
				CVMtipoControl,
				CVMcalculoControl)
			select  a.Ecodigo, 
				#form.CVid# as CVid, 
				a.Cmayor, 
				a.Ctipo, 
				b.CPVid as CPVidOri, 
				b.PCEMid as PCEMidOri, 
				d.PCEMformatoP as Cmascara,
				(case Ctipo when 'A' then 1 when 'G' then 1 else 0 end),
				2
			from CtasMayor a
				left outer join (CPVigencia b
					inner join CPresupuestoPeriodo c
					on c.Ecodigo = b.Ecodigo
							 and c.CPPid = #form.CPPid#
								and (c.CPPfechaDesde between b.CPVdesde and b.CPVhasta
									OR c.CPPfechaHasta between b.CPVdesde and b.CPVhasta
								)
					)
					on b.Ecodigo = a.Ecodigo
					and b.Cmayor = a.Cmayor
				left outer join PCEMascaras d
				 on d.PCEMid = b.PCEMid
			where a.Ecodigo = #Session.Ecodigo#
			and a.Cmayor not in (select Cmayor from CVMayor 
									where CVid = #form.CVid#
										and Ecodigo = #Session.Ecodigo#
								)
		</cfquery>
		<!--- (index PK_CVMAYOR) --->
	<cfelseif isdefined("form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
			table="CVersion"
			redirect="versionesComun.cfm"
			timestamp="#form.ts_rversion#"
			field1="CVid" 
			type1="numeric" 
			value1="#form.CVid#"
			field2="Ecodigo" 
			type2="numeric" 
			value2="#session.Ecodigo#"
			>
		<cfquery name="update" datasource="#session.dsn#">
			update CVersion
			set CVdescripcion=<cf_jdbcQuery_param  cfsqltype="cf_sql_varchar" value="#form.CVdescripcion#" len="50">
				, CVestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CVestado#">
			where Ecodigo = #Session.Ecodigo#
				and CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
		</cfquery>
	<cfelseif isdefined("form.Baja")>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select CVaprobada
			from CVersion
			where Ecodigo = #Session.Ecodigo#
				and CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
		</cfquery>
		<cfif rsSQL.CVaprobada NEQ '0'>
			<cf_errorCode	code = "50555" msg = "La versión no puede ser eliminada porque ya está Aplicada!">
		</cfif>
		<cftransaction>
			<cfquery datasource="#session.dsn#">
				delete from CVFormulacionMonedas
				where Ecodigo = #Session.Ecodigo#
					and CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
			</cfquery>
			<cfquery datasource="#session.dsn#">
				delete from CVFormulacionTotales
				where Ecodigo = #Session.Ecodigo#
					and CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
			</cfquery>
			<cfquery datasource="#session.dsn#">
				delete from CVPresupuesto
				where Ecodigo = #Session.Ecodigo#
					and CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
			</cfquery>
			<cfquery datasource="#session.dsn#">
				delete from CVMayor
				where Ecodigo = #Session.Ecodigo#
					and CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
			</cfquery>
			<cfquery datasource="#session.dsn#">
				delete from CVersion
				where Ecodigo = #Session.Ecodigo#
					and CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
			</cfquery>
		</cftransaction>
	<cfelseif isdefined("form.CambioDet") and isdefined("form.PCEMidNueva")>
		<cf_dbtimestamp datasource="#session.dsn#"
			table="CVMayor"
			redirect="versionesComun.cfm"
			timestamp="#form.ts_rversiondet#"
			field1="CVid" 
			type1="numeric" 
			value1="#form.CVid#"
			field2="Cmayor" 
			type2="char" 
			value2="#form.Cmayor#"
			field3="Ecodigo" 
			type3="numeric" 
			value3="#session.Ecodigo#"
			>
		
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select CVtipo
			  from CVersion
			 where Ecodigo 	= #Session.Ecodigo#
			   and CVid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
		</cfquery>

		<!--- SOLO PERMITE CAMBIAR LA MASCARA Y VIGENCIA CUANDO ES APROBACION DE Presupuesto Ordinario --->
		<cfif rsSQL.CVtipo EQ 1>
			<cfquery name="update" datasource="#session.dsn#">
				update CVMayor
				set CVMtipoControl		= <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.CVMtipoControl#">
					,CVMcalculoControl	= <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.CVMcalculoControl#">
					,PCEMidNueva		= <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.PCEMidNueva#" null="#form.PCEMidOri eq form.PCEMidNueva#">
					,Cmascara			= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#form.Cmascara#">
				where Ecodigo = #Session.Ecodigo#
				  and CVid    = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CVid#">
				  and Cmayor  = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#form.Cmayor#">
			</cfquery>
		<cfelse>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select distinct 
					#rsSQL.CVtipo# as CVtipo,
					b.CPVid as CPVidOri, 
					b.PCEMid as PCEMidOri, 
					d.PCEMformatoP as Cmascara
				from CtasMayor a
					left outer join CPVigencia b	<!--- Primera Vigencia del Inicio del Periodo o que empiece despues del Inicio --->
						 ON b.Ecodigo = a.Ecodigo
						and b.Cmayor  = a.Cmayor
					left outer join PCEMascaras d
					 on d.PCEMid = b.PCEMid
				where a.Ecodigo = #Session.Ecodigo#
				  and a.Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#">
                  and b.CPVdesde =			
							(select min(v.CPVdesde)
							   from CPVigencia v, CPresupuestoPeriodo p
							  where v.Ecodigo = a.Ecodigo
								and v.Cmayor  = a.Cmayor
							    and p.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
							    and (
										p.CPPfechaDesde between v.CPVdesde and v.CPVhasta
									OR 
										p.CPPfechaDesde < v.CPVdesde
									)
							)
			</cfquery>
			<cfquery name="update" datasource="#session.dsn#">
				update CVMayor
				set CVMtipoControl=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CVMtipoControl#">
					,CVMcalculoControl=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CVMcalculoControl#">
					,CPVidOri=#rsSQL.CPVidOri#
					,PCEMidOri=#rsSQL.PCEMidOri#
					,PCEMidNueva=null
					,Cmascara=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSQL.Cmascara#">
				where Ecodigo	= #Session.Ecodigo#
				  and CVid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
				  and Cmayor 	= <cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#">
			</cfquery>
		</cfif>
        <cfset CambioMayor = ''>
	<cfelseif isdefined("form.MayorDefault")>
		<cf_dbtimestamp datasource="#session.dsn#"
			table="CVMayor"
			redirect="versionesComun.cfm"
			timestamp="#form.ts_rversiondet#"
			field1="CVid" 
			type1="numeric" 
			value1="#form.CVid#"
			field2="Cmayor" 
			type2="char" 
			value2="#form.Cmayor#"
			field3="Ecodigo" 
			type3="numeric" 
			value3="#session.Ecodigo#"
		>
		
		<cfquery name="update" datasource="#session.dsn#">
			update CVMayor
			set CVMtipoControl=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CVMtipoControl#">
				,CVMcalculoControl=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CVMcalculoControl#">
			where Ecodigo = #Session.Ecodigo#
				and CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
				and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#">
		</cfquery>
        <cfset CambioMayor = ''>
	<cfelseif isdefined("form.MayorMasiva")>
		<cfquery name="update" datasource="#session.dsn#">
			update CVPresupuesto
			set CVPtipoControl=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CVMtipoControl#">
				,CVPcalculoControl=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CVMcalculoControl#">
			where Ecodigo = #Session.Ecodigo#
			  and CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
			  and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#">
		</cfquery>
        <cfset CambioMayor = ''>
	<cfelseif isdefined("form.MayorMascara")>
		<cf_dbtimestamp datasource="#session.dsn#"
			table="CVMayor"
			redirect="versionesComun.cfm"
			timestamp="#form.ts_rversiondet#"
			field1="CVid" 
			type1="numeric" 
			value1="#form.CVid#"
			field2="Cmayor" 
			type2="char" 
			value2="#form.Cmayor#"
			field3="Ecodigo" 
			type3="numeric" 
			value3="#session.Ecodigo#"
			>
		
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select CVtipo
			  from CVersion
			 where Ecodigo 	= #Session.Ecodigo#
			   and CVid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
		</cfquery>

		<!--- SOLO PERMITE CAMBIAR LA MASCARA Y VIGENCIA CUANDO ES APROBACION DE Presupuesto Ordinario --->
		<cfif rsSQL.CVtipo EQ 1>
			<cfquery name="update" datasource="#session.dsn#">
				update CVMayor
				set PCEMidNueva = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEMidNueva#" null="#form.PCEMidOri eq form.PCEMidNueva#">
				   ,Cmascara    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cmascara#">
				where Ecodigo   = #Session.Ecodigo#
					and CVid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
					and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#">
			</cfquery>
		<cfelse>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select distinct 
					#rsSQL.CVtipo# as CVtipo,
					b.CPVid as CPVidOri, 
					b.PCEMid as PCEMidOri, 
					d.PCEMformatoP as Cmascara
				from CtasMayor a
					left outer join CPVigencia b	<!--- Primera Vigencia del Inicio del Periodo o que empiece despues del Inicio --->
						 ON b.Ecodigo = a.Ecodigo
						and b.Cmayor  = a.Cmayor
					left outer join PCEMascaras d
					 on d.PCEMid = b.PCEMid
				where a.Ecodigo = #Session.Ecodigo#
				  and a.Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#">
                  and b.CPVdesde =			
							(select min(v.CPVdesde)
							   from CPVigencia v, CPresupuestoPeriodo p
							  where v.Ecodigo = a.Ecodigo
								and v.Cmayor  = a.Cmayor
							    and p.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
							    and (
										p.CPPfechaDesde between v.CPVdesde and v.CPVhasta
									OR 
										p.CPPfechaDesde < v.CPVdesde
									)
							)
			</cfquery>
			<cfquery name="update" datasource="#session.dsn#">
				update CVMayor
				set 
					 CPVidOri=#rsSQL.CPVidOri#
					,PCEMidOri=#rsSQL.PCEMidOri#
					,PCEMidNueva=null
					,Cmascara=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSQL.Cmascara#">
				where Ecodigo	= #Session.Ecodigo#
				  and CVid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
				  and Cmayor 	= <cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#">
			</cfquery>
		</cfif>
        <cfset CambioMayor = ''>
	<cfelseif isdefined("form.AltaMoneda") or isdefined("form.CambioMoneda") or isdefined("form.BajaMoneda") or isdefined("form.NuevoMoneda")>
		<cfset LvarFormMonedas = true>
		<cfif isdefined("form.AltaMoneda")>
			<!--- Inserta CVFormulacionTotales si no existen --->
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select 1 from CVFormulacionTotales
				where Ecodigo = #Session.Ecodigo#
					and CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
					and CVPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVPcuenta#">
					and CPCano = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPCano#">
					and CPCmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPCmes#">
					and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
			</cfquery>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				insert into CVFormulacionTotales
				(Ecodigo,CVid,CVPcuenta,CPCano,CPCmes,Ocodigo,CVFTmontoSolicitado)
				select distinct 
						#session.Ecodigo#, #form.CVid#, #form.CVPcuenta#, 
						m.CPCano, m.CPCmes, 
						#form.Ocodigo#,
						0
				  from CVersion v
						inner join CPmeses m
							on m.Ecodigo   = v.Ecodigo
						   and m.CPPid 	   = v.CPPid
				 where v.Ecodigo = #session.Ecodigo#
				   and v.CVid 	 = #form.CVid#
				   and not exists 
						(
							select 1
							  from CVFormulacionTotales
							 where Ecodigo 	= #session.Ecodigo#
							   and CVid 	= #form.CVid#
							   and CPCano	= m.CPCano
							   and CPCmes	= m.CPCmes
							   and CVPcuenta = #form.CVPcuenta#
							   and Ocodigo	= #form.Ocodigo#
						)
			</cfquery>			
			<cfquery name="insert_moneda" datasource="#session.dsn#">
				insert into CVFormulacionMonedas
				(Ecodigo,CVid,CVPcuenta,CPCano,CPCmes,Ocodigo,Mcodigo,CVFMmontoBase,CVFMtipoCambio)
				select distinct 
						#session.Ecodigo#, #form.CVid#, #form.CVPcuenta#, 
						m.CPCano, m.CPCmes, 
						#form.Ocodigo#,
						#form.Mcodigo#,
						0,0
				  from CVersion v
						inner join CPmeses m
							on m.Ecodigo   = v.Ecodigo
						   and m.CPPid 	   = v.CPPid
				 where v.Ecodigo = #session.Ecodigo#
				   and v.CVid 	 = #form.CVid#
				   and not exists 
						(
							select 1
							  from CVFormulacionMonedas
							 where Ecodigo 	= #session.Ecodigo#
							   and CVid 	= #form.CVid#
							   and CPCano	= m.CPCano
							   and CPCmes	= m.CPCmes
							   and CVPcuenta = #form.CVPcuenta#
							   and Ocodigo	= #form.Ocodigo#
							   and Mcodigo	= #form.Mcodigo#
						)
			</cfquery>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				update CVFormulacionMonedas
				   set CVFMmontoBase 	= <cfqueryparam cfsqltype="cf_sql_money" 	 value="#form.CVFMmontoBase#">
				   	,  CVFMajusteUsuario= <cfqueryparam cfsqltype="cf_sql_money" 	 value="#form.CVFMajusteUsuario#">
				   	,  CVFMajusteFinal 	= <cfqueryparam cfsqltype="cf_sql_money" 	 value="#form.CVFMajusteFinal#">
				where Ecodigo = #Session.Ecodigo#
					and CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
					and CVPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVPcuenta#">
					and CPCano = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPCano#">
					and CPCmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPCmes#">
					and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
					and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
			</cfquery>
		<cfelseif isdefined("form.CambioMoneda")>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				update CVFormulacionMonedas
				   set CVFMmontoBase 	= <cfqueryparam cfsqltype="cf_sql_money" 	 value="#form.CVFMmontoBase#">
				   	,  CVFMajusteUsuario= <cfqueryparam cfsqltype="cf_sql_money" 	 value="#form.CVFMajusteUsuario#">
				   	,  CVFMajusteFinal 	= <cfqueryparam cfsqltype="cf_sql_money" 	 value="#form.CVFMajusteFinal#">
				where Ecodigo = #Session.Ecodigo#
					and CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
					and CVPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVPcuenta#">
					and CPCano = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPCano#">
					and CPCmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPCmes#">
					and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
					and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
			</cfquery>
		<cfelseif isdefined("form.BajaMoneda")>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				delete from CVFormulacionMonedas
				where Ecodigo = #Session.Ecodigo#
					and CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
					and CVPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVPcuenta#">
					and CPCano = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPCano#">
					and CPCmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPCmes#">
					and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
					and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
			</cfquery>
		</cfif>

		<cfinvoke 
			component="sif.Componentes.PRES_Formulacion"
			method="AjustaFormulacion"
		>
			<cfinvokeargument name="CVid" value="#form.CVid#">
			<cfinvokeargument name="CVPcuenta" value="#form.CVPcuenta#">
			<cfinvokeargument name="Ocodigo" value="#form.Ocodigo#">
			<cfinvokeargument name="CPCano" value="#form.CPCano#">
			<cfinvokeargument name="CPCmes" value="#form.CPCmes#">
			<cfinvokeargument name="Mcodigo" value="#form.Mcodigo#">
		</cfinvoke>
	<cfelseif isdefined("btnMonedas")>
		<!--- Esta transacción debe insertar el registro de totales de formulación antes del monto solicitado por moneda, en caso de que no exista, 
			además debe actualizar este total al final de la transacción --->
		<cftransaction>
			<!--- Obtiene la Moneda de la Empresa --->
			<cfquery name="qry_monedaEmpresa" datasource="#session.dsn#">
				select Mcodigo
				from Empresas 
				where Ecodigo = #Session.Ecodigo#
			</cfquery>

			<!--- Obtiene los meses del Periodo --->
			<cfquery name="qry_meses" datasource="#session.dsn#">
				select 	m.CPCano, m.CPCmes 
				from CVersion v, CPmeses m
				where v.Ecodigo 	= #Session.Ecodigo#
				  and v.CVid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
				  and m.Ecodigo 	= v.Ecodigo
				  and m.CPPid 		= v.CPPid
			</cfquery>

			<cfloop query="qry_meses">
				<!--- Inserta CVFormulacionTotales si no existen --->
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select 1 from CVFormulacionTotales
					where Ecodigo = #Session.Ecodigo#
						and CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
						and CVPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVPcuenta#">
						and CPCano = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_meses.CPCano#">
						and CPCmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_meses.CPCmes#">
						and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
				</cfquery>
				<cfif rsSQL.RecordCount EQ 0>
					<cfquery name="rsSQL" datasource="#session.dsn#">
						insert into CVFormulacionTotales
						(Ecodigo,CVid,CVPcuenta,CPCano,CPCmes,Ocodigo,CVFTmontoSolicitado)
						values(
							#Session.Ecodigo#,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVPcuenta#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_meses.CPCano#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_meses.CPCmes#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">,
							0.00
						)				
					</cfquery>			
				</cfif>

				<!--- Actualiza CVFormulacionMonedas para solicitudes mayores que 0 --->
				<cfquery name="rsSQL" datasource="#session.dsn#">
					delete from CVFormulacionMonedas
					where Ecodigo = #Session.Ecodigo#
						and CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
						and CVPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVPcuenta#">
						and CPCano = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_meses.CPCano#">
						and CPCmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_meses.CPCmes#">
						and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
						and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
				</cfquery>

				<cfquery name="insert_moneda" datasource="#session.dsn#">
					insert into CVFormulacionMonedas
					(Ecodigo,CVid,CVPcuenta,CPCano,CPCmes,Ocodigo,Mcodigo,CVFMmontoBase,CVFMajusteUsuario,CVFMajusteFinal,CVFMtipoCambio)
					values(
						#Session.Ecodigo#,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVPcuenta#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_meses.CPCano#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_meses.CPCmes#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" scale="2"	 value="#evaluate('form.MontoM_#qry_meses.CPCano#_#qry_meses.CPCmes#')#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" scale="2"	 value="#evaluate('form.AjusteU_#qry_meses.CPCano#_#qry_meses.CPCmes#')#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" 	 value="#evaluate('form.AjusteF_#qry_meses.CPCano#_#qry_meses.CPCmes#')#">,
						0
					)
				</cfquery>
			</cfloop>
			<!--- Actualizar los totales de la formulación --->

			<cfinvoke 
				component="sif.Componentes.PRES_Formulacion"
				method="AjustaFormulacion"
			>
				<cfinvokeargument name="CVid" value="#form.CVid#">
				<cfinvokeargument name="CVPcuenta" value="#form.CVPcuenta#">
				<cfinvokeargument name="Ocodigo" value="#form.Ocodigo#">
			</cfinvoke>
		</cftransaction>
	</cfif>
</cfif>
<cfset params = ''>
<cfset action = 'versionesComun.cfm'>
<cfif isdefined("form.Nuevo")>
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'btnnuevo=' & form.Nuevo>
<cfelseif isdefined("form.Cambio") or isdefined("form.btnRecargar")>
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'CVid=' & form.CVid>
<cfelseif isdefined("form.Alta")>
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'CVid=' & LvarCVid>
<cfelseif isdefined("CambioMayor") or isdefined("form.ListoDet")>
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'CVid=' & form.CVid>
	<!--- <cfset params = params & iif(len(params),DE('&'),DE('?')) & 'Cmayor=' & form.Cmayor> --->
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'pagenum2=' & form.pagenum2>
<cfelseif isdefined("form.btnAgregarCta")>
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'CVid=' & form.CVid>
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'Cmayor=' & form.Cmayor>	
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'CPresup=1'>
<cfelseif isdefined("form.btnModificaCta")>
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'CVid=' & form.CVid>
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'Cmayor=' & form.Cmayor>
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'CPPid=' & form.CPPid>	
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'CVPcuenta=' & form.CVPcuenta>
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'pantallaNueva=20'>
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'CPresup=-100'>
<cfelseif isdefined("form.Regresar")>
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'CVid=' & form.CVid>
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'Cmayor=' & form.Cmayor>	
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'CPresup=1'>
<cfelseif isdefined("form.btnMonedas")>
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'CVid=' & form.CVid>
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'Cmayor=' & form.Cmayor>	
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'CVPcuenta=' & form.CVPcuenta>
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'Ocodigo=' & form.Ocodigo>
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'Mcodigo=' & form.Mcodigo>	
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'btnMonedas=yes'>	
<cfelseif isdefined("LvarFormMonedas")>
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'CVid=' & form.CVid>
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'Cmayor=' & form.Cmayor>	
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'CVPcuenta=' & form.CVPcuenta>
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'Ocodigo=' & form.Ocodigo>
<!--- 
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'Mcodigo=' & form.Mcodigo>	
 --->
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'CPCano=' & form.CPCano>	
	<cfset params = params & iif(len(params),DE('&'),DE('?')) & 'CPCmes=' & form.CPCmes>	
</cfif>

<cflocation url="#action##params#">


