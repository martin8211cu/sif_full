<!---======== Tabla temporal de errores  ========--->
<cf_dbtemp name="ErroresImpMetasV1" returnvariable="ErroresImpMetasV1" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp>
<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">

<cf_dbfunction2 name="date_part"   args="YYYY,a.Pfecha"     datasource="#session.dsn#" returnVariable="YYYY">
<cfset YYYY &= "* 1000">
<cf_dbfunction2 name="date_format" args="a.Pfecha,YYYY"   datasource="#session.dsn#" returnVariable="PART_A">
<cf_dbfunction2 name="date_part" args="DY,a.Pfecha" datasource="#session.dsn#" returnVariable="PART_D">
<cf_dbfunction2 name="date_part" args="WK,a.Pfecha" datasource="#session.dsn#" returnVariable="PART_W">
<cf_dbfunction2 name="date_part" args="MM,a.Pfecha" datasource="#session.dsn#" returnVariable="PART_M">
<cf_dbfunction2 name="date_part" args="QQ,a.Pfecha" datasource="#session.dsn#" returnVariable="PART_T">
<cf_dbfunction2 name="date_part" args="QQ,a.Pfecha" datasource="#session.dsn#" returnVariable="PART_Q">
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

<cfquery name="rsRepetidos" datasource="#session.DSN#">
	select  a.MIGMcodigo,
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
		group by a.MIGMcodigo,
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
		Insert into #ErroresImpMetasV1# (Error)
		values ('La M&eacute;trica #rsRepetidos.MIGMcodigo# esta repetida para la Fecha #rsImportador.Pfecha#.')
	</cfquery>
</cfif>

<cfset session.Importador.SubTipo = "2">
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
	
<!---Valida que los valores ingresados por el importador  no vayan en blanco.--->
	<cfif trim(rsImportador.MIGMcodigo) EQ "">	
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpMetasV1# (Error)
			values ('El C&oacute;digo de la M&eacute;trica no puede ir en blanco')
		</cfquery>
	</cfif>
	<cfif trim(rsImportador.Pfecha) EQ "">	
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpMetasV1# (Error)
			values ('La fecha no puede ir en blanco')
		</cfquery>
	</cfif>	
	<cfif trim(rsImportador.Meta) EQ "">	
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpMetasV1# (Error)
			values ('El valor de la Meta no puede ir en blanco')
		</cfquery>
	</cfif>
	<!--- Valida Estado Activo=1 Inactivo=0--->	
	<cfif trim(rsImportador.Dactiva) EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpMetasV1# (Error)
			values ('El Estado no puede ir en blanco')
		</cfquery>
	</cfif>		
	
	<cfif len(trim(rsImportador.MIGMcodigo)) GT 0>
		<cfquery name="rsMetricas" datasource="#session.dsn#">
			select MIGMid
			from MIGMetricas
			where MIGMcodigo = '#trim(rsImportador.MIGMcodigo)#'
			and  MIGMesmetrica='I'
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		
		<cfif rsMetricas.MIGMid EQ "">	
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpMetasV1# (Error)
				values ('El Indicador #rsImportador.MIGMcodigo# no existe')
			</cfquery>
		</cfif>
	</cfif>	
	<!--- Valida Estado Activo=1 Inactivo=0--->	
	<cfif trim(rsImportador.Dactiva) NEQ "">
		<cfif trim(rsImportador.Dactiva) NEQ 0 and trim(rsImportador.Dactiva) NEQ 1>
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpMetasV1# (Error)
				values ('Favor verificar Estado. Activo=1 Inactivo=0')
			</cfquery>
		</cfif>
	</cfif>
	
	<cfif trim(rsImportador.Peso) EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpMetasV1# (Error)
			values ('El Peso no puede ir en blanco')
		</cfquery>
		
	<cfelse>
		
		<cfif trim(rsImportador.Peso) LT 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpMetasV1# (Error)
				values ('El Peso debe ser mayor a cero.')
			</cfquery>
		</cfif>	
	</cfif>	
	
		
	<cfquery name="rsErrores" datasource="#session.DSN#">
		select count(1) as cantidad
		from #ErroresImpMetasV1#
	</cfquery>
<!---Si hay errores no hace la inserción--->
	<cfif rsErrores.cantidad gt 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #ErroresImpMetasV1#
		</cfquery>
		<cfreturn>
<!---Hace lo inserción en caso de que no hayan errores.--->
	<cfelse>
		<cfset LvarMes=mid(rsImportador.Pfecha,6,2)>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select MIGMetaid
			from MIGMetas
			where MIGMid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMetricas.MIGMid#">
			and Periodo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsImportador.Periodo#">
			and Ecodigo=#session.Ecodigo#
			and Periodo_Tipo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.Periodo_Tipo#">
		</cfquery>
		<cfif rsSQL.recordCount EQ 0>
			<cftransaction>
				<cfinvoke component="mig.Componentes.MIGMetas" method="Alta" returnvariable="MIGMetaid">
					<cfinvokeargument name="MIGMid" 				value="#rsMetricas.MIGMid#"/>
					<cfinvokeargument name="Pfecha" 				value="#rsImportador.Pfecha#"/>
					<cfinvokeargument name="Meta" 					value="#rsImportador.Meta#"/>
				<cfif isdefined('rsImportador.Metaadicional') and len(trim(rsImportador.Metaadicional)) GT 0>
					<cfinvokeargument name="Metaadicional" 			value="#rsImportador.Metaadicional#"/>
				<cfelse>
					<cfinvokeargument name="Metaadicional" 			value="0"/>
				</cfif>
					<cfinvokeargument name="Periodo" 				value="#rsImportador.Periodo#"/>
					<cfinvokeargument name="Periodo_Tipo" 			value="#rsImportador.Periodo_Tipo#"/>
					<cfinvokeargument name="Dactiva" 				value="#rsImportador.Dactiva#"/>
					<cfinvokeargument name="CodFuente" 				value="2"/>
				<cfif isdefined('rsImportador.Peso') and len(trim(rsImportador.Peso)) gt 0>
					<cfinvokeargument name="Peso" 				value="#rsImportador.Peso#"/>
				<cfelse>
					<cfinvokeargument name="Peso" 				value="0"/>
				</cfif>			
				</cfinvoke>	
			</cftransaction>			
		<cfelse>
			<cftransaction>
				<cfinvoke component="mig.Componentes.MIGMetas" method="Cambio">
					<cfinvokeargument name="MIGMetaid" 				value="#rsSQL.MIGMetaid#"/>
					<cfinvokeargument name="Pfecha" 				value="#rsImportador.Pfecha#"/>
					<cfinvokeargument name="Meta" 					value="#rsImportador.Meta#"/>
				<cfif isdefined('rsImportador.Metaadicional') and len(trim(rsImportador.Metaadicional)) GT 0>
					<cfinvokeargument name="Metaadicional" 			value="#rsImportador.Metaadicional#"/>
				<cfelse>
					<cfinvokeargument name="Metaadicional" 			value="0"/>
				</cfif>
					<cfinvokeargument name="Dactiva" 				value="#rsImportador.Dactiva#"/>
				<cfif isdefined('rsImportador.Peso') and len(trim(rsImportador.Peso)) gt 0>
					<cfinvokeargument name="Peso" 				value="#rsImportador.Peso#"/>
				<cfelse>
					<cfinvokeargument name="Peso" 				value="0"/>
				</cfif>	
				</cfinvoke>	
			</cftransaction>			
		</cfif>
	</cfif>
</cfloop>		

<cfset session.Importador.SubTipo = 3>

