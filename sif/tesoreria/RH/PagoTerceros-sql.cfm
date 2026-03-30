<CF_NAVEGACION NAME="SNid">
<CF_NAVEGACION NAME="periodo" default="0">
<CF_NAVEGACION NAME="mes"     default="0">
<CF_NAVEGACION NAME="TESSPtipoDocumento" default="5"><!---►►Manual de CxP.◄◄--->
<CF_NAVEGACION NAME="Action" 			 default="">

<cfif ListFind('G,R',form.Action)>

	<!---Busca la informacion del Socio de Negocios--->
	<cfquery datasource="#session.dsn#" name="SNegocios">
		select SNid, SNcodigo
		  from SNegocios
		where SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNid#">
	</cfquery>

	<!---Retorna el Pasivo de las deducciones tanto obrero como Patrono--->
	<cfinvoke method="GetPasivoPatronoObrero" returnvariable="RsPasivo">
	</cfinvoke>
	
	<!---Retorna el Gasto de las deducciones Patronales--->
	<cfinvoke method="GetGastoPatrono" returnvariable="RsGastoPatronalTEMP">
	</cfinvoke>
	
	<!---►►Crea tabla Temportar para Distribucion de los Gastos, Integracion con Tesoreria◄◄--->
    <cfinvoke component="rh.Componentes.RH_PagoNomina" method="CrearTemporalTesoreria" returnvariable="tmpDistribucionTES"/>
    
    <!---►►Se genera la distribucion de las deducciones entre las cuentas de gasto, parte obrero◄◄---> 
    <cfinvoke component="rh.Componentes.RH_PagoNomina" method="GeneraDistribucionTesoreria">
    	<cfinvokeargument name="Tabla"     value="#tmpDistribucionTES#">
        <cfinvokeargument name="Detallado" value="False">
        <cfinvokeargument name="SNid" 	   value="#form.SNid#">
        <cfinvokeargument name="Periodo"   value="#form.Periodo#">
        <cfinvokeargument name="Mes" 	   value="#form.Mes#">
    </cfinvoke>
    
    <cftransaction>
    	<!---Se recorre cada uno de los registros y se agrupa por Tipo de Nomina--->
        <cfoutput query="RsPasivo" group="Tcodigo">
			
        	<cfquery name="rsRCNids" dbtype="query">
            	select distinct RCNid, HERNdescripcion 
					from RsPasivo 
				where Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(RsPasivo.Tcodigo)#">
				 order by RCNid
            </cfquery>
			
			<!---Se esta regenerando la Solicitud de Pago, por lo tanto hay que borrar la anterior--->
			<cfif ListFind('R',form.Action)>
				<cfquery name="rsTESsolicitudPago" datasource="#session.dsn#">
					select TESSPid
						from TESsolicitudPago
					where SNid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rtrim(SNegocios.SNid)#">
					  and RCNids = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(rsRCNids.RCNid)#">
				</cfquery>
				<cfif NOT rsTESsolicitudPago.RecordCount>
					<cfthrow message="No se pudo recuperar la Solicitu de Pago a Regenerar">
				<cfelse>
					<cfquery datasource="#session.dsn#">
						delete from TESgastosPago
						where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rtrim(rsTESsolicitudPago.TESSPid)#">
					</cfquery>
					<cfquery datasource="#session.dsn#">
						delete from TESdetallePago
						where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rtrim(rsTESsolicitudPago.TESSPid)#">
					</cfquery>
					<cfquery datasource="#session.dsn#">
						delete from TESsolicitudPago
						where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rtrim(rsTESsolicitudPago.TESSPid)#">
					</cfquery>					
				</cfif>
			</cfif>
			
        	<!---►►Se Crea el Encabezado de la Solicitud de Pago◄◄--->
            <cfinvoke component="sif.Componentes.TESsolicitudPago" method="AltaTESsolicitudPago" returnvariable="LvarTESSPid">
                <cfinvokeargument name="TESSPtipoDocumento"  value="#form.TESSPtipoDocumento#">
                <cfinvokeargument name="TESSPfechaPagar" 	 value="#now()#">
                <cfinvokeargument name="TESSPtotalPagarOri"  value="100">
                <cfinvokeargument name="TESOPobservaciones"  value="#ValueList(rsRCNids.HERNdescripcion)#">
                <cfinvokeargument name="TESOPinstruccion" 	 value="">
                <cfinvokeargument name="SNid" 				 value="#rtrim(SNegocios.SNid)#">
                <cfinvokeargument name="SNcodigoOri" 		 value="#rtrim(SNegocios.SNcodigo)#">
                <cfinvokeargument name="ConTramite" 		 value="true">
                <cfinvokeargument name="TESSPtipoDocumento"  value="5">
                <cfinvokeargument name="CFid"  				 value="#RsPasivo.CFid#">
                <cfinvokeargument name="RCNids"  			 value="#ValueList(rsRCNids.RCNid)#">
            </cfinvoke>

            <!---►►Se Crean las Lineas de Gasto que generan el pagado, sobre Cargas Patronales◄◄--->
			<cfquery dbtype="query" name="RsGastoPatronal">
				select Tcodigo, Tdescripcion, Ocodigo, Descripcion, CFcuenta, monto, tipo, Miso4217, TC
				 from RsGastoPatronalTEMP
				where Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RsPasivo.Tcodigo#">
			</cfquery>
			
            <cfloop query="RsGastoPatronal">
                <cfinvoke component="sif.Componentes.TESsolicitudPago" method="AltaTESgastosPago" access="public">
                    <cfinvokeargument name="Conexion" 		 	value="#session.dsn#">
                    <cfinvokeargument name="Ecodigo"  			value="#session.Ecodigo#">
                    <cfinvokeargument name="Usucodigo" 			value="#session.Usucodigo#">
                    <cfinvokeargument name="TESSPid" 			value="#LvarTESSPid#">
                    <cfinvokeargument name="Ocodigo" 			value="#RsGastoPatronal.Ocodigo#">
                    <cfinvokeargument name="TESGPdescripcion" 	value="Patrono:#RsGastoPatronal.Descripcion#">
                    <cfinvokeargument name="TESGPmovimiento" 	value="#RsGastoPatronal.tipo#">
                    <cfinvokeargument name="CFcuenta" 			value="#RsGastoPatronal.CFcuenta#">
                    <cfinvokeargument name="Miso4217" 			value="#RsGastoPatronal.Miso4217#">
                    <cfinvokeargument name="TESGPmontoOri" 		value="#RsGastoPatronal.monto#">
                    <cfinvokeargument name="TESGPtipoCambio" 	value="#RsGastoPatronal.TC#">
                    <cfinvokeargument name="TESGPmonto" 		value="#RsGastoPatronal.monto#">
                </cfinvoke>
            </cfloop>
			
			<cfquery datasource="#session.dsn#" name="RsGastoObrero">
				select a.Ocodigo, a.Descripcion, a.CFcuenta, 'D' as TipoMov, 1 as TC,'CRC' as Miso4217, SUM(Coalesce(MontoDeducir,0)) MontoDeducir
					from #tmpDistribucionTES# a
						inner join HERNomina no
							on no.RCNid = a.RCNid	
						inner join CuentasBancos ba
							on ba.CBcc = no.CBcc
					where no.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RsPasivo.Tcodigo#">
				group by a.Ocodigo, a.Descripcion, a.CFcuenta
				having SUM(Coalesce(MontoDeducir,0)) <> 0
			</cfquery>
            
            <!---►►Se Crean las Lineas de Gasto que generan el pagado, sobre Cargas, Deducciones y renta Obrero◄◄--->
            <cfloop query="RsGastoObrero">
                <cfinvoke component="sif.Componentes.TESsolicitudPago" method="AltaTESgastosPago" access="public">
                    <cfinvokeargument name="Conexion" 		 	value="#session.dsn#">
                    <cfinvokeargument name="Ecodigo"  			value="#session.Ecodigo#">
                    <cfinvokeargument name="Usucodigo" 			value="#session.Usucodigo#">
                    <cfinvokeargument name="TESSPid" 			value="#LvarTESSPid#">
                    <cfinvokeargument name="Ocodigo" 			value="#RsGastoObrero.Ocodigo#">
                    <cfinvokeargument name="TESGPdescripcion" 	value="Obrero:#RsGastoObrero.Descripcion#">
                    <cfinvokeargument name="TESGPmovimiento" 	value="#RsGastoObrero.TipoMov#">
                    <cfinvokeargument name="CFcuenta" 			value="#RsGastoObrero.CFcuenta#">
                    <cfinvokeargument name="Miso4217" 			value="#RsGastoObrero.Miso4217#">
                    <cfinvokeargument name="TESGPmontoOri" 		value="#RsGastoObrero.MontoDeducir#">
                    <cfinvokeargument name="TESGPtipoCambio" 	value="#RsGastoObrero.TC#">
                    <cfinvokeargument name="TESGPmonto" 		value="#RsGastoObrero.MontoDeducir#">
                </cfinvoke>
            </cfloop>
            
            <cfoutput>
               	<cfinvoke component="sif.Componentes.TESsolicitudPago" method="AltaTESdetallePago" returnvariable="Rlinea">
         			<cfinvokeargument name="TESSPid" 				 value="#LvarTESSPid#">
            		<cfinvokeargument name="TESDPtipoDocumento" 	 value="#form.TESSPtipoDocumento#">
            		<cfinvokeargument name="TESDPidDocumento" 		 value="#LvarTESSPid#">
           		 	<cfinvokeargument name="TESDPmoduloOri" 		 value="RHPN">
            		<cfinvokeargument name="TESDPdocumentoOri" 		 value="#RsPasivo.Codigo#">
                    <cfinvokeargument name="TESDPreferenciaOri" 	 value="Referencia">
                    <cfinvokeargument name="TESDPfechaVencimiento" 	 value="#NOW()#">
                    <cfinvokeargument name="TESDPfechaSolicitada" 	 value="#NOW()#">
                    <cfinvokeargument name="TESDPfechaAprobada" 	 value="#NOW()#">
            		<cfinvokeargument name="TESDPmontoSolicitadoOri" value="#RsPasivo.monto#">
            		<cfinvokeargument name="CFcuentaDB" 			 value="#RsPasivo.CFcuenta#">
                    <cfinvokeargument name="TESDPdescripcion" 		 value="#RsPasivo.Descripcion#">
                    <cfinvokeargument name="CFid" 					 value="#RsPasivo.CFid#">
                    <cfinvokeargument name="Ecodigo" 				 value="#session.Ecodigo#">
           		</cfinvoke>
            </cfoutput>
        </cfoutput>
        Finalización de generación de Solicitudes<br />
    </cftransaction>
    <cflocation url="PagoTerceros.cfm?Periodo=#form.Periodo#&mes=#form.Mes#" addtoken="no">
