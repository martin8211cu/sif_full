<cfset error = false >
<cfif isdefined('Procesar')>
	<cftry>
		<!--- Copia el xml a un folder del servidor --->
		<cffile action="Upload" fileField="Form.FiletoUpload"  destination="#gettempdirectory()#" nameConflict="Overwrite" > 
		
		<!--- lee el arrchivo XML del servidor y la almacena en myxml --->
		<cffile action="read" file="#gettempdirectory()##cffile.ClientFileName#.#cffile.ClientFileExt#" variable="myxml" >
		<cfset mydoc = XmlParse(myxml)>
		
		<cffile action="delete" file="#gettempdirectory()##cffile.ClientFileName#.#cffile.ClientFileExt#" >

	<cfcatch type="any">
		<cfset error = true >
		<cfset number_error = 1 >
	</cfcatch> 
	</cftry>
</cfif>		

<cfif not error >

	<table width="35%" border="0">
		<tr><td id="item">Importando...</td></tr>
		<tr>
			<td align="rigth" width="1%">
				<table style="border:solid 1px black;width:200px; height:15px;" cellpadding="0" cellspacing="0">
					<tr>
						<td>
							<table id="tabla" width="0%" height="100%" bgcolor="##0099FF" cellpadding="0" cellspacing="0"><tr><td align="center" width="100%"></td></tr></table>
						</td>
					</tr>
				</table>
			</td>
			<td id="pct">0%</td>	
		</tr>
		<tr>
			<td>
			<table width="100%">
				<tr><td width="1%">Sistemas</td><td id="sistema"></td></tr>
				<tr><td width="1%">Modulos</td><td id="modulo"></td></tr>
				<tr><td width="1%">Roles</td><td id="rol"></td></tr>
				<tr><td width="1%">Servicios</td><td id="servicio"></td></tr>
				<tr><td width="1%" nowrap>Roles por Servicio</td><td id="serviciorol"></td></tr>
				<tr><td width="1%">Procesos</td><td id="proceso"></td></tr>
			</table>
			</td>
		</tr>
	</table>

	<cftransaction>
 	<cftry>
		<!--- Calcula registros por cada tabla --->
		<cfset numSistemas 	   = ArrayLen(mydoc.datos.Sistema_list.row)>
		<cfset numModulos 	   = ArrayLen(mydoc.datos.Modulo_list.row)>
		<cfset numRoles 	   = ArrayLen(mydoc.datos.Rol_list.row)>
		<cfset numServicios    = ArrayLen(mydoc.datos.Servicios_list.row)>		
		<cfset numServiciosRol = ArrayLen(mydoc.datos.ServiciosRol_list.row)>
		<cfset numProcesos     = ArrayLen(mydoc.datos.Procesos_list.row)>
		<cfset total = numSistemas + numModulos + numRoles + numServicios + numServiciosRol + numProcesos >
		<cfset cont = 0 >

		<!--- ========================================================================================================================== --->
		<!---                                                        1. Importar Sistemas                                                --->
		<!--- ========================================================================================================================== --->
		<cfloop index="i" from = "1" to = #numSistemas#>
			<cfset cont = cont + 1 >
			<cfset ancho = ceiling((cont * 100)/total) >
	
			<cfquery name="rsSistemas" datasource="sdc">
				set nocount on
				update Sistema
				set nombre       = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mydoc.datos.Sistema_list.row[i].nombre.xmlText#">,
					nombre_cache = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mydoc.datos.Sistema_list.row[i].nombre_cache.xmlText#">,
					orden        = <cfqueryparam cfsqltype="cf_sql_integer" value="#mydoc.datos.Sistema_list.row[i].orden.xmlText#">,
					activo       = <cfif trim(mydoc.datos.Sistema_list.row[i].activo.xmlText) eq 'true' >1<cfelse>0</cfif>
				where sistema    = <cfqueryparam cfsqltype="cf_sql_char" value="#mydoc.datos.Sistema_list.row[i].sistema.xmlText#">
				if @@rowcount = 0
					insert Sistema (sistema, nombre, nombre_cache, orden, activo)
					values ( <cfqueryparam cfsqltype="cf_sql_char"    value="#mydoc.datos.Sistema_list.row[i].sistema.xmlText#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#mydoc.datos.Sistema_list.row[i].nombre.xmlText#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#mydoc.datos.Sistema_list.row[i].nombre_cache.xmlText#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#mydoc.datos.Sistema_list.row[i].orden.xmlText#">,
							 <cfif trim(mydoc.datos.Sistema_list.row[i].activo.xmlText) eq 'true' >1<cfelse>0</cfif>
						   )
				set nocount off
			</cfquery>

			<script language="javascript1.2" type="text/javascript">
				document.getElementById("tabla").width = "<cfoutput>#ancho#%</cfoutput>";
				document.getElementById("pct").innerHTML = "<cfoutput>#ancho#</cfoutput>%";
			</script>
		</cfloop>
		<script language="javascript1.2" type="text/javascript">
			document.getElementById("sistema").innerHTML = "<img border='0' src='../../framework/imagenes/w-check.gif'>";
		</script>
		<!--- ========================================================================================================================== --->
		
		<!--- ========================================================================================================================== --->
		<!---                                                      2. Importar Módulos                                                   --->
		<!--- ========================================================================================================================== --->
		<cfloop index="i" from = "1" to = #numModulos#>
			<cfset cont = cont + 1 >
			<cfset ancho = ceiling((cont * 100)/total) >

			<cfquery name="rsModulos" datasource="sdc">
				set nocount on
				update Modulo
				set sistema      = <cfqueryparam cfsqltype="cf_sql_char"        value="#mydoc.datos.Modulo_list.row[i].sistema.xmlText#">,
					nombre       = <cfqueryparam cfsqltype="cf_sql_varchar"     value="#mydoc.datos.Modulo_list.row[i].nombre.xmlText#">,
					tarifa       = <cfqueryparam cfsqltype="cf_sql_money"       value="#mydoc.datos.Modulo_list.row[i].tarifa.xmlText#">,
					facturacion  = <cfqueryparam cfsqltype="cf_sql_char"        value="#mydoc.datos.Modulo_list.row[i].facturacion.xmlText#">,
					componente   = <cfqueryparam cfsqltype="cf_sql_varchar"     value="#mydoc.datos.Modulo_list.row[i].componente.xmlText#">,
					metodo       = <cfqueryparam cfsqltype="cf_sql_varchar"     value="#mydoc.datos.Modulo_list.row[i].metodo.xmlText#">,
					descripcion  = <cfqueryparam cfsqltype="cf_sql_varchar"     value="#mydoc.datos.Modulo_list.row[i].descripcion.xmlText#">,
					contrato     = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#mydoc.datos.Modulo_list.row[i].contrato.xmlText#">,
					orden        = <cfqueryparam cfsqltype="cf_sql_integer"     value="#mydoc.datos.Modulo_list.row[i].orden.xmlText#">,
					activo       = <cfif trim(mydoc.datos.Modulo_list.row[i].activo.xmlText) eq 'true' >1<cfelse>0</cfif>
				where modulo     = <cfqueryparam cfsqltype="cf_sql_char"        value="#mydoc.datos.Modulo_list.row[i].modulo.xmlText#">
				if @@rowcount = 0
					insert Modulo ( modulo, sistema, nombre, tarifa, facturacion, componente, metodo, descripcion, contrato, orden, activo )
					values ( <cfqueryparam cfsqltype="cf_sql_char"        value="#mydoc.datos.Modulo_list.row[i].modulo.xmlText#">,
							 <cfqueryparam cfsqltype="cf_sql_char"        value="#mydoc.datos.Modulo_list.row[i].sistema.xmlText#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar"     value="#mydoc.datos.Modulo_list.row[i].nombre.xmlText#">,
							 <cfqueryparam cfsqltype="cf_sql_money"       value="#mydoc.datos.Modulo_list.row[i].tarifa.xmlText#">,
							 <cfqueryparam cfsqltype="cf_sql_char"        value="#mydoc.datos.Modulo_list.row[i].facturacion.xmlText#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar"     value="#mydoc.datos.Modulo_list.row[i].componente.xmlText#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar"     value="#mydoc.datos.Modulo_list.row[i].metodo.xmlText#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar"     value="#mydoc.datos.Modulo_list.row[i].descripcion.xmlText#">,
							 <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#mydoc.datos.Modulo_list.row[i].contrato.xmlText#">,
							 <cfqueryparam cfsqltype="cf_sql_integer"     value="#mydoc.datos.Modulo_list.row[i].orden.xmlText#">,
							 <cfif trim(mydoc.datos.Modulo_list.row[i].activo.xmlText) eq 'true' >1<cfelse>0</cfif>
						   )
				set nocount off
			</cfquery>
			<script language="javascript1.2" type="text/javascript">
				document.getElementById("tabla").width = "<cfoutput>#ancho#%</cfoutput>";
				document.getElementById("pct").innerHTML = "<cfoutput>#ancho#</cfoutput>%";
			</script>
		</cfloop>
		<script language="javascript1.2" type="text/javascript">
			document.getElementById("modulo").innerHTML = "<img border='0' src='../../framework/imagenes/w-check.gif'>";
		</script>
		<!--- ========================================================================================================================== --->
		
		<!--- ========================================================================================================================== --->
		<!---                                                      3. Importar Roles                                                   --->
		<!--- ========================================================================================================================== --->
		<cfloop index="i" from = "1" to = #numRoles#>
			<cfset cont = cont + 1 >
			<cfset ancho = ceiling((cont * 100)/total) >				
			
			<cfquery name="rsRoles" datasource="sdc">
				set nocount on
				update Rol
				set Rolcod       = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#mydoc.datos.Rol_list.row[i].Rolcod.xmlText#">,
					sistema      = <cfqueryparam cfsqltype="cf_sql_char"    	value="#mydoc.datos.Rol_list.row[i].sistema.xmlText#">,
					nombre       = <cfqueryparam cfsqltype="cf_sql_varchar"     value="#mydoc.datos.Rol_list.row[i].nombre.xmlText#">,
					descripcion  = <cfqueryparam cfsqltype="cf_sql_varchar"     value="#mydoc.datos.Rol_list.row[i].descripcion.xmlText#">,
					Rolinfo      = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#mydoc.datos.Rol_list.row[i].Rolinfo.xmlText#">,
					empresarial  = <cfif trim(mydoc.datos.Rol_list.row[i].empresarial.xmlText) eq 'true' >1<cfelse>0</cfif>,
					interno      = <cfif trim(mydoc.datos.Rol_list.row[i].interno.xmlText) eq 'true' >1<cfelse>0</cfif>,
					activo       = <cfif trim(mydoc.datos.Rol_list.row[i].activo.xmlText) eq 'true' >1<cfelse>0</cfif>
				where rol        = <cfqueryparam cfsqltype="cf_sql_char" value="#mydoc.datos.Rol_list.row[i].rol.xmlText#">
				if @@rowcount = 0
					insert Rol ( rol, Rolcod, sistema, nombre, descripcion, Rolinfo, empresarial, interno, activo )
					values ( <cfqueryparam cfsqltype="cf_sql_char" value="#mydoc.datos.Rol_list.row[i].rol.xmlText#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#mydoc.datos.Rol_list.row[i].Rolcod.xmlText#">,
							 <cfqueryparam cfsqltype="cf_sql_char"    	value="#mydoc.datos.Rol_list.row[i].sistema.xmlText#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar"     value="#mydoc.datos.Rol_list.row[i].nombre.xmlText#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar"     value="#mydoc.datos.Rol_list.row[i].descripcion.xmlText#">,
							 <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#mydoc.datos.Rol_list.row[i].Rolinfo.xmlText#">,
							 <cfif trim(mydoc.datos.Rol_list.row[i].empresarial.xmlText) eq 'true' >1<cfelse>0</cfif>,
							 <cfif trim(mydoc.datos.Rol_list.row[i].interno.xmlText) eq 'true' >1<cfelse>0</cfif>,
							 <cfif trim(mydoc.datos.Rol_list.row[i].activo.xmlText) eq 'true' >1<cfelse>0</cfif>
						   )
	
				set nocount off
			</cfquery>
			<script language="javascript1.2" type="text/javascript">
				document.getElementById("tabla").width = "<cfoutput>#ancho#%</cfoutput>";
				document.getElementById("pct").innerHTML = "<cfoutput>#ancho#</cfoutput>%";
			</script>
		</cfloop>
		<script language="javascript1.2" type="text/javascript">
			document.getElementById("rol").innerHTML = "<img border='0' src='../../framework/imagenes/w-check.gif'>";
		</script>
		<!--- ========================================================================================================================== --->
		
		<!--- ========================================================================================================================== --->
		<!---                                                        4. Importar Servicios 												 --->
		<!--- ========================================================================================================================== --->
		<cfloop index="i" from = "1" to = #numServicios#>
			<cfset cont = cont + 1 >
			<cfset ancho = ceiling((cont * 100)/total) >
			<cfquery name="rsServicios" datasource="sdc">
				set nocount on
				update Servicios
				set modulo       = <cfqueryparam cfsqltype="cf_sql_char" value="#mydoc.datos.Servicios_list.row[i].modulo.xmlText#">,
					nombre       = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mydoc.datos.Servicios_list.row[i].nombre.xmlText#">,
					descripcion  = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#mydoc.datos.Servicios_list.row[i].descripcion.xmlText#">,
					menu         = <cfif trim(mydoc.datos.Servicios_list.row[i].menu.xmlText) eq 'true' >1<cfelse>0</cfif>,
					home         = <cfif trim(mydoc.datos.Servicios_list.row[i].home.xmlText) eq 'true' >1<cfelse>0</cfif>,
					snapshot_uri = <cfif len(trim(mydoc.datos.Servicios_list.row[i].snapshot_uri.xmlText)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#mydoc.datos.Servicios_list.row[i].snapshot_uri.xmlText#"><cfelse>null</cfif>,
					<!---home_uri     = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mydoc.datos.Servicios_list.row[i].home_uri.xmlText#">,--->
					<!---home_tipo    = <cfif len(trim(mydoc.datos.Servicios_list.row[i].home_tipo.xmlText)) gt 0 ><cfqueryparam cfsqltype="cf_sql_char" value="#mydoc.datos.Servicios_list.row[i].home_tipo.xmlText#"><cfelse>'J'</cfif>,--->
					agregacion   = <cfqueryparam cfsqltype="cf_sql_char" value="#mydoc.datos.Servicios_list.row[i].agregacion.xmlText#">,
					orden        = <cfqueryparam cfsqltype="cf_sql_integer" value="#mydoc.datos.Servicios_list.row[i].orden.xmlText#">,
					activo       = <cfif trim(mydoc.datos.Servicios_list.row[i].activo.xmlText) eq 'true' >1<cfelse>0</cfif>
				where servicio   = <cfqueryparam cfsqltype="cf_sql_char" value="#mydoc.datos.Servicios_list.row[i].servicio.xmlText#">
				if @@rowcount = 0
					insert Servicios ( servicio, modulo, nombre, descripcion, menu, home, snapshot_uri, agregacion, orden, activo )
					values ( <cfqueryparam cfsqltype="cf_sql_char" value="#mydoc.datos.Servicios_list.row[i].servicio.xmlText#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#mydoc.datos.Servicios_list.row[i].modulo.xmlText#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#mydoc.datos.Servicios_list.row[i].nombre.xmlText#">,
							 <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#mydoc.datos.Servicios_list.row[i].descripcion.xmlText#">,
							 <cfif trim(mydoc.datos.Servicios_list.row[i].menu.xmlText) eq 'true' >1<cfelse>0</cfif>,
							 <cfif trim(mydoc.datos.Servicios_list.row[i].home.xmlText) eq 'true' >1<cfelse>0</cfif>,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#mydoc.datos.Servicios_list.row[i].snapshot_uri.xmlText#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#mydoc.datos.Servicios_list.row[i].agregacion.xmlText#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#mydoc.datos.Servicios_list.row[i].orden.xmlText#">,
							 <cfif trim(mydoc.datos.Servicios_list.row[i].activo.xmlText) eq 'true' >1<cfelse>0</cfif>
						   )
				set nocount off
			</cfquery>
			<script language="javascript1.2" type="text/javascript">
				document.getElementById("tabla").width = "<cfoutput>#ancho#%</cfoutput>";
				document.getElementById("pct").innerHTML = "<cfoutput>#ancho#</cfoutput>%";
			</script>
		</cfloop>
		<script language="javascript1.2" type="text/javascript">
			document.getElementById("servicio").innerHTML = "<img border='0' src='../../framework/imagenes/w-check.gif'>";
		</script>
		<!--- ========================================================================================================================== --->
		
		<!--- ========================================================================================================================== --->
		<!---                                                        5. Importar ServiciosRol											 --->
		<!--- ========================================================================================================================== --->
		<cfloop index="i" from = "1" to = #numServiciosRol#>
			<cfset cont = cont + 1 >
			<cfset ancho = ceiling((cont * 100)/total) >

			<cfquery name="rsSRDatos" datasource="sdc">
				select * from Servicios where servicio = <cfqueryparam cfsqltype="cf_sql_char" value="#mydoc.datos.ServiciosRol_list.row[i].servicio.xmlText#">
			</cfquery>			

			<cfif rsSRDatos.RecordCount gt 0 >			
				<cfquery name="rsServiciosRol" datasource="sdc">
					set nocount on
					update ServiciosRol
					set servicio     = <cfqueryparam cfsqltype="cf_sql_char" value="#mydoc.datos.ServiciosRol_list.row[i].servicio.xmlText#">,
						rol          = <cfqueryparam cfsqltype="cf_sql_char" value="#mydoc.datos.ServiciosRol_list.row[i].rol.xmlText#">,
						activo       = <cfif trim(mydoc.datos.ServiciosRol_list.row[i].activo.xmlText) eq 'true' >1<cfelse>0</cfif>
					where servicio   = <cfqueryparam cfsqltype="cf_sql_char" value="#mydoc.datos.ServiciosRol_list.row[i].servicio.xmlText#">
					  and rol        = <cfqueryparam cfsqltype="cf_sql_char" value="#mydoc.datos.ServiciosRol_list.row[i].rol.xmlText#">
					if @@rowcount = 0
						insert ServiciosRol ( servicio, rol, activo )
						values ( <cfqueryparam cfsqltype="cf_sql_char" value="#mydoc.datos.ServiciosRol_list.row[i].servicio.xmlText#">,
								 <cfqueryparam cfsqltype="cf_sql_char" value="#mydoc.datos.ServiciosRol_list.row[i].rol.xmlText#">,
								 <cfif trim(mydoc.datos.ServiciosRol_list.row[i].activo.xmlText) eq 'true' >1<cfelse>0</cfif>
							   )
					set nocount off
				</cfquery>
			</cfif>	

			<script language="javascript1.2" type="text/javascript">
				document.getElementById("tabla").width = "<cfoutput>#ancho#%</cfoutput>";
				document.getElementById("pct").innerHTML = "<cfoutput>#ancho#</cfoutput>%";
			</script>
		</cfloop>
		<script language="javascript1.2" type="text/javascript">
			document.getElementById("serviciorol").innerHTML = "<img border='0' src='../../framework/imagenes/w-check.gif'>";
		</script>
		<!--- ========================================================================================================================== --->
		
		<!--- ========================================================================================================================== --->
		<!--- 															6. Procesos                                                      --->
		<!--- ========================================================================================================================== --->
		<cfloop index="i" from = "1" to = #numProcesos#>
			<cfset cont = cont + 1 >
			<cfset ancho = ceiling((cont * 100)/total) >

			<cfquery name="rsProcesos" datasource="sdc">
				set nocount on
				update Procesos
				set tipo_obj     = <cfqueryparam cfsqltype="cf_sql_char"    value="#mydoc.datos.Procesos_list.row[i].tipo_obj.xmlText#">,
					titulo       = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mydoc.datos.Procesos_list.row[i].titulo.xmlText#">,
					descripcion  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mydoc.datos.Procesos_list.row[i].descripcion.xmlText#">,
					activo       = <cfif trim(mydoc.datos.Procesos_list.row[i].activo.xmlText) eq 'true' >1<cfelse>0</cfif>
				where uri        = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mydoc.datos.Procesos_list.row[i].uri.xmlText#">
				  and tipo_uri   = <cfqueryparam cfsqltype="cf_sql_char"    value="#mydoc.datos.Procesos_list.row[i].tipo_uri.xmlText#">
				  and servicio   = <cfqueryparam cfsqltype="cf_sql_char"    value="#mydoc.datos.Procesos_list.row[i].servicio.xmlText#">
				if @@rowcount = 0
					insert Procesos (uri, tipo_uri, servicio, tipo_obj, titulo, descripcion, activo)
					values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#mydoc.datos.Procesos_list.row[i].uri.xmlText#">,
							 <cfqueryparam cfsqltype="cf_sql_char"    value="#mydoc.datos.Procesos_list.row[i].tipo_uri.xmlText#">,
							 <cfqueryparam cfsqltype="cf_sql_char"    value="#mydoc.datos.Procesos_list.row[i].servicio.xmlText#">,
							 <cfqueryparam cfsqltype="cf_sql_char"    value="#mydoc.datos.Procesos_list.row[i].tipo_obj.xmlText#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#mydoc.datos.Procesos_list.row[i].titulo.xmlText#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#mydoc.datos.Procesos_list.row[i].descripcion.xmlText#">,
							 <cfif trim(mydoc.datos.Procesos_list.row[i].activo.xmlText) eq 'true' >1<cfelse>0</cfif>
						   )
				set nocount off
			</cfquery>
			<script language="javascript1.2" type="text/javascript">
				document.getElementById("tabla").width = "<cfoutput>#ancho#%</cfoutput>";
				document.getElementById("pct").innerHTML = "<cfoutput>#ancho#</cfoutput>%";
			</script>
		</cfloop>
		
		<!--- 7. update a servicios que referencian procesos  --->
		<cfloop index="i" from = "1" to = #numServicios#>
			<cfif len(trim(mydoc.datos.Servicios_list.row[i].home_uri.xmlText)) gt 0 and 
				  len(trim(mydoc.datos.Servicios_list.row[i].home_tipo.xmlText)) gt 0 >

				<cfquery name="rsDatos" datasource="sdc">
					select servicio, tipo_uri, uri
					from Procesos
					where uri = '#mydoc.datos.Servicios_list.row[i].home_uri.xmlText#' 
					and tipo_uri  = '#mydoc.datos.Servicios_list.row[i].home_tipo.xmlText#'
					and servicio = '#mydoc.datos.Servicios_list.row[i].servicio.xmlText#'
				</cfquery>
				<cfif rsDatos.RecordCount gt 0>
					<cfquery name="rsServicios" datasource="sdc">
						set nocount on
						update Servicios
						set home_uri   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mydoc.datos.Servicios_list.row[i].home_uri.xmlText#">,
							home_tipo  = <cfif len(trim(mydoc.datos.Servicios_list.row[i].home_tipo.xmlText)) gt 0 ><cfqueryparam cfsqltype="cf_sql_char" value="#mydoc.datos.Servicios_list.row[i].home_tipo.xmlText#"><cfelse>'J'</cfif>
						where servicio = <cfqueryparam cfsqltype="cf_sql_char" value="#mydoc.datos.Servicios_list.row[i].servicio.xmlText#">
						set nocount off
					</cfquery>
				</cfif>	
			</cfif>		
		</cfloop>
		<script language="javascript1.2" type="text/javascript">
			document.getElementById("proceso").innerHTML = "<img border='0' src='../../framework/imagenes/w-check.gif'>";
		</script>
		<!--- ========================================================================================================================== --->

 	<cfcatch type="any">
		<cfset error = true >
		<cfset number_error = 2 >
	</cfcatch>
	</cftry>
	</cftransaction>
