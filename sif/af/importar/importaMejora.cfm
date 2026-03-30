<cf_dbfunction name="OP_concat"	returnvariable="LvarOP_Concat" >
<!--- Funciona de Validación General de a existencia de un dato en la Base de Datos --->
<cffunction 
	access="private" 
	name="fnValida"
	output="false" 
	returntype="boolean">
	<cfargument name="Columna" 		required="true">
	<cfargument name="Type" 		required="false" default="S">
	<cfargument name="Tabla" 		required="true">
	<cfargument name="Filtro" 		required="true">
	<cfargument name="Mensaje" 		required="true">
	<cfargument name="ErrorNum" 	required="true"/>
	<cfargument name="filtroGral" 	required="false" default=""/>
	<cfargument name="joinEmpresas" required="false" default="false"><!--- true indica que haga join con Empresas, básicamente para obtener el nombre de la Empresa para el mensaje de error --->
	<cfargument name="exists" 		required="false" default="false"><!--- true indica que hay error cuando existe --->
	<cfargument name="permiteNulos" required="false" default="false" type="boolean"/>
	<cfargument name="debug" 		required="false" default="false" type="boolean"/>
	<cfif Arguments.debug>
		<cf_dumptable name="#table_name#" abort="false" >
	</cfif>
	<cfquery datasource="#session.dsn#">
		insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
		select #table_name#.Aplaca, <cf_dbfunction name="concat" args="'#ErrorNum#. La Columna #Arguments.Columna# contiene un dato que ',#PreserveSingleQuotes(Arguments.Mensaje)#,'.'"> as Mensaje, 
		<cfif Arguments.Type EQ 'D'>
			<cf_dbfunction name="date_format" args="#table_name#.#Arguments.Columna#,DD/MM/YYYY"> as DatoIncorrecto, 
		<cfelseif Arguments.Type EQ 'M'>
			<cf_dbfunction name="to_char_currency" args="#table_name#.#Arguments.Columna#"> as DatoIncorrecto, 
		<cfelseif Arguments.Type EQ 'F'>
			<cf_dbfunction name="to_char_float" args="#table_name#.#Arguments.Columna#"> as DatoIncorrecto, 
		<cfelse>
			<cf_dbfunction name="to_char" args="#table_name#.#Arguments.Columna#"> as DatoIncorrecto, 
		</cfif>
		#Arguments.ErrorNum# as ErrorNum
		from #table_name#
		where #table_name#.Aplaca is not null
		<cfif len(trim(Arguments.Tabla)) GT 0>
			and <cfif not Arguments.exists> not </cfif>exists(
				select 1
				from #PreserveSingleQuotes(Arguments.Tabla)#
				where #PreserveSingleQuotes(Arguments.filtro)#
			)
		</cfif>
		<cfif len(trim(Arguments.filtroGral)) GT 0>
			and #PreserveSingleQuotes(Arguments.filtroGral)#
		</cfif>
		<cfif Arguments.permiteNulos>
			and #table_name#.#Arguments.Columna# is not null
		</cfif>
		<cfif Arguments.debug><cfabort></cfif>
	</cfquery>
	<cfreturn true/>
</cffunction>
<!--- Tabla Temporal de Errores --->
<cf_dbtemp name="AF_INICIO_ERROR" returnvariable="AF_INICIO_ERROR" datasource="#session.dsn#">
	<cf_dbtempcol name="Aplaca" type="char(20)" mandatory="no">
	<cf_dbtempcol name="Mensaje" type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="DatoIncorrecto" type="varchar(40)" mandatory="no">
	<cf_dbtempcol name="ErrorNum" type="integer" mandatory="yes">
</cf_dbtemp>
<!--- Consultas Generales --->
<!--- Periodo--->
<cfquery name="rsPeriodo" datasource="#session.DSN#">
	select p1.Pvalor as value 
	 from Parametros p1 
	where Ecodigo = #session.Ecodigo#  
	and Pcodigo = 50
</cfquery>
<cfif (rsPeriodo.recordcount eq 0) or (rsPeriodo.recordcount gt 0 and  len(trim(rsPeriodo.value)) eq 0)>
	<cf_errorCode	code = "50078" msg = "No se encontró el periodo de auxiliares, Proceso Cancelado!">
