<!---
COMPONENTE DE VALIDACION DE ACTIVOS FIJOS
VALIDACIONES:
	- fnValida_ExisteAF: Valida que el Activo sea Valido
	- fnValida_Saldos: Valida que el Activo Tenga Saldos y que el valor en Libros, debe ser mayor a cero
	- fnValida_Mejora: Valida que el Activo No tenga transacciones de MEJORA Pendiente de aplicar
	- fnValida_Revaluacion: Valida que el Activo No tenga transacciones de REVALUACION Pendiente de aplicar
	- fnValida_Depreciacion: Valida que el Activo No tenga transacciones de DEPRECIACION Pendiente de aplicar
	- fnValida_Retiro: Valida que el Activo No tenga transacciones de RETIRO Pendiente de aplicar
	- fnValida_CambioCatCls: Valida que el Activo No tenga transacciones de CAMBIO CATEGORIA/CLASE Pendiente de aplicar	
	- fnValida_Traslado: Valida que el Activo No tenga transacciones de TRASLADO Pendiente de aplicar	
	- fnValida_Cola: Valida que el Activo no se encuentre en la cola de Transacciones de Activos Fijos	
	- fnValida_isDepreciable: Valida que el Activo sea depreciable
	- fnValida_Transito: Valida que el Activos no sea un activo en transito	
	- fnValida_Documentos: Valida que el Activo no tenga vales Duplicados o que no tenga un vale por el contrario no tenga Vale
	- fnValida_Empleado: Valida que un empleado sea un Empleado Activo, tenga un centro Funcional vigente a la fecha
	- fnValida_CentroCustodia: Valida que un código de centro de Custodia sea válido para la empresa
	- fnValida_TipoDocumento: Valida que un Tipo de Documento sea Válido para la empresa
	- fnValida_Categoria: Valida que un Categoría de Activo Fijo sea válido para la empresa
	- fnValida_Clase:  Valida que un Clase sea válida para una empresa, si se pasa la categoría valida que estén Asociadas Categoría-Clase
	- fnValida_Marca: Valida que una Marca de activos Fijo sea válida para la empresa
	- fnValida_Modelo: Valida que el modulo de un Activo Fijo sea Válido para la empresa, si se pasa la marca valida que Marca-Modelo estén Asociadas
	- fnValida_CFuncional: Valida que un centro Funcional sea Valido
	- fnValida_TCompra: Valida que el tipo de Compra de un Activo, sea Válido para la empresa.
	- fnValida_TipoAF: Valida que la Clasificación o Tipo de Activos sea Válido para la empresa
	- fnGetPeriodoAux: Valida y devuelve el periodo Auxiliar
	- fnGetMesAux: Valida y devuelve el mes Auxiliar
	- fnGetProRev: Obtiene el parámetro Considerar traslados, retiros y Revaluaciones del último periodo en la Revaluación

USADO EN ACTIVOS FIJOS:
	- Depreciaciones Manuales
	- Mejora
	- Retiros
	- Cambio de placa
	- Traslados
USADO EN CONTROL DE RESPONSABLESS:	
	- Retiros
	- Mejora 
	- Traslados
	- Inclusion de Documento
USANDO EN INTERFACES:
	-Interfaz 200
