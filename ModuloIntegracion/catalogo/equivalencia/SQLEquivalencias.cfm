<cfset params = "">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfset arreglo = ListToArray(form.EQUidSIF,"|")>
		<cfset varid = arreglo[1]>
		<cfset varcodigo = arreglo[2]>
		<cfset vardescripcion = arreglo[3]>
		<cfquery name="insEquivalencia" datasource="sifinterfaces">
			insert into SIFLD_Equivalencia (SIScodigo, CATcodigo, EQUempOrigen, EQUcodigoOrigen, EQUempSIF, EQUcodigoSIF, EQUidSIF, EQUdescripcion)
			values (
				 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SIScodigo#">)) ,
				 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CATcodigo#">)),
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.EQUempOrigen#" null="#Len(Trim(Form.EQUempOrigen)) Is 0#">,
   				 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EQUcodigoOrigen#">)),
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.EQUempSIF#" null="#Len(Trim(Form.EQUempSIF)) Is 0#">,
   				 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#varcodigo#">)),
				 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#varid#">)),
				 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#vardescripcion#">))
    			)
			<cf_dbidentity1 verificar_transaccion="false" datasource="sifinterfaces">
		</cfquery>

        <cf_dbidentity2 name="insEquivalencia" verificar_transaccion="false" datasource="sifinterfaces">
		<cfquery name="rsPagina" datasource="sifinterfaces">
			select EQUid
			from SIFLD_Equivalencia
			where 1=1

			  <cfif isdefined('form.filtro_SISCodigo') and LEN(TRIM(form.filtro_SISCodigo))>
			  and upper(SIScodigo) like <cfqueryparam cfsqltype="cf_sql_char" value="%#Ucase(form.filtro_SIScodigo)#%">
			  </cfif>

			  <cfif isdefined('form.filtro_CATcodigo') and LEN(TRIM(form.filtro_CATcodigo))>
			  and upper(CATcodigo) like <cfqueryparam cfsqltype="cf_sql_char" value="%#Ucase(form.filtro_CATcodigo)#%">
			  </cfif>

			  <cfif isdefined('form.EQUempOrigen')>
			  and EQUempOrigen = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.EQUempOrigen#">
			  </cfif>

			  <cfif isdefined('form.EQUcodigoOrigen')>
			  and EQUcodigoOrigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EQUcodigoOrigen#">
			  </cfif>

			  <cfif isdefined('form.EQUempSIF')>
			  and EQUempSIF = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.EQUempSIF#">
			  </cfif>

			  <cfif isdefined('form.EQUidSIF')>
			  and EQUidSIF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EQUidSIF#">
			  </cfif>

			order by SIScodigo, CATcodigo

		</cfquery>
		<cfset params=params&"&EQUid="&insEquivalencia.identity>
		<cfset row = 1>
		<cfif rsPagina.RecordCount LT 500>
			<cfloop query="rsPagina">
				<cfif rsPagina.EQUid EQ insEquivalencia.identity>
					<cfset row = rsPagina.currentrow>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		<cfset form.pagina = Ceiling(row / form.MaxRows)>

        *****************************************************************************************************************
        *****************************************************************************************************************

    <cfelseif isdefined("Form.Baja")>
		<cfquery name="delEquivalencias" datasource="sifinterfaces">
			delete from SIFLD_Equivalencia
			where EQUid = <cfqueryparam value="#Form.EQUid#" cfsqltype="cf_sql_numeric">
		</cfquery>
    	<cfset form.pagina = 1>

        *****************************************************************************************************************
        *****************************************************************************************************************

	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp
			datasource="sifinterfaces"
			table="SIFLD_Equivalencia"
			redirect="Equivalencias.cfm"
			timestamp="#form.ts_rversion#"
			field1="EQUid,numeric,#form.EQUid#">

		<cfset arreglo = ListToArray(form.EQUidSIF,"|")>
		<cfset varid = arreglo[1]>
		<cfset varcodigo = arreglo[2]>
		<cfset vardescripcion = arreglo[3]>
		<cfquery name="updEquivalencias" datasource="sifinterfaces">
			update SIFLD_Equivalencia set
				SIScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SIScodigo#">,
				CATcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CATcodigo#">,
				EQUempOrigen = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EQUempOrigen#" null="#Len(Trim(Form.EQUempOrigen)) Is 0#">,
				EQUcodigoOrigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.EQUcodigoOrigen)#">,
				EQUempSIF = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EQUempSIF#" null="#Len(Trim(Form.EQUempSIF)) Is 0#">,
				EQUcodigoSIF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(varcodigo)#">,
				EQUidSIF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(varid)#">,
				EQUdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(vardescripcion)#">
			where EQUid = <cfqueryparam value="#Form.EQUid#" cfsqltype="cf_sql_numeric">
		</cfquery>
	</cfif>
