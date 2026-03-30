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
		and ge.GECconcepto = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#rsImportador.GECconcepto#">
	</cfquery>	
	
		<cfif data.recordcount eq 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error. El Concepto de Gasto (#rsImportador.GECconcepto#) No esta definido!')
			</cfquery>
		</cfif>


	
	<cfquery name="dataViatico" datasource="#session.DSN#">
		select a.GECVid
				from GEClasificacionViaticos a  
				where a.Ecodigo=#session.Ecodigo#
			and a.GECVcodigo = <cf_jdbcquery_param  cfsqltype="cf_sql_varchar"   value="#rsImportador.GECVcodigo#">
	</cfquery>
	<cfif dataViatico.recordcount eq 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error. La clasificacion Viatico (#rsImportador.GECVcodigo#) No esta definida!')
			</cfquery>
	</cfif>

	<cfquery name="rsMoneda" datasource="#session.DSN#">
		select Mcodigo
		from Monedas m
		where Ecodigo=#session.Ecodigo#
		and Miso4217 =  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#rsImportador.Miso4217#">
	</cfquery>	
	<cfif rsMoneda.recordcount eq 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error. La moneda (#rsImportador.Miso4217#) No esta definida!')
			</cfquery>
	</cfif>
	
	<cfquery name="rsErrores" datasource="#session.DSN#">
		select count(1) as cantidad
		from #errores#
	</cfquery>
	
	<cfif rsErrores.cantidad eq 0>
			<cfquery datasource="#session.dsn#" name="rs">
				select count(1) as cantidad 
				from GEPlantillaViaticos 
				where GEPVcodigo=<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rsImportador.GEPVcodigo#"> 
					 and Ecodigo = #session.Ecodigo#
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
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#dataViatico.GECVid#">,		
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#data.GECid#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#rsMoneda.Mcodigo#"> ,
							<cf_jdbcquery_param cfsqltype="cf_sql_char" 	    value="#rsImportador.GEPVcodigo#">,
							<cfif isdefined("rsImportador.GEPVtipoviatico") and (#rsImportador.GEPVtipoviatico# EQ "I" or  #rsImportador.GEPVtipoviatico# EQ "i")>
								'1',
							<cfelse>
								'2',
							</cfif>
							<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#rsImportador.GEPVdescripcion#">, 
							<cfif #rsImportador.GEPVaplicaTodos# EQ "S">
								'1',
							<cfelse>
								'0',
							</cfif>
							<cf_jdbcquery_param cfsqltype="cf_sql_money"     value="#rsImportador.GEPVmonto#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#LvarHoraIni#" >,
							<cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#LvarHoraFin#" >,
							<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsImportador.GEPVfechaini#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsImportador.GEPVfechafin#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#session.Usucodigo#">
						)
						<cf_dbidentity1>
				 </cfquery>
				<cf_dbidentity2 name="rsInsert">
			<cfelse>
				<cfquery datasource="#session.dsn#">
					update GEPlantillaViaticos 
						set 
						GEPVdescripcion = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#rsImportador.GEPVdescripcion#">,
						GEPVaplicaTodos = <cfif isdefined("rsImportador.GEPVaplicaTodos") and #rsImportador.GEPVaplicaTodos# eq 'S'>'1'<cfelse>'0'</cfif>,
						GEPVmonto	 = <cf_jdbcquery_param cfsqltype="cf_sql_money"     value="#rsImportador.GEPVmonto#" >,
						GEPVhoraini  = <cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#LvarHoraIni#" >,
						GEPVhorafin  = <cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#LvarHoraFin#" >,
						GEPVfechaini = <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsImportador.GEPVfechaini#">,
						GEPVtipoviatico = <cfif isdefined("rsImportador.GEPVtipoviatico") and (#rsImportador.GEPVtipoviatico# EQ "I" or  #rsImportador.GEPVtipoviatico# EQ "i")>
								'1',
							<cfelse>
								'2',
							</cfif>
						GEPVfechafin = <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsImportador.GEPVfechafin#"> 
					where 
					Ecodigo = #session.Ecodigo#
					and GEPVcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_char" 	    value="#rsImportador.GEPVcodigo#">
				</cfquery>
			</cfif>
	</cfif>
 </cfloop>
	<cfquery name="rsErrores2" datasource="#session.DSN#">
		select count(1) as cantidad
		from #errores#
	</cfquery>

	<cfif rsErrores2.cantidad gt 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #errores#
		</cfquery>
		<cfreturn>		
	</cfif>
		