</cfif>
<!--- Mes --->
<cfquery name="rsMes" datasource="#session.DSN#">
	select p1.Pvalor as value 
	 from Parametros p1 
	where Ecodigo = #session.Ecodigo#  
	and Pcodigo = 60
</cfquery>
<cfif (rsMes.recordcount eq 0) or (rsMes.recordcount gt 0 and 	len(trim(rsMes.value)) eq 0)>
	<cf_errorCode	code = "50079" msg = "No se encontró el mes de auxiliares, Proceso Cancelado!">
</cfif>
<!--- Obtiene la Moneda Local --->
<cfquery name="rsMoneda" datasource="#session.dsn#">
	select Mcodigo as value
	from Empresas 
	where Ecodigo =  #session.Ecodigo# 
</cfquery>
<cfif (rsMes.recordcount eq 0) or (rsMes.recordcount gt 0 and 	len(trim(rsMes.value)) eq 0)>
	<cf_errorCode	code = "50080"
					msg  = "No se encontró la moneda para la empresa @errorDat_1@, Proceso Cancelado!"
					errorDat_1="#session.Enombre#"
	>
</cfif>
<!--- 100. AGTPdescripcion: valida que no sea nulo. --->
<cfinvoke method="fnValida"
	Columna="AGTPdescripcion"
	Type="S"
	Tabla=""
	Filtro=""
	FiltroGral="AGTPdescripcion is null"
	Mensaje="'es nulo'"
	ErrorNum="100"/>
<!--- 200. AGTPrazon: valida que no sea nulo. --->
<cfinvoke method="fnValida"
	Columna="AGTPrazon"
	Type="S"
	Tabla=""
	Filtro=""
	FiltroGral="AGTPrazon is null"
	Mensaje="'es nulo'"
	ErrorNum="200"/>
<!--- 300. Aplaca: valida que no sea nulo. --->
<cfquery datasource="#session.dsn#">
	insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">, '400. Existe(n) ' #LvarOP_Concat# <cf_dbfunction name="to_char" args="count(1)"> #LvarOP_Concat# ' placa(s) en blanco.', <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">, 300
	from #table_name#
	where Aplaca is null
	having count(1) > 0
</cfquery>
<!--- 305. Aplaca: valida que no este repetida. --->
<cfquery datasource="#session.dsn#">
	insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select Aplaca, '410. La Placa se encuentra ' #LvarOP_Concat# <cf_dbfunction name="to_char" args="count(1)"> #LvarOP_Concat# ' veces en el Archivo' as Mensaje, 
	<cf_dbfunction name="to_char" args="Aplaca"> as DatoIncorrecto, 305 as ErrorNum
	from #table_name#
	where Aplaca is not null
	group by Aplaca
	having count(1) > 1
</cfquery>
<!--- 310. Aplaca: valida que no exista. --->
<cfinvoke method="fnValida"
	Columna="Aplaca"
	Type="S"
	Tabla="Activos"
	Filtro="Activos.Ecodigo = #session.Ecodigo# and Activos.Aplaca = #table_name#.Aplaca"
	Mensaje="'no existe para la empresa #session.Enombre#'"
	ErrorNum="310"/>
<!--- 320. Aplaca: valida que no este retirado para la empresa. --->
<cfinvoke method="fnValida"
	Columna="Aplaca"
	Type="S"
	Tabla=""
	Filtro=""
	FiltroGral="exists (select 1 from Activos where Activos.Ecodigo = #session.Ecodigo# and Activos.Aplaca = #table_name#.Aplaca and Activos.Astatus = 60)"
	Mensaje="'está retirado para la empresa #session.Enombre#'"
	ErrorNum="320"/>
<!--- 330. Aplaca: valida que no tenga saldos. --->
<cfinvoke method="fnValida"
	Columna="Aplaca"
	Type="S"
	Tabla="Activos inner join AFSaldos on AFSaldos.Ecodigo = Activos.Ecodigo and AFSaldos.Aid = Activos.Aid and AFSaldos.AFSperiodo = #rsPeriodo.value# and AFSaldos.AFSmes = #rsMes.value#"
	Filtro="Activos.Ecodigo = #session.Ecodigo# and Activos.Aplaca = #table_name#.Aplaca"
	Mensaje="'no tiene saldos para la empresa #session.Enombre# para el periodo #rsPeriodo.value#, mes #rsMes.value#'"
	ErrorNum="330"/>
