<cfif Len(session.saci.agente.id) is 0 or session.saci.agente.id is 0>
  <cfthrow message="Usted no está registrado como agente autorizado, por favor verifíquelo.">
</cfif>

<cfinclude template="vendedor-params.cfm">

<cfif isdefined("Form.Guardar")>

	<cfset form.Pid = form.PidSinMask>

	<!--- busca si el Pid de la persona existe en la base de datos, si existe lo modifica y si no lo agrega --->
	<cfquery datasource="#session.dsn#" name="rsVerifica">
		select Pquien from ISBpersona
		where Pid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.Pid)#">
	</cfquery>
	
	<!--- busca el nivel mas alto de division politica para generar el nombre del compo de la localidad que vamos a almacenar en la tabla de personas --->
	<cfquery datasource="#session.dsn#" name="rsDivPolitica">
		select max(DPnivel) as nivel 
		from DivisionPolitica
		where Ppais = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.saci.pais#">
	</cfquery>

	<!--- nombre del campo que posee el valor de la localidad --->
	<cfset localidad = "LCid_" & rsDivPolitica.nivel>
	
	<cfif rsDivPolitica.RecordCount eq 0>
		<cfthrow message="Error: La división política no se ha definido.">
	<cfelse>
		
		<cfif len(trim(form[localidad])) EQ false>
			<cfthrow message="Error: Debe llenar los campos de Localidad, no pueden quedar en blanco.">
		</cfif>
		
		<cftransaction>

			<cfif isdefined("rsVerifica.Pquien") and len(trim(rsVerifica.Pquien))>	

				<cfset form.Pquien = rsVerifica.Pquien>	
				<!--- Modifica los datos de la persona --->
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
					
					
					<cfinvokeargument name="cambialocalizacion" value="false">
					
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
					<cfinvokeargument name="ts_rversion" value="#trim(form.ts_rversionp)#">
				</cfinvoke>	
			
			<cfelse>	
				
				<!--- Agrega los datos de la persona --->	
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
					<cfif isdefined("Form.AEactividad") and Len(Trim(Form.AEactividad))>
					<cfinvokeargument name="AEactividad" value="#form.AEactividad#">
					</cfif>
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
				
			</cfif>

			<!--- Registro de Atributos Extendidos de Persona --->
			<cfif isdefined("Form.Ppersoneria") and (Form.Ppersoneria EQ "F" or Form.Ppersoneria EQ "J")>
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

			<!--- verifica si existe el vendedor --->
			<cfquery datasource="#session.dsn#" name="rsVerificaVendedor">
				select Vid 
				from ISBvendedor
				where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Pquien#">
			</cfquery>	
			
			<cfif isdefined("rsVerificaVendedor.Vid") and len(trim(rsVerificaVendedor.Vid))>
		
				<cfset form.Vid = rsVerificaVendedor.Vid>

				<!--- Modifica el vendedor --->
				<cfinvoke component="saci.comp.ISBvendedor" method="Cambio">
					<cfinvokeargument name="Vid" value="#rsVerificaVendedor.Vid#">
					<cfinvokeargument name="Pquien" value="#form.Pquien#">
					<cfinvokeargument name="AGid" value="#session.saci.agente.id#">
					<cfinvokeargument name="Vprincipal" value="#IsDefined('form.Vprincipal') and form.Vprincipal EQ '1'#">
					<cfinvokeargument name="Habilitado" value="true">
				</cfinvoke>

			<cfelse>
			
				<!--- Agrega el vendedor --->
				<cfinvoke component="saci.comp.ISBvendedor" method="Alta" returnvariable="idReturn">
					<cfinvokeargument name="Pquien" value="#form.Pquien#">
					<cfinvokeargument name="AGid" value="#session.saci.agente.id#">
					<cfinvokeargument name="Vprincipal" value="#IsDefined('form.Vprincipal') and form.Vprincipal EQ '1'#">
					<cfinvokeargument name="Habilitado" value="true">
				</cfinvoke>
				<cfif idReturn eq -1>
					<cfthrow message="Error: No se pudo agregar el vendedor, verifique los datos.">
				<cfelse>
					<cfset form.Vid = idReturn>
				</cfif>
				
			</cfif>
			
			<cfif isdefined("form.Lid") and len(trim(form.Lid))>	
					
				<!--- Modifica los datos de la ISBlocalizacion --->
				<cfinvoke component="saci.comp.ISBlocalizacion" method="Cambio">
					<cfinvokeargument name="Lid" value="#form.Lid#">
					<cfinvokeargument name="RefId" value="#form.Vid#">
					<cfinvokeargument name="Ltipo" value="V">
					
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
					<cfinvokeargument name="ts_rversion" value="#trim(form.ts_rversionl)#">
				</cfinvoke>	
			
			<cfelse>	
				
				<!--- Agrega los datos de la ISBlocalizacion --->	
				<cfinvoke component="saci.comp.ISBlocalizacion" method="Alta"  returnvariable="idReturn">
					
					<cfinvokeargument name="RefId" value="#form.Vid#">
					<cfinvokeargument name="Ltipo" value="V">
					
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
					<cfset form.Lid = idReturn>  
				</cfif>
				
			</cfif>

		</cftransaction>
	</cfif>
	
