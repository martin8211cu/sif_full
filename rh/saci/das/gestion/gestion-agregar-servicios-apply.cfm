<cfset Request.Error.Url = "gestion.cfm?cli=#form.cli#&ppaso=#Form.ppaso#&lpaso=#Form.lpaso#&cpaso=#Form.cpaso#&cue=#Form.cue#&pkg=#Form.pkg#">

<!--- el usuario va a usar un login ya existente--->
<cfif isdefined("form.LGnumero") and len(trim(form.LGnumero))>
	<cfquery name="rsPQ" datasource="#session.DSN#">													<!--- Toma el codigo del paquete--->
		select PQcodigo 
		from ISBproducto 
		where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pkg#">
	</cfquery>
	
	<cfquery name="rsExist" datasource="#session.DSN#">														<!--- Revisa que el login no poseea el servicio que se le desea agregar--->
		select LGnumero,TScodigo 
		from ISBserviciosLogin 
		where LGnumero  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LGnumero#">
		and  TScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TScodigo#">
		and Habilitado = 1
	</cfquery>

	<cfif rsExist.recordCount EQ 0>
	
		<cftransaction>
			
			<cfquery name="rsCorreo" datasource="#session.dsn#">							<!--- Indica si algun servicio del login es de tipo correo --->
				select count(1)as cant
				from ISBservicioTipo
				where TScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.TScodigo#">
					and TStipo='C'
			</cfquery>
			<cfif rsCorreo.cant gt 0>
				<cfquery name="rsQuota" datasource="#session.dsn#">							<!--- Toma el valor de la Quota del paquete--->
					select b.PQmailQuota as valor
					from ISBproducto a
						inner join ISBpaquete b
							on b.PQcodigo = a.PQcodigo
							and b.Habilitado=1
					where a.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.pkg#">	
				</cfquery>
				<cfif rsQuota.recordCount GT 0>
					<cfinvoke component="saci.comp.ISBlogin" method="UpdateQuota">			<!---Actualiza el valor de la Quota del login con la cuota del paquete--->
					<cfinvokeargument name="LGnumero" value="#Form.LGnumero#">
					<cfinvokeargument name="LGmailQuota" value="#rsQuota.valor#">
					</cfinvoke>
				</cfif>
			</cfif>
																							<!--- Agregar el nuevo servicio --->
			<cfinvoke component="saci.comp.ISBserviciosLogin" method="Alta">
				<cfinvokeargument name="LGnumero" value="#Form.LGnumero#">
				<cfinvokeargument name="TScodigo" value="#Form.TScodigo#">
				<cfinvokeargument name="PQcodigo" value="#rsPQ.PQcodigo#">
				<cfinvokeargument name="SLpassword" value="*">
				<cfinvokeargument name="Habilitado" value="1">
			</cfinvoke>
			<cfif isdefined("Form.LGtelefono") and Len(Trim(Form.LGtelefono))>				<!--- Asignar el telefono si viene asignado --->
				<cfinvoke component="saci.comp.ISBlogin" method="CambioTelefono">
					<cfinvokeargument name="LGnumero" value="#Form.LGnumero#">
					<cfinvokeargument name="LGtelefono" value="#Form.Snumero#">
				</cfinvoke>
			</cfif>
			<cfif isdefined("Form.Snumero") and Len(Trim(Form.Snumero))>					<!--- Asignar el sobre si viene asignado --->
				<cfinvoke component="saci.comp.ISBsobres" method="Asigna_Login">
					<cfinvokeargument name="Snumero" value="#Form.Snumero#">
					<cfinvokeargument name="LGnumero" value="#Form.LGnumero#">
				</cfinvoke>
				<cfinvoke component="saci.comp.ISBlogin" method="Asignar_Sobre">
					<cfinvokeargument name="LGnumero" value="#Form.LGnumero#">
					<cfinvokeargument name="Snumero" value="#Form.Snumero#">
				</cfinvoke>
				<cfinvoke component="saci.comp.ISBsobres" method="Activacion" returnvariable="LvarError">	<!--- Activar el sobre --->
					<cfinvokeargument name="Snumero" value="#Form.Snumero#">
				</cfinvoke>
			</cfif>
		</cftransaction>
	
	<cfelse>
		<cfthrow message="Error: El login digitado ya posee el servicio que desea agregar debe elegir un login diferente.">	
	</cfif>
