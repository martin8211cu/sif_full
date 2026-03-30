<!--- ========================================================================================= --->
<!---                                         FUNCIONES GENERALES                               --->
<!--- ========================================================================================= --->
<cffunction name="datos" access="public" returntype="query">
	<!--- RESULTADO --->
	<!---  Devuelve los datos necesarios para insertar en encabezados y detalles --->
	<cfargument name="DSLinea" type="numeric" required="true" default="">
	<cfquery name="rsInfo" datasource="#session.DSN#" >
		select b.Ocodigo, b.Dcodigo, b.ESobservacion, b.ESobservacion, a.DSdescripcion, a.DSobservacion,
		<cf_dbfunction name="to_char"	args="b.CMGSid"> as CMGSid, 
		<cf_dbfunction name="to_char" args="b.CMSid"> as CMSid, 
		<cf_dbfunction name="today"> as ESfecha
		from DSolicitudCompraCM a
			inner join ESolicitudCompraCM b
				on a.ESnumero = b.ESnumero
		       and a.Ecodigo  = b.Ecodigo
		where a.ESolicitud = b.ESolicitud
		  and a.Ecodigo =  #session.Ecodigo# 
		  and a.DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DSlinea#">
	</cfquery>
	<cfreturn #rsInfo#>
</cffunction>

<cffunction name="Insertar_ER" access="public" returntype="query">
	<!--- RESULTADO --->
	<!---  Inserta un Encabezado de Requisicion --->
	<cfargument name="ESolicitud"    type="string"  required="true" default="">
	<cfargument name="ESobservacion" type="string"  required="true" default="">
	<cfargument name="Alm_Aid"       type="numeric" required="true" default="">
	<cfargument name="DSLinea"       type="string"  required="true" default="">
	<cfargument name="Ocodigo"       type="numeric" required="true" default="">
	<cfargument name="Dcodigo"       type="numeric" required="true" default="">
	<cfargument name="TRcodigo"      type="string"  required="true" default="">
	<cfargument name="ERdocumento"   type="string"  required="true" default="">	
	
<cftransaction>
	<!----Obtiene el consecutivo----->
	<cfinvoke	component		= "sif.Componentes.OriRefNextVal"
				method			= "nextVal"
				returnvariable	= "LvarERdocumento"
			
				Ecodigo			= "#session.Ecodigo#"
				ORI				= "INRQ"
				REF				= "ERdocumento"
				datasource		= "#session.dsn#"
	/>
	
	<cfquery name="rsInsertarEReq" datasource="#session.DSN#">
		insert into ERequisicion ( Ecodigo, ERdescripcion, Aid, ERdocumento, Ocodigo, TRcodigo, ERFecha, ERtotal, ERusuario, Dcodigo, EReferencia)
					 values (  #session.Ecodigo# ,
							  <cfif #Len("ESobservacion")# gt 80 >'#Mid(ESobservacion, 1, 72)#...-#LvarERdocumento#'<cfelse>'#ESobservacion#-#LvarERdocumento#'</cfif>,
							  <cfqueryparam value="#Alm_Aid#"      cfsqltype="cf_sql_numeric">,
							  <cfqueryparam value="#LvarERdocumento#-#ERdocumento#"  cfsqltype="cf_sql_varchar">,
							  <cfqueryparam value="#Ocodigo#"      cfsqltype="cf_sql_integer">,
							  <cfqueryparam value="#TRcodigo#"     cfsqltype="cf_sql_varchar">,
							  <cf_dbfunction name="today">,
							  <cfqueryparam value="0"                  cfsqltype="cf_sql_money">,
							  <cfqueryparam value="#session.usuario#"  cfsqltype="cf_sql_varchar">,
							  <cfqueryparam value="#Dcodigo#"          cfsqltype="cf_sql_integer">,
							  <cfqueryparam value="#ESolicitud#"       cfsqltype="cf_sql_varchar">
							)
			<cf_dbidentity1 datasource="#session.DSN#">
	</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="rsInsertarEReq">
			<cfset id = rsInsertarEReq.identity>
</cftransaction>	
		
	<cfreturn #rsInsertarEReq#>
</cffunction>

