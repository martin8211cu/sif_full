<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cffunction name="datos" returntype="query">
	<cfargument name="padre" required="yes" type="numeric">
	<cfquery name="data" datasource="#session.DSN#">
		select GECVnivel, GECVpath
		from GEClasificacionViaticos
		where Ecodigo =  #session.Ecodigo# 
		and GECVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.padre#">
	</cfquery>
	<cfreturn data >
</cffunction>

<cffunction name="_nivel" returntype="boolean">
	<cfargument name="nivel" required="yes" type="numeric">
	<cfquery name="data" datasource="#session.DSN#">
		select coalesce(Pvalor, '1') as Pvalor
		from Parametros
		where Ecodigo =  #session.Ecodigo# 
		and Pcodigo = 530
	</cfquery>
	<cfif nivel gte data.Pvalor>
		<cfreturn false>
	<cfelse>
		<cfreturn true>
	</cfif>
</cffunction>

<cfparam name="modo" default="ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfset nivel = 0 >
	<cfset path  = RepeatString("0", 5-len(trim(form.GECVcodigo)) ) & "#trim(form.GECVcodigo)#">
	<cfif isdefined("Form.Alta") or isdefined("form.CAMBIO")>
		<cfif isdefined("form.GECVid_Padre") and len(trim(form.GECVid_Padre))>
			<cfset _datos = datos(form.GECVid_Padre) >
			<cfset nivel = _datos.GECVnivel + 1>
			<cfset path  = trim(_datos.GECVpath) & "/" & trim(path) >
			<cfif not _nivel(nivel) >
				<cf_errorCode	code = "50016" msg = "Ha excedido el nivel máximo para la Clasificación de Viaticos.">
			</cfif>
			
		</cfif>
	</cfif>
	
	<cfif isdefined("Form.Alta")>
		<cfquery name="insConceptos" datasource="#Session.DSN#">			
			insert into GEClasificacionViaticos( Ecodigo, GECVid_Padre, GECVcodigo, GECVdescripcion, GECVnivel, GECVpath,GECVtipo,BMUsucodigo)
			values(  #session.Ecodigo# ,
					<cfif isdefined("form.GECVid_Padre") and len(trim(form.GECVid_Padre))>
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#form.GECVid_Padre#">
					<cfelse>
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="null">
					</cfif>,
					<cfqueryparam cfsqltype="cf_sql_char" value="#trim(Ucase(form.GECVcodigo))#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GECVdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#nivel#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#path#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#trim(Ucase(form.GECVtipo))#">,
					#session.usucodigo# )
		</cfquery>
		<cfset modo="ALTA">
		
		<cfquery name="rsConceptoInsertado" datasource="#session.dsn#">
			select GECVid
			from GEClasificacionViaticos
			where GECVcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Ucase(form.GECVcodigo))#">
				and Ecodigo =  #session.Ecodigo# 
		</cfquery>

		<cfelseif isdefined("Form.Baja")>
			<cfquery name="delConceptos" datasource="#Session.DSN#">
				delete from GEClasificacionViaticos
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and GECVid = <cfqueryparam value="#Form.GECVid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cf_sifcomplementofinanciero action='delete'
				tabla="GEClasificacionViaticos"
				form = "form1"
				llave="#form.GECVid#" />					
			<cfset modo="ALTA">

		<cfelseif isdefined("Form.Cambio")>
			<cftransaction>
			<cf_dbtimestamp
				datasource="#session.dsn#"
				table="GEClasificacionViaticos" 
				redirect="GEClasificacionViaticos.cfm"
				timestamp="#form.ts_rversion#"
				field1="Ecodigo,integer,#Session.Ecodigo#"
				field2="GECVid,numeric,#form.GECVid#">
