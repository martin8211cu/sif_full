<cfif isdefined("form.BTNMODIFICAR")>
	<cfquery  datasource="#session.DSN#">
		update Empresas
			set
				  ETelefono1 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETelefono1#" null="#Len(trim(form.ETelefono1)) eq 0#">
				, ETelefono2 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETelefono2#" null="#Len(trim(form.ETelefono2)) eq 0#">
				, EDireccion1 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EDireccion1#" null="#Len(trim(form.EDireccion1)) eq 0#">
				, EDireccion2 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EDireccion2#" null="#Len(trim(form.EDireccion2)) eq 0#">
				, EDireccion3 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EDireccion3#" null="#Len(trim(form.EDireccion3)) eq 0#">
				, EIdentificacion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EIdentificacion#" null="#Len(trim(form.EIdentificacion)) eq 0#">
				, NumExt			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NumExt#" null="#Len(Trim(form.NumExt)) eq 0#">
				, NumInt			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NumInt#" null="#Len(Trim(form.NumInt)) eq 0#">
				, Colonia			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Colonia#" null="#Len(Trim(form.Colonia)) eq 0#">
				, Localidad			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Localidad#" null="#Len(Trim(form.Localidad)) eq 0#">
				, Referencia 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Referencia#" null="#Len(Trim(form.Referencia)) eq 0#">
				<cfif isdefined("Form.SNDirFisc")>
					<cfif form.SNDirFisc eq 'on'>
						, DirecFisc	= <cfqueryparam cfsqltype="cf_sql_bit" value="1">
					<cfelse>
						, DirecFisc	= <cfqueryparam cfsqltype="cf_sql_bit" value="0">
					</cfif>
				<cfelse>
					, DirecFisc		= <cfqueryparam cfsqltype="cf_sql_bit" value="0">
				</cfif>
				, Estado	 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Estado#" null="#Len(Trim(form.Estado)) eq 0#">
				, Pais				= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pais#" null="#Len(Trim(form.Pais)) eq 0#">
				, Calle 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Calle#" null="#len(trim(form.Calle)) eq 0#">
				, Delegacion 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Delegacion#" null="#Len(Trim(form.Delegacion)) eq 0#">
				, CodPostal			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CodPostal#" null="#Len(Trim(form.CodPostal)) eq 0#">
		where Ecodigo = #form.Ecodigo#
	</cfquery>
</cfif>

<cflocation addtoken="no" url="DatosEmpresas.cfm?Ecodigos=#form.Ecodigo#">