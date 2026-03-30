<!---
 L  NOMBRE			TIPO			DESCRIPCION
 1  CPCano  		int				Año Inicial Período Presupuesto  int  0    
 2  CPCmes  		int				Mes Inicial Período Presupuesto  int  0    
 3  CPformato  		varchar(100)	Cuenta Vinculada      
 3  CPdescripcion	varchar(40)		Descripcion Cuenta Vinculada      
 4  CPCVporcentaje	float 			Porcentaje del total de padres (1-100)  float  0    
 5  CPformatoPadre	varchar(100)	Cuenta Padre
 --->
 
<cfset session.Importador.SubTipo = "1">
<!--- Obtiene el Periodo --->
<cfquery  name="rsCPP" datasource="#session.dsn#">
	select count(distinct CPCano*100+CPCmes) as cantidad,
			min(CPCano*100+CPCmes) as CPCanoMes
	  from #table_name# t
	 where CPCano is not null and CPCmes is not null
</cfquery>
<cfif rsCPP.Cantidad GT 1>
	<cf_errorCode	code = "50477" msg = "Existen mas de un Mes de Presupuesto Inicial en el Archivo de Importacion">
<cfelseif rsCPP.Cantidad EQ 0>
	<cf_errorCode	code = "50478" msg = "No se indicó el Mes de Presupuesto Inicial en el Archivo de Importacion">
</cfif>
<cfset LvarAnoMes = rsCPP.CPCanoMes>
<cfif isdefined("session.CPPid")>
	<cfset LvarCPPid = session.CPPid>
	<cfquery  name="rsCPP" datasource="#session.dsn#">
		select CPPid, CPPestado, CPPanoMesDesde, CPPanoMesHasta
		  from CPresupuestoPeriodo
		 where CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCPPid#">
	</cfquery>
	<cfif LvarAnoMes EQ rsCPP.CPPanoMesDesde>
		<cf_errorCode	code = "50479"
						msg  = "El Mes de Presupuesto Inicial en el Archivo de Importacion '@errorDat_1@-@errorDat_2@' no corresponde con el mes inicial del Período de Presupuesto indicado '@errorDat_3@-@errorDat_4@'"
						errorDat_1="#mid(LvarAnoMes,1,4)#"
						errorDat_2="#mid(LvarAnoMes,5,2)#"
						errorDat_3="#mid(rsCPP.CPPanoMesDesde,1,4)#"
						errorDat_4="#mid(rsCPP.CPPanoMesDesde,5,2)#"
		>
	</cfif>
<cfelse>
	<cfquery  name="rsCPP" datasource="#session.dsn#">
		select CPPid, CPPestado, CPPanoMesDesde, CPPanoMesHasta
		  from CPresupuestoPeriodo
		 where Ecodigo = #session.Ecodigo#
		   and CPPanoMesDesde = #rsCPP.CPCanoMes#
	</cfquery>
	<cfif rsCPP.CPPid NEQ "">
		<cf_errorCode	code = "50480"
						msg  = "No existe ningún Período de Presupuesto que incie con el Mes de Presupuesto Inicial en el Archivo de Importacion '@errorDat_1@-@errorDat_2@'"
						errorDat_1="#mid(LvarAnoMes,1,4)#"
						errorDat_2="#mid(LvarAnoMes,5,2)#"
		>
	</cfif>
	<cfset LvarCPPid = rsCPP.CPPid>
</cfif>
<cfif rsCPP.CPPestado EQ "2">
	<cf_errorCode	code = "50481" msg = "El Período de Presupuesto ya esta cerrado, no se puede modificar">
</cfif>
<cfset LvarResultado = "">
<cfset LvarCPformatoAnt = "">
<cfset LvarCPCVporcentajeAnt = "">

<cfquery  name="rsImportador" datasource="#session.dsn#">
	select distinct CPformato as CPformato
	  from #table_name# t
	 where CPformato is not null
UNION
	select CPformatoPadre as CPformato
	  from #table_name# t
	 where CPformatoPadre is not null
</cfquery>

