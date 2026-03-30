<!---*********************************************************************************************************************************************************************************************************************************************************************************************
Importación de Retiros de Activos Fijos
Fecha de Creación: 26/07/2006
Creado por: Dorian Abarca Gómez.
Columnas esperadas:
AGTPdescripcion AFRmotivo AGTPrazon Aplaca TAmontolocadq TAmontolocmej TAmontolocrev RetiroPorcentaje
Ejemplo de Archivo de Importación:

Comentarios de Programación:
0. Este importador ya existía pero estaba un poco desordenado e ineficiente se modificó para ordenarlo y corregir algunas validaciones (se hicieron validaciones masivas con resultados individuales por placa y tipo de error.). Esto dió problemas en el ICE y en Panamá.
1. Este programa es de Importación de un Archivo de Texto, y será utilizado para importar los Transacciones de Rerito de Activos Fijos, y dejarlas sin aplicar.
2. Primero se realizan las validaciones de cada dato, de manera masiva y si hay algún error será devuelto al usuario en una lista que indica, la Placa que contiene errores, y la lista de errores encontrados para esa Placa por línea.
3. Si todos los datos en el archivo son válidos y existen en la Base de Datos, se inicia el proceso.
4. Si se envía el porcentaje del retiro, se omiten los montos del retiro aun cuando se le halla enviado valores en el txt.
*********************************************************************************************************************************************************************************************************************************************************************************************--->
<!---►►►Funciona de Validación General de a existencia de un dato en la Base de Datos◄◄◄--->
<cffunction access="private" name="fnValida" output="false" returntype="boolean">
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
<!---►►►Valiable de Concatenación, Periodo Auxiliar, Mes Auxialir y Ultimo dia del Periodo/Mes Auxiliar◄◄◄--->
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetPeriodoAux" returnvariable="rsPeriodo.value"/>
<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetMesAux" 	returnvariable="rsMes.value"/>
<cfset rsFechaAux.value = CreateDate(rsPeriodo.value, rsMes.value, 01)>
<cfset rsFechaAux.value = DateAdd("m",1,rsFechaAux.value)>
<cfset rsFechaAux.value = DateAdd("d",-1,rsFechaAux.value)>
<!---►►►Tabla Temporal de Errores◄◄◄--->
<cf_dbtemp name="tempRetErro_v1" returnvariable="AF_INICIO_ERROR" datasource="#session.dsn#">
	<cf_dbtempcol name="Aplaca" 		type="char(20)"		mandatory="no">
	<cf_dbtempcol name="Mensaje" 		type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="DatoIncorrecto" type="varchar(40)" 	mandatory="no">
	<cf_dbtempcol name="ErrorNum" 		type="integer" 		mandatory="yes">
</cf_dbtemp>
<!---►►►Actualiza los montos de la tabla temporal que estan en nulo a 0◄◄◄--->
<cfquery datasource="#session.dsn#">
	update #table_name#
	set RetiroPorcentaje = case when RetiroPorcentaje is null then 0.00 else RetiroPorcentaje end
	   ,TAmontolocadq    = case when TAmontolocadq    is null then 0.00 else TAmontolocadq end
	   ,TAmontolocmej    = case when TAmontolocmej    is null then 0.00 else TAmontolocmej end
	   ,TAmontolocrev    = case when TAmontolocrev    is null then 0.00 else TAmontolocrev end	
	where RetiroPorcentaje is null or TAmontolocadq is null or TAmontolocmej is null or TAmontolocrev is null
</cfquery>
<!---►►►Obtiene la Moneda Local◄◄◄--->
<cfquery name="rsMoneda" datasource="#session.dsn#">
	select Mcodigo as value
	from Empresas 
	where Ecodigo =  #session.Ecodigo# 
</cfquery>
<cfif (rsMoneda.recordcount eq 0) or (rsMoneda.recordcount gt 0 and NOT len(trim(rsMoneda.value)))>
	<cf_errorCode	code = "50080"
					msg  = "No se encontró la moneda para la empresa @errorDat_1@, Proceso Cancelado!"
					errorDat_1="#session.Enombre#"
	>