</cfif>
<cfif isdefined("Form.Eliminar")>

	<cfset i = 0>
	<cfset msgError ="Validaciones Previas para el borrado del Vendedor:<br>">
				
				<!------Validacion 1------->
	<cfquery name="rs" datasource="#Session.DSN#">
		Select count(1) as t
		from ISBagente ag
			inner join ISBvendedor ven
			on ag.AGid = ven.AGid
			and ag.Pquien = ven.Pquien
		where ag.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Pquien#">
	</cfquery>
	<cfif rs.t gt 0>
		<cfset i = i + 1>
		<cfset msgError ="#msgError#<br>-El Vendedor principal ligado al Agente no puede ser eliminado.">
	</cfif>


	<cfif i gt 0>
		<!---------<cftransaction action="rollback"/>------->
		<cfthrow message="#msgError#<br><br>Vid:(#Form.Vid#)  Proceso Cancelado!!">
	<cfelse>
		<cfinvoke component="saci.comp.ISBvendedor" method="Baja">
		<cfinvokeargument name="Vid" value="#Form.Vid#">
		</cfinvoke>
	
			<!---  Busqueda del Usucodigo del agente seleccionado  --->
		<cfquery name="rsUsucodigo" datasource="#session.dsn#">
			Select Usucodigo
			from UsuarioReferencia
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
				and STabla='ISBvendedor'
				and llave=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Vid#" null="#Len(Form.Vid) Is 0#">
		</cfquery>
			
		<cfif isdefined('rsUsucodigo') and rsUsucodigo.recordCount GT 0>
			<!---  Busqueda si ya existe el registro antes de insertarlo en UsuarioBloqueo  --->
			<cfquery name="rsUsuarioBloqueo" datasource="#session.dsn#">
				Select 1
				from UsuarioBloqueo
				where Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUsucodigo.Usucodigo#">
					and bloqueo=<cfqueryparam cfsqltype="cf_sql_timestamp" value="1-1-6100">
					and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			</cfquery>		
	
			<cfif isdefined('rsUsuarioBloqueo') and rsUsuarioBloqueo.recordCount EQ 0>
				<!---  BLOQUEO DEL USUARIO AGENTE que como pertenece a otro DataSource debe estar fuera de la transaccion	--->
				<cfquery datasource="#session.dsn#">
					insert into UsuarioBloqueo (Usucodigo, bloqueo, CEcodigo, fecha, razon, desbloqueado)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUsucodigo.Usucodigo#">
						, <cfqueryparam cfsqltype="cf_sql_timestamp" value="1-1-6100">
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
						, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
						, <cfqueryparam cfsqltype="cf_sql_varchar" value="Eliminaci&oacute;n del Vendedor">
						, 0)
			   </cfquery>					
			 <cfelse>
				<!---  DESBLOQUEO DEL USUARIO AGENTE que como pertenece a otro DataSource debe estar fuera de la transaccion	--->
				<cfquery datasource="#session.dsn#">
					update UsuarioBloqueo
					set desbloqueado = 0
					where bloqueo   > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
					  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#rsUsucodigo.Usucodigo#">
					  and CEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#session.CEcodigo#">
					  and desbloqueado = 1
				</cfquery>					 
			</cfif>
		</cfif>
	</cfif>




</cfif>	

<cfinclude template="vendedor-redirect.cfm">