<cfelse>
	Accion no implementada<cfabort>
</cfif>

<cffunction name="GetPasivoPatronoObrero">
	<cfquery datasource="#session.dsn#" name="RsPasivo">
		<!---►►Pasivo de de las Cargas patronales y del Empleado◄◄--->
		select a.RCNid, no.HERNdescripcion, rtrim(g.Tcodigo) Tcodigo, g.Tdescripcion, ba.Ocodigo, a.CFid, d.DCcodigo Codigo, d.DCdescripcion Descripcion, a.CFcuenta, SUM(a.montores) monto
			 from RCuentasTipo a	
				inner join HERNomina no
					on no.RCNid = a.RCNid		 	
				inner join SNegocios b
					on b.SNid = a.SNid
				left Outer join SNegocios c
					on c.SNid = b.SNidPadre
				inner join DCargas d
					on d.DClinea = a.referencia
				inner join CalendarioPagos f
					on f.CPid = a.RCNid
				inner join TiposNomina g
					 on g.Ecodigo = f.Ecodigo
					and g.Tcodigo = f.Tcodigo
				inner join CuentasBancos ba
					on ba.CBcc = no.CBcc
            where a.tiporeg in (30,31,40,41,50,51,52,55,56,57)
			  and d.DCprovision = 0
			  and Coalesce(c.SNid,b.SNid) = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.SNid#">
			  and f.CPperiodo             = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.periodo#">
			  and f.CPmes                 = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.mes#">
			  and a.tipo                  = 'C' 
			  and no.HERNestado in (4,6)
              and 0 = (select count(1) 
                            from TESsolicitudPago tes 
                            where  convert(varchar , a.RCNid) in (tes.RCNids) 
                                and tes.SNid = a.SNid 
                                and TESSPestado = 12
                             )
		   group by a.RCNid, no.HERNdescripcion, rtrim(g.Tcodigo), g.Tdescripcion, ba.Ocodigo, a.CFid, d.DCcodigo,d.DCdescripcion, a.CFcuenta
		   
		 UNION ALL
		 
		<!---►►Pasivo de las Deducciones del Empleado◄◄--->      
		select a.RCNid, no.HERNdescripcion, rtrim(g.Tcodigo) Tcodigo, g.Tdescripcion, ba.Ocodigo, a.CFid, TDcodigo Codigo, e.TDdescripcion Descripcion, a.CFcuenta, SUM(a.montores) monto
			 from RCuentasTipo a	
				inner join HERNomina no
					on no.RCNid = a.RCNid	 	
				inner join SNegocios b
					on b.SNid = a.SNid
				left Outer join SNegocios c
					on c.SNid = b.SNidPadre
				inner join DeduccionesEmpleado d
					 on d.Did    = a.referencia
					and d.DEid   = a.DEid
				inner join TDeduccion e
					on e.TDid = d.TDid
				inner join CalendarioPagos f
					on f.CPid = a.RCNid
				inner join TiposNomina g
					 on g.Ecodigo = f.Ecodigo
					and g.Tcodigo = f.Tcodigo
				inner join CuentasBancos ba
					on ba.CBcc = no.CBcc
			where a.tiporeg in (60,61)
			  and Coalesce(c.SNid,b.SNid) = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.SNid#">
			  and f.CPperiodo             = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.periodo#">
			  and f.CPmes                 = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.mes#">
			  and a.tipo                  = 'C'
			  and no.HERNestado in (4,6)
              and 0 = (select count(1) 
                            from TESsolicitudPago tes 
                            where  convert(varchar , a.RCNid) in (tes.RCNids) 
                                and tes.SNid = a.SNid 
                                and TESSPestado = 12
                             )
			  group by a.RCNid,no.HERNdescripcion, rtrim(g.Tcodigo),  g.Tdescripcion, ba.Ocodigo, a.CFid, e.TDcodigo, e.TDdescripcion, a.CFcuenta
			 
		   UNION ALL
		
		<!---►►Pasivo de la Renta del Empleado◄◄--->      
		select a.RCNid,no.HERNdescripcion, rtrim(g.Tcodigo) Tcodigo, g.Tdescripcion, ba.Ocodigo, a.CFid, 'Renta' Codigo,'Renta' Descripcion, a.CFcuenta, SUM(a.montores) monto
			 from RCuentasTipo a
				inner join HERNomina no
					on no.RCNid = a.RCNid		 	
				inner join SNegocios b
					on b.SNid = a.SNid
				left Outer join SNegocios c
					on c.SNid = b.SNidPadre		
				inner join CalendarioPagos f
					on f.CPid = a.RCNid		
				inner join TiposNomina g
					 on g.Ecodigo = f.Ecodigo
					and g.Tcodigo = f.Tcodigo
				inner join CuentasBancos ba
					on ba.CBcc = no.CBcc
			where a.tiporeg in (70)
			  and Coalesce(c.SNid,b.SNid) = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.SNid#">
			  and f.CPperiodo             = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.periodo#">
			  and f.CPmes                 = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.mes#">
			  and a.tipo                  = 'C'
			  and no.HERNestado in (4,6)
              and 0 = (select count(1) 
                            from TESsolicitudPago tes 
                            where  convert(varchar , a.RCNid) in (tes.RCNids) 
                                and tes.SNid = a.SNid 
                                and TESSPestado = 12
                             )
			  group by a.RCNid, no.HERNdescripcion, rtrim(g.Tcodigo), g.Tdescripcion, ba.Ocodigo, a.CFid, a.CFcuenta
		   order by ba.Ocodigo 
	</cfquery>
	<cfreturn RsPasivo>