</cfif>
<!---►►►Cuando se envia el Porcentaje de Retiro se Actualizan los montos a depreciar (Monto porcentual de los Saldos)◄◄◄--->
<cfquery name="rsThisRelacionItems" datasource="#session.dsn#">
   select a.Aplaca, a.RetiroPorcentaje, c.AFSvaladq, c.AFSvalmej, c.AFSvalrev 
     from #table_name# a
     	inner join Activos b
        	 on b.Aplaca  = a.Aplaca
            and b.Ecodigo = #session.Ecodigo#
     	inner join AFSaldos c
        	on c.Aid 		 = b.Aid            
            and c.AFSperiodo = #rsPeriodo.value#             
            and c.AFSmes 	 = #rsMes.value#      
      where b.Astatus != 60           
       and a.Aplaca is not null      
       and a.RetiroPorcentaje between 1 and 100
</cfquery>
<cfloop query="rsThisRelacionItems">
    <cfquery datasource="#session.dsn#">
        update #table_name#
          set TAmontolocadq = #rsThisRelacionItems.AFSvaladq# / 100* #rsThisRelacionItems.RetiroPorcentaje#
            , TAmontolocmej = #rsThisRelacionItems.AFSvalmej# / 100* #rsThisRelacionItems.RetiroPorcentaje#
            , TAmontolocrev = #rsThisRelacionItems.AFSvalrev# / 100* #rsThisRelacionItems.RetiroPorcentaje#
        where Aplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsThisRelacionItems.Aplaca#"> 
    </cfquery>
</cfloop>
<!--- 100. AGTPdescripcion: valida que no sea nulo. --->
<cfinvoke method="fnValida"
	Columna="AGTPdescripcion"
	Type="S"
	Tabla=""
	Filtro=""
	FiltroGral="AGTPdescripcion is null"
	Mensaje="'es nulo'"
	ErrorNum="100"/>
<!--- 200. AFRmotivo: valida que no sea nulo. --->
<cfinvoke method="fnValida"
	Columna="AFRmotivo"
	Type="S"
	Tabla=""
	Filtro=""
	FiltroGral="AFRmotivo is null"
	Mensaje="'es nulo'"
	ErrorNum="200"/>
<!--- 210. AFRmotivo: valida exista. --->
<cfinvoke method="fnValida"
	Columna="AFRmotivo"
	Type="S"
	Tabla="AFRetiroCuentas"
	Filtro="AFRetiroCuentas.Ecodigo = #session.Ecodigo# and AFRetiroCuentas.AFRmotivo = #table_name#.AFRmotivo"
	Mensaje="'no existe para la empresa #session.Enombre#'"
	ErrorNum="210"/>
<!--- 220. AFRmotivo: valida exista. --->
<cfinvoke method="fnValida"
	Columna="AFRmotivo"
	Type="S"
	Tabla="AFRetiroCuentas"
	Filtro="AFRetiroCuentas.Ecodigo = #session.Ecodigo# and AFRetiroCuentas.AFRmotivo = #table_name#.AFRmotivo and AFResventa in ('S','s')"
	exists="true"
	Mensaje="'es un retiro por venta, este tipo de retiro no está permitido en el importador'"
	ErrorNum="220"/>
<!--- 300. AGTPrazon: no se valida. --->
<!--- 400. Aplaca: valida que no sea nulo. --->
<cfquery datasource="#session.dsn#">
	insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select <cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">, 
	'400. Existe(n) '#_Cat# <cf_dbfunction name="to_char" args="count(1)">#_Cat#' placa(s) en blanco.', 
	<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">, 
	400
	from #table_name#
	where Aplaca is null
	having count(1) > 0
</cfquery>
<!--- 410. Aplaca: valida que no este repetida. --->
<cfquery datasource="#session.dsn#">
	insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select Aplaca, 
	'410. La Placa se encuentra '#_Cat#	<cf_dbfunction name="to_char" args="count(1)"> #_Cat# ' veces en el Archivo' as Mensaje, 
	<cf_dbfunction name="to_char" args="Aplaca"> as DatoIncorrecto, 
	410 as ErrorNum
	from #table_name#
	where Aplaca is not null
	group by Aplaca
	having count(1) > 1
</cfquery>
<!--- 420. Aplaca: valida que no exista. --->
<cfinvoke method="fnValida"
	Columna="Aplaca"
	Type="S"
	Tabla="Activos"
	Filtro="Activos.Ecodigo = #session.Ecodigo# and Activos.Aplaca = #table_name#.Aplaca"
	Mensaje="'no existe para la empresa #session.Enombre#'"
	ErrorNum="420"/>
