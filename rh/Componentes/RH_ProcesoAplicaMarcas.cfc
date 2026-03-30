<cfcomponent name="RH_ProcesoAplicaMarcas">
<cfset Gvar_debug = false>
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfinvoke component="RHParametros" method="init" returnvariable="parametros">
<!---======================================================================================---->
<!--- 						Función para insertar incidencias 							   ---->
<!---======================================================================================---->
<cffunction name="funcIncidencias" access="public" output="true">
	<cfargument name="arg_DEid" 	type="numeric" 	required="yes">
	<cfargument name="arg_CIid" 	type="numeric" 	required="yes">
	<cfargument name="arg_fecha" 	type="date" 	required="yes">
	<cfargument name="arg_RHJid" 	type="numeric" 	required="yes">
	<cfargument name="arg_CantHoras" type="numeric" required="yes">
	<cfinvoke component="rh.Componentes.RH_Incidencias" 
			method="Alta" 
			DEid="#arguments.arg_DEid#" 
			CIid="#arguments.arg_CIid#" 
			iFecha="#arguments.arg_fecha#" 
			iValor="#arguments.arg_CantHoras#"
			RHJid="#arguments.arg_RHJid#"
			Debug="#Gvar_debug#"
			TransaccionAbierta="true"
			returnVariable="xIid"/>
	<cfreturn xIid>