<!--- 340. Aplaca: valida que no este en una transacción de Mejora. --->
<cfinvoke method="fnValida"
	Columna="Aplaca"
	Type="S"
	Tabla="Activos inner join ADTProceso on ADTProceso.Ecodigo = Activos.Ecodigo and ADTProceso.Aid = Activos.Aid and ADTProceso.IDtrans = 2"
	Filtro="Activos.Ecodigo = #session.Ecodigo# and Activos.Aplaca = #table_name#.Aplaca"
	Mensaje="'se encuentra en una realación de Mejora'"
	exists="true"
	ErrorNum="340"/>
<!--- 350. Aplaca: valida que no este en una transacción de Revaluacion. --->
<cfinvoke method="fnValida"
	Columna="Aplaca"
	Type="S"
	Tabla="Activos inner join ADTProceso on ADTProceso.Ecodigo = Activos.Ecodigo and ADTProceso.Aid = Activos.Aid and ADTProceso.IDtrans = 3"
	Filtro="Activos.Ecodigo = #session.Ecodigo# and Activos.Aplaca = #table_name#.Aplaca"
	Mensaje="'se encuentra en una realación de Mejora'"
	exists="true"
	ErrorNum="450"/>
<!--- 360. Aplaca: valida que no este en una transacción de Revaluacion. --->
<cfinvoke method="fnValida"
	Columna="Aplaca"
	Type="S"
	Tabla="Activos inner join ADTProceso on ADTProceso.Ecodigo = Activos.Ecodigo and ADTProceso.Aid = Activos.Aid and ADTProceso.IDtrans = 4"
	Filtro="Activos.Ecodigo = #session.Ecodigo# and Activos.Aplaca = #table_name#.Aplaca"
	Mensaje="'se encuentra en una realación de Depreciación'"
	exists="true"
	ErrorNum="460"/>	
<!--- 370. Aplaca: valida que no este en una transacción de retiro. --->
<cfinvoke method="fnValida"
	Columna="Aplaca"
	Type="S"
	Tabla="Activos inner join ADTProceso on ADTProceso.Ecodigo = Activos.Ecodigo and ADTProceso.Aid = Activos.Aid and ADTProceso.IDtrans = 5"
	Filtro="Activos.Ecodigo = #session.Ecodigo# and Activos.Aplaca = #table_name#.Aplaca"
	Mensaje="'se encuentra en una realación de retiro'"
	exists="true"
	ErrorNum="370"/>
<!--- 380. Aplaca: valida que no este en una transacción de Cambio Categoria/Clase. --->
<cfinvoke method="fnValida"
	Columna="Aplaca"
	Type="S"
	Tabla="Activos inner join ADTProceso on ADTProceso.Ecodigo = Activos.Ecodigo and ADTProceso.Aid = Activos.Aid and ADTProceso.IDtrans = 6"
	Filtro="Activos.Ecodigo = #session.Ecodigo# and Activos.Aplaca = #table_name#.Aplaca"
	Mensaje="'se encuentra en una realación de Cambio de Categoria-Clase pendiente'"
	exists="true"
	ErrorNum="380"/>
<!--- 390. Aplaca: valida que no este en una transacción de Traslado. --->
<cfinvoke method="fnValida"
	Columna="Aplaca"
	Type="S"
	Tabla="Activos inner join ADTProceso on ADTProceso.Ecodigo = Activos.Ecodigo and ADTProceso.Aid = Activos.Aid and ADTProceso.IDtrans = 8"
	Filtro="Activos.Ecodigo = #session.Ecodigo# and Activos.Aplaca = #table_name#.Aplaca"
	Mensaje="'se encuentra en una realación de Traslado'"
	exists="true"
	ErrorNum="390"/>
<!--- 391. Verifica que los Activos que vienen en el archivo, nos e encuentren dentro de la cola de AF. --->
<cfquery datasource="#session.dsn#">
	insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select a.Aplaca, '820. La Placa se encuentra dentro de la Cola de procesos de Activos Fijos en una transacción pendiente de aplicar' as Mensaje, 
	<cf_dbfunction name="to_char" args="a.Aplaca"> as DatoIncorrecto, 391 as ErrorNum
	from #table_name# a, Activos b				
	where a.Aplaca = b.Aplaca
	  and exists (	Select 1
					from CRColaTransacciones c
					where c.Aid = b.Aid)
