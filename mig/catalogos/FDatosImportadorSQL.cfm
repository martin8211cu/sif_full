
<!---======== Tabla temporal de errores  ========--->
<cf_dbtemp name="ErroresImpDVV3" returnvariable="ErroresImpDVV3" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp>


<!---Valida que lo datos no esten repetidos--->
<cf_dbfunction2 name="OP_concat" args="a.Fecha"	returnvariable="_Cat">

<cf_dbfunction2 name="date_part"   args="YYYY,a.Fecha"     datasource="#session.dsn#" returnVariable="YYYY">
<cfset YYYY &= "* 1000">
<cf_dbfunction2 name="date_format" args="a.Fecha,YYYY"   datasource="#session.dsn#" returnVariable="PART_A">
<cf_dbfunction2 name="date_part" args="DY,a.Fecha" datasource="#session.dsn#" returnVariable="PART_D">
<cf_dbfunction2 name="date_part" args="WK,a.Fecha" datasource="#session.dsn#" returnVariable="PART_W">
<cf_dbfunction2 name="date_part" args="MM,a.Fecha" datasource="#session.dsn#" returnVariable="PART_M">
<cf_dbfunction2 name="date_part" args="QQ,a.Fecha" datasource="#session.dsn#" returnVariable="PART_T">
<cf_dbfunction2 name="date_part" args="QQ,a.Fecha" datasource="#session.dsn#" returnVariable="PART_Q">
<cfquery  name="rsImportador" datasource="#session.dsn#">
	select a.*,
		b.Ecodigo,
		#preserveSingleQuotes(YYYY)#+
		case b.MIGMperiodicidad
					when 'D' then #preserveSingleQuotes(PART_D)#
					when 'W' then #preserveSingleQuotes(PART_W)#
					when 'M' then #preserveSingleQuotes(PART_M)#
					when 'T' then #preserveSingleQuotes(PART_T)#
					when 'A' then 1
					when 'S' then 
								case when #preserveSingleQuotes(PART_Q)# <= 2 then
											1
								else
											2
								end
		end as Periodo, 
		b.MIGMperiodicidad as Periodo_Tipo
	from #table_name# a
		left join MIGMetricas b
		on a.MIGMcodigo=b.MIGMcodigo
		and b.Ecodigo = #session.Ecodigo#
</cfquery>
<cfset session.Importador.SubTipo = "2">
<cfquery name="rsRepetidos" datasource="#session.DSN#">
	select  a.MIGMcodigo,
			a.Deptocodigo,a.MIGProcodigo,a.MIGCuecodigo,a.id_atr_dim4,a.id_atr_dim5,a.Miso4217,
			b.MIGMperiodicidad,
			#preserveSingleQuotes(YYYY)#+
			case b.MIGMperiodicidad
					when 'D' then #preserveSingleQuotes(PART_D)#
					when 'W' then #preserveSingleQuotes(PART_W)#
					when 'M' then #preserveSingleQuotes(PART_M)#
					when 'T' then #preserveSingleQuotes(PART_T)#
					when 'A' then 1
					when 'S' then 
								case when #preserveSingleQuotes(PART_Q)# <= 2 then
											1
								else
											2
								end
			end as Periodo,
			count(1) as repetidos		
	from #table_name# a
		inner join MIGMetricas b
			on a.MIGMcodigo=b.MIGMcodigo
			and b.Ecodigo = #session.Ecodigo# 
		group by a.MIGMcodigo,a.Deptocodigo,a.MIGProcodigo,a.MIGCuecodigo,a.id_atr_dim4,a.id_atr_dim5,a.Miso4217,
			b.MIGMperiodicidad,
			#preserveSingleQuotes(YYYY)#+
			case b.MIGMperiodicidad
					when 'D' then #preserveSingleQuotes(PART_D)#
					when 'W' then #preserveSingleQuotes(PART_W)#
					when 'M' then #preserveSingleQuotes(PART_M)#
					when 'T' then #preserveSingleQuotes(PART_T)#
					when 'A' then 1
					when 'S' then 
								case when #preserveSingleQuotes(PART_Q)# <= 2 then
											1
								else
											2
								end
			end
	having count(1) > 1
</cfquery>
<cfif rsRepetidos.recordCount GT 0>
	<cfquery name="ERR" datasource="#session.DSN#">
		Insert into #ErroresImpDVV3# (Error)
		values ('La Fecha para la M&eacute;trica #rsRepetidos.MIGMcodigo# estan incorrectas.Verifique la Periodicidad de la M&eacute;trica')
	</cfquery>
