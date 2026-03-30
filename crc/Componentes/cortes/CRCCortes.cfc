<cfcomponent output="false" access="" displayname="CRCCortes" hint="componente base para creacion de cortes">

	<!--- tipo de corte (D,TC,TM)" --->
	<cfset This.TipoCorte = "">
	<cfset This.conexion  = "">
	<cfset This.ECodigo   = "">

	<cfset This.TC_Distribudidor = "D">
	<cfset This.TC_Mayorista     = "TM">
	<cfset This.TC_Tarjeta       = "TC">


	<cfset This.fechaFinUltimoCorte = "">
	
	<cfset This.C_CORTE_STATUS_CALCULADO = "1">
	<cfset This.vFechaActual = true>

	<cfset This.desdeImportador = 0>

	 
    <cffunction name="init" output="false" returntype="CRCCortes" hint="constructor del componente">
		<cfargument name="TipoCorte"          type="string"> 
		<cfargument name="conexion"           type="string"  required="false" default="#session.dsn#"> 
		<cfargument name="ECodigo"  		  type="string"  required="false" default="#session.Ecodigo#"> 
		 
		<cfset This.TipoCorte 		  = #arguments.TipoCorte#> 
		<cfset This.conexion 		  = #arguments.conexion#>
		<cfset This.ECodigo   		  = #arguments.ECodigo#> 
		<cfreturn This>

    </cffunction>	

 
	<cffunction name="CreaCortes" access="private"  returntype="array" hint="funcion para la creacion de cortes">
		<cfargument name="fecha" 	 	 type="date" 	required="true" hint="fecha inicial donde se pidio un corte">    
   		<cfargument name="parcialidades" type="numeric" required="true">
 
 		<!--no se pueden crear cortes con fecha menor a la fecha actual-->
 		<!---cfset fechaActual = CreateDate(DatePart('yyyy',now()), DatePart('m',now()),DatePart('d',now()))>
 		<cfset comparision = DateCompare(arguments.fecha, #fechaActual#,"d")>
 		<cfif comparision eq -1>
 			<cfthrow type="CRCortesException" message="La fecha de corte no puede ser menor a la fecha actual">
 		</cfif --->

		<!---se incrementa la fecha de operacion para generar información de cortes posterior a la operacion y lograr tener la informacion de las fechas de calculo de saldo vencido --->
		<cfset loc.fechafin = DateAdd("m",parcialidades + 6,arguments.fecha)>
 		
		<!-- busqueda del ultimo corte generado-->
		<cfquery name="rsUltimoCorte" datasource="#This.conexion#">
			select top 1 Codigo, FechaFin, FechaInicio
			from  CRCCortes
			where Ecodigo = #This.ECodigo#
			and   Tipo    = '#This.TipoCorte#'
			order by FechaFin DESC
		</cfquery>

		<!--- fecha inicial con la fecha actual---> 
		<cfset initDate = '' >
		<cfif This.vFechaActual eq true>
			<cfset initDate = CreateDate(DatePart('yyyy',now()), DatePart('m',now()),DatePart('d',now()))>  
		<cfelse>
			<cfset initDate = CreateDate(DatePart('yyyy',arguments.fecha), DatePart('m',arguments.fecha),DatePart('d',arguments.fecha))>  
		</cfif>
		<cfif rsUltimoCorte.recordCount gt 0 and This.desdeImportador eq 0> 
			<cfset This.fechaFinUltimoCorte  = rsUltimoCorte.FechaFin>
			<cfset initDate = dateadd('d',1,rsUltimoCorte.FechaFin)>
			<cfset loc.fechafin = DateAdd("m",parcialidades + 6,rsUltimoCorte.FechaFin)>  
		<cfelse>
			<cfset initDate = dateadd('m',-1,initDate)> 
		</cfif>  
		<cfset LvarMesIni = DatePart('m', initDate)>
		
		<cfset loc.listaCortesExistentes = cortesExistentes(initDate=initDate, endDate=loc.fechaFin)>

		<!-- anio inicio y fin de los cortes a generar-->
		<cfset LvarAnioIni = DatePart('yyyy', initDate)>
		<cfset LvarAnioFin = DatePart('yyyy', loc.fechafin)>

		<!-- mes final-->
		<cfset LvarMesFin = DatePart('m', loc.fechafin)>
		<cfset loopInit   = "#LvarAnioIni##right('00'&LvarMesIni,2)#">
		<cfset loopFin    = "#LvarAnioFin##right('00'&LvarMesFin,2)#">
		 
		<cfreturn _CreaCortes(LvarMesIni, LvarMesFin, LvarAnioIni, LvarAnioFin,loc.listaCortesExistentes)>
 
	</cffunction>

	<cffunction name="_CreaCortes" access="package" returntype="array" hint="funcion para crear cortes, los componentes
	que herenden de este, deben sobre escribir esta funcion">
		<cfargument name="LvarMesIni"   type="string" required="true">
		<cfargument name="LvarMesFin"   type="string" required="true">
		<cfargument name="LvarAnioIni"  type="string" required="true">
		<cfargument name="LvarAnioFin"  type="string" required="true"> 
		<cfargument name="listaCortesExistentes" type="string"  required="false" default="">  
	</cffunction>

	<cffunction name="cortesExistentes" access="public">
		<arguments name="initDate" required="true" type="date">
		<arguments name="endDate"  required="true" type="date"> 


		<cfquery name="qCorteExist" datasource="#this.conexion#">
			select Codigo
			from CRCCortes
			where Ecodigo  = #This.Ecodigo#
			and   Tipo     =  '#This.TipoCorte#'  
		</cfquery>

		<cfset loc.cortesExistentes = "">
		<cfloop query = "qCorteExist"> 
			<cfset loc.cortesExistentes = ListAppend(loc.cortesExistentes,qCorteExist.codigo)>  
		</cfloop>
  
		<cfreturn loc.cortesExistentes>		

	</cffunction>

	<cffunction name="GetCorte" access="public" returntype="string" hint="Devuelve el codigo de corte por tipo y donde la fecha pasada como parametro este entre las fechas de inicio y fecha fin">
		<cfargument name="fecha"      type="date"    required="true">  
		<cfargument name="TipoCorte"  type="string"  required="no" default="#This.TipoCorte#">  
		<cfargument name="dsn"        type="string"  required="no" default="#This.conexion#">  
		<cfargument name="ecodigo"    type="numeric" required="no" default="#This.Ecodigo#">  
		<cfargument name="SNid"        type="numeric"  required="no" default="0">  
 
		<cfset loc.fecha = arguments.fecha>

 		<cfif This.desdeImportador eq 1>
			<!--- pude ser que la fecha caiga en un dia en que se mueve la fecha para el corte--->
			<cfset crcParametros = createobject("component","crc.Componentes.CRCParametros")>
			<cfset loc.adcorte = crcParametros.GetParametro(codigo='#loc.CPARAM_DIA_ADELANTO_CORTE#',conexion=#This.conexion#,ecodigo=#This.ecodigo#)>
			<cfset loc.diacorteD1 = crcParametros.GetParametro(codigo='30000601',conexion=#This.conexion#,ecodigo=#This.ecodigo#)>
			<cfset loc.diacorteD2 = crcParametros.GetParametro(codigo='30000602',conexion=#This.conexion#,ecodigo=#This.ecodigo#)>
			<cfset loc.diacorteTC = crcParametros.GetParametro(codigo='30000603',conexion=#This.conexion#,ecodigo=#This.ecodigo#)>
			
			<cfif loc.adcorte neq "">

				<cfif DayOfWeek(CreatedateB(DatePart('yyyy',#loc.fecha#), DatePart('m',#loc.fecha#), DatePart('d',#loc.fecha#))) eq loc.adcorte
					and ((arguments.TipoCorte eq 'D' and (DatePart('d',#loc.fecha#) eq loc.diacorteD1 or DatePart('d',#loc.fecha#) eq loc.diacorteD2))
						or (arguments.TipoCorte eq 'TC' and (DatePart('d',#loc.fecha#) eq loc.diacorteTC )))>
					<cfset temopFecha = dateAdd('d', -1, loc.fecha)>	
					<cfset loc.fecha = CreatedateB(DatePart('yyyy',#temopFecha#), 
												   DatePart('m',#temopFecha#), 
											 	   DatePart('d',#temopFecha#))> 
				</cfif>
			</cfif>  
 		</cfif>
		

		<cfquery name="rsCorte" datasource="#arguments.dsn#">
			select top 1 Codigo
			from CRCCortes
			where Ecodigo = #arguments.Ecodigo#
				 and Tipo = '#arguments.TipoCorte#'
				 <cfif arguments.TipoCorte eq 'TM'>
					and Codigo like '%-#arguments.SNid#'
					and datediff(day,<cfqueryparam value ="#loc.fecha#" cfsqltype="cf_sql_date">,FechaInicio) = 0
				 <cfelse>
				 	and  <cfqueryparam value ="#loc.fecha#" cfsqltype="cf_sql_date"> between FechaInicio and FechaFin
				 </cfif>
		</cfquery>
   
		<cfif rsCorte.recordCount gt 0>
			<cfreturn rsCorte.Codigo>
		<cfelse>  
			<cfreturn ''>
		</cfif>
	</cffunction>

	<cffunction name="_GetCorteCodigos" access="private" returntype="string" hint="Devuelve los codigos de los cortes a partir de la fecha pasada como parametros y la cantidad de cortes específicos">
		<cfargument name="fecha" type="date" required="true">
		<cfargument name="cantidadCortes" type="numeric" required="true">  

		<cfquery name="rsCortes" datasource="#This.conexion#">
			select top #arguments.cantidadCortes# codigo,FechaInicio, FechaFin
			from CRCCortes
			where Ecodigo = #This.Ecodigo#
			and   Tipo    = '#This.TipoCorte#'
			and  (
					<cfif #This.desdeImportador# eq 1>
						FechaInicio <= <cfqueryparam value ="#arguments.fecha#" cfsqltype="cf_sql_date">   
									and FechaFin > <cfqueryparam value ="#arguments.fecha#" cfsqltype="cf_sql_date"> 
                    <cfelse>
			 			FechaFin >= <cfqueryparam value ="#arguments.fecha#" cfsqltype="cf_sql_date">
						<cfif #This.TipoCorte# eq 'D' >
							or (FechaInicio <= <cfqueryparam value ="#arguments.fecha#" cfsqltype="cf_sql_date">   
									and FechaFin > <cfqueryparam value ="#arguments.fecha#" cfsqltype="cf_sql_date"> )  
						</cfif>
					</cfif>
			)
			order by FechaFin asc
		</cfquery>

		<cfset loc.cortes = "">
		<cfloop query = "rsCortes"> 
			<cfset loc.cortes = ListAppend(loc.cortes,rsCortes.codigo)>  
		</cfloop>

		<cfreturn loc.cortes>
	</cffunction>

 
	<cffunction name="GetCorteCodigos" access="public" returntype="string" hint="Devuelve string de cortes separados por coma dado una fecha, tipo de productos y cantidad parcialidades">
		<cfargument name="fecha"    	   type="date"    required="true"> 
		<cfargument name="parcialidades"   type="numeric" required="true"> 
 
		<cfset fechaCortes = CreateDate(DatePart('yyyy',arguments.fecha), DatePart('m',arguments.fecha),DatePart('d',arguments.fecha))>

		<!-- buscar todos los cortes deseados, segun parametro paracialidades -->
		<cfset loc.cortes = _GetCorteCodigos(fecha=#fechaCortes#, cantidadCortes=arguments.parcialidades)>
		<cfset cantCortesEncontrados = listLen(loc.cortes,',',false)>
		<cfif cantCortesEncontrados eq #arguments.parcialidades#>
			<cfreturn loc.cortes>
		</cfif>

		<!--- este es el caso en que no hay cortes suficientes para las parcialidades que se necesitan
		Se tienen en cuanta dos temas.
	    1. Cuantas parcialidades faltan por generar.
	    2. Si es un corte a futuro generar los cortes anteriores sino existen --->
	    <cfset cantCortesRestantes = #arguments.parcialidades# - #cantCortesEncontrados#>

		<cfset CreaCortes(fecha=#fechaCortes#, parcialidades=cantCortesRestantes)>
  
 		<cfreturn _GetCorteCodigos(fecha=#fechaCortes#, cantidadCortes=arguments.parcialidades)>
 		 
	</cffunction>	


	<cffunction name="insertCorte" access="private" hint="funcion para insertar registro de corte en la base de datos"> 
		<cfargument name="LvarCodigo"     type="string"   required="true">
		<cfargument name="FechaInicio"    type="date" 	  required="true">
		<cfargument name="FechaFin"       type="date" 	  required="true">
		<cfargument name="cerrado"     	  type="numeric"  required="true">  
		<cfargument name="FechaInicioSV"  type="date"     required="true">  
		<cfargument name="FechaFinSV"     type="date"     required="true">  
		<cfargument name="status"     	  type="string"   required="false" default="0"> 

 
    	<cfquery name="rsParam"  datasource="#This.conexion#">
			insert into CRCCortes(Codigo,FechaInicio,FechaFin,Cerrado,Tipo,Ecodigo, FechaInicioSV, FechaFinSV,status)
			values('#arguments.LvarCodigo#',#arguments.FechaInicio#,#arguments.FechaFin#,#arguments.cerrado#,'#This.TipoCorte#',#This.Ecodigo#,#arguments.FechaInicioSV#,#arguments.FechaFinSV#, '#arguments.status#')
		</cfquery>	 
	</cffunction>


	<cffunction name="ProximoCorte" access="public" returntype="string" hint="funcion para cerrar un corte en especifico">
		<cfargument name="corte"  type="string"  required="true">
		<cfargument name="estado" type="string"  required="false" default="0">
 
		<cfquery name="qCorte" datasource="#This.conexion#">
			select FechaFin 
			from  CRCCortes 
		 	where Codigo = '#arguments.corte#' 
		</cfquery>

		<cfif qCorte.recordCount gt 0>
			<cfset proximaFecha =  DateAdd('d',1, qCorte.FechaFin)> 
			<cfreturn  GetCorteCodigos(proximaFecha, 1) >
		<cfelse>
			<cfreturn ''>
		</cfif> 
		 
	</cffunction>
	
	<cffunction name="AnteriorCorte" access="public" returntype="string" hint="funcion para cerrar un corte en especifico">
		<cfargument name="corte"  type="string"  required="true">
 
		<cfquery name="qCorte" datasource="#This.conexion#">
			select FechaInicio
			from  CRCCortes 
		 	where Codigo = '#arguments.corte#' 
		</cfquery>

		<cfif qCorte.recordCount gt 0>
			<cfset proximaFecha =  DateAdd('d',-2, qCorte.FechaInicio)> 
			<cfreturn  GetCorteCodigos(proximaFecha, 1) >
		<cfelse>
			<cfreturn ''>
		</cfif> 
		 
	</cffunction>


	

	<cffunction name="obtenerCortePorStatus" access="public" hint="devuelve los cortes con saldo vencidos calculados" returntype="string">
		<cfargument name="Tipo_Producto" required="true" type="string" default="" hint="si se desea obtener los cortes solo para un tipo de producto">
		<cfargument name="status" required="true" type="numeric"   hint=" status por el cual filtrar">

 		<!-- cortes a calcular su salvo vencido-->
 		<cfquery name = "qPeriodoStatus" datasource = "#This.conexion#">
 	    	select  Codigo 
        	from CRCCortes 
        	where  Tipo   = '#arguments.Tipo_Producto#' 
        	and    status = #arguments.status#
 	    </cfquery>
 
		<cfset loc.cortesAnteriores = "">
		<cfloop query = "qPeriodoStatus"> 
			<cfset loc.cortesAnteriores = ListAppend(loc.cortesAnteriores,Codigo)>  
		</cfloop> 	

		<cfreturn loc.cortesAnteriores>

	</cffunction>	

	
	<cffunction name="obtenerCortesSV" access="public" hint="devuelve los cortes a calcular su saldo vencido" returntype="string">
		<cfargument name="fechaActual"   required="true"  type="date"   hint="fecha actual">
		<cfargument name="Tipo_Producto" required="false" type="string" default="" hint="si se desea obtener los cortes solo para un tipo de producto">

  		
 		<!-- cortes a calcular su salvo vencido-->
 		<cfquery name="qPeriodoSV" datasource="#This.conexion#">
 	    	select Codigo, status
        	from CRCCortes 
        	where  <cfqueryparam value = "#arguments.fechaActual#" CFSQLType = 'CF_SQL_DATE'> between FechaInicioSV and FechaFinSV 
        	<cfif arguments.Tipo_Producto neq "" >
        		and Tipo = '#arguments.Tipo_Producto#'
        	</cfif>
 	    </cfquery>
 
		<cfset loc.cortesAnteriores = "">
		<cfloop query = "qPeriodoSV"> 
			<cfset loc.cortesAnteriores  = ListAppend(loc.cortesAnteriores,Codigo)>  
		</cfloop> 	
		<cfreturn loc.cortesAnteriores>

	</cffunction>	


	<cffunction name="obtenerCortesMP" access="public" returntype="string" hint="devuelve los cortes con monto a pagar calculado">
		<cfargument name="fechaActual" required="true" type="date" hint="fecha actual">
		<cfargument name="status" 	   required="true" type="string" hint="status">
  
		<!-- cortes a cerrar y/o calcular monto a pagar-->
 		<cfquery name="qPeriodoMP"  datasource="#This.conexion#">
 	    	select Codigo 
        	from CRCCortes 
        	where cerrado = 0 
        	and   FechaFin < <cfqueryparam value ="#arguments.fechaActual#" cfsqltype="cf_sql_date">
 	    </cfquery>
 
		<cfset loc.cortesACerrar = "">

		<cfloop query = "qPeriodoMP"> 
			<cfset loc.cortesACerrar = ListAppend(loc.cortesACerrar,#Codigo#)>  
		</cfloop>	
		<cfreturn loc.cortesACerrar>	 

	</cffunction>	

	<cffunction name="obtenerCortesACerrar" access="public" returntype="array" hint="devuelve en un arreglo de estructura los cortes a cerrar">
		<cfargument name="fechaActual"   required="true"  type="date"    hint="fecha actual">
		<cfargument name="status" 	     required="true"  type="string"  hint="status">
		<cfargument name="Tipo_Producto" required="false" type="string"  default="" hint="si se desea obtener los cortes solo para un tipo de producto">
  		 
		<!-- cortes a cerrar y/o calcular monto a pagar-->
 		<cfquery name="qPeriodoMP"  datasource="#This.conexion#">
 	    	select Codigo, Tipo, FechaFin, FechaInicio
        	from CRCCortes 
        	where  (cerrado = 0 and FechaFin < <cfqueryparam value ="#arguments.fechaActual#" cfsqltype="cf_sql_date">)
        	<cfif arguments.Tipo_Producto neq "" >
        		<!--- or  (cerrado = 1 and status = #This.C_CORTE_STATUS_CALCULADO#) --->
        		and Tipo = '#arguments.Tipo_Producto#'
        	</cfif>
 	    </cfquery>
 		
 		<cfset loc.cortesACerrar = ArrayNew(1)>
 		<cfif qPeriodoMP.recordCount eq 0>
 			<cfreturn loc.cortesACerrar>
 		</cfif>
		
		<cfset loc.index = 1>
		<cfloop query = "qPeriodoMP"  > 
			<cfset cortesInfo.codigo 		= qPeriodoMP.Codigo>
			<cfset cortesInfo.tipo   		= qPeriodoMP.Tipo> 
			<cfset cortesInfo.FechaFin      = qPeriodoMP.FechaFin>
			<cfset cortesInfo.FechaInicio   = qPeriodoMP.FechaInicio>  
			<cfset loc.cortesACerrar[loc.index] = #cortesInfo#>  
			<cfset loc.index = loc.index + 1>
		</cfloop>	
		<cfreturn loc.cortesACerrar>	 

	</cffunction>		

	<cffunction name="buscarUltimoCorteCalculado" hint="busca ultimo corte calculado por tipo de transaccion"> 
		<cfargument name="TipoTransaccion" type="string" required="true">
		<cfset fechaActual = CreateDate(DatePart('yyyy',now()), DatePart('m',now()),DatePart('d',now()))>
		<cfset conexion = this.conexion neq "" ? this.conexion : session.dsn>
		<cfquery name="qCorteActual" datasource="#conexion#"> 
			select Codigo  
			from CRCCortes 
			where Tipo = <cfqueryparam value ="#arguments.TipoTransaccion#" cfsqltype="cf_sql_varchar"> 
			and Cerrado = 1
			and status = 1
	    </cfquery>
	    
	   	<cfif qCorteActual.recordCount gt 0> 
	    	<cfreturn qCorteActual.Codigo>
        <cfelse> 
	    	<cfreturn ''>
	    </cfif>
	   
	</cffunction> 

	<cffunction  name="createDateB">
		<cfargument  name="year" 		required="true"> 	<!--- Año base para la fecha --->
		<cfargument  name="month"   	required="true"> 	<!--- Mes base para la fecha --->
		<cfargument  name="day" 		required="true"> 	<!--- Dia base para la fecha --->
		<cfargument  name="diffyear" 	default="0">		<!--- Cantidad de años a [sumar|restar] --->
		<cfargument  name="diffmonth" 	default="0">		<!--- Cantidad de meses a [sumar|restar] --->
		<cfargument  name="diffday" 	default="0">		<!--- Cantidad de dias a [sumar|restar] --->
		<cfargument  name="bisiesto" 	default="1">		<!--- Comportamiento base para años bisiestos --->

		<cfset newDate = funcBisiesto(arguments.year,arguments.month,arguments.day,arguments.bisiesto)>
		<cfset newDate = dateAdd('yyyy', arguments.diffyear, newDate)>
		<cfset newDate = dateAdd('m', arguments.diffmonth, newDate)>
		<cfset newDate = dateAdd('d', arguments.diffday, newDate)>
		
		<cfreturn newDate>
	</cffunction>

	<cffunction  name="funcBisiesto">
		<cfargument  name="year" 		required="true"> 	<!--- Año base para la fecha --->
		<cfargument  name="month"   	required="true"> 	<!--- Mes base para la fecha --->
		<cfargument  name="day" 		required="true"> 	<!--- Dia base para la fecha --->
		<cfargument  name="bisiesto" 	default="1">		<!--- Comportamiento base para años bisiestos --->

		<cfset y = arguments.year>
		<cfif arguments.day eq 29 && arguments.month eq 2>
			<cfif !(((y%40) eq 0) && (((y%100) neq 0) || (((y%100) eq 0) && ((y%400) eq 0))))>
				<cfif arguments.bisiesto eq 1>
					<cfreturn Createdate(y,arguments.month+1,1)>
				<cfelse>
					<cfset newDate = Createdate(y,arguments.month+1,1)>
					<cfset newDate = dateAdd('d', arguments.bisiesto, newDate)>
				</cfif>
			</cfif>
		</cfif>
		
		<cfreturn Createdate(arguments.year,arguments.month,arguments.day)>
	</cffunction>

</cfcomponent>