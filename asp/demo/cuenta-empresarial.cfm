	<!--- 1.1 Inserta la direccion --->
	<cfquery name="pais" datasource="asp" maxrows="1">
		select Ppais 
		from Pais
		where Ppais >= 'CR'
	</cfquery>
	<cfif pais.recordcount eq 0 >
		<cfthrow message="Error. No se puede asociar el pa&iacute;s a la Cuenta Empresarial.">
	</cfif>
	<cfquery name="direccion" datasource="asp">
		insert INTO Direcciones( atencion, direccion1, ciudad, estado, codPostal, Ppais, BMUsucodigo, BMfechamod )
		values ( 'Marcel de Mezérville',
				 'Parque Empresarial Forum',
				 'Santa Ana',
				 'San José',
				 '901-6155',
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#pais.Ppais#">,
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> )
		<cf_dbidentity1 datasource="asp">
	</cfquery>
	<cf_dbidentity2 datasource="asp" name="direccion">

	<!--- 1.2 Calcula Codigo de Pais/ CEcuenta --->
	<!--- 1.2.1 Codigo de Pais--->
	<cfset codigo_pais = '00000'>
	<cfquery name="rsCodigoPais" datasource="asp">
		select CPcodigo
		from CPais
		where Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#pais.Ppais#">
	</cfquery>
	<cfif rsCodigoPais.RecordCount gt 0>
		<cfset codigo_pais = Mid(NumberFormat(trim(rsCodigoPais.CPcodigo),'00000'),1,5) >
	</cfif>

	<!--- 1.2.2 CEcuenta --->
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

	<!--- 1.3 Calcula la moneda--->
	<cfquery name="moneda" datasource="asp" maxrows="1">
		select Mcodigo from Moneda where upper(Miso4217) >= 'CRC'
	</cfquery>
	<cfif moneda.recordcount eq 0 >
		<cfthrow message="Error. No se puede asociar la moneda a la Cuenta Empresarial.">
	</cfif>

	<!--- 1.4 Valida que el alias de la cuenta sea unico --->
	<cfquery name="alias" datasource="asp">
		select CEaliaslogin 
		from CuentaEmpresarial
		where upper(CEaliaslogin) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(alias_cuenta)#">
	</cfquery>
	<cfif alias.recordcount gt 0 >
		<cfthrow message="Error. Ya existe una cuenta empresarial definida para demostraciones.">
	</cfif>

	<!--- Inserta la Cuenta Empresarial, le asocia la direccion y el numero de cuenta --->
	<cfquery name="cuenta" datasource="asp">
		insert INTO CuentaEmpresarial (id_direccion, Mcodigo, LOCIdioma, CEaliaslogin, CEnombre, CEcuenta, CEtelefono1, CEtelefono2, CEfax, CEcontrato, BMfecha, BMUsucodigo, CElogo )
		values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#direccion.identity#">,
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#moneda.Mcodigo#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#idioma#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#alias_cuenta#">,
				 'Demostraciones',
				 <cfqueryparam cfsqltype="cf_sql_char" value="#code#">,
				 '204-7151',
				 '204-7151',
				 '204-7155',
				 null,
				 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				null )
	  <cf_dbidentity1 datasource="asp">
	</cfquery>
	<cf_dbidentity2 datasource="asp" name="cuenta">