</cfif>
	<cfquery name="rsLote" datasource="#session.dsn#">
		select max(Lote) as Lote from F_Datos
		where Ecodigo=#session.Ecodigo#
	</cfquery>
	<cfset LvarLote=0>
	<cfif rsLote.Lote EQ -1 or rsLote.Lote EQ "">
		<cfset LvarLote=1>
	<cfelse>
		<cfset LvarLote=rsLote.Lote+1>
	</cfif>
	
	
<cfloop query="rsImportador">
	<cfset session.Importador.Avance = rsImportador.currentRow/rsImportador.recordCount>

	<cfif (rsImportador.currentRow mod 179 EQ 0)>
		<cfoutput>
			<!-- Flush:
				#repeatString("*",1024)#
			-->
		</cfoutput>
		<!--- veamos si hay que cancelar el proceso --->
		<cfflush interval="64">
	</cfif>	
	
<!--- Valida que los datos que son Obligatorios esten el archivo a Importar--->	
	
	<cfif trim(rsImportador.MIGMcodigo) EQ "">	
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpDVV3# (Error)
			values ('El C&oacute;digo de M&egrave;trica no puede ir en blanco')
		</cfquery>
	</cfif>
	
	<cfif trim(rsImportador.Deptocodigo) EQ "">	
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpDVV3# (Error)
			values ('El Departamento no puede ir en blanco')
		</cfquery>
	</cfif>
	
	<cfif trim(rsImportador.Fecha) EQ "">	
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpDVV3# (Error)
			values ('Fecha Información no puede ir en blanco')
		</cfquery>
	</cfif>
	
	<cfif trim(rsImportador.Valor) EQ "">	
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpDVV3# (Error)
			values ('El valor de la M&eacute;trica no puede ir en blanco')
		</cfquery>
		
		<!--- POR CAMBIOS POSTERIORES EL CLIENTE SOLICITO QUE SE PUDIERAN INGRESAR VALORES ES EN CERO PARA EL CAMPO DE VALOR--->
		<!---<cfelseif trim(rsImportador.Valor) EQ 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpDVV3# (Error)
				values ('El valor de la M&eacute;trica no puede ser 0')
			</cfquery>--->
			
	</cfif>
	
