<!---
	Interfaz 200 
	Interfaz SIME
	Dirección de la Inforamción: Sistema Externo - SIF
	Elaborado por: Alexander Rodríguez (arodriguez@soin.co.cr)
	Fecha de U. Modificación: 26-11-2007
	Motivo de la Modificación: 
--->
<cfsetting requesttimeout="3600">
<!--- Crea Instancia de Componente de Interfaces para reportar actividad de la intarfaz --->
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- Crea Transacción para Leer Encabezado de Activos de la BD de Interfaces. --->
<cftransaction isolation="read_uncommitted">
	<!--- Lee Activos por procesar. --->
	<cfquery name="rsDatos" datasource="sifinterfaces">
		select a.*, b.Aid
		  from IE200 a
			left join <cf_dbdatabase datasource="#Session.Dsn#" table="Activos"> b
				on b.Aplaca = a.placa
		 where a.ID = #GvarID#
	</cfquery>

	<!--- Valida que vengan datos --->
	<cfif rsDatos.recordCount eq 0>
		<cfthrow message="Error en Interfaz 200. No existen datos de Entrada para el Lote ='#GvarID#'. Proceso Cancelado!.">
	</cfif>
</cftransaction>

<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<!--- *************************************************** --->
<!--- **Inicia el proceso de validacion de datos** --->
<!--- *************************************************** --->

<!--- Verifica el Concepto Contable "Lote" --->
<cfquery name="rsVerificaLote" datasource="sifinterfaces">
	insert into ERR200(ID, placa, tipoTrans, mensaje)
	select 	#GvarID#,
			a.placa, 
			a.estado, 
			'ERROR: Lote incorrecto' as message
	from IE200 a
	where  
		(
			select count(1)
			from <cf_dbdatabase datasource="#Session.Dsn#" table="ConceptoContableE"> b
			where b.Cconcepto	= a.lote
			  and b.Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		) = 0
	  and a.ID = #GvarID#
</cfquery>

<!--- Verifica que exista la categoría en el activo--->
<cfquery name="rsVerificaCat" datasource="sifinterfaces">
	insert into ERR200(ID, placa, tipoTrans, mensaje)
	Select 	#GvarID#,
			a.placa, 
			a.estado, 
			'ERROR: Codigo de Categoria incorrecto.' as message
	from IE200 a
	where 
		(
			select count(1)
			from <cf_dbdatabase datasource="#Session.Dsn#" table="ACategoria"> b
			where b.Ecodigo			= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and b.ACcodigodesc	= a.categoria
		) = 0
	  and a.ID = #GvarID#
</cfquery>	

<!--- Verifica que el activo tenga asociado la categoría con la clasificación--->
<cfquery name="rsVerificaCatClas" datasource="sifinterfaces">
	insert into ERR200(ID, placa, tipoTrans, mensaje)
	Select 	#GvarID#,
			a.placa, 
			a.estado, 
			'ERROR: La Clase no es válida con respecto a la Categoría, ó la Clase no existe.' as message
	from IE200 a
	where (
			Select count(1)
			  from <cf_dbdatabase datasource="#Session.Dsn#" table="AClasificacion"> b 						
					inner join <cf_dbdatabase datasource="#Session.Dsn#" table="ACategoria"> c
						on a.categoria = c.ACcodigodesc
						and c.ACcodigo= b.ACcodigo
						and b.Ecodigo= c.Ecodigo							   
			  where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and b.ACcodigodesc = a.clase
			) = 0
	  and a.ID = #GvarID#
</cfquery>

<!--- 
Valores del estado
------------------
1 - Adquisicion
2 - Traslados
3 - Retiros
------------------
--->

<!--- Verifica el estado --->
<cfquery name="rsVerificaLote" datasource="sifinterfaces">
	insert into ERR200(ID, placa, tipoTrans, mensaje)
	Select 	#GvarID#,
			a.placa, 
			a.estado, 
			'ERROR: Estado incorrecto.' as message
	from IE200 a
	where a.estado NOT IN (1,2,3)
	  and a.ID = #GvarID#
</cfquery>

