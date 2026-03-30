<cfset form.Pid = form.PidSinMask>

<!--- busca si el Pid de la persona existe en la base de datos, si existe lo modifica y si no lo agrega --->
<cfquery datasource="#session.dsn#" name="rsVerifica">
	select Pquien, rtrim(rtrim(Pnombre) || ' ' || rtrim(Papellido) || ' ' || Papellido2) as NombreCompleto
	from ISBpersona
	where Pid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.Pid)#">
</cfquery>

<!--- busca el nivel mas alto de divicion politica para generar el nombre del compo de la localidad que vamos a almacenar en la tabla de personas --->
<cfquery datasource="#session.dsn#" name="rsDivPolitica">
	select max(DPnivel) as nivel 
	from DivisionPolitica
	where Ppais = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.saci.pais#">
</cfquery>


<cfif isdefined("rsVerifica.Pquien") and Len(Trim(rsVerifica.Pquien))>
	<cfinvoke component="saci.comp.ISBcuenta" method="PermiteVenta" returnvariable="PermiteCuenta">
		<cfinvokeargument name="Pquien" value="#rsVerifica.Pquien#">
	</cfinvoke>
	
	<cfif not PermiteCuenta.valida>
		<cfoutput>
			<cfthrow message="No se puede modificar el cliente #rsVerifica.NombreCompleto# debido a que posee cuenta(s) en estado (#PermiteCuenta.nombre#).">
		</cfoutput>
	</cfif>
</cfif>
<!--- nombre del campo que posee el valor de la localidad --->
<cfset localidad = "LCid_" & rsDivPolitica.nivel>

<cfif rsDivPolitica.RecordCount eq 0>
	<cfthrow message="Error: La división política no se ha definido.">