<!---Valida que los datos relacionados existan--->	

		<!---Valida Metrica--->
		<cfquery datasource="#Session.DSN#" name="rsMetricas">
			select MIGMid,MIGMcodigo,MIGMtipodetalle,MIGMperiodicidad
			from MIGMetricas
			where MIGMcodigo='#trim(rsImportador.MIGMcodigo)#'
			and Ecodigo=#session.Ecodigo#
			and MIGMesmetrica='M'	
		</cfquery>
		<cfif rsMetricas.MIGMid EQ "">	
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpDVV3# (Error)
				values ('La M&eacute;trica #rsImportador.MIGMcodigo# no existe')
			</cfquery>
		</cfif>
		<!---Valida Departamento--->
		<cfquery datasource="#Session.DSN#" name="rsDepartamentos">
				select Dcodigo,Deptocodigo
				from Departamentos
				where RTRIM(Deptocodigo)='#trim(rsImportador.Deptocodigo)#'
				and Ecodigo=#session.Ecodigo#
		</cfquery>	
		<cfif rsDepartamentos.Dcodigo EQ "">	
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpDVV3# (Error)
				values ('El Departamento #rsImportador.Deptocodigo# no existe')
			</cfquery>
		</cfif>
		
		<!---Valida Productos--->
		<cfif len(trim(rsImportador.MIGProcodigo)) GT 0>	
			<cfquery datasource="#Session.DSN#" name="rsProductos">
				select MIGProid,MIGProcodigo
				from MIGProductos
				where MIGProcodigo='#trim(rsImportador.MIGProcodigo)#'
				and Ecodigo=#session.Ecodigo#
			</cfquery>
			<cfif rsProductos.MIGProcodigo EQ "">	
				<cfquery name="ERR" datasource="#session.DSN#">
					Insert into #ErroresImpDVV3# (Error)
					values ('El Productos #rsImportador.MIGProcodigo# no existe')
				</cfquery>
			</cfif>
		</cfif>
		<!---Valida Cuenta--->
		<cfif len(trim(rsImportador.MIGCuecodigo)) GT 0>	
			<cfquery datasource="#Session.DSN#" name="rsCuentas">
				select MIGCueid,MIGCuecodigo
				from MIGCuentas
				where MIGCuecodigo='#trim(rsImportador.MIGCuecodigo)#'
				and Ecodigo=#session.Ecodigo#
			</cfquery>	
			<cfif rsCuentas.MIGCueid EQ "">	
				<cfquery name="ERR" datasource="#session.DSN#">
					Insert into #ErroresImpDVV3# (Error)
					values ('La Cuenta #rsImportador.MIGCuecodigo# no existe')
				</cfquery>
			</cfif>
		</cfif>	
	
		<!---Valida Moneda--->
		<cfif len(trim(rsImportador.Miso4217)) GT 0>
			<!---Primero obtengo el MISO de la Moneda del Datos--->
			<cfquery name="rsMIGMonedas" datasource="#session.dsn#">
				select Mcodigo,Miso4217
				from MIGMonedas
				where Miso4217='#trim(rsImportador.Miso4217)#'
				and Ecodigo=#session.Ecodigo#
			</cfquery>
			
			<cfif rsMIGMonedas.Mcodigo EQ "">	
				<cfquery name="ERR" datasource="#session.DSN#">
					Insert into #ErroresImpDVV3# (Error)
					values ('La Moneda #rsImportador.Miso4217# no existe')
				</cfquery>
			<cfelse>
				<!---Luego obtengo el Mcodigo para compararlo con el de la empresa--->
				<cfquery name="rsMonedaEmpresa" datasource="#session.dsn#">
					select Mcodigo
					from Empresas
					where Ecodigo=#session.Ecodigo#
				</cfquery>
				<!---obtengo el Mcodigo para compararlo--->
				<cfquery name="rsMoneda" datasource="#session.dsn#">
					select Mcodigo,Miso4217
					from Monedas
					where Mcodigo=#rsMonedaEmpresa.Mcodigo#
					and Ecodigo=#session.Ecodigo#
				</cfquery>
				<cfif rsMoneda.Miso4217 NEQ rsMIGMonedas.Miso4217>						
					<cfset LvarMes=mid(rsImportador.Fecha,6,2)*1>
					<cfset LvarMesPer=mid(rsImportador.Fecha,6,2)>
					<cfset LvarPer=mid(rsImportador.Periodo,1,5)*1>
					<cfquery name="rsTipoCambio" datasource="#session.dsn#">
						select Factor 
						from MIGFactorconversion 
						where Ecodigo=#session.Ecodigo#
						and Mcodigo=#rsMIGMonedas.Mcodigo#
						and Periodo=#LvarPer##LvarMesPer#
						and Mes=#LvarMes#
					</cfquery>
					<cfset LvarTC=0>
					
					<cfif rsTipoCambio.recordcount GT 0>
						<cfset LvarTC=rsTipoCambio.Factor*rsImportador.Valor>
					<cfelse>
						<cfset LvarPer=mid(rsImportador.Periodo,1,4)*1>
						<cfquery name="ERR" datasource="#session.DSN#">
							Insert into #ErroresImpDVV3# (Error)
							values ('Para la Moneda #rsImportador.Miso4217# no existe un Historico de Tipo de Cambio en el Perido #LvarPer# para el mes #LvarMes#')
						</cfquery>
					</cfif>
				<cfelse>
					<cfset LvarTC=rsImportador.Valor>
				</cfif>
			</cfif>
		<cfelse>	
			<cfset LvarTC=rsImportador.Valor>
		</cfif>	
		
	<cfquery name="rsErrores" datasource="#session.DSN#">
		select count(1) as cantidad
		from #ErroresImpDVV3#
	</cfquery>
<!---Si hay errores no hace la inserción--->
	<cfif rsErrores.cantidad gt 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #ErroresImpDVV3#
		</cfquery>
		<cfreturn>