<!--- Verifica que NO exista la placa en Activos ó en CRDocumentoResponsabilidad--->
<cfquery name="rsVerificaPlaca" datasource="sifinterfaces">
	insert into ERR200(ID, placa, tipoTrans, mensaje)
	Select 	#GvarID#,
			a.placa, 
			a.estado, 
			'ERROR: El Activo a adquirir ya existe en el sistema.' as message
	  from IE200 a
	 where 
		(
			Select count(1)
			  from <cf_dbdatabase datasource="#Session.Dsn#" table="Activos"> b
			 where a.placa = b.Aplaca
			   and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		) + (
			Select count(1)
			  from <cf_dbdatabase datasource="#Session.Dsn#" table="CRDocumentoResponsabilidad"> r
			 where a.placa = r.CRDRplaca
			   and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		) > 0
	   and a.ID = #GvarID#
	   and a.estado = 1
</cfquery>	

<!--- Verifica que exista la placa en AFResponsables con un vale vigente (TRASLADOS) --->
<cfquery name="rsVerificaPlaca" datasource="sifinterfaces">
	insert into ERR200(ID, placa, tipoTrans, mensaje)
	Select 	#GvarID#,
			a.placa, 
			a.estado, 
			case 
				when a.estado = 2 then
					'ERROR: El Activo a trasladar no existe en el sistema'
				else
					'ERROR: El Activo a retirar no existe en el sistema'
			end as message
	from IE200 a
	where 
		(
			Select count(1)
			  from <cf_dbdatabase datasource="#Session.Dsn#" table="Activos"> b
			 where b.Aplaca = a.placa
			   and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">					
		) = 0
	  and a.ID = #GvarID#
	  and a.estado <> 1
</cfquery>

<!--- Verifica que exista la placa en AFResponsables con un vale vigente (TRASLADOS) --->
<cfquery name="rsVerificaPlaca" datasource="sifinterfaces">
	insert into ERR200(ID, placa, tipoTrans, mensaje)
	Select 	#GvarID#,
			a.placa, 
			a.estado, 
			case 
				when a.estado = 2 then
					'ERROR: El Activo a trasladar no tiene un documento de responsabilidad(VALE) vigente.' 
				else
					'ERROR: El Activo a retirar no tiene un documento de responsabilidad(VALE) vigente.' 
			end as message
	  from IE200 a
	 where 	(
				Select count(1)
				  from <cf_dbdatabase datasource="#Session.Dsn#" table="Activos"> b
				 where b.Aplaca = a.placa
				   and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">					
			) > 0
	  and	(
				Select count(1)
				  from <cf_dbdatabase datasource="#Session.Dsn#" table="Activos"> b
					inner join <cf_dbdatabase datasource="#Session.Dsn#" table="AFResponsables"> r
						on r.Aid = b.Aid
						  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">					
						  and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between r.AFRfini and r.AFRffin
				 where b.Aplaca  = a.placa
				   and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">					
			) = 0
	   and a.ID = #GvarID#
	   and a.estado <> 1
</cfquery>

<!--- Verifica que exista la marca en el activo--->
<cfquery name="rsVerificaMarca" datasource="sifinterfaces">
	insert into ERR200(ID, placa, tipoTrans, mensaje)
	Select 	#GvarID#,
			a.placa, 
			a.estado, 
			'ERROR: La Marca es incorrecta.' as message
	  from IE200 a
	 where	(
	 			Select count(1)
				  from <cf_dbdatabase datasource="#Session.Dsn#" table="AFMarcas"> b
				 where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				   and b.AFMcodigo = a.marca
			) = 0
	   and a.ID = #GvarID#
</cfquery>

<!--- Verifica que el activo tenga asociado el modelo con la marca--->
<cfquery name="rsVerificaModMar" datasource="sifinterfaces">
	insert into ERR200(ID, placa, tipoTrans, mensaje)
	Select 	#GvarID#,
			a.placa, 
			a.estado, 
			'ERROR: El Modelo no es válido con respecto a la Marca, ó el Modelo no existe.' as message
	from IE200 a
	where 	(	
			  Select count(1)
				From <cf_dbdatabase datasource="#Session.Dsn#" table="AFMarcas"> b
					inner join <cf_dbdatabase datasource="#Session.Dsn#" table="AFMModelos"> c
					  on b.AFMid = c.AFMid 
					  and b.Ecodigo = c.Ecodigo 
						where a.modelo= c.AFMMcodigo
						  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			) = 0
	  and a.ID = #GvarID#
