<cfif isdefined("form.Activar")>

	<!--- Validar que todas los logines tengan un sobre asignado --->
	<cfquery name="chkLogines" datasource="#Session.DSN#">
		select count(1) as cantidad
		from ISBproducto a
			inner join ISBlogin b
				on b.Contratoid = a.Contratoid
				and b.Snumero is null
		where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
		and a.CTcondicion = 'C'
	</cfquery>
	<cfif chkLogines.cantidad GT 0>
		<cfthrow message="ERROR: Todos los logines deben tener un sobre asignado.">
	</cfif>

	<!--- Chequear si los sobres asignados son los correctos --->


	<!--- Validar que la cantidad de servicios asignados a cada producto sea la correcta --->
	<cfquery name="chkServicios" datasource="#Session.DSN#">
		select x.TScodigo,
			x.TSnombre,
			coalesce((
				select count(1)
				from ISBproducto a
				inner join ISBlogin b
					on b.Contratoid = a.Contratoid
				inner join ISBserviciosLogin c
					on c.LGnumero = b.LGnumero
					and c.PQcodigo = a.PQcodigo
					and c.TScodigo = x.TScodigo
					and c.Habilitado = 1
				inner join ISBservicio e
					on e.PQcodigo = c.PQcodigo
					and e.TScodigo = c.TScodigo
					and e.Habilitado = 1
				where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
				and a.CTcondicion = 'C'
			), 0) as ServActivos, 
			coalesce((
				select sum(b.SVcantidad) 
				from ISBproducto a
				inner join ISBservicio b
					on b.PQcodigo = a.PQcodigo
					and b.TScodigo=x.TScodigo
					and b.Habilitado = 1
				where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
				and a.CTcondicion = 'C'
			), 0) as ServPermitidos
		from ISBservicioTipo x
		where x.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	<cfloop query="chkServicios">
		<cfif chkServicios.ServActivos GT chkServicios.ServPermitidos>
			<cfthrow message="ERROR: Se asignó una cantidad mayor a la permitida en la configuración del servicio de #chkServicios.TSnombre#.">
		</cfif>
	</cfloop>
	<cftransaction>

		<cfquery name="rsStatusCuenta" datasource="#Session.DSN#">
			select a.Habilitado
			from ISBcuenta a
			where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
		</cfquery>
		
		<!--- Verificar que el monto de la garantia sea el correcto --->

		<!--- Activar la cuenta si no esta activa --->
		<cfif rsStatusCuenta.Habilitado EQ 0>

			<!--- Activar Cuenta de Acceso --->
			<cfinvoke component="saci.comp.ISBcuenta" method="Activacion">
				<cfinvokeargument name="CTid" value="#form.CTid#">
				<cfinvokeargument name="CTapertura" value="#Now()#">
			</cfinvoke>

			<!--- Averiguar también la cuenta de facturación --->
			<cfquery name="rsDatosAgente" datasource="#Session.DSN#">
				select a.CTidFactura
				from ISBagente a
				where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Pquien#">
				and a.CTidAcceso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
			</cfquery>
			
			<cfif rsDatosAgente.recordCount GT 0>
				<cfquery name="rsStatusCuenta2" datasource="#Session.DSN#">
					select a.Habilitado
					from ISBcuenta a
					where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosAgente.CTidFactura#">
				</cfquery>
				<cfif rsStatusCuenta2.Habilitado EQ 0>
					<!--- Activar Cuenta de Facturacion --->
					<cfinvoke component="saci.comp.ISBcuenta" method="Activacion">
						<cfinvokeargument name="CTid" value="#rsDatosAgente.CTidFactura#">
						<cfinvokeargument name="CTapertura" value="#Now()#">
					</cfinvoke>
				</cfif>
			</cfif>

		</cfif>
		
		<!--- Activación de los logines y sobres --->
		<cfquery name="rsSobres" datasource="#Session.DSN#">
			select a.Contratoid, b.LGnumero, b.Snumero
			from ISBproducto a
				inner join ISBlogin b
					on b.Contratoid = a.Contratoid
			where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
			and a.CTcondicion = 'C'
		</cfquery>

		<!--- Activar los productos (Poner en condición 0) --->
		<cfquery name="rsProductos" dbtype="query">
			select distinct Contratoid
			from rsSobres
		</cfquery>
		<cfloop query="rsProductos">
			<cfinvoke component="saci.comp.ISBproducto" method="Activacion">
				<cfinvokeargument name="Contratoid" value="#rsProductos.Contratoid#">
			</cfinvoke>
		</cfloop>

		<cfloop query="rsSobres">

			<!--- Activar el login --->
			<cfinvoke component="saci.comp.ISBlogin" method="Activacion">
				<cfinvokeargument name="LGnumero" value="#rsSobres.LGnumero#">
			</cfinvoke>
			
			<!--- Activar el sobre --->
			<cfinvoke component="saci.comp.ISBsobres" method="Activacion" returnvariable="LvarError">
				<cfinvokeargument name="Snumero" value="#rsSobres.Snumero#">
			</cfinvoke>
			<cfif LvarError NEQ 0>
				<cfthrow message="ERROR: El sobre con número #rsSobres.Snumero# ya fue activado o no tiene un login asignado.">
			</cfif>

		</cfloop>
		<cfset ExtraParams = "Activado=1">
	</cftransaction>
	
	<!--- activar la cuenta en los sistemas externos (SIIC) --->
	<cfquery dbtype="query" name="por_activar">
		select distinct Contratoid from rsSobres
	</cfquery>
	<cfloop query="por_activar">
		<cfinvoke component="saci.ws.intf.H001_crearLoginSIIC" method="activar_cuenta"
			CTid="#Form.CTid#" Contratoid="#por_activar.Contratoid#" />
	</cfloop>

</cfif>
