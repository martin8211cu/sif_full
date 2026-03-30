<cfif isdefined("form.accion") and form.accion neq '3' >

	<cfif isdefined("form.logo") and Len(Trim(form.logo)) gt 0 >
		<cfinclude template="../utiles/imagen.cfm">
	</cfif>

	<cfif modo neq 'ALTA'>
		<!--- Modifica la direccion --->
		<cf_direccion action="readform" name="data">
		<cf_direccion action="update" key="#id_direccion#" name="data" data="#data#">
	
		<cfquery name="rs" datasource="asp_oracle">
			update Empresa
			set Mcodigo  	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
				Enombre 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Enombre#">,
				Etelefono1	= <cfif len(trim(form.Etelefono1)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Etelefono1#"><cfelse>null</cfif>,
				Etelefono2	= <cfif len(trim(form.Etelefono2)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Etelefono2#"><cfelse>null</cfif>,
				Efax		= <cfif len(trim(form.Efax)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Efax#"><cfelse>null</cfif>,
				Eidentificacion	= <cfif len(trim(form.Eidentificacion)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Eidentificacion#"><cfelse>null</cfif>,
				BMfecha		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
				BMUsucodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> 
				<cfif isdefined("ts")>, Elogo = #ts#</cfif>
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Empresa#">
		</cfquery>

		<!--- Averiguar Codigo de Referencia, Moneda y Cache para la Empresa --->
		<cfquery name="rsNewEmpresa" datasource="asp_oracle">
			select b.Ccache, a.Ereferencia, a.Enombre
			from Empresa a, Caches b, Moneda c
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Empresa#">
			and a.Cid = b.Cid
		</cfquery>
		<cfset cache = rsNewEmpresa.Ccache>

		<!--- Actualizar empresa en base de datos referencia --->
		<cfquery name="rsEmpresa" datasource="#cache#">
			update Empresas
			   set Edescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNewEmpresa.Enombre#">
			 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNewEmpresa.Ereferencia#">
		</cfquery>
	<cfelse>
		<!--- Inserta la direccion --->
		<cf_direccion action="readform" name="data">
		<cf_direccion action="insert" name="data" data="#data#">
	
		<!--- Inserta la Cuenta Empresarial, le asocia la direccion y el numero de cuenta --->
		<cfquery name="rs" datasource="asp_oracle">
			declare @referencia numeric
			select @referencia = coalesce(max(Ereferencia), 0)+1 from Empresa
			
			insert INTO  Empresa (CEcodigo, id_direccion, Cid, Mcodigo, Enombre, Etelefono1, Etelefono2, Efax, Ereferencia, Eidentificacion, BMfecha, BMUsucodigo, Elogo)
			values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_direccion#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Enombre#">,
					 <cfif len(trim(form.Etelefono1)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Etelefono1#"><cfelse>null</cfif>,
					 <cfif len(trim(form.Etelefono2)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Etelefono2#"><cfelse>null</cfif>,
					 <cfif len(trim(form.Efax)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Efax#"><cfelse>null</cfif>,
					 @referencia, 
					 <cfif len(trim(form.Eidentificacion)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Eidentificacion#"><cfelse>null</cfif>,
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					 <cfif isdefined("ts")>#ts#<cfelse>null</cfif>
				   )
				   
			select convert(varchar, @@identity) as Ecodigo
		</cfquery>
		
		<!--- Averiguar Codigo de Referencia, Moneda y Cache para la Empresa --->
		<cfquery name="rsNewEmpresa" datasource="asp_oracle">
			select b.Ccache, a.Ereferencia, a.Enombre, c.Mnombre, Msimbolo, Miso4217
			from Empresa a, Caches b, Moneda c
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.Ecodigo#">
			and a.Cid = b.Cid
			and a.Mcodigo = c.Mcodigo
		</cfquery>
		<cfset cache = rsNewEmpresa.Ccache>
		
		<cftransaction>
			<!--- Insertar moneda en la base de datos referencia --->
			<cfquery name="rsMoneda" datasource="#cache#">
				insert INTO  Monedas(Ecodigo, Mnombre, Msimbolo, Miso4217)
				values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNewEmpresa.Ereferencia#">,
					     <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNewEmpresa.Mnombre#">,
					     <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNewEmpresa.Msimbolo#">,
					     <cfqueryparam cfsqltype="cf_sql_char" value="#rsNewEmpresa.Miso4217#">
				)
				select convert(varchar, @@identity) as Mcodigo
			</cfquery>

			<!--- Insertar la empresa en la base de datos referencia --->
			<cfquery name="rsEmpresa" datasource="#cache#">
				insert INTO  Empresas(Ecodigo, Mcodigo, Edescripcion, Elocalizacion, Ecache, Usucodigo, Ulocalizacion, cliente_empresarial, EcodigoSDC)
				values ( 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNewEmpresa.Ereferencia#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMoneda.Mcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNewEmpresa.Enombre#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="00">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cache#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.Ecodigo#">
				)
			</cfquery>
		</cftransaction>
	</cfif>
<cfelse>
	<cfquery name="rs" datasource="asp_oracle">
		<!--- Averiguar si hay que chequear en la otra base de datos --->
		declare @id_direccion numeric

		select @id_direccion = id_direccion
		from Empresa
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Empresa#">

		delete Empresa
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Empresa#">
		
		delete Direcciones
		where id_direccion = @id_direccion
	</cfquery>
</cfif>	

<cfif isdefined("form.accion")>
	<cfif form.accion eq 1>
		<cflocation url="/cfmx/asp/catalogos/Usuarios.cfm">
	<cfelseif form.accion EQ 2 or form.accion EQ 3>
		<cflocation url="/cfmx/asp/catalogos/Empresas.cfm">
	</cfif>
</cfif>
