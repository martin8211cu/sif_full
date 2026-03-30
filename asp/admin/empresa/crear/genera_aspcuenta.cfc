<cfcomponent output="no">
<cffunction name="crear" output="false" returntype="numeric">
	<cfargument name="Mcodigo" type="numeric" required="yes">
	<cfargument name="LOCidioma" type="string" required="yes">
	<cfargument name="CEnombre" type="string" required="yes">
	<cfargument name="CEaliaslogin" type="string" required="yes">
	<cfargument name="CEtelefono1" type="string" required="yes">
	<cfargument name="CEtelefono2" type="string" required="yes">
	<cfargument name="CEfax" type="string" required="yes">
	<cfargument name="Cid" type="numeric" required="yes">
	<cfargument name="logoblob" type="binary" required="yes">

	<cfif Len(Trim(Arguments.CEaliaslogin))>
		<cfquery name="data" datasource="asp">
			select CEaliaslogin 
			from CuentaEmpresarial
			where CEaliaslogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.CEaliaslogin)#">
		</cfquery>
		<cfif data.recordCount gt 0 >
			<cfthrow message="El alias de login solicitado para la cuenta ya está reservado.">
		</cfif>
	</cfif>
	
	<!--- Inserta la dirección --->
	<cf_direccion action="readform" name="data">
	<cf_direccion action="insert" name="data" data="#data#">

	<cfquery name="rsCodigoPais" datasource="asp">
		select CPcodigo
		from CPais
		where Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#data.Pais#">
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
	<cfquery name="rs" datasource="asp">
		insert INTO CuentaEmpresarial (id_direccion, Mcodigo, LOCIdioma, CEaliaslogin, CEnombre, CEcuenta, CEtelefono1, CEtelefono2, CEfax, CEcontrato, BMfecha, BMUsucodigo, CElogo )
		values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_direccion#">,
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#">,
				 <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LOCIdioma#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CEaliaslogin#" null="#Len(Trim(Arguments.CEaliaslogin)) Is 0#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CEnombre#">,
				 <cfqueryparam cfsqltype="cf_sql_char" value="#code#">,
				 <cfif len(trim(Arguments.CEtelefono1)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CEtelefono1#"><cfelse>null</cfif>,
				 <cfif len(trim(Arguments.CEtelefono2)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CEtelefono2#"><cfelse>null</cfif>,
				 <cfif len(trim(Arguments.CEfax)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CEfax#"><cfelse>null</cfif>,
				 null,
				 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				 <cfif Len(form.logo)>
				 <cfqueryparam cfsqltype="cf_sql_blob" value="#Arguments.logoblob#">
				 <cfelse>null
				 </cfif>
			   )
	  <cf_dbidentity1 verificar_transaccion="false" datasource="asp">
	</cfquery>
	<cf_dbidentity2 verificar_transaccion="false" datasource="asp" name="rs">
	
	<cfquery datasource="asp">
		insert into ModulosCuentaE (CEcodigo, SScodigo, SMcodigo)
		select <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.identity#">,
			SScodigo, SMcodigo
		from SModulos
		where SScodigo = 'aspweb' and SMcodigo not in('aspweb_tes')
	</cfquery>
	
	<cfquery datasource="asp">
		insert into CECaches (CEcodigo, Cid, BMfecha, BMUsucodigo)
		values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.identity#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Cid#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
	</cfquery>
	
	<cfreturn rs.identity>
</cffunction>
</cfcomponent>