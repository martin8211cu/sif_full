<cfset LvarOCOtipoOD = form.OCOtipoOD>
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cftransaction>			
			<cfquery name="rsOCOnumero" datasource="#session.DSN#">
				select 
					coalesce(max(OCOnumero),0) +1 as OCOnumero
				from OCotros
				where Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and OCOtipoOD = <cfqueryparam cfsqltype="cf_sql_char" value="#form.OCOtipoOD#">
			</cfquery>
			<cfset form.OCOnumero = rsOCOnumero.OCOnumero>
			<cfquery name="inserta" datasource="#session.DSN#">
				insert into OCotros 
					(
						Ecodigo, 
						OCOtipoOD, 
						OCOnumero, 
						OCOfecha, 
						OCOobservaciones,
						CFcuenta,
						SNid, Ocodigo, 
						Mcodigo,
						OCOtotalOrigen,
						OCOtipoCambio,
						BMUsucodigo
					)
				values (
						<cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.Ecodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_char" 		value="#form.OCOtipoOD#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.OCOnumero#">, 
						<cfqueryparam cfsqltype="cf_sql_date" 		value="#form.OCOfecha#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.OCOobservaciones#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric"	value="#form.CFcuenta#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric"	value="#form.SNid#">, 
						<cfqueryparam cfsqltype="cf_sql_integer"	value="#form.Ocodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric"	value="#form.Mcodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_money"		value="#fnQuitarComas(form.OCOtotalOrigen)#">,
						<cfqueryparam cfsqltype="cf_sql_float"   	value="#fnQuitarComas(form.OCOtipoCambio)#">,
						<cfqueryparam cfsqltype="cf_sql_numeric"	value="#session.Usucodigo#">
					)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>	
			<cf_dbidentity2 datasource="#session.DSN#" name="inserta">
			<cfset form.OCOid = inserta.identity >
		</cftransaction>
		<cflocation url="OC_OTROS_#LvarOCOtipoOD#O.cfm?OCOid=#URLEncodedFormat(form.OCOid)#">
	<cfelseif isdefined("Form.Baja")>
		<cfquery datasource="#session.DSN#">
			delete from OCotrosDetalle
			where OCOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.OCOid#">
		</cfquery>

		<cfquery datasource="#session.DSN#">
			delete from OCotros
			where OCOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.OCOid#">
		</cfquery>
		<cflocation url="OC_OTROS_#LvarOCOtipoOD#O.cfm">
	<cfelseif isdefined("Form.Cambio")>
		<cfquery datasource="#session.DSN#">
			update OCotros
			set 
				OCOfecha 			= <cfqueryparam cfsqltype="cf_sql_date"    value="#form.OCOfecha#">,
				OCOobservaciones	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCOobservaciones#">,
				CFcuenta			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuenta#">,
				SNid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNid#">,
				Ocodigo				= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">,
				Mcodigo				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
				OCOtotalOrigen		= <cfqueryparam cfsqltype="cf_sql_float"   value="#fnQuitarComas(form.OCOtotalOrigen)#">,
				OCOtipoCambio		= <cfqueryparam cfsqltype="cf_sql_money"   value="#fnQuitarComas(form.OCOtipoCambio)#">,
				BMUsucodigo 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			where OCOid 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCOid#">
		</cfquery>	  
		<cflocation url="OC_OTROS_#LvarOCOtipoOD#O.cfm?OCOid=#URLEncodedFormat(form.OCOid)#">
	<cfelseif isdefined("Form.AltaDet")>
	
		<cfquery name="inserta" datasource="#session.DSN#">
			insert into OCotrosDetalle 
				(
					OCOid, 
					OCTid, 
					Aid,
					OCCid_O, OCIid_D, OCid_D,
					OCODmontoOrigen, 
					BMUsucodigo
				)
			values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCOid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">,
				<cfif form.OCOtipoOD EQ "O">
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCCid_O#">, 
					null, null,
				<cfelse>
					null, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCIid_D#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCid_D#">,
				</cfif>
					<cfqueryparam cfsqltype="cf_sql_money" 	 value="#fnQuitarComas(form.OCODmontoOrigen)#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				)
		</cfquery>	
		<cflocation url="OC_OTROS_#LvarOCOtipoOD#O.cfm?OCOid=#URLEncodedFormat(form.OCOid)#&OCTid=#form.OCTid#&Aid=#form.Aid#">
	<cfelseif isdefined("Form.BajaDet")>
		<cfquery datasource="#session.DSN#">
			delete from OCotrosDetalle
			where OCOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.OCOid#">
			  and OCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTid#">
			  and Aid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
		</cfquery>
		<cflocation url="OC_OTROS_#LvarOCOtipoOD#O.cfm?OCOid=#URLEncodedFormat(form.OCOid)#">
	<cfelseif isdefined("Form.CambioDet")>
		<!--- Actualiza el encabezado y el detalle --->
		<cfquery datasource="#session.DSN#">
			update OCotros
			set 
				OCOfecha 			= <cfqueryparam cfsqltype="cf_sql_date"    value="#form.OCOfecha#">,
				OCOobservaciones	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCOobservaciones#">,
				CFcuenta			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuenta#">,
				SNid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNid#">,
				Ocodigo				= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">,
				Mcodigo				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
				OCOtotalOrigen		= <cfqueryparam cfsqltype="cf_sql_float"   value="#fnQuitarComas(form.OCOtotalOrigen)#">,
				OCOtipoCambio		= <cfqueryparam cfsqltype="cf_sql_money"   value="#fnQuitarComas(form.OCOtipoCambio)#">,
				BMUsucodigo 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			where OCOid 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCOid#">
		</cfquery>
		<cfquery datasource="#session.DSN#">
			update OCotrosDetalle
			set 
				OCODmontoOrigen 	  = <cfqueryparam cfsqltype="cf_sql_money" value="#fnQuitarComas(form.OCODmontoOrigen)#">,
			<cfif form.OCOtipoOD EQ "O">
			   	OCCid_O = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCCid_O#">
			<cfelse>
			   	OCIid_D = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCIid_D#">
			</cfif>
			where OCOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.OCOid#">
			  and OCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTid#">
			<cfif form.OCOtipoOD NEQ "O">
			  and OCid_D  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCid_D#">
			</cfif>
			  and Aid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
		</cfquery>	  
		<cflocation url="OC_OTROS_#LvarOCOtipoOD#O.cfm?OCOid=#URLEncodedFormat(form.OCOid)#&OCTid=#form.OCTid#&Aid=#form.Aid#">
	<cfelseif isdefined("Form.NuevoDet")>
		<cflocation url="OC_OTROS_#LvarOCOtipoOD#O.cfm?OCOid=#URLEncodedFormat(form.OCOid)#">
	<cfelseif isdefined("form.BtnAplicar") or isdefined("form.BtnVer_Aplicacion") or isdefined("form.Aplicar") or isdefined("form.Ver_Aplicacion")>
		<cfparam name="form.chk" default="">
		<cfif form.chk EQ "" and isdefined("form.OCOid")>
			<cfset form.chk = form.OCOid>
		</cfif>
		<cfif LvarOCOtipoOD EQ "O">
			<cfset LvarMetodo = "OC_Aplica_OCOO">
		<cfelse>
			<cfset LvarMetodo = "OC_Aplica_OCDO">
		</cfif>
		<!--- Hay que hacer un loop con los Id's de los cheks de la lista --->
		<cfloop list="#form.chk#" index="LvarChk">
			<cfinvoke component="sif.oc.Componentes.OC_transito" 
					method="#LvarMetodo#"

					Ecodigo = "#Session.Ecodigo#"
					OCOid	= "#listGetAt(LvarChk,1,"|")#"
					Conexion = "#session.DSN#"
					VerAsiento = "#isdefined("form.BtnVer_Aplicacion")#"
					debug 	= "false"
				/>
		</cfloop>
		<cflocation url="OC_OTROS_#LvarOCOtipoOD#O.cfm">
	</cfif>
<cfelse>
	<cflocation url="OC_OTROS_#LvarOCOtipoOD#O.cfm?btnNuevo">	
</cfif>
	
<cffunction name="fnQuitarComas" returntype="string" output="false">
	<cfargument name="numero" type="string" required="yes">
	
	<cfreturn replace(Arguments.numero,",","","ALL")>
</cffunction>