<!---<cf_dump var="#form#">--->
				<cfquery name="updConceptos" datasource="#Session.DSN#">
					update GEClasificacionViaticos 
					set GECVid_Padre = 
						<cfif isdefined("form.GECVid_Padre") and len(trim(form.GECVid_Padre))>
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#form.GECVid_Padre#">
						<cfelse>
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="null">
						</cfif>,						
						GECVdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GECVdescripcion#">,
						GECVnivel = <cfqueryparam cfsqltype="cf_sql_integer" value="#nivel#">,
						GECVpath = <cfqueryparam cfsqltype="cf_sql_varchar" value="#path#">,
						GECVcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ucase(form.GECVcodigo))#">,
						GECVtipo=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(Ucase(form.GECVtipo))#">,
						BMUsucodigo=#session.usucodigo# 
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and GECVid = <cfqueryparam value="#Form.GECVid#" cfsqltype="cf_sql_numeric">
				</cfquery>
				<!---<cf_sifcomplementofinanciero action='update'
					tabla="GEClasificacionViaticos"
					form = "form1"
					llave="#form.GECVid#" />	
				 Reordenamiento del arbolito --->	
				<!--- solo si cambia padre o codigo --->
				<cfif (form.GECVid_Padre neq form._GECVid_Padre) or (trim(form.GECVcodigo) neq trim(form._GECVcodigo)) >
					<!---<cfquery name="update_path" datasource="#session.DSN#" >
						  update GEClasificacionViaticos
						  set GECVpath =  right( '00000'  #_Cat# ltrim(rtrim(GECVcodigo)), 5),
							  GECVnivel = case when GECVid_Padre is null then 0 else -1 end
						  where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					</cfquery>--->

					<cfset nivel  = 0 >	
					
					<cfloop from="0" to="99" index="i">
						<cfquery datasource="#session.DSN#">														  
							update GEClasificacionViaticos 
							set GECVpath =    coalesce((select min(p.GECVpath)
											from GEClasificacionViaticos p 
											where p.GECVid = GEClasificacionViaticos.GECVid_Padre 
											and p.Ecodigo = GEClasificacionViaticos.Ecodigo 
											and p.GECVnivel = #nivel# ), ' ')
											#_Cat# '/' #_Cat# right ( '00000' #_Cat# rtrim(ltrim(GECVcodigo)) , 5), 
											GECVnivel = #nivel + 1#
							 where Ecodigo = #session.Ecodigo# and GECVnivel = -1
						</cfquery>
						
						<cfquery name="rsSeguir" datasource="#session.dsn#">
							select count(1) as cantidad
							from GEClasificacionViaticos 
							where Ecodigo= #session.Ecodigo# 
							  and GECVnivel=-1
						</cfquery>
						
						<cfif rsSeguir.cantidad eq 0>
							<cfbreak>
						</cfif>
						<cfset nivel = nivel + 1 >

						<cfif nivel ge 100 >
							<cf_errorCode	code = "50002" msg = "La asociación no es válida">
						</cfif>
					</cfloop>
				</cfif>	<!--- reordenamiento --->
				
				<cfquery name="rsvalidar" datasource="#session.DSN#">
					select max(GECVnivel) as nivelMaximo
					from GEClasificacionViaticos
					where Ecodigo= #session.Ecodigo# 
				</cfquery>
				<cfset nivel = rsvalidar.nivelMaximo + 1>
				<cfif rsvalidar.Recordcount gt 0 and len(trim(rsvalidar.nivelMaximo))>
					<cfif not _nivel(rsvalidar.nivelMaximo)>
						<cftransaction action="rollback">
						<cf_errorCode	code = "50016" msg = "Ha excedido el nivel máximo para la Clasificación de Viaticos.">
					</cfif>
				</cfif>

			</cftransaction>
			<cfset modo="CAMBIO">
		</cfif>
</cfif>

<cfset params = ''>
<cfif isdefined("form.CAMBIO")>
	<cfset params = "?arbol_pos=#form.GECVid#" >
<cfelseif isdefined("form.Alta") and isdefined("rsConceptoInsertado") and rsConceptoInsertado.RecordCount gt 0>
	<cfset params = "?arbol_pos=#rsConceptoInsertado.GECVid#" >
</cfif>
<cflocation url="catalogoClasificacionesViaticos.cfm#params#">