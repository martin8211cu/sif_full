<!--- 
La operacion del proceso es la siguiente:
	- Se tiene una tabla de entrada denominada IE20 que contiene los codigos que funcionan en el ICE, de categoria, clase,
	oficina, centro funcional.
	- Se actualizan esos codigos por las llaves internas reales, y se verifica en las tablas de vales la informacion correspondientes
	a fechas de inicio de depreciacion y revaluacion, ademas de serie , marca y modelo
	-Se insertan los datos en la tabla de transacciones reales
--->

<!--- Actualiza los siguientes datos con las llaves internas
		1. Centro de Custodia
		2. Tipo de Documento
		3. Empleado
		4. Categoria
		5. Clase
		6. Centro Funcional
		7. Oficina ( UEN o Segmento )
		8. Marca
		9. Modelo
		10. Tipo de Activo
	La información se debe tomar de ( en dicho orden ):
		1. Vales ( si existe el vale )
		2. Vale en Proceso ( si no existe el vale y existe el vale en proceso )
		3. De los datos que llegan, convertidos a códigos internos
--->

<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<cfquery name="rsObtieneLlaves" datasource="sifinterfaces">
	select GATplaca, Ecodigo, Referencia1, Referencia2, Referencia3
	from IE20
	where ID = #GvarID#
</cfquery>

<cfif rsObtieneLlaves.recordcount NEQ 1>
	<cfthrow message="No se encontró el registro de control de la interfaz. Proceso Cancelado!">
</cfif>

<cfset GvarEcodigo = rsObtieneLlaves.Ecodigo>
<cfset GvarGATplaca = rsObtieneLlaves.GATplaca>
<cfset GvarReferencia1 = rsObtieneLlaves.Referencia1>
<cfset GvarReferencia2 = rsObtieneLlaves.Referencia2>
<cfset GvarReferencia3 = rsObtieneLlaves.Referencia3>

<cfset LvarExisteVale = false>
<cfset LvarExisteValeTransito = false>
<cfset LvarEstatus = 0>

<cfset LvarExisteVale = fnVerificaValeExistente(GvarNI, GvarID, GvarEcodigo, GvarGATplaca)>
<cfif not LvarExisteVale>
	<cfset LvarExisteValeTransito = fnVerificaValeTransito(GvarNI, GvarID, GvarEcodigo, GvarGATplaca)>
</cfif>

<cfif LvarExisteVale>
	<cfset LvarEstatus = fnActualizaVale(GvarNI, GvarID, GvarEcodigo, GvarGATplaca)>
<cfelseif LvarExisteValeTransito>
	<cfset LvarEstatus = fnActualizaTransito(GvarNI, GvarID, GvarEcodigo, GvarGATplaca)>
<cfelse>
	<cfset LvarEstatus = fnActualizaInfo(GvarNI, GvarID, GvarEcodigo, GvarGATplaca)>
</cfif>

<cfset LvarEstatus = fnActualizaGATransacciones (GvarNI, GvarID, GvarEcodigo, GvarGATplaca, GvarReferencia1, GvarReferencia2, GvarReferencia3)>

<!--- VERIFICA SI LA INFO ESTA COMPLETA.  Se indica un estado en "1" si todos los datos son diferentes de nulo --->
<cfquery name="rsAFResp" datasource="sifinterfaces">
	update IE20
		set GATestado = 1
	where ID = #GvarID#
 	  and Cconcepto is not null
	  and GATperiodo is not null
	  and GATmes is not null
	  and GATfecha is not null
	  and CFid is not null
	  and ACid is not null
	  and ACcodigo is not null
	  and GATplaca is not null
	  and GATdescripcion is not null
	  and AFMid is not null
	  and AFMMid is not null
	  and AFCcodigo is not null
	  and Ocodigo is not null
	  and GATfechainidep is not null
	  and GATfechainirev is not null
	  and GATmonto is not null
	  and CFcuenta is not null
	  and DEid is not null
	  and CRCCid is not null
	  and CRTDid is not null
