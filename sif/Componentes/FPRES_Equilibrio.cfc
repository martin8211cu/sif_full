<cfcomponent>
	<!---=================GetEquilibrio: Obtiene el listado de todas los equilibrios disponibles=======--->
	<cffunction name="GetEquilibrio"  access="public" returntype="query">
		<cfargument name="Conexion" 	type="string"  required="no">
		<cfargument name="Ecodigo" 		type="numeric" required="no">
		<cfargument name="CPPid" 		type="numeric" required="no">
		<cfargument name="FPEEestado" 	type="string" required="no">
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cf_dbfunction name="OP_concat" returnvariable="_Cat">
		<cfquery datasource="#Arguments.Conexion#" name="rslistaEquilibrio">		
			select  Distinct a.CPPid, case when f.FPTVTipo = -1 then 'Prespuesto Ordinario' when f.FPTVTipo = 0 then 'Modificación Presupuestaria' else 'Variación' end #_Cat#
			case d.CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
					#_Cat# ' de ' #_Cat# 
					case {fn month(d.CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(d.CPPfechaDesde)}">
					#_Cat# ' a ' #_Cat# 
					case {fn month(d.CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(d.CPPfechaHasta)}">
				as Pdescripcion,
				(select count(1) from FPEEstimacion  b where a.CPPid = b.CPPid) total,
				(select count(1) from FPEEstimacion  b where a.CPPid = b.CPPid and FPEEestado = 0 ) EnPreparacion,
				(select count(1) from FPEEstimacion  b where a.CPPid = b.CPPid and FPEEestado = 1 ) EnAprobacion,
				(select count(1) from FPEEstimacion  b where a.CPPid = b.CPPid and FPEEestado = 2 ) Listo, 
				(select count(1) from FPEEstimacion  b where a.CPPid = b.CPPid and FPEEestado > 2 ) otros, 
				case FPEEestado when 2 then 'En equilibrio Financiero' when 3 then 'En Aprobación Interna' when 4 then 'En Aprobación Externa' else 'Otro' end as Estado, 
				FPEEestado,
				FPTVTipo
			from FPEEstimacion a 
				inner join CPresupuestoPeriodo d 
					 on a.CPPid = d.CPPid
				inner join TipoVariacionPres f
					on f.FPTVid = a.FPTVid
			 where a.FPEEestado in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEEestado#" list="yes">)
			 	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			 <cfif isdefined('Arguments.CPPid')>
			 	and a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPPid#">
			 </cfif>
		</cfquery>
		<cfreturn rslistaEquilibrio>
	</cffunction>
	<!---=================GetNiveles: Obtiene el listado de todas niveles de Equilibrio=======--->
	<cffunction name="GetNiveles"  access="public" returntype="query">
		<cfargument name="Conexion" type="string"  required="no">
		<cfargument name="CPPid" 	type="numeric" required="yes">
		<cfargument name="FPO" 		type="boolean" required="yes" default="true">
		<cfargument name="query" 	type="query"   required="no">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif Arguments.FPO>
			<cfquery datasource="#Arguments.Conexion#" name="NivelEquilibrio">	
				select dc.PCDcatid, dc.PCDdescripcion,
					   Round(Coalesce(sum(case ep.FPCCtipo when 'I' then de.DPDMontoTotalPeriodo * de.Dtipocambio  else 0 end),0),2) as TotalIngresos,
					   Round(Coalesce(sum(case ep.FPCCtipo when 'G' then de.DPDMontoTotalPeriodo * de.Dtipocambio  else 0 end),0),2) as TotalEgresos,
					   Round(Coalesce(sum(case ep.FPCCtipo when 'I' then de.DPDMontoTotalPeriodo * de.Dtipocambio  else - de.DPDMontoTotalPeriodo * de.Dtipocambio end),0),2) as Equilibrio
					from FPEEstimacion ee
						inner join FPDEstimacion de
							on ee.FPEEid = de.FPEEid
						inner join FPEPlantilla ep
							on ep.FPEPid = de.FPEPid
						inner join FPActividadD ad
							on ad.FPAEid = de.FPAEid
							and ad.FPADEquilibrio = 1
						inner join PCECatalogo ec
							on ec.PCEcatid = ad.PCEcatid
						inner join PCDCatalogo dc
							on dc.PCEcatid = ec.PCEcatid
							and dc.PCDvalor = <cf_dbfunction name="sPart" args="de.CFComplemento, ad.FPADPosicion , ad.FPADLogitud"> 
				where ee.FPEEestado in (2,3,4)
				  and ee.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPPid#">	
				group by dc.PCDcatid, dc.PCDdescripcion
			</cfquery>
		<cfelse>
			<cfif isdefined('Arguments.query')>
				<cfset rsQueryGeneral = Arguments.query>
			<cfelse>
				<cfset rsQueryGeneral = CreateQueryGeneral(Arguments.Conexion,Arguments.CPPid)>
			</cfif>
			<cfquery dbtype="query" name="NivelEquilibrio">	
				select 	PCDcatid, PCDdescripcion,
					Round(sum(IngresosEstimacion),2) TotalIngresos,
					Round(sum(EgresosEstimacion),2)  TotalEgresos,
					Round(sum(IngresosEstimacion),2) - sum(EgresosEstimacion) Equilibrio,
					Round(sum(IngresosEstimacion) - sum(IngresosPlan),2) Dif_TotalIngresos,
					Round(sum(EgresosEstimacion)  - sum(EgresosPlan),2) Dif_TotalEgresos
				from rsQueryGeneral
				group by PCDcatid, PCDdescripcion	
				order by PCDcatid, PCDdescripcion		
			</cfquery>
		</cfif>
		<cfreturn NivelEquilibrio>	
	</cffunction>
	<!---=================GetCentrosF: Obtiene el listado de todos los Centros Funcionales de Equilibrio=======--->
	<cffunction name="GetCentrosF"  access="public" returntype="query">
		<cfargument name="Conexion" type="string"  required="no">
		<cfargument name="CPPid" 	type="numeric" required="yes">
		<cfargument name="PCDcatid" type="numeric" required="yes">
		<cfargument name="FPO" 		type="boolean" required="yes" default="true">
		<cfargument name="query" 	type="query"   required="no">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>	
		<cfif Arguments.FPO>
			<cfquery datasource="#Arguments.Conexion#" name="CFS">	
				select ee.CFid, cf.CFdescripcion, ee.FPEEid,
					   Coalesce(sum(case ep.FPCCtipo when 'I' then de.DPDMontoTotalPeriodo * de.Dtipocambio  else 0 end),0) as TotalIngresos,
					   Coalesce(sum(case ep.FPCCtipo when 'G' then de.DPDMontoTotalPeriodo * de.Dtipocambio  else 0 end),0) as TotalEgresos,
					   Coalesce(sum(case ep.FPCCtipo when 'I' then de.DPDMontoTotalPeriodo * de.Dtipocambio  else - de.DPDMontoTotalPeriodo * de.Dtipocambio end),0) as Equilibrio,
					   ee.FPEEestado, tv.FPTVTipo
					from FPEEstimacion ee
						inner join FPDEstimacion de
							on ee.FPEEid = de.FPEEid
						inner join FPEPlantilla ep
							on ep.FPEPid = de.FPEPid
						inner join FPActividadD ad
							on ad.FPAEid = de.FPAEid
							and ad.FPADEquilibrio = 1
						inner join PCECatalogo ec
							on ec.PCEcatid = ad.PCEcatid
						inner join PCDCatalogo dc
							on dc.PCEcatid = ec.PCEcatid
							and dc.PCDvalor = <cf_dbfunction name="sPart" args="de.CFComplemento, ad.FPADPosicion , ad.FPADLogitud"> 
						inner join CFuncional cf
							on cf.CFid = ee.CFid
						inner join TipoVariacionPres tv 
							on tv.FPTVid = ee.FPTVid
					where ee.FPEEestado in (2, 3, 4)
					  and ee.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPPid#">
					  and dc.PCDcatid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCDcatid#">
					  group by ee.FPEEid, ee.CFid, cf.CFdescripcion, ee.FPEEestado, tv.FPTVTipo
					  order by CFid, CFdescripcion, FPEEestado, FPTVTipo
			</cfquery>
		<cfelse>
			<cfif isdefined('Arguments.query')>
				<cfset rsQueryGeneral = Arguments.query>
			<cfelse>
				<cfset rsQueryGeneral = CreateQueryGeneral(Arguments.Conexion,Arguments.CPPid)>
			</cfif>
			<cfquery dbtype="query" name="CFS">	
				select CFid, CFdescripcion, FPEEid,FPEEestado,FPTVTipo,
					sum(IngresosEstimacion) TotalIngresos,
					sum(EgresosEstimacion)  TotalEgresos,
					sum(IngresosEstimacion) - sum(EgresosEstimacion) Equilibrio,
					sum(IngresosEstimacion) - sum(IngresosPlan) Dif_TotalIngresos,
					sum(EgresosEstimacion)  - sum(EgresosPlan) Dif_TotalEgresos
				from rsQueryGeneral
				where PCDcatid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCDcatid#">
				group by FPEEid, CFid, CFdescripcion,FPEEestado,FPTVTipo
				order by CFid, CFdescripcion, FPEEestado, FPTVTipo
			</cfquery>
		</cfif>
		<cfreturn CFS>
	</cffunction>
	<!---=================GetActividad: Obtiene el listado de todas las Actividades de Equilibrio=======--->
	<cffunction name="GetActividad"  access="public" returntype="query">
		<cfargument name="Conexion" type="string"  required="no">
		<cfargument name="CPPid" 	type="numeric" required="yes">
		<cfargument name="PCDcatid" type="numeric" required="yes">
		<cfargument name="CFid" 	type="numeric" required="yes">
		<cfargument name="FPO" 		type="boolean" required="yes" default="true">
		<cfargument name="query" 	type="query"   required="no">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>	
		
		<cfif Arguments.FPO>
			<cfquery datasource="#Arguments.Conexion#" name="Actividad">	
				select ae.FPAEid, ae.FPAEDescripcion,
					  Coalesce(sum(case ep.FPCCtipo when 'I' then de.DPDMontoTotalPeriodo * de.Dtipocambio  else 0 end),0) as TotalIngresos,
					  Coalesce(sum(case ep.FPCCtipo when 'G' then de.DPDMontoTotalPeriodo * de.Dtipocambio  else 0 end),0) as TotalEgresos,
					  Coalesce(sum(case ep.FPCCtipo when 'I' then de.DPDMontoTotalPeriodo * de.Dtipocambio  else - de.DPDMontoTotalPeriodo * de.Dtipocambio end),0) as Equilibrio
					from FPEEstimacion ee
						inner join FPDEstimacion de
							on ee.FPEEid = de.FPEEid
						inner join FPEPlantilla ep
							on ep.FPEPid = de.FPEPid
						inner join FPActividadE ae
							on ae.FPAEid = de.FPAEid
						inner join FPActividadD ad
							on ad.FPAEid = ae.FPAEid
							and ad.FPADEquilibrio = 1
						inner join PCECatalogo ec
							on ec.PCEcatid = ad.PCEcatid
						inner join PCDCatalogo dc
							on dc.PCEcatid = ec.PCEcatid
							and dc.PCDvalor = <cf_dbfunction name="sPart" args="de.CFComplemento, ad.FPADPosicion , ad.FPADLogitud"> 
						inner join CFuncional cf
							on cf.CFid = ee.CFid
				where ee.FPEEestado in (2, 3, 4)
				  and ee.CPPid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPPid#">
				  and dc.PCDcatid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCDcatid#">
				  and ee.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#">
				  group by ae.FPAEid, ae.FPAEDescripcion
			</cfquery>
		<cfelse>
			<cfif isdefined('Arguments.query')>
				<cfset rsQueryGeneral = Arguments.query>
			<cfelse>
				<cfset rsQueryGeneral = CreateQueryGeneral(Arguments.Conexion,Arguments.CPPid)>
			</cfif>
			<cfquery dbtype="query" name="Actividad">	
				select FPAEid, FPAEDescripcion,
					sum(IngresosEstimacion) TotalIngresos,
					sum(EgresosEstimacion)  TotalEgresos,
					sum(IngresosEstimacion) - sum(EgresosEstimacion) Equilibrio,
					sum(IngresosEstimacion) - sum(IngresosPlan) Dif_TotalIngresos,
					sum(EgresosEstimacion)  - sum(EgresosPlan) Dif_TotalEgresos
				from rsQueryGeneral
				where PCDcatid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCDcatid#">
				  and CFid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#">
				group by FPAEid, FPAEDescripcion
				order by FPAEid, FPAEDescripcion
			</cfquery>
		</cfif>
		<cfreturn Actividad>
	</cffunction>
<!---=================GetTotales: Obtiene una sumatoria de todas las Actividades de Equilibrio=======--->
	<cffunction name="GetTotales"  access="public" returntype="query">
		<cfargument name="Conexion" type="string"  required="no">
		<cfargument name="CPPid" 	type="numeric" required="yes">
		<cfargument name="FPO" 		type="boolean" required="yes" default="true">
		<cfargument name="query" 	type="query"   required="no">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>	
		
		<cfif Arguments.FPO>
		<cfquery datasource="#Arguments.Conexion#" name="Totales">	
			select Round(Coalesce(sum(case c.FPCCtipo when 'I' then b.DPDMontoTotalPeriodo * b.Dtipocambio  else 0 end),0),2) TotalIngresos,
				   Round(Coalesce(sum(case c.FPCCtipo when 'G' then b.DPDMontoTotalPeriodo * b.Dtipocambio  else 0 end),0),2) TotalEgresos,
				   Round(Coalesce(sum(case c.FPCCtipo when 'I' then b.DPDMontoTotalPeriodo * b.Dtipocambio  else - b.DPDMontoTotalPeriodo * b.Dtipocambio end),0),2) Equilibrio
				from FPEEstimacion a
					inner join FPDEstimacion b
						on a.FPEEid = b.FPEEid
					inner join FPEPlantilla c
						on c.FPEPid = b.FPEPid
			where a.FPEEestado in (2, 3, 4)
			  and a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPPid#">
		</cfquery>
		<cfelse>
			<cfif isdefined('Arguments.query')>
				<cfset rsQueryGeneral = Arguments.query>
			<cfelse>
				<cfset rsQueryGeneral = CreateQueryGeneral(Arguments.Conexion,Arguments.CPPid)>
			</cfif>
			<cfquery dbtype="query" name="Totales">	
				select Round(sum(IngresosEstimacion),2) TotalIngresos,
					   Round(sum(EgresosEstimacion),2)  TotalEgresos,
					   Round(sum(IngresosEstimacion) - sum(EgresosEstimacion),2) Equilibrio,
					   Round(sum(IngresosEstimacion) - sum(IngresosPlan),2) Dif_TotalIngresos,
					   Round(sum(EgresosEstimacion)  - sum(EgresosPlan),2) Dif_TotalEgresos
				from rsQueryGeneral
			</cfquery>
		</cfif>
		<cfreturn Totales>
	</cffunction>
<!---=================CambioEstadoMasivo: Cambia todas las estimacion que cumplan con un filtro a un estado espeficico=======--->
	<cffunction name="CambioEstadoMasivo"  access="public">
		<cfargument name="Conexion" 	type="string"  required="no">
		<cfargument name="FPEEestado" 	type="numeric" required="no" default="3">
		<cfargument name="Filtro" 		type="string"  required="yes">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>	
		
		<cfquery datasource="#Arguments.Conexion#" name="Totales">	
			update FPEEstimacion
				set FPEEestado = #Arguments.FPEEestado#
			<cfif isdefined('Arguments.Filtro')>
				where #Arguments.Filtro#
			</cfif>
		</cfquery>
	</cffunction>
	
<!---=================rsAltaVersion: Inserta la version de formulación presupuestal=======--->
	<cffunction name="AltaVersion"  	access="public" returntype="numeric">
		<cfargument name="CVtipo" 			type="string" 	required="yes">
		<cfargument name="CVdescripcion" 	type="string" 	required="yes">
		<cfargument name="CPPid" 			type="numeric" 	required="yes">
		<cfargument name="CVestado" 		type="numeric"  required="yes">
		<cfargument name="CVaprobada" 		type="numeric"  required="no" default="0">
		<cfargument name="Ecodigo" 			type="numeric"  required="no">
		<cfargument name="Conexion" 		type="string"  	required="no">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>	
		
		<cfquery name="rsAltaVersion" datasource="#session.dsn#">
			insert into CVersion(Ecodigo, CVtipo, CVdescripcion, CPPid, CVestado, CVaprobada)
			values(	<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#Arguments.CVtipo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.CVdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.CPPid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.CVestado#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.CVaprobada#">
			)<cf_dbidentity1>
		</cfquery>
		<cf_dbidentity2 name="rsAltaVersion">
		<cfreturn rsAltaVersion.identity>
	</cffunction>
	<!---=====Genera un solo query para todas las consultas--->
	<cffunction name="CreateQueryGeneral"  access="public" returntype="query">
		<cfargument name="Conexion" 	type="string"  required="no">
		<cfargument name="CPPid" 		type="numeric" required="yes">
		<cfargument name="FPEEestado" 	type="string"  required="no" default="2,3,4">
		<cfargument name="Table" 		type="any" 	   required="no">
		<cfargument name="DropTable" 	type="boolean" required="no" default="true">
		<cfargument name="CFids" 		type="string" required="no">

		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		
		<cfif not isdefined('Arguments.Table')>
			<cf_dbtemp name="temp_EquilibrioFP_v1" returnvariable="temp" datasource="#Arguments.Conexion#">
				<cf_dbtempcol name="PCDcatid"   		type="numeric"	  		mandatory="yes">
				<cf_dbtempcol name="PCDdescripcion"   	type="varchar(255)"  	mandatory="yes">
				<cf_dbtempcol name="IngresosEstimacion" type="money"  			mandatory="yes">
				<cf_dbtempcol name="EgresosEstimacion"  type="money"  			mandatory="yes">
				<cf_dbtempcol name="IngresosPlan"   	type="money"  			mandatory="yes" default="0.00">
				<cf_dbtempcol name="EgresosPlan"   		type="money"  			mandatory="yes" default="0.00">
				<cf_dbtempcol name="FPCCtipo"   		type="char(1)"  		mandatory="yes">
				<cf_dbtempcol name="CFid"   			type="numeric"  		mandatory="yes">
				<cf_dbtempcol name="CFdescripcion"   	type="varchar(255)"  	mandatory="yes">
				<cf_dbtempcol name="FPEEid"   			type="numeric"  		mandatory="yes">
				<cf_dbtempcol name="FPEEestado"   		type="numeric"  		mandatory="yes">
				<cf_dbtempcol name="FPAEid"   			type="numeric"  		mandatory="yes">
				<cf_dbtempcol name="FPAEDescripcion"   	type="varchar(255)"  	mandatory="yes">
				<cf_dbtempcol name="CPcuenta"   		type="numeric"  		mandatory="no">
	
				<cf_dbtempcol name="FPEPid"   			type="numeric"  		mandatory="no">
				<cf_dbtempcol name="FPDElinea"   		type="numeric"  		mandatory="no">
				<cf_dbtempcol name="FPDEid"   			type="numeric"  		mandatory="no">
				
				<cf_dbtempcol name="Ocodigo"   			type="numeric"  		mandatory="no">
				<cf_dbtempcol name="PCGDid"   			type="numeric"  		mandatory="no">
				<cf_dbtempcol name="FPTVTipo"   		type="numeric"  		mandatory="no">
				<cf_dbtempcol name="PCGcuenta"   		type="numeric"  		mandatory="yes">
			</cf_dbtemp>
		<cfelse>
			<cfset temp = Arguments.Table>
		</cfif>
		
		<!---Las Lineas que estan el Plan de Compras y que estan o no estan en la estimacion Actual--->
		<cfquery datasource="#Arguments.Conexion#">	
			insert into #temp# (PCDcatid,PCDdescripcion,Ocodigo,PCGDid,IngresosEstimacion,EgresosEstimacion,IngresosPlan,EgresosPlan,FPCCtipo, CFid,CFdescripcion,FPEEid,FPEEestado,FPAEid,FPAEDescripcion,CPcuenta,FPEPid,FPDElinea,FPTVTipo,PCGcuenta,FPDEid)
			select f.PCDcatid, f.PCDdescripcion, cf.Ocodigo, g.PCGDid,
				   Coalesce(case c.FPCCtipo when 'I' then <cf_dbfunction name="to_float" args="b.DPDMontoTotalPeriodo * b.Dtipocambio" dec="4">  else 0 end,0) IngresosEstimacion,
				   Coalesce(case c.FPCCtipo when 'G' then <cf_dbfunction name="to_float" args="b.DPDMontoTotalPeriodo * b.Dtipocambio" dec="4">  else 0 end,0) EgresosEstimacion,
				   Coalesce(case c.FPCCtipo 
				   				when 'I' then 
										case when g.PCGDxPlanCompras = 0 then 
											 (select sum(m.CPCpresupuestado)
													+ sum(m.CPCmodificado)
													+ sum(m.CPCmodificacion_Excesos)
													+ sum(m.CPCvariacion)
													+ sum(m.CPCtrasladado)
													+ sum(m.CPCtrasladadoE)
											   from CPresupuestoControl m 
											  where m.Ecodigo  = EPC.Ecodigo
												and m.CPPid    = EPC.CPPid
												and m.CPcuenta = ctas.CPcuenta
												and m.Ocodigo  = cf.Ocodigo
											 )
										 else g.PCGDautorizado end
								else 0 end,0) IngresosPlan,
				   Coalesce(case c.FPCCtipo 
				   				when 'G' then 
										case when g.PCGDxPlanCompras = 0 then 
											 (select sum(m.CPCpresupuestado)
													+ sum(m.CPCmodificado)
													+ sum(m.CPCmodificacion_Excesos)
													+ sum(m.CPCvariacion)
													+ sum(m.CPCtrasladado)	
													+ sum(m.CPCtrasladadoE)
											   from CPresupuestoControl m 
											  where m.Ecodigo  = EPC.Ecodigo
												and m.CPPid    = EPC.CPPid
												and m.CPcuenta = ctas.CPcuenta
												and m.Ocodigo  = cf.Ocodigo
											 )
										else g.PCGDautorizado  end
								else 0 end,0) EgresosPlan,
				   c.FPCCtipo,g.CFid,cf.CFdescripcion, Coalesce(EE.FPEEid,-1), Coalesce(EE.FPEEestado,6),
				   FPAE.FPAEid,FPAE.FPAEDescripcion,ctas.CPcuenta,Coalesce(b.FPEPid,-1),Coalesce(b.FPDElinea,-1),tv.FPTVTipo,ctas.PCGcuenta, b.FPDEid
				from PCGDplanCompras g
					inner join PCGplanCompras EPC
						inner join CPresupuestoPeriodo cpp
							on cpp.CPPid = EPC.CPPid
						on EPC.PCGEid  = g.PCGEid 
					inner join PCGcuentas ctas
						on ctas.PCGcuenta = g.PCGcuenta
					inner join CFuncional cf
							on cf.CFid = g.CFid
					inner join FPActividadD d
						on d.FPAEid = g.FPAEid
					   and d.FPADEquilibrio = 1
					inner join FPActividadE FPAE
						on FPAE.FPAEid = d.FPAEid
					inner join FPEPlantilla c
						on c.FPEPid = g.FPEPid
					inner join PCECatalogo e
						on e.PCEcatid = d.PCEcatid
					inner join PCDCatalogo f
						on f.PCEcatid = e.PCEcatid
					   and f.PCDvalor = <cf_dbfunction name="sPart" args="g.CFComplemento, d.FPADPosicion , d.FPADLogitud"> 
                       and (f.Ecodigo is null or f.Ecodigo = g.Ecodigo)
					left outer join FPDEstimacion b
						inner join FPEEstimacion EE
							left outer join TipoVariacionPres tv 
								on tv.FPTVid = EE.FPTVid
							on EE.FPEEid = b.FPEEid
						on b.PCGDid = g.PCGDid
					   and EE.FPEEestado in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEEestado#" list="yes">)
			where EPC.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPPid#">
              and e.CEcodigo = #session.CEcodigo#
              <cfif isdefined('Arguments.CFids') and len(trim(Arguments.CFids))>
             	and g.CFid in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFids#" list="yes">)
              </cfif>
		</cfquery>
		<!---Lineas de la estimacion Actual que no estan en el Plan de compras(Lineas Nuevas)--->
		<cfquery datasource="#Arguments.Conexion#">	
			insert into #temp# (PCDcatid,PCDdescripcion,Ocodigo,IngresosEstimacion,EgresosEstimacion,FPCCtipo,CFid,CFdescripcion,FPEEid,FPEEestado,FPAEid,FPAEDescripcion,CPcuenta,FPEPid,FPDElinea,FPTVTipo,PCGcuenta,FPDEid)
			select f.PCDcatid, f.PCDdescripcion, cf.Ocodigo,
				   Coalesce(case c.FPCCtipo when 'I' then b.DPDMontoTotalPeriodo * b.Dtipocambio  else 0 end,0),
				   Coalesce(case c.FPCCtipo when 'G' then b.DPDMontoTotalPeriodo * b.Dtipocambio  else 0 end,0),
				   c.FPCCtipo,a.CFid,cf.CFdescripcion, a.FPEEid, a.FPEEestado,
				   FPAE.FPAEid,FPAE.FPAEDescripcion, ctas.CPcuenta,b.FPEPid,b.FPDElinea,tv.FPTVTipo, ctas.PCGcuenta, b.FPDEid
				from FPEEstimacion a
					inner join FPDEstimacion b
						on a.FPEEid = b.FPEEid
					inner join FPEPlantilla c
						on c.FPEPid = b.FPEPid
					left outer join PCGcuentas ctas
						on ctas.PCGcuenta = b.PCGcuenta
					inner join FPActividadD d
						on d.FPAEid = b.FPAEid
						and d.FPADEquilibrio = 1
					inner join FPActividadE FPAE
						on FPAE.FPAEid = d.FPAEid
					inner join PCECatalogo e
						on e.PCEcatid = d.PCEcatid
					inner join PCDCatalogo f
						on f.PCEcatid = e.PCEcatid
						and f.PCDvalor = <cf_dbfunction name="sPart" args="b.CFComplemento, d.FPADPosicion , d.FPADLogitud"> 
                        and (f.Ecodigo is null or f.Ecodigo = a.Ecodigo)
					inner join CFuncional cf
						on cf.CFid = a.CFid
					left outer join TipoVariacionPres tv 
						on tv.FPTVid = a.FPTVid
			where FPEEestado in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEEestado#" list="yes">)
			  and a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPPid#">	
			  and PCGDid is null
              and e.CEcodigo = #session.CEcodigo#
              <cfif isdefined('Arguments.CFids') and len(trim(Arguments.CFids))>
             	and a.CFid in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFids#" list="yes">)
              </cfif>
		 </cfquery>
		 <cfquery datasource="#Arguments.Conexion#" name="rsConsulta">	
		 	select * from #temp#
		 </cfquery>
		 
		 <cfif Arguments.DropTable>
			 <cfquery datasource="#Arguments.Conexion#">	
				drop table #temp#
			 </cfquery>
		 </cfif>
		 <cfreturn rsConsulta>
	</cffunction>
	
	<!---=================fnAprobarI: Aprueba una variacion/estimacion de equilibrio a Aprobacion Interna =======--->
	<cffunction name="fnAprobarI"  			access="public">
		<cfargument name="CPPid" 			type="numeric" 	required="yes">
		<cfargument name="Ecodigo" 			type="numeric"  required="no">
		<cfargument name="Conexion" 		type="string"  	required="no">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>	

		<cfquery datasource="#Arguments.Conexion#" name="rsDetalles">
			select de.DPDEdescripcion, de.PCGDid, 
				<cf_dbfunction name="to_float"	args="coalesce(de.DPDMontoTotalPeriodo,0) * coalesce(de.Dtipocambio,1)" dec="4"> - coalesce(pcd.PCGDautorizado,0) as diferienciaMonto, 
				coalesce(pcd.PCGDautorizado,0) - coalesce(pcd.PCGDreservado,0) 
					- coalesce(pcd.PCGDcomprometido,0) - coalesce(pcd.PCGDejecutado,0) - coalesce(pcd.PCGDpendiente,0) as disponibleMonto,
				coalesce(de.DPDEcantidadPeriodo,0) - coalesce(pcd.PCGDcantidad,0) as diferienciaCantidad,
				coalesce(pcd.PCGDcantidad,0) - coalesce(pcd.PCGDcantidadCompras,0) 
					- coalesce(pcd.PCGDcantidadConsumo,0) - coalesce(pcd.PCGDcantidadPendiente,0)  as disponibleCantidad
			from FPEEstimacion ee
				inner join FPDEstimacion de
					on de.FPEEid = ee.FPEEid
				inner join PCGDplanCompras pcd
					on pcd.PCGDid = de.PCGDid
				inner join FPEPlantilla ep
					on ep.FPEPid = de.FPEPid
				inner join TipoVariacionPres tv
					on tv.FPTVid = ee.FPTVid
				where ee.Ecodigo = #Arguments.Ecodigo# 
				  and ee.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPPid#">
				  and ee.FPEEestado = 2
				  and tv.FPTVTipo <> 1 and tv.FPTVTipo <> 4 <!--- Que no sea de tipo no modifica monto(Individual y grupal) --->
		</cfquery>
		<cfloop query="rsDetalles">
			<cfset monto = "0">
			<cfset cantidad = "0">
			<cfif rsDetalles.diferienciaMonto lt 0 and rsDetalles.disponibleMonto LT ABS(rsDetalles.diferienciaMonto)>
				<cfthrow message="'#rsDetalles.DPDEdescripcion#', El monto para el consumo negativo autorizado pero pendiente de aplicar(#ABS(rsDetalles.diferienciaMonto)#) es mayor al disponible actual(#rsDetalles.disponibleMonto#)">
			<cfelseif rsDetalles.diferienciaMonto lt 0>
				<cfset monto = iif(rsDetalles.diferienciaMonto lt 0,"#abs(rsDetalles.diferienciaMonto)#","0")>
			</cfif>
			<cfif rsDetalles.diferienciaCantidad lt 0 and rsDetalles.disponibleCantidad LT ABS(rsDetalles.diferienciaCantidad)>
				<cfthrow message="#rsDetalles.DPDEdescripcion#, La cantidad para el consumo negativo autorizado pero pendiente de aplicar es mayor al disponible actual. Disponible actual: #rsDetalles.disponibleCantidad#">
			<cfelseif rsDetalles.diferienciaCantidad lt 0>
				<cfset cantidad = iif(rsDetalles.diferienciaCantidad lt 0,"#abs(rsDetalles.diferienciaCantidad)#","0")>
			</cfif>
			<cfquery datasource="#Arguments.Conexion#">
					update PCGDplanCompras set 
					PCGDpendiente = #monto#,
					PCGDcantidadPendiente = #cantidad#
					where PCGDid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalles.PCGDid#">
			</cfquery>
		</cfloop>
		<cfset CambioEstadoMasivo(Arguments.Conexion,3,"CPPid = #Arguments.CPPid# and FPEEestado = 2")>
	</cffunction>
</cfcomponent>
