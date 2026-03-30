<cfif not isdefined("Form.Nuevo") >
	<cfif isdefined("Form.Alta")>
		<cfquery name="rsExiste" datasource="#session.DSN#">
			select 1 
			from CTipoRequisicion
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			and Dcodigo = <cfqueryparam value="#Form.Dcodigo#" cfsqltype="cf_sql_integer">
			and TRcodigo = <cfqueryparam value="#Form.TRcodigo#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfif rsExiste.recordCount gt 0>
			<cfquery name="update" datasource="#session.DSN#">
				update CTipoRequisicion
				set Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#" >,
                CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuenta#" > 
				where Dcodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#" >
				  and TRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TRcodigo#" >
				  and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >	
			</cfquery>
		<cfelse>
			<cfquery name="insert" datasource="#session.DSN#">
			insert into CTipoRequisicion ( Ecodigo, Dcodigo, TRcodigo, Ccuenta,CFcuenta )
			values( <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">, 
					<cfqueryparam value="#Form.Dcodigo#" cfsqltype="cf_sql_integer">, 
					<cfqueryparam value="#Form.TRcodigo#" cfsqltype="cf_sql_varchar">, 
					<cfqueryparam value="#Form.Ccuenta#" cfsqltype="cf_sql_numeric">,
                    <cfqueryparam value="#Form.CFcuenta#" cfsqltype="cf_sql_numeric">)
			</cfquery>
		</cfif>

	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#session.DSN#">
			delete from CTipoRequisicion
			where Dcodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#" >
			and TRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TRcodigo#" >
			and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >	
		</cfquery>

	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="CTipoRequisicion" 
			redirect="CTipoRequisicion.cfm"
			timestamp="#form.ts_rversion#"
			field1="TRcodigo"
			type1="char"
			value1="#form.TRcodigo#"

			field2="Dcodigo"
			type2="integer"
			value2="#form.Dcodigo#"

			field3="Ecodigo"
			type3="integer"
			value3="#session.Ecodigo#" >

		<cfquery name="update" datasource="#session.DSN#">
			update CTipoRequisicion
			set Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#" >,
            CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuenta#" >
			where Dcodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#" >
			  and rtrim(TRcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.TRcodigo)#" >
			  and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >	
		</cfquery>
	</cfif>
</cfif>

<cfset params="">
<cfif not isdefined('form.Nuevo') and not isdefined('form.Baja') >
	<cfif isdefined('form.TRcodigo') and form.TRcodigo NEQ ''>
		<cfset params= params&'&TRcodigo='&form.TRcodigo>	
	</cfif>
	<cfif isdefined('form.Dcodigo') and form.Dcodigo NEQ ''>
		<cfset params= params&'&Dcodigo='&form.Dcodigo>	
	</cfif>	
</cfif>
<cfif isdefined('form.filtro_TRdescripcion') and form.filtro_TRdescripcion NEQ ''>
	<cfset params= params&'&filtro_TRdescripcion='&form.filtro_TRdescripcion>	
	<cfset params= params&'&hfiltro_TRdescripcion='&form.filtro_TRdescripcion>		
</cfif>
<cfif isdefined('form.filtro_Cdescripcion') and form.filtro_Cdescripcion NEQ ''>
	<cfset params= params&'&filtro_Cdescripcion='&form.filtro_Cdescripcion>	
	<cfset params= params&'&hfiltro_Cdescripcion='&form.filtro_Cdescripcion>		
</cfif>

<cflocation url="CTipoRequisicion.cfm?Pagina=#Form.Pagina#&Empresa=#session.Ecodigo##params#">