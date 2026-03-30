<!--- Tabla Temporal de Errores 
<cf_dbtemp name="ERR#Gvar.table_name#" returnvariable="err_table_name" datasource="#Gvar.Conexion#">
	<cf_dbtempcol name="ErrorCode" 	type="integer" 		mandatory="yes"><!--- Código para agrupar los errores --->
	<cf_dbtempcol name="ColumnName" type="varchar(1024)" mandatory="yes"><!--- Nombre de la columna con error--->
	<cf_dbtempcol name="ColumnType" type="varchar(1024)" mandatory="yes"><!--- Tipo de dato la Columna con error:
																					I=Entero,
																					N=2 decimales,
																					M=4 decimales,
																					F=6 decimales,
																					D=Fecha,
																					%=Texto--->
	<cf_dbtempcol name="Message" 	type="varchar(1024)" mandatory="yes"><!--- Mensaje de Error --->
	<cf_dbtempcol name="Details" 	type="varchar(1024)" mandatory="yes"><!--- Detalles Adicionales del Error --->
	<cf_dbtempcol name="ColumnValue"type="varchar(1024)" mandatory="yes"><!--- Detalles Adicionales del Error --->
</cf_dbtemp>--->
<cfquery datasource="#Gvar.Conexion#">
	delete from CDErrores
</cfquery>
<cfset err_table_name = "CDErrores">
<!--- Algunas Validaciones Generales --->
<!--- ¡Donde p.... estaan los datos
<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo"
		refresh="no"
		datasource="#Gvar.Conexion#" />
<cfdump var="#Application.dsinfo[Gvar.Conexion]#">
<cf_dumptable var="#Gvar.table_name#" datasource="#Gvar.Conexion#">
--->
<!--- Validación de Repetidos en una columna --->
<cffunction name="funcVRepetidos" output="true" returntype="Any" access="public" 
			description="Valida la repetición de Datos de una columna" displayname="funcVRepetidos" 
			hint="Utilice esta función para validar que una columna no venga con datos repetidos.">
	<cfargument name="ErrorCode" 	type="numeric" 	required="yes">
	<cfargument name="ColumnName" 	type="String" 	required="yes">
	<cfargument name="ColumnType" 	type="String" 	required="no" default="S">
	<cfargument name="Message" 		type="String" 	required="no" default="Valores repetidos en columna">
	<cfargument name="Details" 		type="String" 	required="no" default="La columna solo permite valores distintos en esta columna">
	<cfargument name="Filtro" 		type="String" 	required="no" default="1=1">
	<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
	
	<cfquery datasource="#Gvar.Conexion#">
		insert into #err_table_name#
		(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo)
		select #ErrorCode#, 
		'#ColumnName#', 
		'#ColumnType#', 
		'#Message#', 
		'#Details#',
		<cfset ArrColumnName = ListToArray(ColumnName)>
		<cfset ArrColumnType = ListToArray(ColumnType)>
		<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
				case when #ArrColumnName[i]# is not null then 
					<cfif trim(ArrColumnType[i]) EQ 'D'>
						<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
					<cfelse>
						<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
					</cfif> else 'NULL' end #_Cat# ','#_Cat#
		</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i"></cfloop>,
		#Gvar.Ecodigo#
		from #Gvar.table_name#
		where CDPcontrolv = 0
		and #Filtro#
		and Ecodigo=#Gvar.Ecodigo#
		group by #ColumnName#
		having count(1) > 1
	</cfquery>
	<cfreturn true>	
