<cfcomponent>
	<cfset rsFPCCconcepto = QueryNew("ID","VarChar")>
	<cfset QueryAddRow(rsFPCCconcepto, 10)>
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "1", 1)> <!---Otros--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "2", 2)> <!---Concepto Salarial--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "3", 3)> <!---Amortización de prestamos--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "4", 4)> <!---Financiamiento--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "5", 5)> <!---Patrimonio--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "6", 6)> <!---Ventas--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "F", 7)> <!---Activos--->
	<cfset ListFPCCconcepto = left(ValueList(rsFPCCconcepto.ID), LEN(ValueList(rsFPCCconcepto.ID))-3)> 
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "S", 8)> <!---Servicio--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "A", 9)> <!---Articulos de Inventario--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "P", 10)><!---Obras en Proceso--->
	<cfset ListFPCCconceptoALL = ValueList(rsFPCCconcepto.ID)> 
	<cfset ExigeAuxiliar = "F,A,S,P">
	<!---=======Agrega un nuevo encabezado de estimacion de Gasto o Ingreso en la formulación de presupuesto =======--->
	<cffunction name="AltaEncabezadoEstimacion"  access="public" returntype="numeric">
		<cfargument name="Conexion" 	    type="string"   required="no">
		<cfargument name="Ecodigo" 		    type="numeric"  required="no">
		<cfargument name="CFid" 	    	type="numeric"  required="yes">
		<cfargument name="CPPid"  			type="numeric"  required="yes">
		<cfargument name="FPEEFechaLimite" 	type="date"  	required="no">
		<cfargument name="FPEEestado" 	    type="numeric"  required="no">
		<cfargument name="FPEEUsucodigo" 	type="numeric"  required="no">
		<cfargument name="BMUsucodigo"      type="numeric"  required="no">
		<cfargument name="FPTVid" 	    	type="numeric"  required="no">
		<cfargument name="FPEEVersion" 	    type="numeric"  required="no">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif> 
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif> 
		<cfif not isdefined('Arguments.BMUsucodigo')>
			<cfset Arguments.BMUsucodigo = "#Session.Usucodigo#">
		</cfif> 
		<cfif not isdefined('Arguments.FPEEUsucodigo')>
			<cfset Arguments.FPEEUsucodigo = "#Session.Usucodigo#">
		</cfif> 
		<cfif not isdefined('Arguments.FPTVid')>
			<cfquery name="EO" datasource="#session.dsn#">
				select FPTVid 
					from TipoVariacionPres
				where FPTVTipo = - 1
				  and Ecodigo = #Session.Ecodigo#
				order by FPTVCodigo, FPTVDescripcion
			</cfquery>
			<cfif EO.recordcount eq 0>
				<cfthrow message="No existe un tipo 'Presupuesto Ordinario' en 'Tipos de Variaciones Presupuestales', Proceso cancelado">
			<cfelse>
				<cfset Arguments.FPTVid = EO.FPTVid>
			</cfif>
		<cfelse>
			<cfquery name="TVP" datasource="#session.dsn#">
				select 1 
					from TipoVariacionPres
				where Ecodigo = #Session.Ecodigo#
					and FPTVid = #Arguments.FPTVid#
				order by FPTVCodigo, FPTVDescripcion
			</cfquery>
			<cfif TVP.recordcount eq 0>
				<cfthrow message="No existe #Arguments.FPTVid# en 'Tipos de Variaciones Presupuestales', Proceso cancelado">
			</cfif>
		</cfif> 
		<cfif not isdefined('Arguments.FPEEVersion')>
			<cfset Arguments.FPEEVersion = "null">
		</cfif> 
		<cfif not isdefined('Arguments.FPEEFechaLimite')>
			<cfset Arguments.FPEEFechaLimite = "null">
		</cfif> 
		<!---Valida que el centro Funcional Exista para la empresa--->
		<cfquery datasource="#Arguments.Conexion#" name="rsCentroF">
			select count(1) cantidad 
				from CFuncional 
			where CFid    = #Arguments.CFid# 
			  and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfif rsCentroF.cantidad EQ 0>
			<cfthrow message="El centro Funcional no existe en la Empresa">
		</cfif>
		<cfquery datasource="#Arguments.Conexion#" name="rsAltaEstimacion">
			insert into FPEEstimacion
			(Ecodigo,CFid,CPPid,FPEEFechaLimite,FPEEestado,FPEEUsucodigo,BMUsucodigo,FPTVid,FPEEVersion)
			values
			(
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.Ecodigo#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Trim(Arguments.CFid)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Trim(Arguments.CPPid)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_date" 		value="#Trim(Arguments.FPEEFechaLimite)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Trim(Arguments.FPEEestado)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Trim(Arguments.FPEEUsucodigo)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.BMUsucodigo#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.FPTVid#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.FPEEVersion#">
			 )
		<cf_dbidentity1>
		</cfquery>
			  <cf_dbidentity2 name="rsAltaEstimacion">
			  <cfreturn #rsAltaEstimacion.identity#>
	</cffunction>
	<!---=======Modifica el encabezado de estimacion de Gasto o Ingreso en la formulación de presupuesto =======--->
	<cffunction name="CambioEncabezadoEstimacion"  access="public" returntype="numeric">
		<cfargument name="FPEEid" 		    type="numeric"  required="yes">
		<cfargument name="CFid" 	    	type="numeric"  required="no">
		<cfargument name="CVid"  			type="numeric"  required="no">
		<cfargument name="FPEEFechaLimite" 	type="date"  	required="no">
		<cfargument name="FPEEestado" 	    type="numeric"  required="no">
		<cfargument name="Conexion" 	    type="string"   required="no" default="#session.dsn#">
		<cfargument name="Ecodigo" 		    type="numeric"  required="no" default="#session.Ecodigo#">
		<cfargument name="BMUsucodigo"      type="numeric"  required="no" default="#Session.Usucodigo#">
		<cfargument name="FPEEVersion" 	    type="numeric"  required="no">
		<cfif not isdefined('Arguments.CFid')>
			<cfset Arguments.DPDEfechaFin = "null">
		</cfif> 
		<cfquery datasource="#Arguments.Conexion#" name="rsCambioEstimacion">
			update FPEEstimacion set
				<cfif isdefined('Arguments.CFid')>
				CFid				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Trim(Arguments.CFid)#">,
				</cfif>
				<cfif isdefined('Arguments.CVid')>
				CVid				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Trim(Arguments.CVid)#">,
				</cfif>
				<cfif isdefined('Arguments.FPEEFechaLimite')>
				FPEEFechaLimite		= <cf_jdbcquery_param cfsqltype="cf_sql_date" 			value="#Trim(Arguments.FPEEFechaLimite)#">,
				</cfif>
				<cfif isdefined('Arguments.FPEEestado')>
				FPEEestado			= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Trim(Arguments.FPEEestado)#">,
				</cfif>
				BMUsucodigo			= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.BMUsucodigo#">,
				Ecodigo				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.Ecodigo#">
				<cfif isdefined('Arguments.FPEEVersion')>
				,FPEEVersion				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Trim(Arguments.FPEEVersion)#">
				</cfif>
			where
				FPEEid 				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Trim(Arguments.FPEEid)#">
		</cfquery>
			
		<cfreturn #Arguments.FPEEid#>
	</cffunction>
	<!---=======Agrega un nuevo Detalle de estimacion de Gasto o Ingreso en la formulación de presupuesto =======--->
	<cffunction name="AltaDetalleEstimacion"  access="public">
		<cfargument name="Conexion" 	     type="string"   required="no">
		<cfargument name="Ecodigo" 		     type="numeric"  required="no">
		<cfargument name="BMUsucodigo"       type="numeric"  required="no">
		<cfargument name="DPDEfechaIni" 	 type="date"  	 required="no">
		<cfargument name="DPDEfechaFin" 	 type="date"     required="no">
		<cfargument name="Dtipocambio" 	     type="any"      required="no" default="1">
		<cfargument name="Ucodigo" 	    	 type="string"   required="no" default="null">
		<cfargument name="Aid" 	     		 type="numeric"  required="no">
		<cfargument name="Cid" 	     		 type="numeric"  required="no">
		<cfargument name="FPCid" 	     	 type="numeric"  required="no">
		<cfargument name="FPCCid" 	    	 type="numeric"  required="no"><!---FPCCid=(Formulacion Presupuesto Clasificación Conceptos)--->
		
		<cfargument name="FPEEid" 	    	 type="numeric"  required="yes"><!---FPEEid=(Formulacion Presupuesto Encabezado Estimación)  --->
		<cfargument name="FPEPid" 	    	 type="numeric"  required="yes"><!---FPEPid=(Formulacion Presupuesto Encabezado Plantilla)   --->
		
		<cfargument name="DPDEdescripcion" 	 type="string"   required="yes">
		<cfargument name="DPDEjustificacion" type="string"   required="yes">
		<cfargument name="DPDEcantidad" 	 type="numeric"  required="yes">
		<cfargument name="Mcodigo" 	    	 type="numeric"  required="yes">
		<cfargument name="DPDEcosto" 	     type="any"      required="yes">
		
		<cfargument name="FPAEid" 	     	 	type="numeric"  	required="yes">
		<cfargument name="CFComplemento" 	 	type="string"   	required="yes">
		<cfargument name="DPDMontoTotalPeriodo" type="numeric"   	required="yes">
		<cfargument name="DPDEcantidadPeriodo" 	type="numeric"   	required="no">
		<cfargument name="OBOid" 				type="string"   	required="no" default="">
		<cfargument name="DPDEcontratacion" 	type="string"   	required="no" default="null">
		<cfargument name="DPDEmontoMinimo" 		type="string"   	required="no" default="0">
		<cfargument name="DPDEmontoAjuste" 		type="string"   	required="no" default="null">
  
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = #session.dsn#>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = #session.Ecodigo#>
		</cfif>
		<cfif not isdefined('Arguments.BMUsucodigo')>
			<cfset Arguments.BMUsucodigo = #session.Usucodigo#>
		</cfif>
		
		<cf_dbfunction name="OP_concat"	datasource="#Arguments.Conexion#" returnvariable="_Cat">
		<cfset ComplementoActiv  = replace(Arguments.CFComplemento,'-','')>
		 
		<!---Se valida Estimación--->
		<cfquery datasource="#Arguments.Conexion#" name="rsEEstimacion">
			select CFid, CPPid
			    from FPEEstimacion 
			where FPEEid = #Arguments.FPEEid#
		</cfquery>
		<cfif rsEEstimacion.recordCount EQ 0>
			<cfthrow message="El Encabezado de la Estimación de gastos e Ingresos no existe.">
		</cfif>
		<!---Se valida Plantilla--->
		<cfquery datasource="#Arguments.Conexion#" name="rsEPlantilla">
			select FPEPdescripcion,FPCCconcepto,PCGDxPlanCompras, CFid ,PCGDxCantidad
			   from FPEPlantilla 
			 where FPEPid = #Arguments.FPEPid#
		</cfquery>
		<cfif rsEPlantilla.recordcount EQ 0>
			<cfthrow message="La plantilla de Estimación de Ingreso y Egreso no existe.">
		</cfif>
		<cfif rsEPlantilla.FPCCconcepto EQ 'P' and (not isdefined('Arguments.OBOid') or not len(trim(Arguments.OBOid)))>
			<cfthrow message="El Parametro 'OBOid' es requerido cuando el idicador auxiliar de la pantilla es 'Obras en Proceso'.">
		</cfif>
		<!---Centro Funcional donde se tomar la cuenta, Si son Suministros y se configura el CF funcional se toma de lo contrario sera el CF que estima--->
		<cfif ListFind('A',rsEPlantilla.FPCCconcepto) and LEN(TRIM(rsEPlantilla.CFid))>
			<cfset CFid = rsEPlantilla.CFid>
		<cfelse>
			<cfset CFid = rsEEstimacion.CFid>
		</cfif>
		<!---Se valida el concepto de Ingreso o egreso para el caso de Plantillas de Activo, concepto salarial y otros--->
		<cfif ListFind(ListFPCCconcepto,rsEPlantilla.FPCCconcepto)>
			<cfif not isdefined('Arguments.FPCid')>
				<cfthrow message="El Conceptos de Ingresos y Egreso es requerido.">
			</cfif>
			<cfquery datasource="#Arguments.Conexion#" name="rsConcepto">
				select a.FPCCid,a.FPCdescripcion, b.FPCCcomplementoC #_Cat# b.FPCCcomplementoP as CFComplemento,b.FPCCExigeFecha
					from FPConcepto a
						inner join FPCatConcepto b
							on a.FPCCid = b.FPCCid
				where FPCid = #Arguments.FPCid#
			</cfquery>
			<cfif rsConcepto.recordcount EQ 0>
				<cfthrow message="El Conceptos de Ingreso y Egreso no existe.">
			</cfif>
			<cfif rsConcepto.FPCCExigeFecha eq '1' and (not isdefined('Arguments.DPDEfechaIni') or not isdefined('Arguments.DPDEfechaFin'))>
				<cfthrow message="La fecha inicial y fecha final es requerida'.">
			</cfif>
			<cfset Arguments.FPCCid = rsConcepto.FPCCid>
			<cfset ComplementoOGasto = rsConcepto.CFComplemento>
			<cfif not isRelated(Arguments.Conexion, Arguments.FPCCid,Arguments.FPEPid)>
				<cfthrow message="El Conceptos #rsConcepto.FPCdescripcion# no esta ligado a la plantilla #rsEPlantilla.FPEPdescripcion#">
			</cfif>
			<cfif rsEPlantilla.FPCCconcepto eq 'F' and ( not isdefined('Arguments.Ucodigo') or not len(trim(Arguments.Ucodigo)) or Arguments.Ucodigo eq 'null')>
				<cfthrow message="La unidad es requerida en el Indicador Auxiliar 'Activos Fijos'.">
			</cfif>
		</cfif>	
		<!---Valida el Articulo para el caso de plantillas de Inventario--->
		<cfif ListFind('A',rsEPlantilla.FPCCconcepto)>
			<cfif not isdefined('Arguments.Aid')>
				<cfthrow message="El Articulo es requerido.">
			</cfif>
			<cfquery datasource="#Arguments.Conexion#" name="rsArticulo">
				select a.Ccodigo, a.Adescripcion, b.Cdescripcion, b.cuentac as CFComplemento 
					from Articulos a 
						inner join Clasificaciones b
							on a.Ecodigo = b.Ecodigo
							and a.Ccodigo = b.Ccodigo
				where a.Aid = #Arguments.Aid#
			</cfquery>
			<cfif rsArticulo.recordcount EQ 0>
				<cfthrow message="El Articulo no existe.">
			</cfif>
			<cfset ComplementoOGasto = rsArticulo.CFComplemento>
			<cfquery datasource="#Arguments.Conexion#" name="rsClasificacion" maxrows="1">
				select FPCCid,FPCCdescripcion,FPCCExigeFecha
					from FPCatConcepto 
				where Ecodigo = #Arguments.Ecodigo#
				  and FPCCconcepto = 'A'
				  and FPCCTablaC = #rsArticulo.Ccodigo#
				  order by FPCCid
			</cfquery>
			<cfif rsClasificacion.recordCount EQ 0>
				<cfthrow message="El Articulo '#rsArticulo.Adescripcion#'-Clasificación '#rsArticulo.Cdescripcion#' no esta Configurada en ninguna Clasificación de Conceptos de Ingresos y Egresos.">
			</cfif>
			<cfif rsClasificacion.FPCCExigeFecha eq '1' and (not isdefined('Arguments.DPDEfechaIni') or not isdefined('Arguments.DPDEfechaFin'))>
				<cfthrow message="La fecha inicial y fecha final es requerida'.">
			</cfif>
			<cfloop query="rsClasificacion">
				<cfif isRelated(Arguments.Conexion, rsClasificacion.FPCCid,Arguments.FPEPid)>
					<cfset Arguments.FPCCid = rsClasificacion.FPCCid>
					<cfbreak>
				</cfif>
			</cfloop>
			<cfif not isdefined('Arguments.FPCCid')>
				<cfthrow message="Ningunas de las la Clasificaciónes de Ingresos y Egresos esta ligado a la plantilla #rsEPlantilla.FPEPdescripcion#." detail="<br>Articulo: #rsArticulo.Adescripcion#<br>Clasificacion: #rsArticulo.Cdescripcion#">
			</cfif>
			<cfif not isdefined('Arguments.Ucodigo') or not len(trim(Arguments.Ucodigo)) or Arguments.Ucodigo eq 'null'>
				<cfthrow message="La unidad es requerida en el Indicador Auxiliar 'Articulos'.">
			</cfif>
			
		</cfif>	
		<!---Valida el concepto de servicio para el caso de plantillas de servicios--->
		<cfif ListFind('S,P',rsEPlantilla.FPCCconcepto)>
			<cfif not isdefined('Arguments.Cid')>
				<cfthrow message="El Concepto de servicio es requerido.">
			</cfif>
			<cfquery datasource="#Arguments.Conexion#" name="rsServicio">
				select a.CCid, a.Cdescripcion, b.CCdescripcion, b.cuentac as CFComplemento
					from Conceptos a 
						inner join CConceptos b
							on a.CCid = b.CCid
				where a.Cid = #Arguments.Cid#
			</cfquery>
			<cfif rsServicio.recordcount EQ 0>
				<cfthrow message="El concepto de servicio no existe.">
			</cfif>
			<cfset ComplementoOGasto = rsServicio.CFComplemento>
			<cfquery datasource="#Arguments.Conexion#" name="rsClasificacion">
				select FPCCid,FPCCdescripcion ,FPCCExigeFecha
					from FPCatConcepto 
				where Ecodigo = #Arguments.Ecodigo#
				  and FPCCconcepto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEPlantilla.FPCCconcepto#">
				  and FPCCTablaC = #rsServicio.CCid#
			</cfquery>
			<cfif rsClasificacion.recordCount EQ 0>
				<cfthrow message="El concepto del servicio '#rsServicio.Cdescripcion#'-Clasificación '#rsServicio.CCdescripcion#' no esta Configurada en ninguna Clasificación de Conceptos de Ingresos y Egresos.">
			</cfif>
			<cfif rsClasificacion.FPCCExigeFecha eq '1' and (not isdefined('Arguments.DPDEfechaIni') or not isdefined('Arguments.DPDEfechaFin'))>
				<cfthrow message="La fecha inicial y fecha final es requerida'.">
			</cfif>
			<cfloop query="rsClasificacion">
				<cfif isRelated(Arguments.Conexion, rsClasificacion.FPCCid,Arguments.FPEPid)>
					<cfset Arguments.FPCCid = rsClasificacion.FPCCid>
					<cfbreak>
				</cfif>
			</cfloop>
			<cfif not isdefined('Arguments.FPCCid')>
				<cfthrow message="Ningunas de las la Clasificaciónes de Ingresos y Egresos esta ligado a la plantilla #rsEPlantilla.FPEPdescripcion#." detail="<br>Servicio: #rsServicio.Cdescripcion#<br>Clasificacion: #rsServicio.CCdescripcion#">
			</cfif>
			<cfif not isdefined('Arguments.Ucodigo') or not len(trim(Arguments.Ucodigo)) or Arguments.Ucodigo eq 'null'>
				<cfthrow message="La unidad es requerida en el Indicador Auxiliar 'Servicio' o 'Obras'.">
			</cfif>
		</cfif>	
		<!---Se crea la nueva linea--->
		<cfquery datasource="#Arguments.Conexion#" name="rsUltimaLinea">
			select Coalesce(max(FPDElinea),0)+1 FPDElinea from FPDEstimacion where FPEEid = #Arguments.FPEEid#
		</cfquery>
		<cfif not isdefined('Arguments.DPDEfechaIni')>
			<cfset Arguments.DPDEfechaIni = "null">
		</cfif> 
		<cfif not isdefined('Arguments.DPDEfechaFin')>
			<cfset Arguments.DPDEfechaFin = "null">
		</cfif> 
		<cfif not isdefined('Arguments.Aid')>
			<cfset Arguments.Aid = "null">
		</cfif> 
		<cfif not isdefined('Arguments.Cid')>
			<cfset Arguments.Cid = "null">
		</cfif>
		<cfif not isdefined('Arguments.FPCid')>
			<cfset Arguments.FPCid = "null">
		</cfif>
		<cfif rsEPlantilla.PCGDxCantidad EQ 0>
			<cfset Arguments.DPDEcantidadPeriodo = "1">
			<cfset Arguments.DPDEcantidad 		 = "1">
		<cfelseif not isdefined('Arguments.DPDEcantidadPeriodo')>
			<cfset Arguments.DPDEcantidadPeriodo = "0">
		</cfif>
		<cfif not len(trim(Arguments.DPDEmontoMinimo))>
			<cfset Arguments.DPDEmontoMinimo = "0">
		</cfif>
		<cfset PCGcuenta = CreateCFformato(Arguments.Conexion, Arguments.Ecodigo, CFid, rsEPlantilla.FPCCconcepto, ComplementoOGasto,ComplementoActiv, rsEEstimacion.CPPid, Arguments.OBOid)>
		
		<!--- Valida que la cuenta mayor tenga niveles presupuestales--->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select CFformato
			  from PCGcuentas
			 where PCGcuenta = #PCGcuenta#
		</cfquery>
		<cfset Lprm_Cmayor = mid(rsSQL.CFformato,1,4)>
		<cfset Lprm_Fecha=fnFechaDefault()>
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select 	v.CPVid, m.PCEMid
			  from CPVigencia v
				left outer join PCEMascaras m
					 ON m.PCEMid = v.PCEMid
			 where v.Ecodigo = #Arguments.Ecodigo#
			   and v.Cmayor = '#Lprm_Cmayor#'
			   and #dateformat(Lprm_Fecha,"YYYYMM")# between CPVdesdeAnoMes and CPVhastaAnoMes
		</cfquery>
		<cfif rsSql.recordcount eq 0>
			<cfreturn "No hay m&aacute;scara vigente para la Cuenta Mayor '#Lprm_Cmayor#'">
		</cfif>
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select count(1) as niveles
			  from PCNivelMascara
			 where PCEMid = #rsSQL.PCEMid#
			   and PCNpresupuesto = 1
		</cfquery>
		<cfset Lvar_NivelesP = rsSQL.niveles>
		<cfif Lvar_NivelesP EQ 0>
			<cfthrow message="Control de Formato: La Cuenta Mayor tiene una M&aacute;scara que no contiene Niveles de Presupuesto">
		</cfif>
		
		<!--- Cuando el Control es por Presupuesto, no se pueden repetir la Cuenta Presupuestal por Centro Funcional y periodo Presupuestal --->
		<cfif rsEPlantilla.PCGDxPlanCompras EQ 0>
			<cfquery datasource="#Arguments.Conexion#" name="rslineaEstimacion">
				select count(1) cantidad
				   from FPDEstimacion 
				where Ecodigo   = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Ecodigo#">
				  and FPEEid    = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Trim(Arguments.FPEEid)#">
				  and PCGcuenta = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#PCGcuenta#">
			</cfquery>
			<cfif rslineaEstimacion.cantidad GT 0>
				<cfthrow message="Cuando el Control de presupuesto es por Cuenta Presupuestal, no se pueden Repetir cuentas en las líneas de estimación.">
			</cfif>
		</cfif>
		<cfquery datasource="#Arguments.Conexion#" name="rsAltaEstimacion">
			insert into FPDEstimacion
			(Ecodigo,FPEEid,FPEPid,FPDElinea,FPCCid,Aid,Cid,FPCid,DPDEdescripcion,DPDEjustificacion,DPDEfechaIni,DPDEfechaFin,DPDEcosto,DPDEcantidad,Ucodigo,Mcodigo,Dtipocambio,BMUsucodigo,FPAEid,CFComplemento,DPDMontoTotalPeriodo,DPDEcantidadPeriodo,PCGcuenta,OBOid,DPDEcontratacion,DPDEmontoMinimo,DPDEmontoAjuste)
			values
			(
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.Ecodigo#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Trim(Arguments.FPEEid)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Trim(Arguments.FPEPid)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#rsUltimaLinea.FPDElinea#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Trim(Arguments.FPCCid)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Trim(Arguments.Aid)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Trim(Arguments.Cid)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Trim(Arguments.FPCid)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#RTrim(Arguments.DPDEdescripcion)#"   len="256">,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#RTrim(Arguments.DPDEjustificacion)#" len="2000">,
				<cf_jdbcquery_param cfsqltype="cf_sql_date" 		value="#Trim(Arguments.DPDEfechaIni)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_date" 		value="#Trim(Arguments.DPDEfechaFin)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Trim(Arguments.DPDEcosto)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Trim(Arguments.DPDEcantidad)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Trim(Arguments.Ucodigo)#" null="#NOT LEN(Arguments.Ucodigo)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Trim(Arguments.Mcodigo)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Trim(Arguments.Dtipocambio)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.BMUsucodigo#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.FPAEid#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Arguments.CFComplemento#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.DPDMontoTotalPeriodo#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.DPDEcantidadPeriodo#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#PCGcuenta#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.OBOid#" null="#NOT LEN(TRIM(Arguments.OBOid))#">,
			 	<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#RTrim(Arguments.DPDEcontratacion)#" null="#NOT LEN(TRIM(Arguments.DPDEcontratacion))#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.DPDEmontoMinimo#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.DPDEmontoAjuste#">
			 )
		</cfquery>
	</cffunction>
	<!---Eliminacion de un Detalle de estimacion de Gasto o Ingreso en la formulación de presupuesto --->
	<cffunction name="BajaDetalleEstimacion"  access="public">
		<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
		<cfargument name="FPEEid" 	    	type="numeric" required="yes">
		<cfargument name="FPEPid" 	    	type="numeric" required="yes">
		<cfargument name="FPDElinea"      	type="numeric" required="yes">

		<cfquery datasource="#Arguments.Conexion#" name="rsCambioConcepto">
			delete from FPDEstimacion
				where FPEEid    = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPEEid#">
				  and FPEPid	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPEPid#">
				  and FPDElinea = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPDElinea#">
		</cfquery>
	</cffunction>
	<!---=======Modifica un Detalle de estimacion de Gasto o Ingreso en la formulación de presupuesto =======--->
	<cffunction name="CambioDetalleEstimacion"  access="public">
		<cfargument name="Conexion" 	     type="string"   required="no">
		<cfargument name="Ecodigo" 		     type="numeric"  required="no">
		<cfargument name="BMUsucodigo"       type="numeric"  required="no">
		<cfargument name="DPDEfechaIni" 	 type="date"  	 required="no">
		<cfargument name="DPDEfechaFin" 	 type="date"     required="no">
		<cfargument name="Dtipocambio" 	     type="any"      required="no" default="1">
		<cfargument name="Ucodigo" 	    	 type="string"   required="no" default="null">
		<cfargument name="Aid" 	     		 type="numeric"  required="no">
		<cfargument name="Cid" 	     		 type="numeric"  required="no">
		<cfargument name="FPCid" 	     	 type="numeric"  required="no">
		
		<cfargument name="FPEEid" 	    	 type="numeric"  required="yes"><!---FPEEid=(Formulacion Presupuesto Encabezado Estimación)  --->
		<cfargument name="FPEPid" 	    	 type="numeric"  required="yes"><!---FPEPid=(Formulacion Presupuesto Encabezado Plantilla)   --->
		<cfargument name="FPDElinea" 	     type="numeric"  required="yes"><!---FPCCid=(Formulacion Presupuesto Clasificación Conceptos)--->
		<cfargument name="DPDEdescripcion" 	 type="string"   required="yes">
		<cfargument name="DPDEjustificacion" type="string"   required="yes">
		<cfargument name="DPDEcantidad" 	 type="numeric"  required="yes">
		<cfargument name="Mcodigo" 	    	 type="numeric"  required="yes">
		<cfargument name="DPDEcosto" 	     type="any"      required="yes">
		
		<cfargument name="FPAEid" 	     	 type="numeric"  required="yes">
		<cfargument name="CFComplemento" 	 type="string"   required="yes">
		
		<cfargument name="DPDMontoTotalPeriodo" type="numeric"   	required="yes">
		<cfargument name="DPDEcantidadPeriodo" 	type="numeric"   	required="no">
		<cfargument name="OBOid" 				type="string"   	required="no" default="">
		<cfargument name="DPDEcontratacion" 	type="string"   	required="no" default="null">
		<cfargument name="DPDEmontoMinimo" 		type="string"   	required="no" default="0">
		<cfargument name="DPDEmontoAjuste" 		type="string"   	required="no" default="null">
		<cfargument name="EQUILIBRIO" 			type="string"   	required="no" default="N">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = #session.dsn#>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = #session.Ecodigo#>
		</cfif>
		<cfif not isdefined('Arguments.BMUsucodigo')>
			<cfset Arguments.BMUsucodigo = #session.Usucodigo#>
		</cfif>
		
		<cf_dbfunction name="OP_concat"	datasource="#Arguments.Conexion#" returnvariable="_Cat">
		<cfset ComplementoActiv  = replace(Arguments.CFComplemento,'-','')>
		
		<!---Se valida Estimación--->
		<cfquery datasource="#Arguments.Conexion#" name="rsEEstimacion">
			select CFid, CPPid, FPEEestado, FPTVTipo
				from FPEEstimacion a
					inner join TipoVariacionPres b on b.FPTVid = a.FPTVid
			where FPEEid = #Arguments.FPEEid#
		</cfquery>
		<cfif rsEEstimacion.RecordCount EQ 0>
			<cfthrow message="El Encabezado de la Estimación de Ingreso y Egreso no existe.">
		</cfif>
		
		<!---Se valida Plantilla--->
		<cfquery datasource="#Arguments.Conexion#" name="rsEPlantilla">
			select FPEPdescripcion,FPCCconcepto,PCGDxPlanCompras, CFid, PCGDxCantidad, FPEPmultiperiodo
				from FPEPlantilla 
			where FPEPid = #Arguments.FPEPid#
		</cfquery>
		<cfif rsEPlantilla.recordcount EQ 0>
			<cfthrow message="La plantilla de Estimación de Ingreso y Egreso no existe.">
		</cfif>
		<!---Centro Funcional donde se tomar la cuenta, Si son Suministros y se configura el CF funcional se toma de lo contrario sera el CF que estima--->
		<cfif ListFind('A',rsEPlantilla.FPCCconcepto) and LEN(TRIM(rsEPlantilla.CFid))>
			<cfset CFid = rsEPlantilla.CFid>
		<cfelse>
			<cfset CFid = rsEEstimacion.CFid>
		</cfif>	
		<!---Se valida el concepto de Ingreso o egreso--->
		<cfif ListFind(ListFPCCconcepto,rsEPlantilla.FPCCconcepto)>
			<cfif not isdefined('Arguments.FPCid')>
				<cfthrow message="El Conceptos de Ingreso y Egreso es requerido.">
			</cfif>
			<cfquery datasource="#Arguments.Conexion#" name="rsConcepto">
				select a.FPCCid,a.FPCdescripcion, b.FPCCcomplementoC #_Cat# b.FPCCcomplementoP as CFComplemento 
					from FPConcepto a
						inner join FPCatConcepto b
							on a.FPCCid = b.FPCCid
				where FPCid = #Arguments.FPCid#
			</cfquery>
			<cfif rsConcepto.recordcount EQ 0>
				<cfthrow message="El Conceptos de Ingresos y Egreso no existe.">
			</cfif>
			<cfset Arguments.FPCCid  = rsConcepto.FPCCid>
			<cfset ComplementoOGasto = rsConcepto.CFComplemento>
			<cfif not isRelated(Arguments.Conexion, Arguments.FPCCid,Arguments.FPEPid)>
				<cfthrow message="El Conceptos #rsConcepto.FPCdescripcion# no esta ligado a la plantilla #rsEPlantilla.FPEPdescripcion#">
			</cfif>
			<cfif rsEPlantilla.FPCCconcepto eq 'F' and ( not isdefined('Arguments.Ucodigo') or not len(trim(Arguments.Ucodigo)) or Arguments.Ucodigo eq 'null')>
				<cfthrow message="La unidad es requerida en el Indicador Auxiliar 'Activos Fijos'.">
			</cfif>
		</cfif>		
		<!---Valida el Articulo para el caso de plantillas de Inventario--->
		<cfif ListFind('A',rsEPlantilla.FPCCconcepto)>
			<cfif not isdefined('Arguments.Aid')>
				<cfthrow message="El Articulo es requerido.">
			</cfif>
			<cfquery datasource="#Arguments.Conexion#" name="rsArticulo">
				select a.Ccodigo, a.Adescripcion, b.Cdescripcion, b.cuentac as CFComplemento 
					from Articulos a 
						inner join Clasificaciones b
							on a.Ecodigo = b.Ecodigo
							and a.Ccodigo = b.Ccodigo
				where a.Aid = #Arguments.Aid#
			</cfquery>
			<cfif rsArticulo.recordcount EQ 0>
				<cfthrow message="El Articulo no existe.">
			</cfif>
			<cfset ComplementoOGasto = rsArticulo.CFComplemento>
			<cfquery datasource="#Arguments.Conexion#" name="rsClasificacion" maxrows="1">
				select FPCCid,FPCCdescripcion 
					from FPCatConcepto 
				where Ecodigo = #Arguments.Ecodigo#
				  and FPCCconcepto = 'A'
				  and FPCCTablaC = #rsArticulo.Ccodigo#
			</cfquery>
			<cfif rsClasificacion.recordCount EQ 0>
				<cfthrow message="El Articulo '#rsArticulo.Adescripcion#'-Clasificación '#rsArticulo.Cdescripcion#' no esta Configurada en ninguna Clasificación de Conceptos de Ingresos y Egresos.">
			</cfif>
			<cfloop query="rsClasificacion">
				<cfif isRelated(Arguments.Conexion, rsClasificacion.FPCCid,Arguments.FPEPid)>
					<cfset Arguments.FPCCid = rsClasificacion.FPCCid>
					<cfbreak>
				</cfif>
			</cfloop>
			<cfif not isdefined('Arguments.FPCCid')>
				<cfthrow message="Ningunas de las la Clasificaciónes de Ingresos y Egresos esta ligado a la plantilla #rsEPlantilla.FPEPdescripcion#." detail="<br>Articulo: #rsArticulo.Adescripcion#<br>Clasificacion: #rsArticulo.Cdescripcion#">
			</cfif>
			<cfif not isdefined('Arguments.Ucodigo') or not len(trim(Arguments.Ucodigo)) or Arguments.Ucodigo eq 'null'>
				<cfthrow message="La unidad es requerida en el Indicador Auxiliar 'Artículos de Inventario'.">
			</cfif>
		</cfif>	
		<!---Valida el concepto de servicios para el caso de plantillas de servicios--->
		<cfif ListFind('S,P',rsEPlantilla.FPCCconcepto)>
			<cfif not isdefined('Arguments.Cid')>
				<cfthrow message="El Concepto de servicio es requerido.">
			</cfif>
			<cfquery datasource="#Arguments.Conexion#" name="rsServicio">
				select a.CCid, a.Cdescripcion, b.CCdescripcion, b.cuentac as CFComplemento
					from Conceptos a 
						inner join CConceptos b
							on a.CCid = b.CCid
				where a.Cid = #Arguments.Cid#
			</cfquery>
			<cfif rsServicio.recordcount EQ 0>
				<cfthrow message="El concepto de servicio no existe.">
			</cfif>
			<cfset ComplementoOGasto = rsServicio.CFComplemento>
			<cfquery datasource="#Arguments.Conexion#" name="rsClasificacion">
				select FPCCid,FPCCdescripcion 
					from FPCatConcepto 
				where Ecodigo = #Arguments.Ecodigo#
				  and FPCCconcepto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEPlantilla.FPCCconcepto#">
				  and FPCCTablaC = #rsServicio.CCid#
			</cfquery>
			<cfif rsClasificacion.recordCount EQ 0>
				<cfthrow message="El concepto del servicio '#rsServicio.Cdescripcion#'-Clasificación '#rsServicio.CCdescripcion#' no esta Configurada en ninguna Clasificación de Conceptos de Ingresos y Egresos.">
			</cfif>
			<cfloop query="rsClasificacion">
				<cfif isRelated(Arguments.Conexion, rsClasificacion.FPCCid,Arguments.FPEPid)>
					<cfset Arguments.FPCCid = rsClasificacion.FPCCid>
					<cfbreak>
				</cfif>
			</cfloop>
			<cfif not isdefined('Arguments.FPCCid')>
				<cfthrow message="Ningunas de las la Clasificaciónes de Ingresos y Egresos esta ligado a la plantilla #rsEPlantilla.FPEPdescripcion#." detail="<br>Servicio: #rsServicio.Cdescripcion#<br>Clasificacion: #rsServicio.CCdescripcion#">
			</cfif>
			<cfif not isdefined('Arguments.Ucodigo') or not len(trim(Arguments.Ucodigo)) or Arguments.Ucodigo eq 'null'>
				<cfthrow message="La unidad es requerida en el Indicador Auxiliar 'Servicio' o 'Obras'.">
			</cfif>
		</cfif>	
		<cfif not isdefined('Arguments.DPDEfechaIni')>
			<cfset Arguments.DPDEfechaIni = "null">
		</cfif> 
		<cfif not isdefined('Arguments.DPDEfechaFin')>
			<cfset Arguments.DPDEfechaFin = "null">
		</cfif> 
		<cfif not isdefined('Arguments.Aid')>
			<cfset Arguments.Aid = "null">
		</cfif> 
		<cfif not isdefined('Arguments.Cid')>
			<cfset Arguments.Cid = "null">
		</cfif>
		<cfif not isdefined('Arguments.FPCid')>
			<cfset Arguments.FPCid = "null">
		</cfif> 
		<cfif rsEPlantilla.PCGDxCantidad EQ 0>
			<cfset Arguments.DPDEcantidadPeriodo = "1">
			<cfset Arguments.DPDEcantidad 		 = "1">
		<cfelseif not isdefined('Arguments.DPDEcantidadPeriodo')>
			<cfset Arguments.DPDEcantidadPeriodo = "0">
		</cfif>
		<cfif rsEPlantilla.FPEPmultiperiodo NEQ 1>
			<cfset Arguments.DPDMontoTotalPeriodo = replace(Arguments.DPDEcosto,',','') * Arguments.DPDEcantidadPeriodo>
		</cfif>
		<cfif not len(trim(Arguments.DPDEmontoMinimo))>
			<cfset Arguments.DPDEmontoMinimo = "0">
		</cfif>
		<cfset PCGcuenta = CreateCFformato(Arguments.Conexion, Arguments.Ecodigo, CFid, rsEPlantilla.FPCCconcepto, ComplementoOGasto,ComplementoActiv, rsEEstimacion.CPPid, Arguments.OBOid)>
		
		<!--- valida que la cuenta mayor tenga niveles presupuestales--->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select CFformato
			  from PCGcuentas
			 where PCGcuenta = #PCGcuenta#
		</cfquery>
		<cfset Lprm_Cmayor = mid(rsSQL.CFformato,1,4)>
		<cfset Lprm_Fecha=fnFechaDefault()>
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select 	v.CPVid, m.PCEMid, m.PCEMplanCtas
			  from CPVigencia v
				left outer join PCEMascaras m
					 ON m.PCEMid = v.PCEMid
			 where v.Ecodigo = #Arguments.Ecodigo#
			   and v.Cmayor = '#Lprm_Cmayor#'
			   and #dateformat(Lprm_Fecha,"YYYYMM")# between CPVdesdeAnoMes and CPVhastaAnoMes
		</cfquery>
		<cfif rsSql.recordcount eq 0>
			<cfreturn "No hay m&aacute;scara vigente para la Cuenta Mayor '#Lprm_Cmayor#'">
		</cfif>
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select count(1) as niveles
			  from PCNivelMascara
			 where PCEMid = #rsSQL.PCEMid#
			   and PCNpresupuesto = 1
		</cfquery>
		<cfset Lvar_NivelesP = rsSQL.niveles>
		<cfif Lvar_NivelesP EQ 0>
			<cfthrow message="Control de Formato: La Cuenta Mayor tiene una M&aacute;scara que no contiene Niveles de Presupuesto">
		</cfif>
		
		<!--- Cuando el Control es por Presupuesto, no se pueden repetir la Cuenta Presupuestal por Centro Funcional y periodo Presupuestal --->
		<cfif rsEPlantilla.PCGDxPlanCompras EQ 0>
			<cfquery datasource="#Arguments.Conexion#" name="rslineaEstimacion">
				select count(1) cantidad
				   from FPDEstimacion 
				where Ecodigo   =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Ecodigo#">
				  and FPEEid    =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Trim(Arguments.FPEEid)#">
				  and PCGcuenta =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#PCGcuenta#">
				  and FPDElinea <> <cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.FPDElinea#">
			</cfquery>
			<cfif rslineaEstimacion.cantidad GT 0>
				<cfthrow message="Cuando el Control de presupuesto es por Cuenta Presupuestal, no se pueden Repetir cuentas en las líneas de estimación.">
			</cfif>
		</cfif>
		<cfquery datasource="#Arguments.Conexion#" name="rscambioEstimacion">
			update FPDEstimacion set 
			   CFComplemento		= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Trim(Arguments.CFComplemento)#">,
			   PCGcuenta			= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#PCGcuenta#">
			<cfif Arguments.EQUILIBRIO EQ 'N'>
				,Aid 				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Trim(Arguments.Aid)#"> ,
				Cid 				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Trim(Arguments.Cid)#"> ,
				FPCid				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Trim(Arguments.FPCid)#">,
				FPCCid				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Trim(Arguments.FPCCid)#">,
				DPDEdescripcion 	= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#LTrim(Arguments.DPDEdescripcion)#"   len="256">,
				DPDEjustificacion 	= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#LTrim(Arguments.DPDEjustificacion)#" len="2000">,
				DPDEfechaIni		= <cf_jdbcquery_param cfsqltype="cf_sql_date" 			value="#Trim(Arguments.DPDEfechaIni)#">,
				DPDEfechaFin 		= <cf_jdbcquery_param cfsqltype="cf_sql_date" 			value="#Trim(Arguments.DPDEfechaFin)#">,
				DPDEcosto 			= <cf_jdbcquery_param cfsqltype="cf_sql_money" 			value="#Trim(Arguments.DPDEcosto)#">,
				DPDEcantidad 		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Trim(Arguments.DPDEcantidad)#">,
				Ucodigo 			= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Trim(Arguments.Ucodigo)#">,
				Mcodigo 			= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Trim(Arguments.Mcodigo)#">,
				Dtipocambio 		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Trim(Arguments.Dtipocambio)#">,
				BMUsucodigo 		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.BMUsucodigo#">,
				FPAEid				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Trim(Arguments.FPAEid)#">,
				DPDMontoTotalPeriodo= <cf_jdbcquery_param cfsqltype="cf_sql_money" 			value="#Arguments.DPDMontoTotalPeriodo#">,
				DPDEcantidadPeriodo	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.DPDEcantidadPeriodo#">,
				OBOid				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.OBOid#" null="#NOT LEN(TRIM(Arguments.OBOid))#">,
				DPDEcontratacion	= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#LTrim(Arguments.DPDEcontratacion)#" null="#NOT LEN(TRIM(Arguments.DPDEcontratacion))#">,
				DPDEmontoMinimo		= <cf_jdbcquery_param cfsqltype="cf_sql_money" 			value="#Arguments.DPDEmontoMinimo#">,
				DPDEmontoAjuste		= <cf_jdbcquery_param cfsqltype="cf_sql_money" 			value="#Arguments.DPDEmontoAjuste#">
			</cfif>
			where FPEEid    = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FPEEid#">
			  and FPEPid    = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FPEPid#">
			  and FPDElinea = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FPDElinea#">
		</cfquery>
		<cfif rsEEstimacion.FPTVTipo neq -1 and rsEEstimacion.FPEEestado eq '2'>  
			<cfquery datasource="#Arguments.Conexion#" name="rsEstimacionDet">
				select a.DPDEdescripcion, a.PCGDid, 
				coalesce(a.DPDMontoTotalPeriodo,0) * coalesce(a.Dtipocambio,0) - coalesce(b.PCGDautorizado,0) diferienciaMonto, 
				coalesce(b.PCGDautorizado,0) - coalesce(b.PCGDreservado,0) 
					- coalesce(b.PCGDcomprometido,0) - coalesce(b.PCGDejecutado,0) disponibleMonto,
				coalesce(a.DPDEcantidadPeriodo,0) - coalesce(b.PCGDcantidad,0) diferienciaCantidad,
				coalesce(b.PCGDcantidad,0) - coalesce(b.PCGDcantidadCompras,0) 
					- coalesce(b.PCGDcantidadConsumo,0) disponibleCantidad
				from FPDEstimacion a
					left outer join PCGDplanCompras b
						on b.PCGDid = a.PCGDid
					inner join FPEPlantilla c
						on c.FPEPid = a.FPEPid
					where a.FPEEid 		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPEEid#">
					  and a.FPEPid    	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPEPid#">
				  	  and a.FPDElinea 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.FPDElinea#">
					  and a.PCGDid is not null
			</cfquery>
			<cfif len(trim(rsEstimacionDet.PCGDid))><!--- Linea Vieja --->
				<cfset monto = "0">
				<cfset cantidad = "0">
				<cfif rsEstimacionDet.diferienciaMonto lt 0 and rsEstimacionDet.disponibleMonto LT ABS(rsEstimacionDet.diferienciaMonto)>
					<cfthrow message="#rsEstimacionDet.DPDEdescripcion#, El monto para el consumo negativo autorizado pero pendiente de aplicar es mayor al disponible actual. Disponible actual: #rsEstimacionDet.disponibleMonto#">
				<cfelseif rsEstimacionDet.diferienciaMonto lt 0>
					<cfset monto = iif(rsEstimacionDet.diferienciaMonto lt 0,"#abs(rsEstimacionDet.diferienciaMonto)#","0")>
				</cfif>
				<cfif rsEstimacionDet.diferienciaCantidad lt 0 and rsEstimacionDet.disponibleCantidad LT ABS(rsEstimacionDet.diferienciaCantidad)>
					<cfthrow message="#rsEstimacionDet.DPDEdescripcion#, La cantidad para el consumo negativo autorizado pero pendiente de aplicar es mayor al disponible actual. Disponible actual: #rsEstimacionDet.disponibleCantidad#">
				<cfelseif rsEstimacionDet.diferienciaCantidad lt 0>
					<cfset cantidad = iif(rsEstimacionDet.diferienciaCantidad lt 0,"#abs(rsEstimacionDet.diferienciaCantidad)#","0")>
				</cfif>
				<cfquery datasource="#Arguments.Conexion#">
						update PCGDplanCompras set 
						PCGDpendiente = #monto#,
						PCGDcantidadPendiente = #cantidad#
						where PCGDid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstimacionDet.PCGDid#">
				</cfquery>
			</cfif>
		</cfif>

	</cffunction>
	<!---=======Modifica unicamente el monto de una Variación=======--->
	<cffunction name="CambioMontoVariacion"  access="public">
		<cfargument name="Conexion" 	     	type="string"   required="no">
		<cfargument name="BMUsucodigo"       	type="numeric"  required="no">
		<cfargument name="FPEEid" 	 		 	type="numeric"  required="yes">
		<cfargument name="PCGDid" 	 		 	type="numeric"  required="yes">
		<cfargument name="AumentoMonto" 	 	type="numeric"  required="no" default="0">
		<cfargument name="DPDEjustificacion"  	type="string"   required="no">
		<cfargument name="TraerFuturo"  		type="boolean"  required="no" default="true" hint="Trae monto del Futuro al presente">
    
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.BMUsucodigo')>
			<cfset Arguments.BMUsucodigo = session.Usucodigo>
		</cfif>
		
		<!---Se valida Estimación--->
		<cfquery datasource="#Arguments.Conexion#" name="rsEEstimacion">
			select count(1) cantidad
				from FPEEstimacion 
			where FPEEid = #Arguments.FPEEid#
		</cfquery>
		<cfif rsEEstimacion.cantidad EQ 0>
			<cfthrow message="El Encabezado de la Estimación de Ingreso y Egreso no existe.">
		</cfif>
		<!---Se valida el ID del plan de Compras--->
		<cfquery datasource="#Arguments.Conexion#" name="rsDEstimacion">
			select a.FPEPid, PCGDxCantidad, FPEPmultiperiodo
				from FPDEstimacion a
					inner join FPEPlantilla b
					on b.FPEPid = a.FPEPid
			where a.FPEEid = #Arguments.FPEEid#
			  and a.PCGDid = #Arguments.PCGDid#
		</cfquery>
		<cfif rsDEstimacion.RecordCount EQ 0>
			<cfthrow message="La linea del Plan de compras no fue cargada a la Variacion Presupuestal (FPEEid = #Arguments.FPEEid#, PCGDid = #Arguments.PCGDid#)">
		<cfelseif rsDEstimacion.RecordCount GT 1>
			<cfthrow message="La linea del Plan de compras fue cargada más de una vez a la Variacion Presupuestal (FPEEid = #Arguments.FPEEid#, PCGDid = #Arguments.PCGDid#)">
		</cfif>
		<!---Valida Tipo de Plantilla--->
		<cfif rsDEstimacion.PCGDxCantidad EQ 1>
			<cfthrow message="Únicamente se pueden Modificar líneas de Estimación que no controlen cantidades">
		</cfif>
		<!---Valida el Monto--->
		<cfif Arguments.AumentoMonto LTE 0>
			<cfthrow message="El monto del Aumento debe ser mayor a cero">
		</cfif>
		<cfquery datasource="#Arguments.Conexion#" name="rscambioEstimacion">
			update FPDEstimacion set 
					DPDMontoTotalPeriodo = DPDMontoTotalPeriodo + #Arguments.AumentoMonto#,
					BMUsucodigo			 = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.BMUsucodigo#">
				<cfif isdefined('Arguments.DPDEjustificacion') and LEN(TRIM(Arguments.DPDEjustificacion))>
					,DPDEjustificacion 	 = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.DPDEjustificacion#" len="256">
				</cfif>
				<cfif TraerFuturo>
					,DPDEcosto 			 = DPDEcosto + #Arguments.AumentoMonto#
				</cfif>
			where FPEEid    = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FPEEid#">
			  and PCGDid 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.PCGDid#">
		</cfquery>
		
	</cffunction>
	<!---Obtiene el Encabezado de la estimacion de Gasto o Ingreso en la formulación de presupuesto --->
	<cffunction name="GetEncabezadoEstimacion"  access="public" returntype="query">
		<cfargument name="Conexion" type="string"  required="no" default="#session.dsn#">
		<cfargument name="FPEEid" 	type="numeric" required="yes">
		<cfargument name="prefijo" 	type="string"  required="no" default="">
	
		<cf_dbfunction name="OP_concat" returnvariable="_Cat">
		
		<cfquery name="Encabezado" datasource="#Arguments.Conexion#">
			select a.FPEEestado,a.CFid, case when FPTVTipo = -1 then 'el Presupuesto Ordinario' when FPTVTipo = 0 then 'la Modificación Presupuestaria' else 'Variación' end as tipo,
			case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
					#_Cat# ' de ' #_Cat# 
					case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
					#_Cat# ' a ' #_Cat# 
					case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
				as Pdescripcion,
				CFcodigo #_Cat#'-'#_Cat# CFdescripcion CFdescripcion,
				Oficodigo #_Cat#'-'#_Cat# Odescripcion Ofidescripcion,
				a.FPEEUsucodigo, c.CFuresponsable, a.FPEEFechaLimite,
				f.FPTVTipo,
				a.CPPid,
				a.FPEEVersion,
				a.FPEEid,
				f.FPTVid,
				f.FPTVDescripcion
			from #Arguments.prefijo#FPEEstimacion a 
				inner join CFuncional c
					on a.CFid = c.CFid
				inner join CPresupuestoPeriodo d 
					 on a.CPPid = d.CPPid
				inner join Oficinas e
					on c.Ocodigo = e.Ocodigo
				inner join TipoVariacionPres f
					on f.FPTVid = a.FPTVid
			 where FPEEid = #Arguments.FPEEid#
		</cfquery>
		<cfreturn Encabezado>
	</cffunction>
	<!---Obtiene el Encabezado de la estimacion de Gasto o Ingreso en la formulación de presupuesto --->
	<cffunction name="GetDetalleEstimacion"  access="public" returntype="query">
		<cfargument name="Conexion" 	type="string"  required="no" default="#session.dsn#">
		<cfargument name="FPEEid" 		type="numeric" required="yes">
		<cfargument name="FPEPid" 		type="numeric" required="yes">
		<cfargument name="FPDElinea" 	type="numeric" required="yes">
		<cfargument name="prefijo" 		type="string"  required="no" default="">

		<cfquery name="Detalle" datasource="#Arguments.Conexion#">
			select 
		<!---	distinct --->
			a.FPDEid, a.FPDElinea,a.DPDEObservaciones,a.FPEEid,a.FPEPid,a.FPCCid,a.Dtipocambio,a.DPDEcantidad,a.DPDEfechaIni,a.DPDEfechaFin,a.DPDEcosto,a.Mcodigo,a.Ucodigo,a.DPDEdescripcion,
			a.DPDEjustificacion, 
			b.Udescripcion, c.Cid,c.Ccodigo,c.Cdescripcion,d.Aid,d.Acodigo,d.Adescripcion,e.FPCid,e.FPCcodigo,e.FPCdescripcion,a.FPAEid,a.CFComplemento,f.FPCCExigeFecha,a.DPDEcantidadPeriodo,a.DPDMontoTotalPeriodo,
			g.FPCCconcepto, case when a.PCGDid is null then 'false' else 'true' end as LigadoPCG,OB.OBOid, OB.OBOcodigo, OB.OBOdescripcion,
			case when i.PCGDid IS NOT NULL then 1 else 0 end as Multiperiodo, a.ts_rversion, a.DPDEcontratacion, a.DPDEmontoMinimo,
			Coalesce(i.PCGDcantidadTotal,Coalesce(h.PCGDCantidad,0)) 		as CantidadTotal, 		<!---Cantidad Total --->
			Coalesce(h.PCGDcantidad,0)		as PCGDcantidad, 		<!---Cantidad Periodo --->
			<!--- SOLO MULTIPERIODO --->
			Coalesce(i.PCGDautorizadoTotal,0.00) 		as PCGDautorizadoTotal, 		<!---Autorizado TOTAL multiperiodo --->
			Coalesce(i.PCGDautorizadoAnteriores,0.00) 	as PCGDautorizadoAnteriores, 	<!---Autorizados Anteriores Multiperiodo --->
			Coalesce(i.PCGDautorizadoFuturos,0.00) 		as PCGDautorizadoFuturos, 		<!---Autorizados Futuros Multiperiodo --->
			case when g.PCGDxPlanCompras = 0 then 
				(
					select sum	(
									  m.CPCreservado_Anterior
									+ m.CPCreservado_Presupuesto
									+ m.CPCreservado	
									+ m.CPCcomprometido_Anterior
									+ m.CPCcomprometido	
									+ m.CPCejecutado + m.CPCejecutadoNC
									- m.CPCnrpsPendientes
								)
					   from CPresupuestoControl m 
					  where m.Ecodigo  = j.Ecodigo
						and m.CPPid    = j.CPPid
						and m.CPcuenta = l.CPcuenta
						and m.Ocodigo  = CF.Ocodigo
				) + Coalesce(h.PCGDpendiente,0.00)  + Coalesce(i.PCGDautorizadoAnteriores,0.00)
			else Coalesce(h.PCGDreservado,0.00) + Coalesce(h.PCGDcomprometido,0.00) + Coalesce(h.PCGDejecutado,0.00) + Coalesce(h.PCGDpendiente,0.00) + Coalesce(i.PCGDautorizadoAnteriores,0.00) end as PCGDconsumidoNetoTotal, <!--- Consumido Neto TOTAL multiperiodo --->
			case when g.PCGDxPlanCompras = 0 then 
				(
					select sum	(
									  m.CPCreservado_Anterior
									+ m.CPCreservado_Presupuesto
									+ m.CPCreservado	
									+ m.CPCcomprometido_Anterior
									+ m.CPCcomprometido	
									+ m.CPCejecutado + m.CPCejecutadoNC
								)
					   from CPresupuestoControl m 
					  where m.Ecodigo  = j.Ecodigo
						and m.CPPid    = j.CPPid
						and m.CPcuenta = l.CPcuenta
						and m.Ocodigo  = CF.Ocodigo
				) + Coalesce(h.PCGDpendiente,0.00)  + Coalesce(i.PCGDautorizadoAnteriores,0.00)
			else Coalesce(h.PCGDreservado,0.00) + Coalesce(h.PCGDcomprometido,0.00) + Coalesce(h.PCGDejecutado,0.00) + Coalesce(i.PCGDautorizadoAnteriores,0.00) end as PCGDconsumidoBrutoTotal, <!--- Consumido Bruto TOTAL multiperiodo --->
			<!--- MULTIPERIODO Y NORMALES --->
			case when g.PCGDxPlanCompras = 0 then 
				(
					select sum	(
									  m.CPCpresupuestado
									+ m.CPCmodificado
									+ m.CPCmodificacion_Excesos
									+ m.CPCvariacion
									+ m.CPCtrasladado	
									+ m.CPCtrasladadoE
								)
					   from CPresupuestoControl m 
					  where m.Ecodigo  = j.Ecodigo
						and m.CPPid    = j.CPPid
						and m.CPcuenta = l.CPcuenta
						and m.Ocodigo  = CF.Ocodigo
						<!--- Control de Calculo 
						and m.CPanoMes 
								Mensual: = 		#AnoMes del documento de estimación#
								Acumulado: <= 	#AnoMes del documento de estimación#
								Total no se pone
											
						--->
				)
			else Coalesce(h.PCGDautorizado,0.00) end as PCGDautorizado, 					<!---Autorizado		PERIODO--->
			case when g.PCGDxPlanCompras = 0 then 
				(
					select sum	(
									  m.CPCreservado_Anterior
									+ m.CPCreservado_Presupuesto
									+ m.CPCreservado	
								)
					   from CPresupuestoControl m 
					  where m.Ecodigo  = j.Ecodigo
						and m.CPPid    = j.CPPid
						and m.CPcuenta = l.CPcuenta
						and m.Ocodigo  = CF.Ocodigo
				)
			else Coalesce(h.PCGDreservado,0.00) end as PCGDreservado, 						<!---Reservados		PERIODO--->
			case when g.PCGDxPlanCompras = 0 then 
				(
					select sum	(
									  m.CPCcomprometido_Anterior
									+ m.CPCcomprometido	
								)
					   from CPresupuestoControl m 
					  where m.Ecodigo  = j.Ecodigo
						and m.CPPid    = j.CPPid
						and m.CPcuenta = l.CPcuenta
						and m.Ocodigo  = CF.Ocodigo
				)
			else Coalesce(h.PCGDcomprometido,0.00) end as PCGDcomprometido, 				<!---Comprometido	PERIODO--->
			case when g.PCGDxPlanCompras = 0 then 
				(
					select sum(m.CPCejecutado+m.CPCejecutadoNC)
					   from CPresupuestoControl m 
					  where m.Ecodigo  = j.Ecodigo
						and m.CPPid    = j.CPPid
						and m.CPcuenta = l.CPcuenta
						and m.Ocodigo  = CF.Ocodigo
				)
			else Coalesce(h.PCGDejecutado,0.00) end as PCGDejecutado, 						<!---Ejecutado		PERIODO--->
			Coalesce(h.PCGDpendiente,0.00) as PCGDpendiente, 								<!---Pendientes 	PERIODO---> 
			case when g.PCGDxPlanCompras = 0 then 
				(
					select sum	(
									  m.CPCreservado_Anterior
									+ m.CPCreservado_Presupuesto
									+ m.CPCreservado	
									+ m.CPCcomprometido_Anterior
									+ m.CPCcomprometido	
									+ m.CPCejecutado + m.CPCejecutadoNC
								)
					   from CPresupuestoControl m 
					  where m.Ecodigo  = j.Ecodigo
						and m.CPPid    = j.CPPid
						and m.CPcuenta = l.CPcuenta
						and m.Ocodigo  = CF.Ocodigo
				)
			else Coalesce(h.PCGDreservado,0.00) + Coalesce(h.PCGDcomprometido,0.00) + Coalesce(h.PCGDejecutado,0.00) end as PCGDconsumidoBruto, <!--- Consumido Bruto PERIODO --->
			case when g.PCGDxPlanCompras = 0 then 
				(
					select sum	(
									  m.CPCreservado_Anterior
									+ m.CPCreservado_Presupuesto
									+ m.CPCreservado	
									+ m.CPCcomprometido_Anterior
									+ m.CPCcomprometido	
									+ m.CPCejecutado + m.CPCejecutadoNC
									- m.CPCnrpsPendientes
								)
					   from CPresupuestoControl m 
					  where m.Ecodigo  = j.Ecodigo
						and m.CPPid    = j.CPPid
						and m.CPcuenta = l.CPcuenta
						and m.Ocodigo  = CF.Ocodigo
				) + Coalesce(h.PCGDpendiente,0.00)
			else Coalesce(h.PCGDreservado,0.00) + Coalesce(h.PCGDcomprometido,0.00) + Coalesce(h.PCGDejecutado,0.00) + Coalesce(h.PCGDpendiente,0.00) end as PCGDconsumidoNeto, <!--- Consumido Neto PERIODO --->
			coalesce(PCGDcostoUori,0.00) PCGDcostoUori
			,a.PCGDid <!--- Detalle al Plan de Compras--->
			,a.DPDEmontoAjuste <!--- Monto Ajuste--->
			,case when h.PCGDxPlanCompras = 0 then 
				(select sum( m.CPCpresupuestado
							 + m.CPCmodificado
							 + m.CPCmodificacion_Excesos
							 + m.CPCvariacion
							 + m.CPCtrasladado	
							 + m.CPCtrasladadoE
				)
				   from CPresupuestoControl m 
				  where m.Ecodigo  = j.Ecodigo
					and m.CPPid    = j.CPPid
					and m.CPcuenta = l.CPcuenta
					and m.Ocodigo  = CF.Ocodigo
				) / h.PCGDtipocambio
				else Coalesce(h.PCGDcostoOri,0.00) end as MontoPeriodoPlanC
			from #Arguments.prefijo#FPDEstimacion a
				left outer join Unidades b
					on a.Ucodigo = b.Ucodigo
				   and a.Ecodigo = b.Ecodigo
				 left outer join Conceptos c
				 	on c.Cid = a.Cid
				 left outer join Articulos d
				 	on d.Aid = a.Aid
				 left outer join FPConcepto e
					on e.FPCid = a.FPCid
				 inner join FPCatConcepto f
					on f.FPCCid =  a.FPCCid
				inner join FPEPlantilla g
					on g.FPEPid = a.FPEPid	
				left outer join PCGDplanCompras h
					<!---Controlado por Plan de compras--->
					left outer join PCGDplanComprasMultiperiodo i
						on i.PCGDid = h.PCGDid
					<!---Controlado por Presupuesto---><!---NOTA: ESTA CUENTA NO SE PUEDE REPETIR EN PRESUPUESTO--->
					inner join PCGplanCompras j
						on h.PCGEid = j.PCGEid
					inner join CPresupuestoPeriodo k
						on k.CPPid = j.CPPid							
					inner join PCGcuentas l
						on l.PCGcuenta = h.PCGcuenta
					inner join CFuncional CF
						on CF.CFid = h.CFid
					inner join CPresupuestoControl m
						 on m.Ecodigo  = j.Ecodigo
						and m.CPPid    = j.CPPid
				   <!---and m.CPCano   = j.CPPanoMesDesde /100
						and m.CPCmes   = j.CPPanoMesDesde - d.CPPanoMesDesde /100 *100--->
						and m.CPcuenta = l.CPcuenta
						and m.Ocodigo  = CF.Ocodigo
				  on a.PCGDid = h.PCGDid
				  
				  	left outer join OBobra OB
						on OB.OBOid = a.OBOid
						
			where a.FPEEid     = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FPEEid#">
			  and a.FPEPid	   = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FPEPid#">
			  and a.FPDElinea  = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FPDElinea#">
		</cfquery>
		<cfreturn Detalle>
	</cffunction>
	<!---Enviar a proceso de Aprobación la estimacion de Egresos e Ingresos--->
	<cffunction name="EnviarAprobarEstimacion"  access="public">
		<cfargument name="Conexion" 	type="string"  required="no">
		<cfargument name="FPEEid" 		type="numeric" required="yes">
		<cfargument name="BMUsucodigo"  type="numeric" required="no">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.BMUsucodigo')>
			<cfset Arguments.BMUsucodigo = session.Usucodigo>
		</cfif>
		
		<cfset EncabezadoEst = GetEncabezadoEstimacion(Arguments.Conexion,Arguments.FPEEid)>
		<cfif EncabezadoEst.recordcount EQ 0>
			<cfthrow message="Error en FPRES_ActividadEmpresarial.EnviarAprobarEstimacion" detail="No se puedo encontrar la Actividad a Enviar a Aprobar">
		<cfelseif EncabezadoEst.FPEEestado NEQ 0>
			<cfthrow message="Error en FPRES_ActividadEmpresarial.EnviarAprobarEstimacion" detail="No se puede enviar a Aprobar una Actividad que no este en preparación.">
		</cfif>
		<cfquery datasource="#Arguments.Conexion#" name="Remitente">
			select Coalesce(b.Pemail1, b.Pemail2, 'gestion@soin.co.cr') correo, b.Pnombre #_Cat# ' ' #_Cat# b.Papellido1 #_Cat# ' ' #_Cat# b.Papellido2 as nombre
				from Usuario a 
					inner join DatosPersonales b
						on a.datos_personales = b.datos_personales
			where a.Usucodigo = #Arguments.BMUsucodigo#
		</cfquery>
		<!---Envio el correo al reponsable de presupuesto (El que abrio la estimación)--->
		<cfif LEN(TRIM(EncabezadoEst.CFuresponsable))>
			<cfquery datasource="#Arguments.Conexion#" name="Destinatario">
				select Coalesce(b.Pemail1, b.Pemail2, 'gestion@soin.co.cr') correo, b.Pnombre #_Cat# ' ' #_Cat# b.Papellido1 #_Cat# ' ' #_Cat# b.Papellido2 as nombre, b.Psexo
					from Usuario a 
						inner join DatosPersonales b
							on a.datos_personales = b.datos_personales
				where a.Usucodigo = #EncabezadoEst.FPEEUsucodigo#
			</cfquery>
			<cfif Destinatario.Psexo EQ 'F'>
				<cfset sexo = 'Srta. '>
			<cfelse>
				<cfset sexo = 'Sr. '>
			</cfif>
			<cfset texto = "
					<table border='0' cellpadding='4' cellspacing='0' style='border:2px solid ##999999;'>
						<tr bgcolor='##999999'><td colspan='2' height='8'></td></tr>
						<tr bgcolor='##003399'><td colspan='2' height='24'></td></tr>
						<tr bgcolor='##999999'><td colspan='2'> <strong>Información sobre Estimación de Ingresos y Egresos en #session.Enombre# </strong> </td></tr>
						<tr><td width='80%'>&nbsp;</td><td width='20%'>&nbsp;</td></tr>
						<tr><tr><td>#sexo##Destinatario.nombre#</td></tr>
						<tr><td><div align='justify'>Este correo a sido enviado por #Remitente.Nombre# para informarle que la Estimación de Ingresos y Egresos para #EncabezadoEst.tipo# #EncabezadoEst.Pdescripcion# del Centro Funcional:<strong>#EncabezadoEst.CFdescripcion#</strong>  Oficina: <strong>#EncabezadoEst.Ofidescripcion#</strong>, 
						esta Pendiente de su respectivo <label style='color:##0000CC'><strong>Proceso de Aprobación</strong></label>.<br>
						</div></td></tr>
				    </table>">
				<cfset InsertarEmail(Remitente.correo,Destinatario.correo,'Pendiente Aprobación de la Estimación de Ingresos y Egresos',#texto#,#Arguments.BMUsucodigo#,Arguments.Conexion)> 
		</cfif>
		<cfif EncabezadoEst.FPTVTipo eq 1><!--- Variacion de tipo no modifica monto--->
			<cfset ValidarVariacionNoMonto(EncabezadoEst.CFid,EncabezadoEst.CPPid,Arguments.Conexion,0,true,Arguments.FPEEid)>
		</cfif>
		<cfquery datasource="#Arguments.Conexion#">
			update FPEEstimacion 
			  set FPEEestado = 1
				where FPEEid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPEEid#">
				and FPEEestado = 0
		</cfquery>
	</cffunction>
	<!--- Aprobación de la estimacion de Egresos e Ingresos, Se envia el correo de quien Aprueba al Jefe del centro Funcional--->
	<cffunction name="AprobarEstimacion"  access="public">
		<cfargument name="Conexion" 	type="string"  required="no">
		<cfargument name="FPEEid" 		type="numeric" required="yes">
		<cfargument name="BMUsucodigo"  type="numeric" required="no">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.BMUsucodigo')>
			<cfset Arguments.BMUsucodigo = session.Usucodigo>
		</cfif>
		
		<cfset EncabezadoEst = GetEncabezadoEstimacion(Arguments.Conexion,Arguments.FPEEid)>
		
		<cfif EncabezadoEst.recordcount EQ 0>
			<cfthrow message="Error en FPRES_ActividadEmpresarial.EnviarAprobarEstimacion" detail="No se puedo encontrar la Actividad a Enviar a Aprobar">
		<cfelseif EncabezadoEst.FPEEestado NEQ 1>
			<cfthrow message="Error en FPRES_ActividadEmpresarial.EnviarAprobarEstimacion" detail="No se puede Aprobar una Actividad que no este en Aprobación.">
		</cfif>
			<cfquery datasource="#Arguments.Conexion#" name="Remitente">
				select Coalesce(b.Pemail1, b.Pemail2, 'gestion@soin.co.cr') correo, b.Pnombre #_Cat# ' ' #_Cat# b.Papellido1 #_Cat# ' ' #_Cat# b.Papellido2 as nombre
					from Usuario a 
						inner join DatosPersonales b
							on a.datos_personales = b.datos_personales
				where a.Usucodigo = #Arguments.BMUsucodigo#
			</cfquery>
		<cfif LEN(TRIM(EncabezadoEst.CFuresponsable))>
			<cfquery datasource="#Arguments.Conexion#" name="Destinatario">
				select Coalesce(b.Pemail1, b.Pemail2, 'gestion@soin.co.cr') correo, b.Pnombre #_Cat# ' ' #_Cat# b.Papellido1 #_Cat# ' ' #_Cat# b.Papellido2 as nombre, b.Psexo
					from Usuario a 
						inner join DatosPersonales b
							on a.datos_personales = b.datos_personales
				where a.Usucodigo = #EncabezadoEst.CFuresponsable#
			</cfquery>
			<cfif Destinatario.Psexo EQ 'F'>
				<cfset sexo = 'Srta. '>
			<cfelse>
				<cfset sexo = 'Sr. '>
			</cfif>
			<cfset texto = "
			<table border='0' cellpadding='4' cellspacing='0' style='border:2px solid ##999999; '>
			  <tr bgcolor='##999999'><td colspan='2' height='8'></td></tr>
			  <tr bgcolor='##003399'><td colspan='2' height='24'></td></tr>
			  <tr bgcolor='##999999'><td colspan='2'><strong>Información sobre Estimación de Ingresos y Egresos en #session.Enombre# </strong></td></tr>
			  <tr><td width='80%'>&nbsp;</td> <td width='20%'>&nbsp;</td></tr>
			  <tr><td>#sexo##Destinatario.nombre#</td></tr>
			  <tr>
				<td><div align='justify'>Este correo a sido enviado por #Remitente.Nombre# para informarle que la Estimación de Ingresos y Egresos para #EncabezadoEst.tipo# #EncabezadoEst.Pdescripcion# del Centro Funcional:<strong>#EncabezadoEst.CFdescripcion#</strong> Oficina: <strong>#EncabezadoEst.Ofidescripcion#</strong> a sido <label style='color:##009900'><strong>Aprobada</strong></label>.<br>
				</div></td>
			  </tr>
			</table>">
			
			<cfset InsertarEmail(Remitente.correo,Destinatario.correo,'Aprobación de la Estimación de Ingresos y Egresos',#texto#,#Arguments.BMUsucodigo#,Arguments.Conexion)> 
		</cfif>
		<cfif EncabezadoEst.FPTVTipo neq 1>
			<cfset fnActualizaPendientes(Arguments.FPEEid, -1, 1)>
		</cfif>
		<cfset estado = 2>
		<cfif EncabezadoEst.FPTVTipo eq 1><!--- Variacion de tipo no modifica monto--->
			<cfset ValidarVariacionNoMonto(EncabezadoEst.CFid,EncabezadoEst.CPPid,Arguments.Conexion,1,false,Arguments.FPEEid,"-Admin")>
			<cfset estado = 5>
			<cfinvoke component="sif.Componentes.PCG_Traslados" method="fnCrearTablasTemporales">
				<cfinvokeargument name="CPPid" 					value="-1">
				<cfinvokeargument name="FPEEestado" 			value="1">
				<cfinvokeargument name="CreateQuery" 			value="false">
				<cfinvokeargument name="CreateNivelEquilibrio" 	value="false">
				<cfinvokeargument name="CreateTableTemp" 		value="false">
				<cfinvokeargument name="CreateTableMax" 		value="false">
			</cfinvoke>
			<cfinvoke component="sif.Componentes.PCG_Traslados" method="ALTATraslado" returnvariable="CPDEid">
				<cfinvokeargument name="FPEEid_origen" value="#Arguments.FPEEid#">
				<cfinvokeargument name="FPEEestado"    value="1">
			</cfinvoke>
		</cfif>
		<cfquery datasource="#Arguments.Conexion#">
			update FPEEstimacion 
			  set FPEEestado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#estado#">
			where FPEEid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPEEid#">
			  and FPEEestado = 1
		</cfquery>
	</cffunction>
	<!---Rechazo la estimacion de Egresos e Ingresos, Se envia correo de quien esta rechazando hacia el Jefe del centro Funcional--->
	<cffunction name="RechazarEstimacion"  access="public">
		<cfargument name="Conexion" 	type="string"  required="no">
		<cfargument name="FPEEid" 		type="numeric" required="yes">
		<cfargument name="BMUsucodigo"  type="numeric" required="no">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.BMUsucodigo')>
			<cfset Arguments.BMUsucodigo = session.Usucodigo>
		</cfif>
		
		<cfset EncabezadoEst = GetEncabezadoEstimacion(Arguments.Conexion,Arguments.FPEEid)>
		
		<cfif EncabezadoEst.recordcount EQ 0>
			<cfthrow message="No se puedo encontrar la Actividad a Enviar a Aprobar.">
		<cfelseif NOT listfind("1,2",EncabezadoEst.FPEEestado)>
			<cfthrow message="No se puede Rechazar una Actividad que no este en Aprobación o Equilibrio.">
		</cfif>
		<cfquery datasource="#Arguments.Conexion#" name="Remitente">
			select Coalesce(b.Pemail1, b.Pemail2, 'gestion@soin.co.cr') correo, b.Pnombre #_Cat# ' ' #_Cat# b.Papellido1 #_Cat# ' ' #_Cat# b.Papellido2 as nombre
				from Usuario a 
					inner join DatosPersonales b
						on a.datos_personales = b.datos_personales
			where a.Usucodigo = #Arguments.BMUsucodigo#
		</cfquery>
		<cfif len(trim(EncabezadoEst.CFuresponsable))>
			<cfquery datasource="#Arguments.Conexion#" name="Destinatario">
				select Coalesce(b.Pemail1, b.Pemail2, 'gestion@soin.co.cr') correo, b.Pnombre #_Cat# ' ' #_Cat# b.Papellido1 #_Cat# ' ' #_Cat# b.Papellido2 as nombre, b.Psexo
					from Usuario a 
						inner join DatosPersonales b
							on a.datos_personales = b.datos_personales
				where a.Usucodigo = #EncabezadoEst.CFuresponsable#
			</cfquery>
			<cfif Destinatario.Psexo EQ 'F'>
				<cfset sexo = 'Srta. '>
			<cfelse>
				<cfset sexo = 'Sr. '>
			</cfif>
			<cfset texto = "
				<table border='0' cellpadding='4' cellspacing='0' style='border:2px solid ##999999; '>
   					<tr bgcolor='##999999'><td colspan='2' height='8'></td></tr>
    				<tr bgcolor='##003399'><td colspan='2' height='24'></td></tr>
    				<tr bgcolor='##999999'><td colspan='2'> <strong>Información sobre Estimación de Ingresos y Egresos en #session.Enombre# </strong> </td></tr>
    				<tr><td width='80%'>&nbsp;</td><td width='20%'>&nbsp;</td></tr>
    				<tr><tr><td>#sexo##Destinatario.nombre#</td></tr>
					<tr>
				  		<td><div align='justify'>Este correo a sido enviado por #Remitente.Nombre# para informarle que la Estimación de Ingresos y Egresos para #EncabezadoEst.tipo# #EncabezadoEst.Pdescripcion# del Centro Funcional:<strong>#EncabezadoEst.CFdescripcion#</strong>  
						Oficina: <strong>#EncabezadoEst.Ofidescripcion#</strong> a sido <label style='color:##FF0000'><strong>Rechazada</strong></label>.<br>
							Le solicitamos revisar los comentarios de cada una de las líneas, hacer las correcciones pertinentes y enviarlo nuevamente al proceso de revisión.
				 	 	</div></td></tr>
				</table>
				">
		</cfif>
		<cfif EncabezadoEst.FPTVTipo neq 1>
			<cfquery datasource="#Arguments.Conexion#">
					update PCGDplanCompras set 
					  PCGDpendiente = 0,
					  PCGDcantidadPendiente = 0
					where PCGDid in (	select de.PCGDid
										from FPDEstimacion de
										where de.FPEEid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPEEid#">
										and de.PCGDid = PCGDplanCompras.PCGDid
									)
			</cfquery>
		</cfif>
		<cfquery datasource="#Arguments.Conexion#">
			update FPEEstimacion 
			  set FPEEestado = 0
				where FPEEid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FPEEid#">
				and FPEEestado in (1,2)
		</cfquery>
		<cfif len(trim(EncabezadoEst.CFuresponsable))>
			<cfset InsertarEmail(Remitente.correo,Destinatario.correo,'Rechazo de la Estimación de Ingresos y Egresos',#texto#,#Arguments.BMUsucodigo#,Arguments.Conexion)> 
		</cfif>
	</cffunction>
	<!---=======MOdifica un Detalle de estimacion de Gasto o Ingreso en la formulación de presupuesto =======--->
	<cffunction name="NotasDetalleEstimacion"  access="public" >
		<cfargument name="Conexion"   			type="string"   required="no">
		<cfargument name="FPEEid" 	  			type="numeric"  required="yes"><!---FPEEid    =(Formulacion Presupuesto Encabezado Estimación)  --->
		<cfargument name="FPEPid" 	  			type="numeric"  required="yes"><!---FPEPid    =(Formulacion Presupuesto Encabezado Plantilla)   --->
		<cfargument name="FPDElinea"  			type="numeric"  required="yes"><!---FPDElinea =(Linea de la Estación)--->
		<cfargument name="DPDEObservaciones" 	type="string"  required="no">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif> 
		<cfif isdefined('Arguments.DPDEObservaciones')>
			<cfquery datasource="#Arguments.Conexion#" name="rscambioEstimacion">
				update FPDEstimacion set 
					DPDEObservaciones 	= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Trim(Arguments.DPDEObservaciones)#">
				where FPEEid    = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FPEEid#">
				  and FPEPid    = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FPEPid#">
				  and FPDElinea = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FPDElinea#">
			</cfquery>
		</cfif>
		<cfreturn GetDetalleEstimacion(Arguments.Conexion,Arguments.FPEEid,Arguments.FPEPid,Arguments.FPDElinea)>
	</cffunction>
	<!--- Inserta correos en la cola de envio de correos --->
	<cffunction name="InsertarEmail" access="public" returntype="numeric">
		<cfargument name="remitente" 			type="string" 	required="yes">
		<cfargument name="destinario" 			type="string" 	required="yes"><!--- correo --->
		<cfargument name="asunto" 				type="string" 	required="yes">
		<cfargument name="texto" 				type="string" 	required="yes">
		<cfargument name="usuario" 				type="numeric" 	required="no">
		<cfargument name="Conexion"   			type="string"   required="no">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif> 
		<cfif not isdefined('Arguments.usuario')>
			<cfset Arguments.usuario = session.usucodigo>
		</cfif> 
		
		<cfquery name="rsInserta" datasource="#arguments.Conexion#">
			insert into SMTPQueue ( SMTPremitente, 	SMTPdestinatario, 	SMTPasunto, 
									SMTPtexto, 		SMTPintentos, 		SMTPcreado, 
									SMTPenviado, 	SMTPhtml, 			BMUsucodigo ) 
		 	values ( <cfqueryparam 	cfsqltype="cf_sql_varchar" 	value="#arguments.remitente#">, 
					<cfqueryparam 	cfsqltype="cf_sql_varchar" 	value="#arguments.destinario#">, 
					<cfqueryparam 	cfsqltype="cf_sql_varchar" 	value="#arguments.asunto#">,
					<cfqueryparam 	cfsqltype="cf_sql_varchar" 	value="#arguments.texto#">,
					0,	#now()#,	#now()#,	1,
					<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#arguments.usuario#">
					)
			<cf_dbidentity1>
    	</cfquery>
		<cf_dbidentity2 name="rsInserta">
		<cfreturn #rsInserta.identity#>
	</cffunction>
	<!---Verifica si una Clasificacion de Ingreso y Egreso esta relacionado a una plantilla--->
	<cffunction name="isRelated" access="public" returntype="boolean">
		<cfargument name="Conexion"  type="string"   required="no">
		<cfargument name="FPCCid"  	 type="string"   required="no">
		<cfargument name="FPEPid"    type="string"   required="no">
		
		<cfquery datasource="#Arguments.Conexion#" name="rsisRelated">
			select count(1) as cantidad from FPDPlantilla where FPCCid = #Arguments.FPCCid#  and FPEPid = #Arguments.FPEPid#
		</cfquery>
		<cfquery datasource="#Arguments.Conexion#" name="isSon">
			select FPCCidPadre from FPCatConcepto where FPCCid = #Arguments.FPCCid# and FPCCidPadre is not null
		</cfquery>
		<cfif rsisRelated.cantidad>
			<cfreturn true>
		<cfelseif isSon.recordcount GT 0>
			<cfreturn isRelated(Arguments.Conexion,isSon.FPCCidPadre,Arguments.FPEPid)>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	<cffunction name="isfather" access="public" returntype="boolean">
		<cfargument name="Conexion"  type="string"   required="no">
		<cfargument name="FPCCid"  	 type="string"   required="no">
		<cfargument name="FPEPid"    type="string"   required="no">
		<cfargument name="FPEEid"    type="string"   required="no">
		<cfargument name='filtro'	 type='string' 	 required='no' default="">
		
		<cfquery datasource="#session.DSN#" name="rsEPlantilla">
			select FPCCconcepto 
			   from FPEPlantilla 
			 where FPEPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEPid#">
		</cfquery>
		<cfif ListFind(ListFPCCconcepto,rsEPlantilla.FPCCconcepto)>
			<cfquery datasource="#session.DSN#" name="rsDetalles">
				select count(1) as cantidad
				from FPDEstimacion a
					inner join FPConcepto b
						on b.FPCid = a.FPCid
				where a.Ecodigo = #session.Ecodigo#
				  and a.FPEEid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.FPEEid#">
				  and a.FPCCid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.FPCCid#">
				  and a.FPEPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEPid#">
				  #preservesinglequotes(Arguments.filtro)#
			</cfquery>
		<cfelseif ListFind('A',rsEPlantilla.FPCCconcepto)>
			<cfquery datasource="#session.DSN#" name="rsDetalles">
				select count(1) as cantidad
				from FPCatConcepto d
					inner join Clasificaciones b
						on d.FPCCTablaC = b.Ccodigo
					inner join Articulos c
						on c.Ecodigo = b.Ecodigo and c.Ccodigo = b.Ccodigo
					inner join FPDEstimacion a
						on a.Aid = c.Aid
				where a.Ecodigo = #session.Ecodigo#
				  and d.FPCCconcepto = 'A'
				  and a.FPCCid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.FPCCid#">
				  and a.FPEPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEPid#">
				  and a.FPEEid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.FPEEid#">
				  #preservesinglequotes(Arguments.filtro)#
			</cfquery>
		<cfelseif ListFind('S,P',rsEPlantilla.FPCCconcepto)>
			<cfquery datasource="#session.DSN#" name="rsDetalles">
				select count(1) as cantidad
				from FPDEstimacion a
					inner join Conceptos b 
						on a.Cid = b.Cid
					inner join CConceptos c 
						on c.CCid = b.CCid
					inner join FPCatConcepto d 
						on d.FPCCTablaC = c.CCid
					left outer join OBobra OB 
						inner join OBproyecto OP 
							on OP.OBPid = OB.OBPid 
					on OB.OBOid = a.OBOid
				where d.Ecodigo = #session.Ecodigo#
				  and d.FPCCconcepto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEPlantilla.FPCCconcepto#">
				  and d.FPCCid 		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPCCid#">
				  and a.FPEPid		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEPid#">
				  and a.FPEEid 		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEEid#">
				  #preservesinglequotes(Arguments.filtro)#
			</cfquery>
		</cfif>
		<cfif not ListFind(ExigeAuxiliar,rsEPlantilla.FPCCconcepto)>
			<cfinvoke component="sif.Componentes.PCG_ConceptoGastoIngreso" method="fnTienenConceptos" returnvariable="TieneConceptos">
				<cfinvokeargument name="Conexion" 	 	value="#session.DSN#">
				<cfinvokeargument name="FPCCid" 	 	value="#Arguments.FPCCid#">
			</cfinvoke>
		<cfelse>
			<cfset TieneConceptos = true>
		</cfif>
		
		<cfif rsDetalles.cantidad gt 0 and TieneConceptos>
			<cfreturn true>
		<cfelse>
			<cfset pintar = false>
			<cfquery name="hijos" datasource="#session.DSN#">
				select FPCCid as id from FPCatConcepto where FPCCidPadre = #Arguments.FPCCid#
			</cfquery>
			<cfif hijos.recordcount EQ 0>
				<cfreturn false>
			<cfelse>
				<cfloop query="hijos">
					<cfset pintar = isfather(Arguments.Conexion,id,Arguments.FPEPid,Arguments.FPEEid,Arguments.filtro)>
					<cfif pintar>
						<cfreturn pintar>
					</cfif>
				</cfloop>	
			</cfif>
			<cfreturn pintar>
		</cfif>
	</cffunction>
	
	<cffunction name="CopiarDetalles" access="public" returntype="boolean">
		<cfargument name="Conexion"  	type="string"   required="no">
		<cfargument name="CPPid"    	type="numeric"  required="yes">
		<cfargument name="CFid"     	type="numeric"  required="yes">
		<cfargument name="FPEEid"     	type="numeric"  required="yes">
		<cfargument name="BMUsucodigo"  type="string"   required="no">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.BMUsucodigo')>
			<cfset Arguments.BMUsucodigo = "#Session.Usucodigo#">
		</cfif> 
		<cfquery name="PCGEncabezado" datasource="#Arguments.Conexion#">
			select PCGEid from PCGplanCompras where CPPid = #Arguments.CPPid#
		</cfquery>
		<cfif PCGEncabezado.recordcount GT 0>
			<cfquery name="DetalleEstimacion" datasource="#Arguments.Conexion#">
				insert into FPDEstimacion
				 (FPEEid, FPEPid, FPDElinea, Ecodigo, DPDEdescripcion, DPDEjustificacion, Mcodigo,Dtipocambio, FPAEid,CFComplemento, 
				  FPCCid, DPDEfechaIni, DPDEfechaFin, Ucodigo, Aid, Cid, FPCid, OBOid, DPDEObservaciones, DPDEcosto, DPDEcantidad, DPDEcantidadPeriodo, 
				  DPDMontoTotalPeriodo,PCGDid, PCGcuenta,DPDEcontratacion,DPDEmontoMinimo,DPDEmontoAjuste)
				select 
					#Arguments.FPEEid#, a.FPEPid,
					(select coalesce(max(b.FPDElinea),0) 
						from FPDEstimacion b 
					where b.FPEEid =#Arguments.FPEEid# 
					  and b.FPEPid = a.FPEPid)
					+(select count(1) 
						from PCGDplanCompras contador
						where contador.PCGEid    = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#PCGEncabezado.PCGEid#">
						  and contador.CFid	    = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.CFid#"> 
						  and contador.PCGDid <= a.PCGDid
				      )
					,
					a.Ecodigo,a.PCGDdescripcion, a.PCGDjustificacion, a.Mcodigo, a.PCGDtipocambio,a.FPAEid,a.CFComplemento, 
					a.FPCCid, a.PCGDfechaIni, a.PCGDfechaFin,
					case when <cf_dbfunction name="length"	args="rtrim(a.Ucodigo)"> > 0 then a.Ucodigo else 
					 <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="null"> end,
					a.Aid, a.Cid, a.FPCid, a.OBOid, a.PCGDobservaciones,
                    <!---Precio Unitario: Cuando no es controlado por Plan de Compras, no controla Cantidad, 
					por lo tanto el Precio Unitario en moneda local es igual al Autorizado del Perido. NO poner coalesce, para que de error, 
					ya que siempre debe haber Registro en ControlPresupuesto, si no hay fue porque cambiaron la Oficina del CF--->
                    case when a.PCGDxPlanCompras = 0 then 
                    (select sum( m.CPCpresupuestado
								 + m.CPCmodificado
								 + m.CPCmodificacion_Excesos
								 + m.CPCvariacion
								 + m.CPCtrasladado	
								 + m.CPCtrasladadoE
					)
					   from CPresupuestoControl m 
					  where m.Ecodigo  = j.Ecodigo
						and m.CPPid    = j.CPPid
						and m.CPcuenta = l.CPcuenta
						and m.Ocodigo  = CF.Ocodigo
					) / a.PCGDtipocambio
				 	else Coalesce(a.PCGDcostoUori,0.00) end,
                    <!---Cantidad Total (Multiperiodo)--->
					coalesce(mp.PCGDcantidadTotal,a.PCGDcantidad,1),
                    <!---Cantidad del periodo: Cuando no se controla por Plan de Compras, la cantidad Siempre es 1--->
					case when a.PCGDxPlanCompras = 0 then 1 else a.PCGDcantidad end,
					<!---Monto del Periodo en Moneda Origen : Si es una moneda no Local y NO se controla por plan de Compras, se toma el Tipo de cambio 
					del Plan de Compras con el Monto de Presupuesto (En Buena Teoria, nunca van a usar PCG y Presupuesto, por lo que PCG = presupuesto)
					NO poner coalesce, para que de error,ya que siempre debe haber Registro en ControlPresupuesto, si no hay fue porque cambiaron la Oficina del CF--->
                    case when a.PCGDxPlanCompras = 0 then 
                    (select sum( m.CPCpresupuestado
								 + m.CPCmodificado
								 + m.CPCmodificacion_Excesos
								 + m.CPCvariacion
								 + m.CPCtrasladado	
								 + m.CPCtrasladadoE
					)
					   from CPresupuestoControl m 
					  where m.Ecodigo  = j.Ecodigo
						and m.CPPid    = j.CPPid
						and m.CPcuenta = l.CPcuenta
						and m.Ocodigo  = CF.Ocodigo
					) / a.PCGDtipocambio
				 	else Coalesce(a.PCGDcostoOri,0.00) end DPDMontoTotalPeriodo,
                    
					a.PCGDid,
					a.PCGcuenta,
					a.PCGDcontratacion,
					a.PCGDmontoMinimo,
					0
				 from PCGDplanCompras a
				 	left outer join PCGDplanComprasMultiperiodo mp
						on mp.PCGDid = a.PCGDid
                    inner join PCGplanCompras j
						on j.PCGEid = a.PCGEid						
					inner join PCGcuentas l
						on l.PCGcuenta = a.PCGcuenta
					inner join CFuncional CF
						on CF.CFid = a.CFid
				where a.PCGEid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#PCGEncabezado.PCGEid#">
				  and a.CFid   = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#Arguments.CFid#">
			</cfquery>
		
		</cfif>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="FechaLimiteValida" access="public" returntype="boolean">
		<cfargument name='fechaLimite'	type='date' required='true'>
		<cfset año	= DatePart("yyyy", fechaLimite)>
		<cfset mes  = DatePart("m", fechaLimite)>
		<cfset dia  = DatePart("d", fechaLimite)>
		<cfif año + mes + dia gte year(now()) + month(now()) + day(now())>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	<!---=================CreateCFformato: Se arma el Formato de la cuenta Finaciera y se Actualiza en el detalle de la estimacion
		A=Activos Fijos 	= Cuenta de Inversion	+ Complemento de la Actividad + Complemento de la Categoria-Clase
		I=Inventario 		= Cuenta de Inventario  + Complemento de la Actividad
		S=servicio 			= Cuenta de Gasto		+ Complemento de la Actividad
		C=Concepto Salarial = Cuenta de Gasto		+ Complemento de la Actividad
		O=Otros 			= Cuenta de Gasto		+ Complemento de la Actividad
	=======--->
	<cffunction name="CreateCFformato"  access="private" returntype="numeric">
		<cfargument name="Conexion" 		 type="string"  required="no">
		<cfargument name="Ecodigo"	 		 type="numeric" required="no">
		<cfargument name="CFid"				 type="numeric" required="yes">
		<cfargument name="FPCCconcepto"		 type="string"  required="yes">
		<cfargument name="ComplementoOGasto" type="string"  required="yes">
		<cfargument name="ComplementoActiv"  type="string"  required="yes">
		<cfargument name="CPPid"  			 type="numeric" required="yes">
		<cfargument name="OBOid"  			 type="string"  required="no">

    	<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		
		<cfif not ListFind(ListFPCCconceptoALL, Arguments.FPCCconcepto)>
			<cfthrow message="Error Generando el Formato Financiero, FPCCconcepto '#Arguments.FPCCconcepto#' no Implementado.">
		</cfif>
		<cfquery name="rsFecha" datasource="#Arguments.Conexion#">
			select case when <cf_dbfunction name="now"> < CPPfechaDesde then CPPfechaDesde when <cf_dbfunction name="now"> > CPPfechaHasta then CPPfechaHasta else <cf_dbfunction name="now"> end as value
				from CPresupuestoPeriodo
			where CPPid = #Arguments.CPPid#
		</cfquery>
		
		<cfif rsFecha.recordcount EQ 0 or NOT LEN(TRIM(rsFecha.value))>
			<cfthrow message="No se puedo recuperar la Fecha del Periodo Presupuestal">
		</cfif>
		
		<cfif isdefined('Arguments.OBOid') and len(trim(Arguments.OBOid))>
			<cfinvoke component 	= "sif.Componentes.AplicarMascara" 
			  method    	= "fnComplementoObras"
			  OBOid	    	= "#Arguments.OBOid#"
			  conMayor    	= "false"
			  returnvariable= "LvarCuentaC">
			  <cfset Arguments.ComplementoActiv = LvarCuentaC & replace(Arguments.ComplementoActiv,'-','')>	
		</cfif>	  
		
		<cfquery name="rsCentroFuncional" datasource="#Arguments.Conexion#">
			select Ocodigo, 
				 case '#Arguments.FPCCconcepto#'
				 	when 'F' then b.CFcuentainversion 	<!---Activos Fijos--->
				 	when 'A' then b.CFcuentainventario 	<!---Articulo de Inventario--->
					when 'S' then b.CFcuentac 			<!---Sevicios--->
					when 'P' then b.CFcuentaobras 		<!---Obras en Construcción--->
					when '1' then b.CFcuentac 			<!---Otros--->
					when '2' then b.CFcuentac 			<!---Concepto Salarial--->
					when '5' then b.CFcuentaPatri 		<!---Patrimonio--->
					when '6' then b.CFcuentaingreso 	<!---Ventas--->
					else 'NA' end as cuenta
				from CFuncional b
			where CFid = #Arguments.CFid#
		</cfquery>
		<cfset cuenta = rsCentroFuncional.cuenta>
		<cfif Arguments.FPCCconcepto EQ 3>		<!---Amortización de prestamos---> 
			<cfquery name="rs2800" datasource="#Arguments.Conexion#">
				select Pvalor 
					from Parametros 
				where Ecodigo = #Arguments.Ecodigo# 
				 and Pcodigo = 2800
			</cfquery>
			<cfif rs2800.RecordCount EQ 0 or NOT LEN(TRIM(rs2800.Pvalor))>
				<cfthrow message="La empresa no tienen definida la Cuenta de Egresos por Amortización de préstamos">
			</cfif>
			<cfset cuenta = rs2800.Pvalor>
		<cfelseif Arguments.FPCCconcepto EQ 4>	<!---Financiamiento--->
			<cfquery name="rs2600" datasource="#Arguments.Conexion#">
				select Pvalor 
					from Parametros 
				where Ecodigo = #Arguments.Ecodigo# 
				 and Pcodigo = 2600
			</cfquery>
			<cfif rs2600.RecordCount EQ 0 or NOT LEN(TRIM(rs2600.Pvalor))>
				<cfthrow message="La empresa no tienen definida la Cuenta de ingreso por Financiamiento">
			</cfif>
			<cfset cuenta = rs2600.Pvalor>
		</cfif>
		<cfif not isdefined('cuenta') or NOT LEN(TRIM(cuenta)) or cuenta EQ 'NA'>
			<cfthrow message="El Centro Funcional no tiene las cuentas Requeridas debidamente configuradas">
		</cfif>
	
		<cfobject component="sif.Componentes.AplicarMascara" name="LobjMascara">
		<cfset CFFormato = LobjMascara.AplicarMascara(LobjMascara.AplicarMascara(cuenta,Arguments.ComplementoOGasto),REReplace(Arguments.ComplementoActiv,"-","","ALL"), '_')>
	
		<cfinvoke component="PC_GeneraCuentaFinanciera" method="fnGeneraCuentaPlanCompras" returnvariable="LvarStructResult"> 
  			<cfinvokeargument name="Lprm_DSN"                   value="#Arguments.Conexion#"/>
   			<cfinvokeargument name="Lprm_Ecodigo"               value="#Arguments.Ecodigo#"/>
   			<cfinvokeargument name="Lprm_CFformato"             value="#CFFormato#"/>
  			<cfinvokeargument name="Lprm_Ocodigo"               value="#rsCentroFuncional.Ocodigo#"/>
   			<cfinvokeargument name="Lprm_TransaccionActiva"     value="true"/>
			<cfinvokeargument name="Lprm_Fecha"     			value="#rsFecha.value#"/>
	 </cfinvoke>
		<cfif LvarStructResult['MSG'] EQ "OK">
			<cfreturn LvarStructResult['PCGcuenta']>
		<cfelse>
			<cfthrow message="Error Creando la Cuenta: #CFFormato#<br>" detail="#LvarStructResult['MSG']#">
		</cfif>
	</cffunction>
	
	<!--- Valida la variación no modifica monto de la estimación --->
	<cffunction name="ValidarVariacionNoMonto"  access="private" output="true">
		<cfargument name="CFid"				 type="numeric" required="yes">
		<cfargument name="CPPid"  			 type="numeric" required="yes">
		<cfargument name="Conexion" 		 type="string"  required="no">
		<cfargument name="FPEEestado" 		 type="string"  required="no" default="0">
		<cfargument name="GenerarQuery" 	 type="boolean" required="no" default="true">
		<cfargument name="FPEEid" 	 		 type="numeric" required="no" default="-1">
		<cfargument name="Sufijo" 	 		 type="string"  required="no" default="">
		
		
		
    	<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif Arguments.GenerarQuery>
			<cfinvoke component="sif.Componentes.FPRES_Equilibrio" method="CreateQueryGeneral" returnvariable="query">
				<cfinvokeargument name="CPPid" 			value="#Arguments.CPPid#">
				<cfinvokeargument name="FPEEestado" 	value="#Arguments.FPEEestado#">
				<cfinvokeargument name="Conexion" 		value="#Arguments.Conexion#">		
			</cfinvoke>
		<cfelse>
			<cfset query = Request.rsQueryGeneral>
		</cfif>
		<cfquery dbtype="query" name="rsNivelesEquilibrio">	
			select PCDcatid, PCDdescripcion,
				sum(IngresosEstimacion) as TotalIngresos,
				sum(EgresosEstimacion)  as TotalEgresos,
				sum(IngresosPlan) as TotalIngresosPlan,
				sum(EgresosPlan) as TotalEgresosPlan
			from query
			where CFid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#">
			group by PCDcatid, PCDdescripcion
			having
			  sum(IngresosPlan) - sum(IngresosEstimacion) <> 0
			  or 
			  sum(EgresosPlan) - sum(EgresosEstimacion)  <> 0
			order by PCDdescripcion
		</cfquery>
		<cfif rsNivelesEquilibrio.recordcount gt 0>
			<html>
			<head></head>
			<body>
			<cf_templatecss>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr style="font-weight:bold;">
					<td colspan="13" align="center" style="font-size:24px">Los siguientes niveles de equilibrio estan desequilibrados</td>
				</tr>
				<tr><td colspan="13">&nbsp;</td></tr>
				<tr style="font-weight:bold" align="center">
					<td colspan="2" nowrap>Nivel</td>
					<td colspan="2" nowrap>Total Egresos</td>
					<td colspan="2" nowrap>Total Egresos En Plan</td>
					<td colspan="2" nowrap>Diferencia</td>
					<td colspan="2" nowrap>Total Ingresos</td>
					<td colspan="2" nowrap>Total Ingresos En Plan</td>
					<td nowrap>Diferencia</td>
				</tr>
				<cfset i = 0>
				<cfoutput query="rsNivelesEquilibrio">
					<tr class="<cfif i mod 2 eq 0>listaPar<cfelse>listaNon</cfif>">
						<cfset lvarDifE = rsNivelesEquilibrio.TotalEgresosPlan - rsNivelesEquilibrio.TotalEgresos>
						<cfset lvarDifI = rsNivelesEquilibrio.TotalIngresosPlan - rsNivelesEquilibrio.TotalIngresos>
						<td nowrap>#rsNivelesEquilibrio.PCDdescripcion#</td><td>&nbsp;</td>
						<td align="right" nowrap>#numberformat(rsNivelesEquilibrio.TotalEgresos,',9.0000')#</td><td>&nbsp;</td>
						<td align="right" nowrap>#numberformat(rsNivelesEquilibrio.TotalEgresosPlan,',9.0000')#</td><td>&nbsp;</td>
						<td align="right" nowrap>#numberformat(lvarDifE,',9.0000')#</td><td>&nbsp;</td>
						<td align="right" nowrap>#numberformat(rsNivelesEquilibrio.TotalIngresos,',9.0000')#</td><td>&nbsp;</td>
						<td align="right" nowrap>#numberformat(rsNivelesEquilibrio.TotalIngresosPlan,',9.0000')#</td><td>&nbsp;</td>
						<td align="right" nowrap>#numberformat(lvarDifI,',9.0000')#</td>
					</tr>
					<cfset i = i + 1>
				</cfoutput>
				<tr><td colspan="13">&nbsp;</td></tr>
				<tr style="font-weight:bold;">
					<td colspan="13">El proceso no puede continuar hasta que los niveles esten equilibrados.</td>
				</tr>
				<tr><td colspan="13">&nbsp;</td></tr>
				<tr>
					<td colspan="13">
						<form name="form1" action="VariacionPresupuestal#Arguments.Sufijo#.cfm?FPEEid=#Arguments.FPEEid#" method="post"><cf_botones values="Regresar"></form>
					</td>
				</tr>
			</table>
			</body>
			</html>
			<cfabort>
		</cfif>
	</cffunction>
		<!---===============================================--->
	<cffunction name="CrearFiltro_All" 		access="public" returntype="string">
		<cfargument name='FPCCconcepto'			type='string' 	required='true'>
		<cfargument name='DPDEdescripcion'		type='string' 	required='no'>
		<cfargument name='DPDEjustificacion'	type='string' 	required='no'>
		<cfargument name='FPAEid'				type='numeric' 	required='no'>
		<cfargument name='CFComplemento'		type='string' 	required='no'>
		<cfargument name='Aid'					type='numeric' 	required='no'>
		<cfargument name='Cid'					type='numeric' 	required='no'>
		<cfargument name='FPCid'				type='numeric' 	required='no'>
		<cfargument name='Mcodigo'				type='numeric' 	required='no'>
		<cfargument name='Ucodigo'				type='string' 	required='no'>
		<cfargument name='DPDEfechaIni'			type='string' 	required='no'>
		<cfargument name='DPDEfechaFin'			type='string' 	required='no'>
		<cfargument name='OBPcodigo'			type='string' 	required='no'>
		<cfargument name='OBOcodigo'			type='string' 	required='no'>
		
	
		<cfset filtro_All = "">
		<cfif isdefined('Arguments.DPDEdescripcion') and len(trim(Arguments.DPDEdescripcion))>
			<cfset filtro_All &= " and upper(a.DPDEdescripcion) like '%#Ucase(Arguments.DPDEdescripcion)#%'">
		</cfif>
		<cfif isdefined('Arguments.DPDEjustificacion') and len(trim(Arguments.DPDEjustificacion))>
			<cfset filtro_All &= " and upper(a.DPDEjustificacion) like '%#Ucase(Arguments.DPDEjustificacion)#%'">
		</cfif>
		<cfif isdefined('Arguments.FPAEid') and len(trim(Arguments.FPAEid)) and isdefined('Arguments.CFComplemento') and len(trim(Arguments.CFComplemento))>
			<cfset filtro_All &= " and a.FPAEid = #Arguments.FPAEid# and a.CFComplemento = '#Arguments.CFComplemento#'">
		</cfif>
		<cfif isdefined('Arguments.Aid') and len(trim(Arguments.Aid)) and ListFind('A', Arguments.FPCCconcepto)>
			<cfset filtro_All &= " and a.Aid = #Arguments.Aid#">
		</cfif>
		<cfif isdefined('Arguments.Cid') and len(trim(Arguments.Cid)) and ListFind('S,P', Arguments.FPCCconcepto)>
			<cfset filtro_All &= " and a.Cid = #Arguments.Cid#">
		</cfif>
		<cfif isdefined('Arguments.FPCid') and len(trim(Arguments.FPCid)) and ListFind(ListFPCCconcepto, Arguments.FPCCconcepto)>
			<cfset filtro_All &= " and a.FPCid = #Arguments.FPCid#">
		</cfif>
		<cfif isdefined('Arguments.Mcodigo') and len(trim(Arguments.Mcodigo))>
			<cfset filtro_All &= " and a.Mcodigo = #Arguments.Mcodigo#">
		</cfif>
		<cfif isdefined('Arguments.Ucodigo') and len(trim(Arguments.Ucodigo))>
			<cfset filtro_All &= " and a.Ucodigo = '#Arguments.Ucodigo#'">
		</cfif>
		<cfif isdefined('Arguments.DPDEfechaIni') and len(trim(Arguments.DPDEfechaIni))>
			<cfset filtro_All &= " and a.DPDEfechaIni = #LSParseDateTime(Arguments.DPDEfechaIni)#">
		</cfif>
		<cfif isdefined('Arguments.DPDEfechaFin') and len(trim(Arguments.DPDEfechaFin))>
			<cfset filtro_All &= " and a.DPDEfechaFin = #LSParseDateTime(Arguments.DPDEfechaFin)#">
		</cfif>
		<cfif isdefined('Arguments.OBPcodigo') and len(trim(Arguments.OBPcodigo)) and ListFind('P', Arguments.FPCCconcepto)>
			<cfset filtro_All &= " and upper(OP.OBPcodigo) like '%#Ucase(Arguments.OBPcodigo)#%'">
		</cfif>
		<cfif isdefined('Arguments.OBOcodigo') and len(trim(Arguments.OBOcodigo)) and ListFind('P', Arguments.FPCCconcepto)>
			<cfset filtro_All &= " and upper(OB.OBOcodigo) like '%#Ucase(Arguments.OBOcodigo)#%'">
		</cfif>
		
		
		<cfreturn filtro_All>
	</cffunction>
	
	<cffunction name="fnFechaDefault" access="public" output="no" returntype="date">
		<cfargument name="Ecodigo" 		 	type="numeric"  required="no">
		<cfargument name="Conexion" 		type="string"  	required="no">
		
    	<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		
		<!--- Obtiene el Periodo-Mes de Auxiliares --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #Arguments.Ecodigo#
			   and Pcodigo = 50
		</cfquery>
		<cfset LvarAuxAno = rsSQL.Pvalor>
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #Arguments.Ecodigo#
			   and Pcodigo = 60
		</cfquery>
		<cfset LvarAuxMes = rsSQL.Pvalor>

		<cfset LvarAuxMesFechaIni = createDate(LvarAuxAno,LvarAuxMes,1)>
		<cfset LvarAuxMesFechaFin = createDate(LvarAuxAno,LvarAuxMes,DaysInMonth(LvarAuxMesFechaIni))>

		<cfset LvarAuxAnoMes = LvarAuxAno*100 + LvarAuxMes>
		<cfset LvarHoyAnoMes = DateFormat(now(),"YYYYMM")>

		<cfif LvarHoyAnoMes LT LvarAuxAnoMes>
			<!--- Si se digita antes del mes de Aux: Fecha inicial --->
			<cfreturn LvarAuxMesFechaIni>
		<cfelseif LvarHoyAnoMes GT LvarAuxAnoMes>
			<!--- Si se digita despues del mes de Aux: Fecha final --->
			<cfreturn LvarAuxMesFechaFin>
		<cfelse>
			<!--- Si se digita durante el mes de Aux: Fecha actual --->
			<cfreturn createDate(LvarAuxAno,LvarAuxMes, Day(now()) )>
		</cfif>
	</cffunction>
	<!---Al enviar a Equilibrio se guarda la estimación en la table de Historicos de Versiones--->
	<cffunction name="GuardarHVersion" access="public" output="no" returntype="numeric">
		<cfargument name="Ecodigo" 		 	type="numeric"  required="no">
		<cfargument name="Conexion" 		type="string"  	required="no">
		<cfargument name="FPEEid" 		 	type="numeric"  required="yes">
		
    	<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfquery datasource="#Arguments.Conexion#" name="HV">
			select coalesce(max(Version),0)+1 NewVersion from VFPEEstimacion where FPEEid = #Arguments.FPEEid#
		</cfquery>
		<!---Se guarda el Encabezado de la Estimación--->
		<cfquery datasource="#Arguments.Conexion#">
			insert into VFPEEstimacion 
			         (Version, 		FPEEid ,CFid, FPTVid, FPEEestado, FPEEFechaLimite, FPEEUsucodigo, FPEEidRef, Ecodigo, CPPid, FPEEVersion, BMUsucodigo) 
			select #HV.NewVersion#, FPEEid ,CFid, FPTVid, FPEEestado, FPEEFechaLimite, FPEEUsucodigo, FPEEidRef, Ecodigo, CPPid, FPEEVersion, BMUsucodigo
			from FPEEstimacion
			where FPEEid = #Arguments.FPEEid#
		</cfquery>
		<!---Se guarda el Detalle de la Estimación--->
		<cfquery datasource="#Arguments.Conexion#">
			insert into VFPDEstimacion 
			           (Version, FPDEid, FPEEid, FPEPid, FPDElinea, Ecodigo, DPDEdescripcion, DPDEjustificacion, DPDEcosto, DPDEcantidad, DPDEcantidadPeriodo, Mcodigo, Dtipocambio, FPAEid, CFComplemento, FPCCid, DPDEfechaIni, DPDEfechaFin, Ucodigo, Aid, Cid, OBOid, FPCid, DPDEObservaciones, DPDMontoTotalPeriodo, PCGDid, PCGcuenta, BMUsucodigo, CPcuenta, consecutivo, DPDEcontratacion, DPDEmontoMinimo, DPDEmontoAjuste) 
		 select #HV.NewVersion#, FPDEid, FPEEid, FPEPid, FPDElinea, Ecodigo, DPDEdescripcion, DPDEjustificacion, DPDEcosto, DPDEcantidad, DPDEcantidadPeriodo, Mcodigo, Dtipocambio, FPAEid, CFComplemento, FPCCid, DPDEfechaIni, DPDEfechaFin, Ucodigo, Aid, Cid, OBOid, FPCid, DPDEObservaciones, DPDMontoTotalPeriodo, PCGDid, PCGcuenta, BMUsucodigo, CPcuenta, consecutivo, DPDEcontratacion, DPDEmontoMinimo, DPDEmontoAjuste
		  from FPDEstimacion
			where FPEEid = #Arguments.FPEEid#
		</cfquery>
		<cfreturn #HV.NewVersion#>
	</cffunction>
	
	<!--- Guarda Los datos de las estimaciones/variaciones Congeladas --->
	<cffunction name="fnCongelar" access="public">
		<cfargument name="CPPid" 		 	type="numeric"  required="yes">
		<cfargument name="FPEEestado" 		type="numeric"  required="yes">
		<cfargument name="FPVCdescripcion" 	type="string"  required="yes">
		<cfargument name="Ecodigo" 		 	type="numeric"  required="no">
		<cfargument name="Conexion" 		type="string"  	required="no">

    	<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		
		<cfquery name="rsVCongelada" datasource="#Arguments.Conexion#">
			insert into FPEstimacionesCongeladas(FPECdescripcion,Ecodigo,BMUsucodigo)
			values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.FPVCdescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">,
				#session.usucodigo#
			)
			<cf_dbidentity1>
    	</cfquery>
		<cf_dbidentity2 name="rsVCongelada">
		<cfset lvarFPVCid = rsVCongelada.identity>
		
		<cfquery datasource="#Arguments.Conexion#">
			update PCGDplanCompras set 
			  PCGDpendiente = 0,
			  PCGDcantidadPendiente = 0
			where PCGDid in (select de.PCGDid
								from FPEEstimacion ee
									inner join FPDEstimacion de
										on de.FPEEid = ee.FPEEid
								where ee.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.CPPid#">
								  and not ee.FPEEestado in (6,7,8)
								  and ee.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Ecodigo#">
								  and de.PCGDid = PCGDplanCompras.PCGDid
							)
		</cfquery>
		
		<cfquery datasource="#Arguments.Conexion#">
			update FPEEstimacion
			set FPECid = #lvarFPVCid#
			where CPPid = #Arguments.CPPid#
			  and not FPEEestado in (6,7,8)
			  and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		
		<cfinvoke component="sif.Componentes.FPRES_Equilibrio" method="CambioEstadoMasivo">
			<cfinvokeargument name="FPEEestado" 	value="8">
			<cfinvokeargument name="Filtro" 		value="CPPid = #Arguments.CPPid# and not FPEEestado in (6,7,8) and Ecodigo = #Arguments.Ecodigo#">
		</cfinvoke>
		
	</cffunction>
	
	<!--- Descongela las estimaciones/variaciones Congeladas --->
	<cffunction name="fnDescongelar" access="public">
		<cfargument name="FPECid" 	type="numeric"  required="yes">
		<cfargument name="Ecodigo" 		 	type="numeric"  required="no">
		<cfargument name="Conexion" 		type="string"  	required="no">

    	<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		
		<cfquery name="rsEnProceso" datasource="#Arguments.Conexion#">
			select count(1) as cantidad
			from FPEEstimacion
			where Ecodigo = #Arguments.Ecodigo#
			  and CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPPid#">
			  and FPEEestado in (0,1,2,3,4,5)
		</cfquery>
		<cfif rsEnProceso.cantidad gt 0>
			<cfthrow message="Existen Estimaciones/Variaciones en proceso, no se puede descongelar hasta que estas sean finalizados o congeladas.">
		</cfif>
		
		<!--- Actualiza los campos de la estimacion segun el plan de compras --->
		<cfquery name="rsEstimaciones" datasource="#Arguments.Conexion#">
			update FPDEstimacion
			set
				DPDEcosto = (
								select 
									case when pcd.PCGDxPlanCompras = 0 then 
										(select sum( pc.CPCpresupuestado
													 + pc.CPCmodificado
													 + pc.CPCmodificacion_Excesos
													 + pc.CPCvariacion
													 + pc.CPCtrasladado	
													 + pc.CPCtrasladadoE
										)
										   from CPresupuestoControl pc 
										  where pc.Ecodigo  = pce.Ecodigo
											and pc.CPPid    = pce.CPPid
											and pc.CPcuenta = c.CPcuenta
											and pc.Ocodigo  = cf.Ocodigo
										) / pcd.PCGDtipocambio
									else Coalesce(pcd.PCGDcostoUori,0.00) end
									+ (FPDEstimacion.DPDEcosto - FPDEstimacion.DPDMontoTotalPeriodo)
        							- (coalesce(pcd.PCGDcostoUori,0.00) - coalesce(pcd.PCGDcostoOri,0.00))
								from PCGDplanCompras pcd
									left outer join PCGDplanComprasMultiperiodo pcmp
										on pcmp.PCGDid = pcd.PCGDid
									inner join PCGplanCompras pce
										on pce.PCGEid = pcd.PCGEid
									inner join PCGcuentas c
										on c.PCGcuenta = pcd.PCGcuenta
									inner join CFuncional cf
										on cf.CFid = pcd.CFid
								where pcd.PCGDid = FPDEstimacion.PCGDid
							) + DPDEmontoAjuste
				,DPDMontoTotalPeriodo = (
											select
												case when pcd.PCGDxPlanCompras = 0 then 
													(select sum( cp.CPCpresupuestado
																 + cp.CPCmodificado
																 + cp.CPCmodificacion_Excesos
																 + cp.CPCvariacion
																 + cp.CPCtrasladado	
																 + cp.CPCtrasladadoE
																)
													from CPresupuestoControl cp 
													where cp.Ecodigo  = pce.Ecodigo
													  and cp.CPPid    = pce.CPPid
													  and cp.CPcuenta = c.CPcuenta
													  and cp.Ocodigo  = cf.Ocodigo
													) / pcd.PCGDtipocambio
											else Coalesce(pcd.PCGDcostoOri,0.00) end
											from PCGDplanCompras pcd
												left outer join PCGDplanComprasMultiperiodo pcmp
													on pcmp.PCGDid = pcd.PCGDid
												inner join PCGplanCompras pce
													on pce.PCGEid = pcd.PCGEid
												inner join PCGcuentas c
													on c.PCGcuenta = pcd.PCGcuenta
												inner join CFuncional cf
													on cf.CFid = pcd.CFid
											where pcd.PCGDid = FPDEstimacion.PCGDid
					) + DPDEmontoAjuste
				,DPDEcantidad = (
									select
									    coalesce(pcmp.PCGDcantidadTotal, pcd.PCGDcantidad, 1)
										+ (FPDEstimacion.DPDEcantidad - FPDEstimacion .DPDEcantidadPeriodo)
										- (coalesce(pcmp.PCGDcantidadTotal, pcd.PCGDcantidad) - pcd.PCGDcantidad)
										+ case when pcd.PCGDxCantidad = 1 then FPDEstimacion.DPDEmontoAjuste / FPDEstimacion.DPDEcosto else 0 end
									from PCGDplanCompras pcd
										left outer join PCGDplanComprasMultiperiodo pcmp
											on pcmp.PCGDid = pcd.PCGDid
									where pcd.PCGDid = FPDEstimacion.PCGDid
								 )
				,DPDEcantidadPeriodo = (
											select case when pcd.PCGDxPlanCompras = 0 then 1 else pcd.PCGDcantidad end  + case when pcd.PCGDxCantidad = 1 then FPDEstimacion.DPDEmontoAjuste / FPDEstimacion.DPDEcosto else 0 end
											from PCGDplanCompras pcd
											where pcd.PCGDid = FPDEstimacion.PCGDid
									   )
				,DPDEmontoMinimo = (
										select pcd.PCGDmontoMinimo
										from PCGDplanCompras pcd
										where pcd.PCGDid = FPDEstimacion.PCGDid
									)
			where
			  FPDEid in ( select FPDEid
			  	from FPEEstimacion ee
					inner join FPDEstimacion de
						on de.FPEEid = ee.FPEEid
					inner join PCGDplanCompras pcd
						on pcd.PCGDid = de.PCGDid
				where ee.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
				  and ee.FPECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPECid#">
			  )
		</cfquery>
		
		<!--- Elimina lineas que ha sido eliminadas del plan de compras --->
		<cfquery name="rsEstimaciones" datasource="#Arguments.Conexion#">
			delete from FPDEstimacion
			where FPDEid in(
							select FPDEid
							from FPEEstimacion ee
								inner join FPDEstimacion de
									on de.FPEEid = ee.FPEEid
							where ee.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
							  and ee.FPECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPECid#">
							  and not exists(
							  					select 1 
												from PCGDplanCompras pcd
												where pcd.PCGDid = de.PCGDid
							  				)
			  				)
		</cfquery>
		
		<!--- Inserta las nuevas lineas del plan de compras a la estimacion --->
		<cfquery name="DetalleEstimacion" datasource="#Arguments.Conexion#">
			insert into FPDEstimacion
			 (FPEEid, FPEPid, FPDElinea, Ecodigo, DPDEdescripcion, DPDEjustificacion, Mcodigo,Dtipocambio, FPAEid,CFComplemento, 
			  FPCCid, DPDEfechaIni, DPDEfechaFin, Ucodigo, Aid, Cid, FPCid, OBOid, DPDEObservaciones, DPDEcosto, DPDEcantidad, DPDEcantidadPeriodo, 
			  DPDMontoTotalPeriodo,PCGDid, PCGcuenta,DPDEcontratacion,DPDEmontoMinimo,DPDEmontoAjuste)
			select 
				ee.FPEEid, a.FPEPid,
				(select coalesce(max(b.FPDElinea),0) 
					from FPDEstimacion b 
				where b.FPEEid = ee.FPEEid
				  and b.FPEPid = a.FPEPid)
				+(select count(1) 
					from PCGDplanCompras contador
					where contador.PCGEid    = epc.PCGEid
					  and contador.CFid	    = a.CFid 
					  and contador.PCGDid <= a.PCGDid
				  )
				,
				a.Ecodigo,a.PCGDdescripcion, a.PCGDjustificacion, a.Mcodigo, a.PCGDtipocambio,a.FPAEid,a.CFComplemento, 
				a.FPCCid, a.PCGDfechaIni, a.PCGDfechaFin,
				case when <cf_dbfunction name="length"	args="rtrim(a.Ucodigo)"> > 0 then a.Ucodigo else 
				 <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="null"> end,
				a.Aid, a.Cid, a.FPCid, a.OBOid, a.PCGDobservaciones,
				<!---Precio Unitario: Cuando no es controlado por Plan de Compras, no controla Cantidad, 
				por lo tanto el Precio Unitario en moneda local es igual al Autorizado del Perido. NO poner coalesce, para que de error, 
				ya que siempre debe haber Registro en ControlPresupuesto, si no hay fue porque cambiaron la Oficina del CF--->
				case when a.PCGDxPlanCompras = 0 then 
				(select sum( m.CPCpresupuestado
							 + m.CPCmodificado
							 + m.CPCmodificacion_Excesos
							 + m.CPCvariacion
							 + m.CPCtrasladado	
							 + m.CPCtrasladadoE
				)
				   from CPresupuestoControl m 
				  where m.Ecodigo  = j.Ecodigo
					and m.CPPid    = j.CPPid
					and m.CPcuenta = l.CPcuenta
					and m.Ocodigo  = CF.Ocodigo
				) / a.PCGDtipocambio
				else Coalesce(a.PCGDcostoUori,0.00) end,
				<!---Cantidad Total (Multiperiodo)--->
				coalesce(mp.PCGDcantidadTotal,a.PCGDcantidad,1),
				<!---Cantidad del periodo: Cuando no se controla por Plan de Compras, la cantidad Siempre es 1--->
				case when a.PCGDxPlanCompras = 0 then 1 else a.PCGDcantidad end,
				<!---Monto del Periodo en Moneda Origen : Si es una moneda no Local y NO se controla por plan de Compras, se toma el Tipo de cambio 
				del Plan de Compras con el Monto de Presupuesto (En Buena Teoria, nunca van a usar PCG y Presupuesto, por lo que PCG = presupuesto)
				NO poner coalesce, para que de error,ya que siempre debe haber Registro en ControlPresupuesto, si no hay fue porque cambiaron la Oficina del CF--->
				case when a.PCGDxPlanCompras = 0 then 
				(select sum( m.CPCpresupuestado
							 + m.CPCmodificado
							 + m.CPCmodificacion_Excesos
							 + m.CPCvariacion
							 + m.CPCtrasladado	
							 + m.CPCtrasladadoE
				)
				   from CPresupuestoControl m 
				  where m.Ecodigo  = j.Ecodigo
					and m.CPPid    = j.CPPid
					and m.CPcuenta = l.CPcuenta
					and m.Ocodigo  = CF.Ocodigo
				) / a.PCGDtipocambio
				else Coalesce(a.PCGDcostoOri,0.00) end DPDMontoTotalPeriodo,
				
				a.PCGDid,
				a.PCGcuenta,
				a.PCGDcontratacion,
				a.PCGDmontoMinimo,
				0
			 from FPEEstimacion ee
				inner join PCGplanCompras epc
					on epc.CPPid = ee.CPPid and epc.Ecodigo = ee.Ecodigo
				inner join PCGDplanCompras a
					on a.CFid = ee.CFid and a.PCGEid = epc.PCGEid
				left outer join PCGDplanComprasMultiperiodo mp
					on mp.PCGDid = a.PCGDid
				inner join PCGplanCompras j
					on j.PCGEid = a.PCGEid				
				inner join PCGcuentas l
					on l.PCGcuenta = a.PCGcuenta
				inner join CFuncional CF
					on cf.CFid = ee.CFid
			where ee.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Arguments.CPPid#">
			  and ee.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			  and ee.FPECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPECid#">
			  and not exists(
					select 1
					from FPDEstimacion de
					where de.PCGDid = a.PCGDid
      				  and de.FPEEid = ee.FPEEid
				)
		</cfquery>
		<cfquery datasource="#Arguments.Conexion#">
			update FPEEstimacion
			set FPEEestado = 0
			  , FPECid = null
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			  and FPECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPECid#">
		</cfquery>
		<cfquery datasource="#Arguments.Conexion#">
			delete from FPEstimacionesCongeladas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			  and FPECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPECid#">
		</cfquery>
	</cffunction>
	
	<!--- Valida inconsistencia en las lineas de la(s) estimacion(es) --->
	<cffunction name="fnValidarInconsistencias" access="public" output="true">
		<cfargument name="FPEEid" 		type="string"  	required="yes">
		<cfargument name="IrA" 			type="string"  	required="no" default="EstimacionGI.cfm">
		<cfargument name="Ecodigo" 		type="numeric"  required="no">
		<cfargument name="Conexion" 	type="string"  	required="no">

    	<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		
		<cfquery datasource="#Arguments.Conexion#" name="rsLineasInc">
			select cf.CFdescripcion, de.DPDEdescripcion, de.DPDEmontoAjuste, de.DPDMontoTotalPeriodo, ep.FPEPdescripcion, dpc.PCGDid,  dpc.PCGDcostoOri
			from FPEEstimacion ee
				inner join FPDEstimacion de
					on de.FPEEid = ee.FPEEid
				left outer join PCGDplanCompras dpc
					on dpc.PCGDid = de.PCGDid
				inner join FPEPlantilla ep
					on ep.FPEPid = de.FPEPid
				inner join CFuncional cf
					on cf.CFid = ee.CFid
			where de.FPEEid in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEEid#" list="yes">)
			and de.DPDMontoTotalPeriodo < 0
		</cfquery>
		
		<cfif rsLineasInc.recordcount gt 0>
			<html><head></head><body><cf_templatecss>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr style="font-weight:bold;">
						<td colspan="11" align="center" style="font-size:24px">Las Siguientes lineas presentan inconsistencias</td>
					</tr>
					<tr><td colspan="11">&nbsp;</td></tr>
					<tr style="font-weight:bold" align="center">
						<td nowrap>Centro Funcional</td><td>&nbsp;</td>
						<td nowrap>Plantilla</td><td>&nbsp;</td>
						<td nowrap>Descripci&oacute;n</td><td>&nbsp;</td>
						<td nowrap>Monto Estimaci&oacute;n</td><td>&nbsp;</td>
						<td nowrap>Monto Plan Compras</td><td>&nbsp;</td>
						<td nowrap>Monto Ajuste</td>
					</tr>
					<cfset i = 0>
					<cfoutput query="rsLineasInc">
						<tr class="<cfif i mod 2 eq 0>listaPar<cfelse>listaNon</cfif>">
							<td nowrap>#rsLineasInc.CFdescripcion#</td><td>&nbsp;</td>
							<td nowrap>#rsLineasInc.FPEPdescripcion#</td><td>&nbsp;</td>
							<td nowrap>#rsLineasInc.DPDEdescripcion#</td><td>&nbsp;</td>
							<td align="right" nowrap>#numberformat(rsLineasInc.DPDMontoTotalPeriodo,',9.0000')#</td><td>&nbsp;</td>
							<td align="right" nowrap>#numberformat(rsLineasInc.PCGDcostoOri,',9.0000')#</td><td>&nbsp;</td>
							<td align="right" nowrap>#numberformat(rsLineasInc.DPDEmontoAjuste,',9.0000')#</td>
						</tr>
						<cfset i = i + 1>
					</cfoutput>
					<tr><td colspan="11">&nbsp;</td></tr>
					<tr style="font-weight:bold;">
						<td colspan="11">El proceso no puede continuar hasta que las lineas sean verificadas y solucionadas, el monto del ajuste no puede ser mayor al disponible en el plan de compras.</td>
					</tr>
					<tr><td colspan="11">&nbsp;</td></tr>
					<tr>
						<td colspan="11">
							<form name="form1" action="#Arguments.IrA#" method="post"><cf_botones values="Regresar"></form>
						</td>
					</tr>
				</table>
			</body></html>
			<cfabort>
		</cfif>
	</cffunction>
	<cffunction name="fnActualizaPendientes" access="public">
		<cfargument name="FPEEid" 		type="numeric"  required="no">
		<cfargument name="CPPid" 		type="numeric"  required="no">
		<cfargument name="FPTVTipo" 	type="string"   required="yes" default="1">
		<cfargument name="Ecodigo" 		type="numeric"  required="no">
		<cfargument name="Conexion" 	type="string"  	required="no">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif (not isdefined('Arguments.FPEEid') or Arguments.FPEEid eq -1) and (not isdefined('Arguments.CPPid') or Arguments.CPPid eq -1)>
			<cfthrow message="fnActualizaPendientes[ Debe de ingresar alguno de estos dos campos, FPEEid ó CPPid]">
		</cfif>
		<cfquery datasource="#Arguments.Conexion#">
			update PCGDplanCompras set
				PCGDpendiente = 0,
				PCGDcantidadPendiente = 0
				where PCGDid in( select de.PCGDid
								from FPEEstimacion ee
									inner join FPDEstimacion de
										on de.FPEEid = ee.FPEEid
									inner join TipoVariacionPres tv
										on tv.FPTVid = ee.FPTVid
									where 
									<cfif isdefined('Arguments.FPEEid') and Arguments.FPEEid neq -1>
										de.FPEEid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.FPEEid#">
									<cfelse>
										ee.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
										and ee.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPPid#">
										and ee.FPEEestado = 2
									</cfif>
									and not tv.FPTVTipo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPTVTipo#" list="yes">)
									and de.PCGDid = PCGDplanCompras.PCGDid
								)
		</cfquery>
		<cfquery datasource="#Arguments.Conexion#" name="rsDetalles">
			select de.DPDEdescripcion, de.PCGDid,
				coalesce(case when ep.PCGDxCantidad = 1 then
					(de.DPDEmontoAjuste / de.DPDEcosto)
				else
					 de.DPDEmontoAjuste
				end, 0) as Ajuste,
				case when ep.PCGDxCantidad = 1 then
					coalesce(dpc.PCGDcantidad,0) - coalesce(dpc.PCGDcantidadCompras,0) - coalesce(dpc.PCGDcantidadConsumo,0)
				else
					coalesce(dpc.PCGDautorizado,0) - coalesce(dpc.PCGDreservado,0) - coalesce(dpc.PCGDcomprometido,0) 
					- coalesce(dpc.PCGDejecutado,0)
				 end as Disponible,
				 ep.PCGDxCantidad,PCGDpendiente
			from FPEEstimacion ee
				inner join FPDEstimacion de
					on de.FPEEid = ee.FPEEid
				inner join PCGDplanCompras dpc
					on dpc.PCGDid = de.PCGDid
				inner join FPEPlantilla ep
					on ep.FPEPid = de.FPEPid
				inner join TipoVariacionPres tv
					on tv.FPTVid = ee.FPTVid
				where 
				<cfif isdefined('Arguments.FPEEid') and Arguments.FPEEid neq -1>
					de.FPEEid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.FPEEid#">
				<cfelse>
					ee.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
					and ee.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPPid#">
					and ee.FPEEestado = 2
				</cfif>
				and not tv.FPTVTipo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPTVTipo#" list="yes">)
				and de.DPDEmontoAjuste < 0
		</cfquery>
		<cfloop query="rsDetalles">
			<cfset lvarAjuste = rsDetalles.Ajuste>
			<cfif rsDetalles.PCGDxCantidad eq '0' and abs(lvarAjuste) gt rsDetalles.Disponible>
				<cfthrow message="'#rsDetalles.DPDEdescripcion#', El monto para el consumo negativo autorizado pero pendiente de aplicar es mayor al disponible actual. Disponible actual: #rsDetalles.Disponible#">
			<cfelseif rsDetalles.PCGDxCantidad eq '1' and abs(lvarAjuste) gt rsDetalles.Disponible>
				<cfthrow message="#rsDetalles.DPDEdescripcion#, La cantidad para el consumo negativo autorizado pero pendiente de aplicar es mayor al disponible actual. Disponible actual: #rsDetalles.Disponible#">
			</cfif>
			<cfquery datasource="#Arguments.Conexion#">
					update PCGDplanCompras set
					<cfif rsDetalles.PCGDxCantidad eq '0'>
						PCGDpendiente
					<cfelse>
						PCGDcantidadPendiente
					</cfif>
						= <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarAjuste#">
					where PCGDid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalles.PCGDid#">
			</cfquery>
		</cfloop>
	</cffunction>
</cfcomponent>
