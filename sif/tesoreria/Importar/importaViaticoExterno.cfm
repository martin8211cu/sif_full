<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp> 

	<cfquery  name="rsImportador" datasource="#session.dsn#">
	  select * from #table_name# 
	</cfquery>


<cfset Cons = '1'>

<cfloop query="rsImportador">
<!---Validar archivo de texto--->
<!--- Existencia de lineas blancas en el archivo de texto--->
	<cfif len(trim(rsImportador.pais)) 	 			 eq 0 
		or len(trim(rsImportador.clasificacion)) 	 eq 0 
		or len(trim(rsImportador.GECconcepto)) 	 eq 0
		or len(trim(rsImportador.Miso4217)) 	 	 eq 0 
		or len(trim(rsImportador.Monto)) 			 eq 0 
		or len(trim(rsImportador.plantilla)) 		 eq 0
		or len(trim(rsImportador.FechaIni)) 		 eq 0
		or len(trim(rsImportador.FechaFin)) 		 eq 0
		or len(trim(rsImportador.HoraIni)) 		 	 eq 0
		or len(trim(rsImportador.HoraFin)) 		 	 eq 0>
		
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
			and a.GECVcodigo = <cfqueryparam cfsqltype="cf_sql_varchar"   value="#rsImportador.clasificacion#">
	</cfquery>	
	
		<cfif dataViatico.recordcount eq 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error. (La Clasificación del Viático #rsImportador.clasificacion#) No esta definida!')
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
	

	<cfset Cons = '#Cons#'>
	<cfset codigo = '#rsImportador.plantilla##Cons#'>
	
	<cfquery name="rsErrores" datasource="#session.DSN#">
		select count(1) as cantidad
		from #errores#
	</cfquery>
	
	<cfif rsErrores.cantidad eq 0>
		<cfquery datasource="#session.dsn#" name="rs">
			select count(1) as cantidad from GEPlantillaViaticos where GEPVcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#codigo#"> and Ecodigo = #session.Ecodigo#
		</cfquery>
		
		<cfset LvarHoraIni = #rsImportador.HoraIni#>
		<cfset LvarHoraFin = #rsImportador.HoraFin#>
		
		<cfif isdefined ('rsImportador.plantilla') and #rsImportador.plantilla# eq 'FA'>
			<cfset desc = 'Funcionario A'>
		<cfelseif #rsImportador.plantilla# eq 'FB'>
			<cfset desc = 'Funcionario B'>
		<cfelseif #rsImportador.plantilla# eq 'FC'>
			<cfset desc = 'Funcionario C'>
		<cfelseif #rsImportador.plantilla# eq 'DFA'>
			<cfset desc = 'Desayuno Funcionario A'>
		<cfelseif #rsImportador.plantilla# eq 'DFB'>
			<cfset desc = 'Desayuno Funcionario B'>
		<cfelseif #rsImportador.plantilla# eq 'DFC'>
			<cfset desc = 'Desayuno Funcionario  C'>
		<cfelseif #rsImportador.plantilla# eq 'AFA'>
			<cfset desc = 'Almuerzo Funcionario A'>
		<cfelseif #rsImportador.plantilla# eq 'AFB'>
			<cfset desc = 'Almuerzo Funcionario B'>
		<cfelseif #rsImportador.plantilla# eq 'AFC'>
			<cfset desc = 'Almuerzo Funcionario  C'>
		<cfelseif #rsImportador.plantilla# eq 'CFA'>
			<cfset desc = 'Cena Funcionario A'>
		<cfelseif #rsImportador.plantilla# eq 'CFB'>
			<cfset desc = 'Cena Funcionario B'>
		<cfelseif #rsImportador.plantilla# eq 'CFC'>
			<cfset desc = 'Cena Funcionario  C'>
		<cfelseif #rsImportador.plantilla# eq 'CFA'>
			<cfset desc = 'Cena Funcionario A'>
		<cfelseif #rsImportador.plantilla# eq 'CFB'>
			<cfset desc = 'Cena Funcionario B'>
		<cfelseif #rsImportador.plantilla# eq 'CFC'>
			<cfset desc = 'Cena Funcionario  C'>
		<cfelseif #rsImportador.plantilla# eq 'HFA'>
			<cfset desc = 'Hotel Funcionario A'>
		<cfelseif #rsImportador.plantilla# eq 'HFB'>
			<cfset desc = 'Hotel Funcionario B'>
		<cfelseif #rsImportador.plantilla# eq 'HFC'>
			<cfset desc = 'Hotel Funcionario  C'>
		<cfelseif #rsImportador.plantilla# eq 'IFA'>
			<cfset desc = 'Imprevisto Funcionario A'>
		<cfelseif #rsImportador.plantilla# eq 'IFB'>
			<cfset desc = 'Imprevisto Funcionario B'>
		<cfelseif #rsImportador.plantilla# eq 'IFC'>
			<cfset desc = 'Imprevisto Funcionario  C'>
		</cfif>
		
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
					<cfqueryparam cfsqltype="cf_sql_char" 	    value="#codigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" 	    value="2">,
					<cfqueryparam cfsqltype="cf_sql_varchar"   value="#desc#">, 
						'0',
					<cfqueryparam cfsqltype="cf_sql_money"     value="#rsImportador.Monto#">,
					<cfqueryparam cfsqltype="cf_sql_integer"   value="#LvarHoraIni#">,
					<cfqueryparam cfsqltype="cf_sql_integer"   value="#LvarHoraFin#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsImportador.FechaIni#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsImportador.FechaFin#">,
					<cfqueryparam cfsqltype="cf_sql_numeric"   value="#session.Usucodigo#">
				)
				<cf_dbidentity1>
			 </cfquery>
		<cf_dbidentity2 name="rsInsert">
	<cfset Cons = '#Cons#' + 1>
		<cfelse>
				<cfquery datasource="#session.dsn#">
					update GEPlantillaViaticos 
						set 
						GEPVdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar"   value="#desc#">,
						GEPVaplicaTodos = <cfif isdefined("rsImportador.GEPVaplicaTodos") and #rsImportador.GEPVaplicaTodos# eq 'S'>'1'<cfelse>'0'</cfif>,
						GEPVmonto	 = <cfqueryparam cfsqltype="cf_sql_money"     value="#rsImportador.Monto#" >,
						GEPVhoraini  = <cfqueryparam cfsqltype="cf_sql_integer"   value="#LvarHoraIni#">,
						GEPVhorafin  = <cfqueryparam cfsqltype="cf_sql_integer"   value="#LvarHoraFin#">,
						GEPVfechaini = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsImportador.FechaIni#">,
						GEPVfechafin = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsImportador.FechaFin#">   
					where 
					Ecodigo = #session.Ecodigo#
					and GEPVcodigo = <cfqueryparam cfsqltype="cf_sql_varchar"   value="#codigo#">
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