<cffunction name="Insertar_DR" access="public" returntype="any">
	<!--- RESULTADO --->
	<!---  Inserta un Encabezado de Requisicion --->
	<cfargument name="id"       type="numeric" required="true" default="" >
	<cfargument name="Aid"      type="numeric" required="true" default="" >
	<cfargument name="cantidad" type="numeric" required="true" default="" >	
	<cfargument name="DSLinea"  type="numeric" required="true" default="" >

	<cfquery name="rsInsertarDReq" datasource="#session.DSN#">
		insert into DRequisicion ( ERid, Aid, DRcantidad, DRcosto, DSlinea )
					 values ( <cfqueryparam value="#id#"              cfsqltype="cf_sql_numeric">,
							  <cfqueryparam value="#Aid#"             cfsqltype="cf_sql_numeric">,
							  <cfqueryparam value="#cantidad#"        cfsqltype="cf_sql_float">,
							  0.00,
							  <cfqueryparam value="#DSlinea#"         cfsqltype="cf_sql_numeric">
							)					
	</cfquery>						
	<cfreturn 1 >
</cffunction>

<cffunction name="cantidad" access="public" returntype="numeric">
	<!--- RESULTADO --->
	<!---  Devuelve la cantidad Solicitada para una linea --->
	<cfargument name="DSlinea"  type="numeric" required="true" default="" >
		<cfloop index="index" from="1" to="#ArrayLen(cant_chk)#" >
			<cfif DSlinea eq cant_chk[index][1] >
				<cfreturn #Trim(cant_chk[index][2])#>
			</cfif>
		</cfloop>
		<cfreturn 0>
</cffunction>
<!--- ========================================================================================= --->
<!--- ========================================================================================= --->

