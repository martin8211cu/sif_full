<cfif isdefined("form.accion") and form.accion neq '3'>
<cfset Request.Error.Backs = 1>

	<cffunction name="validaAlias" returntype="boolean">
		<cfargument name="CEcodigo" required="yes" type="numeric">
		<cfargument name="alias" required="yes" type="string">
		
		<cfquery name="data" datasource="asp">
			select CEaliaslogin 
			from CuentaEmpresarial
			where CEaliaslogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.alias)#">
			  and CEcodigo <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CEcodigo#">
		</cfquery>
		
		<cfif data.recordCount gt 0 >
			<cfreturn false>
		<cfelse>	
			<cfreturn true>
		</cfif>
		
	</cffunction>

	<cfif isdefined("form.logo") and Len(Trim(form.logo)) gt 0 >
		<cfinclude template="../utiles/imagen.cfm">
	</cfif>

	<cfif modo neq 'ALTA'>
		<!--- valida que el alias del acuenta sea unico --->
		<cfif len(trim(form.CEaliaslogin))>
			<cfif not validaAlias(form.CEcodigo, form.CEaliaslogin) >
				<cfthrow message="Error. El alias de Cuenta Empresarial seleccionado est&aacute; asociado a otra cuenta.">
			</cfif>
		</cfif>

		<!--- Modifica la direccion --->
		<cf_direccion action="readform" name="data">
		<cf_direccion action="update" key="#id_direccion#" name="data" data="#data#">
	
		<cfquery name="rs" datasource="asp">
			update CuentaEmpresarial
			set Mcodigo  	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
				LOCIdioma  	= <cfqueryparam cfsqltype="cf_sql_char" value="#form.LOCIdioma#">,
				CEaliaslogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CEaliaslogin#">,
				CEnombre 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CEnombre#">,
				CEtelefono1 = <cfif len(trim(form.CEtelefono1)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CEtelefono1#"><cfelse>null</cfif>,
				CEtelefono2 = <cfif len(trim(form.CEtelefono2)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CEtelefono2#"><cfelse>null</cfif>,
				CEfax		= <cfif len(trim(form.CEfax)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CEfax#"><cfelse>null</cfif>
				<cfif isdefined("ts")>, CElogo = <cfqueryparam cfsqltype="cf_sql_blob" value="#tmp#"></cfif>
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CEcodigo#">
		</cfquery>
		<cfset Cuenta = Form.CEcodigo>
	<cfelse>
		<!--- Inserta la direccion --->
		<cf_direccion action="readform" name="data">
		<cf_direccion action="insert" name="data" data="#data#">

		<cfquery name="rsCodigoPais" datasource="asp">
			select CPcodigo
			from CPais
			where Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#form.pais#">
		</cfquery>
	
		<cfif rsCodigoPais.RecordCount eq 0>
			<cfset codigo_pais = '00000'>
		<cfelse>
			<cfset codigo_pais = Mid(NumberFormat(trim(rsCodigoPais.CPcodigo),'00000'),1,5) >
		</cfif>
	
		<cfquery name="rsCuentaOrder" datasource="asp">
			select CEcuenta
			from CuentaEmpresarial a
			where a.CEcuenta like '#codigo_pais#-%'
				and ({fn LENGTH({fn RTRIM(a.CEcuenta)}  )}) - 6 = 5
			order by a.CEcuenta desc
		</cfquery>		
	
		<cfif isdefined('rsCuentaOrder') and rsCuentaOrder.recordCount GT 0>
			<cfset varNewCuenta = "">
			<cfset concatenar = "">			
			<cfloop query="rsCuentaOrder">
				<cfset varNewCuenta = MID(Trim(rsCuentaOrder.CEcuenta),7,5) >
					<cfif Isnumeric(varNewCuenta)>
						<cfset varNewCuenta = varNewCuenta + 1>
						<cfif Len(varNewCuenta) LT 5>
							<cfset cantCeros = 5 - (Len(varNewCuenta))>

							<cfloop index = "LoopCount" from = "1" to = #cantCeros#>
								<cfset concatenar = concatenar & '0'>
							</cfloop>
						</cfif>
						<cfset varNewCuenta = Insert(concatenar,varNewCuenta,0)>
						<cfbreak>
					</cfif>
			</cfloop>
		</cfif>		
		
		<cfif isdefined('varNewCuenta') and varNewCuenta NEQ ''>
			<cfset code = codigo_pais & '-' & NumberFormat(varNewCuenta,'00000')>
		<cfelse>
			<cfset code = codigo_pais & '-00001'>
		</cfif>
		
		<!--- Inserta la Cuenta Empresarial, le asocia la direccion y el numero de cuenta --->
		<cfif isdefined('data') and data.id_direccion NEQ ''>
			<cftransaction>
				<cfquery name="rs" datasource="asp">
					insert INTO CuentaEmpresarial (id_direccion, Mcodigo, LOCIdioma, CEaliaslogin, CEnombre, CEcuenta, CEtelefono1, CEtelefono2, CEfax, CEcontrato, BMfecha, BMUsucodigo, CElogo )
					values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_direccion#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#form.LOCIdioma#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CEaliaslogin#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CEnombre#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#code#">,
							 <cfif len(trim(form.CEtelefono1)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CEtelefono1#"><cfelse>null</cfif>,
							 <cfif len(trim(form.CEtelefono2)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CEtelefono2#"><cfelse>null</cfif>,
							 <cfif len(trim(form.CEfax)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CEfax#"><cfelse>null</cfif>,
							 null,
							 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							 <cfif isdefined("ts")>
							 	<cfqueryparam cfsqltype="cf_sql_blob" value="#tmp#">
							 <cfelse>
							 	null
							 </cfif>
						   )
				  <cf_dbidentity1 datasource="asp">
				</cfquery>
				<cf_dbidentity2 datasource="asp" name="rs">
				
				<!--- valida que el alias del acuenta sea unico --->
				<cfif len(trim(form.CEaliaslogin))>
					<cfif not validaAlias(rs.identity, form.CEaliaslogin) >
						<cfthrow message="Error. El alias de Cuenta Empresarial seleccionado est&aacute; asociado a otra cuenta.">
					</cfif>
				</cfif>	

			</cftransaction>		
			
			<cfif isdefined('rs') and rs.recordCount GT 0>
				<cfset Cuenta = rs.identity>			
			</cfif>
		</cfif>

	</cfif>
<cfelseif Form.CEcodigo NEQ 1>
	<cfquery name="rsDireccion" datasource="asp">
		select id_direccion
		from CuentaEmpresarial
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEcodigo#">	
	</cfquery>
	<cfquery name="delCECaches" datasource="asp">
		delete from CECaches
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEcodigo#">	
	</cfquery>	
	<cfquery name="delCaches" datasource="asp">
		delete from Caches
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEcodigo#">
		and Cexclusivo = 1	
	</cfquery>	
	<cfquery name="delModulosCuentaE" datasource="asp">
		delete from ModulosCuentaE
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEcodigo#">	
	</cfquery>	
	<cfquery name="delCuentaEmpresarial" datasource="asp">
		delete from CuentaEmpresarial
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEcodigo#">
	</cfquery>	
	
	<cfif isdefined('rsDireccion') and rsDireccion.recordCount GT 0>
		<cfquery name="delDirecciones" datasource="asp">
			delete from Direcciones
			where id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDireccion.id_direccion#">
		</cfquery>	
	</cfif>
</cfif>	

<cfif isdefined("form.accion")>
	<cfif form.accion eq 1>
		<cfif isdefined('Cuenta')>
			<cfset Session.Progreso.CEcodigo = Cuenta>
			<cflocation url="/cfmx/asp/catalogos/Modulos.cfm">
		<cfelse>
			<cfset StructDelete(Session.Progreso, "CEcodigo")>
			<cflocation url="/cfmx/asp/catalogos/Cuentas.cfm">			
		</cfif>
	<cfelseif form.accion eq 2>
		<cfset StructDelete(Session.Progreso, "CEcodigo")>
		<cflocation url="/cfmx/asp/catalogos/Cuentas.cfm">
	<cfelseif form.accion eq 3>
		<cfset StructDelete(Session.Progreso, "CEcodigo")>
		<cflocation url="/cfmx/asp/catalogos/Cuentas.cfm">
	</cfif>
</cfif>