</cfquery>

<cffunction name="fnVerificaValeExistente" access="private" returntype="boolean" hint="Verifica Existencia de Vale para el Activo" output="no">
	<cfargument name="LvarNI" 		type="numeric" required="yes">
	<cfargument name="LvarID" 		type="numeric" required="yes">
	<cfargument name="LvarEcodigo" 	type="numeric" required="yes">
	<cfargument name="LvarGATplaca" type="string"  required="yes">

	<cfquery name="rs" datasource="#session.DSN#">
		Select count(1) as total
		from Activos a
			inner join AFResponsables r
			on  r.Aid     = a.Aid
			and r.Ecodigo = a.Ecodigo
		where a.Ecodigo = #Arguments.LvarEcodigo#
		  and a.Aplaca  = '#Arguments.LvarGATplaca#'
	</cfquery>

	<cfif rs.total GT 0>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="fnVerificaValeTransito" access="private" returntype="boolean" hint="Verifica Existencia de Vale en Transito para el Activo" output="no">
	<cfargument name="LvarNI" type="numeric" required="yes">
	<cfargument name="LvarID" type="numeric" required="yes">
	<cfargument name="LvarEcodigo" 	type="numeric" required="yes">
	<cfargument name="LvarGATplaca" type="string" required="yes">

	<cfquery name="rs" datasource="#session.DSN#">
		Select count(1) as total
		from CRDocumentoResponsabilidad a
		where a.Ecodigo    = #Arguments.LvarEcodigo#
		  and a.CRDRplaca  = '#Arguments.LvarGATplaca#'
	</cfquery>

	<cfif rs.total GT 0>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="fnActualizaVale" access="private" output="no" returntype="boolean" hint="Actualiza la información desde la información contenida en el Vale">
	<cfargument name="LvarNI" 		type="numeric" required="yes">
	<cfargument name="LvarID" 		type="numeric" required="yes">
	<cfargument name="LvarEcodigo" 	type="numeric" required="yes">
	<cfargument name="LvarGATplaca" type="string" required="yes">

	<cftransaction isolation="read_uncommitted">
		<!--- Obtiene el máximo vale vigente en la fecha del proceso - Por si hay más de uno --->
		<cfquery name="rs" datasource="#session.dsn#">
			select max(r.AFRid) as AFRid
			from Activos a
				inner join AFResponsables r
				on  r.Aid     = a.Aid 
				and r.Ecodigo = a.Ecodigo
			where a.Aplaca = '#Arguments.LvarGATplaca#'
			  and a.Ecodigo = #Arguments.LvarEcodigo#
			  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between AFRfini and AFRffin
		</cfquery>
	</cftransaction>

	<cfif rs.recordcount NEQ 1>
		<cfthrow message="No se encontró el vale de Activo correspondiente.  Proceso Cancelado!">
	</cfif>
	<cfset LvarAFRid = rs.AFRid>

	<cftransaction isolation="read_uncommitted">
		<cfquery name="rs" datasource="#session.dsn#">
			select a.AFMid, a.AFMMid, a.Aserie, r.DEid, r.CRCCid, r.CRTDid, a.Afechainidep, a.Afechainirev
			from AFResponsables r
				inner join Activos a
				on a.Aid = r.Aid
			where r.AFRid = #LvarAFRid#
		</cfquery>
	</cftransaction>
	
	<cfset LvarAFMid = rs.AFMid>
	<cfset LvarAFMMid = rs.AFMMid>
	<cfset LvarAserie = rs.Aserie>
	<cfset LvarDEid = rs.DEid>
	<cfset LvarCRCCid = rs.CRCCid>
	<cfset LvarCRTDid = rs.CRTDid>
	<cfset LvarAfechainidep = rs.Afechainidep>
	<cfset LvarAfechainirev = rs.Afechainirev>

	<cfquery datasource="sifinterfaces">
		update IE20
		set
			AFMid     		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAFMid#" null="#len(LvarAFMid) eq 0#">,
			AFMMid 	  		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAFMMid#" null="#len(LvarAFMMid) eq 0#">,
			GATserie  		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarAserie#" null="#len(LvarAserie) eq 0#">,
			DEid      		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarDEid#"   null="#len(LvarDEid) eq 0#">,
			CRCCid    		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCRCCid#" null="#len(LvarCRCCid) eq 0#">,
			CRTDid    		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCRTDid#" null="#len(LvarCRTDid) eq 0#">,
			GATfechainidep  = <cfqueryparam cfsqltype="cf_sql_date"	 value="#LvarAfechainidep#" null="#len(LvarAfechainidep) eq 0#">,
			GATfechainirev	= <cfqueryparam cfsqltype="cf_sql_date"	 value="#LvarAfechainirev#" null="#len(LvarAfechainirev) eq 0#">
		where ID = #Arguments.LvarID#
	</cfquery>
	<cfreturn true>
