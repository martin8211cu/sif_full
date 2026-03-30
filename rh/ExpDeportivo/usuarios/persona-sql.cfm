
<!--- Carga de la imagen del empleado --->
<!--- Contenido Binario de la Imagen --->
	<!--- Verifica si existe el Jugador en la empresa actual --->
<cfif isdefined('Form.Alta')>

	<cfquery name="rsExisteEmpleado" datasource="#Session.DSN#"> 
		select 1
		from EDPersonas
		where DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEidentificacion#">
			
		</cfquery>
			
		
			
		<cfif rsExisteEmpleado.recordCount GT 0>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_ElJugadorYaExiste"
				Default="El Jugador ya existe"
				returnvariable="MSG_ElJugadorYaExiste"/>
			<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#MSG_ElJugadorYaExiste#." addtoken="no">
			<cfabort> 
		</cfif>
		
		<cftransaction>
			<cfquery name="ABC_datosEmpl" datasource="#Session.DSN#">
				insert into EDPersonas (
				DEnombre, DEapellido1, DEapellido2, NTIcodigo, DEidentificacion, 
				DEdato1, DEdato2, DEcivil, DEfechanac, DEsexo, DEdireccion,
				DEtelefono1, DEtelefono2, DEemail, Ppais, PaisNacionalidad, rutafoto, 
				DEinfo1, DEinfo2, DEinfo3, DEinfo4, DEinfo5, DEinfo6, BMUsucodigo, BMfalta
				)
				values (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEnombre#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEapellido1#">,
					<cfif isdefined('form.DEapellido2')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEapellido2#">,
					<cfelse>
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.NTIcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEidentificacion#">,
					<cfif isdefined('form.DEdato1')>
						<cfqueryparam cfsqltype="cf_sql_date" value="#form.DEdato1#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEdato2')>
						<cfqueryparam cfsqltype="cf_sql_date" value="#form.DEdato2#">,
					<cfelse>
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.DEcivil#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.DEfechanac)#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.DEsexo#">,
					<cfif isdefined('form.DEdireccion')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEdireccion#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEtelefono1')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEtelefono1#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEtelefono2')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEtelefono2#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEemail')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEemail#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.Ppais')>
						<cfqueryparam cfsqltype="cf_sql_char" value="#form.Ppais#" >,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.PaisNacionalidad')>
						<cfqueryparam cfsqltype="cf_sql_char" value="#form.PaisNacionalidad#" >,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.rutafoto')>
						<cfqueryparam cfsqltype="cf_sql_image" value="#form.rutafoto#" >,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEinfo1')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEinfo1#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEinfo2')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEinfo2#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEinfo3')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEinfo3#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEinfo4')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEinfo4#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEinfo5')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEinfo5#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEinfo6')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEinfo6#">,
					<cfelse>
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
							
				)
				
			</cfquery>
			
				
					
		</cftransaction>
				
		
						
	

	<cfelseif isdefined("Form.Baja")>		
		<cfquery name="_deleteDatosEmpleado" datasource="#Session.DSN#">
			delete EDPersonas						
			where DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
		</cfquery>
		

	<cfelseif isdefined("Form.Cambio") and not isdefined('url.popup')>
		<!--- <cf_direccion action="readform" name="data">
		<cf_direccion action="update" key="#id_direccion#" name="data" data="#data#"> --->
		<cfquery name="ABC_datosEmpl" datasource="#Session.DSN#">
			update EDPersonas 
			set
				DEnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEnombre#">, 
				DEapellido1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEapellido1#">, 
				DEapellido2 = <cfif isdefined('form.DEapellido2')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEapellido2#">,
					<cfelse>
						null,
					</cfif>
				NTIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NTIcodigo#">,
				DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEidentificacion#">, 
				<cfif isdefined('form.DEdato1')>
					DEdato1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEdato1#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined('form.DEdato2')>
					DEdato2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEdato2#">,
				<cfelse>
					null,
				</cfif>
				DEcivil = <cfqueryparam cfsqltype="cf_sql_char" value="#form.DEcivil#">, 
				DEfechanac = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.DEfechanac)#">,
				DEsexo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEsexo#">, 
				<cfif isdefined('form.DEdireccion')>
					DEdireccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEdireccion#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined('form.DEtelefono1')>
					DEtelefono1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEtelefono1#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined('form.DEtelefono2')>
					DEtelefono2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEtelefono2#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined('form.DEemail')>
					DEemail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEemail#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined('form.Ppais')>
					Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ppais#" >,
				<cfelse>
					null,
				</cfif> 
				<cfif isdefined('form.PaisNacionalidad')>
					PaisNacionalidad = <cfqueryparam cfsqltype="cf_sql_char" value="#form.PaisNacionalidad#" >,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined('form.rutafoto')>
					rutafoto = <cfqueryparam cfsqltype="cf_sql_image" value="#form.rutafoto#" >,
				<cfelse>
					null,
				</cfif> 
				<cfif isdefined('form.DEinfo1')>
					DEinfo1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEinfo1#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined('form.DEinfo2')>
					DEinfo2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEinfo2#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined('form.DEinfo3')> 
					DEinfo3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEinfo3#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined('form.DEinfo4')> 
					DEinfo4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEinfo4#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined('form.DEinfo5')>
					DEinfo5 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEinfo5#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined('form.DEinfo6')>
					DEinfo6 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEinfo6#">
				<cfelse>
					null
				</cfif>				
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		</cfquery>
		</cfif>	

		<!--- ======================================================================================== --->
		<!--- 							REPLICACION DE USUARIOS INTERCOMPAÑIA 						   --->
		<!---                   ESTO SOLO APLICA SI EL PARAMETRO 580 TIENE VALOR DE 1				   --->
		<!--- ======================================================================================== --->
	<!--- 	<cfif rsP580.Pvalor eq 1 >
			<cfinclude template="replicacion-sql.cfm">
		</cfif> --->
		<!--- ======================================================================================== --->
		<!--- ======================================================================================== --->

		<cfset modo="CAMBIO">

<cfif isdefined("url.popup")>
	<cfif url.popup EQ 'a'>
		<cfset nombre = "DEacnombre">
		<cfset id = "EDParbitroc">
	<cfelseif url.popup EQ 'b'>
		<cfset nombre = "DEanombre1">
		<cfset id = "EDPalinea1">
	<cfelseif url.popup EQ 'c'>
		<cfset nombre = "DEanombre2">
		<cfset id = "EDPalinea2">
	<cfelseif url.popup EQ 'd'>
		<cfset nombre = "DEcnombre">
		<cfset id = "EDPcarbitro">
	<cfelse>
		<cfset nombre = "DEnombre">
		<cfset id = "DEid">
	</cfif>

<cfoutput>
<script>
var obj = window.parent.opener.document.getElementById('#nombre#');
obj.value = "#form.DEidentificacion# - #form.nombreEmpl#";
var obj = window.parent.opener.document.getElementById('#id#'); 
obj.value = "#form.DEid#";
window.close();
</script>
</cfoutput>
<cfelse>
<cflocation url="/cfmx/rh/ExpDeportivo/usuarios/persona.cfm">
</cfif>		
	

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