<cfset LvarCtasMalas = ArrayNew(2)>
<cfset LvarCtasMalasI = 0>
<cfset session.Importador.SubTipo = "2">
<cfloop query="rsImportador">
	<cfset session.Importador.Avance = rsImportador.currentRow/rsImportador.recordCount>
	<cfinvoke 
	 component="sif.Componentes.PC_GeneraCuentaFinanciera"
	 method="fnGeneraCuentaFinanciera"
	 returnvariable="LvarMSG">
		<cfinvokeargument name="Lprm_CFformato" value="#rsImportador.CPformato#"/>
		<cfinvokeargument name="Lprm_fecha" value="#now()#"/>
		<cfinvokeargument name="Lprm_Ocodigo" value="0"/>
		<cfinvokeargument name="Lprm_Cdescripcion" value="x"/>
		<cfinvokeargument name="Lprm_CrearPresupuesto" value="true"/>
		<cfinvokeargument name="Lprm_CPPid" value="#LvarCPPid#"/>
		<cfinvokeargument name="Lprm_CVPtipoControl" value="0"/>
		<cfinvokeargument name="Lprm_CVPcalculoControl" value="1"/>
		<cfinvokeargument name="Lprm_SoloVerificar" value="yes"/>
		<cfinvokeargument name="Lprm_TransaccionActiva" value="no"/>
	</cfinvoke>
	<cfif LvarMSG NEQ 'OLD' AND LvarMSG NEQ 'NEW'>
		<cfset LvarCtasMalasI = LvarCtasMalasI + 1>
		<cfset LvarCtasMalas[LvarCtasMalasI][1] = rsImportador.CPformato>
		<cfset LvarCtasMalas[LvarCtasMalasI][2] = LvarMSG>
	</cfif>
</cfloop>
	
