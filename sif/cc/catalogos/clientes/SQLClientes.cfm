<cfset params = ''>
<cfif isdefined('form.Pagina')>
	<cfset params = params & 'Pagina=#form.Pagina#'>
</cfif>
<cfif isdefined('form.Filtro_CDIdentificacion') and LEN(TRIM(form.Filtro_CDIdentificacion))>
	<cfset params = params & '&Filtro_CDIdentificacion=#form.Filtro_CDIdentificacion#'>
</cfif>
<cfif isdefined('form.Filtro_CDnombre') and LEN(TRIM(form.Filtro_CDnombre))>
	<cfset params = params & '&Filtro_CDnombre=#form.Filtro_CDnombre#'>
</cfif>
<cfif isdefined('form.Filtro_rotulo') and LEN(TRIM(form.Filtro_rotulo))>
	<cfset params = params & '&Filtro_rotulo=#form.Filtro_rotulo#'>
</cfif>		
<cfif not isdefined("Form.Nuevo")>
	
		<cfif isdefined("Form.Alta")>
			<cftransaction>
			<cfquery name="insClienteDetallista" datasource="#Session.DSN#">			
				insert into ClienteDetallista (CEcodigo ,CDTid ,CDactivo, CDidentificacion ,CDnombre ,CDapellido1 ,CDapellido2 ,
					CDdireccion1 ,CDdireccion2 ,CDpais, CDciudad, CDestado ,CDcodPostal ,CDoficina ,CDcasa ,CDcelular ,CDfax ,
					CDemail ,CDcivil ,CDfechanac ,CDingreso ,CDsexo, CDtrabajo ,CDantiguedad ,
					CDvivienda ,CDrefcredito ,CDrefbancaria ,CDestudios, CDdependientes,LPid)
        		values 
				(				
					 #session.CEcodigo#, 
					 <cfif len(trim(form.CDTid)) eq 0>
					 	null,
					 <cfelse>
					 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDTid#">, 
					</cfif>
					 'P',
					rtrim(ltrim(<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.CDidentificacion#">)), 
                     <cf_jdbcquery_param cfsqltype='cf_sql_varchar' value='#Form.CDnombre#'>,
                     <cf_jdbcquery_param cfsqltype='cf_sql_varchar' value='#Form.CDapellido1#'>,
                     <cf_jdbcquery_param cfsqltype='cf_sql_varchar' value='#Form.CDapellido2#'>,
                     <cf_jdbcquery_param cfsqltype='cf_sql_varchar' value='#Form.CDdireccion1#'>,
                     <cf_jdbcquery_param cfsqltype='cf_sql_varchar' value='#Form.CDdireccion2#'>,
                     <cf_jdbcquery_param cfsqltype='cf_sql_varchar' value='#Form.CDpais#'>,
                     <cf_jdbcquery_param cfsqltype='cf_sql_varchar' value='#Form.CDciudad#'>,
                     <cf_jdbcquery_param cfsqltype='cf_sql_varchar' value='#Form.CDestado#'>,
                     <cf_jdbcquery_param cfsqltype='cf_sql_varchar' value='#Form.CDcodPostal#'>,
                     <cf_jdbcquery_param cfsqltype='cf_sql_varchar' value='#Form.CDoficina#'>,
                     <cf_jdbcquery_param cfsqltype='cf_sql_varchar' value='#Form.CDcasa#'>,
                     <cf_jdbcquery_param cfsqltype='cf_sql_varchar' value='#Form.CDcelular#'>,
                     <cf_jdbcquery_param cfsqltype='cf_sql_varchar' value='#Form.CDfax#'>,
                     <cf_jdbcquery_param cfsqltype='cf_sql_varchar' value='#Form.CDemail#'>,
                     <cf_jdbcquery_param cfsqltype='cf_sql_integer' value='#Form.CDcivil#'>,
                     <cf_jdbcquery_param cfsqltype='cf_sql_timestamp' value='#lsparsedatetime(Form.CDfechanac)#'>,
                     <cf_jdbcquery_param cfsqltype='cf_sql_money' value='#Form.CDingreso#'>,
                     <cf_jdbcquery_param cfsqltype='cf_sql_varchar' value='#Form.CDsexo#'>,
                     <cf_jdbcquery_param cfsqltype='cf_sql_varchar' value='#Form.CDtrabajo#'>,
					 <cfif len(trim(form.CDantiguedad)) eq 0>
					 	0,
					 <cfelse>
                          <cf_jdbcquery_param cfsqltype='cf_sql_integer' value='#Form.CDantiguedad#'>,
					 </cfif>	 
					 <cf_jdbcquery_param cfsqltype='cf_sql_char' value='#Form.CDvivienda#'>,
                     

                     rtrim(ltrim(<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.CDrefcredito#">)),
					 rtrim(ltrim(<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.CDrefbancaria#">)),
                     
					 <cfif len(trim(form.CDestudios)) eq 0>
					 	null,
					 <cfelse>
					 	<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#form.CDestudios#">, 
					 </cfif>
					  <cfif len(trim(form.CDdependientes)) eq 0>
					 	0,
					 <cfelse>
					 	<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.CDdependientes#">,
					 </cfif>
					 <cfif isdefined("form.LPid") and len(trim(form.LPid)) gt 0><cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.LPid#"><cfelse>null</cfif>
					 	)
						
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="insClienteDetallista">
			</cftransaction>

			<cfset form.CDid=insClienteDetallista.identity>

		<cfelseif isdefined("Form.Baja")>
			<cfquery name="delClienteDetallista" datasource="#Session.DSN#">
				delete from ClienteDetallista
				where CEcodigo = #Session.CEcodigo#
				  and CDid = <cfqueryparam value="#Form.CDid#" cfsqltype="cf_sql_numeric">
				  <cfset modo="ALTA">
			</cfquery>
			<cfif isdefined('form.Filtro_CDIdentificacion') and LEN(TRIM(form.Filtro_CDIdentificacion))>
				<cfset params = params & '&hFiltro_CDIdentificacion=#form.Filtro_CDIdentificacion#'>
			</cfif>
			<cfif isdefined('form.Filtro_CDnombre') and LEN(TRIM(form.Filtro_CDnombre))>
				<cfset params = params & '&hFiltro_CDnombre=#form.Filtro_CDnombre#'>
			</cfif>
			<cfif isdefined('form.Filtro_rotulo') and LEN(TRIM(form.Filtro_rotulo))>
				<cfset params = params & '&hFiltro_rotulo=#form.Filtro_rotulo#'>
			</cfif>
			<cflocation url="Clientes.cfm?#params#">
		<cfelseif isdefined("Form.Cambio")>
				<cf_dbtimestamp datasource="#Session.DSN#"
							table="ClienteDetallista"
							redirect="DatosClientes.cfm"
							timestamp="#Form.ts_rversion#"
							field1="CEcodigo" type1="integer" value1="#Session.CEcodigo#"
							field2="CDid" type2="numeric" value2="#Form.CDid#">	
		
			<cfquery name="updClienteDetallista" datasource="#Session.DSN#">
					update ClienteDetallista set 
						CDidentificacion =  rtrim(ltrim(<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.CDidentificacion#">)),
						CDnombre     = rtrim(ltrim(<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.CDnombre#">)),
						CDapellido1  = rtrim(ltrim(<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.CDapellido1#">)),
						CDapellido2  = rtrim(ltrim(<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.CDapellido2#">)),
						CDdireccion1 = rtrim(ltrim(<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.CDdireccion1#">)),
						CDdireccion2 = rtrim(ltrim(<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.CDdireccion2#">)),
						CDpais 		 = rtrim(ltrim(<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.CDpais#">)),
						CDciudad	 = rtrim(ltrim(<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.CDciudad#">)),
						CDestado 	 = rtrim(ltrim(<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.CDestado#">)),
						CDcodPostal  = rtrim(ltrim(<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.CDcodPostal#">)),
						CDoficina 	 = rtrim(ltrim(<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.CDoficina#">)),
						CDcasa		 = rtrim(ltrim(<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.CDcasa#">)),
						CDcelular	 = rtrim(ltrim(<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.CDcelular#">)),
						CDfax 		 = rtrim(ltrim(<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.CDfax#">)),
						CDemail 	 = rtrim(ltrim(<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.CDemail#">)),
						CDcivil 	 = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.CDcivil#">, 
						CDfechanac 	 =  <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#lsparsedatetime(Form.CDfechanac)#">,
						CDingreso	 = <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#form.CDingreso#">, 
						CDsexo 		 = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#form.CDsexo#">, 
						CDtrabajo	 = rtrim(ltrim(<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.CDtrabajo#">)),
						CDantiguedad = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.CDantiguedad#">, 
						CDvivienda	 = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#form.CDvivienda#">, 
						CDrefcredito = rtrim(ltrim(<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.CDrefcredito#">)),
						CDrefbancaria = rtrim(ltrim(<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.CDrefbancaria#">)),
						 <cfif len(trim(form.CDestudios)) eq 0>
						 	CDestudios   = null,
						<cfelse>
							CDestudios   = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#form.CDestudios#">, 
						</cfif>
						<cfif len(trim(form.CDTid)) eq 0>
						    CDTid  = null,
						<cfelse>
							CDTid  = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CDTid#">,
						</cfif>
						CDdependientes = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.CDdependientes#">,
						LPid = <cfif isdefined("form.LPid") and len(trim(form.LPid)) gt 0><cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.LPid#"><cfelse>null</cfif>
						
					where CEcodigo =#Session.CEcodigo#
					  and CDid = <cfqueryparam value="#Form.CDid#" cfsqltype="cf_sql_numeric">			
 				</cfquery>
			</cfif>
	<cfelse>
	<cflocation url="DatosClientes.cfm?#params#">
</cfif>
<cfif isdefined('form.opcion')>
	  <cfset nombre = "#form.CDnombre#  #form.CDapellido1#  #form.CDapellido2#">
	  <cfquery name="updateVentaE" datasource="#Session.DSN#">
		 update VentaE
		 set    CDid = <cf_jdbcquery_param  cfsqltype="cf_sql_numeric" value="#insClienteDetallista.identity#">,
				nombre_cliente = <cf_jdbcquery_param  cfsqltype="cf_sql_varchar" value="#nombre#">, 
				cedula_cliente = <cf_jdbcquery_param  cfsqltype="cf_sql_varchar" value="#form.CDidentificacion#">
		 where  VentaID = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#session.listaFactura.VentaID#">
		   and  Ecodigo = #session.Ecodigo#
	  </cfquery>
	
	  <cflocation url="../../../fa/consultas/cons_art/carrito.cfm">
</cfif>
<cflocation url="DatosClientes.cfm?CDid=#form.CDid#&#params#">