</cffunction>

<cffunction name="GetGastoPatrono">
	<cfquery datasource="#session.dsn#" name="RsGastoPatronal">
		<!---►►Gasto de las Cargas patronales, estas tienen su propia cuenta de Gasto, no hay que prorratear◄◄--->
		select rtrim(g.Tcodigo) Tcodigo, g.Tdescripcion, a.Ocodigo, d.DCcodigo Codigo, d.DCdescripcion Descripcion, a.CFcuenta, SUM(a.montores) monto, a.tipo, mo.Miso4217 , 1 as TC
			 from RCuentasTipo a	
				inner join HERNomina no
					on no.RCNid = a.RCNid	
				inner join Monedas mo
					on mo.Mcodigo = no.Mcodigo 	
				inner join SNegocios b
					on b.SNid = a.SNid
				left Outer join SNegocios c
					on c.SNid = b.SNidPadre
				inner join DCargas d
					on d.DClinea = a.referencia
				inner join CalendarioPagos f
					on f.CPid = a.RCNid
				inner join RHEjecucion ej
					 on ej.RCNid   = a.RCNid	
					and ej.Periodo = f.CPperiodo
					and ej.Mes     = f.CPmes
				inner join TiposNomina g
					 on g.Ecodigo = f.Ecodigo
					and g.Tcodigo = f.Tcodigo
				inner join CuentasBancos ba
					on ba.CBcc = no.CBcc
				<!---inner join CPNAPdetalle nd
					 on nd.CFcuenta = a.CFcuenta
					and nd.Ocodigo  = ba.Ocodigo
					and nd.CPNAPnum = ej.NAP--->
			where a.tiporeg in (30,31,40,41,55,56,57) 
			  and d.DCprovision = 0
			  and Coalesce(c.SNid,b.SNid) = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.SNid#">
			  and f.CPperiodo             = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.periodo#">
			  and f.CPmes                 = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.mes#">
			  and a.tipo                  = 'D' 
			  and no.HERNestado in (4,6)
              and 0 = (select count(1) 
                            from TESsolicitudPago tes 
                            where  convert(varchar , a.RCNid) in (tes.RCNids) 
                                and tes.SNid = a.SNid 
                                and TESSPestado = 12
                             )
		   group by rtrim(g.Tcodigo) , g.Tdescripcion, a.Ocodigo, d.DCcodigo,d.DCdescripcion, a.CFcuenta, a.tipo, mo.Miso4217
	</cfquery>
	<cfreturn RsGastoPatronal>
</cffunction>