<!---Hace lo inserción en caso de que no hayan errores.--->
	<cfelse>
		<!---Busca las lineas existentes en F_datos para hacerles un update--->
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select  id_datos
			  from 	F_Datos
				 where 	MIGMid			= #rsMetricas.MIGMid#
			 	and 	Dcodigo			= #rsDepartamentos.Dcodigo#
			<cfif rsImportador.MIGProcodigo	NEQ "">
			   and 	MIGProid = #rsProductos.MIGProid#
			</cfif>
			<cfif rsImportador.MIGCuecodigo	NEQ "">
			   and 	MIGCueid = 	#rsCuentas.MIGCueid#
			</cfif>
			<cfif len(trim(rsImportador.Miso4217)) GT 0 and isdefined ('rsMIGMonedas.Mcodigo') and  rsMIGMonedas.Mcodigo NEQ "">
				and id_moneda=#rsMonedaEmpresa.Mcodigo#
				and id_moneda_origen=#rsMIGMonedas.Mcodigo#
			</cfif>
			<cfif rsImportador.id_atr_dim4	NEQ "">
				and id_atr_dim4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsImportador.id_atr_dim4)#">
			</cfif>
			<cfif rsImportador.id_atr_dim5	NEQ "">
				and id_atr_dim5 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsImportador.id_atr_dim5)#">
			</cfif>				
			  	and  	Ecodigo =			#session.Ecodigo#
			  	and 	Periodo_Tipo = 	'#rsImportador.Periodo_Tipo#'
			  	and 	Periodo = 		#rsImportador.Periodo#
		</cfquery>
		<cfif rsSQL.id_datos EQ "">
			<cftransaction>
				<cfinvoke component="mig.Componentes.FDatos" method="Alta" returnvariable="Lvarid_datos">
					<cfinvokeargument name="Lote" 					value="#LvarLote#"/>
					<cfinvokeargument name="cod_fuente" 			value="2"/>			
					<cfinvokeargument name="MIGMid" 				value="#rsMetricas.MIGMid#"/>
				<cfif isdefined ('rsDepartamentos.Dcodigo') and  rsDepartamentos.Dcodigo NEQ "">
					<cfinvokeargument name="Dcodigo" 				value="#rsDepartamentos.Dcodigo#">
				<cfelse>
					<cfinvokeargument name="Dcodigo" 				value="null">
				</cfif>
				<cfif len(trim(rsImportador.MIGProcodigo)) GT 0 and  isdefined ('rsProductos.MIGProid') and rsProductos.MIGProid gt 0>
					<cfinvokeargument name="MIGProid" 				value="#rsProductos.MIGProid#">
				<cfelse>
					<cfinvokeargument name="MIGProid" 				value="null">
				</cfif>
				<cfif len(trim(rsImportador.MIGCuecodigo)) GT 0 and isdefined ('rsCuentas.MIGCueid') and rsCuentas.MIGCueid GT 0>
					<cfinvokeargument name="MIGCueid" 				value="#rsCuentas.MIGCueid#">
				<cfelse>
					<cfinvokeargument name="MIGCueid" 				value="null">
				</cfif>
				<cfif len(trim(rsImportador.Miso4217)) GT 0 and isdefined ('rsMIGMonedas.Mcodigo') and rsMIGMonedas.Mcodigo GT 0>
					<cfinvokeargument name="id_moneda" 				value="#rsMonedaEmpresa.Mcodigo#">
					<cfinvokeargument name="id_moneda_origen" 		value="#rsMIGMonedas.Mcodigo#">
				<cfelse>
					<cfinvokeargument name="id_moneda" 				value="null">
					<cfinvokeargument name="id_moneda_origen" 		value="null">
				</cfif>
				<cfif isdefined ('rsImportador.id_atr_dim4') and len(trim(rsImportador.id_atr_dim4)) GT 0>
					<cfinvokeargument name="id_atr_dim4" 			value="#rsImportador.id_atr_dim4#">
				<cfelse>
					<cfinvokeargument name="id_atr_dim4" 			value="">
				</cfif>
				<cfif isdefined ('rsImportador.id_atr_dim5') and len(trim(rsImportador.id_atr_dim5)) GT 0>
					<cfinvokeargument name="id_atr_dim5" 			value="#rsImportador.id_atr_dim5#">
				<cfelse>
					<cfinvokeargument name="id_atr_dim5" 			value="">
				</cfif>
					<cfinvokeargument name="Pfecha" 				value="#rsImportador.Fecha#">
					<cfinvokeargument name="Periodo" 				value="#rsImportador.Periodo#">
					<cfinvokeargument name="Periodo_Tipo"			value="#rsImportador.Periodo_Tipo#">
					<cfinvokeargument name="Valor" 				    value="#LvarTC#">
					<cfinvokeargument name="valor_moneda_origen" 	value="#rsImportador.Valor#">
				</cfinvoke>
			</cftransaction>
		<cfelse>
			<cftransaction>
				<cfinvoke component="mig.Componentes.FDatos" method="Cambio">
					<cfinvokeargument name="id_datos" 				value="#rsSQL.id_datos#"/>
					<cfinvokeargument name="Lote" 					value="#LvarLote#"/>
					<cfinvokeargument name="Pfecha" 				value="#rsImportador.Fecha#">
					<cfinvokeargument name="Valor" 				    value="#LvarTC#">
					<cfinvokeargument name="valor_moneda_origen" 	value="#rsImportador.Valor#">
				</cfinvoke>
			</cftransaction>
		</cfif>
	</cfif>

</cfloop>		
<cfset LvarOBJ=createObject("component", "mig.Componentes.utils")>
<cfset LvarOBJ.sbCalcularAcumulados(session.dsn)>
<cfset session.Importador.SubTipo = 3>