<!--- 430. Aplaca: valida que no este retirado para la empresa. --->
<cfinvoke method="fnValida"
	Columna="Aplaca"
	Type="S"
	Tabla=""
	Filtro=""
	FiltroGral="exists (select 1 from Activos where Activos.Ecodigo = #session.Ecodigo# and Activos.Aplaca = #table_name#.Aplaca and Activos.Astatus = 60)"
	Mensaje="'está retirado para la empresa #session.Enombre#'"
	ErrorNum="430"/>
<!--- 440. Aplaca: valida que no tenga saldos. --->
<cfinvoke method="fnValida"
	Columna="Aplaca"
	Type="S"
	Tabla="Activos inner join AFSaldos on AFSaldos.Ecodigo = Activos.Ecodigo and AFSaldos.Aid = Activos.Aid and AFSaldos.AFSperiodo = #rsPeriodo.value# and AFSaldos.AFSmes = #rsMes.value#"
	Filtro="Activos.Ecodigo = #session.Ecodigo# and Activos.Aplaca = #table_name#.Aplaca"
	Mensaje="'no tiene saldos para la empresa #session.Enombre# para el periodo #rsPeriodo.value#, mes #rsMes.value#'"
	ErrorNum="440"/>
<!--- 450. Aplaca: valida que no este en una transacción de Mejora. --->
<cfinvoke method="fnValida"
	Columna="Aplaca"
	Type="S"
	Tabla="Activos inner join ADTProceso on ADTProceso.Ecodigo = Activos.Ecodigo and ADTProceso.Aid = Activos.Aid and ADTProceso.IDtrans = 2"
	Filtro="Activos.Ecodigo = #session.Ecodigo# and Activos.Aplaca = #table_name#.Aplaca"
	Mensaje="'se encuentra en una realación de Mejora'"
	exists="true"
	ErrorNum="450"/>
<!--- 460. Aplaca: valida que no este en una transacción de Revaluacion. --->
<cfinvoke method="fnValida"
	Columna="Aplaca"
	Type="S"
	Tabla="Activos inner join ADTProceso on ADTProceso.Ecodigo = Activos.Ecodigo and ADTProceso.Aid = Activos.Aid and ADTProceso.IDtrans = 3"
	Filtro="Activos.Ecodigo = #session.Ecodigo# and Activos.Aplaca = #table_name#.Aplaca"
	Mensaje="'se encuentra en una realación de Mejora'"
	exists="true"
	ErrorNum="460"/>
<!--- 470. Aplaca: valida que no este en una transacción de Revaluacion. --->
<cfinvoke method="fnValida"
	Columna="Aplaca"
	Type="S"
	Tabla="Activos inner join ADTProceso on ADTProceso.Ecodigo = Activos.Ecodigo and ADTProceso.Aid = Activos.Aid and ADTProceso.IDtrans = 4"
	Filtro="Activos.Ecodigo = #session.Ecodigo# and Activos.Aplaca = #table_name#.Aplaca"
	Mensaje="'se encuentra en una realación de Depreciación'"
	exists="true"
	ErrorNum="470"/>	
<!--- 480. Aplaca: valida que no este en una transacción de retiro. --->
<cfinvoke method="fnValida"
	Columna="Aplaca"
	Type="S"
	Tabla="Activos inner join ADTProceso on ADTProceso.Ecodigo = Activos.Ecodigo and ADTProceso.Aid = Activos.Aid and ADTProceso.IDtrans = 5"
	Filtro="Activos.Ecodigo = #session.Ecodigo# and Activos.Aplaca = #table_name#.Aplaca"
	Mensaje="'se encuentra en una realación de retiro'"
	exists="true"
	ErrorNum="480"/>
<!--- 490. Aplaca: valida que no este en una transacción de Cambio Categoria/Clase. --->
<cfinvoke method="fnValida"
	Columna="Aplaca"
	Type="S"
	Tabla="Activos inner join ADTProceso on ADTProceso.Ecodigo = Activos.Ecodigo and ADTProceso.Aid = Activos.Aid and ADTProceso.IDtrans = 6"
	Filtro="Activos.Ecodigo = #session.Ecodigo# and Activos.Aplaca = #table_name#.Aplaca"
	Mensaje="'se encuentra en una realación de Cambio de Categoria-Clase pendiente'"
	exists="true"
	ErrorNum="490"/>
