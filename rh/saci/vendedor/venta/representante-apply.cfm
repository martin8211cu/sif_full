<cfif isdefined("Form.Guardar")>
	
	<cfset IdPerRepre=-1>
		
	<cfif not isdefined("form.Pquien#sufijo#") or not len(trim(form['Pquien' & sufijo]))>
		<cfif isdefined("form.Pquien_Camb") and len(trim(form.Pquien_Camb))>
			<cfset form['Pquien' & sufijo]=form.Pquien_Camb>
		</cfif>
	</cfif>
	
	<cfset form['Pid' & sufijo] = trim(form['PidSinMask' & sufijo])>
	
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
		<cfif (len(trim(form[localidad])) EQ false) and form['RJtipo' & sufijo] EQ 'L'>
			<cfthrow message="Error: Debe llenar los campos de Localidad, no pueden quedar en blanco.">
		</cfif>
		
		<!---valida el caso en que se modifique la identificacion de la persona, para que la identificacion no se repita--->
		<cfquery datasource="#session.dsn#" name="rsVer1">
			select Pquien  from ISBpersona
			where Pid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form['Pid' & sufijo])#">
		</cfquery>
		<cfif rsVer1.RecordCount GT 0>
			<cfif rsVer1.Pquien NEQ form['Pquien' & sufijo]>
				<cfthrow message="Error: la identificación #trim(form['Pid' & sufijo])# pertenece a otra persona, elija una identificación diferente.">
			</cfif> 
		</cfif>
		
		<cftransaction>			
			<cfif isdefined("form.Pquien#sufijo#") and len(trim(form['Pquien' & sufijo]))>
				<!--- busca si el Pid de la persona existe en la base de datos, si existe lo modifica y si no lo agrega --->
				<cfquery datasource="#session.dsn#" name="rsVerifica">
					select count(1) as existe from ISBpersona
					where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form['Pquien' & sufijo])#">
				</cfquery>
				
				<cfif rsVerifica.existe EQ 1>	
					<!--- Modifica los datos del representante en caso de que se haya cambiado algun dato--->
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
						
						<cfinvokeargument name="AEactividad" value="#form['AEactividad' & sufijo]#">
						<cfif isdefined("form.CPid#sufijo#") and Len(Trim(form['CPid' & sufijo]))>
							<cfinvokeargument name="CPid" value="#form['CPid' & sufijo]#">
						</cfif>
						
						<cfinvokeargument name="cambialocalizacion" value="false">
						
						<cfinvokeargument name="Papdo" value="#form['Papdo' & sufijo]#">
						<cfif Len(Trim(form[localidad]))>
							<cfinvokeargument name="LCid" value="#form[localidad]#">
						</cfif>
						<cfinvokeargument name="Pdireccion" value="#form['Pdireccion' & sufijo]#">
						<cfinvokeargument name="Pbarrio" value="#form['Pbarrio' & sufijo]#">
						<cfinvokeargument name="Ptelefono1" value="#trim(form['Ptelefono1' & sufijo])#">
						<cfinvokeargument name="Ptelefono2" value="#trim(form['Ptelefono2' & sufijo])#">
						<cfinvokeargument name="Pfax" value="#trim(form['Pfax' & sufijo])#">
						<cfinvokeargument name="Pemail" value="#trim(form['Pemail' & sufijo])#">
						<cfinvokeargument name="ts_rversion" value="#trim(form['ts_rversionp' & sufijo])#">
					</cfinvoke>	
					
					<!--- verifica si existe el representante--->
					<cfquery datasource="#session.dsn#" name="rsVerificaRepresentante">
						select count(1) as existe
						from  ISBpersonaRepresentante
						where Pcontacto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form['Pquien' & sufijo]#" null="#Len(form['Pquien' & sufijo]) Is 0#">
						and Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#duenno#">
					</cfquery>	

					<cfif rsVerificaRepresentante.existe EQ 1>	
						<!--- Modifica el Representante si existe--->
						<cfinvoke component="saci.comp.ISBpersonaRepresentante"
							method="Cambio" returnvariable="IdPerRepre">
							<cfinvokeargument name="Pquien" value="#duenno#">
							<cfinvokeargument name="Pcontacto" value="#form['Pquien' & sufijo]#">
							<cfinvokeargument name="RJtipo" value="#form['RJtipo' & sufijo]#">
						</cfinvoke>
							
					<cfelse>
						<!--- Agrega el Representante si no existe--->
						<cfinvoke component="saci.comp.ISBpersonaRepresentante"
							method="Alta" returnvariable="IdPerRepre" >
							<cfinvokeargument name="Pquien" value="#duenno#">
							<cfinvokeargument name="Pcontacto" value="#form['Pquien' & sufijo]#">
							<cfinvokeargument name="RJtipo" value="#form['RJtipo' & sufijo]#">
						</cfinvoke>
						<cfset form['Lid' & sufijo] = "">
					</cfif>
				</cfif> 
			
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
					
					<cfinvokeargument name="AEactividad" value="#form['AEactividad' & sufijo]#">
					<cfif isdefined("form.CPid#sufijo#") and Len(Trim(form['CPid' & sufijo]))>
						<cfinvokeargument name="CPid" value="#form['CPid' & sufijo]#">
					</cfif>
					<cfinvokeargument name="Papdo" value="#form['Papdo' & sufijo]#">
					
					<cfif Len(Trim(form[localidad]))>
						<cfinvokeargument name="LCid" value="#form[localidad]#">
					</cfif>
					
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
				
				<!--- Agrega el Representante--->
				<cfinvoke component="saci.comp.ISBpersonaRepresentante"
					method="Alta"  returnvariable="IdPerRepre">
					<cfinvokeargument name="Pquien" value="#duenno#">
					<cfinvokeargument name="Pcontacto" value="#form['Pquien' & sufijo]#">
					<cfinvokeargument name="RJtipo" value="#form['RJtipo' & sufijo]#">
				</cfinvoke>
				<cfset form['Lid' & sufijo] = "">
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
			
			<cfif isdefined("form.Lid#sufijo#") and len(trim(form['Lid' & sufijo]))>	
				<!--- Modifica los datos de la ISBlocalizacion --->
				<cfinvoke component="saci.comp.ISBlocalizacion" method="Cambio">
					<cfinvokeargument name="Lid" value="#form['Lid' & sufijo]#">
					<cfinvokeargument name="RefId" value="#IdPerRepre#">
					<cfinvokeargument name="Ltipo" value="R">
					
					<cfif isdefined("form.CPid#sufijo#") and Len(Trim(form['CPid' & sufijo]))>
						<cfinvokeargument name="CPid" value="#form['CPid' & sufijo]#">
					</cfif>
					
					<cfinvokeargument name="Papdo" value="#form['Papdo' & sufijo]#">
					<cfif Len(Trim(form[localidad]))>
					<cfinvokeargument name="LCid" value="#form[localidad]#">
					</cfif>
					<cfinvokeargument name="Pdireccion" value="#form['Pdireccion' & sufijo]#">
					<cfinvokeargument name="Pbarrio" value="#form['Pbarrio' & sufijo]#">
					<cfinvokeargument name="Ptelefono1" value="#trim(form['Ptelefono1' & sufijo])#">
					<cfinvokeargument name="Ptelefono2" value="#trim(form['Ptelefono2' & sufijo])#">
					<cfinvokeargument name="Pfax" value="#trim(form['Pfax' & sufijo])#">
					<cfinvokeargument name="Pemail" value="#trim(form['Pemail' & sufijo])#">
					<cfinvokeargument name="Pobservacion" value="#form['Pobservacion' & sufijo]#">
					<cfinvokeargument name="ts_rversion" value="#trim(form['ts_rversionl' & sufijo])#">
				</cfinvoke>	
			
			<cfelse>	
				
				<!--- Agrega los datos de la ISBlocalizacion --->	
				<cfinvoke component="saci.comp.ISBlocalizacion" method="Alta"  returnvariable="idReturn">
					
					<cfinvokeargument name="RefId" value="#IdPerRepre#">
					<cfinvokeargument name="Ltipo" value="R">
					
					<cfif isdefined("form.CPid#sufijo#") and Len(Trim(form['CPid' & sufijo]))>
						<cfinvokeargument name="CPid" value="#form['CPid' & sufijo]#">
					</cfif>
					
					<cfinvokeargument name="Papdo" value="#form['Papdo' & sufijo]#">
					
					<cfif Len(Trim(form[localidad]))>
					<cfinvokeargument name="LCid" value="#form[localidad]#">
					</cfif>
					<cfinvokeargument name="Pdireccion" value="#form['Pdireccion' & sufijo]#">
					<cfinvokeargument name="Pbarrio" value="#form['Pbarrio' & sufijo]#">
					<cfinvokeargument name="Ptelefono1" value="#trim(form['Ptelefono1' & sufijo])#">
					<cfinvokeargument name="Ptelefono2" value="#trim(form['Ptelefono2' & sufijo])#">
					<cfinvokeargument name="Pfax" value="#trim(form['Pfax' & sufijo])#">
					<cfinvokeargument name="Pemail" value="#trim(form['Pemail' & sufijo])#">
					<cfinvokeargument name="Pobservacion" value="#form['Pobservacion' & sufijo]#">
					
				</cfinvoke>
				<cfif idReturn eq -1>
					<cfthrow message="Error: No se pudo agregar la persona, verifique los datos.">
				<cfelse>
					<cfset form.Lid = idReturn>  
				</cfif>
				
			</cfif>
			
		</cftransaction>
	</cfif>

<cfelseif isdefined("Form.Eliminar")>

	<cfinvoke component="saci.comp.ISBpersonaRepresentante"
		method="Baja">
		<cfinvokeargument name="Pquien" value="#duenno#">
		<cfinvokeargument name="Pcontacto" value="#form['Pquien' & sufijo]#">
	</cfinvoke>
	
	<cfif isdefined("form.Lid#sufijo#") and len(trim(form['Lid' & sufijo]))>	
				
		<!--- Modifica los datos de la ISBlocalizacion --->
		<cfinvoke component="saci.comp.ISBlocalizacion" method="Baja">
			<cfinvokeargument name="Lid" value="#form['Lid' & sufijo]#">
		</cfinvoke>	
	</cfif>
</cfif>

<cfif not isdefined("Form.Eliminar")and isdefined("form.Pquien#sufijo#") and len(trim(form['Pquien' & sufijo]))>
	<cfset ExtraParams="Pquien#sufijo#="&form['Pquien' & sufijo]>
</cfif>
