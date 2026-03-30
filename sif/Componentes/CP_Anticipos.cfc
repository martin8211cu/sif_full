<cfcomponent>
	<!---Agrega un Nuevo Anticipo al Pago de CxP--->
	<cffunction name="CP_AltaAnticipo"  access="public" returntype="numeric">
		<cfargument name="Conexion" 	    type="string"  required="no">
		<cfargument name="IDpago"       	type="numeric" required="yes">
		<cfargument name="id_direccion"     type="numeric" required="yes">
		<cfargument name="NC_CPTcodigo"     type="string"  required="yes">
		<cfargument name="NC_Ddocumento"    type="string"  required="yes">
		<cfargument name="NC_Ccuenta"       type="numeric" required="yes">
		<cfargument name="NC_fecha"         type="date"    required="no">
		<cfargument name="NC_total"         type="numeric" required="no">
		<cfargument name="NC_RPTCietu"      type="numeric" required="no">
		<cfargument name="NC_RPTCid"        type="numeric" required="no">
		<cfargument name="BMUsucodigo"      type="numeric" required="no">

		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.BMUsucodigo')>
			<cfset Arguments.BMUsucodigo = session.Usucodigo>
		</cfif>
		<cfif not isdefined('Arguments.id_direccion') or not len(trim(Arguments.id_direccion))>
			<cfset Arguments.id_direccion = 'null'>
		</cfif>
		<cfif not isdefined('Arguments.NC_RPTCid')>
			<cfset Arguments.NC_RPTCid = 'null'>
		</cfif>
		<cfif not isdefined('Arguments.NC_fecha')>
			<cfquery name="Pago" datasource="#Arguments.Conexion#">
				select EPfecha from EPagosCxP where IDpago = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.IDpago#">
			</cfquery>
			<cfset Arguments.NC_fecha = Pago.EPfecha>
		</cfif>
			<cfquery name="NC_linea" datasource="#Arguments.Conexion#">
				select coalesce(max(NC_linea),0)+1 as newline from APagosCxP where IDpago = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.IDpago#">
			</cfquery>
		<cfquery name="ExisteAnticipo" datasource="#Arguments.Conexion#">
			select NC_CPTcodigo, NC_Ddocumento 
				from APagosCxP 
			where IDpago        = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.IDpago#">
			  and NC_CPTcodigo  = <cf_jdbcquery_param cfsqltype="cf_sql_char" 	 value="#Arguments.NC_CPTcodigo#">
			  and NC_Ddocumento = <cf_jdbcquery_param cfsqltype="cf_sql_char" 	 value="#Arguments.NC_Ddocumento#">
		</cfquery>
		<cfif ExisteAnticipo.recordcount GT 0>
			<cfthrow message="El Anticipo #ExisteAnticipo.NC_CPTcodigo# - #ExisteAnticipo.NC_Ddocumento# ya existe dentro del Pago">
		</cfif>
		<cfquery name="updAnticipo" datasource="#Arguments.Conexion#">
			insert into APagosCxP (IDpago,NC_linea,id_direccion,NC_CPTcodigo,NC_Ddocumento,NC_Ccuenta,NC_fecha,NC_total,<cfif isdefined('NC_RPTCietu')>NC_RPTCietu,</cfif>NC_RPTCid,BMUsucodigo)
			  values(
			    <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.IDpago#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#NC_linea.newline#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.id_direccion#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.NC_CPTcodigo#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.NC_Ddocumento#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.NC_Ccuenta#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_date" 		value="#Arguments.NC_fecha#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.NC_total#">,
				<cfif isdefined('NC_RPTCietu')>
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" 		value="#Arguments.NC_RPTCietu#">,
				</cfif>
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.NC_RPTCid#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.BMUsucodigo#">
				)
		</cfquery>
		<cfreturn NC_linea.newline>
	</cffunction>
	<!------>
	<cffunction name="CP_CambioAnticipo"  access="public">
		<cfargument name="Conexion" 	    type="string"  required="no">
		<cfargument name="IDpago"       	type="numeric" required="yes">
		<cfargument name="NC_linea"       	type="numeric" required="yes">
		<cfargument name="id_direccion"     type="numeric" required="yes">
		<cfargument name="NC_CPTcodigo"     type="string"  required="yes">
		<cfargument name="NC_Ddocumento"    type="string"  required="yes">
		<cfargument name="NC_Ccuenta"       type="numeric" required="yes">
		<cfargument name="NC_fecha"         type="date"    required="no">
		<cfargument name="NC_total"         type="numeric" required="no">
		<cfargument name="NC_RPTCietu"      type="numeric" required="yes">
		<cfargument name="NC_RPTCid"        type="numeric" required="no">
		<cfargument name="BMUsucodigo"      type="numeric" required="no">

		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.BMUsucodigo')>
			<cfset Arguments.BMUsucodigo = session.Usucodigo>
		</cfif>
		<cfif not isdefined('Arguments.id_direccion') or not len(trim(Arguments.id_direccion))>
			<cfset Arguments.id_direccion = 'null'>
		</cfif>
		<cfif not isdefined('Arguments.NC_RPTCid')>
			<cfset Arguments.NC_RPTCid = 'null'>
		</cfif>
		<cfif not isdefined('Arguments.NC_fecha')>
			<cfquery name="Pago" datasource="#Arguments.Conexion#">
				select EPfecha from EPagosCxP where IDpago = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.IDpago#">
			</cfquery>
			<cfset Arguments.NC_fecha = Pago.EPfecha>
		</cfif>
			
		<cfquery name="updAnticipo" datasource="#Arguments.Conexion#">
			update APagosCxP set 
			id_direccion 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  	value="#Arguments.id_direccion#">,
			NC_CPTcodigo 	= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	   	value="#Arguments.NC_CPTcodigo#">,
			NC_Ddocumento 	= <cf_jdbcquery_param cfsqltype="cf_sql_char"    	value="#Arguments.NC_Ddocumento#">,
			NC_Ccuenta		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.NC_Ccuenta#">,
			NC_fecha		= <cf_jdbcquery_param cfsqltype="cf_sql_date" 		value="#Arguments.NC_fecha#">,
			NC_total 		= <cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.NC_total#">,
			NC_RPTCietu 	= <cf_jdbcquery_param cfsqltype="cf_sql_integer" 	value="#Arguments.NC_RPTCietu#">,
			NC_RPTCid 		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.NC_RPTCid#">,
			BMUsucodigo 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.BMUsucodigo#">
			where IDpago 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.IDpago#">
			and NC_linea 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.NC_linea#">
		</cfquery>
	</cffunction>
	<!---Obtinen la informacion a todos los Anticipos del Pago, si se envia la linea del Anticipo se obtinen unicamente la informacion de ese Acticipo--->
	<cffunction name="CP_GetAnticipo"  access="public" returntype="query">
		<cfargument name="Conexion" 	    type="string"  required="no">
		<cfargument name="IDpago" 			type="numeric" required="yes">
		<cfargument name="NC_linea" 		type="numeric" required="no">
		<cfargument name="nameIDpago" 		type="string"  required="no" default="IDpago">
		<cfargument name="nameNC_Ddocumento"type="string"  required="no" default="NC_Ddocumento">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		
		<cfquery name="getAnticipo" datasource="#Arguments.Conexion#">
			select a.IDpago as #Arguments.nameIDpago# ,a.NC_linea,a.id_direccion,a.NC_CPTcodigo,a.NC_Ddocumento as #Arguments.nameNC_Ddocumento#,
			a.NC_Ccuenta,a.NC_fecha,a.NC_total,a.NC_RPTCietu,a.NC_RPTCid,cf.Ccuenta, rtrim(CFformato) as CFformato, CFdescripcion
				from APagosCxP a
				   left outer join CFinanciera cf
				  		on a.NC_Ccuenta = cf.Ccuenta
			   where a.IDpago = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.IDpago#">
			<cfif isdefined('Arguments.NC_linea')>
			    and a.NC_linea = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.NC_linea#">
			</cfif>
		</cfquery>
		<cfreturn getAnticipo>
	</cffunction>
	<!---Obtienen Montos Totales
		TotalAnticipos 		= Monto en Anticipos
		TotalCubierto		= Monto cubierto por Facturas
		DisponibleActicipos	= Monto del Pago - Monto en Anticipos-Monto cubierto por Facturas
	--->
	<cffunction name="CP_GetAnticipoTotales"  access="public" returntype="query">
		<cfargument name="Conexion" 	    type="string"  required="no">
		<cfargument name="IDpago" 			type="numeric" required="yes">
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		
		<cfquery name="getAnticipoTotales" datasource="#Arguments.Conexion#">
			select (select coalesce(sum(a.NC_total),0.00) from APagosCxP a where a.IDpago = p.IDpago) TotalAnticipos,
				   (select coalesce(sum(DPtotal), 0.00)   from DPagosCxP b where b.IDpago = p.IDpago) TotalCubierto,
			       round(p.EPtotal - 
				   (select coalesce(sum(a.NC_total),0.00) from APagosCxP a where a.IDpago = p.IDpago)-
				   (select coalesce(sum(b.DPtotal), 0.00) from DPagosCxP b where b.IDpago = p.IDpago),2) DisponibleAnticipos
			 from EPagosCxP p
			 where p.IDpago = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.IDpago#">
		</cfquery>
		<cfreturn getAnticipoTotales>
	</cffunction>
	<!---Obtinene información referente a las direcciones del socio de Negocio del Pago--->
	<cffunction name="CP_GetAnticipoDirecciones"  access="public" returntype="query">
		<cfargument name="Conexion" 	    type="string"  required="no">
		<cfargument name="Ecodigo" 	        type="string"  required="no">
		<cfargument name="IDpago" 			type="numeric" required="yes">
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		
		<cfquery name="GetAnticipoDirecciones" datasource="#Arguments.Conexion#">
			select b.id_direccion, <cf_dbfunction name="concat"	args="c.direccion1,' / ', c.direccion2"> as texto_direccion
					,case when b.SNDCFcuentaProveedor is null
				then
					(
						select min(rtrim(CFformato))
						  from CFinanciera
						 where Ccuenta = a.SNcuentacxp
					)
				else
					(
						select rtrim(CFformato)
						from CFinanciera
						where CFcuenta = b.SNDCFcuentaProveedor
					)
				end
			as CFformato
			, case when b.SNDCFcuentaProveedor is null
				then
					(
						select min(CFdescripcion)
						  from CFinanciera
						 where Ccuenta = a.SNcuentacxp
					)
				else
					(
						select CFdescripcion
						from CFinanciera
						where CFcuenta = b.SNDCFcuentaProveedor
					)
				end
			as CFdescripcion
			, case when b.SNDCFcuentaProveedor is null
				then
					a.SNcuentacxp
				else
					b.SNDCFcuentaProveedor
				end 
			as Ccuenta

		from SNegocios a
			inner join SNDirecciones b
				on a.SNid = b.SNid
			inner join DireccionesSIF c
				on c.id_direccion = b.id_direccion
		where a.Ecodigo =  #Arguments.Ecodigo#  
		  and a.SNcodigo = (select SNcodigo from EPagosCxP where IDpago = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.IDpago#">)
	      and b.SNDfacturacion = 1
		</cfquery>
		<cfreturn GetAnticipoDirecciones>
	</cffunction>
	<!---Obtienen el Encabezado del Anticipo--->
	<cffunction name="CP_GetAnticipoEncabezado"  access="public" returntype="query">
		<cfargument name="Conexion" 	    type="string"  required="no">
		<cfargument name="Ecodigo" 	        type="string"  required="no">
		<cfargument name="IDpago" 			type="numeric" required="yes">
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		
		<cfquery name="getAnticipoEncabezado" datasource="#Arguments.Conexion#">
		select a.CPTcodigo, a.EPdocumento, a.EPtipocambio, a.EPselect, a.EPtotal, a.EPtipopago, a.EPbeneficiario, a.Ocodigo, a.SNcodigo, a.IDpago,
			<cf_dbfunction name="to_char"		args="a.Mcodigo"> as Mcodigo, 
			<cf_dbfunction name="to_char"		args="a.Ccuenta"> as Ccuenta, 
			<cf_dbfunction name="to_char"		args="a.CBid"> 	  as CBid,
			<cf_dbfunction name="to_char"		args="a.BTid"> 	  as BTid,
			<cf_dbfunction name="to_sdateDMY"	args="a.EPfecha"> as EPfecha,
	        a.ts_rversion,e.SNid ,e.SNnumero, d.CPTdescripcion, e.SNnombre
			from EPagosCxP a, CuentasBancos b, CContables c, CPTransacciones d, SNegocios e
			 where a.IDpago = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.IDpago#">
               and b.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">	
			   and a.Ecodigo =  #Arguments.Ecodigo#  
			   and a.CBid = b.CBid
			   and b.Ccuenta = c.Ccuenta
			   and b.Ecodigo = c.Ecodigo
			   and a.Ecodigo = d.Ecodigo
			   and a.CPTcodigo = d.CPTcodigo
			   and d.CPTtipo = 'D'
			   and coalesce(d.CPTpago,0) = 1
			   and a.Ecodigo = e.Ecodigo
			   and a.SNcodigo = e.SNcodigo
		</cfquery>
		<cfreturn getAnticipoEncabezado>
	</cffunction>
	<!---Eliminacion de un Anticip del pago--->
	<cffunction name="CP_BajaAnticipo"  access="public">
		<cfargument name="Conexion" 	    type="string"  required="no">
		<cfargument name="IDpago" 			type="any" required="yes">
		<cfargument name="NC_linea" 		type="numeric" required="no">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		
		<cfquery name="BajaAnticipo" datasource="#Arguments.Conexion#">
			delete from APagosCxP
			   where IDpago = #Arguments.IDpago#
			<cfif isdefined('Arguments.NC_linea')>
			    and NC_linea = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.NC_linea#">
			</cfif>
		</cfquery>
	</cffunction>
</cfcomponent>