<!--- 491. Aplaca: valida que no este en una transacción de Traslado. --->
<cfinvoke method="fnValida"
	Columna="Aplaca"
	Type="S"
	Tabla="Activos inner join ADTProceso on ADTProceso.Ecodigo = Activos.Ecodigo and ADTProceso.Aid = Activos.Aid and ADTProceso.IDtrans = 8"
	Filtro="Activos.Ecodigo = #session.Ecodigo# and Activos.Aplaca = #table_name#.Aplaca"
	Mensaje="'se encuentra en una realación de Traslado'"
	exists="true"
	ErrorNum="491"/>
<!--- 500. TAmontolocadq: Se valida que sea mayor que 0. --->
<cfinvoke method="fnValida"
	Columna="TAmontolocadq"
	Type="M"
	Tabla=""
	Filtro=""
	FiltroGral="(TAmontolocadq < 0.00)"
	Mensaje="'es menor que cero'"
	ErrorNum="500"/>
<!--- 510. TAmontolocadq: Se valida que sea menor o igual que AFSvaladq. --->
<cfquery datasource="#session.dsn#">
	insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select a.Aplaca, 
    	'510. El monto a retirar en la Adquisición ('#_Cat# <cf_dbfunction name="to_char" args="a.TAmontolocadq"> #_Cat# '( es menor al Valor de Adquisición del Activo('#_Cat# <cf_dbfunction name="to_char" args="c.AFSvaladq"> as Mensaje, 
	<cf_dbfunction name="to_char" args="a.Aplaca"> as DatoIncorrecto, 510 as ErrorNum
	 from #table_name# a
    	inner join Activos b
        	 on b.Aplaca  = a.Aplaca
            and b.Ecodigo = #session.Ecodigo#
        inner join AFSaldos c        	 
        	on c.Aid 		 = b.Aid            
            and c.AFSperiodo = #rsPeriodo.value#             
            and c.AFSmes 	 = #rsMes.value#      
            where b.Astatus != 60           
            and a.Aplaca is not null        
            and a.TAmontolocadq > c.AFSvaladq    
</cfquery>
<!--- 600. TAmontolocmej: Se valida que sea mayor que 0. --->
<cfinvoke method="fnValida"
	Columna="TAmontolocmej"
	Type="M"
	Tabla=""
	Filtro=""
	FiltroGral="(TAmontolocmej < 0.00)"
	Mensaje="'es menor que cero'"
	ErrorNum="600"/>
<!--- 610. TAmontolocmej: Se valida que sea menor o igual que AFSvalmej. --->
<cfquery datasource="#session.dsn#">
	insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select a.Aplaca, '610. El monto a retirar en la Mejora ('#_Cat# <cf_dbfunction name="to_char" args="a.TAmontolocmej"> #_Cat# '( es menor al Valor de Mejora del Activo('#_Cat# <cf_dbfunction name="to_char" args="c.AFSvalmej"> as Mensaje, 
	<cf_dbfunction name="to_char" args="a.Aplaca"> as DatoIncorrecto, 610 as ErrorNum
	 from #table_name# a
    	inner join Activos b
        	 on b.Aplaca  = a.Aplaca
            and b.Ecodigo = #session.Ecodigo#
        inner join AFSaldos c        	 
        	on c.Aid 		 = b.Aid            
            and c.AFSperiodo = #rsPeriodo.value#             
            and c.AFSmes 	 = #rsMes.value#      
            where b.Astatus != 60           
            and a.Aplaca is not null        
            and a.TAmontolocmej > c.AFSvalmej    
</cfquery>
<!--- 710. TAmontolocmej: Se valida que sea menor o igual que AFSvalmej. --->
<cfquery datasource="#session.dsn#">
	insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select a.Aplaca, '710. El monto a retirar en la revaluación ('#_Cat# <cf_dbfunction name="to_char" args="a.TAmontolocrev"> #_Cat# '( es menor al Valor de Reevaluación del Activo('#_Cat# <cf_dbfunction name="to_char" args="c.AFSvalrev"> as Mensaje, 
	<cf_dbfunction name="to_char" args="a.Aplaca"> as DatoIncorrecto, 710 as ErrorNum
	 from #table_name# a
    	inner join Activos b
        	 on b.Aplaca  = a.Aplaca
            and b.Ecodigo = #session.Ecodigo#
        inner join AFSaldos c        	 
        	on c.Aid 		 = b.Aid            
            and c.AFSperiodo = #rsPeriodo.value#             
            and c.AFSmes 	 = #rsMes.value#      
            where b.Astatus != 60           
            and a.Aplaca is not null        
            and a.TAmontolocrev > c.AFSvalrev    