</cfquery>

<!--- Verifica que exista el tipo en el activo--->
<cfquery name="rsVerificaTipo" datasource="sifinterfaces">
	insert into ERR200(ID, placa, tipoTrans, mensaje)
	Select 	#GvarID#,
			a.placa, 
			a.estado, 
			'ERROR: El activo no posee un tipo válido.' as message
	from IE200 a
	where	(
				Select count(1)
				  from <cf_dbdatabase datasource="#Session.Dsn#" table="AFClasificaciones"> b
				 where a.tipo = b.AFCcodigoclas
				   and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			) = 0
	  and a.ID = #GvarID#
</cfquery>

<!--- Verifica que exista el tipo de documento en el activo--->
<cfquery name="rsVerificaTipoDoc" datasource="sifinterfaces">
	insert into ERR200(ID, placa, tipoTrans, mensaje)
	Select 	#GvarID#,
			a.placa, 
			a.estado, 
			'ERROR: El activo no posee un tipo de documento válido.' as message
	from IE200 a
	where	(
				Select count(1)
				  from <cf_dbdatabase datasource="#Session.Dsn#" table="CRTipoDocumento"> b
				 where a.tipoDocumento = b.CRTDcodigo
				   and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			) = 0
	  and a.ID = #GvarID#
</cfquery>

<!--- Verifica que exista el empleado en el activo--->
<cfquery name="rsVerificaEmpleado" datasource="sifinterfaces">
	insert into ERR200(ID, placa, tipoTrans, mensaje)
	Select 	#GvarID#,
			a.placa, 
			a.estado, 
			'ERROR: El activo no posee un empleado válido.' as message
	from IE200 a
	where	(
				Select count(1)
				  from <cf_dbdatabase datasource="#Session.Dsn#" table="DatosEmpleado"> b
				 where b.DEidentificacion = a.empleado
				   and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			) = 0
	  and a.ID = #GvarID#		
</cfquery>

<!--- Verifica que exista el centro funcional en el activo--->
<cfquery name="rsVerificaCF" datasource="sifinterfaces">
	insert into ERR200(ID, placa, tipoTrans, mensaje)
	Select 	#GvarID#,
			a.placa, 
			a.estado, 
			'ERROR: El activo no posee un centro funcional válido.' as message	
	from IE200 a
	where	(
				Select count(1)
				  from <cf_dbdatabase datasource="#Session.Dsn#" table="CFuncional"> b
				 where b.CFcodigo = a.centroFuncional
				   and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			) = 0
	  and a.ID = #GvarID#
</cfquery>

<!--- Verifica que exista un tipo de compra en el activo--->
<cfquery name="rsVerificaTC" datasource="sifinterfaces">
	insert into ERR200(ID, placa, tipoTrans, mensaje)
	Select 	#GvarID#,
			a.placa, 
			a.estado, 
			'ERROR: El activo no posee un tipo de compra válido.' as message
	from IE200 a 
	where	(
				Select count(1)
				from <cf_dbdatabase datasource="#Session.Dsn#" table="CRTipoCompra"> b
				where a.tipoCompra = b.CRTCcodigo
				  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			) = 0
	  and a.ID = #GvarID#
</cfquery>

<!--- Verifica que exista un centro de custodia en el activo--->
<cfquery name="rsVerificaCC" datasource="sifinterfaces">
	insert into ERR200(ID, placa, tipoTrans, mensaje)
	Select 	#GvarID#,
			a.placa, 
			a.estado, 
			'ERROR: El activo no posee un centro de custodia válido.' as message
	from IE200 a
	where	(
				Select count(1)
					from <cf_dbdatabase datasource="#Session.Dsn#" table="CRCentroCustodia"> b
					where a.centroCustodia = b.CRCCcodigo
					  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			) = 0
	  and a.ID = #GvarID#
</cfquery>	

<cfquery name="rsErrores" datasource="sifinterfaces">
	Select count(1) as total
	from ERR200
</cfquery>
<cfif rsErrores.total GT 0>
	<cfreturn ""/>
</cfif>

