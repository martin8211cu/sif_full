<cfcomponent>
	<cffunction name="ALTA_LIBERACION" access="public" returntype="numeric">
		<cfargument name="COEGid" 				type="numeric" 	required="yes">
		<cfargument name="COLGObservacion" 		type="string" 	required="yes">
		<cfargument name="COLGFecha" 			type="date" 	required="no" default="#now()#">
		<cfargument name="COLGUsucodigo" 		type="numeric" 	required="yes">
		<cfargument name="COLGTipoMovimiento" 	type="numeric" 	required="yes">
		<cfargument name="COEGVersion" 			type="numeric" 	required="yes">
		<cfargument name="Ecodigo" 				type="numeric" 	required="no" default="#session.Ecodigo#">
		<cfargument name="BMUsucodigo" 			type="numeric" 	required="no" default="#session.Usucodigo#">
		<cfargument name="Conexion" 			type="string" 	required="no" default="#session.DSN#">
		
		<cfquery name="rsInserta" datasource="#arguments.Conexion#">
			insert into COLiberaGarantia(
				COEGid,
				Ecodigo,
				COLGObservacion,
				COLGFecha,
				COLGUsucodigo,
				COLGTipoMovimiento,
				COLGEstado,
				COEGVersion,
				BMUsucodigo
		   )
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.COEGid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar"	value="#arguments.COLGObservacion#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#arguments.COLGFecha#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.COLGUsucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" 	value="#arguments.COLGTipoMovimiento#">,
				2,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.COEGVersion#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.BMUsucodigo#">				
			)
      	  <cf_dbidentity1 datasource="#arguments.Conexion#">
    	</cfquery>
    	<cf_dbidentity2 datasource="#arguments.Conexion#" name="rsInserta" returnvariable="LvarCOLGid">
		<cfreturn #LvarCOLGid#>
	</cffunction>
	
	<cffunction name="CAMBIO_GARANTIA" access="public" returntype="numeric">
		<cfargument name="COEGid" 				type="numeric" 	required="yes">
		<cfargument name="COEGVersion" 			type="numeric" 	required="yes">
		<cfargument name="COEGEstado" 			type="numeric" 	required="yes">
		<cfargument name="Ecodigo" 				type="numeric" 	required="no" default="#session.Ecodigo#">
		<cfargument name="BMUsucodigo" 			type="numeric" 	required="no" default="#session.Usucodigo#">
		<cfargument name="Conexion" 			type="string" 	required="no" default="#session.DSN#">
		<cfargument name="COEGVersionActiva" 	type="numeric" 	required="no">
		<cfargument name="COEGTipoGarantia" 	type="numeric" 	required="no">
		<cfquery datasource="#arguments.Conexion#">
			update COHEGarantia	set
				COEGEstado 	=	<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.COEGEstado#">,
				BMUsucodigo =	<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.BMUsucodigo#">
			where COEGid 	= 	<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.COEGid#">	
				and COEGVersion = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.COEGVersion#">
				and Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#arguments.Ecodigo#">
				<cfif isdefined('arguments.COEGVersionActiva')>
					and COEGVersionActiva = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#arguments.COEGVersion#">
				</cfif>
				<cfif isdefined('arguments.COEGTipoGarantia')>
					and COEGTipoGarantia = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.COEGTipoGarantia#">
				</cfif>
    	</cfquery>
		<cfreturn #arguments.COEGid#>
	</cffunction>
	
	<cffunction name="CAMBIO_GARANTIA_DEVOLUCION" access="public" returntype="numeric">
		<cfargument name="COEGid" 					type="numeric" 	required="yes">
		<cfargument name="COEGVersion" 				type="numeric" 	required="yes">
		<cfargument name="COEGEstado" 				type="numeric" 	required="yes">
		<cfargument name="COEGFechaDevOEjec" 		type="date" 	required="yes">
		<cfargument name="COEGUsuCodigoDevOEjec" 	type="numeric" 	required="no" default="#session.Usucodigo#">
		<cfargument name="Ecodigo" 					type="numeric" 	required="no" default="#session.Ecodigo#">
		<cfargument name="BMUsucodigo" 				type="numeric" 	required="no" default="#session.Usucodigo#">
		<cfargument name="Conexion" 				type="string" 	required="no" default="#session.DSN#">
		<cfquery name="rsInserta" datasource="#arguments.Conexion#">
			update COHEGarantia	set
				COEGEstado 				= <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#arguments.COEGEstado#">,
				BMUsucodigo 			= <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#arguments.BMUsucodigo#">,
				COEGFechaDevOEjec 		= <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#arguments.COEGFechaDevOEjec#">,
				COEGUsuCodigoDevOEjec 	= <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#arguments.COEGUsuCodigoDevOEjec#">
			where COEGid 				= <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#arguments.COEGid#">	
				and COEGVersion 		= <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#arguments.COEGVersion#">
				and COEGEstado 			= 7 <!---  Liberada --->
		  		and COEGVersionActiva 	= 1 <!--- Version activa --->
				and Ecodigo 			= <cfqueryparam cfsqltype="cf_sql_integer" 		value="#arguments.Ecodigo#">
    	</cfquery>
		<cfreturn #arguments.COEGid#>
	</cffunction>
	
	<cffunction name="CAMBIO_GARANTIA_EJECUCION" access="public" returntype="numeric">
		<cfargument name="COEGid" 				type="numeric" 	required="yes">
		<cfargument name="COEGVersion" 			type="numeric" 	required="yes">
		<cfargument name="COEGEstado" 			type="numeric" 	required="yes">
		<cfargument name="COEGFechaDevOEjec" 	type="date" 	required="yes">
		<cfargument name="COEGUsuCodigoDevOEjec" type="numeric" required="no" default="#session.Usucodigo#">
		<cfargument name="COEGDocDevOEjec" 		type="string" 	required="no" default="">
		<cfargument name="Ecodigo" 				type="numeric" 	required="no" default="#session.Ecodigo#">
		<cfargument name="BMUsucodigo" 			type="numeric" 	required="no" default="#session.Usucodigo#">
		<cfargument name="Conexion" 			type="string" 	required="no" default="#session.DSN#">
		<cfquery name="rsInserta" datasource="#arguments.Conexion#">
			update COHEGarantia	set
				COEGEstado 	=	<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.COEGEstado#">,
				BMUsucodigo =	<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.BMUsucodigo#">,
				COEGDocDevOEjec = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.COEGDocDevOEjec#">,
				COEGFechaDevOEjec = <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#arguments.COEGFechaDevOEjec#">,
				COEGUsuCodigoDevOEjec = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.COEGUsuCodigoDevOEjec#">
			where COEGid 	= 	<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.COEGid#">	
				and COEGVersion = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.COEGVersion#">
				and COEGEstado = 4 <!---  Liberada --->
		  		and COEGVersionActiva = 1 <!--- Version activa --->
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#arguments.Ecodigo#">
    	</cfquery>
		<cfreturn #arguments.COEGid#>
	</cffunction>
	
	<cffunction name="CAMBIO_LIBERACION_GARANTIA_APRUEBA" access="public" returntype="numeric">
		<cfargument name="COLGid" 				type="numeric" 	required="yes">
		<cfargument name="COEGEstado" 			type="numeric" 	required="yes">
		<cfargument name="FechaAprueba" 		type="date" 	required="yes">
		<cfargument name="UsuarioAprueba" 		type="numeric" 	required="no" default="#session.Usucodigo#">
		<cfargument name="BMUsucodigo" 			type="numeric" 	required="no" default="#session.Usucodigo#">
		<cfargument name="Ecodigo" 				type="numeric" 	required="no" default="#session.Ecodigo#">
		<cfargument name="Conexion" 			type="string" 	required="no" default="#session.DSN#">
		<cfquery name="rsInserta" datasource="#arguments.Conexion#">
			update COLiberaGarantia	set
				COLGEstado 	=	<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.COEGEstado#">,
				COLGFechaAprobacion = <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#arguments.FechaAprueba#">,
				COLGUsucodigoAprueba = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.UsuarioAprueba#">,
				Ecodigo 	=	<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.Ecodigo#">,
				BMUsucodigo =	<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.BMUsucodigo#">
			where COLGid 	= 	<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.COLGid#">	
    	</cfquery>
		<cfreturn #arguments.COLGid#>
	</cffunction>
	
	<cffunction name="CAMBIO_LIBERACION_GARANTIA_RECHAZO" access="public" returntype="numeric">
		<cfargument name="COLGid" 				type="numeric" 	required="yes">
		<cfargument name="COEGEstado" 			type="numeric" 	required="yes">
		<cfargument name="FechaRechazo" 		type="date" 	required="yes">
		<cfargument name="UsuarioRechaza" 		type="numeric" 	required="no" default="#session.Usucodigo#">
		<cfargument name="BMUsucodigo" 			type="numeric" 	required="no" default="#session.Usucodigo#">
		<cfargument name="Ecodigo" 				type="numeric" 	required="no" default="#session.Ecodigo#">
		<cfargument name="Conexion" 			type="string" 	required="no" default="#session.DSN#">
		<cfquery name="rsInserta" datasource="#arguments.Conexion#">
			update COLiberaGarantia	set
				COLGEstado 	=	<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.COEGEstado#">,
				COLGFechaRechazo = <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#arguments.FechaRechazo#">,
				COLGUsucodigoRechaza = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.UsuarioRechaza#">,
				Ecodigo 	=	<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.Ecodigo#">,
				BMUsucodigo =	<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.BMUsucodigo#">
			where COLGid 	= 	<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.COLGid#">	
    	</cfquery>
		<cfreturn #arguments.COLGid#>
	</cffunction>
	
	<cffunction name="fnGenerarAsientoEjecucion" access="public" output="no" returntype="any">
		<cfargument name="COEGid" 			type="numeric"  required="yes">
		<cfargument name="COEGVersion" 		type="numeric"  required="yes">
		<cfargument name='Conexion' 		type='string' 	required='false' default	= "#Session.DSN#">
		<cfargument name='Ecodigo' 			type='numeric' 	required='false' default	= "#Session.Ecodigo#">
		<cfargument name='FechaGenAsiento' 	type='date' 	required='false' default	= "#now()#">
		
		
		<cfset LobjCONTA	= createObject( "component","sif.Componentes.CG_GeneraAsiento")>
		<cfset INTARC 		= LobjCONTA.CreaIntarc(Arguments.Conexion)>
		<!--- 
			CxC Socio:  Débito
			Ingreso x garantía: Crédito
		 --->
	
		<!--- Garantía Recibida:  Débito --->
		<cfset LvarAnoAux 				= fnGetParametro (Arguments.Ecodigo, 50,  "Periodo de Auxiliares")>
		<cfset LvarMesAux 				= fnGetParametro (Arguments.Ecodigo, 60,  "Mes de Auxiliares")>
	
		<!---==Obtiene la minima oficina del Asiento, si no tienen entonces la minina Oficina para la empresa==---> 
		<!---==============La oficina se le manda al genera asiento para que agrupe===========================--->
		<cfquery name="rsMinOficinaINTARC" datasource="#session.dsn#">
			select Min(Ocodigo) as MinOcodigo
			from #INTARC#
		</cfquery>
		<cfquery name="rsMinOficina" datasource="#session.dsn#">
			select Min(Ocodigo) as MinOcodigo
			from Oficinas
			where Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfif isdefined("rsMinOficinaINTARC") and rsMinOficinaINTARC.recordcount GT 0 and len(trim(rsMinOficinaINTARC.MinOcodigo))>
			<cfset LvarOcodigo = rsMinOficinaINTARC.MinOcodigo>
		<cfelseif isdefined("rsMinOficina") and rsMinOficina.recordcount GT 0>
			<cfset LvarOcodigo = rsMinOficina.MinOcodigo>
		<cfelse>
			<cfset LvarOcodigo = -100>
		</cfif>
		
		<cf_dbfunction name="to_char" args="a.COEGReciboGarantia" returnvariable="LvarRecibo">
		<cf_dbfunction name="concat" args="'Garantía recibo n°: ' + #trim(LvarRecibo)# + ', Proveedor: ' + c.SNidentificacion" delimiters="+" conexion="#Arguments.Conexion#" returnvariable="LvarDescripcionRecibo">
		<!--- Se busca en el histórico la versión anterior para hacer la línea del asiento negativo de la Cuenta Garantía Recivida: Débito --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			insert into #INTARC# 
				( 
					INTORI, 
					INTREL, 
					INTDOC, 
					
					INTREF, 
					INTTIP, 
					
					INTDES, 
					INTFEC, 
					Periodo, 
					Mes, 
					Ccuenta, 
					Ocodigo, 
					Mcodigo, 
					INTMOE, 
					INTCAM, 
					INTMON
				)
			select 
					'COGA',
					1,
					#preservesinglequotes(LvarRecibo)#,		
					'GARANTIA', 
					'D',
					#preservesinglequotes(LvarDescripcionRecibo)#,
					'#dateFormat(arguments.FechaGenAsiento,"YYYYMMDD")#',
					#LvarAnoAux#,
					#LvarMesAux#,
					c.SNcuentacxc,
					#LvarOcodigo#,
					a.Mcodigo,
					a.COEGMontoTotal,
					coalesce(htc.TCcompra, 1), <!---  Tipo de cambio --->
					a.COEGMontoTotal * coalesce(htc.TCcompra, 1)
			from COHEGarantia a
				inner join SNegocios c
					inner join CContables e
						on c.SNcuentacxc = e.Ccuenta and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					on c.SNid = a.SNid and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				left outer join Htipocambio htc 
					   on htc.Mcodigo = a.Mcodigo 
					   and htc.Ecodigo = #session.Ecodigo# 
					   and a.COEGFechaRecibe  BETWEEN htc.Hfecha and  htc.Hfechah
			where a.COEGid = #arguments.COEGid#
			  and a.COEGVersion = #arguments.COEGVersion#
			  and a.COEGEstado = 3   <!--- En proceso de Ejecución --->
			   and a.COEGVersionActiva = 1 <!--- Activa --->
		</cfquery>
		<cfquery name="temp" datasource="#arguments.Conexion#">
			select count(1) as cantidad from 	#INTARC# 
		</cfquery>
		
		<cfif temp.cantidad eq 0>
			<cfoutput>
			<table align="center" border="0">
				<tr><td>&nbsp;</td></tr>
				<tr align="center"><td>
					No se han insertado datos en la tabla temporal, Proceso Cancelado!!!.
					<br><br>
					Puede que se deba a que el socio de negocio no posee una cuenta por cobrar definida.
				</td>
				</tr>
				<td>
					<form method="post" action="listaAprobarEjecucionGarantia.cfm">
						<cf_botones modo="ALTA" include="Regresar" exclude="ALTA,Limpiar">
						<input name="modo" id="modo" value="ALTA" type="hidden" />
					</form>
					<cfabort>
				</td></tr>
			</table>
			</cfoutput>
			<cfabort>
		</cfif>
		
		<!--- se busca en el histórico la versión anterior para hacer la línea del asiento negativo de la Cuenta Garantía por Pagar: Crédito --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			insert into #INTARC# 
				( 
					INTORI, 
					INTREL, 
					INTDOC, 
					
					INTREF, 
					INTTIP, 
					
					INTDES, 
					INTFEC, 
					Periodo, 
					Mes, 
					Ccuenta, 
					Ocodigo, 
					Mcodigo, 
					INTMOE, 
					INTCAM, 
					INTMON
				)
			select 
					'COGA',
					1,
					#preservesinglequotes(LvarRecibo)#,
					'GARANTIA', 
					'C',
					#preservesinglequotes(LvarDescripcionRecibo)#,
					'#dateFormat(arguments.FechaGenAsiento,"YYYYMMDD")#',
					#LvarAnoAux#,
					#LvarMesAux#,
					d.CcuentaIngresoGarantia,
					#LvarOcodigo#,
					b.CODGMcodigo,
					b.CODGMonto,
					b.CODGTipoCambio, <!---  Tipo de cambio --->
					b.CODGMonto * b.CODGTipoCambio
			from COHEGarantia a
				inner join COHDGarantia b
					 on b.COEGid = a.COEGid
					and b.COEGVersion = a.COEGVersion
					and b.Ecodigo = a.Ecodigo
				inner join SNegocios c
					 on c.SNid = a.SNid
				inner join COTipoRendicion d
					on d.COTRid = b.COTRid
			where a.COEGid = #arguments.COEGid#
			  and a.COEGVersion = #arguments.COEGVersion#
			  and a.COEGEstado = 3 <!---  En proceso de Ejecución --->
			  and a.COEGVersionActiva = 1 <!--- Activa --->
		</cfquery>
		<!---====Cuenta contable multimoneda=====--->
		<cfquery datasource="#Arguments.Conexion#" name="rsCuentaPuente">
			select Pvalor as CuentaPuente
			from Parametros
			where Ecodigo = #Arguments.Ecodigo# 
			  and Pcodigo = 200
		</cfquery>
		<!--- Balance por Moneda --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into #INTARC#
				( 
					Ocodigo, Mcodigo, INTCAM, 
					INTORI, INTREL, INTDOC, INTREF, 
					INTFEC, Periodo, Mes, 
					INTTIP, INTDES, 
					Ccuenta, 
					INTMOE, INTMON,CFid
				)
			select 
					Ocodigo, i.Mcodigo, round(INTCAM,10), 
					min(INTORI), min(INTREL), min(INTDOC), min(INTREF), 
					min(INTFEC), min(Periodo), min(Mes), 
					'D', 'Balance entre Monedas', 
					 #rsCuentaPuente.CuentaPuente#, 
					-sum(case when INTTIP = 'D' then INTMOE else -INTMOE end),
					-sum(case when INTTIP = 'D' then INTMON else -INTMON end),CFid
			  from #INTARC# i
			 where i.Mcodigo in
				(
					select Mcodigo
					  from #INTARC#
					 group by Mcodigo
					having sum(case when INTTIP = 'D' then INTMOE else -INTMOE end) <> 0
				)
			group by	i.Ocodigo, i.Mcodigo, round(INTCAM,10)
			having sum(case when INTTIP = 'D' then INTMOE else -INTMOE end) <> 0
		</cfquery>

		<cfquery name="garantia" datasource="#arguments.Conexion#">
			select case when COEGTipoGarantia = 1 then 'Participación' else 'Cumplimiento' end as tipoGarantia, COEGReciboGarantia, COEGFechaRecibe
			from COHEGarantia a
			where a.COEGid = #arguments.COEGid#
			  and a.COEGVersion = #arguments.COEGVersion#
			  and a.COEGEstado = 3 <!---  En proceso de Ejecución --->
			  and a.COEGVersionActiva = 1 <!--- Activa --->	
		</cfquery>
		<!---  Se lee el consecutivo del documento si este existe, de lo contrario se crea. --->
		<cfquery name="rsPETnumdocumento" datasource="#Arguments.Conexion#">
			select COHEnumdocumento 
			from COHEGarantia
			where COEGid = #arguments.COEGid#
			  and COEGVersion = #arguments.COEGVersion#
			  and COEGEstado = 3 <!---  En proceso de Ejecución --->
			  and COEGVersionActiva = 1 <!--- Activa --->	
			  and not COHEnumdocumento is null 
		</cfquery>
		<!--- Se obtiene el consecutivo del origen --->
		<cfif rsPETnumdocumento.RecordCount eq 0>
			<cfinvoke	component		= "sif.Componentes.OriRefNextVal"
				method			= "nextVal"
				returnvariable	= "LvarConsecutivo"
				Ecodigo			= "#session.Ecodigo#"
				ORI				= "COGA"
				REF				= "Ejec. Garantía"
				datasource		= "#arguments.Conexion#"
			/>
			<!--- Guardamos el consecutivo en el registro, en caso de que de error la proxima vez no se genera sino que se lee de BD --->
			<cfquery datasource="#arguments.Conexion#">
				update COHEGarantia set
					COHEnumdocumento = 33
				where COEGid = #arguments.COEGid#
				  and COEGVersion = #arguments.COEGVersion#
				  and COEGEstado = 3 <!---  En proceso de Ejecución --->
				  and COEGVersionActiva = 1 <!--- Activa --->	
			</cfquery>
		<cfelse>
			<cfset LvarDocumento=rsPETnumdocumento.COHEnumdocumento>
		</cfif>
		<!--- Genera el Asiento Contable --->
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="LvarIDcontable">
			<cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>
			<cfinvokeargument name="Eperiodo"		value="#LvarAnoAux#"/>
			<cfinvokeargument name="Emes"			value="#LvarMesAux#"/>
			<cfinvokeargument name="Efecha"			value="#arguments.FechaGenAsiento#"/>
			<cfinvokeargument name="Oorigen"		value="COGA"/>
			<cfinvokeargument name="Edocbase"		value="Ejec. Gar:#LvarConsecutivo#"/>
			<cfinvokeargument name="Ereferencia"	value="Ejec. Garantía"/>
			<cfinvokeargument name="Edescripcion"	value="Ejec. Garantía -> Tipo : #garantia.tipoGarantia#, Recibo : #garantia.COEGReciboGarantia#, Consec.: #LvarConsecutivo#"/>
			<cfinvokeargument name="Ocodigo"		value="#LvarOcodigo#"/>						
			<cfinvokeargument name="PintaAsiento"	value="false"/>						
		</cfinvoke>
		<cfreturn LvarIDcontable>
	</cffunction>
	
	<cffunction name="fnGenerarAsientoDevolucion" access="public" output="no" returntype="any">
		<cfargument name="COEGid" 				type="numeric"  required="yes">
		<cfargument name="COEGVersion" 			type="numeric"  required="yes">
		<cfargument name='Conexion' 			type='string' 	required='false' default	= "#Session.DSN#">
		<cfargument name='Ecodigo' 				type='numeric' 	required='false' default	= "#Session.Ecodigo#">
		<cfargument name='FechaGenAsiento' 		type='date' 	required='false' default	= "#now#">
		<cfset LobjCONTA	= createObject( "component","sif.Componentes.CG_GeneraAsiento")>
		<cfset INTARC 		= LobjCONTA.CreaIntarc(Arguments.Conexion)>
		<!--- 
			CxC Socio:  Débito
			Ingreso x garantía: Crédito
		 --->
	
		<!--- Garantía Recibida:  Débito --->
		<cfset LvarAnoAux 				= fnGetParametro (Arguments.Ecodigo, 50,  "Periodo de Auxiliares")>
		<cfset LvarMesAux 				= fnGetParametro (Arguments.Ecodigo, 60,  "Mes de Auxiliares")>
		<cfset CFSolicitud 				= fnGetParametro (Arguments.Ecodigo, 3200,"Centro Funcional para Solictud de Garantía")>
		
		<!---==Obtiene la minima oficina del Asiento, si no tienen entonces la minina Oficina para la empresa==---> 
		<!---==============La oficina se le manda al genera asiento para que agrupe===========================--->
		<cfquery name="rsMinOficinaINTARC" datasource="#session.dsn#">
			select Min(Ocodigo) as MinOcodigo
			from #INTARC#
		</cfquery>
		<cfquery name="rsMinOficina" datasource="#session.dsn#">
			select Min(Ocodigo) as MinOcodigo
			from Oficinas
			where Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfif isdefined("rsMinOficinaINTARC") and rsMinOficinaINTARC.recordcount GT 0 and len(trim(rsMinOficinaINTARC.MinOcodigo))>
			<cfset LvarOcodigo = rsMinOficinaINTARC.MinOcodigo>
		<cfelseif isdefined("rsMinOficina") and rsMinOficina.recordcount GT 0>
			<cfset LvarOcodigo = rsMinOficina.MinOcodigo>
		<cfelse>
			<cfset LvarOcodigo = -100>
		</cfif>
		<cf_dbfunction name="to_char" args="a.COEGReciboGarantia" returnvariable="LvarRecibo">
		<cf_dbfunction name="concat" args="'Garantía recibo n°: ' + #trim(LvarRecibo)# + ', Proveedor: ' + c.SNidentificacion" delimiters="+" conexion="#Arguments.Conexion#" returnvariable="LvarDescripcionRecibo">
		<!--- Se busca en el histórico la versión anterior para hacer la línea del asiento negativo de la Cuenta Garantía Recivida: Débito --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			insert into #INTARC# 
				( 
					INTORI, 
					INTREL, 
					INTDOC, 
					
					INTREF, 
					INTTIP, 
					
					INTDES, 
					INTFEC, 
					Periodo, 
					Mes, 
					Ccuenta, 
					Ocodigo, 
					Mcodigo, 
					INTMOE, 
					INTCAM, 
					INTMON
				)
			select 
					'COGA',
					1,
					#preservesinglequotes(LvarRecibo)#,		
					'GARANTIA', 
					'D',
					#preservesinglequotes(LvarDescripcionRecibo)#,
					'#dateFormat(arguments.FechaGenAsiento,"YYYYMMDD")#',
					#LvarAnoAux#,
					#LvarMesAux#,
					b.CcuentaGarxPagar,
					#LvarOcodigo#,
					b.CODGMcodigo,
					b.CODGMonto,
					b.CODGTipoCambio, <!---  Tipo de cambio --->
					b.CODGMonto * b.CODGTipoCambio
			from COHEGarantia a
				inner join COHDGarantia b
					 on b.COEGid = a.COEGid
					and b.COEGVersion = a.COEGVersion
					and b.Ecodigo = a.Ecodigo
				inner join SNegocios c
					on c.SNid = a.SNid and c.Ecodigo = #session.Ecodigo#
			where a.COEGid = #arguments.COEGid#
			  and a.COEGVersion = #arguments.COEGVersion#
			  and a.COEGEstado = 7   <!--- Estado Enviada a aprobar --->
			   and a.COEGVersionActiva = 1 <!--- Activa --->
		</cfquery>
		
		<cfquery name="temp" datasource="#arguments.Conexion#">
			select count(1) as cantidad from 	#INTARC# 
		</cfquery>
		<cfif temp.cantidad eq 0>
			<cfoutput>
			<table align="center" border="0">
				<tr><td>&nbsp;</td></tr>
				<tr align="center"><td>
					No se gan insertado datos en la tabla temporal, Proceso Cancelado!!!.
				</td>
				</tr>
				<td>
					<form method="post" action="listaAprobarEjecucionGarantia.cfm">
						<cf_botones modo="ALTA" include="Regresar" exclude="ALTA,Limpiar">
						<input name="modo" id="modo" value="ALTA" type="hidden" />
					</form>
					
				</td></tr>
			</table>
			</cfoutput>
			<cfabort>
		</cfif>
		<!--- se busca en el histórico la versión anterior para hacer la línea del asiento negativo de la Cuenta Garantía por Pagar: Crédito --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">			
		insert into #INTARC# 
				( 
					INTORI, 
					INTREL, 
					INTDOC, 
					
					INTREF, 
					INTTIP, 
					
					INTDES, 
					INTFEC, 
					Periodo, 
					Mes, 
					Ccuenta, 
					Ocodigo, 
					Mcodigo, 
					INTMOE, 
					INTCAM, 
					INTMON
				)
			select 
					'COGA',
					1,
					#preservesinglequotes(LvarRecibo)#,
					'GARANTIA', 
					'C',
					#preservesinglequotes(LvarDescripcionRecibo)#,
					'#dateFormat(arguments.FechaGenAsiento,"YYYYMMDD")#',
					#LvarAnoAux#,
					#LvarMesAux#,
					b.CcuentaRecibida,
					#LvarOcodigo#,
					b.CODGMcodigo,
					b.CODGMonto,
					b.CODGTipoCambio, <!---  Tipo de cambio --->
					b.CODGMonto * b.CODGTipoCambio
			from COHEGarantia a
				inner join COHDGarantia b
					 on b.COEGid = a.COEGid
					and b.COEGVersion = a.COEGVersion
					and b.Ecodigo = a.Ecodigo
				inner join SNegocios c
					 on c.SNid = a.SNid
			where a.COEGid = #arguments.COEGid#
			  and a.COEGVersion = #arguments.COEGVersion#
			  and a.COEGEstado = 7 <!---  En proceso de Ejecución --->
			  and a.COEGVersionActiva = 1 <!--- Activa --->
		</cfquery>
        
		<cfquery name="garantia" datasource="#arguments.Conexion#">
			select case when COEGTipoGarantia = 1 then 'Participación' else 'Cumplimiento' end as tipoGarantia, COEGReciboGarantia, COEGFechaRecibe
			from COHEGarantia a
			where a.COEGid = #arguments.COEGid#
			  and a.COEGVersion = #arguments.COEGVersion#
			  and a.COEGEstado = 7 <!---  Liberada --->
			  and a.COEGVersionActiva = 1 <!--- Activa --->	
		</cfquery>
		<cfquery name="rsTES" datasource="#session.dsn#">
			Select e.TESid, t.EcodigoAdm
			  from TESempresas e
				inner join Tesoreria t
					on t.TESid = e.TESid
			 where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfif rsTES.recordCount EQ 0>
			<cfset Request.Error.Backs = 1>
			<cf_errorCode	code = "50798" msg = "ESTA EMPRESA NO HA SIDO INCLUIDA EN NINGUNA TESORERÍA">
		</cfif>
		<cfquery name="depositos" datasource="#session.dsn#">
			select 
				b.CODGid,
				b.COEGid,
				c.SNcodigo, 
				b.CODGMcodigo,
				b.CODGTipoCambio,
				b.CODGMonto,
				g.CFcuenta,
				b.CODGNumDeposito,
				e.COLGObservacion,
				m.Miso4217
			from COLiberaGarantia e
				inner join COHEGarantia a
				inner join COHDGarantia b
					inner join COTipoRendicion d
						on d.COTRid = b.COTRid
				on b.COEGid = a.COEGid
				and b.COEGVersion = a.COEGVersion
				and b.Ecodigo = a.Ecodigo
				inner join CFinanciera g
					on g.Ccuenta = b.CcuentaRecibida
				inner join Monedas m
						on m.Mcodigo = b.CODGMcodigo
				inner join SNegocios c
						on c.SNid = a.SNid
				on a.COEGid = e.COEGid and a.COEGVersion = e.COEGVersion
			where a.COEGid = #arguments.COEGid#
			  and a.COEGVersion = #arguments.COEGVersion#
			  and a.COEGEstado = 7 <!---  En proceso de Ejecución --->
			  and a.COEGVersionActiva = 1 <!--- Activa --->
			  and d.COTRGenDeposito = 1
			  and e.COLGEstado = 3
		</cfquery>
		
		 <!---==Obtiene la minima oficina del Asiento, si no tienen entonces la minina Oficina para la empresa==---> 
		<!---==============La oficina se le manda al genera asiento para que agrupe===========================--->
		<cfquery name="rsMinOficina" datasource="#session.dsn#">
			select Min(Ocodigo) as MinOcodigo
			from Oficinas
			where Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfif isdefined("rsMinOficina") and rsMinOficina.recordcount GT 0>
			<cfset LvarOcodigo = rsMinOficina.MinOcodigo>
		<cfelse>
			<cfset LvarOcodigo = -100>
		</cfif>
		<!-- Se obtiene el consecutivo del origen ---> 
		<cfinvoke	component		= "sif.Componentes.OriRefNextVal"
			method			= "nextVal"
			returnvariable	= "LvarConsecutivo"
		
			Ecodigo			= "#session.Ecodigo#"
			ORI				= "COGA"
			REF				= "Dev. Garantía"
			datasource		= "#arguments.Conexion#"
		/>
		
		<!--- Genera el Asiento Contable --->
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="LvarIDcontable">
			<cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>
			<cfinvokeargument name="Eperiodo"		value="#LvarAnoAux#"/>
			<cfinvokeargument name="Emes"			value="#LvarMesAux#"/>
			<cfinvokeargument name="Efecha"			value="#arguments.FechaGenAsiento#"/>
			<cfinvokeargument name="Oorigen"		value="COGA"/>
			<cfinvokeargument name="Edocbase"		value="Dev. Gar:#LvarConsecutivo#"/>
			<cfinvokeargument name="Ereferencia"	value="Dev. Garantía"/>
			<cfinvokeargument name="Edescripcion"	value="Dev. Garantía -> Tipo : #garantia.tipoGarantia#, Recibo : #garantia.COEGReciboGarantia#, Consec. #LvarConsecutivo#"/>
			<cfinvokeargument name="Ocodigo"		value="#LvarOcodigo#"/>						
			<cfinvokeargument name="PintaAsiento"	value="false"/>						
		</cfinvoke>
		<cfset tsids="">
		<cfquery name="CFuncionalGarantia" datasource="#Session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">  
			  and Pcodigo = 3200
		</cfquery>
		<cfif CFuncionalGarantia.recordcount eq '0' or not len(trim(CFuncionalGarantia.Pvalor))>
			<cfthrow message="No se ha configurado el Centro Funcional en los parametros de Garantías para la generación de las solicitud.">
		</cfif>
		<cfloop query="depositos">
			<cfquery name="rsNewSol" datasource="#session.dsn#">
				select coalesce(max(TESSPnumero),0) + 1 as newSol
				from TESsolicitudPago
				where EcodigoOri = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<cfquery datasource="#session.dsn#" name="insert">
				insert into TESsolicitudPago (
					TESid,
					EcodigoOri, TESSPnumero, 
					TESSPtipoDocumento, 
					TESSPestado, 
					SNcodigoOri,
					TESSPfechaPagar, McodigoOri,
					TESSPtipoCambioOriManual, TESSPtotalPagarOri, TESSPfechaSolicitud,
					UsucodigoSolicitud, BMUsucodigo,TESOPobservaciones,CFid
					)
				values( 
					#rsTES.TESid#,
					#session.Ecodigo#, 
					#rsNewSol.newSol#,
					0, <!--- Cual es el que tiene q ingresar en Devolucion de Garantias --->
					1, 
					#depositos.SNcodigo#, 
					<cf_jdbcquery_param value="#arguments.FechaGenAsiento#" cfsqltype="cf_sql_timestamp">,
					#depositos.CODGMcodigo#,
					#depositos.CODGTipoCambio#,
					0,
					<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#arguments.FechaGenAsiento#">,
					#session.usucodigo#,
					#session.usucodigo#,
					'#depositos.COLGObservacion#',
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#CFuncionalGarantia.Pvalor#">
				)
				<cf_dbidentity1 datasource="#session.DSN#" name="insert">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarTESSPid">
			<cfquery datasource="#session.dsn#">
				insert INTO TESdetallePago 
					(
						TESid,
						OcodigoOri,
						TESDPestado, 
						EcodigoOri, 
						TESSPid, 
						TESDPtipoDocumento, 
						TESDPidDocumento,
						TESDPmoduloOri, 
						TESDPdocumentoOri, 
						TESDPreferenciaOri, 
						SNcodigoOri, 
						TESDPfechaVencimiento, 
						TESDPfechaSolicitada, 
						TESDPfechaAprobada, 
						Miso4217Ori, 
						TESDPmontoVencimientoOri, 
						TESDPmontoSolicitadoOri, 
						TESDPmontoAprobadoOri, 
						TESDPdescripcion, 
						CFcuentaDB
					)
				values (
						#rsTES.TESid#,
						#LvarOcodigo#,
						1,
						#session.Ecodigo#,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESSPid#">,
						0,  <!--- Este no es preguntar cual es --->
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESSPid#">,
						'COGA',	
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#depositos.CODGNumDeposito#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#depositos.CODGNumDeposito#">,
						#depositos.SNcodigo#,		
						<cfqueryparam value="#arguments.FechaGenAsiento#" cfsqltype="cf_sql_timestamp">,
						<cfqueryparam value="#arguments.FechaGenAsiento#" cfsqltype="cf_sql_timestamp">,
						<cfqueryparam value="#arguments.FechaGenAsiento#" cfsqltype="cf_sql_timestamp">,
						'#depositos.Miso4217#',
						#depositos.CODGMonto#,
						#depositos.CODGMonto#,			
						#depositos.CODGMonto#,
						<cf_jdbcquery_param cfsqltype="cf_sql_varchar"	value="#depositos.COLGObservacion#" len="80">,
                        #depositos.CFcuenta#
					)
			</cfquery>
			
			<cfquery datasource="#session.dsn#">
				update TESsolicitudPago
					set TESSPtotalPagarOri = 
							coalesce(
							( select sum(TESDPmontoSolicitadoOri)
								from TESdetallePago
							   where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESSPid#" null="#Len(LvarTESSPid) Is 0#">
							)
							, 0)
						, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESSPid#" null="#Len(LvarTESSPid) Is 0#">
			</cfquery>
			<cfquery datasource="#session.dsn#" name="OrdenPago">
				select TESSPnumero, TESSPfechaPagar from TESsolicitudPago 
				where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESSPid#">
				and EcodigoOri = #session.Ecodigo#
			</cfquery>
			<cfinvoke component = "sif.tesoreria.Componentes.TESaplicacion"
				method			= "sbAprobarSP"
				SPid 			= "#LvarTESSPid#"
				fechaPagoDMY	= "#dateFormat(OrdenPago.TESSPfechaPagar,'YYYYMMDD')#"
				generarOP		= "false"
				NAP				= "0"
				PRES_Origen		= "TESP"
				PRES_Documento	= "#OrdenPago.TESSPnumero#"
				PRES_Referencia	= "SP,APROBACION,GARANTIA"
			>
			<cfquery datasource="#session.dsn#">
				update COHDGarantia 
				set CODGOrdenPago = #OrdenPago.TESSPnumero#
				where CODGid = #depositos.CODGid#
					and COEGid = #depositos.COEGid#
			</cfquery>
			<cfset tsids &= OrdenPago.TESSPnumero & ",">
		</cfloop>
		<cfreturn #tsids#>
	</cffunction>
	
	<cffunction name="fnGenerarAsientoEjecutar" access="public" output="no" returntype="any">
		<cfargument name="COEGid" 			type="numeric"  required="yes">
		<cfargument name="COEGVersion" 		type="numeric"  required="yes">
		<cfargument name="documento" 		type="string"  	required="yes">
		<cfargument name='Conexion' 		type='string' 	required='false' default	= "#Session.DSN#">
		<cfargument name='Ecodigo' 			type='numeric' 	required='false' default	= "#Session.Ecodigo#">
		<cfargument name='FechaGenAsiento' 	type='date' 	required='false' default	= "#now()#">
		
		<cfset LobjCONTA	= createObject( "component","sif.Componentes.CG_GeneraAsiento")>
		<cfset INTARC 		= LobjCONTA.CreaIntarc(Arguments.Conexion)>
		<!--- 
			Garantia x pagar:  Débito
			Cta x cobrar del proveedor: Crédito
		 --->
	
		<!--- Garantía Recibida:  Débito --->
		<cfset LvarAnoAux 				= fnGetParametro (Arguments.Ecodigo, 50,  "Periodo de Auxiliares")>
		<cfset LvarMesAux 				= fnGetParametro (Arguments.Ecodigo, 60,  "Mes de Auxiliares")>
	
		<!---==Obtiene la minima oficina del Asiento, si no tienen entonces la minina Oficina para la empresa==---> 
		<!---==============La oficina se le manda al genera asiento para que agrupe===========================--->
		<cfquery name="rsMinOficinaINTARC" datasource="#session.dsn#">
			select Min(Ocodigo) as MinOcodigo
			from #INTARC#
		</cfquery>
		<cfquery name="rsMinOficina" datasource="#session.dsn#">
			select Min(Ocodigo) as MinOcodigo
			from Oficinas
			where Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfif isdefined("rsMinOficinaINTARC") and rsMinOficinaINTARC.recordcount GT 0 and len(trim(rsMinOficinaINTARC.MinOcodigo))>
			<cfset LvarOcodigo = rsMinOficinaINTARC.MinOcodigo>
		<cfelseif isdefined("rsMinOficina") and rsMinOficina.recordcount GT 0>
			<cfset LvarOcodigo = rsMinOficina.MinOcodigo>
		<cfelse>
			<cfset LvarOcodigo = -100>
		</cfif>
		
		<cf_dbfunction name="to_char" args="a.COEGReciboGarantia" returnvariable="LvarRecibo">
		<cf_dbfunction name="concat" args="'Garantía recibo n°: ' + #trim(LvarRecibo)# + ', Proveedor: ' + c.SNidentificacion" delimiters="+" conexion="#Arguments.Conexion#" returnvariable="LvarDescripcionRecibo">
		<!--- Se busca en el histórico la versión anterior para hacer la línea del asiento negativo de la Cuenta Garantía Recivida: Débito --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			insert into #INTARC# 
				( 
					INTORI, 
					INTREL, 
					INTDOC, 
					
					INTREF, 
					INTTIP, 
					
					INTDES, 
					INTFEC, 
					Periodo, 
					Mes, 
					Ccuenta, 
					Ocodigo, 
					Mcodigo, 
					INTMOE, 
					INTCAM, 
					INTMON
				)
			select 
					'COGA',
					1,
					#preservesinglequotes(LvarRecibo)#,		
					'GARANTIA', 
					'C',
					#preservesinglequotes(LvarDescripcionRecibo)#,
					'#dateFormat(arguments.FechaGenAsiento,"YYYYMMDD")#',
					#LvarAnoAux#,
					#LvarMesAux#,
					c.SNcuentacxc,
					#LvarOcodigo#,
					a.Mcodigo,
					a.COEGMontoTotal,
					coalesce(TCcompra, 1), <!---  Tipo de cambio --->
					a.COEGMontoTotal * coalesce(TCcompra, 1)
			from COHEGarantia a
				inner join SNegocios c
					inner join CContables e
						on c.SNcuentacxc = e.Ccuenta and e.Ecodigo = #session.Ecodigo#
					on c.SNid = a.SNid and c.Ecodigo = #session.Ecodigo#
				left outer join Htipocambio htc 
					   on htc.Mcodigo = a.Mcodigo 
					   and htc.Ecodigo = #session.Ecodigo# 
					   and a.COEGFechaRecibe  BETWEEN htc.Hfecha and  htc.Hfechah
			where a.COEGid = #arguments.COEGid#
			  and a.COEGVersion = #arguments.COEGVersion#
			  and a.COEGEstado = 4   <!--- Estado en ejecucion --->
			   and a.COEGVersionActiva = 1 <!--- Activa --->
		</cfquery>
		
		<cfquery name="temp" datasource="#arguments.Conexion#">
			select count(1) as cantidad from 	#INTARC# 
		</cfquery>
		<cfif temp.cantidad eq 0>
			<cfoutput>
			<table align="center" border="0">
				<tr><td>&nbsp;</td></tr>
				<tr align="center"><td>
					No se han insertado datos en la tabla temporal, Proceso Cancelado!!!.
					<br><br>
					Puede que se deba a que el socio de negocio no posee una cuenta por cobrar definida.
				</td>
				</tr>
				<td>
					<form method="post" action="listaAprobarEjecucionGarantia.cfm">
						<cf_botones modo="ALTA" include="Regresar" exclude="ALTA,Limpiar">
						<input name="modo" id="modo" value="ALTA" type="hidden" />
					</form>
					<cfabort>
				</td></tr>
			</table>
			</cfoutput>
			<cfabort>
		</cfif>
		
		<!--- se busca en el histórico la versión anterior para hacer la línea del asiento negativo de la Cuenta Garantía por Pagar: Crédito --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			insert into #INTARC# 
				( 
					INTORI, 
					INTREL, 
					INTDOC, 
					
					INTREF, 
					INTTIP, 
					
					INTDES, 
					INTFEC, 
					Periodo, 
					Mes, 
					Ccuenta, 
					Ocodigo, 
					Mcodigo, 
					INTMOE, 
					INTCAM, 
					INTMON
				)
			select 
					'COGA',
					1,
					#preservesinglequotes(LvarRecibo)#,
					'GARANTIA', 
					'D',
					#preservesinglequotes(LvarDescripcionRecibo)#,
					'#dateFormat(arguments.FechaGenAsiento,"YYYYMMDD")#',
					#LvarAnoAux#,
					#LvarMesAux#,
					b.CcuentaGarxPagar,
					#LvarOcodigo#,
					b.CODGMcodigo,
					b.CODGMonto,
					b.CODGTipoCambio, <!---  Tipo de cambio --->
					b.CODGMonto * b.CODGTipoCambio
			from COHEGarantia a
				inner join COHDGarantia b
					 on b.COEGid = a.COEGid
					and b.COEGVersion = a.COEGVersion
					and b.Ecodigo = a.Ecodigo
				inner join SNegocios c
					 on c.SNid = a.SNid
				inner join COTipoRendicion d
					on d.COTRid = b.COTRid
			where a.COEGid = #arguments.COEGid#
			  and a.COEGVersion = #arguments.COEGVersion#
			  and a.COEGEstado = 4 <!---  Estado en ejecucion --->
			  and a.COEGVersionActiva = 1 <!--- Activa --->
		</cfquery>
				<!---====Cuenta contable multimoneda=====--->
		<cfquery datasource="#Arguments.Conexion#" name="rsCuentaPuente">
			select Pvalor as CuentaPuente
			from Parametros
			where Ecodigo = #Arguments.Ecodigo# 
			  and Pcodigo = 200
		</cfquery>
		<!--- Balance por Moneda --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into #INTARC#
				( 
					Ocodigo, Mcodigo, INTCAM, 
					INTORI, INTREL, INTDOC, INTREF, 
					INTFEC, Periodo, Mes, 
					INTTIP, INTDES, 
					Ccuenta, 
					INTMOE, INTMON
				)
			select 
					Ocodigo, i.Mcodigo, round(INTCAM,10), 
					min(INTORI), min(INTREL), min(INTDOC), min(INTREF), 
					min(INTFEC), min(Periodo), min(Mes), 
					'D', 'Balance entre Monedas', 
					 #rsCuentaPuente.CuentaPuente#, 
					-sum(case when INTTIP = 'D' then INTMOE else -INTMOE end),
					-sum(case when INTTIP = 'D' then INTMON else -INTMON end)
			  from #INTARC# i
			 where i.Mcodigo in
				(
					select Mcodigo
					  from #INTARC#
					 group by Mcodigo
					having sum(case when INTTIP = 'D' then INTMOE else -INTMOE end) <> 0
				)
			group by	i.Ocodigo, i.Mcodigo, round(INTCAM,10)
			having sum(case when INTTIP = 'D' then INTMOE else -INTMOE end) <> 0
		</cfquery>

		<cfquery name="garantia" datasource="#arguments.Conexion#">
			select case when COEGTipoGarantia = 1 then 'Participación' else 'Cumplimiento' end as tipoGarantia, COEGReciboGarantia, COEGFechaRecibe
			from COHEGarantia a
			where a.COEGid = #arguments.COEGid#
			  and a.COEGVersion = #arguments.COEGVersion#
			  and a.COEGEstado = 4 <!---  En proceso de Ejecución --->
			  and a.COEGVersionActiva = 1 <!--- Activa --->	
		</cfquery>
		<!--- Genera el Asiento Contable --->
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="LvarIDcontable">
			<cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>
			<cfinvokeargument name="Eperiodo"		value="#LvarAnoAux#"/>
			<cfinvokeargument name="Emes"			value="#LvarMesAux#"/>
			<cfinvokeargument name="Efecha"			value="#arguments.FechaGenAsiento#"/>
			<cfinvokeargument name="Oorigen"		value="COGA"/>
			<cfinvokeargument name="Edocbase"		value="#arguments.documento#"/>
			<cfinvokeargument name="Ereferencia"	value="Fin Ejec. Garantía"/>
			<cfinvokeargument name="Edescripcion"	value="Fin Ejec. Garantía -> Tipo : #garantia.tipoGarantia#, Recibo : #garantia.COEGReciboGarantia#, Doc : #arguments.documento#"/>
			<cfinvokeargument name="Ocodigo"		value="#LvarOcodigo#"/>						
			<cfinvokeargument name="PintaAsiento"	value="false"/>						
		</cfinvoke>
		<cfreturn LvarIDcontable>
	</cffunction>
	
	<cffunction name="CORREO_GARANTIA" access="public" returntype="boolean">
		<cfargument name="remitente" 			type="string" 	required="yes">
		<cfargument name="destinario" 			type="string" 	required="yes"><!--- correo --->
		<cfargument name="asunto" 				type="string" 	required="yes">
		<cfargument name="texto" 				type="string" 	required="yes">
		<cfargument name="usuario" 				type="numeric" 	required="yes">
		<cfargument name='Conexion' 			type='string' 	required='false' default="#Session.DSN#">
		<cfquery name="rsInserta" datasource="#Arguments.Conexion#">
			insert into SMTPQueue ( SMTPremitente, 	SMTPdestinatario, 	SMTPasunto, 
									SMTPtexto, 		SMTPintentos, 		SMTPcreado, 
									SMTPenviado, 	SMTPhtml, 			BMUsucodigo ) 
		 	values ( <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.remitente#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.destinario#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.asunto#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.texto#">,
					0,	#now()#,	#now()#,	1,
					<cfif arguments.usuario eq -1>
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="null" datasource="#Arguments.Conexion#">
					<cfelse>
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#arguments.usuario#" datasource="#Arguments.Conexion#">
					</cfif>
					) 
    	</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="fnGetParametro" returntype="string" access="public">
		<cfargument name='Ecodigo'		type='numeric' 	required='true'>	 
		<cfargument name='Pcodigo'		type='string' 	required='true'>	 
		<cfargument name='Pdescripcion'	type='string' 	required='true'>
		<cfargument name='Conexion' 	type='string' 	required='false' default	= "#Session.DSN#">
		<cfargument name='Pdefault'		type='string' 	required='no' default="°°">
	
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select Pvalor
			from Parametros
			where Ecodigo = #Arguments.Ecodigo# 
			  and Pcodigo = #Arguments.Pcodigo# 
		</cfquery>
		<cfif rsSQL.recordCount EQ 0>
			<cfif Arguments.Pdefault EQ "°°">
				<cfthrow message="No se ha definido el Parámetro: #Arguments.Pcodigo#, #Arguments.Pdescripcion#">
			<cfelse>
				<cfreturn Arguments.Pdefault>
			</cfif>
		</cfif>
		<cfreturn rsSQL.Pvalor>
	</cffunction>

	<!---	Valida la garantias de la actual solicitud de compra con sus respectivas lineas de detalles.
			Este debe de estar en estado vigante --->
	<cffunction name="fnProcesarGarantias" 	returntype="boolean" access="public">
		<cfargument name='ID'			type='numeric' 	required='true'>
		<cfargument name='tipo' 		type='string' 	required='true'>
		<cfargument name='Ecodigo'		type='numeric' 	required='false' default="#session.Ecodigo#">
		<cfargument name='Conexion' 	type='string' 	required='false' default="#Session.DSN#">
		
		<cfif not listfind('P,C', Arguments.tipo)>
			<cfthrow message="Solamente son permitidos los valores P = Participación ó C = Cumplimiento, Proceso cancelado.">
		</cfif>
		
		<!--- Consulta si la orden/factura esta asociada con una garantia de Participación/Cumplimiento. --->
		<cfquery name="rsValidar" datasource="#Arguments.Conexion#">
			select distinct c.TGidP, c.TGidC<cfif Arguments.tipo eq 'C'>, a.EOidorden </cfif>
			from DOrdenCM a
				inner join CMLineasProceso b
					on b.ESidsolicitud = a. ESidsolicitud 
					  and b.DSlinea = a.DSlinea
				inner join CMProcesoCompra c
					on c.CMPid = b.CMPid
				<cfif Arguments.tipo eq 'C'>
				inner join 	DDocumentosCxP d
					on d.DOlinea = a.DOlinea
				</cfif>
			where 
				a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
				<cfif Arguments.tipo eq 'P'>
					and a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ID#">
					and not c.TGidP is null
				<cfelse>
					and d.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ID#">
					and not c.TGidC is null
				</cfif>
		</cfquery>
		<!--- Recorre la orden de compra, en el caso de orden de compra solamente es un registro, en el caso de facturas puende ser varios ordenes. --->
		<cfloop query="rsValidar">
			<cfset procesar = false>
			
			<!--- Si es de Participación, aplica para orden de compra --->
			<cfif Arguments.tipo eq 'P' and len(trim(rsValidar.TGidP))>
				<cfset procesar = true>
				<cfset tipoGarantia = 1>
				<cfset msg = "Orden de Compras">
				
				<!--- Se obtienen el proceso asociado a la orden de compra --->
				<cfquery name="rsProceso" datasource="#Arguments.Conexion#">
					select count(a.DSlinea), c.CMPid, s.SNcodigo
					from DOrdenCM a
						inner join CMDProceso b
							on a.DSlinea = b.DSlinea and a.ESidsolicitud = b.ESidsolicitud
						inner join CMProceso c
							on b.CMPid = c.CMPid
						inner join EOrdenCM d
							on d.EOidorden = a.EOidorden
						inner join SNegocios s
        					on d.SNcodigo = s.SNcodigo and d.Ecodigo = s.Ecodigo
						inner join COHEGarantia e 
							on e.CMPid = c.CMPid and e.SNid = s.SNid
							and e.COEGVersionActiva = 1  
					where a.Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
						and a.EOidorden		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ID#">
						and e.COEGTipoGarantia   = #tipoGarantia# 
					group by c.CMPid, s.SNcodigo
					having count(a.DSlinea) = (
						select count(1)
						from DOrdenCM a
						where a.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
						  and a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ID#">
					)
				</cfquery>
				
			<!--- Si es de Cumplimiento, aplica para facturas --->
			<cfelseif Arguments.tipo eq 'C' and len(trim(rsValidar.TGidC))>
				<cfset procesar = true>
				<cfset tipoGarantia = 2>
				<cfset msg = "Facturas">
				<!--- Se obtiene el proceso asociado a la factura a partir de la orden de compra --->
				<cfquery name="rsProceso" datasource="#Arguments.Conexion#">
					select count(a.DSlinea), c.CMPid, s.SNcodigo, e.COEGMontoTotal, d.EOtotal,e.Mcodigo as McodigoCOHEG,e.COEGFechaRecibe,d.Mcodigo as McodigoEO 
					from DOrdenCM a
						inner join CMDProceso b
							on a.DSlinea = b.DSlinea and a.ESidsolicitud = b.ESidsolicitud
						inner join CMProceso c
							on b.CMPid = c.CMPid
						inner join EOrdenCM d
							on d.EOidorden = a.EOidorden
						inner join SNegocios s
        					on d.SNcodigo = s.SNcodigo and d.Ecodigo = s.Ecodigo
						inner join COHEGarantia e
							on e.CMPid = c.CMPid and e.SNid = s.SNid and COEGVersionActiva = 1
					where a.Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
						and a.EOidorden		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsValidar.EOidorden#">
						and e.COEGTipoGarantia   = #tipoGarantia# 
					group by c.CMPid, s.SNcodigo, e.COEGMontoTotal,d.EOtotal,e.Mcodigo,e.COEGFechaRecibe,d.Mcodigo 
					having count(a.DSlinea) <= (
						select count(1)
						from DOrdenCM a
						where a.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
						  and a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsValidar.EOidorden#">
					)
				</cfquery>
				<!---Se obtiene si el Exigido minimo es por monto o por porcentaje--->
				<cfquery name="rsTiposGarantia" datasource="#Arguments.Conexion#">
					select TGporcentaje, TGmonto,TGmanejaMonto ,a.Mcodigo
					from TiposGarantia a
						
					where a.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
						and a.TGid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsValidar.TGidC#">
				</cfquery>
				
				<cfif rsProceso.recordcount gt 0>
					
					<!---Si es 0 se maneja por PORCENTAJE en minimo exigido--->		
					<cfif #rsTiposGarantia.TGmanejaMonto# eq 0>
					
						<!---si las monedas son diferentes obtiene los TC correspondientes a la fecha de entrega de la garantia --->
						<cfif #rsProceso.McodigoCOHEG# neq #rsProceso.McodigoEO#>
							<cfquery name="rsTCCOEGMontoTotal" datasource="#session.dsn#">
								select 
									coalesce(TCventa,1) as venta 
	
								from Htipocambio htc
									where htc.Mcodigo = #rsProceso.McodigoCOHEG#
										and <cfqueryparam cfsqltype="cf_sql_date" value="#rsProceso.COEGFechaRecibe#">  between htc.Hfecha and htc.Hfechah  		
										and htc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
							</cfquery>
						
							<cfquery name="rsTCEOtotal" datasource="#session.dsn#">
								select 
									coalesce(TCventa,1) as venta 
	
								from Htipocambio htc
									where htc.Mcodigo = #rsProceso.McodigoEO#
										and <cfqueryparam cfsqltype="cf_sql_date" value="#rsProceso.COEGFechaRecibe#">  between htc.Hfecha and htc.Hfechah  		
										and htc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
							</cfquery>
						</cfif>
						<!---Se define el COEGMontoTotal y el EOtotal--->
						<cfif isdefined('rsTCCOEGMontoTotal') and len(trim(#rsTCCOEGMontoTotal.venta#)) gt 0>
							<cfset COEGMontoTotal=#rsTCCOEGMontoTotal.venta#* #rsProceso.COEGMontoTotal#>
						<cfelse>
							<cfset COEGMontoTotal=#rsProceso.COEGMontoTotal#>
						</cfif>
						<cfif isdefined('rsTCEOtotal') and len(trim(#rsTCEOtotal.venta#)) gt 0>
							<cfset EOtotal=#rsTCEOtotal.venta#* #rsProceso.EOtotal#>
						<cfelse>
							<cfset EOtotal=#rsProceso.EOtotal#>
						</cfif>	
						<!---Se obtiene el el monto de acuerdo al porcentaje y al total de la orden--->
						<cfset LvarMontoExigido=#rsTiposGarantia.TGporcentaje# * #EOtotal# / 100>
						
					<cfelse><!---Si es 1 se maneja por MONTO en minimo exigido --->
						<!---si las monedas son diferentes obtiene los TC correspondientes a la fecha de entrega de la garantia --->
						<cfif #rsProceso.McodigoCOHEG# neq #rsTiposGarantia.Mcodigo#>
						
							<cfquery name="rsTCCOEGMontoTotal" datasource="#session.dsn#">
								select 
									coalesce(TCventa,1) as venta 
	
								from Htipocambio htc
									where htc.Mcodigo = #rsProceso.McodigoCOHEG#
										and <cfqueryparam cfsqltype="cf_sql_date" value="#rsProceso.COEGFechaRecibe#">  between htc.Hfecha and htc.Hfechah  		
										and htc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
							</cfquery>
							<cfquery name="rsTCTGmonto" datasource="#session.dsn#">
								select 
									coalesce(TCventa,1) as venta
	
								from Htipocambio htc
									where htc.Mcodigo = #rsTiposGarantia.Mcodigo#
										and <cfqueryparam cfsqltype="cf_sql_date" value="#rsProceso.COEGFechaRecibe#"> between htc.Hfecha and htc.Hfechah  		
										and htc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
							</cfquery>
							
						</cfif>
						<!---Se define el COEGMontoTotal y el TGmonto--->
						<cfif isdefined('rsTCCOEGMontoTotal') and len(trim(#rsTCCOEGMontoTotal.venta#)) gt 0>
							<cfset COEGMontoTotal=#rsTCCOEGMontoTotal.venta#* #rsProceso.COEGMontoTotal#>
						<cfelse>
							<cfset COEGMontoTotal=#rsProceso.COEGMontoTotal#>
						</cfif>
						<cfif isdefined('rsTCTGmonto') and len(trim(#rsTCTGmonto.venta#)) gt 0>
							<cfset TGmonto=#rsTCTGmonto.venta#* #rsTiposGarantia.TGmonto#>
						<cfelse>
							<cfset TGmonto=#rsTiposGarantia.TGmonto#>
						</cfif>	
						<!---Se obtiene el monto de acuerdo campo del monto--->
						<cfset LvarMontoExigido=#TGmonto#>	
					</cfif>		
				</cfif>	
			</cfif>
			<!--- Si no existe un proceso asociado no ejecuta.--->
			<cfif procesar>
				<!--- Verifica que exista un proceso asociada a la orden de compra o factura --->

<!---			      <cfif rsProceso.recordcount eq 0>   modific. RSC el 31-12-2010 a solicitud de AChS, para q no valide garantias, quitar comentario cuando se borre linea 1290 --->

				<cfif rsProceso.recordcount eq 500000234234.111>
					<cfthrow message="No existe un proceso de garantía con las misma cantidad de lineas de la actual orden de compra, Proceso cancelado.">
				</cfif>
				<cfif isdefined('LvarMontoExigido') and #COEGMontoTotal# lt #LvarMontoExigido# >
					<cfthrow message="La garantia entregada #COEGMontoTotal# es menor que el monto minimo Exigido para la garantia #LvarMontoExigido# , Proceso cancelado. ">
				</cfif>
				<cfloop query="rsProceso">
					<!--- Obtiene la la agarantia asociada a la orden/factura, que tenga el mismo proceso y el mismo socio. --->
					<cfquery name="rsProcesoGarantia" datasource="#Arguments.Conexion#">
						select b.COEGid, CODGFechaFin
						from COHEGarantia a
							inner join COHDGarantia b
								on b.COEGid = a.COEGid and b.Ecodigo = a.Ecodigo
                                and b.COEGVersion = a.COEGVersion
							inner join SNegocios c
								on c.SNid = a.SNid
						where a.Ecodigo 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
						  and a.CMPid 				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsProceso.CMPid#">
						  and a.COEGTipoGarantia   = #tipoGarantia#
						  and a.COEGVersionActiva 	= 1
						  and c.SNcodigo 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsProceso.SNcodigo#">
					</cfquery>
					<!--- Verifica que exista una garantia asociada a la orden de compra o factura. --->
					<cfif rsProcesoGarantia.recordcount eq 0>
						<cfthrow message="No existen Garantía asociada a esta orden de compra, Proceso cancelado.">
					</cfif>
					<!--- Recorre las lineas de la garatia --->
					<cfloop query="rsProcesoGarantia">
						<!--- Valida que la garantia posea fecha --->
						<cfif not len(trim(rsProcesoGarantia.CODGFechaFin))>
							<cfthrow message="La Garantia del proceso no posee una fecha final, Proceso cancelado.">
						<!--- Valida que la fecha final este en estado vigente, no se sobrepase la fecha actual --->
						<cfelseif LSParseDateTime(rsProcesoGarantia.CODGFechaFin) lt createdate(YEAR(now()), MONTH(now()), DAY(now()))>
							<cfthrow message="La Garantia del proceso no esta en estado vigente, Proceso cancelado.">
						</cfif>
					</cfloop>
					<!--- Se ejecuta solo para el tipo de Participación, solamente cuando es orden de compra--->
					<cfif Arguments.tipo eq 'P'>
						<!--- Obtiene las garantias activas:
						 1) Con el mimsmo proceso asociado a la orden de compra.
						 2) Diferente a la garantia asociada a la orden de compra.
						 3) Diferente al socio de negocio asociado a la orden de compra.
						 4) Que este activa. --->
						<cfquery name="rsGarantiaExtras" datasource="#arguments.Conexion#">
							select COEGid, COEGVersion
							from COHEGarantia a
								inner join SNegocios b
									on a.SNid = b.SNid
							where CMPid 		      =	 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsProceso.CMPid#">
								and COEGid 		      <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsProcesoGarantia.COEGid#">
								and SNcodigo 		  <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsProceso.SNcodigo#">
								and COEGTipoGarantia   = #tipoGarantia#
								and COEGVersionActiva =  1
								and a.Ecodigo 		  =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
							group by COEGid, COEGVersion
						</cfquery>
						<!--- Recorre las garantias asociadas:
							1) Crea una garantia(COLiberaGarantia) para procesar los estados(Liberación de Garantías, Aprobar Liberación Garantía, Devolución de Garantías).
							2) Cambia el estado de la garantia(COLiberaGarantia).
							3) Cambia el estado de la garantia(COHEGarantia). --->
						<cfloop query="rsGarantiaExtras">
							 <cfquery name="rsConseEjecucionGarantia" datasource="#session.DSN#">
									select coalesce(max(COLGnumeroControl),0) + 1 as consecutivoControl 
									from COLiberaGarantia
									where COLGTipoMovimiento = 1 <!--- Liberacion --->
							  </cfquery>
   						     <cfset LvarConsecutivoControl = rsConseEjecucionGarantia.consecutivoControl>	
							<cfinvoke method="ALTA_LIBERACION"
								COEGid="#rsGarantiaExtras.COEGid#"
								COLGObservacion="Liberación automática desde #msg#"
								COLGFecha="#now()#"
								COLGUsucodigo="#session.Usucodigo#"
								COEGVersion="#rsGarantiaExtras.COEGVersion#"
								COLGnumeroControl="#LvarConsecutivoControl#"
								COLGTipoMovimiento="1" <!--- Liberacion --->
                                Ecodigo="#Arguments.Ecodigo#"
								returnvariable="LvarCOLGid"
							/>
							<cfinvoke method="CAMBIO_LIBERACION_GARANTIA_APRUEBA"
								COLGid="#LvarCOLGid#"
								COEGEstado="3" <!--- Liberacion aprobada --->
								FechaAprueba="#now()#"
                                Ecodigo="#Arguments.Ecodigo#"
								returnvariable="LvarId"
							/>
							<cfinvoke 
								method				="CAMBIO_GARANTIA"
								COEGid				="#rsGarantiaExtras.COEGid#"
								COEGVersion			="#rsGarantiaExtras.COEGVersion#"
								COEGEstado			="7" <!--- 'Liberada' --->
								COEGVersionActiva	="1"
								COEGTipoGarantia   	= "#tipoGarantia#"
                                Ecodigo="#Arguments.Ecodigo#"
								returnvariable		="LvarId"
							/>
						</cfloop>
					</cfif>
				</cfloop>
			</cfif>
		</cfloop>
		<cfreturn true>
	</cffunction>
	
</cfcomponent>