<cfif isdefined("btnAplicar") >
	<cftry>
		<cfif isdefined("chk") >
			<cftransaction>		
				<cfset continuar = true >
	
				<!--- Requisicion Default --->
				<cfquery name="rsTipoReq" datasource="#session.DSN#">
					select ltrim(rtrim(Pvalor)) as TRcodigo
					from Parametros a
						inner join TRequisicion b
							on a.Pvalor=b.TRcodigo
					       and a.Ecodigo=b.Ecodigo	
					where a.Ecodigo= #session.Ecodigo# 
					  and a.Pcodigo=360
				</cfquery>
				
				<!--- Solicitante/Grupo Default --->
				<cfquery name="rsGrupoSolic" datasource="#session.DSN#">
					select rtrim(Pvalor) as CMSid, <cf_dbfunction name="to_char" args="CMGSid"> as CMGSid
					from Parametros a
						inner join CMSolicitantes b
							on rtrim(a.Pvalor) = <cf_dbfunction name="to_char"	args="b.CMSid">
						inner join CMSolicGrupo c
							on b.CMSid = c.CMSid
					where a.Ecodigo= #session.Ecodigo# 
					  and Pcodigo=370
				</cfquery>
				
				<cfif (rsTipoReq.RecordCount eq 0) or (rsGrupoSolic.RecordCount eq 0) >
					<script language="JavaScript1.2" type="text/javascript">
						var msg	 = "Se presentaron los siguientes errores:\n";
							msg += " - Debe definir el Tipo de Requisición default.\n";
							msg += " - Debe definir el Solicitante default."
						alert(msg)
					</script>
					<cfset continuar = false >
				</cfif>
	
				<cfif continuar >
				
					<!---  Los valores del objeto chk, que envia el form, esta compuesto de la siguiente forma: DSlinea|DScant
						   Este codigo hace dos cosas:
						   	1. Crea un arreglo de tamaño de chk, donde cada posicion es otro arreglo que contiene la linea(1)
							   y la cantidad solicitada (2). Esto es para recuperar la cantidad solicitada para una linea.
							2. Crea una lista, que va a contener los DSlineas a procesar. 
							Esto se hizo asi, pues es una modificacion de lo que ya existia, y asi se evita modificar
							sustancialmente el codigo.
					  --->
					<cfset vchk = #ListToArray(form.chk)# >
					<cfset cant_chk = ArrayNew(1) >
					<cfset lineas = "">
					<cfloop index="index" from="1" to="#ArrayLen(vchk)#" >
						<cfset cant_chk[index] = #ListToArray(vchk[index], '|')# >
						<cfset lineas = #ListAppend(lineas, cant_chk[index][1], ',')# >
					</cfloop>
				
					<!---  Lineas que se van a procesar  --->
					<cfquery name="rsLineas" datasource="#session.DSN#">
						select <cf_dbfunction name="to_char" args="Aid"> as Aid,
						       <cf_dbfunction name="to_char"	args="Alm_Aid"> as Alm_Aid, 
							   <cf_dbfunction name="to_char"	args="ESolicitud"> as ESolicitud, 
							   <cf_dbfunction name="to_char"	args="DSlinea"> as DSlinea, (
							   DScant - DScantsurt) as DScant
						from DSolicitudCompraCM
						where DSlinea in ( #lineas# )
						order by ESolicitud, Alm_Aid
					</cfquery>
					
					<cfset corte  = "">
					<cfset id_req = "">				<!---  id de la requisicion insertada --->
					<cfset id_sol = "">				<!---  id de la solicitud insertada --->
					<cfset corte_req    = "" >		<!--- especifica para esta parte, indica si hay corte en el proceso de Requisiciones (solic, almacen) --->
					<cfset corte_sol    = "" >		<!--- especifica para esta parte, indica si hay corte en el proceso de Solicitud (solic) --->
		
					<cfloop query="rsLineas">
						<cfset requisicion  = false >	<!--- false: no genera solicitud, true: genera requisicion ---> 
						<cfset solicitud    = false >	<!--- false: no genera solicitud, true: genera solicitud ---> 
						<cfset cantidad_req = 0 >		<!--- cantidad de articulos en la requisicion --->
						<cfset cantidad_sol = 0 >		<!--- cantidad de artculos para la solicitud --->		
					
						<!--- 1. Determina si hay existencias en inventario para surtir parcialmente la solicitud.
								 Si las hay, debera generar una requisicion para las existencias disponibles y una solicitud por
								 la cantidad que falta.
								 Si no hay, genera solo un asolicitud de compra, por la cantidad total de la solicitud.
						--->
						<cfquery name="rsExistencias" datasource="#session.DSN#">
							select coalesce(sum(Eexistencia), 0) as existencia
							from Existencias a
								inner join Articulos b
									on a.Aid=b.Aid
								   and a.Ecodigo=b.Ecodigo
								inner join Almacen c
									on a.Alm_Aid=c.Aid
							       and a.Ecodigo=c.Ecodigo
							where a.Ecodigo= #session.Ecodigo# 
							  and a.Aid=#rsLineas.Aid#
						</cfquery>
			
						<!--- Determina que se va a generar: Solic. y Requi. o solo Solic.
							  Ademas calcula las cantidades que se van a procesar segun el proceso que se vaya a
							  generar
						--->
						<cfset DScantidad = cantidad(rsLineas.DSlinea) >
						<cfif rsExistencias.existencia gt 0 >
							<cfset requisicion  = true >
							
							<!--- Calcula las cantidades que se van a insertar --->
							<cfif rsExistencias.existencia gte DScantidad >
								<cfset cantidad_req = DScantidad >
							<cfelse>
								<cfset solicitud    = true >
								<cfset cantidad_req = rsExistencias.existencia >
								<cfset cantidad_sol = DScantidad - rsExistencias.existencia >
							</cfif>
						<cfelse>
							<cfset solicitud   = true >
							<cfset cantidad_sol = DScantidad >
						</cfif>
					
						<!--- Datos necesarios para los inserts --->
						<cfset rsDatos = datos(rsLineas.DSlinea) >
		
						<!--- Procesa las Requisiciones --->
						<cfif requisicion >
							<cfif (rsLineas.ESolicitud & "_" & rsLineas.Alm_Aid) neq corte_req >	
								<!--- Crea el valor para el campo de documento de la Req. 
									  Este valor se va a componer de:
										  CM S#solicitud Alm#almacen #de registros en la tabla + a, segun la empresa 
								--->
								<cfquery name="rsRegistros" datasource="#session.DSN#">
									select * from ERequisicion where Ecodigo= #session.Ecodigo# 
								</cfquery>	
								<cfset documento = "CM" & (rsRegistros.RecordCount + 1) & "S" & rsLineas.ESolicitud & "Alm" & rsLineas.Alm_Aid >
	
								<cfset insert_req = Insertar_ER( rsLineas.ESolicitud, rsDatos.ESobservacion, rsLineas.Alm_Aid, rsLineas.DSLinea, rsDatos.Ocodigo, rsDatos.Dcodigo, rsTipoReq.TRcodigo, documento ) >
								<cfset id_req = insert_req.id >
							</cfif>
							
							<!--- Inserta Detalle de requisicion --->
							<cfset resultado = Insertar_DR( id_req, rsLineas.Aid, cantidad_req, rsLineas.DSlinea  ) >
		
							<!--- salvo los ultimos cortes --->
							<cfset corte_req = rsLineas.ESolicitud & "_" & rsLineas.Alm_Aid >
						</cfif>	 <!--- requisicion --->
		
						<!--- Procesa las solicitudes --->
						<cfif solicitud >
							<!--- Si hay cortes, significa que se va a insertar un encabezado --->
							<cfif rsLineas.ESolicitud neq corte_sol >
				
								<!--- Calcula el numero de solicitud--->
								<cfquery name="rsNumero" datasource="#session.DSN#">
									select coalesce(max(ESnumero), 0)+1 as ESnumero
									from ESolicitudCompraCM 
									where Ecodigo= #session.Ecodigo# 
								</cfquery>
							
								<!--- Inserta el encabezado de solicitud y devuelve el id insertado --->
							<cftransaction>
								<cfquery name="insert_sol" datasource="#session.DSN#">
									insert into ESolicitudCompraCM(Ecodigo, ESnumero, Ocodigo, Dcodigo, CMGSid, CMSid, CMEcodigo, ESfecha, ESobservacion, ESusuario )
									values (  #session.Ecodigo# ,
											 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNumero.ESnumero#">, 
											 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Ocodigo#">,
											 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Dcodigo#">,
											 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGrupoSolic.CMGSid#">,
											 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGrupoSolic.CMSid#">,
											 'A',
											 <cf_dbfunction name="to_date00"	args="#rsDatos.ESfecha#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.ESobservacion#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">
										  )
									<cf_dbidentity1 datasource="#session.DSN#">
								</cfquery>
									<cf_dbidentity2 datasource="#session.DSN#" name="insert_sol">
								<cfset id_sol = insert_sol.identity >
							</cftransaction>
							</cfif>  <!--- corte por solicitud --->
		
							<!--- Procesa los Detalles de Solicitud--->
							<cfquery name="insert_detS" datasource="#session.DSN#" >
								insert into DSolicitudCompraCM ( Ecodigo, ESolicitud, ESnumero, CMTcodigo, DScant, Aid, Alm_Aid, DSdescripcion, DSobservacion, DScompradirecta, DSreflin)
								values (  #session.Ecodigo# , 
										 <cfqueryparam value="#id_sol#" 			   cfsqltype="cf_sql_numeric">, 
										 <cfqueryparam value="#rsNumero.ESnumero#" 	   cfsqltype="cf_sql_numeric">, 
										 <cfqueryparam value="A" 					   cfsqltype="cf_sql_char">, 
										 <cfqueryparam value="#cantidad_sol#" 		   cfsqltype="cf_sql_float">, 
										 <cfqueryparam value="#rsLineas.Aid#" 		   cfsqltype="cf_sql_numeric">,
										 <cfqueryparam value="#rsLineas.Alm_Aid#"      cfsqltype="cf_sql_numeric">, 
										 <cfqueryparam value="#rsDatos.DSdescripcion#" cfsqltype="cf_sql_varchar">, 
										 <cfqueryparam value="#rsDatos.DSobservacion#" cfsqltype="cf_sql_varchar">, 
										 1,
										 <cfqueryparam value="#rsLineas.DSlinea#" cfsqltype="cf_sql_numeric"> )
							</cfquery>			 
			
							<!--- salvo los ultimos cortes --->
							<cfset corte_sol = rsLineas.ESolicitud>
						</cfif> <!--- Solicitud --->
		
					</cfloop><!--- rsLineas --->
	
				</cfif> <!--- continuar --->
			</cftransaction>
		</cfif> <!---chk --->

	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>	
	</cftry>

</cfif><!--- btnAplicar --->

<cfparam name="action" default="listaCompras.cfm">

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="orden"   type="hidden" value="<cfif isdefined("form.orden")><cfoutput>#form.orden#</cfoutput></cfif>" >
	<input name="campo"  type="hidden" value="<cfif isdefined("form.campo")><cfoutput>#form.campo#</cfoutput></cfif>" >
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>