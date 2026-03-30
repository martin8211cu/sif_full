<!---<cf_dump var="#form#"> ---> 
<cfset params = "">

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cftransaction>
			<cfquery name="InsEstadoSNegocios" datasource="#Session.DSN#">		
				insert into EstadoSNegocios (Ecodigo, ESNcodigo, ESNdescripcion, ESNfacturacion, BMUsucodigo)
				values (
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> , 
					 <cfqueryparam cfsqltype="cf_sql_char" value="#Form.ESNcodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESNdescripcion#">, 
					 <cfif isdefined("form.ESNfacturacion")>1<cfelse>0</cfif>,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				)
				<cf_dbidentity1>
			</cfquery>			
			<cf_dbidentity2 name="InsEstadoSNegocios">	
		</cftransaction>
		<cfquery name="rsPagina" datasource="#session.DSN#">
			 select ESNid
			 from EstadoSNegocios 
			 where 1=1 
			   <cfif isdefined('form.filtro_ESNcodigo') and LEN(TRIM(form.filtro_ESNcodigo))>
			   and upper(ESNcodigo) like <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(form.filtro_ESNcodigo)#">
			   </cfif>
			   <cfif isdefined('form.filtro_ESNdescripcion') and LEN(TRIM(form.filtro_ESNdescripcion))>
			   and upper(ESNdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ucase(form.filtro_ESNdescripcion)#">
			   </cfif>
			   <cfif isdefined('form.filtro_ESNfacturacion') and LEN(TRIM(form.filtro_ESNfacturacion))>
			   and upper(ESNfacturacion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ucase(form.filtro_ESNfacturacion)#">
			   </cfif>
			   and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			order by ESNcodigo
		</cfquery>
		<cfset params=params&"&ESNid="&InsEstadoSNegocios.identity>	
		<cfset row = 1>
		<cfif rsPagina.RecordCount LT 500>
			<cfloop query="rsPagina">
				<cfif rsPagina.ESNid EQ InsEstadoSNegocios.identity>
					<cfset row = rsPagina.currentrow>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		<cfset form.pagina = Ceiling(row / form.MaxRows)>
		
	<cfelseif isdefined("Form.Cambio")>
			<cf_dbtimestamp datasource="#session.dsn#"
							table="EstadoSNegocios"
							redirect="EstadoSNegocios.cfm"
							timestamp="#form.ts_rversion#"
							field1="ESNid" type1="numeric" value1="#form.ESNid#"
							field2="Ecodigo" type2="integer" value2="#Session.Ecodigo#">		
							
			<cfquery name="UpdEstadoSNegocios" datasource="#Session.DSN#">								
				update EstadoSNegocios  
				set ESNcodigo =<cfqueryparam cfsqltype="cf_sql_char" value="#Form.ESNcodigo#">,
					ESNdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESNdescripcion#">,
					ESNfacturacion = <cfif isdefined("form.ESNfacturacion")>1<cfelse>0</cfif>
				where ESNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESNid#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>		
		<cfset params=params&"&ESNid="&form.ESNid>	  
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delEstadoSNegocios" datasource="#Session.DSN#">
			delete from EstadoSNegocios
			where ESNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESNid#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>			
		<cfset form.pagina = 1>  
	</cfif>
</cfif>

<cflocation url="EstadoSNegocios.cfm?Pagina=#Form.Pagina#&filtro_ESNcodigo=#form.filtro_ESNcodigo#&filtro_ESNdescripcion=#form.filtro_ESNdescripcion#&filtro_Factura=#form.filtro_Factura#&hfiltro_ESNcodigo=#form.filtro_ESNcodigo#&hfiltro_ESNdescripcion=#form.filtro_ESNdescripcion#&hfiltro_Factura=#form.filtro_Factura##params#">