<cfelse>

	<cfif len(trim(form[localidad])) EQ false>
		<cfthrow message="Error: Debe llenar los campos de Localidad, no pueden quedar en blanco.">
	</cfif>
	
	<cftransaction>
		<cfif Len(Trim(rsVerifica.Pquien))>
			
			<!--- Modifica los datos del cliente siempre y cuando no provenga de la atención de prospectos --->
			<cfif not isdefined("Form.idprospecto")>
				
				<cfinvoke component="saci.comp.ISBpersona" method="Cambio">
					<cfinvokeargument name="Pquien" value="#form.Pquien#">
					<cfinvokeargument name="Ppersoneria" value="#form.Ppersoneria#">
					<cfinvokeargument name="Pid" value="#form.Pid#">
					<cfif form.Ppersoneria EQ 'J'>
						<cfinvokeargument name="Pnombre" value="#trim(form.PrazonSocial)#">
						<cfinvokeargument name="PrazonSocial" value="#trim(form.PrazonSocial)#">
					<cfelse>
						<cfinvokeargument name="Pnombre" value="#trim(form.Pnombre)#">
						<cfinvokeargument name="Papellido" value="#trim(form.Papellido)#">
						<cfinvokeargument name="Papellido2" value="#trim(form.Papellido2)#">
					</cfif>
					<cfif form.Ppersoneria EQ 'F' or form.Ppersoneria EQ 'J'>
						<cfinvokeargument name="Ppais" value="#session.saci.pais#">
					<cfelse>
						<cfinvokeargument name="Ppais" value="#form.Ppais#">
					</cfif>
					<cfinvokeargument name="Pobservacion" value="#form.Pobservacion#">
					<cfinvokeargument name="AEactividad" value="#form.AEactividad#">
					<cfif isdefined("Form.CPid") and Len(Trim(Form.CPid))>
						<cfinvokeargument name="CPid" value="#form.CPid#">
					</cfif>
					<cfinvokeargument name="Papdo" value="#form.Papdo#">
					<cfinvokeargument name="LCid" value="#form[localidad]#">
					<cfinvokeargument name="Pdireccion" value="#form.Pdireccion#">
					<cfinvokeargument name="Pbarrio" value="#form.Pbarrio#">
					<cfinvokeargument name="Ptelefono1" value="#trim(form.Ptelefono1)#">
					<cfinvokeargument name="Ptelefono2" value="#trim(form.Ptelefono2)#">
					<cfinvokeargument name="Pfax" value="#trim(form.Pfax)#">
					<cfinvokeargument name="Pemail" value="#trim(form.Pemail)#">
					<cfinvokeargument name="ts_rversion" value="#trim(form.ts_rversion)#">
				</cfinvoke>
				
			<cfelse>
				<!--- Actualiza el estado del prospecto como formalizado --->
				<cfif isdefined("Form.idprospecto") and Len(Trim(Form.idprospecto))>
					<cfinvoke component="saci.comp.ISBprospectos" method="Cambio_Estado">
						<cfinvokeargument name="Pquien" value="#Form.idprospecto#">
						<cfinvokeargument name="Pprospectacion" value="F">
					</cfinvoke>
				</cfif>

				<cfset form.Pquien = rsVerifica.Pquien>
			
			</cfif>
			
		<cfelse>						
			
			<!--- Agrega los datos del cliente --->	
			<cfinvoke component="saci.comp.ISBpersona" method="Alta"  returnvariable="idReturn">
				<cfinvokeargument name="Ppersoneria" value="#form.Ppersoneria#">
				<cfinvokeargument name="Pid" value="#form.Pid#">
				<cfif form.Ppersoneria EQ 'J'>
					<cfinvokeargument name="Pnombre" value="#trim(form.PrazonSocial)#">
					<cfinvokeargument name="PrazonSocial" value="#trim(form.PrazonSocial)#">
				<cfelse>
					<cfinvokeargument name="Pnombre" value="#trim(form.Pnombre)#">
					<cfinvokeargument name="Papellido" value="#trim(form.Papellido)#">
					<cfinvokeargument name="Papellido2" value="#trim(form.Papellido2)#">
				</cfif>
				<cfif form.Ppersoneria EQ 'F' or form.Ppersoneria EQ 'J'>
					<cfinvokeargument name="Ppais" value="#session.saci.pais#">
				<cfelse>
					<cfinvokeargument name="Ppais" value="#form.Ppais#">
				</cfif>
				<cfinvokeargument name="Pobservacion" value="#form.Pobservacion#">
				<cfinvokeargument name="AEactividad" value="#form.AEactividad#">
				<cfif isdefined("Form.CPid") and Len(Trim(Form.CPid))>
					<cfinvokeargument name="CPid" value="#form.CPid#">
				</cfif>
				<cfinvokeargument name="Papdo" value="#form.Papdo#">
				<cfinvokeargument name="LCid" value="#form[localidad]#">
				<cfinvokeargument name="Pdireccion" value="#form.Pdireccion#">
				<cfinvokeargument name="Pbarrio" value="#form.Pbarrio#">
				<cfinvokeargument name="Ptelefono1" value="#trim(form.Ptelefono1)#">
				<cfinvokeargument name="Ptelefono2" value="#trim(form.Ptelefono2)#">
				<cfinvokeargument name="Pfax" value="#trim(form.Pfax)#">
				<cfinvokeargument name="Pemail" value="#trim(form.Pemail)#">
			</cfinvoke>
			<cfif idReturn eq -1>
				<cfthrow message="Error: No se pudo agregar la persona, verifique los datos.">
			<cfelse>
				<cfset form.Pquien = idReturn>
			</cfif>
			
			<!--- Actualiza el estado del prospecto como formalizado --->
			<cfif isdefined("Form.idprospecto") and Len(Trim(Form.idprospecto))>
				<cfinvoke component="saci.comp.ISBprospectos" method="Cambio_Estado">
					<cfinvokeargument name="Pquien" value="#Form.idprospecto#">
					<cfinvokeargument name="Pprospectacion" value="F">
				</cfinvoke>
			</cfif>
			
		</cfif> 
		
		<cfif not isdefined("Form.idprospecto") and isdefined("Form.Ppersoneria") and (Form.Ppersoneria EQ "F" or Form.Ppersoneria EQ "J")>
			<cfset tipo = Iif(Form.Ppersoneria EQ "F", DE("1"), DE("2"))>
			<cfinvoke component="saci.comp.atrExtendidosPersona" method="Alta_Cambio">
				<cfinvokeargument 	name="id" 				value="#form.Pquien#">
				<cfinvokeargument 	name="identificacion" 	value="#form.Pid#">
				<cfinvokeargument 	name="tipo" 			value="#tipo#">
				<cfinvokeargument 	name="Usuario" 			value="#session.Usucodigo#">
				<cfinvokeargument 	name="Ecodigo" 			value="#session.Ecodigo#">
				<cfinvokeargument	name="Conexion" 		value="#session.DSN#">
				<cfinvokeargument 	name="form" 			value="#form#">
			</cfinvoke>
		</cfif>
		
	</cftransaction>
</cfif>