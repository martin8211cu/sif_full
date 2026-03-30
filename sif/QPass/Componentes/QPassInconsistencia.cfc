<cfcomponent>
	<cffunction name="fnReprocesar" access="public" output="no" hint="Reprocesa">
		<cfargument name="Conexion" 	    type="string"  default="#session.dsn#">
		<cfargument name='Ecodigo'		    type="numeric" default="#Session.Ecodigo#">				 
        <cfargument name="QPMid" 			type="numeric"  required="no" default="-1">
		<cfargument name='QPTPAN' 			type="string"   required="no" default="-1">			
		<cfargument name='QPMCFInclusion' 	type='date' 	required="no">				 
		<cfargument name='QPMCdescripcion' 	type='string' 	required="no" default=""> 	 
		<cfargument name='QPTidTag' 		type='numeric' 	required="no" default="0">	   
		<cfargument name='QPMCMonto' 	    type='numeric' 	required="no" default="0">	
		<cfargument name='BMusucodigo'		type="numeric" default="#Session.Usucodigo#">				 
		<cfset LvarError = ''>

		<cf_dbtemp name="QPInconsistencia" returnvariable="TempTable" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="Ecodigo" 			type="integer" 		mandatory="yes">
			<cf_dbtempcol name="QPTPAN" 			type="char(20)" 	mandatory="yes">	
			<cf_dbtempcol name="QPMid" 				type="numeric" 		mandatory="yes">	
			<cf_dbtempcol name="QPMCFInclusion" 	type="datetime" 	mandatory="no">
			<cf_dbtempcol name="QPMCdescripcion" 	type="varchar(80)" 	mandatory="no">
			<cf_dbtempcol name="QPctaSaldosid" 		type="numeric" 		mandatory="no">
			<cf_dbtempcol name="QPcteid" 			type="numeric" 		mandatory="no">
			<cf_dbtempcol name="QPTidTag" 			type="numeric" 		mandatory="no">
			<cf_dbtempcol name="QPMCMonto" 			type="money" 		mandatory="no">
		</cf_dbtemp>
		
	<cfquery datasource="#Arguments.Conexion#">
		insert into #TempTable# (QPMid,Ecodigo, QPTPAN, QPMCFInclusion, QPMCMonto, QPMCdescripcion)
		values ( #Arguments.QPMid#, #Arguments.Ecodigo#, '#Arguments.QPTPAN#', '#Arguments.QPMCFInclusion#', #Arguments.QPMCMonto# , '#Arguments.QPMCdescripcion#')
	</cfquery>
	
    <!--- Actualizar el id del TAG --->
    <!--- Documentacion de Campo:  Estado de Dispositivo ( QPTEstadoActivacion )
		1: En Banco / Almacen o Sucursal, 
		2:  Recuperado ( En poder del banco por recuperacion )
		3:  En proceso de Venta ( Asignado a Cliente pero no Activado )
		4. Vendido y Activo
		5: Vendido e Inactivo
		6:  Vendido y Retirado
		7: Robado o Extraviado
		8: En traslado sucurcal/PuntoVenta
		9: Asignado a Promotor
		90: Eliminado--->
		
		<cfquery name="rsTag" datasource="#Arguments.Conexion#">
			select count(1) as cantidad
			from QPassTag a
			where Ecodigo  = #Arguments.Ecodigo#
 			and a.QPTPAN   = '#Arguments.QPTPAN#'
		</cfquery>
		
		<cfif rsTag.cantidad gt 0>
			<cfquery name="rsVerificaTag" datasource="#Arguments.Conexion#">
				select count(1) as cantidad
				from QPassTag a
				where Ecodigo  = #Arguments.Ecodigo#
				and a.QPTPAN   = '#Arguments.QPTPAN#'
				and a.QPTEstadoActivacion in (4,5,6)		
			</cfquery>
		
				<cfif rsVerificaTag.cantidad GT 0>
					<cfquery datasource="#Arguments.Conexion#">
						update #TempTable#
						set QPTidTag = ((
							select min(QPTidTag)
							from QPassTag a
							where a.Ecodigo = #Arguments.Ecodigo#
							  and a.QPTPAN   = '#Arguments.QPTPAN#'
							  and a.QPTEstadoActivacion in (4,5,6)
						))
						where QPMid = #Arguments.QPMid#
					</cfquery>
				<cfelse>	
					<cfset LvarError = 'El dispositivo #Arguments.QPTPAN#, No a sido vendido'>
				</cfif>
		<cfelse>
			<cfset LvarError = 'El dispositivo #Arguments.QPTPAN#, No a sido ingresado al sistema'>
		</cfif>
			
    <!--- actualizar la cuenta de saldos de la tabla temporal - de esta forma se puede saber los registros con error --->
	
		<cfquery name="rsTemp" datasource="#Arguments.Conexion#">
			select QPTidTag,QPctaSaldosid from #TempTable# where QPMid = #Arguments.QPMid# and QPTidTag is not null
		</cfquery>
		
	
		<cfif rsTemp.QPTidTag gt 0>
			<cfquery name="rsVerificaCuenta" datasource="#Arguments.Conexion#">
				select max(QPctaSaldosid) as QPctaSaldosid
					from QPventaTags a
				where a.QPTidTag   = #rsTemp.QPTidTag#
			</cfquery>
			
			<cfset LvarQPctaSaldosid = #rsVerificaCuenta.QPctaSaldosid#>
		
			<cfif rsVerificaCuenta.recordcount GT 0>
				<cfquery datasource="#Arguments.Conexion#">
					update #TempTable#
					set QPctaSaldosid = #LvarQPctaSaldosid#
					where QPMid = #Arguments.QPMid# and QPTidTag is not null
				</cfquery>
			<cfelse>
				<cfset LvarError="El dispositivo #Arguments.QPTPAN#, No se encuentra asociado a una cuenta">
			</cfif>
			
			
			<cfif len(trim(LvarQPctaSaldosid)) gt 0>
				<cfquery name="rsVerificaCliente" datasource="#Arguments.Conexion#">
					select max(QPcteid) as QPcteid
						from QPventaTags a
						where a.QPctaSaldosid   = #LvarQPctaSaldosid#
				</cfquery>
				
				<cfset LvarQPcteid = #rsVerificaCliente.QPcteid#>
	
				<cfif rsVerificaCliente.recordcount GT 0>
					<cfquery datasource="#Arguments.Conexion#">
						update #TempTable#
						set QPcteid = #LvarQPcteid#
						where 
						QPMid = #Arguments.QPMid# 
						and QPctaSaldosid is not null
						and QPTidTag      is not null
					</cfquery>
				<cfelse>
					<cfset LvarError="El dispositivo #Arguments.QPTPAN#, No se encuentra asociado a un cliente.">
				</cfif>
			</cfif>
		</cfif>

	
    <!--- Obtiene la categoría marcada para la importación de movimientos de Autopistas del Sol (ADS) --->
    <cfquery name="rsCausaparaImportacion" datasource="#Arguments.Conexion#">
        select min(QPCid) as QPCid
        from QPCausa
        where Ecodigo = #Arguments.Ecodigo#
        and QPCtipo = 2 <!--- indica si la causa es la que se usa en la importación de movimientos de Autopistas del Sol (ADS) --->
    </cfquery>
	
    <cfset LvarQPCid = rsCausaparaImportacion.QPCid>
	
	   <cfquery name="rsMoneda" datasource="#Arguments.Conexion#">
        select Mcodigo 
        from Empresas 
        where Ecodigo = #Arguments.Ecodigo#
    </cfquery>
   	 <cfset LvarMcodigo = rsMoneda.Mcodigo>
	
    <cfif len(trim(rsCausaparaImportacion.QPCid)) neq 0>
 
	<cfquery name="rsMovimientoImportacion" datasource="#Arguments.Conexion#">
		select min(QPMovid) as QPMovid
		from QPCausaxMovimiento
		where Ecodigo = #Arguments.Ecodigo#
		and QPCid = #LvarQPCid# <!--- indica si la causa es la que se usa en la importación de movimientos de Autopistas del Sol (ADS) --->
	</cfquery>
		
	<cfset LvarQPMovid = rsMovimientoImportacion.QPMovid>	
		
		<cfif len(trim(LvarQPMovid)) neq 0>
			<cfquery name="rsDato" datasource="#Arguments.Conexion#">
				select QPTidTag  from #TempTable# where QPMid = #Arguments.QPMid# and Ecodigo = #Arguments.Ecodigo#
			</cfquery>
	
			<cfif len(trim(rsDato.QPTidTag))>
				<cfquery datasource="#Arguments.Conexion#">
					insert into QPMovCuenta ( QPCid, QPctaSaldosid, QPcteid, QPMovid, QPTidTag, QPTPAN, QPMCFInclusion, Mcodigo, QPMCMonto, QPMCMontoLoc, QPMCdescripcion, BMFecha)
					select #LvarQPCid#, QPctaSaldosid, QPcteid, #LvarQPMovid#, QPTidTag, QPTPAN, QPMCFInclusion, #LvarMcodigo#, QPMCMonto, QPMCMonto, QPMCdescripcion, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
					from #TempTable#
					where QPMid = #Arguments.QPMid# and QPTidTag is not null
				</cfquery>
				<cfset fnCambiaEstado(Arguments.Conexion,Arguments.Ecodigo,Arguments.QPMid,Arguments.QPTPAN,2,#Arguments.BMusucodigo#,#Now()#)>
			</cfif>
		<cfelse>
			<cfset LvarError="No existe un movimiento que contenga la causa marcada para Movimiento por Uso (ADS), esto se define en el cat&aacute;logo de Movimientos.">
		</cfif>
   <cfelse>
   		<cfset LvarError="No se ha marcado una causa de Movimiento de Uso (cat&aacute;logo causas - Movimiento por Uso (ADS))">
	</cfif>	
	
	<cfif len(trim(LvarError)) gt 0>
		<cfquery name="rsintento" datasource="#Arguments.Conexion#">
			select coalesce(QPMCintento,0) + 1 as intento
			from QPMovInconsistente
			where QPMid = #Arguments.QPMid#
		</cfquery>
	
		<cfquery datasource="#Arguments.Conexion#">
			update QPMovInconsistente
			set QPMCintento = #rsintento.intento#,
				QPMCerrordesc  = '#LvarError#'
			where QPMid = #Arguments.QPMid#
		</cfquery>
	</cfif>
</cffunction>

	<!--- Actualizar el Estado Tabla Inconsistencias (QPMovInconsistente)
		Documentacion de Campo:  Estado ( QPMestado )
		2: reprocesado, 
		1: Eliminado, 
		0: Inconsistente
	--->
	<cffunction name="fnCambiaEstado" access="public" output="no" hint="Cambia el estado 1-eliminado 2-reprocesado" returntype="boolean">
    	<cfargument name="Conexion" 	type="string"  default="#session.dsn#">
        <cfargument name="Ecodigo" 		type="numeric" default="#Session.Ecodigo#">
        <cfargument name="QPMid" 		type="numeric" required="no"  default="-1">
        <cfargument name="QPTPAN"   	type="string"  required="no"  default="-1">
        <cfargument name="QPMestado"  	type="numeric" required="no"  default="0">
        <cfargument name="BMusucodigo"  type="numeric" default="#session.Usucodigo#">
		<cfargument name="QPMCFechaM" 	type="date"    required="no"  default="#Now()#">
	
			<cfquery datasource="#Arguments.Conexion#">
				Update QPMovInconsistente
				set QPMestado = #Arguments.QPMestado#,
				BMusucodigo = #Arguments.BMusucodigo#,
				QPMCFechaM = #Arguments.QPMCFechaM#
				where QPMid   = #Arguments.QPMid#
			</cfquery>
		<cfreturn true>
	</cffunction>
</cfcomponent>
