<cfparam name="modo" default="ALTA">

<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("Form.Alta")>
			<cfquery name="rsExiste" datasource="#session.DSN#">
				select 1 
				from TRequisicion 
				where TRcodigo=<cfqueryparam value="#Form.TRcodigo#" cfsqltype="cf_sql_varchar">
				  and Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif rsExiste.RecordCount gt 0>
				<cfquery name="update" datasource="#session.DSN#">
					update TRequisicion
					set TRdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TRdescripcion#" >
					where TRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TRcodigo#" >
					  and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >	
				</cfquery>
			<cfelse>	
				<cfquery name="insert" datasource="#session.DSN#">
					insert into TRequisicion ( Ecodigo, TRcodigo, TRdescripcion, TRreversaCreditoFiscal )
					values( <cfqueryparam value="#session.Ecodigo#"    cfsqltype="cf_sql_integer">, 
							<cfqueryparam value="#Form.TRcodigo#"      cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Form.TRdescripcion#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Form.TRreversaCreditoFiscal#" cfsqltype="cf_sql_bit">
						)
				</cfquery>
			</cfif>

			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="ABC_TRequisicion" datasource="#session.DSN#">
				delete from TRequisicion
				where TRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TRcodigo#" >
				  and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >	
			</cfquery>
			<cf_sifcomplementofinanciero action='delete'
					tabla="TRequisicion"
					form = "trequisicion"
					llave="#Form.TRcodigo#" />					
			<cfset modo="ALTA">

		<cfelseif isdefined("Form.Cambio")>
			<cf_dbtimestamp
				datasource="#session.dsn#"
				table="TRequisicion" 
				redirect="TRequisicion.cfm"
				
				timestamp="#form.ts_rversion#"
				
				field1="TRcodigo"
				type1="char"
				value1="#form.TRcodigo#"

				field2="Ecodigo"
				type2="integer"
				value2="#session.Ecodigo#">

			<cfquery name="ABC_TRequisicion" datasource="#session.DSN#">					
				update TRequisicion
				set TRdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TRdescripcion#" >,
				    TRreversaCreditoFiscal=<cfqueryparam value="#Form.TRreversaCreditoFiscal#" cfsqltype="cf_sql_bit">
				where TRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TRcodigo#" >
				  and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >	
			</cfquery>
			<cf_sifcomplementofinanciero action='update'
					tabla="TRequisicion"
					form = "trequisicion"
					llave="#Form.TRcodigo#" />		
		</cfif>
</cfif>

<cfset params="">
<cfif not isdefined('form.Nuevo') and not isdefined('form.Baja') >
	<cfif isdefined('form.TRcodigo') and form.TRcodigo NEQ ''>
		<cfset params= params&'&TRcodigo='&form.TRcodigo>	
	</cfif>
</cfif>

<cfif isdefined('form.filtro_TRdescripcion') and form.filtro_TRdescripcion NEQ ''>
	<cfset params= params&'&filtro_TRdescripcion='&form.filtro_TRdescripcion>	
	<cfset params= params&'&hfiltro_TRdescripcion='&form.filtro_TRdescripcion>		
</cfif>
<cflocation url="TRequisicion.cfm?Pagina=#Form.Pagina#&Empresa=#session.Ecodigo##params#">

