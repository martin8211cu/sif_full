<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp> 

	<cfquery  name="rsImportador" datasource="#session.dsn#">
	  select * from #table_name# 
	</cfquery>

<cfloop query="rsImportador">
<!---Validar archivo de texto--->
<!--- Existencia de lineas blancas en el archivo de texto--->
	<cfif len(trim(rsImportador.GEPVcodigo)) 	 	 eq 0 or len(trim(rsImportador.GEPVdescripcion)) 	eq 0 or len(trim(rsImportador.GECVcodigo )) 	   eq 0 
		or len(trim(rsImportador.Miso4217)) 		 eq 0 or len(trim(rsImportador.GEPVmonto))      	eq 0 or len(trim(rsImportador.GEPVhoraini)) 		eq 0 
		or len(trim(rsImportador.GEPVfechaini)) 	 eq 0 or len(trim(rsImportador.GEPVfechafin)) 		eq 0 or len(trim(rsImportador.GEPVaplicaTodos)) eq 0
		or len(trim(rsImportador.GEPVhorafin)) 	 eq 0 or len(trim(rsImportador.GEPVtipoviatico)) 	eq 0 or len(trim(rsImportador.GECconcepto)) 		eq 0>
		
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error! Existen Columnas en el archivo que estan en blanco')
		</cfquery>
	</cfif>
	
	<!---Concepto de Gasto --->
	<cfquery name="data" datasource="#session.DSN#">
		select ge.GECid
		from Conceptos con 
			inner join GEconceptoGasto ge
				on ge.Cid = con.Cid
		where con.Ecodigo=#session.Ecodigo#
		and ge.GECconcepto = <cfqueryparam cfsqltype="cf_sql_varchar"   value="#rsImportador.GECconcepto#">
	</cfquery>	

		<cfif data.recordcount eq 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error. El Concepto de Gasto (#rsImportador.GECconcepto#) No esta definido!')
			</cfquery>
		</cfif>
		
	<!---Clasificación del viático --->
	<cfquery name="dataViatico" datasource="#session.DSN#">
		select a.GECVid
		from GEClasificacionViaticos a  
			where a.Ecodigo=#session.Ecodigo#
			and a.GECVcodigo = <cfqueryparam cfsqltype="cf_sql_varchar"   value="#rsImportador.GECVcodigo#">
	</cfquery>	
	
		<cfif dataViatico.recordcount eq 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error. La Clasificación del Viático #rsImportador.GECVcodigo#) No esta definida!')
			</cfquery>
		</cfif>

	<!---MONEDAS --->
	<cfquery name="rsMoneda" datasource="#session.DSN#">
		select Mcodigo
		from Monedas m
		where Ecodigo=#session.Ecodigo#
		and Miso4217 =  <cfqueryparam cfsqltype="cf_sql_varchar"   value="#rsImportador.Miso4217#">
	</cfquery>		
	<!--- --->
	
	<cfquery name="rsErrores" datasource="#session.DSN#">
		select count(1) as cantidad
		from #errores#
	</cfquery>
	
	<cfif rsErrores.cantidad eq 0>
		<cfquery datasource="#session.dsn#" name="rs">
			select count(1) as cantidad from GEPlantillaViaticos where GEPVcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.GEPVcodigo#"> and Ecodigo = #session.Ecodigo#
		</cfquery>
		
		<cfset LvarHoraIni = #rsImportador.GEPVhoraini#>
		<cfset LvarHoraFin = #rsImportador.GEPVhorafin#>
		<cfif rs.cantidad eq 0>
			<cfquery datasource="#session.dsn#" name="rsInsert">
				insert into GEPlantillaViaticos 
					(
						Ecodigo,
						GECVid,
						GECid,
						Mcodigo,
						GEPVcodigo,
						GEPVtipoviatico,
						GEPVdescripcion,
						GEPVaplicaTodos,
						GEPVmonto,
						GEPVhoraini,
						GEPVhorafin,
						GEPVfechaini,
						GEPVfechafin,
						BMUsucodigo
					)
				values( 
					#session.Ecodigo#,
					<cfqueryparam cfsqltype="cf_sql_numeric"   value="#dataViatico.GECVid#">,		
					<cfqueryparam cfsqltype="cf_sql_numeric"   value="#data.GECid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric"   value="#rsMoneda.Mcodigo#"> ,
					<cfqueryparam cfsqltype="cf_sql_char" 	    value="#rsImportador.GEPVcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" 	    value="1">,
					<cfqueryparam cfsqltype="cf_sql_varchar"   value="#rsImportador.GEPVdescripcion#">, 
					<cfif #rsImportador.GEPVaplicaTodos# EQ "S">
						'1',
					<cfelse>
						'0',
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_money"     value="#rsImportador.GEPVmonto#">,
					<cfqueryparam cfsqltype="cf_sql_integer"   value="#LvarHoraIni#" >,
					<cfqueryparam cfsqltype="cf_sql_integer"   value="#LvarHoraFin#" >,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsImportador.GEPVfechaini#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsImportador.GEPVfechafin#">,
					<cfqueryparam cfsqltype="cf_sql_numeric"   value="#session.Usucodigo#">
				)
				<cf_dbidentity1>
			 </cfquery>
		<cf_dbidentity2 name="rsInsert">
		<cfelse>
				<cfquery datasource="#session.dsn#">
					update GEPlantillaViaticos 
						set 
						GEPVdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar"   value="#rsImportador.GEPVdescripcion#">,
						GEPVaplicaTodos = <cfif isdefined("rsImportador.GEPVaplicaTodos") and #rsImportador.GEPVaplicaTodos# eq 'S'>'1'<cfelse>'0'</cfif>,
						GEPVmonto	 = <cfqueryparam cfsqltype="cf_sql_money"     value="#rsImportador.GEPVmonto#" >,
						GEPVhoraini  = <cfqueryparam cfsqltype="cf_sql_integer"   value="#LvarHoraIni#" >,
						GEPVhorafin  = <cfqueryparam cfsqltype="cf_sql_integer"   value="#LvarHoraFin#" >,
						GEPVfechaini = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsImportador.GEPVfechaini#">,
						GEPVfechafin = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsImportador.GEPVfechafin#">   
					where 
					Ecodigo = #session.Ecodigo#
					and GEPVcodigo = <cfqueryparam cfsqltype="cf_sql_varchar"   value="#rsSQL.GEPVcodigo#">
				</cfquery>
			</cfif>
		</cfif>
</cfloop>	

	<cfquery name="rsErrores" datasource="#session.DSN#">
		select count(1) as cantidad
		from #errores#
	</cfquery>

	<cfif rsErrores.cantidad gt 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #errores#
		</cfquery>
		<cfreturn>		
	</cfif>