--->
<cfcomponent>
	<!---**************************************--->
	<!---***Valida que el Activo sea Valido****--->
	<!---***Debe Existir y No estar retirado***--->
	<!---**************************************--->
	<cffunction name="fnValida_ExisteAF" access="public" output="true" returntype="numeric">
		<cfargument name="Conexion" 	type="string" 	required="no">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no">
		<cfargument name="Aplaca" 		type="string" 	required="no">
		<cfargument name="Aid" 			type="numeric"  required="no">
		<cfargument name="DebeExistir" 	type="boolean"  required="no" default="true">
	
		<cfif not isdefined('Arguments.Ecodigo') or len(trim(Arguments.Ecodigo)) LTE 0 or Arguments.Ecodigo LTE 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfquery name="rsValida_ExisteAF" datasource="#Arguments.Conexion#">
				select Aid,Aplaca, Astatus from Activos
					where Ecodigo = #Arguments.Ecodigo# 
			  <cfif isdefined('Arguments.Aid') and len(trim(Arguments.Aid)) and Arguments.Aid gt 0>
					and Aid = #Arguments.Aid#
			 <cfelseif isdefined('Arguments.Aplaca') and len(trim(Arguments.Aplaca)) gt 0 and Arguments.Aplaca GT 0>
					and ltrim(rtrim(Aplaca)) = '#Trim(Arguments.Aplaca)#'
			 <cfelse>
			 		and 1=0 <!------Si no se especifica la placa o el Aid--->
			 </cfif>
		</cfquery> 
		<cfif rsValida_ExisteAF.recordcount GT 0 and rsValida_ExisteAF.Astatus EQ 60>
				<cf_errorCode	code = "50949" msg = "El Activo esta Retirado, Proceso Cancelado!!">
		</cfif>
		<cfif DebeExistir EQ true>
			<cfif rsValida_ExisteAF.recordcount LTE 0>
				<cf_errorCode	code = "50950" msg = "El Activo no existe, Proceso Cancelado!!">
			</cfif>	
			<cfset Aid = rsValida_ExisteAF.Aid>
		<cfelse>
			<cfif rsValida_ExisteAF.recordcount GT 0>
				<cf_errorCode	code = "50951" msg = "El Activo ya existe en el catalogo de Activos Fijos, Proceso Cancelado!!">
			</cfif>
			<cfset Aid = -1>
		</cfif>
		<cfreturn Aid>
	</cffunction>	
	<!---******************************************************--->
	<!---***********Valida que el Activo Tenga Saldos**********--->
	<!---********El valor en Libros, debe ser mayor a cero*****--->
	<!---*El que el Activo no debe estar totalmente depreciado*--->
	<!---****Si no se envia periodo-Mes se toma el Auxiliar****--->
	<!---******************************************************--->
	<cffunction name="fnValida_Saldos" access="public" output="true">
		<cfargument name="Conexion" 	type="string" 	required="no">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no">
		<cfargument name="Aplaca" 		type="string" 	required="no">
		<cfargument name="Aid" 			type="numeric"  required="no">
		<cfargument name="periodo" 		type="numeric"  required="no">
		<cfargument name="mes" 			type="numeric"  required="no">
		<cfargument name="validamontos" type="boolean"  required="no" default="true">
		
		<cfif not isdefined('Arguments.Ecodigo') or len(trim(Arguments.Ecodigo)) LTE 0 or Arguments.Ecodigo LTE 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.periodo') or len(trim(Arguments.periodo)) LTE 0 or Arguments.periodo LTE 0>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetPeriodoAux" returnvariable="Arguments.periodo"/>
		</cfif>
		<cfif not isdefined('Arguments.mes') or len(trim(Arguments.mes)) LTE 0 or Arguments.mes LTE 0>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetMesAux" 	returnvariable="Arguments.mes"/>
		</cfif>
		<cfquery name="rsValida_Saldos" datasource="#Arguments.Conexion#">
				select AFSvaladq, AFSvalmej, AFSvalrev, AFSsaldovutiladq,
				      ((AFSvaladq + AFSvalmej + AFSvalrev) - (AFSdepacumadq + AFSdepacummej + AFSdepacumrev)) as ValorEnLibros
					from Activos a
						inner join AFSaldos b
							on  b.Ecodigo = a.Ecodigo
							and b.Aid = a.Aid
				  where	b.Ecodigo = #Arguments.Ecodigo#
				<cfif isdefined('Arguments.Aid') and len(trim(Arguments.Aid)) and Arguments.Aid gt 0>
				  	and b.Aid = #Arguments.Aid#	
				<cfelseif isdefined('Arguments.Aplaca') and len(trim(Arguments.Aplaca)) gt 0 and Arguments.Aplaca GT 0>
					and ltrim(rtrim(a.Aplaca)) = '#Trim(Arguments.Aplaca)#'  
				<cfelse>
					and 1=0 ---Si no se especifica la placa o el Aid
				</cfif>
					and b.AFSperiodo = #Arguments.periodo#
					and b.AFSmes 	 = #Arguments.mes#
		</cfquery>  
		<cfif rsValida_Saldos.recordcount NEQ 1>
			<cf_errorCode	code = "50952"
							msg  = "El Activo no tienen saldos para el periodo=@errorDat_1@ Mes=@errorDat_2@ , Proceso Cancelado!!"
							errorDat_1="#Arguments.periodo#"
							errorDat_2="#Arguments.mes#"
			>
		<cfelseif rsValida_Saldos.ValorEnLibros LTE 0 and Arguments.validamontos>
			<cf_errorCode	code = "50953"
							msg  = "El Activo tiene un valor en libros en cero para el periodo=@errorDat_1@ Mes=@errorDat_2@, Proceso Cancelado!!"
							errorDat_1="#Arguments.periodo#"
							errorDat_2="#Arguments.mes#"
			>
		<cfelseif rsValida_Saldos.AFSsaldovutiladq LTE 0 and Arguments.validamontos>
			<cf_errorCode	code = "50954" msg = "El Activo tiene saldo de vida util en cero (Se encuentra totalmente depreciado), Proceso Cancelado!!">
		</cfif>
	</cffunction>	
	<!---******************************************************************--->
	<!---*Valida que el Activo No tenga transacciones Pendiente de aplicar*--->
	<!---******************TRANSACCIONES DE MEJORA*************************--->
	<!---******************************************************************--->
	<cffunction name="fnValida_Mejora" access="public" output="true">
		<cfargument name="Conexion" 	type="string" 	required="no">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no">
		<cfargument name="Aplaca" 		type="string" 	required="no">
		<cfargument name="Aid" 			type="numeric"  required="no">
		
		<cfif not isdefined('Arguments.Ecodigo') or len(trim(Arguments.Ecodigo)) LTE 0 or Arguments.Ecodigo LTE 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfquery name="rsValida_Mejora" datasource="#Arguments.Conexion#">
			select count(1) as cantidad from ADTProceso
				  where Ecodigo =  #Arguments.Ecodigo# 
				<cfif isdefined('Arguments.Aid') and len(trim(Arguments.Aid)) and Arguments.Aid gt 0>
					and Aid = #Arguments.Aid#
				</cfif>
				<cfif isdefined('Arguments.Aplaca') and  len(trim(Arguments.Aplaca)) gt 0>
				  and Aplacadestino = '#Arguments.Aplaca#'
				</cfif>
				  and IDtrans = 2
		</cfquery>  
		<cfif rsValida_Mejora.cantidad GT 0>
			<cf_errorCode	code = "50955" msg = "El Activo tiene una transaccion de Mejora pendiente de aplicar, Proceso Cancelado!!">
		</cfif>
	</cffunction>	
	<!---******************************************************************--->
	<!---*Valida que el Activo No tenga transacciones Pendiente de aplicar*--->
	<!---*****************TRANSACCIONES DE REVALUACION*********************--->
	<!---******************************************************************--->
	<cffunction name="fnValida_Revaluacion" access="public" output="true">
		<cfargument name="Conexion" 	type="string" 	required="no">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no">
		<cfargument name="Aid" 			type="numeric"  required="yes">
		
		<cfif not isdefined('Arguments.Ecodigo') or len(trim(Arguments.Ecodigo)) LTE 0 or Arguments.Ecodigo LTE 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfquery name="rsValida_Revaluacion" datasource="#Arguments.Conexion#">
			select count(1) as cantidad from ADTProceso
				 where Ecodigo =  #Arguments.Ecodigo# 
				 and Aid = #Arguments.Aid#			
				 and IDtrans = 3
		</cfquery>  
		<cfif rsValida_Revaluacion.cantidad GT 0>
			<cf_errorCode	code = "50956" msg = "El Activo tiene una transaccion de Revaluación pendiente de aplicar, Proceso Cancelado!!">
		</cfif>
	</cffunction>
	<!---******************************************************************--->
	<!---*Valida que el Activo No tenga transacciones Pendiente de aplicar*--->
	<!---*****************TRANSACCIONES DE DEPRECIACION*********************--->
	<!---******************************************************************--->
	<cffunction name="fnValida_Depreciacion" access="public" output="true">
		<cfargument name="Conexion" 	type="string" 	required="no">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no">
		<cfargument name="Aid" 			type="numeric"  required="yes">
		
		<cfif not isdefined('Arguments.Ecodigo') or len(trim(Arguments.Ecodigo)) LTE 0 or Arguments.Ecodigo LTE 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfquery name="rsValida_Depreciacion" datasource="#Arguments.Conexion#">
			select count(1) as cantidad from ADTProceso
				 where Ecodigo =  #Arguments.Ecodigo# 
				 and Aid = #Arguments.Aid#			
				 and IDtrans = 4
		</cfquery>  
		<cfif rsValida_Depreciacion.cantidad GT 0>
			<cf_errorCode	code = "50957" msg = "El Activo tiene una transaccion de Depreciación pendiente de aplicar, Proceso Cancelado!!">
		</cfif>
	</cffunction>
	<!---******************************************************************--->
	<!---*Valida que el Activo No tenga transacciones Pendiente de aplicar*--->
	<!---*****************TRANSACCIONES DE RETIRO*********************--->
	<!---******************************************************************--->
	<cffunction name="fnValida_Retiro" access="public" output="true">
		<cfargument name="Conexion" 	type="string" 	required="no">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no">
		<cfargument name="Aid" 			type="numeric"  required="yes">
		
		<cfif not isdefined('Arguments.Ecodigo') or len(trim(Arguments.Ecodigo)) LTE 0 or Arguments.Ecodigo LTE 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfquery name="rsValida_Retiro" datasource="#Arguments.Conexion#">
			select count(1) as cantidad from ADTProceso
				 where Ecodigo =  #Arguments.Ecodigo# 
				 and Aid = #Arguments.Aid#			
				 and IDtrans = 5
		</cfquery>  
		<cfif rsValida_Retiro.cantidad GT 0>
			<cf_errorCode	code = "50958" msg = "El Activo tiene una transaccion de Retiro pendiente de aplicar, Proceso Cancelado!!">
		</cfif>
	</cffunction>
    <!---******************************************************************--->
	<!---*Valida que el Activo No tenga transacciones Pendiente de aplicar*--->
	<!---***********TRANSACCIONES DE CAMBIO CATEGORIA/CLASE****************--->
	<!---******************************************************************--->
	<cffunction name="fnValida_CambioCatCls" access="public" output="true">
		<cfargument name="Conexion" 	type="string" 	required="no">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no">
		<cfargument name="Aid" 			type="numeric"  required="yes">
		
		<cfif not isdefined('Arguments.Ecodigo') or len(trim(Arguments.Ecodigo)) LTE 0 or Arguments.Ecodigo LTE 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfquery name="rsValida_CambioCatCls" datasource="#Arguments.Conexion#">
			select count(1) as cantidad from ADTProceso
				 where Ecodigo =  #Arguments.Ecodigo# 
				 and Aid = #Arguments.Aid#			
				 and IDtrans = 6
		</cfquery>  
		<cfif rsValida_CambioCatCls.cantidad GT 0>
			<cf_errorCode	code = "50959" msg = "El Activo tiene una transaccion de Cambio de Categoria-Clase pendiente de aplicar, Proceso Cancelado!!">
		</cfif>
	</cffunction>
	<!---******************************************************************--->
	<!---*Valida que el Activo No tenga transacciones Pendiente de aplicar*--->
	<!---*******************TRANSACCIONES DE TRASLADO**********************--->
	<!---******************************************************************--->
	<cffunction name="fnValida_Traslado" access="public" output="true">
		<cfargument name="Conexion" 	type="string" 	required="no">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no">
		<cfargument name="Aid" 			type="numeric"  required="no">
		<cfargument name="PlacaDestino"	type="string"   required="no">
		<cfargument name="AGTPid"		type="numeric"  required="no"><!---Exluir este AGTPid--->
		
		<cfif not isdefined('Arguments.Ecodigo') or len(trim(Arguments.Ecodigo)) LTE 0 or Arguments.Ecodigo LTE 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfquery name="rsValida_Traslado" datasource="#Arguments.Conexion#">
			select count(1) as cantidad from ADTProceso
				 where Ecodigo =  #Arguments.Ecodigo# 
			<cfif isdefined('Arguments.Aid') and len(trim(Arguments.Aid)) GT 0 and Arguments.Aid GT 0>
				 and Aid 	   = #Arguments.Aid#	
			<cfelseif isdefined('Arguments.PlacaDestino') and len(trim(Arguments.PlacaDestino)) GT 0 and Arguments.PlacaDestino GT 0> 
				 and Aplacadestino = '#Arguments.PlacaDestino#'  
			<cfelse>
				 1=2
			</cfif>		
				 and IDtrans   = 8
			<cfif isdefined('Arguments.AGTPid') and len(trim(Arguments.AGTPid)) GT 0 and Arguments.AGTPid GT 0>
				and AGTPid <> #Arguments.AGTPid#
			</cfif>
		</cfquery>  
		<cfif rsValida_Traslado.cantidad GT 0>
			<cf_errorCode	code = "50960" msg = "El Activo tiene una transaccion de Traslado pendiente de aplicar, Proceso Cancelado!!">
		</cfif>
	</cffunction>
	<!---******************************************************************--->
	<!---*********Valida que el Activo No SE encuentre en la cola**********--->
	<!---*********ACTIVOS FIJOS HACIA CONTROL DE RESPONSABLES**************--->
	<!---******************************************************************--->
	<cffunction name="fnValida_Cola" access="public" output="true">
		<cfargument name="Conexion" 	type="string" 	required="no">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no">
		<cfargument name="Aid" 			type="numeric"  required="yes">
		<cfargument name="CRCTid" 		type="numeric"  required="no" default="-1">
		
		<cfif not isdefined('Arguments.Ecodigo') or len(trim(Arguments.Ecodigo)) LTE 0 or Arguments.Ecodigo LTE 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfquery name="rsValida_Cola" datasource="#Arguments.Conexion#">
			select b.Aplaca
			  from CRColaTransacciones a
			  	inner join Activos b
					on a.Aid = b.Aid
				 where a.Aid = #Arguments.Aid#
			<cfif Arguments.CRCTid GT 0>
				and CRCTid <> #Arguments.CRCTid#
			</cfif>			
		</cfquery>  
		<cfif rsValida_Cola.recordcount GT 0>
			<cf_errorCode	code = "51643"
							msg  = "El Activo @errorDat_1@ se encuentran dentro de la cola de procesos hacia Activos Fijos, Proceso Cancelado!!"
							errorDat_1="#rsValida_Cola.Aplaca#"
			>
		</cfif>
	</cffunction>
	<!---*****************************************************************--->
	<!---****************Valida que el Activo Sea Depreciable*************--->
	<!---**********Debe pertenecer a una categoria/Clase depreciable******--->
	<!---*La fecha de Inicio de depreciacion debe ser menor a la indicada*--->
	<!---*********Si no se envia periodo-Mes se toma el Auxiliar**********--->
	<!---*****************************************************************--->
	<cffunction name="fnValida_isDepreciable" access="public" output="true">
		<cfargument name="Conexion" 	type="string" 	required="no">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no">
		<cfargument name="Aid" 			type="numeric"  required="yes">
		<cfargument name="periodo" 		type="numeric"  required="no">
		<cfargument name="mes" 			type="numeric"  required="no">
		
		<cfset IDtrans = 4>
		<cfif not isdefined('Arguments.Ecodigo') or len(trim(Arguments.Ecodigo)) LTE 0 or Arguments.Ecodigo LTE 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.periodo') or len(trim(Arguments.periodo)) LTE 0 or Arguments.periodo LTE 0>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetPeriodoAux" returnvariable="Arguments.periodo"/>
		</cfif>
		<cfif not isdefined('Arguments.mes') or len(trim(Arguments.mes)) LTE 0 or Arguments.mes LTE 0>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetMesAux" 	returnvariable="Arguments.mes"/>
		</cfif>
		<!--- Crea la FechaAux a partir del periodo / mes y le pone el ultimo dia del mes --->
		<cfset rsFechaAux = CreateDate(Arguments.periodo, Arguments.mes, 01)>
		<cfset rsFechaAux = DateAdd("m",1,rsFechaAux)>
		<cfset rsFechaAux = DateAdd("d",-1,rsFechaAux)>
		<cfset rsFechaAux = DateAdd("h",23,rsFechaAux)>
		<cfset rsFechaAux = DateAdd("n",59,rsFechaAux)>
		<cfset rsFechaAux = DateAdd("s",59,rsFechaAux)>		
		
		<cfquery name="rsValida_Depreciable" datasource="#Arguments.Conexion#">
				select b.AFSdepreciable, a.Afechainidep, 
					  (select count(1) 
					      from TransaccionesActivos TA 
						   	where TA.Ecodigo 	= #Arguments.Ecodigo# 
		  					and TA.Aid       	=#Arguments.Aid#
		 					and TA.TAperiodo	= #Arguments.periodo# 
  		  					and TA.TAmes   	= #Arguments.mes#
		  					and TA.IDtrans  = #IDtrans#
		  			  ) as YaDepreciado
				from Activos a
					inner join AFSaldos b
						on a.Ecodigo = b.Ecodigo
						and a.Aid = b.Aid 
				  where	a.Ecodigo 			= #Arguments.Ecodigo#
				  	and a.Aid 				= #Arguments.Aid#
					and b.AFSperiodo 		= #Arguments.periodo# 
					and b.AFSmes 			= #Arguments.mes#
		</cfquery>
		<cfif rsValida_Depreciable.recordcount EQ 1 and rsValida_Depreciable.AFSdepreciable NEQ 1>
			<cf_errorCode	code = "50962" msg = "El Activo pertenece a una categoria-clase no depreciable, Proceso Cancelado!!">
		<cfelseif rsValida_Depreciable.recordcount EQ 1 and rsValida_Depreciable.Afechainidep GT #rsFechaAux# >
			<cf_errorCode	code = "50963" msg = "El Activo Aun no comienza a depreciarse, revisar la Fecha de Inicio de depreciación, Procesa Cancelado!!">
		<cfelseif rsValida_Depreciable.recordcount EQ 1 and rsValida_Depreciable.YaDepreciado GT 0 >
			<cf_errorCode	code = "50964" msg = "El Activo se encuentran dentro una transaccion de depreciacion aplicada para este periodo-mes!">
		</cfif>
	</cffunction>	
	<!---******************************************************************--->
	<!---*******Valida que el Activo No sea un Activo en transito**********--->
	<!---****ExcluirCRTDid permite exluir un Vale de la validaciones*******--->
	<!---******************************************************************--->
	<cffunction name="fnValida_Transito" access="public" output="true">
		<cfargument name="Conexion" 	 type="string" 	required="no">
		<cfargument name="Ecodigo" 		 type="numeric" required="no">
		<cfargument name="Aplaca"  		 type="string"  required="yes" default="">
		<cfargument name="ExcluirCRTDid" type="numeric" required="no" default="-1">
        <cfargument name="CRDRid"		 type="numeric" required="no" default="0"><!---Se Agrego este Argumento RVD 07/04/204---->
    
		
		<cfif not isdefined('Arguments.Ecodigo') or len(trim(Arguments.Ecodigo)) LTE 0 or Arguments.Ecodigo LTE 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>

		<cfquery name="rsRevisaTransito" datasource="#Arguments.Conexion#">
			select count(1) cantidad
			 from CRDocumentoResponsabilidad
			  where Ecodigo	 =  #Arguments.Ecodigo# 
			   and CRDRplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Aplaca#">
			<cfif Arguments.ExcluirCRTDid GT 0>
				and CRTDid <> #Arguments.ExcluirCRTDid#
			</cfif>
            <cfif Arguments.CRDRid NEQ ""><!---Se Agrego esto RVD 07/04/204---->
           		and CRDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CRDRid#">
             </cfif>
		</cfquery>  
		
		<cfif rsRevisaTransito.cantidad gt 0>
			<cf_errorCode	code = "50965"
							msg  = "El activo @errorDat_1@ es un Activos en Transito!, Proceso Cancelado!"
							errorDat_1="#Arguments.Aplaca#"
			>
		</cfif>
	</cffunction>	
	<!---*******************************************************************************************--->
	<!---*******Valida que el Activo no tenga Documentos Inconsistentes**********--->
	<!---*******************************************************************************************--->
	<cffunction name="fnValida_Documentos" access="public" output="true" returntype="numeric">
		<cfargument name="Conexion" 	type="string" 	required="no">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no">
		<cfargument name="Aid"  		type="numeric"  required="yes">
	
		<cfif not isdefined('Arguments.Ecodigo') or len(trim(Arguments.Ecodigo)) LTE 0 or Arguments.Ecodigo LTE 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		
		<cfquery name="rsRevisaDocumentos" datasource="#Arguments.Conexion#">
			select AFRid
			 from AFResponsables
			  where Ecodigo	=  #Arguments.Ecodigo# 
			  and Aid = #Arguments.Aid#
			  and <cf_dbfunction name="now"> between AFRfini and AFRffin
		</cfquery>  
		<cfif rsRevisaDocumentos.recordCount LTE 0>
			<cf_errorCode	code = "51704" msg = "El activo no posee ningún documento de responsabilidad!, Proceso Cancelado!">
		<cfelseif rsRevisaDocumentos.recordCount GT 1>
			<cf_errorCode	code = "51705"
							msg  = "El activo posee @errorDat_1@ documentos de responsabilidad!, Proceso Cancelado!"
							errorDat_1="#rsRevisaDocumentos.recordCount#"
			>
		</cfif>
		<cfreturn rsRevisaDocumentos.AFRid>
	</cffunction>
	<!---*******************************************************************************************--->
	<!---*******Valida que un empleado sea un Empleado Activo, tenga un centro Funcional  **********--->
	<!---*******************************************************************************************--->
	<cffunction name="fnValida_Empleado" access="public" output="true" returntype="query">
		<cfargument name="Conexion" 		type="string" 	required="no">
		<cfargument name="Ecodigo" 			type="numeric" 	required="no">
		<cfargument name="DEid"  			type="numeric"  required="no">
		<cfargument name="DEidentificacion" type="string"   required="no">
		
		<cfif not isdefined('Arguments.Ecodigo') or len(trim(Arguments.Ecodigo)) LTE 0 or Arguments.Ecodigo LTE 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif (not isdefined('Arguments.DEidentificacion') or NOT LEN(TRIM(Arguments.DEidentificacion))) and (not isdefined('Arguments.DEid') or NOT LEN(TRIM(Arguments.DEid)))>
			<cfthrow message="Error el empleado es requerido. Proceso Cancelado!">
		</cfif>

			<cfset labelError = "">
		<cfif isdefined('Arguments.DEid')>
			<cfset labelError = "DEid=#Arguments.DEid#">
		<cfelseif isdefined('Arguments.DEidentificacion')>
			<cfset labelError = "DEidentificacion=#Arguments.DEidentificacion#">
		</cfif>
		
		<cfquery name="rsRevisaEmpleado" datasource="#Arguments.Conexion#">
			select DEid,DEnombre, DEapellido1, DEapellido2,
			       case when (select count(1)
                                from EmpleadoCFuncional cf
                               where cf.DEid = b.DEid
                                 and <cf_dbfunction name="now"> between cf.ECFdesde and cf.ECFhasta) > 0 
                    then 'Activo' else 'Inactivo' end Estado
			from DatosEmpleado b
			where Ecodigo = #Arguments.Ecodigo# 
			<cfif isdefined('Arguments.DEid') and LEN(TRIM(Arguments.DEid))>
				and DEid = #Arguments.DEid#
			<cfelseif isdefined('Arguments.DEidentificacion') and LEN(TRIM(Arguments.DEidentificacion))>
				and DEidentificacion =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.DEidentificacion#">
			<cfelse>
				and 1 = 2
			</cfif>
		</cfquery>  
		<cfif rsRevisaEmpleado.recordcount LTE 0>
			<cfthrow message="Error el Empleado no existe. #labelError#, Proceso Cancelado!">
		<cfelseif rsRevisaEmpleado.Estado NEQ 'Activo'>
			<cfthrow message="Error, #rsRevisaEmpleado.DEnombre# #rsRevisaEmpleado.DEapellido1# #rsRevisaEmpleado.DEapellido2# no es un Empleado Activo. Proceso Cancelado! ">
		</cfif>
		<cfreturn rsRevisaEmpleado>
	</cffunction>	
	<!---*******************************************************************************************--->
	<!---**********************Valida el Centro de Custodia ****************************************--->
	<!---*******************************************************************************************--->
	<cffunction name="fnValida_CentroCustodia" access="public" output="true" returntype="query">
		<cfargument name="Conexion" 		type="string" 	required="no">
		<cfargument name="Ecodigo" 			type="numeric" 	required="no">
		<cfargument name="CRCCcodigo"  		type="string"   required="yes">

		<cfif not isdefined('Arguments.Ecodigo') or len(trim(Arguments.Ecodigo)) LTE 0 or Arguments.Ecodigo LTE 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif NOT LEN(TRIM(Arguments.CRCCcodigo))>
			<cfthrow message="Error el Centro de Custodia es requerido. Proceso Cancelado!">
		</cfif>
		
		<cfquery name="rsRevisaCC" datasource="#Arguments.Conexion#">
			Select CRCCid, CRCCcodigo
				from CRCentroCustodia 
				  where CRCCcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CRCCcodigo#">
				   and Ecodigo = #Arguments.Ecodigo# 
		</cfquery>  
		<cfif rsRevisaCC.recordcount LTE 0>
			<cfthrow message="Error el Centro de Custodia no existe. Proceso Cancelado!">
		</cfif>
		<cfreturn rsRevisaCC>
	</cffunction>	
	<!---*******************************************************************************************--->
	<!---**************************Valida el Tipo de Documento *************************************--->
	<!---*******************************************************************************************--->
	<cffunction name="fnValida_TipoDocumento" access="public" output="true" returntype="query">
		<cfargument name="Conexion" 		type="string" 	required="no">
		<cfargument name="Ecodigo" 			type="numeric" 	required="no">
		<cfargument name="CRTDcodigo"  		type="string"   required="yes">

		<cfif not isdefined('Arguments.Ecodigo') or len(trim(Arguments.Ecodigo)) LTE 0 or Arguments.Ecodigo LTE 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif NOT LEN(TRIM(Arguments.CRTDcodigo))>
			<cfthrow message="Error el Tipo de Documento es requerido. Proceso Cancelado!">
		</cfif>
		
		<cfquery name="rsRevisaTD" datasource="#Arguments.Conexion#">
			Select CRTDid, CRTDcodigo
				from CRTipoDocumento 
				  where CRTDcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CRTDcodigo#">
				    and Ecodigo    = #Arguments.Ecodigo# 
		</cfquery>  
		<cfif rsRevisaTD.recordcount LTE 0>
			<cfthrow message="Error el Tipo de Documento no existe. Proceso Cancelado!">
		</cfif>
		<cfreturn rsRevisaTD>
	</cffunction>	
	<!---*******************************************************************************************--->
	<!---**************************Valida la Categoria del Activo Fijo******************************--->
	<!---*******************************************************************************************--->
	<cffunction name="fnValida_Categoria" access="public" output="true" returntype="query">
		<cfargument name="Conexion" 		type="string" 	required="no">
		<cfargument name="Ecodigo" 			type="numeric" 	required="no">
		<cfargument name="ACcodigodesc"  	type="string"   required="yes">

		<cfif not isdefined('Arguments.Ecodigo') or len(trim(Arguments.Ecodigo)) LTE 0 or Arguments.Ecodigo LTE 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif NOT LEN(TRIM(Arguments.ACcodigodesc))>
			<cfthrow message="Error la Categoria es requerida. Proceso Cancelado!">
		</cfif>
		
		<cfquery name="rsRevisaCat" datasource="#Arguments.Conexion#">
			Select ACatId,ACcodigo,ACcodigodesc,ACdescripcion
				from ACategoria 
				  where ACcodigodesc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ACcodigodesc#">
				    and Ecodigo    = #Arguments.Ecodigo# 
		</cfquery>  
		<cfif rsRevisaCat.recordcount LTE 0>
			<cfthrow message="Error la categoria #Arguments.ACcodigodesc# no existe. Proceso Cancelado!">
		</cfif>
		<cfreturn rsRevisaCat>
	</cffunction>	
	<!---*******************************************************************************************--->
	<!---**************************Valida la Clase del Activo Fijos*********************************--->
	<!---*******************************************************************************************--->
	<cffunction name="fnValida_Clase" access="public" output="true" returntype="query">
		<cfargument name="Conexion" 		type="string" 	required="no">
		<cfargument name="Ecodigo" 			type="numeric" 	required="no">
		<cfargument name="clase"  			type="string"   required="yes">
		<cfargument name="categoria"  		type="string"   required="no" default="">

		<cfif not isdefined('Arguments.Ecodigo') or len(trim(Arguments.Ecodigo)) LTE 0 or Arguments.Ecodigo LTE 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif NOT LEN(TRIM(Arguments.clase))>
			<cfthrow message="Error la clase es requerida. Proceso Cancelado!">
		</cfif>
		
		<cfquery name="rsRevisaClase" datasource="#Arguments.Conexion#">
			Select a.AClaId, a.ACcodigo, a.ACid, a.ACcodigodesc, a.ACdescripcion, b.ACatId
				from AClasificacion a
					inner join ACategoria b
						on b.Ecodigo	  = a.Ecodigo 
					   and b.ACcodigo	  = a.ACcodigo
					   and b.ACcodigodesc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.categoria#">
				  where a.ACcodigodesc	  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.clase#">
				    and a.Ecodigo      	  = #Arguments.Ecodigo# 
		</cfquery>  
		<cfif rsRevisaClase.recordcount LTE 0>
			<cfthrow message="Error la Clase no existe o no esta asociada a una Categoria. Proceso Cancelado!">
		</cfif>
		<cfreturn rsRevisaClase>
	</cffunction>
	<!---*******************************************************************************************--->
	<!---**************************Valida la Marca de un Activo Fijo*********************************--->
	<!---*******************************************************************************************--->
	<cffunction name="fnValida_Marca" access="public" output="true" returntype="query">
		<cfargument name="Conexion" 		type="string" 	required="no">
		<cfargument name="Ecodigo" 			type="numeric" 	required="no">
		<cfargument name="AFMcodigo"  		type="string"   required="yes">

		<cfif not isdefined('Arguments.Ecodigo') or len(trim(Arguments.Ecodigo)) LTE 0 or Arguments.Ecodigo LTE 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif NOT LEN(TRIM(Arguments.AFMcodigo))>
			<cfthrow message="Error la Marca es requerida. Proceso Cancelado!">
		</cfif>
		<cfquery name="rsRevisaMarcas" datasource="#Arguments.Conexion#">
			Select AFMid,AFMcodigo,AFMdescripcion
				from AFMarcas
				where Ecodigo  = #Arguments.Ecodigo# 
				and AFMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AFMcodigo#">
		</cfquery>  
		<cfif rsRevisaMarcas.recordcount LTE 0>
			<cfthrow message="Error la Marca no existe. Proceso Cancelado!">
		</cfif>
		<cfreturn rsRevisaMarcas>
	</cffunction>
	<!---*******************************************************************************************--->
	<!---**************************Valida el Modelo del Activo Fijos*********************************--->
	<!---*******************************************************************************************--->
	<cffunction name="fnValida_Modelo" access="public" output="true" returntype="query">
		<cfargument name="Conexion" 		type="string" 	required="no">
		<cfargument name="Ecodigo" 			type="numeric" 	required="no">
		<cfargument name="AFMMcodigo"  		type="string"   required="yes">
		<cfargument name="AFMcodigo"  		type="string"   required="no" default="">

		<cfif not isdefined('Arguments.Ecodigo') or len(trim(Arguments.Ecodigo)) LTE 0 or Arguments.Ecodigo LTE 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif NOT LEN(TRIM(Arguments.AFMMcodigo))>
			<cfthrow message="Error el Modelo es requerido. Proceso Cancelado!">
		</cfif>

		<cfquery name="rsRevisaModelo" datasource="#Arguments.Conexion#">
			Select a.AFMMid,a.AFMMcodigo,a.AFMMdescripcion, b.AFMid
				from AFMModelos a
					inner join AFMarcas b
						on b.Ecodigo	  = a.Ecodigo 
					   and b.AFMid	  	  = a.AFMid
					   and b.AFMcodigo    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AFMcodigo#">
				  where a.AFMMcodigo	  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AFMMcodigo#">
				    and a.Ecodigo      	  = #Arguments.Ecodigo# 
		</cfquery>  
		<cfif rsRevisaModelo.recordcount LTE 0>
			<cfthrow message="Error el Modelo no existe. Proceso Cancelado!">
		</cfif>
		<cfif LEN(TRIM(Arguments.AFMcodigo)) AND NOT LEN(TRIM(rsRevisaModelo.AFMid))>
			<cfthrow message="Error el Modelo y la Clase no estan Asociadas. Proceso Cancelado!">
		</cfif>
		<cfreturn rsRevisaModelo>
	</cffunction>
	<!---*******************************************************************************************--->
	<!---**************************Valida el Centro Funcional de un Activo Fijo*********************************--->
	<!---*******************************************************************************************--->
	<cffunction name="fnValida_CFuncional" access="public" output="true" returntype="query">
		<cfargument name="Conexion" 	type="string" 	required="no">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no">
		<cfargument name="CFcodigo"  	type="string"   required="yes">

		<cfif not isdefined('Arguments.Ecodigo') or len(trim(Arguments.Ecodigo)) LTE 0 or Arguments.Ecodigo LTE 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif NOT LEN(TRIM(Arguments.CFcodigo))>
			<cfthrow message="Error el Centro Funcional es requerido. Proceso Cancelado!">
		</cfif>
		<cfquery name="rsRevisaCF" datasource="#Arguments.Conexion#">
			Select CFid,CFcodigo,CFdescripcion
				from CFuncional
				where Ecodigo  = #Arguments.Ecodigo# 
				  and CFcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CFcodigo#">
		</cfquery>  
		<cfif rsRevisaCF.recordcount LTE 0>
			<cfthrow message="Error el Centro Funcional del Activos no existe. Proceso Cancelado!">
		</cfif>
		<cfreturn rsRevisaCF>
	</cffunction>
	<!---*******************************************************************************************--->
	<!---*********************Valida el Tipo de Compra de un Activo Fijo****************************--->
	<!---*******************************************************************************************--->
	<cffunction name="fnValida_TCompra" access="public" output="true" returntype="query">
		<cfargument name="Conexion" 	type="string" 	required="no">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no">
		<cfargument name="CRTCcodigo"  	type="string"   required="yes">

		<cfif not isdefined('Arguments.Ecodigo') or len(trim(Arguments.Ecodigo)) LTE 0 or Arguments.Ecodigo LTE 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif NOT LEN(TRIM(Arguments.CRTCcodigo))>
			<cfthrow message="Error el Tipo de Compra es requerido. Proceso Cancelado!">
		</cfif>
		<cfquery name="rsRevisaTCompra" datasource="#Arguments.Conexion#">
			Select CRTCid,CRTCcodigo,CRTCdescripcion
				from CRTipoCompra
				where Ecodigo    = #Arguments.Ecodigo# 
				  and CRTCcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CRTCcodigo#">
		</cfquery>  
		<cfif rsRevisaTCompra.recordcount LTE 0>
			<cfthrow message="Error el Tipo de Compra no existe. Proceso Cancelado!">
		</cfif>
		<cfreturn rsRevisaTCompra>
	</cffunction>
	<!---*******************************************************************************************--->
	<!---******************Valida la Clasificacion(Tipo) del Activo Fijo****************************--->
	<!---*******************************************************************************************--->
	<cffunction name="fnValida_TipoAF" access="public" output="true" returntype="query">
		<cfargument name="Conexion" 		type="string" 	required="no">
		<cfargument name="Ecodigo" 			type="numeric" 	required="no">
		<cfargument name="AFCcodigoclas"  	type="string"   required="yes">

		<cfif not isdefined('Arguments.Ecodigo') or len(trim(Arguments.Ecodigo)) LTE 0 or Arguments.Ecodigo LTE 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif NOT LEN(TRIM(Arguments.AFCcodigoclas))>
			<cfthrow message="Error la Clasificación(Tipo) del Activos Fijo es requerido. Proceso Cancelado!">
		</cfif>

		<cfquery name="rsRevisaTipo" datasource="#Arguments.Conexion#">
			Select AFCcodigo,AFCcodigopadre,AFCcodigoclas,AFCdescripcion
				from AFClasificaciones
				where Ecodigo  = #Arguments.Ecodigo# 
				and AFCcodigoclas = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AFCcodigoclas#">
		</cfquery>  
		<cfif rsRevisaTipo.recordcount LTE 0>
			<cfthrow message="Error la Clasificación(Tipo) del Activo no existe. Proceso Cancelado!">
		</cfif>
		<cfreturn rsRevisaTipo>
	</cffunction>
	<!---******************************************************************--->
	<!---*******************Obtiene el Periodo Auxiliar********************--->
	<!---******************************************************************--->
	<cffunction name="fnGetPeriodoAux" access="public" output="true" returntype="numeric">
		<cfargument name="Conexion" 	type="string" 	required="no">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no">
		
		<cfif not isdefined('Arguments.Ecodigo') or len(trim(Arguments.Ecodigo)) LTE 0 or Arguments.Ecodigo LTE 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfquery name="rsPeriodo" datasource="#Arguments.Conexion#">
			select <cf_dbfunction name="to_number" datasource="#Arguments.Conexion#" args="Pvalor"> as Pvalor
			from Parametros
			where Ecodigo = #Arguments.Ecodigo#
			  and Pcodigo = 50
			  and Mcodigo = 'GN'
		</cfquery>
		
		<cfif rsPeriodo.recordcount LTE 0>
			<cf_errorCode	code = "51644" msg = "No se ha definido el Periodo Auxiliar!">
		</cfif>
		<cfreturn rsPeriodo.Pvalor>
	</cffunction>	
	<!---******************************************************************--->
	<!---*******************Obtiene el Periodo Auxiliar********************--->
	<!---******************************************************************--->
	<cffunction name="fnGetMesAux" access="public" output="true" returntype="numeric">
		<cfargument name="Conexion" 	type="string" 	required="no">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no">
		
		<cfif not isdefined('Arguments.Ecodigo') or len(trim(Arguments.Ecodigo)) LTE 0 or Arguments.Ecodigo LTE 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfquery name="rsPeriodo" datasource="#Arguments.Conexion#">
			select <cf_dbfunction name="to_number" datasource="#Arguments.Conexion#" args="Pvalor"> as Pvalor
			from Parametros
			where Ecodigo = #Arguments.Ecodigo#
			  and Pcodigo = 60
			  and Mcodigo = 'GN'
		</cfquery>
		
		<cfif rsPeriodo.recordcount LTE 0>
			<cf_errorCode	code = "51645" msg = "No se ha definido el Mes Auxiliar!">
		</cfif>
		<cfreturn rsPeriodo.Pvalor>
	</cffunction>
	<!---***************************PARAMETRO**********************************************--->
	<!---Considerar traslados, retiros y Revaluaciónes del último periodo en la Revaluación--->
	<!---**********************************************************************************--->
	<cffunction name="fnGetProRev" access="public" output="true" returntype="numeric">
		<cfargument name="Conexion" 	type="string" 	required="no">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no">
		
		<cfif not isdefined('Arguments.Ecodigo') or len(trim(Arguments.Ecodigo)) LTE 0 or Arguments.Ecodigo LTE 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfset VALUE= 0>
		<cfquery name="ProRev" datasource="#Arguments.Conexion#">
			select <cf_dbfunction name="to_number" datasource="#Arguments.Conexion#" args="Pvalor"> as Pvalor
			from Parametros
			where Ecodigo = #Arguments.Ecodigo#
			  and Pcodigo = 1600
			  and Mcodigo = 'AF'
		</cfquery>
		<cfif ProRev.recordcount GT 0 AND (LEN(RTRIM(ProRev.Pvalor)))>
			<cfset VALUE = #ProRev.Pvalor#>
		</cfif>
		<cfreturn VALUE>
	</cffunction>
	<!---******************************************************************************************************--->
	<!---Genera una fecha a partir de la fecha indicada(periodo/mes/dia) y le suma el AumentoIndicado------------->
    <!--- yyyy: Year/q: Quarter/m: Month/y: Day of year/d: Day/w: Weekday/ww: Week/h: Hour/ n: Minute/s: Second--->
	<!---******************************************************************************************************--->
	<cffunction name="fnAumentarFecha" access="public" returntype="any">
		<cfargument name="periodo" 					type="numeric" required="yes">
		<cfargument name="mes" 						type="numeric" required="yes">
		<cfargument name="Aumento" 					type="numeric" required="yes">
		<cfargument name="DiaInicio" 				type="numeric" required="no" default="1">
		<cfargument name="tipoAumento" 				type="string"  required="no" default="m">
		<cfargument name="DepAdq" 					type="numeric"  required="no" default="0">

		<cfif NOT listfind("yyyy,q,m,y",LCase(Arguments.tipoAumento))>
			<cfthrow message="El tipo de Aumento de Fecha no es permitido.">
		</cfif>

		<cfset FechaIni = CreateDate(Arguments.periodo, Arguments.mes, Arguments.DiaInicio)>
	<cfif Arguments.DepAdq eq 1>
		<cfset FechaCal = FechaIni>
	<cfelse>
		<cfset FechaCal = dateadd("#LCase(Arguments.tipoAumento)#",Arguments.Aumento,FechaIni)>
	</cfif>
		<cfreturn FechaCal>
	</cffunction>
	<!---**********************************************************************************--->
	<!---Obtiene la fecha auxiliar, Depreciacion y revaluacion para el activo fijo--->
	<!---Devuelve un array con las fechas(auxiliar, Depreciacion, revaluacion, periodo y mes) con el respectivo orden--->
	<!---**********************************************************************************--->
	<cffunction name="fnGetFechas" access="public" returntype="array">
		<cfargument name="DiaInicio" 			type="numeric" 	required="no" default="1">
		<cfargument name="Conexion" 			type="string" 	required="no" default="#session.dsn#">
		<cfargument name="Ecodigo" 				type="numeric" 	required="no" default="#session.Ecodigo#">
        <cfargument name="FechaAdquisicionCxP" 	type="date" 	required="no" default="#LSDateFormat(Now(),'dd/mm/yyyy')#">
        <cfargument name="Parametro3805" 		type="numeric" 	required="no" default="0">
		<cfargument name="DepAdq" 				type="numeric"  required="no" default="0">
		<!--- DepAdq= si esta en 1 obtiene el mismo mes de la fecha inicio  --->


		<!--- Obtiene los meses para calcular la fecha de Depreciacion --->
		<cfquery name="Depreciacion" datasource="#Arguments.Conexion#">
			select Pvalor as  valor
			from Parametros p
			where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
				and p.Pcodigo = 940
		</cfquery>
		<cfif Depreciacion.recordcount eq 0 or not len(trim(Depreciacion.valor))>
			<cfthrow message="Los meses de Depreciación no estan definidos en los parametros del sistema">
		</cfif> 


		<!--- Obtiene los meses para calcular la fecha de revaluacion --->
		<cfquery name="Revaluacion" datasource="#Arguments.Conexion#">
			select <cf_dbfunction name="to_number" datasource="#Arguments.Conexion#" args="Pvalor"> as  valor
			from Parametros p
			where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
				and p.Pcodigo = 950
		</cfquery>
		<cfif Revaluacion.recordcount eq 0 or not len(trim(Revaluacion.valor))>
			<cfthrow message="Los meses de Revaluación no estan definidos en los parametros del sistema">
		</cfif> 

		<!--- Si el parametro 3805 esta apagado la fecha de adquisición del activo es el día primero del periodo mes de auxiliares --->
		<cfif not arguments.Parametro3805>
			<cfset periodo 			 = fnGetPeriodoAux(Arguments.Conexion,Arguments.Ecodigo)>
			<cfset mes 				 = fnGetMesAux(Arguments.Conexion,Arguments.Ecodigo)>
            <cfset LvarFechaAuxiliar = CreateDate(Periodo, mes, Arguments.DiaInicio)>
        	<cfset rsFechaIniDepr =fnAumentarFecha(periodo, mes, Depreciacion.valor, Arguments.DiaInicio,'m',Arguments.DepAdq)>
			<cfset rsFechaIniRev = fnAumentarFecha(periodo, mes, Revaluacion.valor, Arguments.DiaInicio,'m',Arguments.DepAdq)>
        <cfelse>
        	<!--- Si el parametro 3805 esta activo la fecha de adquisición del activo es la fecha del encabezado de la factura de CxP --->
            <cfset periodo 			 = fnGetPeriodoAux(Arguments.Conexion,Arguments.Ecodigo)>
			<cfset mes 				 = fnGetMesAux(Arguments.Conexion,Arguments.Ecodigo)>
            
			<cfset Periodo3805 = datepart('yyyy',arguments.FechaAdquisicionCxP)>
            <cfset Mes3805 = datepart('m',arguments.FechaAdquisicionCxP)>
            <cfset Arguments.DiaInicio = datepart('d',arguments.FechaAdquisicionCxP)>
            <cfset LvarFechaAuxiliar = CreateDate(Periodo3805, Mes3805, Arguments.DiaInicio)>
            <cfset rsFechaIniDepr =fnAumentarFecha(Periodo3805, Mes3805, Depreciacion.valor, Arguments.DiaInicio,'m',Arguments.DepAdq)>
			<cfset rsFechaIniRev = fnAumentarFecha(Periodo3805, Mes3805, Revaluacion.valor, Arguments.DiaInicio,'m',Arguments.DepAdq)>
		</cfif>

		
		<!--- Ingresa las fechas en un array--->
		<cfset arrayFechas = ArrayNew(1)>
		<cfset ArrayAppend(arrayFechas,LvarFechaAuxiliar)>
		<cfset ArrayAppend(arrayFechas,rsFechaIniDepr)>
		<cfset ArrayAppend(arrayFechas,rsFechaIniRev)>
		<cfset ArrayAppend(arrayFechas,periodo)>
		<cfset ArrayAppend(arrayFechas,mes)>
		<cfreturn arrayFechas>
	</cffunction>	
</cfcomponent>