</cfquery>
<!--- 400. Valida que la vida util no sea menor que cero. --->
<cfinvoke method="fnValida"
	Columna="TAvutil"
	Type="F"
	Tabla=""
	Filtro=""
	FiltroGral="TAvutil  < 0"
	Mensaje="'es menor que cero'"
	ErrorNum="400"/>
<!--- 500. Valida que el TAmontolocmej no sea menor que cero. --->
<cfinvoke method="fnValida"
	Columna="TAmontolocmej"
	Type="F"
	Tabla=""
	Filtro=""
	FiltroGral="TAmontolocmej  < 0"
	Mensaje="'es menor que cero'"
	ErrorNum="500"/>
<!--- Devuelve errores si los hay --->
<cfquery name="err" datasource="#session.dsn#">
	select Aplaca, Mensaje, DatoIncorrecto 
	from #AF_INICIO_ERROR#
	order by Aplaca, ErrorNum
</cfquery>
<!--- Si hay errores los devuelve, si no realiza el proceso de importación --->
<cfif (err.recordcount) EQ 0>
<!--- toma todos los datos a insertar y los pone en rs--->
							<cfquery name="rs" datasource="#session.DSN#">
								select t.AGTPdescripcion,t.AGTPrazon,t.TAmontolocmej,t.TAvutil, a.Aid
								from #table_name# t, Activos a
								where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and t.Aplaca= a.Aplaca
								order by t.AGTPdescripcion
							</cfquery>
							
							
							<cfset descripcionAct = "">
							<cfset AGTPid = 0>
							<cfset session.debug = false>
							
							<cfloop query="rs">
									
									<!--- Verifica si es la primera linea para crear encabezado o viene un encabezado nuevo --->
									<cfif (rs.CurrentRow EQ 1) or (descripcionAct NEQ rs.AGTPdescripcion)>								
										
										<!--- Insertar el encabezado --->
										<cfinvoke component="sif.Componentes.AF_MejoraActivos" method="AltaRelacion"
												returnvariable="rsResultadosRA">
											<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#">	
											<cfinvokeargument name="Conexion" value="#session.DSN#">
											<cfinvokeargument name="Usucodigo" value="#session.Usucodigo#">
											<cfinvokeargument name="AGTPdescripcion" value="#rs.AGTPdescripcion#">
											<cfinvokeargument name="AGTPrazon" value="#rs.AGTPrazon#">
											<cfinvokeargument name="debug" value="#session.debug#">
											<cfinvokeargument name="IPregistro" value="#session.sitio.ip#">
										</cfinvoke>
										<cfset AGTPid = rsResultadosRA>
										
										<cfset descripcionAct = rs.AGTPdescripcion>
									</cfif>
									
									<!--- Verifica la existencia de encabezado para crear detalles --->
									<cfif isdefined("AGTPid") and AGTPid NEQ 0>
										
										<!--- Insertar el detalle --->
										<cfset ADTPlinea =0> 
										<cfinvoke component="sif.Componentes.AF_MejoraActivos" method="AltaActivo"
											returnvariable="rsResultadosRE">
											<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#">	
											<cfinvokeargument name="Conexion" value="#session.DSN#">
											<cfinvokeargument name="AGTPid" value="#AGTPid#">
											<cfinvokeargument name="ADTPrazon" value="#rs.AGTPrazon#">
											<cfinvokeargument name="Aid" value="#rs.Aid#">
											<cfinvokeargument name="Usucodigo" value="#session.Usucodigo#">
											<cfinvokeargument name="debug" value="#session.debug#">
											<cfinvokeargument name="IPregistro" value="#session.sitio.ip#">
										</cfinvoke>
										
										<cfset ADTPlinea = rsResultadosRE> 
																				
										<cfif ADTPlinea neq "">
											<cfquery datasource="#session.dsn#">
												update ADTProceso
												set   TAmontolocmej = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(rs.TAmontolocmej,',','','all')#">,
													  TAvutil = <cfqueryparam cfsqltype="cf_sql_integer" value="#rs.TAvutil#">
												where 
													AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#AGTPid#">
													and ADTPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ADTPlinea#">
													and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
													and IDtrans = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.IDtrans#">
											</cfquery> 
										</cfif>	
									</cfif>
									
							</cfloop>	
</cfif>