</cffunction>
<!--- Validación de No Existencia de Datos de una columna --->
<cffunction name="funcVNoExistencia" output="true" returntype="Any" access="public" 
			description="Valida la No Existencia de Datos de una columna" displayname="funcVNoExistencia" 
			hint="Utilice esta función para validar que no exista un valor en la tabla destino.">
	<cfargument name="ErrorCode" type="numeric" required="yes">
	<cfargument name="ColumnName" type="String" required="yes">
	<cfargument name="ColumnDest" type="String" required="yes">
	<cfargument name="ColumnType" type="String" required="no" default="S">
	<cfargument name="Message" type="String" required="no" default="El valor que est&aacute; insertando ya existe">
	<cfargument name="Details" type="String" required="no" default="La Columna destino ya contiene un registro con el valor que est&aacute; intentando insertar">
	<cfargument name="Filtro" type="String" required="no" default="1=1">
	<cfquery datasource="#Gvar.Conexion#">
		insert into #err_table_name#
		(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo)
		select #ErrorCode#, <cfqueryparam cfsqltype="cf_sql_varchar" value="#ColumnName#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#ColumnType#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Message#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Details#">,
		<cfset ArrColumnName = ListToArray(ColumnName)>
		<cfset ArrColumnType = ListToArray(ColumnType)>
		<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
				{fn concat({fn concat(case when #ArrColumnName[i]# is not null then          
					<cfif trim(ArrColumnType[i]) EQ 'D'>
						<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
					<cfelse>
						<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
					</cfif> else 'NULL' end,',')},
		</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
		from #Gvar.table_name#
		where CDPcontrolv = 0
		and exists(
			select 1 
			from #Gvar.table_dest#
			where 
				<cfset n = 0>	
				<cfloop list="#ColumnName#" index="ColumnNamei">
					<cfset n = n + 1>
					<cfset ColumnDesti = ListGetAt(ColumnDest,n)>
					<cfif n Gt 1>and</cfif>
					#ColumnDesti# = coalesce(#Gvar.table_name#.#trim(ColumnNamei)#,NULL)
				</cfloop>
			and #Filtro#
			and Ecodigo=#Gvar.Ecodigo#	
		)
		and #Filtro#
		and Ecodigo=#Gvar.Ecodigo#
	</cfquery>
	<cfreturn true>	
</cffunction>
<!--- Validación de la integridad de una columna --->
<cffunction name="funcVIntegridad" output="true" returntype="Any" access="public" 
			description="Valida la integridad de una columna" displayname="funcVIntegridad" 
			hint="Utilice esta función para validar que exista un valor en una tabla a la que hace referencia la tabla destino.">
	<cfargument name="ErrorCode" type="numeric" required="yes">
	<cfargument name="ColumnName" type="String" required="yes">
	<cfargument name="TableDest" type="String" required="yes">
	<cfargument name="ColumnDest" type="String" required="yes">
	<cfargument name="ColumnType" type="String" required="no" default="S">
	<cfargument name="AllowNulls" type="Boolean" required="no" default="false">
	<cfargument name="Message" type="String" required="no" default="El valor que est&aacute; insertando no existe">
	<cfargument name="Details" type="String" required="no" default="La Columna destino contiene un registro cuyo valor no existe en la tabla a la que referencia">
	<cfargument name="Filtro" type="String" required="no" default="1=1">
	
<!---	<cf_dump var="#Gvar.Ecodigo#"> --->
	
	
	<cfquery datasource="#Gvar.Conexion#">
		insert into #err_table_name#
		(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo)
		select distinct #ErrorCode#, <cfqueryparam cfsqltype="cf_sql_varchar" value="#ColumnName#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#ColumnType#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Message#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Details#">,
		<cfset ArrColumnName = ListToArray(ColumnName)>
		<cfset ArrColumnType = ListToArray(ColumnType)>
		<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
				{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then 
					<cfif trim(ArrColumnType[i]) EQ 'D'>
						<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
					<cfelse>
						<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
					</cfif> else 'NULL' end,',')},
		</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
		from #Gvar.table_name#
		where CDPcontrolv = 0
		and not exists
				(
				select 1 
				from #TableDest#
				where 
				<cfset n = 0>	
				<cfloop list="#ColumnName#" index="ColumnNamei">
					<cfset n = n + 1>
					<cfset ColumnDesti = ListGetAt(ColumnDest,n)>
					<cfif n Gt 1>and</cfif>
					<cfif len(ArrColumnType[n]) EQ 0 OR trim(ArrColumnType[n]) EQ 'S'>
						rtrim(#ColumnDesti#) = coalesce(rtrim(#Gvar.table_name#.#trim(ColumnNamei)#),NULL)
					<cfelse>
						#ColumnDesti# = coalesce(#Gvar.table_name#.#trim(ColumnNamei)#,NULL)
					</cfif> 
					
				</cfloop>
				and #Filtro#
				<!---and Ecodigo=#Gvar.Ecodigo#--->
				)
			and #Filtro#	
			and Ecodigo=#Gvar.Ecodigo#
		<cfif AllowNulls>
			<cfloop list="#ColumnName#" index="ColumnNamei">
				and #Gvar.table_name#.#trim(ColumnNamei)# IS NOT NULL
			</cfloop>
		</cfif>
	</cfquery>	
	<cfreturn true>
</cffunction>
<!---<cfdump var="#funcVIntegridad#">--->
<!--- Validación de Valores de una columna --->
<cffunction name="funcVValor" output="true" returntype="Any" access="public" 
			description="Valida Valores de una columna" displayname="funcVValor" 
			hint="Utilice esta función para validar que una columna solamente contenga ciertos valores.">
	<cfargument name="ErrorCode" type="numeric" required="yes">
	<cfargument name="ColumnName" type="String" required="yes">
	<cfargument name="ColumnType" type="String" required="no" default="S">
	<cfargument name="ListValues" type="String" required="yes">
	<cfargument name="Message" type="String" required="no" default="El valor que est&aacute; insertando es inv&aacute;lido">
	<cfargument name="Details" type="String" required="no" default="El conjunto de valores v&aacute;lidos es {#ListValues#}">
	<cfargument name="Filtro" type="String" required="no" default="1=1">
	<cfquery datasource="#Gvar.Conexion#">
		insert into #err_table_name#
		(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo)
		select #ErrorCode#, <cfqueryparam cfsqltype="cf_sql_varchar" value="#ColumnName#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#ColumnType#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Message#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Details#">,
		coalesce(<cf_dbfunction name="to_char" args="#ColumnName#" datasource="#Gvar.Conexion#">,'NULL'),
		#Gvar.Ecodigo#
		from #Gvar.table_name#
		where CDPcontrolv = 0
		and #ColumnName# not in (<cfif ColumnType EQ 'I'>#ListValues#<cfelse>#QuotedList(ListValues)#</cfif>)
		and #Filtro#
		and Ecodigo=#Gvar.Ecodigo#	
	</cfquery>
	<cfreturn true>
</cffunction>
<!--- Validación de que se cumpla una fórmula sobre los datos de entrada --->
<cffunction name="funcVFormula" output="true" returntype="Any" access="public" 
			description="Valida Fórmula sobre datos de entrada" displayname="funcVFormula" 
			hint="Utilice esta función para validar que se cumlpa una fómula sobre los datos de entrada">
	<cfargument name="ErrorCode" type="numeric" required="yes">
	<cfargument name="ColumnName" type="String" required="yes">
	<cfargument name="ColumnType" type="String" required="no" default="S">
	<cfargument name="Formula" type="String" required="yes">
	<cfargument name="Message" type="String" required="no" default="No se cumple con F&oacute;rmula requerida">
	<cfargument name="Details" type="String" required="no" default="La F&oacute;rmula es '#Formula#'">
	<cfargument name="Filtro" type="String" required="no" default="1=1">
	<cfquery datasource="#Gvar.Conexion#">
		insert into #err_table_name#
		(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue,Ecodigo)
		select #ErrorCode#, <cfqueryparam cfsqltype="cf_sql_varchar" value="#ColumnName#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#ColumnType#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Message#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Details#">,
		coalesce(<cf_dbfunction name="to_char" args="#ColumnNamei#" datasource="#Gvar.Conexion#">,'NULL'),
		#Gvar.Ecodigo#
		from #Gvar.table_name#
		where CDPcontrolv = 0
		and #Formula#
		and #Filtro#
		and Ecodigo=#Gvar.Ecodigo#		
	</cfquery>
	<cfreturn true>
</cffunction>
<!--- Función Privada para agregar comillas a los valores de una lista --->
<cffunction name="QuotedList" access="private" returntype="String">
	<cfargument name="List" type="string">
	<cfset var retList = "">
	<cfloop list="#List#" index="item">
		<cfset retList = ListAppend(retList,"'"&item&"'")>
	</cfloop>
	<cfreturn retList>
</cffunction>

<!--- Validar los datos sin validar (CDPcontrolv=0) sin generar (CDPcontrolvg=0) --->
<cfinclude template = "#Gvar.rutaValida#">

<!--- Obtner los errores si los hay --->
<cfquery name="err" datasource="#Gvar.Conexion#">
	select ErrorCode, ColumnName, ColumnType, '' as Message, count(1) as ErrorCount
	from #err_table_name#
	where Ecodigo = #Gvar.Ecodigo#
	group by ErrorCode, ColumnName, ColumnType
	order by ErrorCode
</cfquery>
<cfloop query="err">
	<cfquery name="rsMessage" datasource="#Gvar.Conexion#">
		select min(Message) as Message
		from #err_table_name#
		where ErrorCode = #ErrorCode#
		and Ecodigo = #Gvar.Ecodigo#
	</cfquery>
	<cfif len(trim(rsMessage.Message)) gt 0>
		<cfset QuerySetCell(err,"Message",rsMessage.Message, err.CurrentRow)>
	</cfif>
</cfloop>
<cfquery name="errsum" dbtype="query">
	select sum(ErrorCount) as ErrorSum from err
</cfquery>
<cf_web_portlet_start title="Resumen de resultados" Skin="Mini">
<cfoutput>

<form name="validar" action="index.cfm" method="post">
	<cfif err.recordcount gt 0>
		<!--- Mostrar link para reporte de todos los errores. --->
		<table border="0" cellpadding="0" cellspacing="0" class="AreaFiltro" align="center" width="800"> 
			<tr>
				<td colspan="6">
					<strong>Resumen de Errores de Carga de #Gvar.table_dest#</strong>
				</td>
			</tr>
			<tr>
				<td colspan="6">
					Se encontraron #errsum.ErrorSum# errores.
				</td>
			</tr>
			<tr>
				<td colspan="6">
					Los errores encontrados se categorizan de la siguiente forma:					
				</td>
			</tr>
			<tr>
				<td class="TituloListas">
					C&oacute;digo
				</td>
				<td class="TituloListas">
					Error
				</td>
				<td class="TituloListas">
					Columna
				</td>
				<td class="TituloListas">
					Cantidad
				</td>
			</tr>
			<cfloop query="err">
				<cfset LvarListaNon = (CurrentRow MOD 2)>
				<cfset LvarClassName = IIf(LvarListaNon, DE('listaNon'), DE('listaPar'))> 
				<tr class="#LvarClassName#" onmouseover="this.className='#LvarClassName#Sel';" onmouseout="this.className='#LvarClassName#';">
					<td class="#LvarClassName#">
						#ErrorCode#
					</td>
					<td class="#LvarClassName#">
						#Message#
					</td>
					<td class="#LvarClassName#">
						#ColumnName#
					</td>
					<td class="#LvarClassName#">
						#ErrorCount#
					</td>
				</tr>
			</cfloop>
		</table>
		<!--- Mostrar resumen de los errores categorizados con click para ver sus detalles en un reporte --->
		<cf_botones values="Regresar, Reporte, Reintentar">
	<cfelse>
		<!--- Actualiza los registros como Válidados --->
		<cfquery datasource="#Gvar.Conexion#">
			update #Gvar.table_name#
			set CDPcontrolv = 1,
			Ecodigo = #Gvar.Ecodigo#
			where coalesce(CDPcontrolv,0) = 0
			and  coalesce(CDPcontrolg,0) = 0			
			and Ecodigo= #Gvar.Ecodigo#
		</cfquery>
		<cfquery name="rsCount" datasource="#Gvar.Conexion#">
			select count(1) as recordcountm
			from #Gvar.table_name#
			where CDPcontrolv = 1
			and coalesce(CDPcontrolg,0) = 0
			and Ecodigo= #Gvar.Ecodigo#			
		</cfquery>
		<cfif rsCount.recordcountm GT 0>
			<!--- Mostrar un resumen de los datos válidos (CDPcontrolv=1) sin generar (CDPcontrolvg=0) --->
			<table border="0" cellpadding="0" cellspacing="0" class="AreaFiltro" align="center" width="800"> 
				<tr>
					<td colspan="6">
						<strong>No se encontrar&oacute;n Errores en la Carga de #Gvar.table_name#</strong>
					</td>
				</tr>
				<tr>
					<td colspan="6">
						Ahora puede proceder a generar los registros en la tabla #Gvar.table_dest#
					</td>
				</tr>
			</table>
			<cf_botones values="Regresar, Generar">
		<cfelse>
			<!--- Informar de la Inexistencia de Registros por procesar --->
			<table border="0" cellpadding="0" cellspacing="0" class="AreaFiltro" align="center" width="800"> 
				<tr>
					<td colspan="6">
						<strong>No se encontrar&oacute;n Registros en #Gvar.table_name#</strong>
					</td>
				</tr>
				<tr>
					<td colspan="6">
						No hay acciones por procesar
					</td>
				</tr>
			</table>
			<cf_botones values="Regresar, Reintentar">
		</cfif>
	</cfif>
	<input type="hidden" name="CEcodigo" value="#form.CEcodigo#">
	<input type="hidden" name="Ecodigo" value="#form.Ecodigo#">
	<input type="hidden" name="SScodigo" value="#form.SScodigo#">
	<input type="hidden" name="CDPid" value="#form.CDPid#">
</form>
<script language="javascript">
	function limpiar(){
		document.validar.CDPid.value="";
	}
	function funcReporte(){
		return true;
	}
	function funcGenerar(){
		return true;
	}
	function funcReintentar(){
		return true;
	}
	function funcRegresar(){
		limpiar();
		return true;
	}
</script>
</cfoutput>
<cf_web_portlet_end>