<cfcomponent output="false"  displayname="CRCCortesTarjetaCredito" extends="CRCCortes">
 
 	<cfset loc.adcorte = "">
 	<cfset loc.c1 = "">
 	<cfset loc.CPARAM_DIA_CORTE_TC = "30000603"> 
 	<cfset loc.CPARAM_DIA_ADELANTO_CORTE = "30001455"> 

    <cffunction name="init" output="false" returntype="CRCCortesTarjetaCredito"> 
    	<cfargument name="conexion"  type="string"   required="false" default="#session.dsn#"> 
		<cfargument name="ECodigo"   type="string"	 required="false" default="#session.Ecodigo#">
		<cfset Super.init(TipoCorte=This.TC_Tarjeta,conexion=arguments.conexion,ECodigo=arguments.ECodigo)>
		<cfreturn this>
    </cffunction>	 	

 	<cffunction name="CreaCortes" access="public" returntype="void" hint="funcion para la creacion de cortes para tarjeta de credito">
		<cfargument name="fecha" 		 type="date"    required="true">
		<cfargument name="parcialidades" type="numeric" required="true">
  
		<cfset cortesList = Super.CreaCortes(#arguments.fecha#,#arguments.parcialidades#)> 
  		 
  		<!--- fecha inicio de chequeo de huecos---> 
  		<cfif This.fechaFinUltimoCorte neq ''>
  			<cfset loc.fechaInicialChequeo = dateadd('d',1, This.fechaFinUltimoCorte)>
  		<cfelse>
  			<cfset loc.fechaInicialChequeo = CreatedateB(DatePart('yyyy',now()), DatePart('m',now()),DatePart('d',now()))>
  		</cfif>
 
		<cfset indice = 0> 
		<cfloop index="i" from="1" to="#arraylen(cortesList)#"> 
			
			<cfif arraylen(cortesList) lt i+2> 
				<cfreturn >
			</cfif> 
			
			<cfset stCorte = cortesList[i]> 
			<cfif stCorte.existe eq false> 
	 			<cfif (loc.fechaInicialChequeo gte stCorte.FechaInicio and loc.fechaInicialChequeo lte stCorte.FechaFin) or
	 			      (arguments.fecha gte stCorte.FechaInicio and arguments.fecha lte stCorte.FechaFin)>
	 			    
	 			    <!--- no hay corte en la fecha actual--->
	 			  	<cfset stCorte.existe = true> 
					<cfset stCorteSV = cortesList[i+2]> 
					<cfset insertCorte('#stCorte.codigo#',#stCorte.fechaInicio#,#stCorte.fechaFin#,#scorte.status#,#stCorteSV.fechaInicio#,#stCorteSV.fechaFin#)>  

					<!--- si la fecha de inicio de pago tambien esta en este periodo entonces se adiciona como un corte pedido a generar --->
						<cfset indice = indice + 1>
					
				<cfelseif arguments.fecha gte stCorte.FechaFin and  stCorte.FechaFin gt loc.fechaInicialChequeo> 
				    <!--- hueco --->
				    <cfset stCorte.existe = true> 
					<cfset stCorteSV = cortesList[i+2]> 
					<cfset insertCorte('#stCorte.codigo#',#stCorte.fechaInicio#,#stCorte.fechaFin#,#scorte.status#,#stCorteSV.fechaInicio#,#stCorteSV.fechaFin#)>  
 					
				<cfelseif stCorte.FechaInicio gt arguments.fecha>
				    <!--- nuevos cortes ---> 
				    <cfset stCorte.existe = true>
					<cfset indice = indice + 1>
					<cfset stCorteSV = cortesList[i+2]> 
					<cfset insertCorte('#stCorte.codigo#',#stCorte.fechaInicio#,#stCorte.fechaFin#,#scorte.status#,#stCorteSV.fechaInicio#,#stCorteSV.fechaFin#)> 

					  
                </cfif>
			</cfif>
 
 			<cfif indice eq arguments.parcialidades>  
 				<cfreturn>
 			</cfif>
 			
		</cfloop> 

 	 
	</cffunction>
   
	<cffunction name="_CreaCortes" access="package" returntype="array"  hint="funcion para crear cortes, para una tarjeta de credito">
		<cfargument name="LvarMesIni"   type="string"  required="true">
		<cfargument name="LvarMesFin"   type="string"  required="true">
		<cfargument name="LvarAnioIni"  type="string"  required="true">
		<cfargument name="LvarAnioFin" 	type="string"  required="true">
		<cfargument name="listaCortesExistentes" type="string"  required="false" default="">
 
		<!--componente de parametros--> 
		<cfset crcParametros = createobject("component","crc.Componentes.CRCParametros")>
 		 
		<!-- Dia corte tarjeta credito-->
		<cfset paramInfo = crcParametros.GetParametroInfo(codigo='#loc.CPARAM_DIA_CORTE_TC#',conexion=#This.conexion#,ecodigo=#This.Ecodigo#,
			descripcion="Día de corte tarjeta de crédito")> 
		<cfif paramInfo.valor eq "" >
			<cfthrow  type="CRCCortesTarjetaCreditoException" message="No se ha definido el parametro de configuracion: #paramInfo.descripcion#">
		</cfif>	
		<cfset loc.c1 = paramInfo.valor>
 
		<!-- dia en que se adelanta el corte -->
		<cfset loc.adcorte = crcParametros.GetParametro(codigo='#loc.CPARAM_DIA_ADELANTO_CORTE#',conexion=#This.conexion#,ecodigo=#This.ecodigo#)>		
		<cfset cortesList = []>

		<cfset incrementa = 1>
		<cfset index = 1>
		<cfloop condition = "loopInit lt loopFin">

			<cfset sq1 = "">
			<cfset LvarDiaIni = loc.c1+incrementa>
			<cfset LvarDiaFin = loc.c1>
			 
			<cfset LvarloopAnioIni = LvarAnioIni>
			<cfset LvarloopMesFin  = LvarMesIni + 1>
			<cfif LvarloopMesFin gt 12>
				<cfset LvarloopAnioIni 	= LvarloopAnioIni +1>
				<cfset LvarloopMesFin = 1>
			</cfif>

			<cfif loc.adcorte neq "">
				<cfif DayOfWeek(CreatedateB(LvarloopAnioIni, LvarloopMesFin, LvarDiaFin)) eq loc.adcorte>
					<cfset LvarDiaFin 	= loc.c1-1>
					<cfset incrementa = 0>
				<cfelse>
					<cfset incrementa = 1>
				</cfif>
			</cfif>
  
			<cfset LvarCodigo 		= "#This.tipoCorte##loopInit##sq1#">
		    <cfset LvarFechaInicio  = CreatedateB(iif(LvarMesIni eq 12,LvarloopAnioIni-1,LvarloopAnioIni),LvarMesIni,LvarDiaIni)>
		    <cfset LvarFechaFin  	= CreatedateB(LvarloopAnioIni,LvarloopMesFin,LvarDiaFin)>
 
 	        <cfset scorte = StructNew()>
		    <cfset scorte.codigo       = #LvarCodigo#>
		    <cfset scorte.fechaInicio  = #LvarFechaInicio#>
		    <cfset scorte.fechaFin     = #LvarFechaFin#>
		    <cfset scorte.status       = 0>
		    <cfset scorte.existe       = listContains(listaCortesExistentes,scorte.codigo ) gt 0>
 			
  			<cfset cortesList[index]  = scorte>  

			<cfset LvarMesIni = LvarMesIni + 1>
			<cfif LvarMesIni gt 12>
				<cfset LvarAnioIni 	= LvarAnioIni +1>
				<cfset LvarMesIni   = 1>
			</cfif>
			<cfset loopInit = "#LvarAnioIni##right('00'&LvarMesIni,2)#">
  			
  			<cfset index = index + 1> 
		</cfloop> 

		<cfreturn #cortesList#>

	</cffunction>	
 
</cfcomponent>