</cfif>

<form action="Import.cfm" method="post">
	<table>
		<tr>
			<td align="center">
				<cfif error >
					<cfif number_error eq 2>
						<script language="javascript1.2" type="text/javascript">
							document.getElementById("tabla").bgColor = "#FFFFFF";
							document.getElementById("pct").innerHTML = "0%";

							document.getElementById("sistema").innerHTML 	 = "<img border='0' src='/cfmx/sif/framework/imagenes/Borrar01_S.gif'>";
							document.getElementById("modulo").innerHTML 	 = "<img border='0' src='/cfmx/sif/framework/imagenes/Borrar01_S.gif'>";
							document.getElementById("rol").innerHTML 		 = "<img border='0' src='/cfmx/sif/framework/imagenes/Borrar01_S.gif'>";
							document.getElementById("servicio").innerHTML    = "<img border='0' src='/cfmx/sif/framework/imagenes/Borrar01_S.gif'>";
							document.getElementById("serviciorol").innerHTML = "<img border='0' src='/cfmx/sif/framework/imagenes/Borrar01_S.gif'>";
							document.getElementById("proceso").innerHTML     = "<img border='0' src='/cfmx/sif/framework/imagenes/Borrar01_S.gif'>";
						</script>
						<b>Se presento un error al modificar datos.<br>Proceso de Importaci&oacute;n abortado.</b>
					<cfelse>
						<b>Error leyendo el archivo framework-app.xml. <br>Proceso de Importaci&oacute;n abortado.</b>
					</cfif>
				</cfif>
			</td>
		</tr>	
		<tr><td><input type="submit" name="Regresar" value="Regresar"></td></tr>
	</table>
</form>

<!---
<form action="Import.cfm" method="post">
	<cfif error >
		<input type="hidden" name="error" value="#number_error#">
	<cfelse>
		<input type="hidden" name="importar" value="ok">
	</cfif>
</form>

<HTML>
<head></head>
<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
--->