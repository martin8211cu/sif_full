<cfparam name="form.escorporativa" default="0">
<cfif isdefined("form.accion") and form.accion neq '3' >

	<cfif isdefined("form.logo") and Len(Trim(form.logo)) gt 0 >
		<cfinclude template="../utiles/imagen.cfm">
	</cfif>

	<cfif modo neq 'ALTA'>
		<!--- Modifica la direccion --->
		<cf_direccion action="readform" name="data" form="frmEmpresas">
		<cf_direccion action="update" key="#id_direccion#" name="data" form="frmEmpresas" data="#data#">
	
		<cfquery name="rs" datasource="asp">
			update Empresa
			set Mcodigo  	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
				Enombre 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Enombre#">,
				Etelefono1	= <cfif len(trim(form.Etelefono1)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Etelefono1#"><cfelse>null</cfif>,
				Etelefono2	= <cfif len(trim(form.Etelefono2)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Etelefono2#"><cfelse>null</cfif>,
				Efax		= <cfif len(trim(form.Efax)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Efax#"><cfelse>null</cfif>,
				Eidentificacion	= <cfif len(trim(form.Eidentificacion)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Eidentificacion#"><cfelse>null</cfif>,
				Enumero = <cfif len(trim(form.Enumero)) GT 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Enumero#"><cfelse>null</cfif>,
				BMfecha		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
				BMUsucodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> 
				<cfif isdefined("ts")>, Elogo = <cfqueryparam cfsqltype="cf_sql_blob" value="#tmp#"></cfif>
				,Eactividad = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Eactividad#">
				,Enumlicencia=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Enumlicencia#">
				,Eidresplegal=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Eidresplegal#">
                ,Iid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Iid#">
                ,ERepositorio = <cfif isdefined('form.contaElectronica')>1<cfelse>0</cfif> <!--- SML. Modificacion para saber si la empresa utiliza Contabilidad Electronica--->
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Empresa#">
		</cfquery>

		<cfif form.escorporativa EQ 1>
			<cfquery datasource="asp">
				update CuentaEmpresarial
				set Ecorporativa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Empresa#">
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
			</cfquery>
		<cfelse>
			<cfquery datasource="asp">
				update CuentaEmpresarial
				set Ecorporativa = null
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
				  and Ecorporativa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Empresa#">
			</cfquery>
		</cfif>
		<cfif IsDefined('form.auditar')>
			<cfinvoke component="asp.admin.bitacora.catalogos.PBitacoraEmp.activar" method="activarEmpresa" Ecodigo="#Form.Empresa#"/>
		<cfelse>
			<cfinvoke component="asp.admin.bitacora.catalogos.PBitacoraEmp.activar" method="inactivarEmpresa" Ecodigo="#Form.Empresa#"/>
		</cfif>

		<!--- Averiguar Codigo de Referencia, Moneda y Cache para la Empresa --->
		<cfquery name="rsNewEmpresa" datasource="asp">
			select b.Ccache, a.Ereferencia, a.Enombre
			from Empresa a, Caches b, Moneda c
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Empresa#">
			and a.Cid = b.Cid
		</cfquery>
		<cfset cache = rsNewEmpresa.Ccache>

		<!--- Actualizar empresa en base de datos referencia --->
		<cfif StructKeyExists(Application.dsinfo, cache) and Len(rsNewEmpresa.Ereferencia)>
			<cfquery name="rsEmpresa" datasource="#cache#">
				update Empresas
				   set Edescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNewEmpresa.Enombre#">,
				   EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Empresa#">,
				   cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
				 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNewEmpresa.Ereferencia#">
			</cfquery>
		</cfif>
	<cfelse>
		
		<!--- Inserta la direccion --->
		<cf_direccion action="readform" name="data" form="frmEmpresas">
		<cf_direccion action="insert" name="data" data="#data#" form="frmEmpresas">
	
		<!--- Inserta la Cuenta Empresarial, le asocia la direccion y el numero de cuenta --->
		<cfquery name="rsMaxEmpresa" datasource="asp">
			select coalesce(max(Ereferencia), 0)+1 as Ereferencia
			from Empresa		
		</cfquery>
		
		<cftransaction>

			<cfquery name="rs" datasource="asp">
				insert INTO  Empresa (CEcodigo, id_direccion, Cid, Mcodigo, Enombre, Etelefono1, Etelefono2, Efax, Ereferencia, Eidentificacion, BMfecha, BMUsucodigo, Elogo, Enumero
									,Eactividad,Enumlicencia,Eidresplegal,Iid,ERepositorio)<!--- SML. Modificacion para saber si la empresa utiliza Contabilidad Electronica--->
				values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_direccion#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Enombre#">,
						 <cfif len(trim(form.Etelefono1)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Etelefono1#"><cfelse>null</cfif>,
						 <cfif len(trim(form.Etelefono2)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Etelefono2#"><cfelse>null</cfif>,
						 <cfif len(trim(form.Efax)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Efax#"><cfelse>null</cfif>,
						 <cfif isdefined('rsMaxEmpresa') and rsMaxEmpresa.recordCount GT 0>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxEmpresa.Ereferencia#">,
						 <cfelse>
							null,
						 </cfif>
						 <cfif len(trim(form.Eidentificacion)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Eidentificacion#"><cfelse>null</cfif>,
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						 <cfif isdefined("ts")>
						 	<cfqueryparam cfsqltype="cf_sql_blob" value="#tmp#">
						 <cfelse>
								null
						 </cfif>,
						 <cfif len(trim(form.Enumero)) GT 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Enumero#"><cfelse>null</cfif>
						,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Eactividad#">
						,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Enumlicencia#">
						,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Eidresplegal#">
                        ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Iid#">
                        ,<cfif isdefined('form.contaElectronica')>1<cfelse>0</cfif>  <!--- SML. Modificacion para saber si la empresa utiliza Contabilidad Electronica--->
					   )
					   
				<cf_dbidentity1 datasource="asp">
			</cfquery>
			<cf_dbidentity2 datasource="asp" name="rs">

		</cftransaction>

		<cfif form.escorporativa EQ 1>
			<cfquery datasource="asp">
				update CuentaEmpresarial
				set Ecorporativa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.identity#">
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
			</cfquery>
		</cfif>

		<cfif Not IsDefined('form.auditar')>
			<cfinvoke component="asp.admin.bitacora.catalogos.PBitacoraEmp.activar" method="inactivarEmpresa" Ecodigo="#rs.identity#"/>
		</cfif>

		<!--- Averiguar Codigo de Referencia, Moneda y Cache para la Empresa --->
		<cfquery name="rsNewEmpresa" datasource="asp">
			select b.Ccache, a.Ereferencia, a.Enombre, c.Mnombre, Msimbolo, Miso4217
			from Empresa a, Caches b, Moneda c
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.identity#">
			and a.Cid = b.Cid
			and a.Mcodigo = c.Mcodigo
		</cfquery>

		<cfset cache = rsNewEmpresa.Ccache>

		<cfquery name="rsFindMoneda" datasource="#cache#">
			Select Mcodigo
			from Monedas
			where Miso4217=<cfqueryparam cfsqltype="cf_sql_char" value="#rsNewEmpresa.Miso4217#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNewEmpresa.Ereferencia#">
		</cfquery>
			
			<!--- NO existe la moneda en la base de datos de referencia --->		
			<cfif isdefined('rsFindMoneda') and rsFindMoneda.recordCount EQ 0>
			
				<cftransaction>
					<!--- Insertar moneda en la base de datos referencia --->
					<cfquery name="rsMoneda" datasource="#cache#">
						insert INTO  Monedas(Ecodigo, Mnombre, Msimbolo, Miso4217)
						values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNewEmpresa.Ereferencia#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNewEmpresa.Mnombre#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNewEmpresa.Msimbolo#">,
								 <cfqueryparam cfsqltype="cf_sql_char" value="#rsNewEmpresa.Miso4217#">
						)
						<cf_dbidentity1 datasource="#cache#">
					</cfquery>
					<cf_dbidentity2 datasource="#cache#" name="rsMoneda">
			
					<cfquery name="rsFindEmpresa" datasource="#cache#">
						Select Ecodigo
						from Empresas
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNewEmpresa.Ereferencia#">
					</cfquery>	
					
					<!--- NO existe la Empresa en la base de datos de referencia --->		
					<cfif isdefined('rsFindEmpresa') and rsFindEmpresa.recordCount EQ 0>
						<!--- Insertar la empresa en la base de datos referencia --->
						<cfquery name="rsEmpresa" datasource="#cache#">
							insert INTO  Empresas(Ecodigo, Mcodigo, Edescripcion, Elocalizacion, Ecache, Usucodigo, Ulocalizacion, cliente_empresarial, EcodigoSDC)
							values ( 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNewEmpresa.Ereferencia#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMoneda.identity#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNewEmpresa.Enombre#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="00">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#cache#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.identity#">
							)
						</cfquery>
					</cfif>
				</cftransaction>
			</cfif>
	</cfif>
<cfelse>
	<!--- Averiguar si hay que chequear en la otra base de datos --->
	<cfquery name="rs_id_direccion" datasource="asp">
		select id_direccion
		from Empresa
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Empresa#">
	</cfquery>
	
	<cfquery name="rs_delEmpresa" datasource="asp">
		delete from PBitacoraEmp
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Empresa#">
	</cfquery>


	<cfquery datasource="asp">
		update CuentaEmpresarial
		set Ecorporativa = null
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
		  and Ecorporativa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Empresa#">
	</cfquery>
		
	<cfquery name="rs_delEmpresa" datasource="asp">
		delete from Empresa
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Empresa#">	
	</cfquery>

	<cfif isdefined('rs_id_direccion')	and rs_id_direccion.recordCount GT 0 and rs_id_direccion.id_direccion NEQ ''>
		<cfquery name="rs" datasource="asp">
			delete from Direcciones
			where id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_id_direccion.id_direccion#">
		</cfquery>
	</cfif>
</cfif>	

<cfif isdefined("form.accion")>
	<cfif form.accion eq 1>
		<cflocation url="/cfmx/asp/catalogos/Usuarios.cfm">
	<cfelseif form.accion EQ 2 or form.accion EQ 3>
		<cflocation url="/cfmx/asp/catalogos/Empresas.cfm">
	</cfif>
</cfif>