</cffunction>

<cffunction name="fnActualizaTransito" access="private" output="no" returntype="boolean" hint="Actualiza la información desde la información contenida en el Vale en Transito">
	<cfargument name="LvarNI" 		type="numeric" required="yes">
	<cfargument name="LvarID" 		type="numeric" required="yes">
	<cfargument name="LvarEcodigo" 	type="numeric" required="yes">
	<cfargument name="LvarGATplaca" type="string" required="yes">

	<cftransaction isolation="read_uncommitted">
		<cfquery name="rs" datasource="#session.dsn#">
			select AFMid, AFMMid, CRDRserie, DEid, CRCCid, CRTDid, CRDRfdocumento
			from CRDocumentoResponsabilidad
			where CRDRplaca = '#Arguments.LvarGATplaca#'
			  and Ecodigo   = #Arguments.LvarEcodigo#
		</cfquery>
	</cftransaction>
	
	<cfset LvarAFMid = rs.AFMid>
	<cfset LvarAFMMid = rs.AFMMid>
	<cfset LvarAserie = rs.CRDRserie>
	<cfset LvarDEid   = rs.DEid>
	<cfset LvarCRCCid = rs.CRCCid>
	<cfset LvarCRTDid = rs.CRTDid>
	<cfset LvarAfechainidep = dateadd("m", 1, rs.CRDRfdocumento)>
	<cfset LvarAfechainirev = dateadd("m", 1, rs.CRDRfdocumento)>

	<cfquery datasource="sifinterfaces">
		update CRDocumentoResponsabilidad
		set CRDRutilaux = 1
		where CRDRplaca = '#Arguments.LvarGATplaca#'
		  and Ecodigo   = #Arguments.LvarEcodigo#
	</cfquery>	

	<cfquery datasource="sifinterfaces">
		update IE20
		set
			AFMid     		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAFMid#" null="#len(LvarAFMid) eq 0#">,
			AFMMid 	  		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAFMMid#" null="#len(LvarAFMMid) eq 0#">,
			GATserie  		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarAserie#" null="#len(LvarAserie) eq 0#">,
			DEid      		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarDEid#"   null="#len(LvarDEid) eq 0#">,
			CRCCid    		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCRCCid#" null="#len(LvarCRCCid) eq 0#">,
			CRTDid    		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCRTDid#" null="#len(LvarCRTDid) eq 0#">,
			GATfechainidep  = <cfqueryparam cfsqltype="cf_sql_date"	 value="#LvarAfechainidep#" null="#len(LvarAfechainidep) eq 0#">,
			GATfechainirev	= <cfqueryparam cfsqltype="cf_sql_date"	 value="#LvarAfechainirev#" null="#len(LvarAfechainirev) eq 0#">
		where ID = #Arguments.LvarID#
	</cfquery>
	<cfreturn true>
</cffunction>


