<cfcomponent>
	<!---Agrega un Nuevo Anticipo al Cobro de CxC--->
	<cffunction name="CC_AltaAnticipo"  access="public" returntype="numeric">
		<cfargument name="Conexion" 	    type="string"  required="no">
		<cfargument name="CCTcodigo"       	type="string"  required="yes">
		<cfargument name="Pcodigo"       	type="string"  required="yes">
		<cfargument name="id_direccion"     type="numeric" required="yes">
		<cfargument name="NC_CCTcodigo"     type="string"  required="yes">
		<cfargument name="NC_Ddocumento"    type="string"  required="yes">
		<cfargument name="NC_Ccuenta"       type="numeric" required="yes">
		<cfargument name="NC_fecha"         type="date"    required="no">
		<cfargument name="NC_total"         type="numeric" required="no">
		<cfargument name="NC_RPTCietu"      type="numeric" required="no">
		<cfargument name="NC_RPTCid"        type="numeric" required="no">
		<cfargument name="BMUsucodigo"      type="numeric" required="no">
		<cfargument name="Ecodigo"       	type="numeric" required="no">
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
		<cfif not isdefined('Arguments.NC_fecha') OR NOT LEN(TRIM(Arguments.NC_fecha))>
			<cfquery name="Pago" datasource="#Arguments.Conexion#">
				select Pfecha 
					from Pagos 
				 where Ecodigo 	 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
			     and rtrim(CCTcodigo) = <cfqueryparam cfsqltype="cf_sql_char" 	 value="#trim(Arguments.CCTcodigo)#"> 
			     and rtrim(Pcodigo)   = <cfqueryparam cfsqltype="cf_sql_char" 	 value="#trim(Arguments.Pcodigo)#"> 
			</cfquery>
			<cfset Arguments.NC_fecha = Pago.Pfecha>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
			<cfquery name="NC_linea" datasource="#Arguments.Conexion#">
				select coalesce(max(NC_linea),0)+1 as newline 
					from APagosCxC  
					where Ecodigo 	 	 = <cfqueryparam cfsqltype="cf_sql_integer"  value="#Arguments.Ecodigo#"> 
			    	and rtrim(CCTcodigo) = <cfqueryparam cfsqltype="cf_sql_char" 	 value="#trim(Arguments.CCTcodigo)#"> 
			    	and rtrim(Pcodigo) 	 = <cfqueryparam cfsqltype="cf_sql_char" 	 value="#trim(Arguments.Pcodigo)#"> 
			</cfquery>
		<cfquery name="updAnticipo" datasource="#Arguments.Conexion#">
			insert into APagosCxC (Ecodigo,CCTcodigo,Pcodigo,NC_linea,id_direccion,NC_CCTcodigo,NC_Ddocumento,NC_Ccuenta,NC_fecha,NC_total,<cfif isdefined('NC_RPTCietu')>NC_RPTCietu,</cfif>NC_RPTCid,BMUsucodigo)
			  values(
			    <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.Ecodigo#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.CCTcodigo#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.Pcodigo#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#NC_linea.newline#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.id_direccion#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.NC_CCTcodigo#">,
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
	<cffunction name="CC_CambioAnticipo"  access="public">
		<cfargument name="Conexion" 	    type="string"  required="no">
		<cfargument name="Ecodigo"       	type="numeric" required="no">
		<cfargument name="CCTcodigo"       	type="string"  required="yes">
		<cfargument name="Pcodigo"       	type="string"  required="yes">
		<cfargument name="NC_linea"       	type="numeric" required="yes">
		<cfargument name="id_direccion"     type="numeric" required="yes">
		<cfargument name="NC_CCTcodigo"     type="string"  required="yes">
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
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
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
				select Pfecha 
					from Pagos 
				where Ecodigo 	 	   = <cfqueryparam cfsqltype="cf_sql_integer"  value="#Arguments.Ecodigo#"> 
			      and rtrim(CCTcodigo) = <cfqueryparam cfsqltype="cf_sql_char" 	   value="#trim(Arguments.CCTcodigo)#"> 
			      and rtrim(Pcodigo)   = <cfqueryparam cfsqltype="cf_sql_char" 	   value="#trim(Arguments.Pcodigo)#"> 
			</cfquery>
			<cfset Arguments.NC_fecha = Pago.Pfecha>
		</cfif>
			
		<cfquery name="updAnticipo" datasource="#Arguments.Conexion#">
			update APagosCxC set 
			id_direccion 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  	value="#Arguments.id_direccion#">,
			NC_CCTcodigo 	= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	   	value="#Arguments.NC_CCTcodigo#">,
			NC_Ddocumento 	= <cf_jdbcquery_param cfsqltype="cf_sql_char"    	value="#Arguments.NC_Ddocumento#">,
			NC_Ccuenta		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.NC_Ccuenta#">,
			NC_fecha		= <cf_jdbcquery_param cfsqltype="cf_sql_date" 		value="#Arguments.NC_fecha#">,
			NC_total 		= <cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.NC_total#">,
			NC_RPTCietu 	= <cf_jdbcquery_param cfsqltype="cf_sql_integer" 	value="#Arguments.NC_RPTCietu#">,
			NC_RPTCid 		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.NC_RPTCid#">,
			BMUsucodigo 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.BMUsucodigo#">
			   where Ecodigo 	     = <cfqueryparam cfsqltype="cf_sql_integer"  		value="#Arguments.Ecodigo#"> 
			    and rtrim(CCTcodigo) = <cfqueryparam cfsqltype="cf_sql_char" 	   		value="#trim(Arguments.CCTcodigo)#"> 
			    and rtrim(Pcodigo)   = <cfqueryparam cfsqltype="cf_sql_char" 	   		value="#trim(Arguments.Pcodigo)#"> 
			    and NC_linea 	     = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.NC_linea#">
		</cfquery>
	</cffunction>
	<!---Obtinen la informacion a todos los Anticipos del Pago, si se envia la linea del Anticipo se obtinen unicamente la informacion de ese Acticipo--->
	<cffunction name="CC_GetAnticipo"  access="public" returntype="query">
		<cfargument name="Conexion" 	    type="string"  required="no">
		<cfargument name="Ecodigo" 	        type="string"  required="no">
		<cfargument name="CCTcodigo" 		type="string"  required="yes">
		<cfargument name="Pcodigo" 			type="string"  required="yes">
		<cfargument name="NC_linea" 		type="string"  required="no">
		<cfargument name="CCTcodigoName" 	type="string"  required="no" default="CCTcodigo">
		<cfargument name="PcodigoName" 		type="string"  required="no" default="Pcodigo">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		
		<cfquery name="getAnticipo" datasource="#Arguments.Conexion#">
			select a.Ecodigo, a.CCTcodigo #Arguments.CCTcodigoName#,a.Pcodigo #Arguments.PcodigoName#,a.NC_linea,a.id_direccion,a.NC_CCTcodigo,a.NC_Ddocumento,
			a.NC_Ccuenta,a.NC_fecha,a.NC_total,a.NC_RPTCietu,a.NC_RPTCid,cf.Ccuenta, rtrim(CFformato) as CFformato, CFdescripcion
				from APagosCxC a
				   left outer join CFinanciera cf
				  		on a.NC_Ccuenta = cf.Ccuenta
			   where a.Ecodigo 		 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
			    and rtrim(a.CCTcodigo) 	  = <cfqueryparam cfsqltype="cf_sql_char" 	 value="#trim(Arguments.CCTcodigo)#"> 
			    and rtrim(a.Pcodigo) 	  = <cfqueryparam cfsqltype="cf_sql_char" 	 value="#trim(Arguments.Pcodigo)#"> 
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
	<cffunction name="CC_GetAnticipoTotales"  access="public" returntype="query">
		<cfargument name="Conexion" 	    type="string"  required="no">
		<cfargument name="Ecodigo" 	        type="string"  required="no">
		<cfargument name="CCTcodigo" 		type="string"  required="yes">
		<cfargument name="Pcodigo" 			type="string"  required="yes">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		
		<cfquery name="getAnticipoTotales" datasource="#Arguments.Conexion#">
			select (select coalesce(sum(a.NC_total),0.00) from APagosCxC a where a.Ecodigo = p.Ecodigo and a.CCTcodigo = p.CCTcodigo and a.Pcodigo = p.Pcodigo) TotalAnticipos,
				   (select coalesce(sum(a.DPtotal), 0.00) from DPagos a    where a.Ecodigo = p.Ecodigo and a.CCTcodigo = p.CCTcodigo and a.Pcodigo = p.Pcodigo) TotalCubierto,
			       round(p.Ptotal - 
				   (select coalesce(sum(a.NC_total),0.00) from APagosCxC a where a.Ecodigo = p.Ecodigo and a.CCTcodigo = p.CCTcodigo and a.Pcodigo = p.Pcodigo)-
				   (select coalesce(sum(a.DPtotal), 0.00) from DPagos a    where a.Ecodigo = p.Ecodigo and a.CCTcodigo = p.CCTcodigo and a.Pcodigo = p.Pcodigo),2) DisponibleAnticipos
			 from Pagos p
			 where p.Ecodigo 		 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
			   and rtrim(p.CCTcodigo) 	  = <cfqueryparam cfsqltype="cf_sql_char" 	 value="#trim(Arguments.CCTcodigo)#"> 
			   and rtrim(p.Pcodigo) 	  = <cfqueryparam cfsqltype="cf_sql_char" 	 value="#trim(Arguments.Pcodigo)#"> 
		</cfquery>
		<cfreturn getAnticipoTotales>
	</cffunction>
	<!---Obtinene información referente a las direcciones del socio de Negocio del Pago--->
	<cffunction name="CC_GetAnticipoDirecciones"  access="public" returntype="query">
		<cfargument name="Conexion" 	    type="string"  required="no">
		<cfargument name="Ecodigo" 	        type="string"  required="no">
		<cfargument name="CCTcodigo" 		type="string"  required="yes">
		<cfargument name="Pcodigo" 			type="string"  required="yes">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		
		<cfquery name="GetAnticipoDirecciones" datasource="#Arguments.Conexion#">
			select b.id_direccion, <cf_dbfunction name="concat" args="c.direccion1,'/',c.direccion2"> as texto_direccion
			,case when b.SNDCFcuentaCliente is null
				then
					(
						select min(rtrim(CFformato))
						  from CFinanciera
						 where Ccuenta = a.SNcuentacxc
					)
				else
					(
						select rtrim(CFformato)
						from CFinanciera
						where CFcuenta = b.SNDCFcuentaCliente
					)
				end
			as CFformato
			, case when b.SNDCFcuentaCliente is null
				then
					(
						select CFdescripcion
						  from CFinanciera
						 where Ccuenta = a.SNcuentacxc
					)
				else
					(
						select CFdescripcion
						from CFinanciera
						where CFcuenta = b.SNDCFcuentaCliente
					)
				end
			as CFdescripcion
			, case when b.SNDCFcuentaCliente is null
				then
					a.SNcuentacxc
				else
					b.SNDCFcuentaCliente
				end 
			as Ccuenta

		from SNegocios a
			join SNDirecciones b
				on a.SNid = b.SNid
			join DireccionesSIF c
				on c.id_direccion = b.id_direccion
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
		  and a.SNcodigo = (select SNcodigo 
		  						from Pagos 
							where Ecodigo        = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
			   				and rtrim(CCTcodigo) = <cfqueryparam cfsqltype="cf_sql_char" 	value="#trim(Arguments.CCTcodigo)#"> 
			   				and rtrim(Pcodigo)   = <cfqueryparam cfsqltype="cf_sql_char" 	value="#trim(Arguments.Pcodigo)#"> )
		</cfquery>
		<cfreturn GetAnticipoDirecciones>
	</cffunction>
	<!---Obtienen el Encabezado del Anticipo--->
	<cffunction name="CC_GetAnticipoEncabezado"  access="public" returntype="query">
		<cfargument name="Conexion" 	    type="string"  required="no">
		<cfargument name="Ecodigo" 	        type="string"  required="no">
		<cfargument name="CCTcodigo" 		type="string"  required="yes">
		<cfargument name="Pcodigo" 			type="string"  required="yes">
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		
		<cfquery name="getAnticipoEncabezado" datasource="#Arguments.Conexion#">
		select 	a.CCTcodigo, 
				rtrim(a.Pcodigo) as Pcodigo, 
				a.Mcodigo, 
				a.Ptipocambio, a.Seleccionado, 
				a.Ccuenta as Ccuenta, 
				a.Ptotal,
				<cf_dbfunction name="to_sdateDMY"	args="a.Pfecha"> as Pfecha, 
				a.Pfecha as DatePfecha, 
				a.Preferencia, a.Pobservaciones, 
				<cf_dbfunction name="concat" args="rtrim(a.CCTcodigo),'|',rtrim(a.Pcodigo)"> as IDPago, 
				a.Ocodigo, a.SNcodigo,
				e.SNid,
				a.ts_rversion, 
				b.Cformato, b.Cdescripcion, 
				d.CCTdescripcion, e.SNnombre, e.SNnumero
		   from Pagos a, CContables b, CCTransacciones d, SNegocios e
		  where rtrim(a.CCTcodigo) 	  = <cfqueryparam cfsqltype="cf_sql_char" 	 value="#trim(Arguments.CCTcodigo)#"> 
			and rtrim(a.Pcodigo) 	  = <cfqueryparam cfsqltype="cf_sql_char" 	 value="#trim(Arguments.Pcodigo)#"> 
			and a.Ecodigo 		 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
			and a.Ecodigo 		 	  = b.Ecodigo
			and a.Ccuenta 		 	  = b.Ccuenta
			and a.Ecodigo 		 	  = d.Ecodigo
			and a.CCTcodigo 	 	  = d.CCTcodigo
			and d.CCTtipo 		 	  = 'C'
			and coalesce(d.CCTpago,0) = 1
			and a.Ecodigo 		 	  = e.Ecodigo
			and a.SNcodigo 			  = e.SNcodigo
		</cfquery>
		<cfreturn getAnticipoEncabezado>
	</cffunction>
	<!---Eliminacion de un Anticip del pago--->
	<cffunction name="CC_BajaAnticipo"  access="public">
		<cfargument name="Conexion" 	    type="string"  	required="no">
		<cfargument name="Ecodigo" 			type="any" 		required="no" default="#session.Ecodigo#">
		<cfargument name="CCTcodigo" 		type="any" 		required="yes">
		<cfargument name="Pcodigo" 			type="any" 		required="yes">
		<cfargument name="NC_linea" 		type="numeric" 	required="no">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		
		<cfquery name="BajaAnticipo" datasource="#Arguments.Conexion#">
			delete from APagosCxC
			   where Ecodigo 		  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
			   and rtrim(CCTcodigo)   = <cfqueryparam cfsqltype="cf_sql_char" 	 value="#trim(Arguments.CCTcodigo)#"> 
			   and rtrim(Pcodigo) 	  = <cfqueryparam cfsqltype="cf_sql_char" 	 value="#trim(Arguments.Pcodigo)#"> 
			<cfif isdefined('Arguments.NC_linea')>
			    and NC_linea = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.NC_linea#">
			</cfif>
		</cfquery>
	</cffunction>
</cfcomponent>