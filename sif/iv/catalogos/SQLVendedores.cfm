<cfset params="">
<cfif isdefined("Form.Alta")>
	<cfquery name="rsExiste" datasource="#Session.DSN#">
		Select 1
		from ESVendedores 
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and ESVcodigo=<cfqueryparam  value="#Form.ESVcodigo#" cfsqltype="cf_sql_varchar">
	</cfquery>
	
	<cfif rsExiste.recordcount GT 0>
		<cf_errorCode	code = "50402" msg = "El registro que desea ingresar ya existe, por favor digite un código diferente">
		<cflocation url="vendedores.cfm">
	</cfif>

</cfif>
<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cftransaction>
			<cfquery name="rsInsert" datasource="#Session.DSN#">
				insert into ESVendedores 
				(Ecodigo, Ocodigo, ESVcodigo, NTIcodigo, ESVidentificacion, ESVnombre, ESVapellido1, ESVapellido2, ESVdireccion
					, ESVtelefono1, ESVtelefono2, ESVemail, ESVcivil, ESVfechanac, ESVsexo, ESVobs1, ESVobs2, Ppais, ESVfingresoLab
					, BMUsucodigo, BMfechaalta)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESVcodigo#">
					, <cfqueryparam cfsqltype="cf_sql_char" value="#Form.NTIcodigo#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESVidentificacion#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESVnombre#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESVapellido1#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESVapellido2#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESVdireccion#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESVtelefono1#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESVtelefono2#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESVemail#">
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ESVcivil#">
					, <cfqueryparam value="#LSParsedateTime(form.ESVfechanac)#" cfsqltype="cf_sql_timestamp">
					, <cfqueryparam cfsqltype="cf_sql_char" value="#Form.ESVsexo#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESVobs1#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESVobs2#">
					<cfif isdefined('Form.Ppais') and Form.Ppais NEQ ''>
						, <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ppais#">
					<cfelse>
						, null					
					</cfif>
					, <cfqueryparam value="#LSParsedateTime(form.ESVfingresoLab)#" cfsqltype="cf_sql_timestamp">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
				 <cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>	
			<cf_dbidentity2 datasource="#session.DSN#" name="rsInsert"> 	   
		</cftransaction>
		<cfset Form.ESVid = rsInsert.identity>
		<cfset params= params&'&ESVid='&form.ESVid>
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete from ESVendedores
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and ESVid = <cfqueryparam value="#Form.ESVid#" cfsqltype="cf_sql_numeric">
		</cfquery>
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
						table="ESVendedores"
						redirect="vendedores.cfm"
						timestamp="#form.ts_rversion#"				
						field1="Ecodigo" 
						type1="integer" 
						value1="#session.Ecodigo#"
						field2="ESVid" 
						type2="numeric" 
						value2="#form.ESVid#">

		<cfquery name="update" datasource="#Session.DSN#">
			update ESVendedores set
				 Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">
				, ESVcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESVcodigo#">
				, NTIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.NTIcodigo#">
				, ESVidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESVidentificacion#">
				, ESVnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESVnombre#">
				, ESVapellido1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESVapellido1#">
				, ESVapellido2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESVapellido2#">
				, ESVdireccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESVdireccion#">
				, ESVtelefono1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESVtelefono1#">
				, ESVtelefono2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESVtelefono2#">
				, ESVemail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESVemail#">
				, ESVcivil = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ESVcivil#">
				, ESVfechanac = <cfqueryparam value="#LSParsedateTime(form.ESVfechanac)#" cfsqltype="cf_sql_timestamp">
				, ESVsexo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.ESVsexo#">
				, ESVobs1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESVobs1#">
				, ESVobs2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESVobs2#">
				, Ppais = <cfif isdefined('Form.Ppais') and Form.Ppais NEQ ''><cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ppais#"><cfelse>null</cfif>
				, ESVfingresoLab = <cfqueryparam value="#LSParsedateTime(form.ESVfingresoLab)#" cfsqltype="cf_sql_timestamp">
				, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and ESVid = <cfqueryparam value="#Form.ESVid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfset params= params&'&ESVid='&form.ESVid>
	</cfif>
</cfif>

<cfif isdefined("Form.Nuevo")>
	<cfset params= params&'&btnNuevo=btnNuevo'>	
</cfif>
<cfif isdefined('form.filtro_ESVcodigo') and form.filtro_ESVcodigo NEQ ''>
	<cfset params= params&'&filtro_ESVcodigo='&form.filtro_ESVcodigo>	
	<cfset params= params&'&hfiltro_ESVcodigo='&form.filtro_ESVcodigo>		
</cfif>
<cfif isdefined('form.filtro_nombreVend') and form.filtro_nombreVend NEQ ''>
	<cfset params= params&'&filtro_nombreVend='&form.filtro_nombreVend>	
	<cfset params= params&'&hfiltro_nombreVend='&form.filtro_nombreVend>	
</cfif>
<cfif isdefined('form.filtro_ESVidentificacion') and form.filtro_ESVidentificacion NEQ ''>
	<cfset params= params&'&filtro_ESVidentificacion='&form.filtro_ESVidentificacion>	
	<cfset params= params&'&hfiltro_ESVidentificacion='&form.filtro_ESVidentificacion>	
</cfif>				

<cflocation url="vendedores.cfm?Pagina=#Form.Pagina##params#">