</cfquery>    
<!--- 800. RetiroPorcentaje: Se valida que el porcentaje sea mayor que 0 cuando los valores de retiro están en 0. --->
<cfinvoke method="fnValida"
	Columna="RetiroPorcentaje"
	Type="F"
	Tabla=""
	Filtro=""
	FiltroGral="(RetiroPorcentaje = 0 and TAmontolocadq = 0
				and TAmontolocmej = 0 and TAmontolocrev = 0)"
	Mensaje="'es nulo o cero, y los montos de retiro también, se requiere que el porcentaje de retiro sea mayor que cero cuando los montos del retiro son cero'"
	ErrorNum="800"/>
<!--- 810. RetiroPorcentaje: Se valida que el porcentaje sea mayor o igual que 0 y menor o igual que 100. --->
<cfinvoke method="fnValida"
	Columna="RetiroPorcentaje"
	Type="F"
	Tabla=""
	Filtro=""
	FiltroGral="(RetiroPorcentaje < 0.00 or RetiroPorcentaje > 100.00)"
	Mensaje="'es menor que cero o mayor que cien'"
	ErrorNum="810"/>
<!--- 820. Verifica que los Activos que vienen en el archivo, nos e encuentren dentro de la cola de AF. --->
<cfquery datasource="#session.dsn#">
	insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select a.Aplaca, '820. La Placa se encuentra dentro de la Cola de procesos de Activos Fijos en una transacción pendiente de aplicar' as Mensaje, 
	<cf_dbfunction name="to_char" args="a.Aplaca"> as DatoIncorrecto, 820 as ErrorNum
	from #table_name# a, Activos b				
	where a.Aplaca = b.Aplaca
	  and exists (	Select 1
					from CRColaTransacciones c
					where c.Aid = b.Aid)
</cfquery>
<!--- Devuelve errores si los hay --->
<cfquery name="err" datasource="#session.dsn#">
	select Aplaca, Mensaje, DatoIncorrecto 
	from #AF_INICIO_ERROR#
	order by Aplaca, ErrorNum