</cfif>

<cfset params="">
<cfif not isdefined('form.Nuevo') and not isdefined('form.Baja') >
	<cfif isdefined('form.EQUid') and form.EQUid NEQ ''>
		<cfset params= params & '&EQUid='&form.EQUid>
	</cfif>
</cfif>
<cfif isdefined('form.fSistema') and form.fSistema NEQ ''>
	<cfset params= params & '&fSistema=' & form.fSistema>
	<cfset params= params & '&hfSistema='&form.fSistema>
</cfif>
<cfif isdefined('form.fCatalogo') and form.fCatalogo NEQ ''>
	<cfset params= params&'&fCatalogo='&form.fCatalogo>
	<cfset params= params&'&hfCatalogo='&form.fCatalogo>
</cfif>
<cfif isdefined('form.filtro_SIScodigo') and form.filtro_SIScodigo NEQ ''>
	<cfset params= params&'&filtro_SIScodigo='&form.filtro_SIScodigo>
	<cfset params= params&'&hfiltro_SIScodigo='&form.filtro_SIScodigo>
</cfif>
<cfif isdefined('form.filtro_CATcodigo') and form.filtro_CATcodigo NEQ ''>
	<cfset params= params&'&filtro_CATcodigo='&form.filtro_CATcodigo>
	<cfset params= params&'&hfiltro_CATcodigo='&form.filtro_CATcodigo>
</cfif>
<cfif isdefined('form.EQUempOrigen') and form.EQUempOrigen NEQ ''>
	<cfset params= params&'&EQUempOrigen='&form.EQUempOrigen>
	<cfset params= params&'&hEQUempOrigen='&form.EQUempOrigen>
</cfif>
<cfif isdefined('form.EQUcodigoOrigen') and form.EQUcodigoOrigen NEQ ''>
	<cfset params= params&'&EQUcodigoOrigen='&form.EQUcodigoOrigen>
	<cfset params= params&'&hEQUcodigoOrigen='&form.EQUcodigoOrigen>
</cfif>
<cfif isdefined('form.EQUempSIF') and form.EQUempSIF NEQ ''>
	<cfset params= params&'&EQUempSIF='&form.EQUempSIF>
	<cfset params= params&'&hEQUempSIF='&form.EQUempSIF>
</cfif>
<cfif isdefined('form.EQUidSIF') and form.EQUidSIF NEQ ''>
	<cfset params= params&'&EQUidSIF='&form.EQUidSIF>
	<cfset params= params&'&hEQUidSIF='&form.EQUidSIF>
</cfif>
<cfif isdefined('form.SIScodigo') and form.SIScodigo NEQ ''>
	<cfset params= params&'&SIScodigo='&form.SIScodigo>
	<cfset params= params&'&hSIScodigo='&form.SIScodigo>
</cfif>
<cfif isdefined('form.CATcodigo') and form.CATcodigo NEQ ''>
	<cfset params= params&'&CATcodigo='&form.CATcodigo>
	<cfset params= params&'&hCATcodigo='&form.CATcodigo>
</cfif>

<cflocation url="Equivalencias.cfm?Pagina=#Form.Pagina##params#">

