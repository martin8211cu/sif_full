
<cfif isdefined("Form.Guardar")>

	<cfset form['Pid' & sufijo] = trim(form['PidSinMask' & sufijo])>
	
	<!--- busca si el Pid de la persona existe en la base de datos, si existe lo modifica y si no lo agrega --->
	<cfquery datasource="#session.dsn#" name="rsVerifica">
		select count(1) existe from ISBpersona
		where Pid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form['Pid' & sufijo])#">
	</cfquery>
	
	<!--- busca el nivel mas alto de divicion politica para generar el nombre del compo de la localidad que vamos a almacenar en la tabla de personas --->
	<cfquery datasource="#session.dsn#" name="rsDivPolitica">
		select max(DPnivel) as nivel 
		from DivisionPolitica
		where Ppais = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.saci.pais#">
	</cfquery>

	<!--- nombre del campo que posee el valor de la localidad --->
	<cfset localidad = "LCid_" & rsDivPolitica.nivel & sufijo>
	
	<cfif rsDivPolitica.RecordCount eq 0>
		<cfthrow message="Error: La división política no se ha definido.">
	<cfelse>
	
		<cfif len(trim(form[localidad])) EQ false>
			<cfthrow message="Error: Debe llenar los campos de Localidad, no pueden quedar en blanco.">
		</cfif>
		
		<cftransaction>
			<cfif rsVerifica.existe EQ 1>	
				
				<!--- Modifica los datos del cliente --->
				<cfinvoke component="saci.comp.ISBpersona" method="Cambio">
					<cfinvokeargument name="Pquien" value="#form['Pquien' & sufijo]#">
					<cfinvokeargument name="Ppersoneria" value="#form['Ppersoneria' & sufijo]#">
					<cfinvokeargument name="Pid" value="#form['Pid' & sufijo]#">
					<cfif form['Ppersoneria' & sufijo] EQ 'J'>
						<cfinvokeargument name="Pnombre" value="#trim(form['PrazonSocial' & sufijo])#">
						<cfinvokeargument name="PrazonSocial" value="#trim(form['PrazonSocial' & sufijo])#">
					<cfelse>
						<cfinvokeargument name="Pnombre" value="#trim(form['Pnombre' & sufijo])#">
						<cfinvokeargument name="Papellido" value="#trim(form['Papellido' & sufijo])#">
						<cfinvokeargument name="Papellido2" value="#trim(form['Papellido2' & sufijo])#">
					</cfif>
					<cfif form['Ppersoneria' & sufijo] EQ 'F' or form['Ppersoneria' & sufijo] EQ 'J'>
						<cfinvokeargument name="Ppais" value="#session.saci.pais#">
					<cfelse>
						<cfinvokeargument name="Ppais" value="#form['Ppais' & sufijo]#">
					</cfif>
					<cfinvokeargument name="Pobservacion" value="#form['Pobservacion' & sufijo]#">
					<cfinvokeargument name="AEactividad" value="#form['AEactividad' & sufijo]#">
					<cfif isdefined("form.CPid#sufijo#") and Len(Trim(form['CPid' & sufijo]))>
						<cfinvokeargument name="CPid" value="#form['CPid' & sufijo]#">
					</cfif>
					<cfinvokeargument name="Papdo" value="#form['Papdo' & sufijo]#">
					<cfinvokeargument name="LCid" value="#form[localidad]#">
					<cfinvokeargument name="Pdireccion" value="#form['Pdireccion' & sufijo]#">
					<cfinvokeargument name="Pbarrio" value="#form['Pbarrio' & sufijo]#">
					<cfinvokeargument name="Ptelefono1" value="#trim(form['Ptelefono1' & sufijo])#">
					<cfinvokeargument name="Ptelefono2" value="#trim(form['Ptelefono2' & sufijo])#">
					<cfinvokeargument name="Pfax" value="#trim(form['Pfax' & sufijo])#">
					<cfinvokeargument name="Pemail" value="#trim(form['Pemail' & sufijo])#">
					<cfinvokeargument name="ts_rversion" value="#trim(form['ts_rversion' & sufijo])#">
				</cfinvoke>	
				
			<cfelse>						
				
				<!--- Agrega los datos del cliente --->	
				<cfinvoke component="saci.comp.ISBpersona" method="Alta"  returnvariable="idReturn">
					<cfinvokeargument name="Ppersoneria" value="#form['Ppersoneria' & sufijo]#">
					<cfinvokeargument name="Pid" value="#form['Pid' & sufijo]#">
					<cfif form['Ppersoneria' & sufijo] EQ 'J'>
						<cfinvokeargument name="Pnombre" value="#trim(form['PrazonSocial' & sufijo])#">
						<cfinvokeargument name="PrazonSocial" value="#trim(form['PrazonSocial' & sufijo])#">
					<cfelse>
						<cfinvokeargument name="Pnombre" value="#trim(form['Pnombre' & sufijo])#">
						<cfinvokeargument name="Papellido" value="#trim(form['Papellido' & sufijo])#">
						<cfinvokeargument name="Papellido2" value="#trim(form['Papellido2' & sufijo])#">
					</cfif>
					<cfif form['Ppersoneria' & sufijo] EQ 'F' or form['Ppersoneria' & sufijo] EQ 'J'>
						<cfinvokeargument name="Ppais" value="#session.saci.pais#">
					<cfelse>
						<cfinvokeargument name="Ppais" value="#form['Ppais' & sufijo]#">
					</cfif>
					<cfinvokeargument name="Pobservacion" value="#form['Pobservacion' & sufijo]#">
					<cfinvokeargument name="AEactividad" value="#form['AEactividad' & sufijo]#">
					<cfif isdefined("form.CPid#sufijo#") and Len(Trim(form['CPid' & sufijo]))>
						<cfinvokeargument name="CPid" value="#form['CPid' & sufijo]#">
					</cfif>
					<cfinvokeargument name="Papdo" value="#form['Papdo' & sufijo]#">
					<cfinvokeargument name="LCid" value="#form[localidad]#">
					<cfinvokeargument name="Pdireccion" value="#form['Pdireccion' & sufijo]#">
					<cfinvokeargument name="Pbarrio" value="#form['Pbarrio' & sufijo]#">
					<cfinvokeargument name="Ptelefono1" value="#trim(form['Ptelefono1' & sufijo])#">
					<cfinvokeargument name="Ptelefono2" value="#trim(form['Ptelefono2' & sufijo])#">
					<cfinvokeargument name="Pfax" value="#trim(form['Pfax' & sufijo])#">
					<cfinvokeargument name="Pemail" value="#trim(form['Pemail' & sufijo])#">
				</cfinvoke>
				<cfif idReturn eq -1>
					<cfthrow message="Error: No se pudo agregar la persona, verifique los datos.">
				<cfelse>
					<cfset form['Pquien' & sufijo] = idReturn>  
				</cfif>
			</cfif> 
			
			<cfif isdefined("Form.Ppersoneria#sufijo#") and (form['Ppersoneria' & sufijo] EQ "F" or form['Ppersoneria' & sufijo] EQ "J")>
				<cfset tipo = Iif(form['Ppersoneria' & sufijo] EQ "F", DE("1"), DE("2"))>
				<cfinvoke component="saci.comp.atrExtendidosPersona" method="Alta_Cambio">
					<cfinvokeargument 	name="id" 				value="#form['Pquien' & sufijo]#">
					<cfinvokeargument 	name="identificacion" 	value="#form['Pid' & sufijo]#">
					<cfinvokeargument 	name="tipo" 			value="#tipo#">
					<cfinvokeargument 	name="Usuario" 			value="#session.Usucodigo#">
					<cfinvokeargument 	name="Ecodigo" 			value="#session.Ecodigo#">
					<cfinvokeargument	name="Conexion" 		value="#session.DSN#">
					<cfinvokeargument 	name="form" 			value="#form#">
					<cfinvokeargument 	name="sufijo" 			value="#sufijo#">
				</cfinvoke>
			</cfif>
			
			<!--- verifica si existe el contacto--->
			<cfquery datasource="#session.dsn#" name="rsVerificaContacto">
				select count(1) as existe
				from  ISBcontactoCta
				where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cuenta#">
				and Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form['Pquien' & sufijo]#" null="#Len(form['Pquien' & sufijo]) Is 0#">
			</cfquery>	
			
			<cfif rsVerificaContacto.existe EQ 1>	
				<!--- Modifica el contacto--->
				<cfinvoke component="saci.comp.ISBcontactoCta"
					method="Cambio" >
					<cfinvokeargument name="CTid" value="#cuenta#">
					<cfinvokeargument name="Pquien" value="#form['Pquien' & sufijo]#">
					<cfinvokeargument name="CCtipo" value="#form['CCtipo' & sufijo]#">
					<cfinvokeargument name="Habilitado" value="#IsDefined('form.Habilitado')#">
				</cfinvoke>
					
			<cfelse>
				<!--- Agrega el contacto--->
				<cfinvoke component="saci.comp.ISBcontactoCta"
					method="Alta"  >
					<cfinvokeargument name="CTid" value="#cuenta#">
					<cfinvokeargument name="Pquien" value="#form['Pquien' & sufijo]#">
					<cfinvokeargument name="CCtipo" value="#form['CCtipo' & sufijo]#">
					<cfinvokeargument name="Habilitado" value="#IsDefined('form.Habilitado')#">
				</cfinvoke>
			</cfif>
		
		</cftransaction>
	</cfif>

<cfelseif isdefined("Form.Eliminar")>
	<cfinvoke component="saci.comp.ISBcontactoCta"
		method="Baja">
		<cfinvokeargument name="CTid" value="#cuenta#">
		<cfinvokeargument name="Pquien" value="#form['Pquien' & sufijo]#">
	</cfinvoke>

</cfif>