<cffunction name="fnActualizaInfo" access="private" output="no" returntype="boolean" hint="Actualiza los datos en la tabla de Interfaz si no existen vales o transito">
	<cfargument name="LvarNI" 		type="numeric" required="yes">
	<cfargument name="LvarID" 		type="numeric" required="yes">
	<cfargument name="LvarEcodigo" 	type="numeric" required="yes">
	<cfargument name="LvarGATplaca" type="string" required="yes">

	<cfset LvarEcodigo = arguments.LvarEcodigo>
	<cfset LvarGATplaca = arguments.LvarGATplaca>

	<cfquery name="rs" datasource="sifinterfaces">
		select CRCCcodigo, CRTDcodigo, DEidentificacion, AF2CAT, AF3COD, I04COD, Oficodigo, AFMcodigo, AFMMcodigo, AFCcodigoclas
		from IE20
		where ID = #Arguments.LvarID#
	</cfquery>
	
	<cfset LvarCRCCcodigo = rs.CRCCcodigo>
	<cfset LvarCRTDcodigo = rs.CRTDcodigo>
	<cfset LvarDEidentificacion = rs.DEidentificacion>
	<cfset LvarAF2CAT = rs.AF2CAT>
	<cfset LvarAF3COD = rs.AF3COD>
	<cfset LvarI04COD = rs.I04COD>
	<cfset LvarOficodigo = rs.Oficodigo>
	<cfset LvarAFMcodigo = rs.AFMcodigo>
	<cfset LvarAFMMcodigo = rs.AFMMcodigo>
	<cfset LvarAFCcodigoclas = rs.AFCcodigoclas>

	<cftransaction isolation="read_uncommitted">
		<cfquery name="rs" datasource="#session.dsn#">
			select CRCCid
			from CRCentroCustodia
			where CRCCcodigo = '#LvarCRCCcodigo#'
			  and Ecodigo    = #LvarEcodigo#
		</cfquery>
		<cfset LvarCRCCid = rs.CRCCid>
		
		<cfquery name="rs" datasource="#session.dsn#">
			select CRTDid
			from CRTipoDocumento
			where CRTDcodigo = '#LvarCRTDcodigo#'
			  and Ecodigo = #LvarEcodigo#
		</cfquery>
		<cfset LvarCRTDid = rs.CRTDid>
		
		<cfquery name="rs" datasource="#session.dsn#">
			select DEid
			from DatosEmpleado
			where DEidentificacion = '#LvarDEidentificacion#'
			  and Ecodigo = #LvarEcodigo#
		</cfquery>
		<cfset LvarDEid = rs.DEid>

		<cfquery name="rs" datasource="#session.dsn#">
			select ACcodigo
			from ACategoria
			where ACcodigodesc = '#LvarAF2CAT#'
			  and Ecodigo = #LvarEcodigo#
		</cfquery>
		<cfset LvarACcodigo = rs.ACcodigo>
		
		<cfquery name="rs" datasource="#session.dsn#">
			select ACid
			from AClasificacion
			where Ecodigo      = #LvarEcodigo#
			  and ACcodigo     = <cfif len(LvarACcodigo) neq 0>#LvarACcodigo#<cfelse> -1 </cfif>
			  and ACcodigodesc = '#LvarAF3COD#'
		</cfquery>
		<cfset LvarACid = rs.ACid>

		<cfquery name="rs" datasource="#session.dsn#">
			select CFid
			from CFuncional
			where Ecodigo      = #LvarEcodigo#
			  and CFcodigo     = '#LvarI04COD#'
		</cfquery>
		<cfset LvarCFid = rs.CFid>

		<cfquery name="rs" datasource="#session.dsn#">
			select Ocodigo
			from Oficinas
			where Ecodigo = #LvarEcodigo#
			  and Oficodigo = '#LvarOficodigo#'
		</cfquery>		
		<cfset LvarOcodigo = rs.Ocodigo>

		<cfquery name="rs" datasource="#session.dsn#">
			select AFMid 
			from AFMarcas
			where Ecodigo = #LvarEcodigo#
			and AFMcodigo = '#LvarAFMcodigo#'
		</cfquery>
		<cfset LvarAFMid = rs.AFMid>
		
		<cfquery name="rs" datasource="#session.dsn#">
			select AFMMid 
			from AFMModelos
			where Ecodigo = #LvarEcodigo#
			and   AFMid   = <cfif len(LvarAFMid) neq 0>#LvarAFMid#<cfelse> -1 </cfif> 
			and   AFMMcodigo = '#LvarAFMMcodigo#'
		</cfquery>
		<cfset LvarAFMMid = rs.AFMMid>

		<cfquery name="rs" datasource="#session.dsn#">
			select AFCcodigo
			from AFClasificaciones
			where Ecodigo = #LvarEcodigo#
			  and AFCcodigoclas = '#LvarAFCcodigoclas#'
		</cfquery>		
		<cfset LvarAFCcodigo = rs.AFCcodigo>

	</cftransaction>

	<cfquery datasource="sifinterfaces">
		update IE20
		set 
			CRCCid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCRCCid#" null="#len(LvarCRCCid) eq 0#">,
			CRTDid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCRTDid#" null="#len(LvarCRTDid) eq 0#">,
			DEid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarDEid#" null="#len(LvarDEid) eq 0#">,
			ACcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarACcodigo#" null="#len(LvarACcodigo) eq 0#">,
			ACid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarACid#" null="#len(LvarACid) eq 0#">,
			CFid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCFid#" null="#len(LvarCFid) eq 0#">,
			Ocodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarOcodigo#" null="#len(LvarOcodigo) eq 0#">,
			AFMid	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAFMid#" null="#len(LvarAFMid) eq 0#">,
			AFMMid	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAFMMid#" null="#len(LvarAFMMid) eq 0#">,
			AFCcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarAFCcodigo#" null="#len(LvarAFCcodigo) eq 0#">
		where ID = #Arguments.LvarID#
	</cfquery>
	<cfreturn true>
