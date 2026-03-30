<cfcomponent output="false">
	<cffunction name="CreaTarjeta" access="public" returntype="string">
		<cfargument name="Zona" 		type="integer"  required="true" >
		<cfargument name="Cuentaid" 	type="integer"  required="true" >
		<cfargument name="Mayorista" 	type="boolean" required="false" default="false" hint="si la tarjete es de credito mayorista">
		<cfargument name="AdicionalID" type="integer" required="false" default="-1" hint="id de Cliente adicional">

		<cfquery name="rsFech" datasource="#session.dsn#">
			select year(isnull(SNFechaNacimiento,SNFecha)) as anio, 
				month(isnull(SNFechaNacimiento,SNFecha)) as mes, 
				isnull(SNFechaNacimiento,SNFecha) SNFecha 
			from CRCCuentas cc
			inner join SNegocios sn
				on sn.SNid = cc.SNegociosSNid
			where id = #arguments.Cuentaid#
		</cfquery>
	<!--- 	<cfif arguments.AdicionalID eq -1>
			<cfquery name="rsMaxConsecutivo" datasource="#session.dsn#">
				select right('0000' + cast(cast(right( COALESCE(max(Numero),0),4) as integer)+1 as varchar),4) 
					as consecutivo
				from CRCTarjeta 
			</cfquery>		
		<cfelse> --->
		
		<!--- </cfif> --->
		<cfset zona = right("00#arguments.Zona#",2)>		

		<cfset LvarAnio1 ="#Mid(rsFech.anio,3,1)#">
		<cfset LvarAnio2 ="#Mid(rsFech.anio,4,1)#">
		<cfset LvarMes1  ="#Mid(rsFech.SNFecha,6,1)#">
		<cfset LvarMes2  ="#Mid(rsFech.SNFecha,7,1)#">

		<cfquery name="rsMaxConsecutivo" datasource="#session.dsn#">
			select max(cast(right(Numero,6) as numeric)) + 1 as consecutivo
			from CRCTarjeta
			where numero like '#LvarAnio1##LvarMes1##LvarAnio2##LvarMes2##zona#______'
		</cfquery>

		<cfset LvarNumerico	="#LvarAnio1##LvarMes1##LvarAnio2##LvarMes2##zona##right('000000' & rsMaxConsecutivo.consecutivo,6)#">
<!--- <cf_dump var="#LvarNumerico#"> --->
		<cfquery datasource="#session.dsn#" name="ins">
			INSERT INTO CRCTarjeta
	           (CRCCuentasid,Numero,Estado,Mayorista,FechaDesde,FechaHasta,
	           Ecodigo,Usucrea,createdat,CRCTarjetaAdicionalid)
			VALUES
		           (
		           #arguments.Cuentaid#	 	
		           ,'#LvarNumerico#'
		           ,'G'
		           ,<cfqueryparam cfsqltype="cf_sql_numeric" value="1" null="#arguments.Mayorista eq false#">
		           ,getdate()
		           ,null
		           ,#Session.Ecodigo#
		           ,#session.Usucodigo#
		           ,getDate()
		           ,
		           <cfif arguments.AdicionalID eq -1>
						null
					<cfelse>
						#arguments.AdicionalID#	
					</cfif>)
			<cf_dbidentity1 datasource="asp">
		</cfquery>
		
		<cf_dbidentity2 datasource="asp" name="ins">
		
		<cfreturn ins.identity>
		
	<!--- 	<cfset loc.numero ="">
	 --->	<!--- 
		<cfif ucase(arguments.tipo) eq "D">
			<cfset loc.numero ="01">
		<cfelseif ucase(arguments.tipo) eq "TC">
			<cfset loc.numero ="02">
		<cfelseif ucase(arguments.tipo) eq "TM">
			<cfset loc.numero ="03">
		</cfif>
		 --->
		<!--- <cfset loc.numero ="#loc.numero##DateFormat(now(),'YYMM')#">
 ---><!--- 
		<cfquery name="rsMaxConsecutivo" datasource="#session.dsn#">
			select right('0000' + cast(cast(right( COALESCE(max(Numero),0),4) as integer)+1 as varchar),4) as consecutivo
			from CRCTarjeta where Numero like '#loc.numero#%' and Ecodigo = #Session.Ecodigo#
		</cfquery>
		<cfset loc.numero ="#loc.numero##rsMaxConsecutivo.consecutivo#">

		<cfquery name="rsEstatusid" datasource="#session.dsn#">
			select top 1 id from CRCEstatusCuentas where Ecodigo = #session.Ecodigo# order by Orden
		</cfquery>

		<!--- Estados: G:Generado,A:Activa,X:Cancelado --->

		<cfquery datasource="#session.dsn#" name="ins">
			NSERT INTO CRCTarjeta
	           (Numero,Estado,Mayorista,FechaDesde,FechaHasta,
	           Ecodigo,Usucrea,createdat)
			VALUES
		           (#arguments.snid#
		           ,'#loc.numero#'
		           ,'G'
		           ,<cfqueryparam cfsqltype="cf_sql_numeric" value="1" null="#arguments.Mayorista eq false#">
		           ,getdate()
		           ,null
		           ,#Session.Ecodigo#
		           ,#session.Usucodigo#
		           ,getDate())
			<cf_dbidentity1 datasource="asp">
		</cfquery>
		<cf_dbidentity2 datasource="asp" name="ins">
		<cfreturn ins.identity>
 	<cfreturn 5>
--->
	</cffunction>
	
	<cffunction name="ValidarNumero" access="public" return="numeric">
		<cfargument name="Num_Producto" 	required="yes" 		type="numeric">
		<cfargument name="Monto" 			default=0 			type="numeric">
		<cfargument name="DSN" 				default="#Session.DNS#" type="string">
		<cfargument name="Ecodigo" 			default="#Session.Ecodigo#" type="string">
		
		<cfargument name="SocioNegocioID" 	default=0 			type="numeric">
		<cfargument name="TipoProducto" 	default='' 			type="string">
		<cfargument name="TipoTransac"		default='' 			type="string">
		<cfargument name="TiendaID" 		default='' 			type="string">
		
		
		<cfquery name="q_Tarjeta" datasource="#arguments.DSN#">
			select Estado,CRCCuentasid from CRCTarjeta
				where Numero = '#arguments.Num_Producto#' and Ecodigo = #arguments.Ecodigo#;
		</cfquery>
		
		
		<cfif q_Tarjeta.recordcount eq 1>
			<cfset q_Tarjeta = QueryGetRow(q_Tarjeta, 1)>
			<cfif q_Tarjeta.Estado eq "A">				
				<cfif arguments.TipoTransac eq 'D'>
					<cfreturn q_Tarjeta.CRCCuentasid>
				</cfif>
				<cfset objCuenta = createObject("component","crc.Componentes.CRCCuentas")>
				<cfset montoDisponible = objCuenta.DisponibleCuenta(CuentaID="#q_Tarjeta.CRCCuentasid#", Monto="#arguments.Monto#",DSN = #arguments.DSN#,Ecodigo = #arguments.Ecodigo#)>
				<cfif (arguments.Monto le montoDisponible and arguments.Monto ge 0) || arguments.Monto eq 0>
					<cfreturn q_Tarjeta.CRCCuentasid>
				<cfelse>
					<cfreturn 0>
				</cfif>
			</cfif>
		<cfelse>
			<cfthrow type="TransaccionException" message = "No se encontro una cuenta para tarjeta numero [#arguments.Num_Producto#]">
		</cfif>
		<cfreturn 0>

		
	</cffunction>
	
	
	
	
</cfcomponent>