<!--- *************************************************************** --->
<!--- *** INICIA EL PROCESAMIENTO DE LOS DATOS ACTIVO POR ACTIVO **** --->
<!--- *************************************************************** --->

<cftransaction>
	<cfloop query="rsDatos">
		<!--- Reporta actividad de la intarfaz --->
		<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

		<cfset LvarTipodeTransaccion = rsDatos.estado>
		
		<cfif LvarTipodeTransaccion eq 1> <!--- Proceso de Adquisicion --->
			<!---Inserta el Documento correspondiente al Activo --->			
			<cfquery name="rsInsertaDoc" datasource="Session.Dsn">
				insert into CRDocumentoResponsabilidad(
							CRDRplaca, 
							CRDRdescripcion, 
							CRDRdescdetallada, 
							CRDRserie, 
							Monto, 
							CRDRfalta,
							CRDRdocori, 
							CRDRestado)
				values(	
					<cfqueryparam cfsqltype="cf_sql_char" value="#rsDatos.placa#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#rsDatos.descripcion#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#rsDatos.descDetallada#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#rsDatos.serie#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.monto#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#rsDatos.fecha#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#rsDatos.documento#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.estado#">)
			</cfquery>
									
		<cfelseif LvarTipodeTransaccion eq 2> <!--- Proceso de Traslado --->
				
				<!--- Genera la Transacción --->
				<cfinvoke component="sif.Componentes.AF_TrasladoActivos" method="AltaRelacion"
					returnvariable="rsResultadosRA">
					<cfinvokeargument name="AGTPdescripcion" value="#rsDatos.descripcion#">
					<cfinvokeargument name="AGTPrazon" value="#rsDatos.descDetallada#">
					<cfinvokeargument name="debug" value="False">
				</cfinvoke>
				<cfset AGTPid = rsResultadosRA>
				
				<!--- Asocia el Activo a la Transacción --->
				<cfinvoke component="sif.Componentes.AF_TrasladoActivos" method="AltaActivo"
					returnvariable="rsResultadosRA">
					<cfinvokeargument name="AGTPid" value="#AGTPid#">
					<cfinvokeargument name="ADTPrazon" value="#rsDatos.descDetallada#">
					<cfinvokeargument name="Aid" value="#rsDatos.Aid#">
					<cfinvokeargument name="debug" value="false">
				</cfinvoke>
				
				<!--- Genera el Asiento Contable --->
				<cfinvoke component="sif.Componentes.AF_ContabilizarTraslado" method="AF_ContabilizarTraslado" 
					returnvariable="rsResultadosRT">
					<cfinvokeargument name="AGTPid" value="#AGTPid#">
					<cfinvokeargument name="debug" value="false">
				</cfinvoke>
						
		<cfelseif LvarTipodeTransaccion eq 3> <!--- Proceso de Retiro --->
				
				<!--- Genera la Transacción --->
				<cfinvoke component="sif.Componentes.AF_RetiroActivos" method="AltaRelacion"
						returnvariable="rsResultadosRE">
					<cfinvokeargument name="AGTPdescripcion" value="#rsDatos.descripcion#">
					<cfinvokeargument name="AGTPrazon" value="#rsDatos.descDetallada#">
					<cfinvokeargument name="RetiroCR" value="true">			
				</cfinvoke>
				<cfset AGTPid = rsResultadosRE>
				
				<!--- Asocia el Activo a la Transacción --->
				<cfinvoke component="sif.Componentes.AF_RetiroActivos" method="AltaActivo"
					returnvariable="rsResultadosRE">
					<cfinvokeargument name="AGTPid" value="#AGTPid#">
					<cfinvokeargument name="ADTPrazon" value="#rsDatos.descDetallada#">
					<cfinvokeargument name="Aid" value="#rsDatos.Aid#">
				</cfinvoke>
				
				<!--- Genera el Asiento Contable --->
				<cfinvoke component="sif.Componentes.AF_ContabilizarRetiro" method="AF_ContabilizarRetiro" 
					returnvariable="rsResultadosRT">
					<cfinvokeargument name="AGTPid" value="#AGTPid#">
					<cfinvokeargument name="debug" value="false">
				</cfinvoke>
		</cfif>	
	</cfloop>
</cftransaction>

<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