</cffunction>

<!--- MODIFICA LOS DATOS EN GATRANSACCIONES--->
<cffunction name="fnActualizaGATransacciones" access="private" output="no" hint="Actualiza los datos en la tabla GATransacciones - Tabla de Control para conciliacion Contable">
	<cfargument name="LvarNI" 			type="numeric" 	required="yes">
	<cfargument name="LvarID" 			type="numeric" 	required="yes">
	<cfargument name="LvarEcodigo" 		type="numeric" 	required="yes">
	<cfargument name="LvarGATplaca" 	type="string" 	required="yes">
	<cfargument name="LvarReferencia1" 	type="string" 	required="no" 	default=" ">
	<cfargument name="LvarReferencia2" 	type="string" 	required="no"	default=" ">
	<cfargument name="LvarReferencia3" 	type="string" 	required="no" 	default=" ">

	<cfquery name="rs" datasource="sifinterfaces">
		select 
			a.GATdescripcion, a.Ocodigo,  a.ACid,  a.ACcodigo, a.AFMid, a.AFMMid,
			a.GATserie, a.GATplaca, a.GATfechainidep, a.GATfechainirev,
			a.CFid, a.GATmonto, coalesce(a.GATestado, 0) as GATestado,
			a.AFCcodigo, a.DEid, a.CRCCid, a.CRTDid,  coalesce(a.GATvutil, 0) as GATvutil,
			a.Cconcepto, a.GATperiodo, a.GATmes, a.GATfecha, CFcuenta, GATReferencia
		from IE20 a
		where a.ID = #Arguments.LvarID#
	</cfquery>

	<cfset LvarGATdescripcion 	= rs.GATdescripcion>
	<cfset LvarOcodigo			= rs.Ocodigo>
	<cfset LvarACid				= rs.ACid>
	<cfset LvarACcodigo			= rs.ACcodigo>
	<cfset LvarAFMid			= rs.AFMid>
	<cfset LvarAFMMid			= rs.AFMMid>
	<cfset LvarGATserie			= rs.GATserie>
	<cfset LvarGATplaca			= rs.GATplaca>
	<cfset LvarGATfechainidep	= rs.GATfechainidep>
	<cfset LvarGATfechainirev	= rs.GATfechainirev>
	<cfset LvarCFid				= rs.CFid>
	<cfset LvarGATmonto			= rs.GATmonto>
	<cfset LvarGATestado		= rs.GATestado>
	<cfset LvarAFCcodigo		= rs.AFCcodigo>
	<cfset LvarDEid				= rs.DEid>
	<cfset LvarCRCCid			= rs.CRCCid>
	<cfset LvarCRTDid			= rs.CRTDid>
	<cfset LvarGATvutil			= rs.GATvutil>
	<cfset LvarCconcepto		= rs.Cconcepto>
	<cfset LvarGATperiodo		= rs.GATperiodo>
	<cfset LvarGATmes			= rs.GATmes>
	<cfset LvarGATfecha			= rs.GATfecha>
	<cfset LvarCFcuenta			= rs.CFcuenta>
	<cfset LvarGATReferencia	= rs.GATReferencia>

	<cfquery name="rs" datasource="#session.dsn#">
		select ID as ID
		from GATransacciones
		where Ecodigo      = #Arguments.LvarEcodigo#
		  and Referencia1  = '#Arguments.LvarReferencia1#'
		  and Referencia2  = '#Arguments.LvarReferencia2#'
		  and Referencia3  = '#Arguments.LvarReferencia3#'
	</cfquery>

	<cfif rs.recordcount GT 1>
		<cfthrow message="Existe mas de un Registro en la tabla GATransacciones con los datos #LvarReferencia1# #LvarReferencia2# #LvarReferencia3#.  Proceso Cancelado!">
	</cfif>

	<cfset LvarExisteRegistro = false>
	
	<cfif rs.recordcount eq 1 and rs.ID GT 0>
		<cfset LvarExisteRegistro = true>
		<cfset LvarIDGATransacciones = rs.ID>
	</cfif>

	<cfif LvarExisteRegistro>
		<cfquery name="rsInclusion" datasource="#session.DSN#">
			update GATransacciones
			set GATdescripcion 		= <cfif len(LvarGATdescripcion)>'#LvarGATdescripcion#'<cfelse>null</cfif>,
				Ocodigo 			= <cfif len(LvarOcodigo)>#LvarOcodigo#<cfelse>null</cfif>,
				ACid 				= <cfif len(LvarACid)>#LvarACid#<cfelse>null</cfif>,
				ACcodigo 			= <cfif len(LvarACcodigo)>#LvarACcodigo#<cfelse>null</cfif>,
				AFMid 				= <cfif len(LvarAFMid)>#LvarAFMid#<cfelse>null</cfif>,
				AFMMid 				= <cfif len(LvarAFMMid)>#LvarAFMMid#<cfelse>null</cfif>,
				GATserie 			= <cfif len(LvarGATserie)>'#LvarGATserie#'<cfelse>null</cfif>,
				GATplaca 			= <cfif len(LvarGATplaca)>'#LvarGATplaca#'<cfelse>null</cfif>,
				GATfechainidep 		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarGATfechainidep#" null="#len(LvarGATfechainidep) eq 0#">,
				GATfechainirev 		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarGATfechainirev#" null="#len(LvarGATfechainirev) eq 0#">,
				CFid 				= <cfif len(LvarCFid)>#LvarCFid#<cfelse>null</cfif>,
				GATmonto 			= <cfif len(LvarGATmonto)>#LvarGATmonto#<cfelse>null</cfif>,
				fechaalta 			= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				GATestado 			= <cfif len(LvarGATestado)>#LvarGATestado#<cfelse>null</cfif>,
				AFCcodigo 			= <cfif len(LvarAFCcodigo)>#LvarAFCcodigo#<cfelse>null</cfif>,
				DEid 				= <cfif len(LvarDEid)>#LvarDEid#<cfelse>null</cfif>,
				CRCCid 				= <cfif len(LvarCRCCid)>#LvarCRCCid#<cfelse>null</cfif>,
				CRTDid 				= <cfif len(LvarCRTDid)>#LvarCRTDid#<cfelse>null</cfif>,
				GATvutil 			= <cfif len(LvarGATvutil)>#LvarGATvutil#<cfelse>null</cfif>
			where ID = #LvarIDGATransacciones#
		</cfquery>
	<cfelse>
		<cfquery name="rsInclusion" datasource="#session.dsn#">
			INSERT into GATransacciones (						
					Ecodigo,
					Cconcepto,
					GATperiodo,
					GATmes,
					GATfecha,
					GATdescripcion,
					Ocodigo,
					ACid,
					ACcodigo,
					AFMid,
					AFMMid,
					GATserie,
					GATplaca,
					GATfechainidep,
					GATfechainirev,
					CFid,
					GATmonto,
					fechaalta,
					BMUsucodigo,
					Referencia1,
					Referencia2,
					Referencia3,
					CFcuenta,
					GATestado,
					AFCcodigo,
					GATReferencia,
					DEid,
					CRCCid,
					CRTDid,
					GATvutil
				)
			values (
					#Arguments.LvarEcodigo#,
					<cfif len(LvarCconcepto)>#LvarCconcepto#<cfelse>null</cfif>,
					<cfif len(LvarGATperiodo)>#LvarGATperiodo#<cfelse>null</cfif>,
					<cfif len(LvarGATmes)>#LvarGATmes#<cfelse>null</cfif>,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarGATfecha#">,
					<cfif len(LvarGATdescripcion)>'#LvarGATdescripcion#'<cfelse>null</cfif>,
					<cfif len(LvarOcodigo)>#LvarOcodigo#<cfelse>null</cfif>,
					<cfif len(LvarACid)>#LvarACid#<cfelse>null</cfif>,
					<cfif len(LvarACcodigo)>#LvarACcodigo#<cfelse>null</cfif>,
					<cfif len(LvarAFMid)>#LvarAFMid#<cfelse>null</cfif>,
					<cfif len(LvarAFMMid)>#LvarAFMMid#<cfelse>null</cfif>,
					<cfif len(LvarGATserie)>'#LvarGATserie#'<cfelse>null</cfif>,
					<cfif len(LvarGATplaca)>'#LvarGATplaca#'<cfelse>null</cfif>,
					<cfqueryparam cfsqltype="cf_sql_date" value="#LvarGATfechainidep#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#LvarGATfechainirev#">,
					<cfif len(LvarCFid)>#LvarCFid#<cfelse>null</cfif>,
					<cfif len(LvarGATmonto)>#LvarGATmonto#<cfelse>null</cfif>,
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
					<cfif isdefined("session.Usucodigo") and len(session.Usucodigo)>#session.Usucodigo#<cfelse>0</cfif>,
					<cfif len(Arguments.LvarReferencia1)>'#Arguments.LvarReferencia1#'<cfelse>null</cfif>,
					<cfif len(Arguments.LvarReferencia2)>'#Arguments.LvarReferencia2#'<cfelse>null</cfif>,
					<cfif len(Arguments.LvarReferencia3)>'#Arguments.LvarReferencia3#'<cfelse>null</cfif>,
					<cfif len(LvarCFcuenta)>#LvarCFcuenta#<cfelse>null</cfif>,
					<cfif len(LvarGATestado)>#LvarGATestado#<cfelse>null</cfif>,
					<cfif len(LvarAFCcodigo)>#LvarAFCcodigo#<cfelse>null</cfif>,
					<cfif len(LvarGATReferencia)>'#LvarGATReferencia#'<cfelse>null</cfif>,
					<cfif len(LvarDEid)>#LvarDEid#<cfelse>null</cfif>,
					<cfif len(LvarCRCCid)>#LvarCRCCid#<cfelse>null</cfif>,
					<cfif len(LvarCRTDid)>#LvarCRTDid#<cfelse>null</cfif>,
					<cfif len(LvarGATvutil)>#LvarGATvutil#<cfelse>null</cfif>
			)
		</cfquery>
	</cfif>
	<cfreturn true>
</cffunction>
