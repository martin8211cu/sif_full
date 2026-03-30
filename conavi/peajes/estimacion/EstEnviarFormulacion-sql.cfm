<cfset LvarPromedioVehicular = 0>
	
<!---Concepto de Ingreso --->
	<cfquery name="rsExisteVenc3" datasource="#session.DSN#">
		select Pvalor as conceptoIng
		from Parametros 
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		  and Pcodigo=1802
	</cfquery>
	
	<cfif rsExisteVenc3.recordcount eq 0>
		<cfthrow message="No se ha definido El Concepto de Ingreso, Proceso Cancelado!">
		<cfabort>
	</cfif>

	<cfquery name="rsParametrosPeaje2" datasource="#session.dsn#">
		select
		pe.PPrecio,
		co.PVid,
		cf.CFid,
		 p.Pid as Pid,
		 p.Pdescripcion as peaje,
		 co.COEPeriodo,
		 co.COEPorcVariacion,
		 co.COEPerInicial as periodoInicial,
		 co.COEMesInicial as mesInicial,
		 co.COEPerFinal as periodoFinal,
		 co.COEMesFinal as mesFinal,
		 max(((co.COEPerFinal * 12 + co.COEMesFinal ) - ( co.COEPerInicial  * 12 + co.COEMesInicial ) +1)) as totalmeses	,
	 	 coalesce( sum(dv.PDTVcantidad), 0) as cantidad

		 from PVehiculos pv
		  inner join PDTVehiculos dv
			on dv.PVid = pv.PVid
		left outer join COEstimacionIng co
			on pv.PVid = co.PVid
		inner join PPrecio pe
			on pe.PVid = co.PVid
			and pe.Pid = co.Pid
		inner join Peaje p
			on co.Pid= p.Pid
		inner join CFuncional cf
			on cf.CFid = p.CFid
		where co.COEPeriodo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#url.Periodo#">
		and co.COEPorcVariacion > 0
		and p.Pid  = #url.Pid#
		group by pe.PPrecio,co.PVid,cf.CFid, 		p.Pid,p.Pdescripcion,co.COEPeriodo,co.COEPorcVariacion,co.COEPerInicial,co.COEMesInicial,co.COEPerFinal,co.COEMesFinal
			order by cf.CFid, p.Pid,p.Pdescripcion,co.COEPeriodo,co.COEPorcVariacion  
    </cfquery>
	 <cfquery name="rsActEmpresarial" datasource="#session.dsn#">
	 Select
	     FPAEid,
	     CFComplemento 
	   from Peaje 
	      where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsParametrosPeaje2.CFid#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	 </cfquery>
	<cfif rsActEmpresarial.recordcount eq 0>
		<cfthrow message="No se ha definido La Actividad Empresarial para este peaje, Proceso Cancelado!">
		<cfabort>
	</cfif>
		
	<cfif isdefined('btnAplicar')>
		
		<cfquery name="rsVerificaD" datasource="#session.dsn#">
		  select count(1) from COEstimacionIng 
		 where COEPeriodo = <cfqueryparam value="#url.periodo#" cfsqltype="cf_sql_numeric"> 
		 and Pid = <cfqueryparam value="#rsParametrosPeaje2.Pid#" cfsqltype="cf_sql_numeric">
		</cfquery>
	
		<cfif rsVerificaD.recordcount gt 0>
			<cfquery name="rsEstimacion1" datasource="#session.dsn#">			
				select 
					a.FPEEid,
					a.CFid,
					a.FPTVid,
					a.FPEEestado,
					a.FPEEFechaLimite,
					a.FPEEUsucodigo,
					a.FPEEidRef,
					a.Ecodigo,
					a.CPPid,
					a.FPEEVersion,
					a.BMUsucodigo
				from 
					FPEEstimacion  a
				inner join TipoVariacionPres b
					on b.FPTVid = a.FPTVid
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and a.CPPid = #url.CPPid# <!-------Periodo Presupuestal Actual--->
				and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsParametrosPeaje2.CFid#">             											
				and a.FPEEestado = 0 
				and b.FPTVTipo  = -1	  <!-------En Preparacion--->
			</cfquery>			
			<cfquery name="rsConcepto" datasource="#session.dsn#">			
				select p.FPEPid,b.FPCCid from FPConcepto a 
				inner join FPCatConcepto b 
					on b.FPCCid =  a.FPCCid
				inner join FPDPlantilla p
					on p.FPCCid = a.FPCCid
				where a.FPCid = #rsExisteVenc3.conceptoIng#
			</cfquery>
			
			<cfquery name="rsElimina" datasource="#session.dsn#">			
				select FPDElinea,  FPEEid from FPDEstimacion 
				where FPEEid = #rsEstimacion1.FPEEid#
			</cfquery>
			
			<cfif rsElimina.recordcount gt 0>
				<cfloop query="rsElimina">
					<cfinvoke component="sif.Componentes.FPRES_EstimacionGI" method="BajaDetalleEstimacion">
						<cfinvokeargument name="FPEEid" 					value="#rsElimina.FPEEid#">
						<cfinvokeargument name="FPEPid" 					value="#rsConcepto.FPEPid#">
						<cfinvokeargument name="FPDElinea" 				value="#rsElimina.FPDElinea#">
					</cfinvoke>
				</cfloop>
			</cfif>
		</cfif>	
	
	   <cfif rsParametrosPeaje2.recordcount gt 0>
		<cfloop query="rsParametrosPeaje2">
		   	 <cfif  #LvarPromedioVehicular# neq '' >		
				
			<!---/**************Obtener el encabezado de la estimación *************************************/--->
				<cfquery name="rsEstimacion" datasource="#session.dsn#">			
						select 
							a.FPEEid,
							a.CFid,
							a.FPTVid,
							a.FPEEestado,
							a.FPEEFechaLimite,
							a.FPEEUsucodigo,
							a.FPEEidRef,
							a.Ecodigo,
							a.CPPid,
							a.FPEEVersion,
							a.BMUsucodigo
						from 
							FPEEstimacion  a
						inner join TipoVariacionPres b
							on b.FPTVid = a.FPTVid
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
						and a.CPPid = #url.CPPid#          														<!-------Periodo Presupuestal Actual--->
								and a.CFid = #rsParametrosPeaje2.CFid#             											
								and a.FPEEestado = 0 
								and b.FPTVTipo  = -1	  <!-------En Preparacion--->
						</cfquery>
						
						<cfquery name="rsConcepto" datasource="#session.dsn#">			
							select p.FPEPid,b.FPCCid from FPConcepto a 
							inner join FPCatConcepto b 
								on b.FPCCid =  a.FPCCid
							inner join FPDPlantilla p
								on p.FPCCid = a.FPCCid
							where a.FPCid = #rsExisteVenc3.conceptoIng#
						</cfquery>
			
					<!---Verifica si una Clasificacion de Ingreso y Egreso esta relacionado a una plantilla--->
					<cffunction name="isRelated" access="public" returntype="boolean">
						<cfargument name="Conexion"  type="string"   required="no">
						<cfargument name="FPCCid"    type="string"   required="no">
						<cfargument name="FPEPid"    type="string"   required="no">
						
						<cfquery datasource="#Arguments.Conexion#" name="rsisRelated">
							select count(1) as cantidad from FPDPlantilla where FPCCid = #Arguments.FPCCid#  and FPEPid = #Arguments.FPEPid#
						</cfquery>
						<cfquery datasource="#Arguments.Conexion#" name="isSon">
							select FPCCidPadre from FPCatConcepto where FPCCid = #Arguments.FPCCid# and FPCCidPadre is not null
						</cfquery>
						<cfif rsisRelated.cantidad>
							<cfreturn true>
						<cfelseif isSon.recordcount GT 0>
							<cfreturn isRelated(Arguments.Conexion,isSon.FPCCidPadre,Arguments.FPEPid)>
						<cfelse>
							<cfreturn false>
						</cfif>
					</cffunction>
			
					<cfif not isdefined('Arguments.Conexion')>
						<cfset Arguments.Conexion = session.dsn>
					</cfif>
					
					<cfloop query="rsConcepto">							
						<cfset pintar = isRelated(Arguments.Conexion,#rsConcepto.FPCCid#,#rsConcepto.FPEPid#)>
						<cfif pintar>
							<cfset Arguments.FPEPid = rsConcepto.FPEPid>
						</cfif>
					</cfloop>
			
				</cfif>	
			</cfloop>	
				<cfif rsEstimacion.recordcount gt 0>
					
					<cfinvoke component="sif.Componentes.FPRES_EstimacionGI" method="AltaDetalleEstimacion">
						<cfinvokeargument name="FPEEid" 					value="#rsEstimacion.FPEEid#">
						<cfinvokeargument name="FPCid" 					value="#rsExisteVenc3.conceptoIng#">
						<cfinvokeargument name="FPEPid" 					value="#Arguments.FPEPid#">
						<cfinvokeargument name="DPDEdescripcion" 		value="#rsParametrosPeaje2.peaje#">
						<cfinvokeargument name="DPDEjustificacion" 	value="#rsParametrosPeaje2.peaje#">
						<cfinvokeargument name="Mcodigo" 				value="#url.Mcodigo#">
						<cfinvokeargument name="DPDEcantidad" 			value="#LvarPromedioVehicular#">
						<cfinvokeargument name="DPDEcosto" 				value="#replace(LvarMonto,',','','ALL')#">
						<cfinvokeargument name="FPAEid" 					value="#rsActEmpresarial.FPAEid#">
						<cfinvokeargument name="CFComplemento" 		value="#rsActEmpresarial.CFComplemento#">
						<cfinvokeargument name="DPDMontoTotalPeriodo"value="#replace(LvarMonto,',','','ALL')#">
					</cfinvoke>
				
				</cfif>  
		 
			<!---Actualiza el COEstimacionIng  Una vez que se ha enviado a formular--->
			<cfquery datasource="#Arguments.Conexion#">
				update COEstimacionIng
					set COEEstado = '2', <!---enviado a formulación--->
					COEFechaFormulacion = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
					COEUsuarioFormulacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				where COEPeriodo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.periodo#">
				and Pid = #rsParametrosPeaje2.Pid#
			</cfquery>	 
	 <cfelse>
	 	<cfthrow message="No posee Líneas de Detalle, Proceso Cancelado!">
	 </cfif>
</cfif>
<cflocation url="EstEnviarFormulacion.cfm" addtoken="no">


