<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 14 de julio del 2005
	Motivo: Se agregó el envio de correos a los representantes de MiGestion.net en el momento 
			de que se hace una solicitud de demostracion. 
	Lineas: 153-208
 --->
<cfoutput>
	<!---Seteo de variables---->
	<cfset vigencia = 0>
	<cfset EmpDemo =''>

	<!----////////////////////// Creación de empresa /////////////////////----->
	<!---Datos de la cuenta empresarial---->
	<!---Trae el valor del parámetro del portal de vigencia del usuario de la demo, y Cuenta empresarial de la demo---->
	<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")><!---Inicializa el componente---->
	<cfset vigencia = Politicas.trae_parametro_global("demo.vigencia")><!---Ejecuta funcion que devuelve el valor---->
	<cfset EmpDemo =  Politicas.trae_parametro_global("demo.CuentaEmpresarial")>
	
	<cfquery name="rsCuentaEmpresarial" datasource="asp">
		select CEcodigo, id_direccion, rtrim(LOCIdioma) as LOCIdioma  
		from CuentaEmpresarial 
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EmpDemo#">
	</cfquery>

	<cfif isdefined("rsCuentaEmpresarial") and rsCuentaEmpresarial.recordcount NEQ 0><!----Si hay una cuenta empresarial para las demos definida en los parametros globales del portal---->		
		<cfquery name="ExisteUsuario" datasource="asp"><!---Verificar si ya existe ese usuario---->
			select 1
			from Usuario
			where Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail1#">
			and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaEmpresarial.CEcodigo#">
		</cfquery>

		<cfif isdefined("ExisteUsuario") and ExisteUsuario.RecordCount EQ 0><!----Si no existe el usuario: crea la empresa, el usuario y le asigna permisos según el producto que seleccionó---->		
			<cftransaction>
			<!---//////////////////// Creación de usuario /////////////////////////----->								
			<!---Insertado en datos personales---->
				<cfquery name="insertDPersonales" datasource="asp">
					insert into DatosPersonales(Pnombre, Papellido1, Papellido2, Pnacimiento, Psexo, 
								Pcasa, Poficina, Pcelular, Pfax, Ppagertel, Ppagernum, Pemail1, 
								Pemail2, Pweb, BMUsucodigo, BMfechamod)
					values(				
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnombre#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido1#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido2#">,
							null,null,null,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Poficina#">,
							null,
							<cfif isdefined("form.Pfax") and len(trim(form.Pfax))>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pfax#">
							<cfelse>
								null	
							</cfif>,
							null,null,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail1#">,
							null,null,0,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					)	
					<cf_dbidentity1 datasource="asp">		
				</cfquery>
				<cf_dbidentity2 datasource="asp" name="insertDPersonales">
				<!--- Insert en Direcciones--->
				<cfquery name="insertDirecciones" datasource="asp">
					insert into Direcciones(Ppais, atencion, direccion1, direccion2, ciudad, estado, codPostal, BMUsucodigo, BMfechamod)
					values(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppais#">,
							null,null,null,null,null,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Codpostal#">,
							0,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						)
					<cf_dbidentity1 datasource="asp">		
				</cfquery>
				<cf_dbidentity2 datasource="asp" name="insertDirecciones">
				<!---Insert en ReqInfo---->
				<cfquery name="insertReqInfo" datasource="asp">
					insert into ReqInfo(id_direccion, datos_personales, Rtipo, Rproducto, Rareacomercial, Rnombreemp, Rnumemp, Rescucho, Observaciones, Rrol, Mcodigo)
					values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#insertDirecciones.identity#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#insertDPersonales.identity#">,
							'D',
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Rproducto#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Rareacomercial#">,
							<cfif isdefined("form.Pnombreemp") and len(trim(form.Pnombreemp))>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnombreemp#">
							<cfelse>
								null
							</cfif>,					
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Rnumemp#">,
							<cfif isdefined("form.Rescucho") and len(trim(form.Rescucho))>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Rescucho#">
							<cfelse>
								null
							</cfif>,
							<cfif isdefined("form.Observaciones") and len(trim(form.Observaciones))>
								<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.Observaciones#">
							<cfelse>
								null
							</cfif>,
							<cfif isdefined("form.Rrol") and len(trim(form.Rrol))>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Rrol#">
							<cfelse>
								null
							</cfif>,
							<cfif isdefined("form.Mcodigo") and len(trim(form.Mcodigo))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#"><cfelse>null</cfif>
					)
					<cf_dbidentity1 datasource="asp">	
				</cfquery>
				<cf_dbidentity2 datasource="asp" name="insertReqInfo">

			<!--- email --->
			<cfsavecontent variable="email_body">
			<table width="80%" style="border:1px solid ##006699; " border="0" cellpadding="0" cellspacing="0" align="center">
			<!---<tr><td colspan="2" style=" height:69; background-image:url(../imagenes/01-02.jpg); background-repeat:repeat;"><img border="0" height="70" src="../imagenes/01-01.jpg"></td></tr>--->
			<tr>
			  <td colspan="2" bgcolor="##006699"><font color="##FFFFFF" face="Arial, Helvetica, sans-serif"><strong>Solicitud de acceso para la cuenta de Demos en MiGestion.net</strong></font></td>
			</tr>	
			<tr>
				<td width="30%" bgcolor="##E3EDEF"></td>
				<td>
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td style="padding-left:5px;">
								<p>
									<font face="Arial, Helvetica, sans-serif" size="2">
									Gracias por visitar MiGestion.net y solicitar un demo de nuestros productos.
									<br><br>En los pr&oacute;ximos d&iacute;as MiGestion.net va a estar en contacto con usted para brindarle 
									la clave de acceso a nuestros sistemas.
									<br><br>Administrador de Seguridad, <br>MiGestion.net
									</font>
								</p>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
				</td>
			</tr>
			</table>
			</cfsavecontent>
			</cftransaction>	

			<cfquery datasource="asp">
				insert into SMTPQueue(SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
				values ( 'gestion@soin.co.cr', 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail1#">,
						 'MiGestion.net: Solicitud de acceso a sistemas, versión demo.',
						 <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#email_body#">,
						 1	)
			</cfquery>
			<!--- ENVIO DE CORREOS PARA LOS ENCARGADOS DE LAS DEMOSTRACIONES, 
				  ESTOS ALMACENADOS EN TABLA NOTIFICACIONES --->
			<cfquery name="rsNotificaciones" datasource="asp">
				select email
				from Notificaciones
				where activo = 1
			</cfquery>

			<cfif isdefined('rsNotificaciones') and rsNotificaciones.RecordCount GT 0>
				<cfquery name="rsPais" datasource="asp">
					select Pnombre
					from Pais
					where Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ppais#">
				</cfquery>
				<cfquery name="rsMonedas" datasource="asp">
					select Mnombre
					from Moneda
					where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
				</cfquery>
				<cfsavecontent variable="Mensaje">
					<cfoutput>
					<html>
						<body>
							<font face="Arial, Helvetica, sans-serif" size="2">
							Representante de MiGestion.Net, el usuario #form.Pnombre# #form.Papellido1# #form.Papellido2# <br>
							el cual labora como #form.RRol# en la empresa #form.PNombreEmp#, #rsPais.Pnombre#, <br>
							solicita una demostración del producto <cfif form.RProducto EQ 'RH'>Soin - Recursos Humanos
							<cfelseif form.RProducto EQ 'SIF'>Soin - SIF<cfelseif form.RProducto EQ 'Educacion'>Soin - Educaci&oacute;n</cfif>.<br>
							<br>
							Por favor contactarlo al tel&eacute;fono #form.POficina#, al n&uacute;mero de fax #form.PFax#, <br>
							c&oacute;digo postal #form.CodPostal# o a la direcci&oacute;n electr&oacute;nica #form.Pemail1#.<br>
							<br>
 
 							La licencia sería para una cantidad de <cfif form.Rnumemp EQ 0>0-50<cfelseif form.Rnumemp EQ 50>50-100<cfelseif form.Rnumemp EQ 100>100-500<cfelseif form.Rnumemp EQ 500>500-1000<cfelseif form.Rnumemp EQ 1000>mas de 1000</cfif> personas.
							<br><br>
							Favor contactar al responsable de preparar las demostraciones y dar seguimiento a la solicitud.
							<br><br><strong>Administrador de Seguridad, <br>MiGestion.net</strong>
							</font>
						</body>
					</html>
					</cfoutput>
				</cfsavecontent>
				<cfloop query="rsNotificaciones">
					<cfquery datasource="asp">
						insert SMTPQueue (SMTPremitente, 
										  SMTPdestinatario, 
										  SMTPasunto, 
										  SMTPtexto, 
										  SMTPhtml )
						values (<cfqueryparam cfsqltype="cf_sql_varchar" value="gestion@soin.co.cr">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNotificaciones.email#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="Solicitud de Demostración de Producto">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">, 
								1)
					</cfquery>
				</cfloop>
			</cfif>
			
			<cflocation url="../DMgracias.cfm">
		<cfelse><!----Si ya esxiste el usuario---->
			<script type="text/javascript" language="javascript1.2">
				alert("El usuario (e-mail) ya existe.  Inténtelo de nuevo.")
				location.href = '../demos.cfm'
			</script>
		</cfif><!---Fin de if si ya existe el usuario ----->
	</cfif><!---Fin de if si hay una cuenta empresarial para las demos---->
</cfoutput>		