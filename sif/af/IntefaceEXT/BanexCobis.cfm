<cfsetting requesttimeout="36000">
<!--- Se crea tabla para salida del proceso  --->
<cf_dbtemp name="Errores" returnvariable="Errores" datasource="#session.dsn#">
	<cf_dbtempcol name="orden"  type="smallint" mandatory="no">
	<cf_dbtempcol name="Resultado" type="char(250)" mandatory="no">
</cf_dbtemp>

<cftransaction>
	<!--- Busca el máximo asiento generado --->
	<cfquery name="TraeAsiento" datasource="#session.dsn#">
		select num_asiento = coalesce(max(Edocumento),1)
		from EContables
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Eperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EPERIODO#">
		and Emes     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EMES#">
	</cfquery>
	
	 <cfif TraeAsiento.recordCount eq 0>
		<cfquery name="insError" datasource="#session.dsn#">
			insert  into #Errores#  (orden,Resultado) 
			values (1,' No se pudo obtener el numero de asiento')
		</cfquery>
	</cfif> 
	<!--- se trae todos los documentos que para el perido y mes  indicados--->
	<cfquery name="TraeDatosE" datasource="#session.dsn#">
		select 
			a.IDcontable,
			a.Ecodigo, 
			a.Cconcepto, 
			a.Eperiodo, 
			a.Emes, 
			a.Edocumento, 
			a.Efecha, 
			a.Edescripcion
		from EContables a
		where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a.Eperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EPERIODO#">
		  and a.Emes     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EMES#">
		  and not exists (select 1 from BitacoraEContables h where h.IDcontable = a.IDcontable)
	</cfquery>
	<!--- <cf_dump var="#TraeDatosE#"> --->
	<cfif TraeDatosE.recordCount gt 0>
		<cfloop query="TraeDatosE">
			<cfset nohayerrores = true>
			<cfset llave =  TraeDatosE.IDcontable>
			<!--- se trae todos los documentos que para el perido y mes  indicados (detalle)--->
			<cfquery name="TraeDatosCOBIS" datasource="#session.dsn#">
				select
				COD_COMPAN = g.Etelefono2,		
				FEC_ASIENT = convert(char(10), getdate(), 112), --a.Efecha,			
				NUM_ASIENT = #TraeAsiento.num_asiento#,		
				NUM_OFICIN = g.Eidentificacion,		
				NUM_PRODUC = 6,  	
				<!---
				{fn concat({fn SUBSTRING(d.Cformato,1,4)} ,
							{fn concat({fn SUBSTRING(d.Cformato,6,1)} ,
								{fn concat({fn SUBSTRING(d.Cformato,8,2)} ,
									{fn concat({fn SUBSTRING(d.Cformato,11,3)} ,
										{fn SUBSTRING(d.Cformato,15,2)})})})})} as COD_CTACOB,
				--->
				COD_CTACOB = substring(replace(d.Cformato,'-',''),3,100),
				MTO_LOCAL  = b.Dlocal * 100,		
				MTO_EXTRAN = 0,		
				TIP_AFECTA = b.Dmovimiento,		
				DES_CONCEP = b.Ddescripcion,    	
				COD_TIPOOP = '  ',			
				COD_OFIORI = g.Eidentificacion,		
				MTO_TIPCAM = b.Dtipocambio,		
				COD_MONEDA = 20,			
				COD_PRODUC = 'ACF',			
				IND_PASCOB = 'N',			
				FEC_INCLUY = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,			
				COD_CTARIS = 'null',			
				rowid_ora = null,
				a.Edocumento,
				b.Dlinea    
				from EContables a
				  inner join DContables b
					on b.IDcontable = a.IDcontable
				  inner join Oficinas c
					on c.Ecodigo = a.Ecodigo
				   and c.Ocodigo = b.Ocodigo
				  inner join CContables d
					on d.Ecodigo = a.Ecodigo
				   and d.Ccuenta = b.Ccuenta
				  inner join <cf_dbdatabase table="Usuario" datasource="#session.dsn#"> e
					on e.Usucodigo = a.BMUsucodigo
				  inner join Empresas f
					on f.Ecodigo = a.Ecodigo
				  inner join <cf_dbdatabase table="Empresa" datasource="#session.dsn#"> g
					on g.Ecodigo = f.EcodigoSDC
				where a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#llave#">
				and a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>

	<!--- <cf_dump var="#TraeDatosCOBIS#"> --->

			<!--- Inserta el registro en COBIS--->
			<cfif TraeDatosCOBIS.recordCount gt 0>
				<cfloop query="TraeDatosCOBIS">
					<cftry>
						<cfquery name="insCOBIS" datasource="#session.dsn#">
							declare @RC int
							EXEC @RC = [COM].[dbo].[inserta_com_asient] 
									<cfqueryparam cfsqltype="cf_sql_varchar"   	value="#TraeDatosCOBIS.COD_COMPAN#">, 
									<!---
									<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#TraeDatosCOBIS.FEC_ASIENT#">, 
									--->
									<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#TraeDatosCOBIS.FEC_ASIENT#">, 
									<cfqueryparam cfsqltype="cf_sql_numeric"   	value="#TraeDatosCOBIS.NUM_ASIENT#">, 
									<cfqueryparam cfsqltype="cf_sql_varchar"   	value="#TraeDatosCOBIS.NUM_OFICIN#">, 
									<cfqueryparam cfsqltype="cf_sql_numeric"   	value="#TraeDatosCOBIS.NUM_PRODUC#">, 
									<cfqueryparam cfsqltype="cf_sql_varchar"   	value="#TraeDatosCOBIS.COD_CTACOB#">, 
									<cfqueryparam cfsqltype="cf_sql_float"     	value="#TraeDatosCOBIS.MTO_LOCAL#">, 
									<cfqueryparam cfsqltype="cf_sql_float"     	value="#TraeDatosCOBIS.MTO_EXTRAN#">, 
									<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#TraeDatosCOBIS.TIP_AFECTA#">, 
									<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#TraeDatosCOBIS.DES_CONCEP#">, 
									<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#TraeDatosCOBIS.COD_TIPOOP#">, 
									<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#TraeDatosCOBIS.COD_OFIORI#">, 
									<cfqueryparam cfsqltype="cf_sql_float" 		value="#TraeDatosCOBIS.MTO_TIPCAM#">, 
									<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#TraeDatosCOBIS.COD_MONEDA#">, 
									<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#TraeDatosCOBIS.COD_produc#">, 
									<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#TraeDatosCOBIS.IND_PASCOB#">, 
									<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#TraeDatosCOBIS.COD_CTARIS#">, 
									null
						</cfquery> 
						<cfcatch type="any">
							<!--- <cf_dump var=#cfcatch#> --->
							<cfset nohayerrores = false>
							<cfquery name="insError" datasource="#session.dsn#">
								insert  into #Errores#  (orden,Resultado)  
								values (2,'Error de base datos tratando de procesar El documento contable [ #TraeDatosCOBIS.Edocumento#] línea  #TraeDatosCOBIS.Dlinea#')
							</cfquery>
						</cfcatch>	
					</cftry>
					<!--- Inserta el registro en BITACORA--->
				</cfloop>
				<cfif nohayerrores>
					<cfquery name="insBitacora" datasource="#session.dsn#">
						insert into BitacoraEContables (
							IDcontable,
							Ecodigo,   
							Cconcepto,   
							Eperiodo,   
							Emes,    
							Edocumento,   
							Efecha,   
							Edescripcion)
						values (
							<cfqueryparam cfsqltype="cf_sql_numeric"   	value="#llave#">, 
							<cfqueryparam cfsqltype="cf_sql_integer"   	value="#TraeDatosE.Ecodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_integer"   	value="#TraeDatosE.Cconcepto#">, 
							<cfqueryparam cfsqltype="cf_sql_integer"   	value="#TraeDatosE.Eperiodo#">, 
							<cfqueryparam cfsqltype="cf_sql_integer"   	value="#TraeDatosE.Emes#">, 
							<cfqueryparam cfsqltype="cf_sql_integer"   	value="#TraeDatosE.Edocumento#">, 
							<cfqueryparam cfsqltype="cf_sql_timestamp"  value="#TraeDatosE.Efecha#">,
							<cfqueryparam cfsqltype="cf_sql_varchar"   	value="#TraeDatosE.Edescripcion#">	
						)
					</cfquery> 
				</cfif>
			<cfset nohayerrores = true>
			<cfelse>
				<cfquery name="insError" datasource="#session.dsn#">
					insert  into #Errores#  (orden,Resultado)
					values (3,'El documento contable [ #TraeDatosE.Edocumento# - #trim(TraeDatosE.Edescripcion)# ] no tiene líneas de detalle.')
				</cfquery>
			</cfif>	
			
		</cfloop>
	<cfelse>
		<cfquery name="insError" datasource="#session.dsn#">
			insert  into #Errores#  (orden,Resultado) 
			values (4,'No se encontraron datos para actualizaral sistema COBIS.')
		</cfquery>
	</cfif>

	<cfquery name="ERR" datasource="#session.DSN#">
		select  Resultado from #Errores#
		order by orden
	</cfquery>
	<cfif ERR.recordCount eq 0>
		<cfquery name="insError" datasource="#session.dsn#">
			insert  into #Errores#  (orden,Resultado)
			values (6,'Actualización de datos realizada con exito')
		</cfquery>
		
		<cfquery name="ERR" datasource="#session.DSN#">
			select  Resultado from #Errores#
			order by orden
		</cfquery>
		
		<cfset action = "COMMIT">
		<cftransaction action = "#action#"/> 
	<cfelse>
		
		<cfset action = "ROLLBACK">
		<cftransaction action = "#action#"/> 
	</cfif>
</cftransaction>