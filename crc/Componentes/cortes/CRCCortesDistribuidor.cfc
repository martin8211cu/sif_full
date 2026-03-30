<cfcomponent output="false"  displayname="CRCCortesDistribuidor" extends="CRCCortes">
 
 	<cfset loc.adcorte = "">
 	<cfset loc.c1 = "">
 	<cfset loc.c2 = "">

 	<cfset loc.CPARAM_DIA_CORTE_QUINCENA_UNO = "30000601">
 	<cfset loc.CPARAM_DIA_CORTE_QUINCENA_DOS = "30000602"> 
 	<cfset loc.CPARAM_DIA_ADELANTO_CORTE     = "30001455"> 

    <cffunction name="init" output="false" returntype="CRCCortesDistribuidor"> 
    	<cfargument name="conexion"  type="string"   required="false" default="#session.dsn#"> 
		<cfargument name="ECodigo"   type="string"	 required="false" default="#session.Ecodigo#">
		<cfset Super.init(TipoCorte=This.TC_Distribudidor,conexion=arguments.conexion,ECodigo=arguments.ECodigo)>
		<cfreturn this>
    </cffunction>	 	 	

 	<cffunction name="CreaCortes" access="public"   returntype="void" hint="funcion para la creacion de cortes para un distribuidor"> 
		<cfargument name="fecha" 		 type="date"    required="true">
		<cfargument name="parcialidades" type="numeric" required="true">
 

		<cfset cortesList = Super.CreaCortes(#arguments.fecha#,#arguments.parcialidades#)> 
  		 
  		<!--- fecha inicio de chequeo de huecos---> 
  		<cfif This.fechaFinUltimoCorte neq ''>
  			<cfset loc.fechaInicialChequeo = dateadd('d',1, This.fechaFinUltimoCorte)>
  		<cfelse>
  			<cfset loc.fechaInicialChequeo = CreatedateB(DatePart('yyyy',now()), DatePart('m',now()),DatePart('d',now()))>
  		</cfif>

		<cfset indice = 1> 
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
					<cfif (arguments.fecha gte stCorte.FechaInicio and arguments.fecha lte stCorte.FechaFin)>
						<cfset indice = indice + 1>
					</cfif>

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
 
 			<cfif indice gt arguments.parcialidades>  
 				<cfreturn>
 			</cfif>
 			
		</cfloop> 	
     

	</cffunction>


	<cffunction name="_CreaCortes" access="package" returntype="array" hint="funcion para crear cortes para un distribuidor">
		<cfargument name="LvarMesIni" type="string" required="true">
		<cfargument name="LvarMesFin" type="string" required="true">
		<cfargument name="LvarAnioIni" type="string" required="true">
		<cfargument name="LvarAnioFin" type="string" required="true"> 
		<cfargument name="listaCortesExistentes" type="string"  required="false" default="">
		
		<cfif LvarMesIni eq 1>
			<cfset LvarMesIni = 12>
			<cfset LvarAnioIni = LvarAnioIni -1>
		<cfelse>
			<cfset LvarMesIni = LvarMesIni -1>
		</cfif>

		<!--parametros--> 
		<cfset crcParametros = createobject("component","crc.Componentes.CRCParametros")>

		<!-- Dia corte quincena uno-->
		<cfset paramInfo = crcParametros.GetParametroInfo(codigo=loc.CPARAM_DIA_CORTE_QUINCENA_UNO,conexion=This.conexion,ecodigo=This.ecodigo,descripcion="Día de corte quincena 1")> 
		<cfif paramInfo.valor eq ""  ><cfthrow type="CRCCortesDistribuidorException" message="No se ha definido el parametro de configuracion: #paramInfo.descripcion#"></cfif>
		<cfset loc.c1 = paramInfo.valor>

		<!-- Dia corte quincena dos-->
		<cfset paramInfo = crcParametros.GetParametroInfo(codigo=loc.CPARAM_DIA_CORTE_QUINCENA_DOS,conexion=This.conexion,ecodigo=This.ecodigo, descripcion="Día de corte quincena 2")>
		<cfif paramInfo.valor eq ""  ><cfthrow type="CRCCortesDistribuidorException" message="No se ha definido el parametro de configuracion: #paramInfo.descripcion#"></cfif> 
		<cfset loc.c2 = paramInfo.valor>
 	 
		<!-- dia en que se adelanta el corte -->
		<cfset loc.adcorte = crcParametros.GetParametro(codigo=loc.CPARAM_DIA_ADELANTO_CORTE,conexion=This.conexion,ecodigo=This.ecodigo)>

 		<cfset cortesList = []>

		<cfset loopInit = "#LvarAnioIni##right('00'&LvarMesIni,2)#">
		<cfset loopFin = "#LvarAnioFin##right('00'&LvarMesFin,2)#">

		<cfset incrementa = 1>
		<cfset index = 1>
		<cfloop condition = "loopInit lt loopFin">
			<cfset sq1 = ""> 
			<cfset LvarDiaIni 		= loc.c2+incrementa>
			<cfset LvarDiaFin 		= loc.c1>
			<cfset sq1 = "01">
  
			<cfset LvarloopAnioIni = LvarAnioIni>
			<cfset LvarloopMesFin = LvarMesIni + 1>
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
 
			<cfset LvarMesInid = LvarMesIni + 1>
			<cfset LvarAnioInid 	= LvarAnioIni>
			<cfif LvarMesInid gt 12>
				<cfset LvarAnioInid 	= LvarAnioIni +1>
				<cfset LvarMesInid = 1>
			</cfif>
			<cfset loopInit = "#LvarAnioInid##right('00'&LvarMesInid,2)#">
				 
			<cfset LvarCodigo 		= "#this.TipoCorte##loopInit##sq1#">
		    <cfset LvarFechaInicio  = CreatedateB(iif(LvarMesIni eq 12,LvarloopAnioIni-1,LvarloopAnioIni),LvarMesIni,LvarDiaIni)>
			<cfset LvarFechaFin  	= CreatedateB(LvarloopAnioIni,LvarloopMesFin,LvarDiaFin)>

		    <cfset scorte = StructNew()>
		    <cfset scorte.codigo      = #LvarCodigo#>
		    <cfset scorte.fechaInicio = #LvarFechaInicio#>
		    <cfset scorte.fechaFin    = #LvarFechaFin#>
		    <cfset scorte.status      = 0>  
  			<cfset cortesList[index]  = scorte>  
  			<cfset scorte.existe      = listContains(listaCortesExistentes,scorte.codigo ) gt 0>
  			<cfset index = index + 1>
 
 
			<cfset LvarMesIni = LvarMesIni + 1>
			<cfif LvarMesIni gt 12>
				<cfset LvarAnioIni 	= LvarAnioIni +1>
				<cfset LvarMesIni = 1>
			</cfif>
			<cfset loopInit = "#LvarAnioIni##right('00'&LvarMesIni,2)#">

			<!--- segunda quincena ---> 
			<cfset LvarDiaIni2 = loc.c1+incrementa>
			<cfset LvarDiaFin2 = loc.c2>
			<cfset sq1 = "02">

			<cfif loc.adcorte neq "">
				<cfif DayOfWeek(CreatedateB(LvarloopAnioIni, LvarloopMesFin, LvarDiaFin2)) eq loc.adcorte>
					<cfset LvarDiaFin2 	= loc.c2-1>
					<cfset incrementa = 0>
				<cfelse>
					<cfset incrementa = 1>
				</cfif>
			</cfif>

			<cfset LvarMesInid2 = LvarMesIni>
			<cfset LvarAnioInid2 	= LvarAnioIni>
			<cfif LvarMesInid2 gt 12>
				<cfset LvarAnioInid2 	= LvarAnioIni +1>
				<cfset LvarMesInid2 = 1>
			</cfif>
			<cfset loopInit = "#LvarAnioInid2##right('00'&LvarMesInid2,2)#">

			<cfset LvarCodigo2 		= "#this.TipoCorte##loopInit##sq1#">
		    <cfset LvarFechaInicio2 = CreatedateB(LvarloopAnioIni,LvarMesIni,LvarDiaIni2)>
		    <cfset LvarFechaFin2  	= CreatedateB(LvarloopAnioIni,LvarloopMesFin,LvarDiaFin2)>

		    <cfset scorte = StructNew()>
		    <cfset scorte.codigo      = #LvarCodigo2#>
		    <cfset scorte.fechaInicio = #LvarFechaInicio2#>
		    <cfset scorte.fechaFin    = #LvarFechaFin2#>
		    <cfset scorte.status      = 0>  
  			<cfset cortesList[index]  = scorte>  
  			<cfset scorte.existe      = listContains(listaCortesExistentes,scorte.codigo ) gt 0>
  			<cfset index = index + 1> 

		</cfloop>
		
		<cfreturn #cortesList#>
		
	</cffunction>
 
	 
</cfcomponent>