<cfinclude template="FnScripts.cfm">


	<!--- Obtiene las Cuentas de Mayor que no existen o que no estan vigentes --->
	<cfquery  name="rsImportador" datasource="#session.dsn#">
		select distinct <cf_dbfunction name='sPart' args='t.CFformato,1,4'> as Cmayor, 
	                  
        	   cm.Cmayor as CmayorExiste
		  from #table_name# t
			left outer join CtasMayor cm
				 on cm.Ecodigo = #session.Ecodigo#
				and cm.Cmayor = substring(t.CFformato,1,4)
		 where NOT EXISTS
			(
				select 1
				  from CPVigencia vg
				 where vg.Ecodigo = #session.Ecodigo#
				   and vg.Cmayor = <cf_dbfunction name='sPart' args='t.CFformato,1,4'>
				   and #dateformat(now(),"YYYYMM")# between vg.CPVdesdeAnoMes and vg.CPVhastaAnoMes
			)
	</cfquery>
	<cfloop query="rsImportador">
		<cfif rsImportador.CmayorExiste EQ "">
			<cfset LvarError = sbError ("FATAL", "Cuenta Mayor '#rsImportador.Cmayor#' no existe")>
		<cfelse>
			<cfset LvarError = sbError ("FATAL", "Cuenta Mayor '#rsImportador.Cmayor#' no esta vigente")>
		</cfif>
	</cfloop>


	<!--- Obtiene las Cuentas de Mayor sin Mascara --->
	<!--- Se deben procesar de padres a hijas y los padres deben existir para incluir una hija --->
	<cfquery  name="rsMayoresSinMascara" datasource="#session.dsn#">
		select substring(t.CFformato,1,4) as Cmayor, vg.CPVformatoF, vg.CPVid
		  from #table_name# t
			inner join CPVigencia vg
				 on vg.Ecodigo = #session.Ecodigo#
				and vg.Cmayor = <cf_dbfunction name='sPart' args='t.CFformato,1,4'>
				and #dateformat(now(),"YYYYMM")# between vg.CPVdesdeAnoMes and vg.CPVhastaAnoMes
				and vg.PCEMid IS NULL
	  order by CFformato asc
	</cfquery>

	<cfset LvarCmayorAnt = "">
	<cfloop query="rsMayoresSinMascara">
		<cfif LvarCmayorAnt NEQ rsMayoresSinMascara.Cmayor>
			<cfset LvarCmayorAnt = rsMayoresSinMascara.Cmayor>
			<cfset LvarError = sbError ("FATAL", "Cuenta Mayor '#rsMayoresSinMascara.Cmayor#' no tiene máscara. No se ha implementado esta importación")>
		</cfif>
	</cfloop>

	<cfif rsMayoresSinMascara.recordCount GT 0>
		<cfset ERR = fnVerificaErrores()>
		<cfexit>
	</cfif>


	<!--- Obtiene las Cuentas de Mayor con Mascara (Con o Sin Plan de Cuentas) --->
	<!--- Se deben procesar de hijas a padres y los padres no son obligatorios --->
	<cfquery  name="rsImportador" datasource="#session.dsn#">
		select substring(t.CFformato,1,4) as Cmayor, m.PCEMformato, m.PCEMformatoC, m.PCEMformatoP, 
				CFformato, CFmovimiento, Cbalancen, CFdescripcion, CPVid
		  from #table_name# t
			inner join CPVigencia vg
					inner join PCEMascaras m
						on m.PCEMid = vg.PCEMid
				 on vg.Ecodigo = #session.Ecodigo#
				and vg.Cmayor = substring(t.CFformato,1,4)
				and #dateformat(now(),"YYYYMM")# between vg.CPVdesdeAnoMes and vg.CPVhastaAnoMes
				and vg.PCEMid IS NOT NULL
	  order by CFformato desc
	</cfquery>
	<cfset LvarResultado = "">
	<cfset LvarCFformatoAnt = "">

	<cfset session.Importador.SubTipo = "2">
    
	<cfloop query="rsImportador">
		<cfset session.Importador.Avance = rsImportador.currentRow/rsImportador.recordCount>

		<cfset LvarCFformato = trim(rsImportador.CFformato)>
		<cfset LvarCFmascara = rsImportador.PCEMformato>
		<cfset LvarCCmascara = rsImportador.PCEMformatoC>
		<cfset LvarCPmascara = rsImportador.PCEMformatoP>
		<!--- Ignorar el Registro cuando la cuenta viene en blanco o la cuenta hija tuvo error o se repite la cuenta --->
		<cfif 	NOT (
					LvarCFformato EQ "" OR 
					LvarCFformato EQ LvarCFformatoAnt OR 
					(LvarCFformato EQ mid(LvarCFformatoAnt,1,len(LvarCFformato)) AND LvarIgnorar)
					)
		>
			<cfset LvarIgnorar = false>
			<cfif len(LvarCFformato) GT len(LvarCFmascara)>
				<cfset LvarIgnorar = true>
				<cfset LvarError = sbError ("FATAL", "Error en Cuenta Financiera '#LvarCFformato#'. La longitud de la Cuenta es Mayor a la Mascara asociada a la Cuenta Mayor, '#LvarCFmascara#'")>
			<cfelseif len(LvarCFformato) EQ len(LvarCFmascara)>
				<cfif rsImportador.CFmovimiento NEQ 'S'>
					<cfset LvarIgnorar = true>
					<cfset LvarError = sbError ("FATAL", "Error en Cuenta Financiera '#LvarCFformato#'. La cuenta debe ser de último nivel para aceptar Movimientos")>
				<cfelseif rsImportador.Cbalancen NEQ 'C' AND rsImportador.Cbalancen NEQ 'D' AND rsImportador.Cbalancen NEQ 'M'>
					<cfset LvarIgnorar = true>
					<cfset LvarError = sbError ("FATAL", "Error en Cuenta Financiera '#LvarCFformato#'. La cuenta debe tener un balance normal C=Credito, D=Debito, o M=igual a la mayor")>
				</cfif>
			<cfelse>
				<cfif rsImportador.CFmovimiento NEQ 'N'>
					<cfset LvarIgnorar = true>
					<cfset LvarError = sbError ("FATAL", "Error en Cuenta Financiera '#LvarCFformato#'. La longitud de la Cuenta es Menor a la Mascara asociada a la Cuenta Mayor, no puede aceptar Movimientos")>
				</cfif>
			</cfif>
			
			<cfset LvarCFformatoAnt = LvarCFformato>
            
			<cfif NOT LvarIgnorar>
				<cfif rereplace(LvarCFformato,"[^-]","X","ALL") NEQ mid(LvarCFmascara,1,len(LvarCFformato))>
					<cfset LvarIgnorar = true>
					<cfset LvarError = sbError ("FATAL", "Error en Cuenta Financiera '#LvarCFformato#'. El formato de la Cuenta no corresponde a la Mascara asociada a la Cuenta Mayor, '#LvarCFmascara#'")>
				<cfelse>
					<cfif rsImportador.CFmovimiento EQ 'S'>
						<cfinvoke 
						 component="sif.Componentes.PC_GeneraCuentaFinanciera"
						 method="fnGeneraCuentaFinanciera"
						 returnvariable="LvarResultado">
							<cfinvokeargument name="Lprm_CFformato" value="#LvarCFformato#"/>
							<cfinvokeargument name="Lprm_fecha" value="#now()#"/>
							<cfinvokeargument name="Lprm_Ocodigo" value="0"/>
						
							<cfinvokeargument name="Lprm_EsDePresupuesto" value="false"/>
							<cfinvokeargument name="Lprm_CrearConPlan" value="true"/>
							<cfinvokeargument name="Lprm_CrearSinPlan" value="true"/>
							<cfinvokeargument name="Lprm_Cdescripcion" value="#rsImportador.CFdescripcion#"/>
							<cfif rsImportador.Cbalancen NEQ "M">
								<cfinvokeargument name="Lprm_Cbalancen" value="#rsImportador.Cbalancen#"/>
							</cfif>
							<cfinvokeargument name="Lprm_TransaccionActiva" value="no"/>
						</cfinvoke>
						
						<cfif LvarResultado EQ "OLD">
							<cfset LvarError = sbError ("INFO", "Cuenta Financiera '#LvarCFformato#' ya existe, se ignora el registro")>
						<cfelseif LvarResultado NEQ "NEW">
							<cfset LvarIgnorar = true>
							<cfset LvarError = sbError ("FATAL", "Error en Cuenta Financiera '#LvarCFformato#'. #LvarResultado#")>
						</cfif>
					</cfif>
					
					<cfif rsImportador.CFmovimiento NEQ 'S' OR LvarResultado EQ "OLD">
						<cfquery  name="rsSQL" datasource="#session.dsn#">
							select CFcuenta, CFdescripcion
							  from CFinanciera
							 where Ecodigo 		= #session.Ecodigo#
							   and Cmayor  		= '#rsImportador.Cmayor#'
							   and CPVid		= #rsImportador.CPVid#
							   and CFformato	= '#LvarCFformato#'
						</cfquery>
						<cfif rsSQL.recordCount EQ 0>
							<cfset LvarIgnorar = true>
							<cfset LvarError = sbError ("FATAL", "Cuenta Financiera '#LvarCFformato#' no existe")>
						<cfelse>
							<cfquery  name="rsSQL" datasource="#session.dsn#">
								update CFinanciera
								<cfif rsImportador.CFdescripcion EQ rsSQL.CFdescripcion>
								   set CFdescripcionF = null
								<cfelse>
								   set CFdescripcionF = '#trim(rsImportador.CFdescripcion)#'
								</cfif>
								 where CFcuenta = #rsSQL.CFcuenta#
							</cfquery>
							<cfif LvarCFmascara EQ LvarCCmascara>
								<cfquery  name="rsSQL" datasource="#session.dsn#">
									select Ccuenta, Cdescripcion
									  from CContables
									 where Ecodigo 		= #session.Ecodigo#
									   and Cmayor  		= '#rsImportador.Cmayor#'
									   and Cformato		= '#LvarCFformato#'
								</cfquery>
								<cfif rsSQL.recordCount EQ 0>
									<cfset LvarIgnorar = true>
									<cfset LvarError = sbError ("FATAL", "Cuenta Contable '#LvarCFformato#' no existe")>
								<cfelse>
									<cfquery  name="rsSQL" datasource="#session.dsn#">
										update CContables
										<cfif rsImportador.CFdescripcion EQ rsSQL.Cdescripcion>
										   set CdescripcionF = null
										<cfelse>
										   set CdescripcionF = '#trim(rsImportador.CFdescripcion)#'
										</cfif>
										 where Ccuenta = #rsSQL.Ccuenta#
									</cfquery>
								</cfif>
							</cfif>
							<cfif LvarCFmascara EQ LvarCPmascara>
								<cfquery  name="rsSQL" datasource="#session.dsn#">
									select CPcuenta, CPdescripcion
									  from CPresupuesto
									 where Ecodigo 		= #session.Ecodigo#
									   and Cmayor  		= '#rsImportador.Cmayor#'
									   and CPVid		= #rsImportador.CPVid#
									   and CPformato	= '#LvarCFformato#'
								</cfquery>
								<cfif rsSQL.recordCount EQ 0>
									<cfset LvarIgnorar = true>
									<cfset LvarError = sbError ("FATAL", "Cuenta Presupuesto '#LvarCFformato#' no existe")>
								<cfelse>
									<cfquery  name="rsSQL" datasource="#session.dsn#">
										update CPresupuesto
										<cfif rsImportador.CFdescripcion EQ rsSQL.CPdescripcion OR rsImportador.CFdescripcion EQ "">
										   set CPdescripcionF = null
										<cfelse>
										   set CPdescripcionF = '#trim(rsImportador.CFdescripcion)#'
										</cfif>
										 where CPcuenta = #rsSQL.CPcuenta#
									</cfquery>
								</cfif>
							</cfif>
						</cfif>
					</cfif>
				</cfif>
			</cfif>
		</cfif>
	</cfloop>
	<cfset ERR = fnVerificaErrores()>
