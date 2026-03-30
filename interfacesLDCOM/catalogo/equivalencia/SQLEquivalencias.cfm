<cfset params = "">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="insEquivalencia" datasource="sifinterfaces">			
			insert into SIFLD_Equivalencia (SIScodigo, CATcodigo, EQUempOrigen, EQUcodigoOrigen, EQUempSIF, EQUcodigoSIF)
			values (
				 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SIScodigo#">)) , 
				 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CATcodigo#">)),
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.EQUempOrigen#" null="#Len(Trim(Form.EQUempOrigen)) Is 0#">, 
   				 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EQUcodigoOrigen#">)), 
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.EQUempSIF#" null="#Len(Trim(Form.EQUempSIF)) Is 0#">, 
   				 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EQUcodigoSIF#">))
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
              
			  <cfif isdefined('form.EQUcodigoSIF')>
			  and EQUcodigoSIF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EQUcodigoSIF#">
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

		<cfquery name="updEquivalencias" datasource="sifinterfaces">
			update SIFLD_Equivalencia set 
				SIScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SIScodigo#">,
				CATcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CATcodigo#">, 
				EQUempOrigen = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EQUempOrigen#" null="#Len(Trim(Form.EQUempOrigen)) Is 0#">,
				EQUcodigoOrigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.EQUcodigoOrigen)#">,
				EQUempSIF = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EQUempSIF#" null="#Len(Trim(Form.EQUempSIF)) Is 0#">,
				EQUcodigoSIF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.EQUcodigoSIF)#">
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
<cfif isdefined('form.EQUcodigoSIF') and form.EQUcodigoSIF NEQ ''>
	<cfset params= params&'&EQUcodigoSIF='&form.EQUcodigoSIF>	
	<cfset params= params&'&hEQUcodigoSIF='&form.EQUcodigoSIF>		
</cfif>

<cflocation url="Equivalencias.cfm?Pagina=#Form.Pagina##params#">