<cftransaction>
	<cfinclude template="FnScripts.cfm">
	<cfif LvarCtasMalasI>
		<cfloop index="i" from="1" to="#LvarCtasMalasI#">
			<cfset sbError ("FATAL", "Cuenta '#LvarCtasMalas[i][1]#': #LvarCtasMalas[i][2]#")>
		</cfloop>
	</cfif>

	<cfquery  name="rsImportador" datasource="#session.dsn#">
		select *
		  from #table_name# t
	</cfquery>
	<cfif rsImportador.CPformato EQ "">
		<cf_errorCode	code = "50482" msg = "No se indicó el formato de la primera Cuenta Vinculada">
	</cfif>
	<cfif rsImportador.CPCVporcentaje EQ "">
		<cf_errorCode	code = "50483" msg = "No se indicó el porcentaje de la primera Cuenta Vinculada">
	</cfif>

	<cfset LvarCPCVid = -1>
	<cfset session.Importador.SubTipo = "2">
	<cfloop query="rsImportador">
		<cfset session.Importador.Avance = rsImportador.currentRow/rsImportador.recordCount>

		<cfset LvarCPformato 		= trim(rsImportador.CPformato)>
		<cfset LvarCPdescripcion	= trim(rsImportador.CPdescripcion)>
		<cfset LvarCPCVporcentaje 	= rsImportador.CPCVporcentaje>
		<cfset LvarCPformatoPadre	= trim(rsImportador.CPformatoPadre)>

		<cfif 	LvarCPformatoAnt 		EQ "" 
			OR	(LvarCPformatoAnt 		NEQ LvarCPformato 		AND LvarCPformato 		NEQ "")
			OR	(LvarCPCVporcentajeAnt	NEQ LvarCPCVporcentaje	AND LvarCPCVporcentaje 	NEQ "")
		>
			<cfif LvarCPformatoAnt NEQ LvarCPformato AND LvarCPformato NEQ "">
				<cfif LvarCPCVporcentaje EQ "">
					<cfset sbError ("FATAL", "No se indicó el Porcentaje para la Cuenta Vinculada '#LvarCPformato#'")>
					<cfset LvarCPCVporcentaje = 0>
				</cfif>
				<cfset LvarCPformatoAnt	= LvarCPformato>
			<cfelse>
				<cfset LvarCPformato = LvarCPformatoAnt>
			</cfif>
			<cfset LvarCPCVporcentajeAnt = LvarCPCVporcentaje>

			<cfif LvarCPCVporcentaje LTE 0 or LvarCPCVporcentaje GT 100>
				<cfset sbError ("FATAL", "El Porcentaje '#numberFormat(LvarCPCVporcentaje,'9.99')#%' para la Cuenta Vinculada '#LvarCPformato#' no está entre 0.01% y 100.00%")>
			</cfif>
			<cfif LvarCPdescripcion EQ "">
				<cfset LvarCPdescripcion = "Cuenta vinculada #LvarCPformato# con #numberFormat(LvarCPCVporcentaje,'9.99')#%">
			</cfif>

			<cfquery  name="rsSQL" datasource="#session.dsn#">
				select CPCVid
				  from CPCtaVinculada
				 where Ecodigo 		= #session.Ecodigo#
				   and CPPid  		= #LvarCPPid#
				   and CPformato	= '#LvarCPformato#'
			</cfquery>
			<cfif rsSQL.CPCVid NEQ "">
				<cfset sbError ("INFO", "Cuenta Vinculada '#LvarCPformato#' ya existe, se sustituyen sus padres y su porcentaje")>
				<cfquery datasource="#session.dsn#">
					delete from CPCtaVinculadaPadres
					 where CPCVid = #rsSQL.CPCVid#
				</cfquery>
				<cfquery datasource="#session.dsn#">
					delete from CPCtaVinculada
					 where CPCVid = #rsSQL.CPCVid#
				</cfquery>
			</cfif>
			<cfquery name="rsSQL" datasource="#Session.DSN#">
				select count(1) as cantidad
				from CPCtaVinculada v, CPCtaVinculadaPadres p
				where v.Ecodigo=#Session.Ecodigo#
					and v.CPPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCPPid#">
					and p.CPCVid = v.CPCVid
					and p.CPformatoPadre=<cfqueryparam cfsqltype="cf_sql_char" value="#LvarCPformato#">
			</cfquery>
			<cfif rsSQL.cantidad GT 0>
				<cfset sbError ("FATAL", "Error, la cuenta '#LvarCPformato#' ya está definida como cuenta Padre dentro de la Cuenta Vinculada '#rsCtasVin.CPformato#' en el Periodo Presupuestario")>
				<cfset LvarCPCVid = -1>
			<cfelse>
				<cfquery name="A_CtasVinculadas" datasource="#Session.DSN#">
					insert into CPCtaVinculada 
						(Ecodigo, CPPid, CPformato, CPdescripcion, CPCVporcentaje, BMUsucodigo)
						values (
							#Session.Ecodigo#,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCPPid#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#mid(LvarCPformato,1,100)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#mid(LvarCPdescripcion,1,40)#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#LvarCPCVporcentaje#">,
							#session.usucodigo#)
					<cf_dbidentity1 verificar_transaccion="false" datasource="#Session.DSN#">
				</cfquery>
				<cf_dbidentity2 name="A_CtasVinculadas" verificar_transaccion="false" datasource="#Session.DSN#">
				
				<cfset LvarCPCVid = A_CtasVinculadas.identity>
			</cfif>
		</cfif>

		<cfif LvarCPCVid NEQ -1>
			<cfif LvarCPformatoPadre EQ "">
				<cfset sbError ("FATAL", "No se indicó una cuenta Padre para la Cuenta Vinculada '#LvarCPformatoAnt#'")>
			<cfelse>
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					select CPformato
					from CPCtaVinculada
					where Ecodigo=#Session.Ecodigo#
						and CPPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCPPid#">
						and CPformato=<cfqueryparam cfsqltype="cf_sql_char" value="#LvarCPformatoPadre#">
				</cfquery>
				<cfif rsSQL.CPformato NEQ "">
					<cfset sbError ("FATAL", "Error, la cuenta Padre '#LvarCPformatoPadre#' para la cuenta vinculada '#LvarCPformato#' ya está definida como Cuenta Vinculada en el Periodo Presupuestario")>
				<cfelse>
					<cfquery datasource="#session.DSN#">
						insert into CPCtaVinculadaPadres 
							(CPCVid, CPformatoPadre, BMUsucodigo)
							values (
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCPCVid#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#LvarCPformatoPadre#">,
								#session.usucodigo#
								)
					</cfquery>				
				</cfif>
			</cfif>
		</cfif>
	</cfloop>

	<cfset ERR = fnVerificaErrores()>

</cftransaction>