</cfquery>
<!--- Si hay errores los devuelve, si no realiza el proceso de importación --->
<cfif (err.recordcount) EQ 0>
	<cfquery name="rsRelaciones" datasource="#session.dsn#">
		select distinct AGTPdescripcion from #table_name#
	</cfquery>
	<cftransaction>
		<cfloop list="#ValueList(rsRelaciones.AGTPdescripcion)#" index="thisAGTPdescripcion">
			<cfquery name="rsThisRelacion" datasource="#session.dsn#" maxrows="1">
				select AFRmotivo, AGTPrazon 
                	from #table_name# 
                 where AGTPdescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#thisAGTPdescripcion#">
			</cfquery>
			<cfinvoke component="sif.Componentes.AF_RetiroActivos" method="AltaRelacion"returnvariable="thisAGTPid">
				<cfinvokeargument name="AGTPdescripcion" 	value="#thisAGTPdescripcion#">
				<cfinvokeargument name="AFRmotivo" 			value="#rsThisRelacion.AFRmotivo#">
				<cfinvokeargument name="AGTPrazon" 			value="#rsThisRelacion.AGTPrazon#">
				<cfinvokeargument name="TransaccionActiva"  value="true">
			</cfinvoke>
			<cfquery name="rsThisRelacionItems" datasource="#session.dsn#">
				select b.Aid, a.AGTPrazon as ADTPrazon, a.TAmontolocadq, a.TAmontolocmej, a.TAmontolocrev, a.RetiroPorcentaje
				  from #table_name# a
                  	inner join Activos b
                    	 on b.Aplaca  = a.Aplaca
                        and b.Ecodigo = #session.Ecodigo#
                 where AGTPdescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#thisAGTPdescripcion#">
			</cfquery>
			<cfloop query="rsThisRelacionItems">
				<!---►►Inserta Activo por Activo, Colocando el monto de Retiro el 100% del Retiro◄◄--->
                <cfinvoke component="sif.Componentes.AF_RetiroActivos" method="AltaActivo" returnvariable="thisADTPlinea">
					<cfinvokeargument name="AGTPid" 		   value="#thisAGTPid#">
					<cfinvokeargument name="ADTPrazon" 		   value="#rsThisRelacionItems.ADTPrazon#">
					<cfinvokeargument name="Aid"			   value="#rsThisRelacionItems.Aid#">
					<cfinvokeargument name="TransaccionActiva" value="true">
				</cfinvoke>
				<cfif rsThisRelacionItems.RetiroPorcentaje GT 0.00 and rsThisRelacionItems.RetiroPorcentaje LT 100.00>
					<cfquery datasource="#session.dsn#">
						update ADTProceso
						 set TAmontolocadq  = TAmontolocadq/100* <cfqueryparam cfsqltype="cf_sql_money" value="#rsThisRelacionItems.RetiroPorcentaje#">
							, TAmontolocmej = TAmontolocmej/100* <cfqueryparam cfsqltype="cf_sql_money" value="#rsThisRelacionItems.RetiroPorcentaje#">
							, TAmontolocrev = TAmontolocrev/100* <cfqueryparam cfsqltype="cf_sql_money" value="#rsThisRelacionItems.RetiroPorcentaje#">
							
							, TAmontodepadq = TAmontodepadq/100* <cfqueryparam cfsqltype="cf_sql_money" value="#rsThisRelacionItems.RetiroPorcentaje#">
							, TAmontodepmej = TAmontodepmej/100* <cfqueryparam cfsqltype="cf_sql_money" value="#rsThisRelacionItems.RetiroPorcentaje#">
							, TAmontodeprev = TAmontodeprev/100* <cfqueryparam cfsqltype="cf_sql_money" value="#rsThisRelacionItems.RetiroPorcentaje#">
						where AGTPid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#thisAGTPid#">
						  and ADTPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#thisADTPlinea#">
						  and Ecodigo   = #session.Ecodigo# 
						  and IDtrans   = <cfqueryparam cfsqltype="cf_sql_numeric" value="5">
					</cfquery>	
				<cfelseif (rsThisRelacionItems.TAmontolocadq GT 0.00) or (rsThisRelacionItems.TAmontolocmej GT 0.00) or (rsThisRelacionItems.TAmontolocrev GT 0.00)>
					<cfquery datasource="#session.dsn#">
						update ADTProceso
						set TAmontolocadq   = case when TAmontolocadq = <cfqueryparam cfsqltype="cf_sql_money" value="#rsThisRelacionItems.TAmontolocadq#"> then TAmontolocadq else <cfqueryparam cfsqltype="cf_sql_money" value="#rsThisRelacionItems.TAmontolocadq#"> end
							, TAmontolocmej = case when TAmontolocmej = <cfqueryparam cfsqltype="cf_sql_money" value="#rsThisRelacionItems.TAmontolocmej#"> then TAmontolocmej else <cfqueryparam cfsqltype="cf_sql_money" value="#rsThisRelacionItems.TAmontolocmej#"> end
							, TAmontolocrev = case when TAmontolocrev = <cfqueryparam cfsqltype="cf_sql_money" value="#rsThisRelacionItems.TAmontolocrev#"> then TAmontolocrev else <cfqueryparam cfsqltype="cf_sql_money" value="#rsThisRelacionItems.TAmontolocrev#"> end
							
							, TAmontodepadq = case 	when TAmontolocadq = <cfqueryparam cfsqltype="cf_sql_money" value="#rsThisRelacionItems.TAmontolocadq#"> then TAmontodepadq else TAmontodepadq/TAmontolocadq*<cfqueryparam cfsqltype="cf_sql_money" value="#rsThisRelacionItems.TAmontolocadq#"> end
							, TAmontodepmej = case when TAmontolocmej  = <cfqueryparam cfsqltype="cf_sql_money" value="#rsThisRelacionItems.TAmontolocmej#"> then TAmontodepmej else TAmontodepmej/TAmontolocmej*<cfqueryparam cfsqltype="cf_sql_money" value="#rsThisRelacionItems.TAmontolocmej#"> end
							, TAmontodeprev = case when TAmontolocrev  = <cfqueryparam cfsqltype="cf_sql_money" value="#rsThisRelacionItems.TAmontolocrev#"> then TAmontodeprev else TAmontodeprev/TAmontolocrev*<cfqueryparam cfsqltype="cf_sql_money" value="#rsThisRelacionItems.TAmontolocrev#"> end
						where AGTPid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#thisAGTPid#">
						  and ADTPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#thisADTPlinea#">
						  and Ecodigo   =  #session.Ecodigo# 
						  and IDtrans   = <cfqueryparam cfsqltype="cf_sql_numeric" value="5">
					</cfquery>	
				</cfif>
			</cfloop>
		</cfloop>
	</cftransaction>
</cfif>