</cffunction>
<cffunction name="RH_ProcesoAplicaMarcas">
	<cfargument name="CAMid" required="true" type="numeric">
    <cfset var Lvar_Iidhr = 0>
	<cfset var Lvar_Iidhn = 0>
	<cfset var Lvar_Iidhea = 0>
	<cfset var Lvar_Iidheb = 0>
	<cfset var Lvar_Iidfer = 0>
	<cftransaction>
		<cfquery name="rsDatos" datasource="#session.DSN#">
			select 	DEid, coalesce(RHJid,0) as RHJid, CAMfhasta,
					CAMcanthorasreb, coalesce(CAMincidrebhoras,0) as CAMincidrebhoras,
					CAMcanthorasjornada, CAMincidjornada,
					CAMcanthorasextA, CAMincidhorasextA,
					CAMcanthorasextB, CAMincidhorasextB,
					CAMmontoferiado, CAMincidferiados
			from RHCMCalculoAcumMarcas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and CAMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CAMid#">
		</cfquery>
		
		<cfquery name="rsDE" datasource="#session.dsn#">
			select DEnombre #LvarCNCT#' '#LvarCNCT# DEapellido1 #LvarCNCT#' '#LvarCNCT# DEapellido2 as nombre
			from DatosEmpleado where DEid=#rsDatos.DEid#
		</cfquery>
		<!---=====================Validación para que las horas extra no excedan el monto indicado en parametros RH=======================--->
			<!---Validacion de los tiempos definidos en parametros rh--->
			<!---Semana--->
			<cfquery name="rsParamS" datasource="#session.dsn#">
				select Pvalor from RHParametros where
				Pcodigo=2040 and Ecodigo=#session.Ecodigo#
			</cfquery>
			<!---Mes--->
			<cfquery name="rsParamM" datasource="#session.dsn#">
				select Pvalor from RHParametros where
				Pcodigo =2041 and Ecodigo=#session.Ecodigo#
			</cfquery>
			
			<cfset fechahoramarca=LSDateFormat(rsDatos.CAMfhasta,'MM/DD/YYYY')>
			<cfset LvarAno= datepart("yyyy",fechahoramarca)>
			<cfset LvarSemana= datepart("ww",fechahoramarca)>
			<cfset LvarMes= datepart("m",fechahoramarca)>
			
			<!---Averiguar cuantas horas ha trabajado en el mes--->
			<cfquery name="sumM" datasource="#session.dsn#">
				select coalesce(sum(ICvalor),0) as ICvalor
				 from HIncidenciasCalculo
				 where DEid=#rsDatos.DEid#
				 and <cf_dbfunction name="date_part" args="mm, ICfecha">=#LvarMes#
				 and <cf_dbfunction name="date_part" args="yyyy, ICfecha">=#LvarAno#
			</cfquery>
			<cfset LvarAcumMes=sumM.ICvalor>
			
			<cfquery name="sumM" datasource="#session.dsn#">
				select coalesce(sum(Ivalor),0) as Ivalor
				 from Incidencias
				 where DEid=#rsDatos.DEid#
				 and <cf_dbfunction name="date_part" args="mm, Ifecha">=#LvarMes#
				 and <cf_dbfunction name="date_part" args="yyyy, Ifecha">=#LvarAno#
			</cfquery>
			<cfset LvarAcumMes=LvarAcumMes+sumM.Ivalor+rsDatos.CAMcanthorasextA+rsDatos.CAMcanthorasextB>
			
			<cfif LvarAcumMes gt rsParamM.Pvalor>
				<cfthrow message="No se puede registrar la solicitud de horas extra de'#rsDE.nombre#'
				en la fecha '#LSdateFormat(rsDatos.CAMFhasta,"DD/MM/YYYY")#' debido a que excedido el n&uacute;mero de horas extras permitidas por mes">
			</cfif>
			<!---Averiguar cuantas horas ha trabajado en la semana--->
			<cfquery name="sumW" datasource="#session.dsn#">
				select coalesce(sum(ICvalor),0) as ICvalor
				 from HIncidenciasCalculo
				 where DEid=#rsDatos.DEid#
				 and <cf_dbfunction name="date_part" args="wk, ICfecha">=#LvarSemana#
				 and <cf_dbfunction name="date_part" args="yyyy, ICfecha">=#LvarAno#
			</cfquery>
			<cfset LvarAcumWeek=sumW.ICvalor>

			<cfquery name="sumW" datasource="#session.dsn#">
				select coalesce(sum(Ivalor),0) as Ivalor
				 from Incidencias
				 where DEid=#rsDatos.DEid#
				 and <cf_dbfunction name="date_part" args="wk, Ifecha">=#LvarSemana#
				 and <cf_dbfunction name="date_part" args="yyyy, Ifecha">=#LvarAno#
			</cfquery>
			<cfset LvarAcumWeek=LvarAcumWeek+sumW.Ivalor+rsDatos.CAMcanthorasextA+rsDatos.CAMcanthorasextB>

			<cfif LvarAcumWeek gt rsParamS.Pvalor>
				<cfthrow message="No se puede registrar la solicitud de horas extra de'#rsDE.nombre#'
				en la fecha '#LSdateFormat(rsDatos.CAMFhasta,"DD/MM/YYYY")#' debido a que excedido el n&uacute;mero de horas extras permitidas por semana">
			</cfif>
		<!---==================================================FIN VALIDACION=====================================================--->
		
		<!---===============================================VALIDACION DE PRESUPUESTO=============================================--->
		<!---Averiguar cual es la cuenta asociada del concepto de pago asociado a la hora extra y si esta cuenta con disponible--->
		
		<cfquery name="ValidaPlanillaPresupuestaria" datasource="#session.dsn#">
			select Pvalor from RHParametros where
			Pcodigo =540 and Ecodigo=#session.Ecodigo#
		</cfquery>		
		
		<cfif ValidaPlanillaPresupuestaria.Pvalor EQ 1><!--- Valida Planilla Prespuestaria Funcionando o no LZ 20110701 --->
			<cfif rsDatos.RecordCount NEQ 0>
				<cfif rsDatos.CAMcanthorasextA GT 0>
						<cfinvoke component="rh.Componentes.RH_ValidaPresupuesto" method="ValidaCuenta" >
						<cfinvokeargument name="CIid" value="#rsDatos.CAMincidhorasextA#"/>
						<cfinvokeargument name="valor" value="#rsDatos.CAMcanthorasextA#"/>
						<cfinvokeargument name="fecha" value="#rsDatos.CAMfhasta#"/>
						<cfinvokeargument name="DEid" value="#rsDatos.DEid#"/>
						<cfinvokeargument name="CAMid" value="#Arguments.CAMid#"/>
						</cfinvoke>
				</cfif>
				
				<cfif rsDatos.CAMcanthorasextB GT 0>
						<cfinvoke component="rh.Componentes.RH_ValidaPresupuesto" method="ValidaCuenta" >
						<cfinvokeargument name="CIid" value="#rsDatos.CAMincidhorasextB#"/>
						<cfinvokeargument name="valor" value="#rsDatos.CAMcanthorasextB#"/>					
						<cfinvokeargument name="fecha" value="#rsDatos.CAMfhasta#"/>
						<cfinvokeargument name="DEid" value="#rsDatos.DEid#"/>
						<cfinvokeargument name="CAMid" value="#Arguments.CAMid#"/>
						</cfinvoke>
				</cfif>
			</cfif>
		</cfif>			
		<!---<cfquery name="x" datasource="#session.dsn#">
		select * from RHOPFormulacion
		</cfquery>
		<cfdump var="#x#">--->
		<!---Una vez realizado esto se debe de actualizar el monto de la reserva--->
		<!---<cf_dump var="Finalizo">--->
		<!---=====================================================================================================================--->
		<cfif Gvar_debug><cfdump var="#rsDatos#"></cfif>
		<!---Generar incidencias ---->
		<cfif rsDatos.RecordCount NEQ 0>
			<cfif rsDatos.CAMcanthorasreb GT 0>
				<cfset Lvar_Iidhr = funcIncidencias(rsDatos.DEid,rsDatos.CAMincidrebhoras,rsDatos.CAMfhasta,rsDatos.RHJid,rsDatos.CAMcanthorasreb)>
			</cfif>
			<cfif rsDatos.CAMcanthorasjornada GT 0>
				<cfset Lvar_Iidhn = funcIncidencias(rsDatos.DEid,rsDatos.CAMincidjornada,rsDatos.CAMfhasta,rsDatos.RHJid,rsDatos.CAMcanthorasjornada)>
			</cfif>
			<cfif rsDatos.CAMcanthorasextA GT 0>
				<cfset Lvar_Iidhea = funcIncidencias(rsDatos.DEid,rsDatos.CAMincidhorasextA,rsDatos.CAMfhasta,rsDatos.RHJid,rsDatos.CAMcanthorasextA)>
			</cfif>
			<cfif rsDatos.CAMcanthorasextB GT 0>
				<cfset Lvar_Iidheb = funcIncidencias(rsDatos.DEid,rsDatos.CAMincidhorasextB,rsDatos.CAMfhasta,rsDatos.RHJid,rsDatos.CAMcanthorasextB)>
			</cfif>
			<cfif rsDatos.CAMmontoferiado GT 0>
				<cfset Lvar_Iidfer = funcIncidencias(rsDatos.DEid,rsDatos.CAMincidferiados,rsDatos.CAMfhasta,rsDatos.RHJid,rsDatos.CAMmontoferiado)>
			</cfif>
		</cfif>
		<cfif Gvar_debug><cfabort></cfif>
		<!---Actualizar Incidencias generadas en Calculo Acum Marcas --->
		<cfquery datasource="#session.DSN#" result="res">
			update RHCMCalculoAcumMarcas
			set Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				<cfif len(trim(Lvar_Iidhn)) GT 0>,CAMhniid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iidhn#"></cfif>
				<cfif len(trim(Lvar_Iidhr)) GT 0>,CAMhriid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iidhr#"></cfif> 
				<cfif len(trim(Lvar_Iidhea)) GT 0>,CAMheaiid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iidhea#"></cfif>
				<cfif len(trim(Lvar_Iidheb)) GT 0>,CAMhebiid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iidheb#"></cfif>
				<cfif len(trim(Lvar_Iidfer)) GT 0>,CAMferiid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iidfer#"></cfif>
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and CAMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CAMid#">
		</cfquery>
		<!---Grabar histórico de marcas del lote que se esta procesando---->			
		<cfquery datasource="#session.DSN#">
			insert into RHHControlMarcas(RHCMid, Ecodigo, DEid, 
										RHASid, fechahorareloj, tipomarca, 
										justificacion, fechahoraautorizado, usuarioautor, 
										fechahoramarca, RHJid, RHPJid, 
										RHCMhoraplan, ttoleranciaantes, ttoleranciadesp, 
										numlote, canthoras, BMUsucodigo, BMfecha)
			select 	RHCMid, Ecodigo, DEid, 
					RHASid, fechahorareloj, tipomarca, 
					justificacion, fechahoraautorizado, usuarioautor, 
					fechahoramarca, RHJid, RHPJid, 
					RHCMhoraplan, ttoleranciaantes, ttoleranciadesp, 
					numlote, canthoras, BMUsucodigo, BMfecha
			from RHControlMarcas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and numlote = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CAMid#">
		</cfquery>			
		<!---Grabar en el histórico de acciones a seguir del lote que se esta procesando---->
		<cfquery datasource="#session.DSN#">
			insert into RHCMBitacoraAccionesSeguir(Ecodigo, DEid, RHASid, 
													CMBfecha, UsucodigoSup, CMBestado, 
													UsucodigoCierre, CMBfechacierre,
													BMUsucodigo, BMfecha, Anotacion)
			select 	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					a.DEid,
					b.RHASid,
					a.CAMfhasta,
					coalesce(b.usuarioautor,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">),
					'A',
					null,
					null,						
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					b.justificacion
			
			from RHCMCalculoAcumMarcas a
				inner join RHControlMarcas b
					on a.CAMid = b.numlote
					and b.RHASid is not null
				
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.CAMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CAMid#">
		</cfquery>
		<!--- Gravar en la tabla de Control Semanal (Solo cuando paga Séptimo o Q250 o Ambos) --->
		<!---***INICIO Procesamiento Séptimo y Q250***--->
		<!--- Datos Séptimo y Q250 
		*******************************************************************************
		***SE COMENTA CÓDIGO ORIGINAL DE GENERACIÓN DE INFO DEL SÉPTIMO PARA DEJARLO***
		***COMO  HISTORIA,  SE ELIMINA DADO QUE SE PASO EL CODIGO PARA LA GENERACIÓN***
		***DE INCIDENCIAS                                                           ***
		*******************************************************************************
		<cfinvoke component="rh.Componentes.RH_ControlMarcasCommon" method="fnGetPagaSeptimo" 
				returnvariable="Lvar_PagaSeptimo">
		<cfinvoke component="rh.Componentes.RH_ControlMarcasCommon" method="fnGetPagaQ250" 
				returnvariable="Lvar_PagaQ250">
		<cfif Lvar_PagaSeptimo or Lvar_PagaQ250>
			<cfset Lvar_DateWOH = CreateDate(Year(rsDatos.CAMfhasta),Month(rsDatos.CAMfhasta),Day(rsDatos.CAMfhasta))>
			<cfset Lvar_DatePartWOH = DatePart("w",Lvar_DateWOH)-1>
			<cfset Lvar_DatePartFDP = parametros.get(session.dsn,session.ecodigo,780)>
			<cfif len(trim(Lvar_DatePartFDP)) EQ 0>
				<cfset Lvar_DatePartFDP = 1>
			</cfif>
			<cfset Lvar_DateFDOTW = DateAdd('d',-((Lvar_DatePartWOH+1+Lvar_DatePartFDP) Mod 7),Lvar_DateWOH)>
			<cfquery name="rsvInsert" datasource="#session.dsn#">
				select RHCMCSid
				from RHCMControlSemanal 
				where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.DEid#">
				and RHCMCSfecha=<cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_DateFDOTW#">
				and RHCMCSpagoseptimo = 0
			</cfquery>
			<cfif rsvInsert.recordcount GT 0>
				<cfset rsInsert.identity = rsvInsert.RHCMCSid>
			<cfelse>
				<cfquery name="rsInsert" datasource="#session.dsn#">
					insert into RHCMControlSemanal 
					(DEid, RHCMCSpagoseptimo, RHCMCSmontoseptimo, RHCMCSfecha, 
					BMfecha, BMUsucodigo)
					values(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.DEid#">,
						0, 0.00, 
						<cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_DateFDOTW#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					)
					<cf_dbidentity1>
				</cfquery>
				<cf_dbidentity2 name="rsInsert">
			</cfif>
			<cfif ListFind("1,2,3,4,5,6","#Lvar_DatePartWOH#")>
				<cfquery name="rsRHCMDia" datasource="#session.dsn#">
					SELECT RHCMDid
					FROM RHCMDia 
					where RHCMCSid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsert.identity#">
					  and RHCMDdia=<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_DatePartWOH#">
					  and RHCMDfecha=<cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_DateWOH#">
				</cfquery>
				<cfif rsRHCMDia.recordcount GT 0>
					<cfquery datasource="#session.dsn#">
						UPDATE RHCMDia 
						SET RHCMDhniid=case 
										when (RHCMDhniid is null) or (RHCMDhniid = 0)
											then <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iidhn#">
										else RHCMDhniid 
									   end,
							RHCMDheaiid=case 
										when (RHCMDheaiid is null) or (RHCMDheaiid = 0)
											then <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iidhea#">
										else RHCMDheaiid 
									   end,
							RHCMDhebiid=case 
										when (RHCMDhebiid is null) or (RHCMDhebiid = 0)
											then <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iidheb#">
										else RHCMDhebiid 
									   end,
							RHCMDferiid=case 
										when (RHCMDferiid is null) or (RHCMDferiid = 0)
											then <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iidfer#">
										else RHCMDferiid 
									   end,
							RHCMDhn=RHCMDhn+<cfqueryparam cfsqltype="cf_sql_float" value="#rsDatos.CAMcanthorasjornada#">,
							RHCMDhea=RHCMDhea+<cfqueryparam cfsqltype="cf_sql_float" value="#rsDatos.CAMcanthorasextA#">,
							RHCMDheb=RHCMDheb+<cfqueryparam cfsqltype="cf_sql_float" value="#rsDatos.CAMcanthorasextB#">
						where RHCMDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHCMDia.RHCMDid#">
					</cfquery>
				<cfelse>
					<cfquery datasource="#session.dsn#">
						insert into RHCMDia 
						(RHCMCSid, RHCMDdia, RHCMDfecha, 
						RHJid, RHCMDhn, RHCMDhea, 
						RHCMDheb, RHCMDhniid, RHCMDheaiid, 
						RHCMDhebiid, RHCMDferiid, 
						BMfecha, BMUsucodigo)
						values(
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsert.identity#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_DatePartWOH#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_DateWOH#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHJid#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#rsDatos.CAMcanthorasjornada#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#rsDatos.CAMcanthorasextA#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#rsDatos.CAMcanthorasextB#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iidhn#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iidhea#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iidheb#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iidfer#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">							
						)
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
		***FIN Procesamiento Séptimo y Q250***--->
		<!---Eliminar los registros de marcas pasados al histórico----->
		<cfquery datasource="#session.DSN#">
			delete from RHControlMarcas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and numlote = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CAMid#">
		</cfquery>
		<!---Cambiar estado del registro procesado de la tabla de RHCMCalculoAcumMarcas ---->
		<cfquery datasource="#session.DSN#">
			update RHCMCalculoAcumMarcas
			set CAMestado = 'A'
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and CAMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CAMid#">
		</cfquery>
	</cftransaction>
</cffunction>
</cfcomponent>