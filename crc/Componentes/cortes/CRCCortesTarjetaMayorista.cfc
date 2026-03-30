<cfcomponent output="false" displayname="CRCCortesTarjetaMayorista"  extends="CRCCortes" >
 
	<cfset loc.CPARAM_DIAS_SUMAR_CORTE_M = "30000711"> 
	<cfset loc.CPARAM_DIA_ADELANTO_CORTE = "30001455"> 

	<cfset this.socioNegocioID = ""> 

    <cffunction name="init" output="false" returntype="CRCCortesTarjetaMayorista"> 
    	<cfargument name="SNid"  	 		  type="numeric" requried ="true"> 
    	<cfargument name="conexion" 		  type="string"  required="false" default="#session.dsn#"> 
		<cfargument name="ECodigo"   		  type="string"	 required="false" default="#session.Ecodigo#">
	 
		<cfset Super.init(TipoCorte=This.TC_Mayorista,conexion=arguments.conexion,ECodigo=arguments.ECodigo)> 
		<cfset This.socioNegocioID = #arguments.SNid#>
		
		<cfreturn this>
    </cffunction>	


	<cffunction name="CreaCortes" access="public" returntype="void" hint="funcion para la creacion de cortes para un mayorista"> 
		<cfargument name="fecha" 		 type="date"    required="true">
		<cfargument name="parcialidades" type="numeric" required="true">
		<cfargument name="SNid" type="numeric" required="false" default="0">

		<!--parametros--> 
		<cfset crcParametros = createobject("component","crc.Componentes.CRCParametros")>

		<!-- Dias a sumar a partir de la fecha pasada como parametros para buscar la fecha fin-->
		<cfset paramInfo = crcParametros.GetParametroInfo(codigo=loc.CPARAM_DIAS_SUMAR_CORTE_M,conexion=This.conexion,ecodigo=This.ecodigo,descripcion="Cantidad de días para corte de mayorista")>
		<cfif paramInfo.valor eq "" ><cfthrow type="CRCCortesTarjetaMayoristaException" message="No se ha definido el parametro de configuracion: #paramInfo.descripcion#">
		</cfif>	
		<cfset loc.diasSumar = paramInfo.valor>
		<!-- dia en que se adelanta el corte -->
		<cfset loc.adcorte = crcParametros.GetParametro(codigo=loc.CPARAM_DIA_ADELANTO_CORTE,conexion=This.conexion,ecodigo=This.ecodigo)> 
		<!--- en el caso de los mayoristas, si tiene registros en movimiento ----> 
		<cfset stCorte   = CreaCorteMayorista(arguments.fecha, arguments.SNid)> 


		<cfquery name="qMayoristaRepetido" datasource="#This.conexion#">
			select 'x'
			from  CRCCortes
			where Codigo = '#stCorte.codigo#'
		</cfquery>

		<cfif qMayoristaRepetido.recordCount eq 0>
			<cfset fechaSV   = DateAdd("d",1,stCorte.fechaFin)>
	 
			<cfset stCorteSV = CreaCorteMayorista(fecha= fechaSV, SNid= arguments.SNid, SV=1)>

			<cfset insertCorte('#stCorte.codigo#',#stCorte.fechaInicio#,#stCorte.fechaFin#,#scorte.status#,#stCorteSV.fechaInicio#,#stCorteSV.fechaFin#, This.C_CORTE_STATUS_CALCULADO)>
		</cfif>

	</cffunction>

	<cffunction name="ProximoCorte" access="public" returntype="string" hint="funcion para crear un corte en especifico">
		<cfargument name="corte"  type="string"  required="true">
		<cfargument name="estado" type="string"  required="false" default="0">
		<cfargument name="SNid"   type="numeric" required="false" default="-1"> 
		
		<cfquery name="qCorte" datasource="#This.conexion#">
			select FechaFin
			from  CRCCortes 
		 	where Codigo = '#arguments.corte#' 
		</cfquery>
		
		<cfif qCorte.recordCount gt 0> 
			<cfset proximaFecha = DateAdd('d',1, qCorte.FechaFin)>
			<cfreturn  GetCorteCodigos(proximaFecha, 1, arguments.SNid) >
		<cfelse>
			<cfreturn ''>
		</cfif> 
		
	</cffunction>
	

	<cffunction name="CreaCorteMayorista" access="public" returntype="struct" hint="funcion para la creacion de cortes para un mayorista">
		<cfargument name="fecha" type="date" required="true">  
		<cfargument name="SNid" type="numeric" required="false" default="0">
		<cfargument name="SV" type="boolean" required="false" default="0">
   
		<!-- dias iniciales-->
		<cfset LvarAnioIni 	= DatePart('yyyy', arguments.fecha)>
		<cfset LvarMesIni   = DatePart('m', arguments.fecha)>
		<cfset LvarDiaIni   = DatePart('d', arguments.fecha)>
		<cfset LvarFechaInicio  = CreatedateB(LvarAnioIni,LvarMesIni,LvarDiaIni)>

		<cfset loopInit   = "#LvarAnioIni##right('00'&LvarMesIni,2)##right('00'&LvarDiaIni,2)#">  
		<cfset LvarCodigo = "#This.tipoCorte##loopInit#-#arguments.SNid#">
 
		<!-- dias de gracia -->
		<cfset loc.diasDeGracia = diasDeGracia()>
		<cfif arguments.SV>
			<cfset loc.diasDeGracia = 0>
		</cfif>
		<cfif loc.diasDeGracia neq "">
			<cfset loc.diasSumar = 	loc.diasSumar + loc.diasDeGracia>
		</cfif>


		<!-- dias finales-->
		<cfset loc.fechafin = DateAdd("d",loc.diasSumar,arguments.fecha )> 
		<cfset LvarAnioFin 	= DatePart('yyyy', loc.fechafin )>
		<cfset LvarMesFin   = DatePart('m', loc.fechafin )>
		<cfset LvarDiaFin   = DatePart('d', loc.fechafin)>

		<cfset LvarFechaFin = CreatedateB( LvarAnioFin,LvarMesFin,LvarDiaFin)>

		<cfset scorte = StructNew()>
	    <cfset scorte.codigo      = #LvarCodigo#>
	    <cfset scorte.fechaInicio = #LvarFechaInicio#>
	    <cfset scorte.fechaFin    = #LvarFechaFin#>
	    <cfset scorte.status      = 1> 
		
		<cfreturn scorte>
	
	</cffunction>


	<cffunction name="diasDeGracia" access="private" returntype="numeric" hint="Devuelve los dias de gracia para un socio de negocios"> 


		<cfquery datasource="#This.conexion#" name="rsCuenta"> 
			select id
			from CRCCuentas
			where SNegociosSNid = #This.socioNegocioID#
				and tipo like '%TM%'
		</cfquery>

		<cfquery datasource="#This.conexion#" name="rsParam"> 

			select TMDiasGracia
			from CRCTCParametros cp  
			where  cp.SNegociosSNid = #This.socioNegocioID#
				and CRCCuentasid = #rsCuenta.id#
			<!---
			and TMLimiteCredito is not null
			and TMDiasGracia    is not null
			and TMSeguro		is not null
			--->
		</cfquery>
		 
		<cfif rsParam.recordCount gt 0>
			<cfreturn rsParam.TMDiasGracia  neq '' ? rsParam.TMDiasGracia:0> 
		<cfelse>
			<cfreturn 0>
		</cfif>
  
	</cffunction>
 
 	<cffunction name="GetCorteCodigos" access="public" returntype="string" hint="Devuelve string de cortes de un distribuidor">
		<cfargument name="fecha" type="date" required="true"> 
		<cfargument name="parcialidades"   type="numeric" required="true"> 
		<cfargument name="SNid"   type="numeric" required="false" default="-1"> 
 
 		<cfset aux.fechaCorte = CreatedateB(DatePart('yyyy',arguments.fecha), DatePart('m',arguments.fecha),DatePart('d',arguments.fecha))>

		<cfquery name="rsCortes" datasource="#This.conexion#">
			select Codigo
			from  CRCCortes
			where Ecodigo = #This.Ecodigo#
			and   Tipo    = '#This.TipoCorte#'
			and   Codigo like '%-#arguments.SNid#'
			and   datediff(day,<cfqueryparam value ="#aux.fechaCorte#" cfsqltype="cf_sql_date"> ,fechaInicio ) = 0
		</cfquery>

 		<cfif rsCortes.recordCount eq 0> 
		 
			<cfset CreaCortes(#aux.fechaCorte#,arguments.parcialidades,arguments.SNid)>
			<cfreturn GetCorte(fecha=aux.fechaCorte,TipoCorte='TM', SNid=arguments.SNid)>
		<cfelse>
			<cfreturn rsCortes.codigo>
		</cfif>
 
	</cffunction>

</cfcomponent>