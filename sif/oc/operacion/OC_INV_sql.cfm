<cfset LvarOCItipoOD = form.OCItipoOD>
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cftransaction>			
			<cfquery name="rsOCInumero" datasource="#session.DSN#">
				select 
					coalesce(max(OCInumero),0) +1 as OCInumero
				from OCinventario
				where Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and OCItipoOD = <cfqueryparam cfsqltype="cf_sql_char" value="#form.OCItipoOD#">
			</cfquery>
			<cfset form.OCInumero = rsOCInumero.OCInumero>
			<cfquery name="inserta" datasource="#session.DSN#">
				insert into OCinventario 
					(
						Ecodigo, 
						 OCItipoOD, 
						 OCInumero, 
						 OCIfecha, 
						 Alm_Aid, 
						 OCIobservaciones,
						 OCid, 
						 BMUsucodigo
					)
				values (
						<cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.Ecodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_char" 		value="#form.OCItipoOD#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.OCInumero#">, 
						<cfqueryparam cfsqltype="cf_sql_date" 		value="#form.OCIfecha#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric"	value="#form.Alm_Aid#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.OCIobservaciones#">, 
						<cfparam name="form.OCid" default="">
						<cfqueryparam cfsqltype="cf_sql_numeric"	value="#form.OCid#" null="#form.OCid EQ ''#">,
						<cfqueryparam cfsqltype="cf_sql_numeric"	value="#session.Usucodigo#">
					)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>	
			<cf_dbidentity2 datasource="#session.DSN#" name="inserta">
			<cfset form.OCIid = inserta.identity >
			<cfif LvarOCItipoOD EQ "O">
				<cfquery name="rsSQL" datasource="#session.DSN#">
					select count(1) as cantidad
					  from OCordenProducto op
					  	inner join OCtransporteProducto tp
							on tp.OCid = op.OCid
							and tp.Aid = op.Aid
					 where op.OCid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.OCid#">
				</cfquery>	
				<cfif rsSQL.cantidad EQ 0>
					<cf_errorCode	code = "50444" msg = "No se han definido Transportes con la Orden Comercial Origen">
				</cfif>
			</cfif>			
		</cftransaction>
		<cflocation url="OC_INV_#LvarOCItipoOD#I.cfm?OCIid=#URLEncodedFormat(form.OCIid)#">
	<cfelseif isdefined("Form.Baja")>
		<cfquery datasource="#session.DSN#">
			delete from OCinventarioProducto
			where OCIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.OCIid#">
		</cfquery>

		<cfquery datasource="#session.DSN#">
			delete from OCinventario
			where OCIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.OCIid#">
		</cfquery>
		<cflocation url="OC_INV_#LvarOCItipoOD#I.cfm">
	<cfelseif isdefined("Form.Cambio")>
		<cfquery datasource="#session.DSN#">
			update OCinventario
			set 
				OCItipoOD			= <cfqueryparam cfsqltype="cf_sql_char" value="#form.OCItipoOD#">,
				OCInumero			= <cfqueryparam cfsqltype="cf_sql_integer" value="#OCInumero#">,
				OCIfecha 			= <cfqueryparam cfsqltype="cf_sql_date" value="#form.OCIfecha#">,
				Alm_Aid 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Alm_Aid#">,
				OCIobservaciones	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCIobservaciones#">,
				BMUsucodigo 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			where OCIid 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCIid#">
		</cfquery>	  
		<cflocation url="OC_INV_#LvarOCItipoOD#I.cfm?OCIid=#URLEncodedFormat(form.OCIid)#">
	<cfelseif isdefined("Form.AgregarSinSalidas")>
		<cfquery name="inserta" datasource="#session.DSN#">
			insert into OCinventarioProducto 
				(
					OCIid, 
					OCTid, 
					Aid, 
					OCIcantidad, 
					OCIcostoValuacion, 
					BMUsucodigo
				)
			select
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCIid#">, 
					OCTid, 
					Aid,
					OCPTentradasCantidad,
					0,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			  from OCproductoTransito pt
			 where OCTid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTid#">
			   and OCPTsalidasCantidad = 0
			   and OCPTentradasCantidad >0
			   and not exists 
			   		(
						select 1 from OCinventarioProducto 
						 where OCTid = pt.OCTid
						   and Aid 	 = pt.Aid
					)
		</cfquery>
		<cflocation url="OC_INV_#LvarOCItipoOD#I.cfm?OCIid=#URLEncodedFormat(form.OCIid)#&OCTid=#form.OCTid#&Aid=#form.Aid#">
	<cfelseif isdefined("Form.AgregarExistentes")>
		<cfquery name="inserta" datasource="#session.DSN#">
			insert into OCinventarioProducto 
				(
					OCIid, 
					OCTid, 
					Aid, 
					OCIcantidad, 
					OCIcostoValuacion, 
					BMUsucodigo
				)
			select
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCIid#">, 
					OCTid, 
					Aid,
					OCPTentradasCantidad + OCPTsalidasCantidad,
					0,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			  from OCproductoTransito pt
			 where OCTid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTid#">
			   and OCPTentradasCantidad + OCPTsalidasCantidad >0
			   and not exists 
			   		(
						select 1 from OCinventarioProducto 
						 where OCTid = pt.OCTid
						   and Aid 	 = pt.Aid
					)
		</cfquery>
		<cflocation url="OC_INV_#LvarOCItipoOD#I.cfm?OCIid=#URLEncodedFormat(form.OCIid)#&OCTid=#form.OCTid#&Aid=#form.Aid#">
	<cfelseif isdefined("Form.AltaDet")>
	
		<cfquery name="inserta" datasource="#session.DSN#">
			insert into OCinventarioProducto 
				(
					OCIid, 
					OCTid, 
					Aid, 
					OCIcantidad, 
					OCIcostoValuacion, 
					BMUsucodigo
				)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCIid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">,
					<cfqueryparam cfsqltype="cf_sql_money" 	 value="#fnQuitarComas(form.OCIcantidad)#">,
					0,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
						)
		</cfquery>	
		<cflocation url="OC_INV_#LvarOCItipoOD#I.cfm?OCIid=#URLEncodedFormat(form.OCIid)#&OCTid=#form.OCTid#&Aid=#form.Aid#">
	<cfelseif isdefined("Form.BajaDet")>
		<cfquery datasource="#session.DSN#">
			delete from OCinventarioProducto
			where OCIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.OCIid#">
			  and OCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTid#">
			  and Aid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
		</cfquery>
		<cflocation url="OC_INV_#LvarOCItipoOD#I.cfm?OCIid=#URLEncodedFormat(form.OCIid)#">
	<cfelseif isdefined("Form.CambioDet")>
		<!--- Actualiza el encabezado y el detalle --->
		<cfquery datasource="#session.DSN#">
			update OCinventario
			set 
				OCIfecha 			= <cfqueryparam cfsqltype="cf_sql_date" value="#form.OCIfecha#">,
				Alm_Aid 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Alm_Aid#">,
				OCIobservaciones	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCIobservaciones#">,
				BMUsucodigo 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			where OCIid 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCIid#">
		</cfquery>
		<cfquery datasource="#session.DSN#">
			update OCinventarioProducto
			set 
				OCIcantidad 	  = <cfqueryparam cfsqltype="cf_sql_money" value="#fnQuitarComas(form.OCIcantidad)#">
				,OCIcostoValuacion = 0
			where OCIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.OCIid#">
			  and OCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTid#">
			  and Aid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
		</cfquery>	  
		<cflocation url="OC_INV_#LvarOCItipoOD#I.cfm?OCIid=#URLEncodedFormat(form.OCIid)#&OCTid=#form.OCTid#&Aid=#form.Aid#">
	<cfelseif isdefined("Form.NuevoDet")>
		<cflocation url="OC_INV_#LvarOCItipoOD#I.cfm?OCIid=#URLEncodedFormat(form.OCIid)#">
	<cfelseif isdefined("form.BtnAplicar") or isdefined("form.BtnVer_Aplicacion") or isdefined("form.Aplicar") or isdefined("form.Ver_Aplicacion")>
		<cfparam name="form.chk" default="">
		<cfif form.chk EQ "" and isdefined("form.OCIid")>
			<cfset form.chk = form.OCIid>
		</cfif>
		<cfif LvarOCItipoOD EQ "D">
			<cfset LvarMetodo = "OC_Aplica_OCDI">
		<cfelse>
			<cfset LvarMetodo = "OC_Aplica_OCOI">
		</cfif>
		<!--- Hay que hacer un loop con los Id's de los cheks de la lista --->
		<cfloop list="#form.chk#" index="LvarChk">
			<cfinvoke component="sif.oc.Componentes.OC_transito" 
					method="#LvarMetodo#"

					Ecodigo = "#Session.Ecodigo#"
					OCIid	= "#listGetAt(LvarChk,1,"|")#"
					Conexion = "#session.DSN#"
					VerAsiento = "#isdefined("form.BtnVer_Aplicacion")#"
					debug 	= "false"
				/>
		</cfloop>
		<cflocation url="OC_INV_#LvarOCItipoOD#I.cfm">
	</cfif>
<cfelse>
	<cflocation url="OC_INV_#LvarOCItipoOD#I.cfm?btnNuevo">	
</cfif>
	
<cffunction name="fnQuitarComas" returntype="string" output="false">
	<cfargument name="numero" type="string" required="yes">
	
	<cfreturn replace(Arguments.numero,",","","ALL")>
</cffunction>