<cfelse>
	<!--- el usuario va a crear un nuevo login para el nuevo servicio --->

	<cftransaction>
		
		<cfinvoke component="saci.comp.ISBlogin" method="Alta" returnvariable="loginid">			<!--- Insertar Login y sus servicios--->
			<cfif isdefined("Form.Snumero") and Len(Trim(Form.Snumero))>
				<cfinvokeargument name="Snumero" value="#Form.Snumero#">
			</cfif>
			<cfinvokeargument name="Contratoid" value="#Form.pkg#">
			<cfinvokeargument name="LGlogin" value="#Form.login2#">
			<cfinvokeargument name="LGrealName" value="">
			<cfinvokeargument name="LGmailQuota" value="">
			<cfinvokeargument name="LGroaming" value="false">
			<cfinvokeargument name="LGprincipal" value="#ListFind(TScodigo, 'ACCS', ',') NEQ 0 or ListFind(TScodigo, 'CABM', ',') NEQ 0#">
			<cfinvokeargument name="Habilitado" value="false">
			<cfinvokeargument name="LGbloqueado" value="false">
			<cfinvokeargument name="LGmostrarGuia" value="false">
			<cfif isdefined("Form.LGtelefono") and Len(Trim(Form.LGtelefono))>
				<cfinvokeargument name="LGtelefono" value="#Form.LGtelefono#">
			</cfif>
			<cfinvokeargument name="Servicios" value="#TScodigo#">
		</cfinvoke>
		
		<cfinvoke component="saci.comp.ISBlogin" method="Activacion">								<!--- Activar el login --->
			<cfinvokeargument name="LGnumero" value="#loginid#">
		</cfinvoke>
		
		<cfif isdefined("Form.Snumero") and Len(Trim(Form.Snumero))>								<!--- Asignar el sobre si viene asignado --->
			<cfinvoke component="saci.comp.ISBsobres" method="Asigna_Login">
				<cfinvokeargument name="Snumero" value="#Form.Snumero#">
				<cfinvokeargument name="LGnumero" value="#loginid#">
			</cfinvoke>
			<cfinvoke component="saci.comp.ISBlogin" method="Asignar_Sobre">
				<cfinvokeargument name="LGnumero" value="#loginid#">
				<cfinvokeargument name="Snumero" value="#Form.Snumero#">
			</cfinvoke>
			<cfinvoke component="saci.comp.ISBsobres" method="Activacion" returnvariable="LvarError"><!--- Activar el sobre --->
				<cfinvokeargument name="Snumero" value="#Form.Snumero#">
			</cfinvoke>
		</cfif>
		
		<cfquery name="rsCorreo" datasource="#session.dsn#">							<!--- Indica si algun servicio del login es de tipo correo --->
			select count(1)as cant
			from ISBservicioTipo
			where TScodigo in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#TScodigo#">)
				and TStipo='C'
		</cfquery>
		<cfif rsCorreo.cant gt 0>
			<cfquery name="rsQuota" datasource="#session.dsn#">							<!--- Toma el valor de la Quota del paquete--->
				select b.PQmailQuota as valor
				from ISBproducto a
					inner join ISBpaquete b
						on b.PQcodigo = a.PQcodigo
						and b.Habilitado=1
				where a.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.pkg#">	
			</cfquery>
			<cfif rsQuota.recordCount GT 0>
				<cfinvoke component="saci.comp.ISBlogin" method="UpdateQuota">			<!---Actualiza el valor de la Quota del login con la cuota del paquete--->
				<cfinvokeargument name="LGnumero" value="#loginid#">
				<cfinvokeargument name="LGmailQuota" value="#rsQuota.valor#">
				</cfinvoke>
			</cfif>
		</cfif>
	</cftransaction>
	<!--- activar la cuenta en los sistemas externos (SIIC) --->
	<cfinvoke component="saci.ws.intf.H001_crearLoginSIIC" method="activar_cuenta"
		LGnumero="#loginid#"/>
</cfif>

<cfinclude template="gestion-redirect.cfm">
