<cfif isdefined("Form.Aplicar")>

	<cfset ArrayAccion = ArrayNew(1)>
		<!---Primera accion a anular--->
		<cfset StructAccion = StructNew()>
		<cfset StructAccion.RHSPEid = Form.RHSPEid>
		<cfset StructAccion.dias = Form.dias>
		<cfset StructAccion.diasD = Form.diasD>
		<cfset ArrayAppend(ArrayAccion, StructAccion)>
		
		<!---Se busca la accion de referenciada para anularla tambien--->
		<!---- este proceso se ejecuta siempre y cuando exista una accion de referencia a anular o suspender---->
		<cfquery name="rsIncapacidadSubsidio" datasource="#Session.DSN#">
			select dl.DLlineaRef as DLlinea, dl.DLfvigencia as RHSPEfdesde
			from DLaboralesEmpleado dl
			where dl.DLlinea =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHSPEid#">
			and dl.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
			and dl.DLlineaRef is not null
		</cfquery>
		
		<!---- si existe una accion de referencia se debe anular tambien los saldos por lo que se agrega al array de acciones a anular---->
		<cfif rsIncapacidadSubsidio.recordcount and len(trim(rsIncapacidadSubsidio.DLlinea))>
			<!---Segunda accion a anular--->
			<cfset StructAccion = StructNew()>
			<cfset StructAccion.RHSPEid = rsIncapacidadSubsidio.DLlinea>
			<cfset ArrayAppend(ArrayAccion, StructAccion)>
		</cfif>

	<cfquery name="rsTipoAccionAnulacion" datasource="#Session.DSN#">
		select min(RHTid) as RHTid
		from RHTipoAccion
		where Ecodigo = #Session.Ecodigo#
		and RHTcomportam = 7
	</cfquery>
	
	<cfif Len(Trim(rsTipoAccionAnulacion.RHTid)) EQ 0>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="MSG_Debe_incluir_un_tipo_de_accion_de_tipo_anulacion_antes_de_proceder_a_realizar_una_anulacion_de_accion"
			Default="Debe incluir un tipo de acci&oacute;n de tipo anulaci&oacute;n antes de proceder a realizar una anulaci&oacute;n de acci&oacute;n"
			xmlfile="/rh/nomina/anulacion/AnulaAcciones.xml"
			returnvariable="vMensaje" />
		<cfset regresar = "/cfmx/rh/nomina/anulacion/AnulaAcciones.cfm">
		<cfset msg = "#vMensaje#.">
		<cf_throw message="#msg#" errorCode="1010">
		<cfabort>
	</cfif>

	<cftransaction>
	<!--- Se Realiza este ciclo para el caso de las acciones de Incapacidad que utilizan acciones vinculadas para pagar subsidio ---->
	
	<cfloop from="1" to="#ArrayLen(ArrayAccion)#" index="i">
		<cfset Form.RHSPEid = ArrayAccion[i].RHSPEid>

	<cfif isdefined("Form.modificaLT") and Form.modificaLT EQ 1><!--- en el caso que modifique linea de tiempo--->
	<cfquery name="rsID" datasource="#Session.DSN#">
		select distinct DLlinea, RHCSdesde as RHSPEfdesde
		from RHControlSaldos
			where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHSPEid#">
			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	</cfquery>
	<cfelse><!--- Procedimiento Normal --->
	<cfquery name="rsID" datasource="#Session.DSN#">
		select DLlinea, RHSPEfdesde
		from RHSaldoPagosExceso
			where RHSPEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHSPEid#">
			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	</cfquery>
    </cfif>
	
	<!--- Caso en que no hay datos para en rsID por que es una accion que no afecto RHSaldoPagosExceso, y RHControlSaldos (acciones de incapacidad dobles)--->
	<cfif rsID.RecordCount EQ 0>
		<cfquery name="rsID" datasource="#Session.DSN#">
			select DLlinea, DLfvigencia as RHSPEfdesde
			from DLaboralesEmpleado
				where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHSPEid#">
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		</cfquery>
	</cfif>
	
	<cfif isdefined("Form.rdAnulacion") and Form.rdAnulacion EQ 1>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="LB_SUSPENSION_DE"
			Default="SUSPENSION DE"
			xmlfile="/rh/nomina/anulacion/AnulaAcciones.xml"
			returnvariable="vMensaje" />

		<cfset observ = "#vMensaje#: ">
		<cfset fecha = Form.FNuevohasta>
	<cfelse>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="LB_ANULACION_DE"
			Default="ANULACION DE"
			xmlfile="/rh/nomina/anulacion/AnulaAcciones.xml"
			returnvariable="vMensaje" />

		<cfset observ = "#vMensaje#: ">
		<cfset fecha = LSDateFormat(rsID.RHSPEfdesde,'dd/mm/yyyy')>
	</cfif>
	
	
			<!--- Grabar en DLaboralesEmpleado --->
			<cfquery name="rsDLE" datasource="#Session.DSN#">
				select a.DLconsecutivo, a.DEid, a.Ecodigo, a.RHPid, a.RHPcodigo, a.Tcodigo, a.RVid, a.Dcodigo, 
					   a.Ocodigo, a.RHJid, a.DLfvigencia, a.DLsalario, {fn concat('#observ#', a.DLobs)} as Descripcion,
					   a.Dcodigoant, a.Ocodigoant, a.RHPidant, a.RHPcodigoant, a.Tcodigoant, a.DLsalarioant, 
					   a.DLporcplaza, a.RVidant, a.DLporcplazaant, a.DLestado, a.DLporcsal, a.DLporcsalant, 
					   a.RHJidant, a.DLidtramite, a.DLvdisf, a.DLvcomp, a.IEid, a.TEid, a.DLffin, a.DLlineaRef, b.RHTcomportam
				from DLaboralesEmpleado a
                	inner join RHTipoAccion b
                    	on a.RHTid=b.RHTid
				where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsID.DLlinea#">
			</cfquery>
			
			<!---Caso de acciones de dobles de Incapacidad (solo en caso de anulacion)--->
			<cfif ArrayLen(ArrayAccion) EQ 2> 
				<cfset fecha = rsDLE.DLffin >
			</cfif>
			
			<cfquery name="rsDLaboralesEmpleado" datasource="#Session.DSN#">
				insert into DLaboralesEmpleado
					(DLconsecutivo, DEid, RHTid, Ecodigo, RHPid, 
					 RHPcodigo, Tcodigo, RVid, Dcodigo, Ocodigo, RHJid, 
					 DLfvigencia, DLffin, DLsalario, DLobs, DLfechaaplic, Dcodigoant, 
					 Ocodigoant, RHPidant, RHPcodigoant, Tcodigoant, DLsalarioant,
					 Usucodigo, Ulocalizacion, DLporcplaza, RVidant, DLporcplazaant, 
					 DLestado, DLporcsal, DLporcsalant, RHJidant, DLidtramite, DLvdisf, 
					 DLvcomp, IEid, TEid, DLreferencia)
				values(
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDLE.DLconsecutivo#">, 
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDLE.DEid#">, 
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTipoAccionAnulacion.RHTid#">, 
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDLE.Ecodigo#">, 
					 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDLE.RHPid#" voidNull>, 
					 <cfqueryparam cfsqltype="cf_sql_char" value="#rsDLE.RHPcodigo#">, 
					 <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#rsDLE.Tcodigo#" voidNull>, 
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDLE.RVid#">, 
					 <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsDLE.Dcodigo#" voidNull>, 
					 <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsDLE.Ocodigo#" voidNull>, 
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDLE.RHJid#">,
                     <cfif isdefined("Form.rdAnulacion") and Form.rdAnulacion EQ 1><!--- suspension--->
					 	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,LSParseDateTime(fecha))#">,
					 	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDLE.DLffin#">,
                     <cfelse>
                     	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDLE.DLfvigencia#">, 
					 	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDLE.DLffin#">,
                     </cfif>
					 <cfqueryparam cfsqltype="cf_sql_money" value="#rsDLE.DLsalario#">, 
					 <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rsDLE.Descripcion#" voidNull>,
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
					 <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsDLE.Dcodigoant#" voidNull>, 
					 <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsDLE.Ocodigoant#" voidNull>, 
					 <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsDLE.RHPidant#" voidNull>, 
					 <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#rsDLE.RHPcodigoant#" voidNull>, 
					 <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#rsDLE.Tcodigoant#" voidNull>, 
					 <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#rsDLE.DLsalarioant#" voidNull>, 
					 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#" voidNull>,
					 <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#" voidNull>,
					 <cf_jdbcquery_param cfsqltype="cf_sql_float" value="#rsDLE.DLporcplaza#" voidNull>, 
					 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDLE..RVidant#" voidNull>, 
					 <cf_jdbcquery_param cfsqltype="cf_sql_float" value="#rsDLE.DLporcplazaant#" voidNull>, 
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDLE.DLestado#">, 
					 <cfqueryparam cfsqltype="cf_sql_float" value="#rsDLE.DLporcsal#">, 
					 <cf_jdbcquery_param cfsqltype="cf_sql_float" value="#rsDLE.DLporcsalant#" voidNull>, 
					 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDLE.RHJidant#" voidNull>, 
					 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDLE.DLidtramite#" voidNull>, 
					 <cfqueryparam cfsqltype="cf_sql_float" value="#rsDLE.DLvdisf#">, 
					 <cfqueryparam cfsqltype="cf_sql_float" value="#rsDLE.DLvcomp#">, 
					 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDLE.IEid#" voidNull>, 
					 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDLE.TEid#" voidNull>, 
					 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsID.DLlinea#" voidNull>
					)
				<cf_dbidentity1>
			</cfquery>
  			<cf_dbidentity2 name="rsDLaboralesEmpleado">
			<cfset lvarDLlinea = rsDLaboralesEmpleado.identity>
			<cfif isdefined("Form.rdAnulacion") and Form.rdAnulacion EQ 1>
				<!--- Suspension --->
                <cfset lvarDiasSusp = form.RHSPEdiasreb - form.dias>
                <cfquery name="rsVacSusp" datasource="#Session.DSN#">
					select {fn concat('#observ#', DVEdescripcion)} as Descripcion, DVEperiodo, DVElinea, 
                    (DVEdisfrutados + coalesce((select sum(DVEdisfrutados) from DVacacionesEmpleado va where va.DVErefLinea = dva.DVElinea),0)) as DVEdisfrutados, DVErefLinea, DVEreferencia
					from DVacacionesEmpleado dva
					where DVEreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsID.DLlinea#">
                      and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
                      and (DVEdisfrutados + coalesce((select sum(DVEdisfrutados) from DVacacionesEmpleado va where va.DVErefLinea = dva.DVElinea),0)) < 0
                    order by DVEperiodo desc
				</cfquery>
                <cfloop query="rsVacSusp">
   
                    <cfif lvarDiasSusp lt 1>
                    	<cfbreak>
                    </cfif>
                    <cfif lvarDiasSusp lte Abs(rsVacSusp.DVEdisfrutados)>
                    	<cfset lvarDiasCant = lvarDiasSusp>
                    <cfelse>
                    	<cfset lvarDiasCant = Abs(rsVacSusp.DVEdisfrutados)>
                    </cfif>
                    <cfquery datasource="#Session.DSN#">
                        insert into DVacacionesEmpleado(
                            DEid, 			Ecodigo, 
                            DVEfecha, 		DVEreferencia, 
                            DVEdescripcion, DVEdisfrutados, 
                            DVEcompensados, DVEmonto, 
                            Usucodigo, 		Ulocalizacion, 
                            DVEfalta, 		DVEenfermedad,
                            DVEperiodo, 	DVErefLinea,
                            BMUsucodigo)
                        values(#Form.DEid#, #session.Ecodigo#, 
                               <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(fecha)#">,
                               #rsID.DLlinea#,
                               '#rsVacSusp.Descripcion#', #lvarDiasCant#, 
                               0, 0, 
                               #Session.Usucodigo#, '#Session.Ulocalizacion#', 
                               <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 0,
                               #rsVacSusp.DVEperiodo#, #rsVacSusp.DVElinea#,#session.usucodigo#)
                    </cfquery>
                    <cfset lvarDiasSusp = lvarDiasSusp - lvarDiasCant>
                </cfloop>
                <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="2505" default="0" returnvariable="vCtrlVacXPeriodo"/>
				<cfif vCtrlVacXPeriodo>
                	<cfset lvarDiasSusp = form.RHSPEdiasreb - form.dias>
                    <cfloop query="rsVacSusp">
						<cfif lvarDiasSusp lt 1>
                            <cfbreak>
                        </cfif>
                        <cfif lvarDiasSusp lte Abs(rsVacSusp.DVEdisfrutados)>
							<cfset lvarDiasCant = lvarDiasSusp>
                        <cfelse>
                            <cfset lvarDiasCant = Abs(rsVacSusp.DVEdisfrutados)>
                        </cfif>
                        <!---20151021-ljimenez se marca como manual la anulacion/suspension esto por que cuando se calculan los DiasRegimenAsignados estan siendo sumadas estas devoluciones sumando  --->
                        <cfquery datasource="#Session.DSN#">
                            insert into DVacacionesAcum
                                (DEid, DVAdiasPotenciales, DVAperiodo, DVAsaldodias, DVASalarioProm, DVASalarioPdiario, DVAfecha, Ecodigo, DVElinea, BMUsucodigo,DVAmanual) 
                            values(#Form.DEid#, 0, #rsVacSusp.DVEperiodo#, #lvarDiasCant#, 0, 0
                               	   ,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(fecha)#">, #Session.Ecodigo#, #rsVacSusp.DVElinea#,#session.usucodigo#,1)
                        </cfquery>
                        <cfset lvarDiasSusp = lvarDiasSusp - lvarDiasCant>
                	</cfloop>
				</cfif>
				<cfif isdefined("Form.modificaLT") and Form.modificaLT EQ 1>
				<cfquery datasource="#Session.DSN#">
					update RHControlSaldos
					set RHCShasta =<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(fecha)#">,
					RHCSsaldo = case 
								when (RHCSdiario * #form.dias#) <= RHCSsaldo 
									then RHCSdiario * #form.dias# 
								else 0 
								end,
					RHCSsuspendido = 1,
					BMUsucodigo = #session.usucodigo#
					where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHSPEid#">
					  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				</cfquery>
				<cfelse>
                <cfquery datasource="#Session.DSN#">
					insert into RHSaldoPagosExceso(Ecodigo, DEid, DLlinea, RHTid, RHSPEfdesde, RHSPEfhasta, RHSPEfecha, RHSPEfdesdesig, RHSPEmontoreb,
                    							   RHSPEsaldo, RHSPEmontosub, RHSPEsaldiario, RHSPEsubdiario, RHSPEsaldosub, RHSPEdiasreb, RHSPEdiassub,
                                                   RHSPEanulado, BMUsucodigo)
                    select 
                        Ecodigo, DEid, DLlinea, RHTid, RHSPEfdesde, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(fecha)#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, RHSPEfdesdesig, RHSPEsaldiario * #form.dias#,
                        case when RHSPEsaldiario * #form.dias# <= RHSPEsaldosub then RHSPEsaldiario * #form.dias# else 0 end,
                        RHSPEsubdiario * #form.dias#, RHSPEsaldiario, RHSPEsubdiario,
                        case when RHSPEsubdiario * #form.dias# <= RHSPEsaldosub then RHSPEsubdiario * #form.dias# else 0 end,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.dias#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.dias#">, 0, #session.Usucodigo#
                   	from RHSaldoPagosExceso
					where RHSPEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHSPEid#">
					  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				</cfquery>
				<cfquery datasource="#Session.DSN#">
					update RHSaldoPagosExceso 
					set RHSPEanulado = 1, BMUsucodigo = #session.usucodigo#
					where RHSPEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHSPEid#">
					  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				</cfquery>
				</cfif>
			<cfelse>
				<!--- Anulacion --->
				<cfif rsDLE.RHTcomportam EQ 3> <!--- 20150218. Solo se aplica si la Accion de de Comportamiento Vacaciones --->                               
                        	<cfquery name="rm" datasource="#Session.DSN#">
                                insert into DVacacionesEmpleado(
                                    DEid, 			Ecodigo, 
                                    DVEfecha, 		DVEreferencia, 
                                    DVEdescripcion, DVEdisfrutados, 
                                    DVEcompensados, DVEmonto, 
                                    Usucodigo, 		Ulocalizacion, 
                                    DVEfalta, 		DVEenfermedad,
                                    DVEperiodo, 	DVErefLinea, DVEmanual)
                                select DEid, Ecodigo,
                                       <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(fecha)#">,
                                       <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDLlinea#">,
                                       {fn concat('#observ#', DVEdescripcion)}, (abs(DVEdisfrutados) + coalesce((select sum(DVEdisfrutados) from DVacacionesEmpleado va where va.DVErefLinea = dva.DVElinea),0)), 
                                       0, 0, 
                                       #Session.Usucodigo#, '#Session.Ulocalizacion#', 
                                       <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 0,
                                       DVEperiodo, DVElinea, 1
                                from DVacacionesEmpleado dva
                                where DVEreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsID.DLlinea#">
                                  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
                                  and (DVEdisfrutados + coalesce((select sum(DVEdisfrutados) from DVacacionesEmpleado va where va.DVErefLinea = dva.DVElinea),0)) < 0
                                order by DVEperiodo desc
                            </cfquery>

							<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="2505" default="0" returnvariable="vCtrlVacXPeriodo"/>
							<cfif vCtrlVacXPeriodo>
                                <cfif isdefined("Form.modificaLT") and Form.modificaLT EQ 1><!--- en el caso que modifique linea de tiempo--->
                                        <cfquery name="rsVacReb" datasource="#Session.DSN#">
                                            select distinct RHCScantidad as Dias
                                            from RHControlSaldos
                                            where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHSPEid#">
                                            and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
                                        </cfquery>
                                <cfelse>
                                        <cfquery name="rsVacReb" datasource="#Session.DSN#">
                                            select coalesce(DLvdisf,0) as Dias
                                            from DLaboralesEmpleado 
                                            where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsID.DLlinea#">
                                            and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
                                        </cfquery>
                                </cfif>
                                <cfquery name="rsVacDis" datasource="#Session.DSN#">
                                    select coalesce(abs(sum(DVEdisfrutados)),0) as Dias
                                    from DVacacionesEmpleado
                                    where DVEreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsID.DLlinea#">
                                     and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
                                </cfquery>

                                <cfif rsVacReb.Dias neq rsVacDis.Dias>
                                    <cf_errorCode	code="51918" msg="Las vacaciones anuladas no corresponde con las vacaciones asignadas para el empleado.">
                                </cfif>
                                <cfset lvarPeriodo = Year(LSParseDateTime(fecha))>
                                <cfquery datasource="#Session.DSN#">
                                    insert into DVacacionesAcum
                                        (DEid, DVAdiasPotenciales, DVAperiodo, DVAsaldodias, DVASalarioProm, DVASalarioPdiario, DVAfecha, Ecodigo, DVElinea,DVAmanual)
                                    select #Form.DEid#, 0, DVEperiodo, abs(DVEdisfrutados), 0, 0
                                       ,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(fecha)#">, #Session.Ecodigo#, DVElinea,1
                                    from DVacacionesEmpleado
                                    where DVEreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDLlinea#">
                                </cfquery>
                            </cfif>
				</cfif>                    
				<cfif isdefined("Form.modificaLT") and Form.modificaLT EQ 1><!--- en el caso que modifique linea de tiempo--->
                    <cfquery name="ABC_Anulacion2" datasource="#Session.DSN#">
                        update RHControlSaldos
                        set RHCShasta = RHCSdesde,
                            RHCSanulado = 1,
                            RHCSsaldo = 0
                        where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHSPEid#">
                        and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
                    </cfquery>	
                    <!--- 20150218. Se anula el corte de la Linea del Tiempo  --->
                    <cfquery name="ABC_Anulacion2" datasource="#Session.DSN#">
                        update LineaTiempo
                        set RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTipoAccionAnulacion.RHTid#">
                        Where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
                        and LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDLE.DLffin#">
                        and LThasta >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDLE.DLfvigencia#">
                        and RHTid in (Select RHTid 
                                      from DLaboralesEmpleado
                                      Where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHSPEid#">)
                    </cfquery>
				<cfelse><!--- procedimiento normal--->
                    <cfquery  datasource="#Session.DSN#">
                        update RHSaldoPagosExceso 
                        set 
                            RHSPEdiasreb = 0,
                            RHSPEdiassub = 0,
                            RHSPEfhasta = RHSPEfdesde,
                            RHSPEanulado = 1
                        where RHSPEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHSPEid#">
                        and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
                    </cfquery>
				</cfif>
			</cfif>
			<cfif isdefined("Form.modificaLT") and Form.modificaLT EQ 0>
				<!--- Actualizar Montos --->
				<cfquery name="ABC_Anulacion" datasource="#Session.DSN#">
					update RHSaldoPagosExceso 
					set 
						RHSPEsaldo = RHSPEsaldo - (RHSPEmontoreb - (RHSPEsaldiario * RHSPEdiasreb)),
						RHSPEsaldosub = RHSPEsaldosub - (RHSPEmontosub - (RHSPEsubdiario * RHSPEdiassub)),
						RHSPEmontoreb = RHSPEsaldiario * RHSPEdiasreb,
						RHSPEmontosub = RHSPEsubdiario * RHSPEdiassub
					where RHSPEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHSPEid#">
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				</cfquery>
			</cfif>
			
			<!--- Actualizar Estado de Nominas en Proceso de Calculo --->
			<!---
			<cfquery name="ABC_SalarioEmpleado" datasource="#Session.DSN#">
				update SalarioEmpleado
				set SEcalculado = 0
				from RCalculoNomina a, CalendarioPagos b
				where SalarioEmpleado.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				and SalarioEmpleado.SEcalculado = 1
				and a.RCNid = SalarioEmpleado.RCNid
				and a.RChasta >= convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FNuevohasta#">, 103)
				and a.RCestado = 0
				and b.CPid = a.RCNid
				and b.CPfcalculo is not null
				and b.CPfenvio is null
			</cfquery>
			--->
			
			<cfquery name="rsSalarioEmpleado" datasource="#session.DSN#">
				select se.RCNid, se.DEid
				from SalarioEmpleado se, RCalculoNomina a, CalendarioPagos b
				where se.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				and se.SEcalculado = 1
				and a.RCNid = se.RCNid
				and a.RChasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.FNuevohasta)#">
				and a.RCestado = 0
				and b.CPid = a.RCNid
				and b.CPfcalculo is not null
				and b.CPfenvio is null
			</cfquery>
			<cfloop query="rsSalarioEmpleado">
				<cfquery datasource="#session.DSN#">
					update SalarioEmpleado
					set SEcalculado = 0
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSalarioEmpleado.DEid#">
					and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSalarioEmpleado.RCNid#">
				</cfquery>
			</cfloop>
		</cfloop>
	</cftransaction>
</cfif>

<form action="AnulaAcciones.cfm" method="post" name="sql"></form>
<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>

