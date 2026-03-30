<cfif not isdefined("Form.Nuevo")>
	<!--- Agregar un criterio --->

	<cfif isdefined("Form.btnAceptar")>
		<!--- Busca si el criterio a insertar ya existe --->
		<cfquery name="rsInsCuentasSocios" datasource="#Session.DSN#">
			set nocount on
			if not exists (
				select * from CuentasSocios
				where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
				and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			)
			insert CuentasSocios (SNcodigo, CCTcodigo, Ecodigo, Ccuenta)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">
			)
			set nocount off
		</cfquery>
		<cfset modo="CAMBIO">

	<!--- Agregar una lista de precios al socio --->
	<cfelseif isdefined("Form.btnAceptarLista")>
		<!--- Busca si la lista de precios a insertar ya existe --->
		<cfquery name="rsInsListaPrecios" datasource="#Session.DSN#">
			set nocount on
			if not exists (
				select * from ListaPrecioSocio
				where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
				and LPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.LPid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			)
			insert ListaPrecioSocio (LPid, SNcodigo, Ecodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.LPid#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			)
			set nocount off
		</cfquery>
		<cfset modo="CAMBIO">

	<!--- Borrar una lista de precios del socio --->
	<cfelseif isdefined("Form.btnBorrar2.X")>
		<cfquery name="rsDelListaPrecios" datasource="#Session.DSN#">
			set nocount on
			delete from ListaPrecioSocio
			where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
			and LPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.datos2#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			set nocount off
		</cfquery>
		<cfset modo="CAMBIO">

	<!--- Borrar un criterio --->
	<cfelseif isdefined("Form.btnBorrar.X")>
		<cfquery name="rsDelCuentasSocios" datasource="#Session.DSN#">
			set nocount on
			delete from CuentasSocios
			where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
			  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.datos#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			set nocount off
		</cfquery>
		<cfset modo="CAMBIO">
	<cfelse>
		<cfif isdefined("form.Publicar") >
			<cfquery name="rsDatos" datasource="#session.DSN#">
				select SNnombre, SNdireccion, SNtelefono, SNFax, SNemail, SNidentificacion
				from SNegocios
				where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cftransaction>
				<cftry>
					<cfquery name="rsUsuario" datasource="sdc">
						set nocount on
						insert Usuario ( Ulocalizacion, Usutemporal,  Pnombre, Pid, BMUsucodigo, BMUlocalizacion, BMUsulogin, BMfechamod)
						values ( '00' , 
								 1, 
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.SNnombre#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.SNidentificacion#">,
								 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
								 <cfqueryparam cfsqltype="cf_sql_char"    value="#session.Ulocalizacion#">, 
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">, 
								 getDate() 
							   )
						select convert(varchar, @@identity) as Usucodigo
						set nocount off
					</cfquery>
						
					<cfquery name="rsInsertDatosUsuario" datasource="sdc">
						set nocount on

						-- UsuarioEmpresarial
						insert UsuarioEmpresarial (Usucodigo, Ulocalizacion, cliente_empresarial, admin, Pnombre, Papellido1, Papellido2, Ppais, TIcodigo, Pid, Pnacimiento, Psexo, Pemail1, Pemail2, Pdireccion, Pcasa, Poficina, Pcelular, Pfax, Ppagertel, Ppagernum, Pfoto, PfotoType, PfotoName, activo, BMUsucodigo, BMUlocalizacion, BMUsulogin, BMfechamod)
						select Usucodigo, Ulocalizacion, #session.CEcodigo#, 0, Pnombre, Papellido1, Papellido2, Ppais, TIcodigo, Pid, Pnacimiento, Psexo, Pemail1, Pemail2, Pdireccion, Pcasa, Poficina, Pcelular, Pfax, Ppagertel, Ppagernum, Pfoto, PfotoType, PfotoName, activo, BMUsucodigo, BMUlocalizacion, BMUsulogin, BMfechamod
						from Usuario
						where Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUsuario.Usucodigo#">
						  and Ulocalizacion='00'
	
						-- UsuarioEmpresa
						insert UsuarioEmpresa (Usucodigo, Ulocalizacion, cliente_empresarial, Ecodigo, activo , BMUsucodigo, BMUlocalizacion, BMUsulogin, BMfechamod)
						select Usucodigo, Ulocalizacion, cliente_empresarial, #session.EcodigoSDC#, activo, BMUsucodigo, BMUlocalizacion, BMUsulogin, BMfechamod
						from UsuarioEmpresarial
						where Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUsuario.Usucodigo#">
						  and Ulocalizacion='00'
						  and cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	
						-- UsuarioPermiso
						insert UsuarioPermiso(Usucodigo, Ulocalizacion, cliente_empresarial, Ecodigo, rol, activo, BMUsucodigo, BMUlocalizacion, BMUsulogin, BMfechamod)
						select Usucodigo, Ulocalizacion, cliente_empresarial, Ecodigo, 'sif.proveedor', activo, BMUsucodigo, BMUlocalizacion, BMUsulogin, BMfechamod
						from UsuarioEmpresa
						where Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUsuario.Usucodigo#">
						  and Ulocalizacion='00'
						  and cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">

						-- Actualiza Usucodigo en SNegocios
						update #trim(session.DSN)#..SNegocios
						set EUcodigo = #rsUsuario.Usucodigo#
						where SNcodigo=<cfqueryparam value="#form.SNcodigo#" cfsqltype="cf_sql_integer">

						set nocount off
					</cfquery>

				<cfcatch type="any">
					<cfinclude template="../../errorPages/BDerror.cfm">
					<cfabort>
				</cfcatch>	
				</cftry>
			</cftransaction>
			<cfset modo="CAMBIO">
		<cfelse> <!---  ELSE DE PUBLICAR O ROLES  --->
			<cftry>
				<cfquery name="SNegocios" datasource="#Session.DSN#">
					set nocount on
					<!--- Insercion del Socio de Negocios Generico, siempre lo hace --->
					if not exists( select 1 from SNegocios where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> and SNcodigo=9999 ) begin
						insert SNegocios ( Ecodigo, SNcodigo, SNidentificacion, SNtiposocio, SNnombre, SNFecha, SNtipo, SNnumero)
						values( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							   	9999,
   								'9999',         
   								'A', 
   								'Socio de Negocios Genérico', 
   								getDate(),    
   								'F', 
   								'999-9999')
					end

					<cfif isdefined("Form.Alta")>
						declare @cont int
						select @cont = isnull(max(SNcodigo),0)+1 from SNegocios where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer"> and SNcodigo <> 9999
						if @cont = 9999 begin
							select @cont = @cont + 1
						end

						insert SNegocios ( Ecodigo, SNcodigo, SNidentificacion, SNtiposocio, SNnombre, SNdireccion, SNtelefono, SNFax, SNemail, 
							               SNFecha, SNtipo, SNvencompras, SNvenventas, SNinactivo, SNactivoportal, SNnumero)
						values (	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> , 
									@cont,
									<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNidentificacion#">,
									<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNtiposocio#">, 
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNnombre#">, 
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNdireccion#">, 
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNtelefono#">, 
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNFax#">, 
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNemail#">, 
									<cfqueryparam value="#LSDateFormat(Form.SNFecha,'YYYYMMDD')#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNtipo#">, 
									<cfif len(trim(Form.SNvencompras)) EQ 0>
										null,
									<cfelse>
										<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNvencompras#">, 
									</cfif>
									<cfif len(trim(Form.SNvenventas)) EQ 0>
										null,
									<cfelse>
										<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNvenventas#">, 
									</cfif>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNinactivo#">,
									1,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNnumero#">
								)
						<cfset modo="ALTA">
					<cfelseif isdefined("Form.Baja")>
						delete from SNegocios
						where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
						<cfset modo="BAJA">
					<cfelseif isdefined("Form.Cambio")>
						update SNegocios set 
						SNidentificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNidentificacion#">, 
						SNtiposocio = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNtiposocio#"> , 
						SNnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNnombre#">, 
						SNdireccion =<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNdireccion#"> , 
						SNtelefono =<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNtelefono#"> , 
						SNFax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNFax#">, 
						SNemail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNemail#">, 
						SNFecha = <cfqueryparam value="#LSDateFormat(Form.SNFecha,'YYYYMMDD')#" cfsqltype="cf_sql_varchar">, 
						SNtipo =  <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNtipo#"> , 
						SNvencompras = 
						<cfif len(trim(Form.SNvencompras)) EQ 0>
						null,
						<cfelse>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNvencompras#">, 
						</cfif>
						SNvenventas = 
						<cfif len(trim(Form.SNvenventas)) EQ 0>
						null,
						<cfelse>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNvenventas#">, 
						</cfif>
						SNinactivo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNinactivo#">,
						SNactivoportal = <cfif isdefined("form.SNactivoportal")>1<cfelse>0</cfif>,
						SNnumero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNnumero#"> 
						where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">
						and timestamp = convert(varbinary,#lcase(Form.timestamp)#)				
						<cfset modo="CAMBIO">
					</cfif>
					set nocount off
				</cfquery>
			<cfcatch type="database">
				<cfinclude template="../../errorPages/BDerror.cfm">
				<cfabort>
			</cfcatch>
			</cftry>
		</cfif>	
	</cfif>
</cfif> <!--- nuevo --->

<form action="Socios.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif not isdefined("form.Nuevo") and not isdefined("form.Baja")>
		<input name="SNcodigo" type="hidden" value="<cfif isdefined("Form.SNcodigo")><cfoutput>#Form.SNcodigo#</cfoutput></cfif>">
	</cfif>	
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">		
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


