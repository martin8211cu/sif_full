<!--- Prueba para SVN --->
<cfcomponent>
	<cffunction name="AF_AltaActivosAdq" access="public" returntype="string">
		<!--- Parámetros de la función--->
		<cfargument name="Ecodigo" 			 type="numeric" required="false" default="#Session.Ecodigo#">
		<cfargument name="Usucodigo" 		 type="numeric" required="false" default="#Session.Usucodigo#">
		<cfargument name="EAcpidtrans" 		 type="string" 	required="true">
		<cfargument name="EAcpdoc" 			 type="string" 	required="true">
		<cfargument name="EAcplinea" 		 type="numeric" required="true">
		<cfargument name="DEBUG" 			 type="boolean" required="false" default="false">
		<cfargument name="TransaccionActiva" type="boolean" required="false" default="false">
		<cfargument name="Contabilizar" 	 type="boolean" required="false" default="true">
		<cfargument name="IDcontable" 	  	 type="numeric" required="false" default="0">

		<!--- Parametros para la contabilizacion de las cuentas intercompañia--->
		<cfargument name="AstInter" type="boolean" required="false" default="false">
		<cfargument name="EmpresaDt" type="numeric" default="0" required="false">

		<!---
			Identifica si se debe validar que falten transacciones de Adquisición de AF o si viene de la conciliación de AF.
			Esto para validar la cola de Adquisiciones por procesar.
			Si viene de la conciliación, el status se pasa a 1 porque el proceso lo generó con -1
		 --->
		<cfargument name="VerificarConciliacionAct" type="boolean" default="true">

		<cfset LvarError = false>

		<cfif Arguments.VerificarConciliacionAct>
			<cfquery name="rsVerificaConciliacion" datasource="#session.dsn#">
				select count(1) as Cantidad
				from EAadquisicion
				where Ecodigo  = #Arguments.Ecodigo#
				  and EAstatus = -1
			</cfquery>
			<cfif rsVerificaConciliacion.Cantidad GT 0>
				<cfset LvarError = true>
				<p>Advertencia:  Existen <cfoutput>#rsVerificaConciliacion.Cantidad#</cfoutput> documentos de adquisicion por procesar.  Deben de Completarse antes de procesar las Adquisiciones"</p>
			</cfif>
		<cfelse>
			<cfquery datasource="#session.dsn#">
				update EAadquisicion
				set EAstatus = 1
				where Ecodigo      = #Arguments.Ecodigo#
				  and EAcpidtrans = '#Arguments.EAcpidtrans#'
				  and EAcpdoc     = '#Arguments.EAcpdoc#'
				  and EAcplinea   = #Arguments.EAcplinea#
				  and EAstatus    = -1
			</cfquery>
		</cfif>

        <cfif LvarError EQ true>
            <p>Haga click <a href="/cfmx/sif/af/operacion/adquisicion-lista.cfm?m=1">aquí</a>  para volver a la página anterior.</p>
            <cf_abort errorInterfaz="">
        </cfif>
        <!---<cf_dump var = "#Arguments.TransaccionActiva#">--->
		<cfif Arguments.TransaccionActiva>
			<cfinvoke
				method="AF_AltaActivosAdqPrivate"
				Ecodigo="#Arguments.Ecodigo#"
				Usucodigo="#Arguments.Usucodigo#"
				EAcpidtrans="#Arguments.EAcpidtrans#"
				EAcpdoc="#Arguments.EAcpdoc#"
				EAcplinea="#Arguments.EAcplinea#"
				DEBUG="#Arguments.DEBUG#"
				Contabilizar="#Arguments.Contabilizar#"
				IDcontable="#Arguments.IDcontable#"
				AstInter="#Arguments.AstInter#"
				EmpresaDt="#Arguments.EmpresaDt#"/>
		<cfelse>
			<cftransaction>
				<cfinvoke
					method="AF_AltaActivosAdqPrivate"
					Ecodigo="#Arguments.Ecodigo#"
					Usucodigo="#Arguments.Usucodigo#"
					EAcpidtrans="#Arguments.EAcpidtrans#"
					EAcpdoc="#Arguments.EAcpdoc#"
					EAcplinea="#Arguments.EAcplinea#"
					DEBUG="#Arguments.DEBUG#"
					Contabilizar="#Arguments.Contabilizar#"
					IDcontable="#Arguments.IDcontable#"
					AstInter="#Arguments.AstInter#"
					EmpresaDt="#Arguments.EmpresaDt#"/>
			</cftransaction>
		</cfif>
	</cffunction>
	<cffunction name="AF_AltaActivosAdqPrivate" access="private" returntype="string">
		<!--- Parámetros de la función--->
		<cfargument name="Ecodigo" 			 type="numeric" required="false" default="#Session.Ecodigo#">
		<cfargument name="Usucodigo" 		 type="numeric" required="false" default="#Session.Usucodigo#">
		<cfargument name="EAcpidtrans" 		 type="string"  required="true">
		<cfargument name="EAcpdoc" 			 type="string"  required="true">
		<cfargument name="EAcplinea" 		 type="numeric" required="true">
		<cfargument name="DEBUG" 			 type="boolean" required="false" default="false">
		<cfargument name="TransaccionActiva" type="boolean" required="false" default="false">
		<cfargument name="Contabilizar" 	 type="boolean" required="false" default="true">
		<cfargument name="IDcontable" 		 type="numeric" required="false" default="0">

		<!--- Parametros para la contabilizacion de las cuentas intercompañia--->
		<cfargument name="AstInter" type="boolean" required="false" default="false">
		<cfargument name="EmpresaDt" type="numeric" default="0" required="no">

		<!--- Variables Locales, Consultas y Validaciones Iniciales.--->
		<!--- Declaración inicial--->
		<cfset descripcion = "Adquisición de Activos Fijos">

		<!--- Esta es la cuenta del credito --->
		<cfquery name="rstemp" datasource="#session.dsn#">
			select <cf_dbfunction name="to_number" args="Pvalor"> as CuentaActivos
			from Parametros
			where Ecodigo = #Arguments.Ecodigo#
				and Pcodigo = 240
		</cfquery>
		<cfset CuentaActivos = rstemp.CuentaActivos>

		<cfif len(trim(CuentaActivos)) eq 0>
        	<cfset LvarError = true>
			<p>Error 40003! No se pudo obtener la Cuenta de Activos de Activos En Tránsito (Parámetros Generales). Proceso Cancelado!</p>
		</cfif>

		<!--- Tipo de Documento --->
		<cfquery name="rstemp" datasource="#session.dsn#">
			select <cf_dbfunction name="to_number" args="Pvalor"> as CRTDid
			from Parametros
			where Ecodigo = #Arguments.Ecodigo#
				and Pcodigo = 910
		</cfquery>
		<cfset CRTDid = rstemp.CRTDid>

		<cfif len(trim(CRTDid)) eq 0>
	        <cfset LvarError = true>
			<p>Error 40004! No se pudo obtener El Tipo de Documento para Vales de Adquisición. Proceso Cancelado!</p>
		</cfif>

		<!--- Moneda --->
		<cfquery name="rstemp" datasource="#session.dsn#">
			select Mcodigo as Monloc
			from Empresas
			where Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfset Monloc = rstemp.Monloc>

		<cfif len(trim(Monloc)) eq 0>
	        <cfset LvarError = true>
			<p>Error 40005! No se pudo obtener la moneda local. Proceso Cancelado!</p>
		</cfif>

		<cfquery name="rstemp" datasource="#session.dsn#">
				select count(1) as cont
				from DSActivosAdq
				where Ecodigo       = #Arguments.Ecodigo#
					and EAcpidtrans = '#Arguments.EAcpidtrans#'
					and EAcpdoc     = '#Arguments.EAcpdoc#'
					and EAcplinea   = #Arguments.EAcplinea#
		</cfquery>

		<cfif rstemp.cont eq 0>
        	<cfset LvarError = true>
			<p>"Error 40006! Al menos un elemento de la Relación no tiene detalles. Proceso Cancelado!</p>
		</cfif>

		<cfquery name="rstemp" datasource="#session.dsn#">
				select CFid
				from DSActivosAdq
				where Ecodigo       = #Arguments.Ecodigo#
					and EAcpidtrans = '#Arguments.EAcpidtrans#'
					and EAcpdoc     = '#Arguments.EAcpdoc#'
					and EAcplinea   = #Arguments.EAcplinea#
					and not exists (select 1
						from CRCCCFuncionales
						where CFid = DSActivosAdq.CFid)
                 group by CFid
		</cfquery>

        <cfif rstemp.recordcount gt 0>
			<cfset LvarError = true>
            <p>Error 40007! Los siguientes Centros Funcionales No están asociados a un Centro de Custodia:</p>
            <cf_dbfunction name='concat' args='CFcodigo + CFdescripcion' delimiters='+' returnvariable='LvarCentros'>
            <cfset LvarMSG = ''>
            <cfset LvarCont = 0>
            <cfloop query="rstemp">
                <cfset LvarCFid = rstemp.CFid>
                <cfset LvarCont = LvarCont + 1>
                <cfquery name="rsCentroFuncional" datasource="#session.DSN#">
                    select CFcodigo, CFdescripcion
                    from CFuncional
                    where Ecodigo = #session.Ecodigo#
                    and CFid = #LvarCFid#
                </cfquery>
                <p>&nbsp;&nbsp;<cfoutput>#rsCentroFuncional.CFcodigo# - #rsCentroFuncional.CFdescripcion#</cfoutput></p>
            </cfloop>
        </cfif>

		<!--- Detallado de acuerdo con documentos de parámetros para la adquisición --->
		<cfquery name="rsData" datasource="#session.dsn#">
			select EAdescripcion
			from EAadquisicion
			where Ecodigo     =  #Arguments.Ecodigo#
			  and EAcpidtrans = '#Arguments.EAcpidtrans#'
			  and EAcpdoc     = '#Arguments.EAcpdoc#'
			  and EAcplinea   =  #Arguments.EAcplinea#
			  and EAstatus = 1
		</cfquery>
		<cfif rsData.recordcount>
			<cfset descripcion = "Adquisición AF :" & Left(rsData.EAdescripcion,40)>
		<cfelse>
        	<cfset LvarError = true>
			<p>Error 40008! Aplicando Relación: <cfoutput>#Arguments.EAcpidtrans#</cfoutput> - <cfoutput>#Arguments.EAcpdoc#</cfoutput>. La Relación no se encuentra preparada para ser aplicada. Proceso Interrumpido!</p>
		</cfif>

		<cfquery name="rsImcompleto" datasource="#Session.DSN#">
			select 1
			from DSActivosAdq
			where Ecodigo       =  #Arguments.Ecodigo#
			  and EAcpidtrans   = '#Arguments.EAcpidtrans#'
			  and EAcpdoc       = '#Arguments.EAcpdoc#'
			  and EAcplinea     = #Arguments.EAcplinea#
			  and (
			       AFMid is null
				or AFMid  <= 0
				or AFMMid is null or AFMMid <= 0
				or CFid is null or CFid <= 0
				or DEid is null or DEid <= 0
				or ACcodigo is null or ACcodigo <= 0
				or ACid is null or ACid <= 0
				or DSdescripcion is null or coalesce({fn LENGTH(ltrim(rtrim(DSdescripcion)))},0) = 0
				or DSplaca is null or coalesce({fn LENGTH(ltrim(rtrim(DSplaca)))},0) = 0

				or DSfechainidep is null
				or DSfechainirev is null
				or DSmonto is null or DSmonto <= 0)
		</cfquery>

		<cfquery name="rsDesbalanceado" datasource="#Session.DSN#">
			select a.DAlinea, a.DAmonto, sum(b.DSmonto) as DSmonto
			from DAadquisicion a
				inner join DSActivosAdq b
					on  b.Ecodigo = a.Ecodigo
					and b.EAcpidtrans = a.EAcpidtrans
					and b.EAcpdoc = a.EAcpdoc
					and b.EAcplinea = a.EAcplinea
					and b.DAlinea = a.DAlinea
			where a.Ecodigo     =  #Arguments.Ecodigo#
			  and a.EAcpidtrans = '#Arguments.EAcpidtrans#'
			  and a.EAcpdoc     = '#Arguments.EAcpdoc#'
			  and a.EAcplinea   = #Arguments.EAcplinea#
			group by a.DAlinea, a.DAmonto
		</cfquery>
		<cfset Lvar_Desbalanceado = false>

		<cfloop query="rsDesbalanceado">
			<cfif rsDesbalanceado.DAmonto neq rsDesbalanceado.DSmonto>
				<cfset Lvar_Desbalanceado = true>
				<cfbreak>
			</cfif>
		</cfloop>

		<cfif rsImcompleto.recordcount gt 0>
	        <cfset LvarError = true>
			<p>Error 40009! Aplicando Relación: <cfoutput>#Arguments.EAcpidtrans#</cfoutput> - <cfoutput>#Arguments.EAcpdoc#</cfoutput>. Datos Incompletos. Proceso Interrumpido!</p>
		<cfelseif Lvar_Desbalanceado>
        	<cfset LvarError = true>
			<p>Error 40010! Aplicando Relación: <cfoutput>#Arguments.EAcpidtrans#</cfoutput> - <cfoutput>#Arguments.EAcpdoc#</cfoutput>. Relación Desbalanceada. Proceso Interrumpido!</p>
		</cfif>

        <cfif LvarError EQ true>
	        <p>Haga click <a href="/cfmx/sif/af/operacion/adquisicion-lista.cfm?m=1">aquí</a>  para volver a la página anterior.</p>
           <cf_abort errorInterfaz="">
        </cfif>

		<!---  06/05/2006 Ahora deben procesarse de manera distinta los Activos con placa existente de los Activos cuya placa no exista --->
			<!--- 1. Alta de Activos --->
				<cfif Arguments.debug>
					Activos...<cfdump var="#now()#">
				</cfif>
			<cfquery name="preActivos" datasource="#session.dsn#">
			   select
						a.Ecodigo ,a.ACid ,a.ACcodigo ,ac.ACdepadq,a.AFMid ,a.AFMMid ,a.SNcodigo ,a.DSdescripcion ,a.DSserie, a.DSplaca,
                        a.DSfechainidep,
						a.lin,
						coalesce(cf.CCFvutil, xf.CCFvutil, c.ACvutil) Avutil
						,case
							when cf.CCFtipo is not null then
								case cf.CCFtipo when 'M' then cf.CCFvalorres when 'P' then (cf.CCFvalorres * a.DSmonto / 100) end
							when xf.CCFtipo is not null then
								case xf.CCFtipo when 'M' then xf.CCFvalorres when 'P' then (xf.CCFvalorres * a.DSmonto / 100) end
							else
								case c.ACtipo when 'M' then c.ACvalorres when 'P' then (c.ACvalorres * a.DSmonto / 100) end
						end Avalrescate,
						a.AFCcodigo, b.CRDRconsecutivo
					from DSActivosAdq a
						inner join AClasificacion c
							on c.ACid = a.ACid
							and c.ACcodigo = a.ACcodigo
							and c.Ecodigo = a.Ecodigo
                        <!---SML.04/03/2014 Obtener el numero consecutivo de acuerdo a la placa --->
                        inner join CRDocumentoResponsabilidad b on a.CRDRid = b.CRDRid
							and b.Ecodigo = a.Ecodigo
						inner join CFuncional d
							on d.CFid = a.CFid
							and d.Ecodigo = a.Ecodigo
						left outer join ClasificacionCFuncional xf
							on xf.ACid      = a.ACid
							and xf.ACcodigo = a.ACcodigo
							and xf.Ocodigo  = d.Ocodigo
							and xf.Ecodigo  = d.Ecodigo
							and xf.CFid     is null
						left outer join ClasificacionCFuncional cf
							on cf.CFid      = a.CFid
							and cf.Ecodigo  = a.Ecodigo
							and cf.ACcodigo = a.ACcodigo
							and cf.ACid     = a.ACid
							and cf.Ocodigo  is null
						left join ACategoria ac
							on ac.ACcodigo = a.ACcodigo
							and ac.Ecodigo = a.Ecodigo
					where a.Ecodigo     =  #Arguments.Ecodigo#
					  and a.EAcpidtrans = '#Arguments.EAcpidtrans#'
					  and a.EAcpdoc     = '#Arguments.EAcpdoc#'
					  and a.EAcplinea   =  #Arguments.EAcplinea#
					  and not exists (
								select 1
								from Activos a_validate
								where a_validate.Ecodigo = a.Ecodigo
								  and a_validate.Aplaca  = a.DSplaca
							)
					   and not exists (
								select 1
								from DSActivosAdq ds_validate
								where ds_validate.Ecodigo   = a.Ecodigo
								and ds_validate.EAcpidtrans = a.EAcpidtrans
								and ds_validate.EAcpdoc     = a.EAcpdoc
								and ds_validate.EAcplinea   = a.EAcplinea
								and ds_validate.DSplaca     = a.DSplaca
								and ds_validate.lin         <> a.lin
							)
				</cfquery>


                <cfquery name="rsFechaAdquisicionCxP" datasource="#session.dsn#">
                    select Pvalor as  valor
                    from Parametros p
                    where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                        and p.Pcodigo = 3805
                </cfquery>
				<cfquery name="rsAplicarME" datasource="#session.dsn#">
                    select Pvalor as  valor
                    from Parametros p
                    where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                        and p.Pcodigo = 4403
                </cfquery>
				<cfset LvarAplicarEnMonedaExtranjera = rsAplicarME.valor eq 1>
                  <!---
                <cfif rsFechaAdquisicionCxP.recordcount eq 0 or len(trim(rsFechaAdquisicionCxP.valor))eq 0 or rsFechaAdquisicionCxP.valor eq 0>
	                <!--- Obtiene la auxiliar, depresiacion y revaluacion a partir del periodo / mes --->
                    <!--- Obtiene la auxiliar, depresiacion y revaluacion a partir del periodo / mes --->

                </cfif>--->

				<cfif preActivos.recordcount gt 0 and preActivos.ACdepadq eq 1>
				      <cfset VACdepad = 1>
				<cfelse>
					  <cfset VACdepad = 0>
				</cfif>

	                <cfinvoke component="sif.Componentes.AF_ValidarActivo" method="fnGetFechas" FechaAdquisicionCxP="19000101" DepAdq="#VACdepad#" Parametro3805="0" returnvariable="LvarArrayFechas">

                <cfset FechaAux 		= LvarArrayFechas[1]><!--- Fecha auxiliar--->
                <cfset FechaIniDepr 	= LvarArrayFechas[2]><!--- Fecha depreciación--->
                <cfset FechaIniRev 		= LvarArrayFechas[3]><!--- Fecha revaluación--->
                <cfset Periodo 			= LvarArrayFechas[4]><!--- Periodo--->
                <cfset Mes 				= LvarArrayFechas[5]><!--- Mes--->


				<cfloop query="preActivos">
					<cfif rsFechaAdquisicionCxP.valor eq 1>
                        <!--- Obtiene la auxiliar, depresiacion y revaluacion a partir del periodo / mes --->
                        <cfinvoke component="sif.Componentes.AF_ValidarActivo" method="fnGetFechas" Parametro3805="1" FechaAdquisicionCxP="#preActivos.DSfechainidep#" DepAdq="#preActivos.ACdepadq#" returnvariable="LvarArrayFechas">
                        <cfset FechaAux 		= LvarArrayFechas[1]><!--- Fecha auxiliar--->
                        <cfset FechaIniDepr 	= LvarArrayFechas[2]><!--- Fecha depreciación--->
                        <cfset FechaIniRev 		= LvarArrayFechas[3]><!--- Fecha revaluación--->
                        <cfset Periodo 			= LvarArrayFechas[4]><!--- Periodo--->
                        <cfset Mes 				= LvarArrayFechas[5]><!--- Mes--->
                    </cfif>


					<cfquery name="createActivos" datasource="#session.dsn#">
						insert into Activos (
							Ecodigo, ACid, ACcodigo, AFMid, AFMMid, SNcodigo, Adescripcion, Aserie, Aplaca, Astatus,
							Areflin, Afechainidep, Afechainirev, Afechaaltaadq,
							Avutil, Avalrescate, AFCcodigo, ACconsecutivo)
						values(
							#preActivos.Ecodigo#,
							#preActivos.ACid#,
							#preActivos.ACcodigo#,
							#preActivos.AFMid#,
							#preActivos.AFMMid#,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#preActivos.SNcodigo#" 	  voidnull>,
						    <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#preActivos.DSdescripcion#" len="100">,
						    <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#preActivos.DSserie#" 	  len="50">,
						    <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#preActivos.DSplaca#" 	  len="20">,
							0,
							#preActivos.lin#,
							<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#FechaIniDepr#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#FechaIniRev#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#FechaAux#">,
							#preActivos.Avutil#,
							#preActivos.Avalrescate#,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#preActivos.AFCcodigo#" 	  voidnull>,
                            <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#preActivos.CRDRconsecutivo#" voidnull>
							)
					 	<cf_dbidentity1>
					</cfquery>
						<cf_dbidentity2 name="createActivos">
					<!---Se Copian los datos variables del proceso de adquisición DSActivosAdq a Activos--->
					<cfinvoke component="sif.Componentes.DatosVariables" method="COPIARVALOR">
						<cfinvokeargument name="DVTcodigoValor" 	value="AF">
						<cfinvokeargument name="DVVidTablaVal"  	value="#preActivos.lin#">
						<cfinvokeargument name="DVVidTablaSec" 		value="2"><!---DSActivosAdq--->
						<cfinvokeargument name="DVVidTablaVal_new"  value="#createActivos.identity#">
						<cfinvokeargument name="DVVidTablaSec_new" 	value="0"><!---Activos--->
						<cfinvokeargument name="delete_OLD" 	    value="true">
					</cfinvoke>
				</cfloop>
				<!--- 1.1 Alta de Responsables --->
				<cfif Arguments.debug>
					AFResponsables...<cfdump var="#now()#">
				</cfif>
				<cf_dbfunction name="sReplace"	args="d.DDlineas+','+rtrim('')" delimiters="+" returnvariable="LvarDDLineas">
                <cf_dbfunction name="sReplace"	args="d.DOlineas+','+rtrim('')" delimiters="+" returnvariable="LvarDOLineas">
				<!--- Alta de vales con documentos (En Transito) existentes --->
				<cfquery datasource="#session.dsn#">
					insert into AFResponsables (
						Ecodigo, DEid, Aid,
						CFid, CRCCid, CRTDid, CRDRdescripcion,
						CRDRdescdetallada, CRDRtipodocori, CRDRdocori,
						EOidorden,DOlineas,CRDRlindocori,Monto,
						AFRfini, AFRffin, AFRdocumento, Usucodigo, Ulocalizacion,
						BMUsucodigo,CRTCid,CRDRid
					)
					select
						a.Ecodigo, a.DEid, c.Aid,
						a.CFid, d.CRCCid, d.CRTDid, d.CRDRdescripcion,
						d.CRDRdescdetallada, d.CRDRtipodocori, d.CRDRdocori,
						d.EOidorden, <cf_dbfunction name="to_number" args="#LvarDOLineas#">, <cf_dbfunction name="to_number" args="#LvarDDLineas#">, coalesce(d.Monto,0.00),
                        <cfif rsFechaAdquisicionCxP.recordcount eq 0 or len(trim(rsFechaAdquisicionCxP.valor))eq 0 or rsFechaAdquisicionCxP.valor eq 0>
                        	#FechaAux#,
                        <cfelse>
                        	c.Afechaaltaadq,
                        </cfif>

						#lsparsedatetime('01/01/6100')#,
						a.DAlinea,
						#session.Usucodigo#,
						'00', #session.Usucodigo#, d.CRTCid, d.CRDRid
					from DSActivosAdq a
						inner join Activos c
							on c.Areflin = a.lin
							and c.Aplaca  = a.DSplaca
						inner join CRDocumentoResponsabilidad d
							on d.CRDRid = a.CRDRid
					where a.Ecodigo     =  #Arguments.Ecodigo#
					  and a.EAcpidtrans = '#Arguments.EAcpidtrans#'
					  and a.EAcpdoc     = '#Arguments.EAcpdoc#'
					  and a.EAcplinea   =  #Arguments.EAcplinea#
					  and d.CRDRestado  = 10
				</cfquery>

				<!--- Alta de vales con documentos INexistentes --->
				<cfquery datasource="#session.dsn#">
					insert into AFResponsables (
						Ecodigo, DEid,    Aid,
						CFid,    CRCCid,  CRTDid,
						CRDRdescripcion, CRDRdescdetallada, Monto,
						AFRfini, AFRffin, AFRdocumento,
						Usucodigo, Ulocalizacion, BMUsucodigo
					)
					select
						a.Ecodigo, a.DEid, c.Aid,
						a.CFid, ((select min(CRCCid) from CRCCCFuncionales where CFid = a.CFid)), #CRTDid#,
						c.Adescripcion, c.Adescripcion, a.DSmonto,
                        <cfif rsFechaAdquisicionCxP.recordcount eq 0 or len(trim(rsFechaAdquisicionCxP.valor))eq 0 or rsFechaAdquisicionCxP.valor eq 0>
                        	#FechaAux#,
                        <cfelse>
                        	c.Afechaaltaadq,
                        </cfif>
						#lsparsedatetime('01/01/6100')#,


						a.DAlinea,
						#session.Usucodigo#, '00', #session.Usucodigo#
					from DSActivosAdq a
						inner join Activos c
							 on c.Areflin = a.lin<!---(c.Areflin = a.lin)impide que se creen vale para las transacciones de Mejora--->
							and c.Aplaca  = a.DSplaca
					where a.Ecodigo       = #Arguments.Ecodigo#
					  and a.EAcpidtrans   = '#Arguments.EAcpidtrans#'
					  and a.EAcpdoc       = '#Arguments.EAcpdoc#'
					  and a.EAcplinea     =  #Arguments.EAcplinea#
					  and not exists (
							select 1
							from CRDocumentoResponsabilidad d
							 where d.CRDRid = a.CRDRid
							)
				</cfquery>
				<!--- Mejora los Documentos de Responsabilidad (Vales) Existentes. --->
				<cfif Arguments.debug>
					Mejora AFResponsables...<cfdump var="#now()#">
				</cfif>
				<cfquery name="rsActualizaResponsables" datasource="#session.dsn#">
					select a.DSplaca, a.CRDRid
					from DSActivosAdq a
					where a.Ecodigo     =  #Arguments.Ecodigo#
					  and a.EAcpidtrans = '#Arguments.EAcpidtrans#'
					  and a.EAcpdoc     = '#Arguments.EAcpdoc#'
					  and a.EAcplinea   =  #Arguments.EAcplinea#
					  and not exists (
								select 1
								from Activos a_validate
								where a_validate.Ecodigo = a.Ecodigo
								  and a_validate.Aplaca = a.DSplaca
								  and a_validate.Areflin = a.lin
							)
				</cfquery>
                <cfset LvarCRDRidE = 0>
				<!--- Recorrer los documentos de reponsabilidad existentes para generar mejoras --->
				<cfloop query="rsActualizaResponsables">
					<cfif rsActualizaResponsables.CRDRid eq 0>
	                    <cfset LvarError = true>
						<p>Error 40011! Error al intentar mejorar el documento de responsabilidad. Documento de Responsabilidad no asignado para la placa: <cfoutput>#rsActualizaResponsables.DSplaca#</cfoutput>. Proceso Cancelado.</p>
					<cfelse>
						<cfquery name="valida_insert_afr" datasource="#session.dsn#">
							select count(1) as Cantidad
							from CRDocumentoResponsabilidad crdr
								inner join Activos act
									on  act.Ecodigo = crdr.Ecodigo
									and act.Aplaca  = crdr.CRDRplaca
								inner join AFResponsables afr
									on afr.Ecodigo = act.Ecodigo
									and afr.Aid = act.Aid
									and
                                    <cfif rsFechaAdquisicionCxP.recordcount eq 0 or len(trim(rsFechaAdquisicionCxP.valor))eq 0 or rsFechaAdquisicionCxP.valor eq 0>
                                        #FechaAux#
                                    <cfelse>
                                        act.Afechaaltaadq
                                    </cfif>
                                     between afr.AFRfini and afr.AFRffin
							where crdr.CRDRid = #rsActualizaResponsables.CRDRid#
						</cfquery>
						<cfif valida_insert_afr.Cantidad eq 0>
							<cfset LvarError = true>
							<p>Error 40011! Error al intentar mejorar el documento de responsabilidad. No se encontró el documento de responsabilidad anterior en estado activo para la placa: <cfoutput>#rsActualizaResponsables.DSplaca#</cfoutput>. Proceso Cancelado.</p>
						<cfelse>
                        	<cf_dbfunction name="sReplace"	args="crdr.DDlineas+','+rtrim('')" delimiters="+" returnvariable="LvarDDLineas">
                			<cf_dbfunction name="sReplace"	args="crdr.DOlineas+','+rtrim('')" delimiters="+" returnvariable="LvarDOLineas">
                        	<cfquery name="select_afr" datasource="#session.dsn#">
								select
									afr.DEid, afr.Aid,
									afr.CFid, afr.CRCCid, afr.CRTDid, afr.CRDRdescripcion,
									{fn concat({fn concat(afr.CRDRdescdetallada,' ')}, crdr.CRDRdescdetallada)} as CRDRdescdetallada,
									crdr.CRDRtipodocori, crdr.CRDRdocori,
									crdr.EOidorden,<cf_dbfunction name="to_number" args="#LvarDOLineas#"> as DOlinea,<cf_dbfunction name="to_number" args="#LvarDDLineas#"> as CRDRlindocori,crdr.Monto,
									crdr.CRDRfdocumento as AFRfini,
									#lsparsedatetime('01/01/6100')# as AFRffin,
									afr.AFRdocumento,
									'00' as Ulocalizacion,
									crdr.CRTCid,crdr.CRDRid
								from CRDocumentoResponsabilidad crdr
									inner join Activos act
										on  act.Ecodigo = crdr.Ecodigo
										and act.Aplaca = crdr.CRDRplaca
									inner join AFResponsables afr
										on afr.Ecodigo = act.Ecodigo
										and afr.Aid = act.Aid
										and
                                        <cfif rsFechaAdquisicionCxP.recordcount eq 0 or len(trim(rsFechaAdquisicionCxP.valor))eq 0 or rsFechaAdquisicionCxP.valor eq 0>
                                            #FechaAux#
                                        <cfelse>
                                            act.Afechaaltaadq
                                        </cfif>
                                         between afr.AFRfini and afr.AFRffin
								where crdr.CRDRid = #rsActualizaResponsables.CRDRid#
							</cfquery>

							<cfquery name="rs_insert_afr" datasource="#session.dsn#">
								insert into AFResponsables (
									Ecodigo, DEid, Aid,
									CFid, CRCCid, CRTDid, CRDRdescripcion,
									CRDRdescdetallada, CRDRtipodocori, CRDRdocori,
									EOidorden,DOlineas,CRDRlindocori,Monto,
									AFRfini, AFRffin, AFRdocumento, Usucodigo, Ulocalizacion,
									BMUsucodigo,CRTCid,CRDRid)
									VALUES(
									   #session.Ecodigo#,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select_afr.DEid#"              voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select_afr.Aid#"               voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select_afr.CFid#"              voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select_afr.CRCCid#"            voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select_afr.CRTDid#"            voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="80"  value="#select_afr.CRDRdescripcion#"   voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#select_afr.CRDRdescdetallada#" voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="10"  value="#select_afr.CRDRtipodocori#"    voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#select_afr.CRDRdocori#"        voidNull>,

									   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select_afr.EOidorden#"         voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select_afr.DOlinea#"           voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select_afr.CRDRlindocori#"     voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#select_afr.Monto#"             voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#select_afr.AFRfini#"           voidNull>,
									   '#select_afr.AFRffin#',
									   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select_afr.AFRdocumento#"      voidNull>,
									   #session.Usucodigo#,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#select_afr.Ulocalizacion#"     voidNull>,
									   #session.Usucodigo#,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select_afr.CRTCid#"            voidNull>,
									   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select_afr.CRDRid#"            voidNull>

								)

								<cf_dbidentity1 verificar_transaccion="false">
							</cfquery>
							<cf_dbidentity2 name="rs_insert_afr" verificar_transaccion="false">
							<!---******* Aqui se hace el alta a la tabla de bitacoras ******--->
							<cfquery datasource="#session.dsn#" name="rsinsertabitacora">
								insert into CRBitacoraTran(
									Ecodigo,
									CRBfecha,
									Usucodigo,
									CRBmotivo,
									CRBPlaca,
									AFRid,
									Aid,
									BMUsucodigo)
								select
									#Session.Ecodigo#,
                                    <cfif rsFechaAdquisicionCxP.recordcount eq 0 or len(trim(rsFechaAdquisicionCxP.valor))eq 0 or rsFechaAdquisicionCxP.valor eq 0>
                                        #FechaAux#,
                                    <cfelse>
                                        act.Afechaaltaadq,
                                    </cfif>
									#Session.Usucodigo#,
									5,
									act.Aplaca,
									afr.AFRid,
									afr.Aid,
									#Session.Usucodigo#
								from AFResponsables afr
									inner join Activos act
										on act.Aid = afr.Aid
								where afr.AFRid = #rs_insert_afr.identity#
							</cfquery>

							<cfquery name="rs_select_afr" datasource="#session.dsn#">
								select AFR.AFRid, <cf_dbfunction name="to_sdateDMY"	args="CRDRfdocumento"> CRDRfdocumento
								from CRDocumentoResponsabilidad crdr
									inner join Activos act
										on act.Aplaca = crdr.CRDRplaca
									   and act.Ecodigo = crdr.Ecodigo
									inner join AFResponsables AFR
										on AFR.Aid     = act.Aid
									   and AFR.Ecodigo = act.Ecodigo
									   and
                                       <cfif rsFechaAdquisicionCxP.recordcount eq 0 or len(trim(rsFechaAdquisicionCxP.valor))eq 0 or rsFechaAdquisicionCxP.valor eq 0>
                                            #FechaAux#
                                        <cfelse>
                                            act.Afechaaltaadq
                                        </cfif>
                                       between AFR.AFRfini and AFR.AFRffin
								where crdr.CRDRid = #rsActualizaResponsables.CRDRid#
								  and (AFR.CRDRid <> #rsActualizaResponsables.CRDRid# or AFR.CRDRid is null)
							</cfquery>
							<cfquery name="rs_update_afr" datasource="#session.dsn#">
								update AFResponsables
								set AFRffin = (<cf_dbfunction name="dateadd" args="-1, '#rs_select_afr.CRDRfdocumento#'">),
									Usucodigo = #Session.Usucodigo#,
									Ulocalizacion = '00'
								where AFRid = #rs_select_afr.AFRid#
							</cfquery>
                            <!---Lista con los Documentos de Responsabilidad a eliminar, anteriormente se eliminaban antes de finalizar el loop
                			esto se cambia debido a que se necesita el documento de responsabilidad para insertar el ADTPrazon (Vales de Mejoras) en Transacciones Activos--->
							<cfset LvarCRDRidE = listAppend(LvarCRDRidE, rsActualizaResponsables.CRDRid)>
						</cfif>
                	</cfif>
				</cfloop>

				<cfif LvarError EQ true>
                	<p>Haga click <a href="/cfmx/sif/af/operacion/adquisicion-lista.cfm?m=1">aquí</a>  para volver a la página anterior.</p>
                   <cf_abort errorInterfaz="">
                </cfif>

				<!---******* Aqui se hace el alta a la tabla de bitacoras ******--->
				<cfquery datasource="#session.dsn#" name="rsinsertabitacora">
					insert into CRBitacoraTran(
						Ecodigo,
						CRBfecha,
						Usucodigo,
						CRBmotivo,
						CRBPlaca,
						AFRid,
						Aid,
						BMUsucodigo)
					select
						#Session.Ecodigo#,
                        <cfif rsFechaAdquisicionCxP.recordcount eq 0 or len(trim(rsFechaAdquisicionCxP.valor))eq 0 or rsFechaAdquisicionCxP.valor eq 0>
                            #FechaAux#,
                        <cfelse>
                            c.Afechaaltaadq,
                        </cfif>
						#Session.Usucodigo#,
						1,
						c.Aplaca,
						d.AFRid,
						c.Aid,
						#Session.Usucodigo#
					from DSActivosAdq a
						inner join Activos c
							on  c.Areflin = a.lin
							and c.Aplaca  = a.DSplaca
						inner join AFResponsables d
							on  d.Aid     = a.Aid
							and d.Ecodigo = a.Ecodigo
					where a.Ecodigo     =  #Arguments.Ecodigo#
					  and a.EAcpidtrans = '#Arguments.EAcpidtrans#'
					  and a.EAcpdoc     = '#Arguments.EAcpdoc#'
					  and a.EAcplinea   =  #Arguments.EAcplinea#
				</cfquery>

				<!--- 2. Alta de Transacción y Saldos--->
				<!--- 2.1 Alta de Transacción --->
				<cfif Arguments.debug>
					TransaccionesActivos...<cfdump var="#now()#">
				</cfif>
				<cfinvoke component	= "sif.Componentes.OriRefNextVal"
						method		= "nextVal"
						returnvariable	= "LvarNumDoc"
						ORI			= "AFAQ"
						REF			= "AQ"
				/>
				<cfquery name="rs_agtp_insert" datasource="#session.dsn#">
					insert into AGTProceso (
						Ecodigo, IDtrans, AGTPdescripcion, AGTPperiodo,
						AGTPmes, Usucodigo, AGTPfalta, AGTPestadp, AGTPecodigo, AGTPdocumento)
					values(
						#Arguments.Ecodigo#, 1, '#descripcion#', #periodo#,
						#Mes#, #Session.Usucodigo#, <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
						4, #Arguments.Ecodigo#, #LvarNumDoc#
					)
					<cf_dbidentity1 verificar_transaccion="false">
				</cfquery>
				<cf_dbidentity2 name="rs_agtp_insert" verificar_transaccion="false">

				<cfquery name="rsTA" datasource="#session.dsn#">
					insert into TransaccionesActivos (
						Ecodigo,
						Aid,
						IDtrans,
                        ADTPrazon,
						CFid,
						TAperiodo,
						TAmes,
						TAfecha,
						TAfalta,
						TAmontooriadq,
						TAmontolocadq,
						TAmontoorimej,
						TAmontolocmej,
						TAmontoorirev,
						TAmontolocrev,
						Mcodigo,
						TAtipocambio,
						Ccuenta,
						Usucodigo,
						TAdocumento,
						TAreferencia,
						TAfechainidep,
						TAvalrescate,
						TAvutil,
						TAsuperavit,
						TAfechainirev,
						AGTPid)
					select
						a.Ecodigo,
						(	select max(c.Aid)
							from Activos c
							where c.Ecodigo = a.Ecodigo
							  and c.Aplaca = a.DSplaca
						),
						case when
							exists (
								select 1 from Activos a_validate
								where a_validate.Ecodigo = a.Ecodigo
								and a_validate.Aplaca = a.DSplaca
								and a_validate.Areflin = a.lin
							)
						then 1
						else 2
						end,
                        case when
							exists (
								select 1 from Activos a_validate
								where a_validate.Ecodigo = a.Ecodigo
								and a_validate.Aplaca = a.DSplaca
								and a_validate.Areflin = a.lin
							)
						then ''
						else (select coalesce(AFCMdescripcion, '')
                        	  from AFConceptoMejoras afc
                              inner join CRDocumentoResponsabilidad crd
                              on crd.AFCMid = afc.AFCMid
                              and crd.CRDRid = a.CRDRid)
						end as trasss,
						a.CFid,
						#periodo#,
						#Mes#,
                        <cfif rsFechaAdquisicionCxP.recordcount eq 0 or len(trim(rsFechaAdquisicionCxP.valor))eq 0 or rsFechaAdquisicionCxP.valor eq 0>
                            #FechaAux#,
                        <cfelse>
                        	coalesce(
                            (select Afechaaltaadq
                        	from Activos aa
                            where aa.Areflin = a.lin
							and aa.Ecodigo = a.Ecodigo
							and aa.Aplaca = a.DSplaca), #FechaAux#),
                        </cfif>
						#now()#,

						case when
							exists (
								select 1 from Activos a_validate
								where a_validate.Areflin = a.lin
								and a_validate.Aplaca = a.DSplaca
								)
							then a.DSmonto / Coalesce(a.DSAtc,1)
							else 0.00
						end,
						case when
							exists (
								select 1 from Activos a_validate
								where a_validate.Areflin = a.lin
								and a_validate.Aplaca = a.DSplaca
								)
							then a.DSmonto
							else 0.00
						end,
						case when
							exists (
								select 1 from Activos a_validate
								where a_validate.Areflin = a.lin
								and a_validate.Aplaca = a.DSplaca
								)
							then 0.00
							else a.DSmonto / a.DSAtc
						end,
						case when
							exists (
								select 1 from Activos a_validate
								where a_validate.Areflin = a.lin
								and a_validate.Aplaca = a.DSplaca
								)
							then 0.00
							else a.DSmonto
						end,
						0.00,
						0.00,
						b.Mcodigo,
						b.EAtipocambio,
						(
							Select min(ACcadq)
							from AClasificacion acl
							where acl.ACid = a.ACid
							  and acl.ACcodigo = a.ACcodigo
							  and acl.Ecodigo = a.Ecodigo
						) as Ccuenta,

						#session.Usucodigo#,
						b.EAcpdoc,
						b.EAcpidtrans,
                        <cfif rsFechaAdquisicionCxP.recordcount eq 0 or len(trim(rsFechaAdquisicionCxP.valor))eq 0 or rsFechaAdquisicionCxP.valor eq 0>
							a.DSfechainidep,
                        <cfelse>
                        	(select coalesce(aa.Afechainidep, a.DSfechainidep)
                        	from Activos aa
                            where aa.Areflin = a.lin
							and aa.Ecodigo = a.Ecodigo
							and aa.Aplaca = a.DSplaca),
                        </cfif>
						case
							when cf.CCFtipo is not null then
								case cf.CCFtipo when 'M' then cf.CCFvalorres when 'P' then (cf.CCFvalorres * a.DSmonto / 100) end
							when xf.CCFtipo is not null then
								case xf.CCFtipo when 'M' then xf.CCFvalorres when 'P' then (xf.CCFvalorres * a.DSmonto / 100) end
							else
								case d.ACtipo when 'M' then d.ACvalorres when 'P' then (d.ACvalorres * a.DSmonto / 100) end
						end,
						coalesce(cf.CCFvutil, xf.CCFvutil, d.ACvutil),
						0,
                        <cfif rsFechaAdquisicionCxP.recordcount eq 0 or len(trim(rsFechaAdquisicionCxP.valor))eq 0 or rsFechaAdquisicionCxP.valor eq 0>
							a.DSfechainirev,
                        <cfelse>
                        	(select coalesce(aa.Afechainirev, a.DSfechainirev)
                        	from Activos aa
                            where aa.Areflin = a.lin
							and aa.Ecodigo = a.Ecodigo
							and aa.Aplaca = a.DSplaca),
                        </cfif>
						#rs_agtp_insert.identity#
					from DSActivosAdq a
						inner join EAadquisicion b
							on  b.Ecodigo     = a.Ecodigo
							and b.EAcpidtrans = a.EAcpidtrans
							and b.EAcpdoc     = a.EAcpdoc
							and b.EAcplinea   = a.EAcplinea
						inner join AClasificacion d
							on d.Ecodigo      = a.Ecodigo
							and d.ACid        = a.ACid
							and d.ACcodigo    = a.ACcodigo
						inner join CFuncional e
							 on e.CFid        = a.CFid
						left outer join ClasificacionCFuncional cf
							on  cf.ACid       = a.ACid
							and cf.ACcodigo   = a.ACcodigo
							and cf.CFid       = a.CFid
							and cf.Ocodigo    is null
						left outer join ClasificacionCFuncional xf
							on  xf.ACid       = a.ACid
							and xf.ACcodigo   = a.ACcodigo
							and xf.Ocodigo    = e.Ocodigo
							and xf.Ecodigo    = e.Ecodigo
							and xf.CFid       is null
					where a.Ecodigo     =  #Arguments.Ecodigo#
					  and a.EAcpidtrans = '#Arguments.EAcpidtrans#'
					  and a.EAcpdoc     = '#Arguments.EAcpdoc#'
					  and a.EAcplinea   =  #Arguments.EAcplinea#
					  and b.EAstatus = 1
				</cfquery>
                <cfif isdefined("LvarCRDRidE") and len(LvarCRDRidE)>
                	<cfloop list="#LvarCRDRidE#" index="ICRDRid">
                        <cfinvoke component="sif.Componentes.AF_DocumentoResponsable" method="BajaDocTransito">
                            <cfinvokeargument name="CRDRid" value="#ICRDRid#">
                        </cfinvoke>
                    </cfloop>
                </cfif>
                <cfquery datasource="#session.dsn#">
					delete from CRDocumentoResponsabilidad
					where CRDocumentoResponsabilidad.CRDRid in (
							select a.CRDRid
							from DSActivosAdq a
							where a.Ecodigo     =  #Arguments.Ecodigo#
							  and a.EAcpidtrans = '#Arguments.EAcpidtrans#'
							  and a.EAcpdoc     = '#Arguments.EAcpdoc#'
							  and a.EAcplinea   =  #Arguments.EAcplinea#
							)
				</cfquery>
				<!--- 2.2 Alta de Saldos --->
				<cfif Arguments.debug>
					AFSaldos...<cfdump var="#now()#">
				</cfif>
				<cfquery name="rstemp" datasource="#session.dsn#">
					insert into AFSaldos (
						Ecodigo,
						Aid,
						CFid,
						Ocodigo,
						AFSperiodo,
						AFSmes,
						AFSperiodourev,
						AFSmesurev,
						AFSvutiladq,
						AFSvutilrev,
						AFSsaldovutiladq,
						AFSsaldovutilrev,
						AFSvaladq,
						AFSvalmej,
						AFSvalrev,
						AFSdepacumadq,
						AFSdepacummej,
						AFSdepacumrev,
						AFSmetododep,
						AFSdepreciable,
						AFSrevalua,
						AFCcodigo,
						ACcodigo,
						ACid
					)
					select
						a.Ecodigo,
						c.Aid,
						a.CFid,
						f.Ocodigo,
						#periodo#,
						#Mes#,
						#periodo#,
						#Mes#,
						coalesce(cf.CCFvutil, xf.CCFvutil, e.ACvutil),
						coalesce(cf.CCFvutil, xf.CCFvutil, e.ACvutil),
						coalesce(cf.CCFvutil, xf.CCFvutil, e.ACvutil),
						coalesce(cf.CCFvutil, xf.CCFvutil, e.ACvutil),
						a.DSmonto,
						0.00,
						0.00,
						0.00,
						0.00,
						0.00,
						d.ACmetododep,
						coalesce(cf.CCFdepreciable, xf.CCFdepreciable, case e.ACdepreciable when 'S' then 1 else 0 end),
						coalesce(cf.CCFrevalua, xf.CCFrevalua, case e.ACrevalua when 'S' then 1 else 0 end),
						a.AFCcodigo,
						a.ACcodigo,
						a.ACid
					from DSActivosAdq a
						inner join Activos c
							on  c.Areflin = a.lin
							and c.Ecodigo = a.Ecodigo
							and c.Aplaca = a.DSplaca
						inner join ACategoria d
							on d.Ecodigo   = a.Ecodigo
							and d.ACcodigo = a.ACcodigo
						inner join AClasificacion e
							on e.Ecodigo   = a.Ecodigo
							and e.ACid     = a.ACid
							and e.ACcodigo = a.ACcodigo
						inner join CFuncional f
							on f.CFid = a.CFid
						left outer join ClasificacionCFuncional xf
							on xf.ACid     = a.ACid
							and xf.ACcodigo = a.ACcodigo
							and xf.Ocodigo = f.Ocodigo
							and xf.Ecodigo = f.Ecodigo
							and xf.CFid    is null
						left outer join ClasificacionCFuncional cf
							on cf.CFid = a.CFid
							and cf.Ecodigo = a.Ecodigo
							and cf.ACcodigo = a.ACcodigo
							and cf.ACid     = a.ACid
							and cf.Ocodigo    is null
					where a.Ecodigo     =  #Arguments.Ecodigo#
					  and a.EAcpidtrans = '#Arguments.EAcpidtrans#'
					  and a.EAcpdoc     = '#Arguments.EAcpdoc#'
					  and a.EAcplinea   =  #Arguments.EAcplinea#
				</cfquery>

                <cfquery name="rsSaldosXActualizar" datasource="#session.dsn#">
                    select
                             a.Ecodigo,
                             a.DSplaca,
                             a.CFid,
                             a.DSmonto,
                             e.ACvutil
                        from DSActivosAdq a
                            inner join ACategoria d
                                on d.Ecodigo = a.Ecodigo
                                and d.ACcodigo = a.ACcodigo
                            inner join AClasificacion e
                                on e.Ecodigo = a.Ecodigo
                                and e.ACid = a.ACid
                                and e.ACcodigo = a.ACcodigo
                            inner join CFuncional f
                                on f.Ecodigo = a.Ecodigo
                                and f.CFid = a.CFid
                            left outer join ClasificacionCFuncional xf
                                on xf.ACid     = a.ACid
                                and xf.ACcodigo = a.ACcodigo
                                and xf.Ocodigo = f.Ocodigo
                                and xf.Ecodigo = f.Ecodigo
                                and xf.CFid    is null
                            left outer join ClasificacionCFuncional cf
                                on cf.CFid = a.CFid
                                and cf.Ecodigo = a.Ecodigo
                                and cf.ACcodigo = a.ACcodigo
                                and cf.ACid     = a.ACid
                                and cf.Ocodigo    is null
                    where a.Ecodigo     =  #Arguments.Ecodigo#
                      and a.EAcpidtrans = '#Arguments.EAcpidtrans#'
                      and a.EAcpdoc     = '#Arguments.EAcpdoc#'
                      and a.EAcplinea   =  #Arguments.EAcplinea#
                      and not exists (
                                select 1
                                from Activos a_validate
                                where a_validate.Ecodigo  = a.Ecodigo
                                and a_validate.Aplaca     = a.DSplaca
                                and a_validate.Areflin    = a.lin
                            )
        		</cfquery>
                <cfloop query="rsSaldosXActualizar">
                    <cfquery name="rstemp" datasource="#session.dsn#">
                        Update AFSaldos
                                    set AFSvalmej    = AFSvalmej 		+ #rsSaldosXActualizar.DSmonto#,
                                    AFSvutiladq      = AFSvutiladq 		+ case AFSsaldovutiladq when 0 then #rsSaldosXActualizar.ACvutil# else 0 end,
                                    AFSsaldovutiladq = AFSsaldovutiladq + case AFSsaldovutiladq when 0 then #rsSaldosXActualizar.ACvutil# else 0 end,
                                    AFSvutilrev 	 = AFSvutilrev 		+ case AFSsaldovutiladq when 0 then #rsSaldosXActualizar.ACvutil# else 0 end,
                                    AFSsaldovutilrev = AFSsaldovutilrev + case AFSsaldovutiladq when 0 then #rsSaldosXActualizar.ACvutil# else 0 end
                        where  	Ecodigo 		= #rsSaldosXActualizar.Ecodigo#
                                and Aid 		= (select max(c.Aid) from Activos c
                                                    where c.Ecodigo = #rsSaldosXActualizar.Ecodigo#
                                                    and   c.Aplaca =  '#rsSaldosXActualizar.DSplaca#')
                                and AFSperiodo 	= #periodo#
                                and AFSmes     	= #Mes#
                                and CFid	   	= #rsSaldosXActualizar.CFid#
                    </cfquery>
                </cfloop>

			<!--- C O N T A B I L I Z A R  A D Q U I S I C I O N --->

			<cfif Arguments.Contabilizar>
				<cfset Lvar_Doc = LvarNumDoc>
				<cfset Lvar_Ref = 'AQ'>
                 <!--- Obtiene la auxiliar a partir del periodo / mes --->
                 <cfif preActivos.recordcount gt 0>
	                 <cfinvoke component="sif.Componentes.AF_ValidarActivo" method="fnGetFechas" Parametro3805="0" FechaAdquisicionCxP="#preActivos.DSfechainidep#" returnvariable="LvarArrayFechas">
                 <cfelse>
	                 <cfinvoke component="sif.Componentes.AF_ValidarActivo" method="fnGetFechas" Parametro3805="0" FechaAdquisicionCxP="19000101" returnvariable="LvarArrayFechas">
                 </cfif>

                <cfset FechaAux 		= LvarArrayFechas[1]><!--- Fecha auxiliar--->

				<!--- 3. Genera Asiento --->
				<!--- 3.1 Crea tabla temportal TAG para crear tablas temporales, devuelve un string con el nombre de la tabla creada en la variable "temp_table"--->
				<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="CreaIntarc" returnvariable="INTARC"></cfinvoke>

				<!--- 3.2 Débito Cuenta de Aquisición --->
				<cfquery name="rstemp" datasource="#session.dsn#">
					insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Ocodigo, CFid,
											Mcodigo, INTMOE, INTCAM, INTMON)
					select
							'AFAQ',
							1,
							'#Lvar_Doc#',
							'#Lvar_Ref#',
							'D',
							<cf_dbfunction name="concat" args="'Adquisición de Activo ',D.DSplaca">,
	                        '#DateFormat(FechaAux,'YYYYMMDD')#', <!---INTFEC type="varchar(8)"--->
							#periodo#,
							#Mes#,
							c.ACcadq,
							cf.Ocodigo,
                            D.CFid,
						<cfif not #LvarAplicarEnMonedaExtranjera#>
							#Monloc#,
							round(1.0 * D.DSmonto,2),
							<!--- round(round(1.0 * D.DSmonto/E.EAtipocambio,2) * E.EAtipocambio,2), --->
							1.00,
						<cfelse>
							E.Mcodigo,
							round(1.0 * D.DSmonto/E.EAtipocambio,2),
							E.EAtipocambio,
						</cfif>
							round(round(1.0 * D.DSmonto/E.EAtipocambio,2) * E.EAtipocambio,2) as INTMON
					from EAadquisicion E
						inner join DSActivosAdq D
							inner join AClasificacion c
								on c.Ecodigo   = D.Ecodigo
								and c.ACid     = D.ACid
								and c.ACcodigo = D.ACcodigo
							inner join CFuncional cf
								on cf.CFid = D.CFid
							 on E.Ecodigo 	   = D.Ecodigo
							and E.EAcpidtrans  = D.EAcpidtrans
							and E.EAcpdoc 	   = D.EAcpdoc
							and E.EAcplinea    = D.EAcplinea
					where E.Ecodigo     =  #Arguments.Ecodigo#
					  and E.EAcpidtrans = '#Arguments.EAcpidtrans#'
					  and E.EAcpdoc     = '#Arguments.EAcpdoc#'
					  and E.EAcplinea   =  #Arguments.EAcplinea#
				</cfquery>

				<cfif (Arguments.AstInter)>
					<!--- 3.3 Crédito con la cuenta por pagar intercompañía --->
					<cfif Arguments.EmpresaDt neq Arguments.Ecodigo>

						<cfset Lvalor_empresa = Arguments.Ecodigo>

							<cfquery name="rsCxPInter" datasource="#session.dsn#">
								Select cf.Ccuenta
								from CIntercompany ic
										inner join CFinanciera cf
											on cf.CFcuenta = ic.CFcuentacxp

								where ic.Ecodigo     = #Lvalor_empresa#
								  and ic.Ecodigodest = #Arguments.EmpresaDt#
							</cfquery>

							<cfif rsCxPInter.recordcount eq 0>
								<cf_errorCode	code = "50892" msg = "No hay una cuenta x pagar intercompañía definida entre la empresa origen y la empresa destino">
							</cfif>

							<cfset ccuenta_cxp = rsCxPInter.Ccuenta>

							<!--- Cuenta x Cobrar Intercompañía--->
							<cfquery name="rstemp" datasource="#session.dsn#">
							insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Ocodigo, CFid,
													Mcodigo, INTMOE, INTCAM, INTMON)
							select
									'AFAQ',
									1,
									'#Lvar_Doc#',
									'#Lvar_Ref#',
									'C',
									<cf_dbfunction name="concat" args="'Cuenta por Pagar Intercompañía - Placa: ',D.DSplaca">,
                                    '#DateFormat(FechaAux,'YYYYMMDD')#', <!---INTFEC type="varchar(8)"--->
									#periodo#,
									#Mes#,
									#ccuenta_cxp#,
									cf.Ocodigo,
                                    D.CFid,

									E.Mcodigo,
									round(1.0 * D.DSmonto/E.EAtipocambio,2),
									E.EAtipocambio,
									round(round(1.0 * D.DSmonto/E.EAtipocambio,2) * E.EAtipocambio,2)
							from EAadquisicion E
								inner join DSActivosAdq D
									inner join AClasificacion c
										on c.Ecodigo   = D.Ecodigo
										and c.ACid     = D.ACid
										and c.ACcodigo = D.ACcodigo
									inner join CFuncional cf
										on cf.CFid = D.CFid
									 on E.Ecodigo 	   = D.Ecodigo
									and E.EAcpidtrans  = D.EAcpidtrans
									and E.EAcpdoc 	   = D.EAcpdoc
									and E.EAcplinea    = D.EAcplinea
							where E.Ecodigo     =  #Arguments.Ecodigo#
							  and E.EAcpidtrans = '#Arguments.EAcpidtrans#'
							  and E.EAcpdoc     = '#Arguments.EAcpdoc#'
							  and E.EAcplinea   =  #Arguments.EAcplinea#
							</cfquery>
						<cfelse>
							<cf_errorCode	code = "50893" msg = "No es posible adquirir activos cuando la empresa origen y la empresa destino son iguales. Proceso Cancelado">
						</cfif>
				<cfelse>
					<!--- 3.3a Crédito a CxP: Cuenta Transito --->
					<cfquery name="rstemp" datasource="#session.dsn#">
						insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Ocodigo,
												Mcodigo, INTMOE, INTCAM, INTMON,CFid)
						select
								'AFAQ',
								1,
								'#Lvar_Doc#',
								'#Lvar_Ref#',
								'C',
								'Activos en Tránsito ',
								'#DateFormat(FechaAux,'YYYYMMDD')#',
								#periodo#,
								#Mes#,
								#CuentaActivos#,
								E.Ocodigo,
								min(E.Mcodigo) as Mcodigo,
								sum(round(1.0 * D.DSmonto/E.EAtipocambio,2)) as MonOri,
								min(E.EAtipocambio) as TC,
								sum(round(round(1.0 * D.DSmonto/E.EAtipocambio,2) * E.EAtipocambio,2)) as Monto,
                                D.CFid
						from EAadquisicion E
							inner join DAadquisicion da
								 on E.Ecodigo 	   = da.Ecodigo
								and E.EAcpidtrans  = da.EAcpidtrans
								and E.EAcpdoc 	   = da.EAcpdoc
								and E.EAcplinea    = da.EAcplinea
                             inner join DSActivosAdq D
                                 on D.Ecodigo 	   = da.Ecodigo
                                and D.EAcpidtrans  = da.EAcpidtrans
                                and D.EAcpdoc 	   = da.EAcpdoc
                                and D.EAcplinea    = da.EAcplinea
                                and D.DAlinea 	   = da.DAlinea
						where E.Ecodigo     =  #Arguments.Ecodigo#
						  and E.EAcpidtrans = '#Arguments.EAcpidtrans#'
						  and E.EAcpdoc     = '#Arguments.EAcpdoc#'
						  and E.EAcplinea   =  #Arguments.EAcplinea#
						  and E.EAstatus = 1
						  and da.CFcuenta is null
						group by E.Ocodigo, D.CFid
						<!--- Aunque solo hay una cuenta, se necesita group by para que de CERO registros --->
					</cfquery>
					<!--- 3.3b Crédito a CxP: Cuenta Inversion --->
					<cfquery name="rstemp" datasource="#session.dsn#">
						insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, CFcuenta, Ccuenta, Ocodigo,
								Mcodigo, INTMOE, INTCAM, INTMON,CFid)
						select
								'AFAQ',
								1,
								'#Lvar_Doc#',
								'#Lvar_Ref#',
								'C',
								min(E.EAdescripcion),
								'#DateFormat(FechaAux,'YYYYMMDD')#',
								#periodo#,
								#Mes#,
								da.CFcuenta, 0,
								min(E.Ocodigo),

								min(E.Mcodigo),
								sum(round(1.0 * D.DSmonto/E.EAtipocambio,2)),
								min(E.EAtipocambio),
								sum(round(round(1.0 * D.DSmonto/E.EAtipocambio,2) * E.EAtipocambio,2)),
                                D.CFid
						from EAadquisicion E
							inner join DAadquisicion da
								 on E.Ecodigo 	   = da.Ecodigo
								and E.EAcpidtrans  = da.EAcpidtrans
								and E.EAcpdoc 	   = da.EAcpdoc
								and E.EAcplinea    = da.EAcplinea
                            inner join DSActivosAdq D
                                 on D.Ecodigo 	   = da.Ecodigo
                                and D.EAcpidtrans  = da.EAcpidtrans
                                and D.EAcpdoc 	   = da.EAcpdoc
                                and D.EAcplinea    = da.EAcplinea
                                and D.DAlinea 	   = da.DAlinea
						where E.Ecodigo     =  #Arguments.Ecodigo#
						  and E.EAcpidtrans = '#Arguments.EAcpidtrans#'
						  and E.EAcpdoc     = '#Arguments.EAcpdoc#'
						  and E.EAcplinea   =  #Arguments.EAcplinea#
						  and E.EAstatus 	= 1
						  and da.CFcuenta is not null
						  group by da.CFcuenta, D.CFid
					</cfquery>

					<!--- 3.4 Balance Moneda --->
					<cfif not #LvarAplicarEnMonedaExtranjera#>
								<cfquery name="rsSQL" datasource="#session.dsn#">
									select sum(round(a.DSmonto,2)) as TotalLocal
									  from DSActivosAdq a
									 where a.Ecodigo     =  #Arguments.Ecodigo#
									   and a.EAcpidtrans = '#Arguments.EAcpidtrans#'
									   and a.EAcpdoc     = '#Arguments.EAcpdoc#'
									   and a.EAcplinea   =  #Arguments.EAcplinea#
								</cfquery>

								<cfquery name="rstemp" datasource="#session.dsn#">
									insert into #INTARC# (
											INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Ocodigo,
											Mcodigo, INTMOE, INTCAM, INTMON)
									select
											'AFAQ',
											1,
											'#Lvar_Doc#',
											'#Lvar_Ref#',
											'D',
											'Balance Moneda ',
											'#DateFormat(FechaAux,'YYYYMMDD')#',
											#periodo#,
											#Mes#,
											<cf_dbfunction name="to_number" datasource="#session.dsn#" args="a.Pvalor">,
											b.Ocodigo,

											b.Mcodigo,
											b.EAtotalori,
											b.EAtipocambio,
											round(#rsSQL.TotalLocal#,2)

									from EAadquisicion b, Parametros a
									where b.Ecodigo     =  #Arguments.Ecodigo#
									  and b.EAcpidtrans = '#Arguments.EAcpidtrans#'
									  and b.EAcpdoc     = '#Arguments.EAcpdoc#'
									  and b.EAcplinea   =  #Arguments.EAcplinea#
									  and b.EAstatus = 1
									  and b.Mcodigo <> #Monloc#
									  and b.Ecodigo = a.Ecodigo
									  and a.Pcodigo = 200
								</cfquery>
								<cfquery name="rstemp" datasource="#session.dsn#">
									insert into #INTARC# (
											INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Ocodigo,
											Mcodigo, INTMOE, INTCAM, INTMON)
									select
											'AFAQ',
											1,
											'#Lvar_Doc#',
											'#Lvar_Ref#',
											'C',
											'Balance Moneda ',
											'#DateFormat(FechaAux,'YYYYMMDD')#',
											#periodo#,
											#Mes#,
											<cf_dbfunction name="to_number" datasource="#session.dsn#" args="a.Pvalor">,
											b.Ocodigo,

											#Monloc#,
											round(#rsSQL.TotalLocal#,2),
											1,
											round(#rsSQL.TotalLocal#,2)

									from EAadquisicion b, Parametros a
									where b.Ecodigo     = #Arguments.Ecodigo#
									  and b.EAcpidtrans = '#Arguments.EAcpidtrans#'
									  and b.EAcpdoc     = '#Arguments.EAcpdoc#'
									  and b.EAcplinea   = #Arguments.EAcplinea#
									  and b.EAstatus = 1
									  and b.Mcodigo <> #Monloc#
									  and b.Ecodigo = a.Ecodigo
									  and a.Pcodigo = 200
								</cfquery>
					</cfif> <!---End del balance--->

				</cfif>

				<!--- Obtiene la minima oficina para la empresa. (La oficina se le manda al genera asiento para que agrupe) --->
				<cfquery name="rsMinOficina" datasource="#session.dsn#">
					Select Min(Ocodigo) as MinOcodigo
					from Oficinas
					where Ecodigo = #Arguments.Ecodigo#
				</cfquery>
				<cfif isdefined("rsMinOficina") and rsMinOficina.recordcount GT 0>
					<cfset LvarOcodigo = rsMinOficina.MinOcodigo>
				<cfelse>
					<cfset LvarOcodigo = -100>
				</cfif>

				<!--- 3.5 Genera Asiento --->
				<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="res_GeneraAsiento">
					<cfinvokeargument name="Ecodigo" value="#Arguments.Ecodigo#"/>
					<cfinvokeargument name="Oorigen" value="AFAQ"/>
					<cfinvokeargument name="Eperiodo" value="#Periodo#"/>
					<cfinvokeargument name="Emes" value="#Mes#"/>
					<cfinvokeargument name="Efecha" value="#FechaAux#"/>
					<cfinvokeargument name="Edescripcion" value="#descripcion#"/>
					<cfinvokeargument name="Edocbase" value="#Lvar_Doc#"/>
					<cfinvokeargument name="Ereferencia" value="#Lvar_Ref#"/>
					<cfinvokeargument name="Ocodigo" value="#LvarOcodigo#"/>
					<cfinvokeargument name="Debug" value="#Arguments.Debug#"/>
					<cfinvokeargument name="NAP" value="0"/> <!---Para que no Afecte presupuesto--->
				</cfinvoke>
			</cfif><!--- Fin del if Arguments.Contabilizar --->
			<cfif isdefined("res_GeneraAsiento") or Arguments.IDcontable GT 0>
				<cfquery name="rstemp" datasource="#session.dsn#">
					update TransaccionesActivos
					set IDcontable =
						<cfif isdefined("res_GeneraAsiento")>
							#res_GeneraAsiento#
						<cfelseif Arguments.IDcontable GT 0>
							#Arguments.IDcontable#
						</cfif>
					where Ecodigo = #Arguments.Ecodigo#
					and AGTPid    = #rs_agtp_insert.identity#
				</cfquery>
			</cfif>

			<!--- 4. Actualizar estado de la relación a Terminada --->
			<cfquery name="rstemp" datasource="#session.dsn#">
				update EAadquisicion set EAstatus = 2
				where Ecodigo     = #Arguments.Ecodigo#
				  and EAcpidtrans = '#Arguments.EAcpidtrans#'
				  and EAcpdoc     = '#Arguments.EAcpdoc#'
				  and EAcplinea   = #Arguments.EAcplinea#
				  and EAstatus = 1
			</cfquery>
			<cfif Arguments.Debug>
				Fin...<cfdump var="#now()#">
				<cf_abort errorInterfaz="">
			</cfif>
		<cfreturn 1>
	</cffunction>
</cfcomponent>
