<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cffunction name="datos" returntype="query">
	<cfargument name="padre" required="yes" type="numeric">
	<cfquery name="data" datasource="#session.DSN#">
		select CCnivel, CCpath
		from CConceptos
		where Ecodigo =  #session.Ecodigo# 
		and CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.padre#">
	</cfquery>
	<cfreturn data >
</cffunction>

<cffunction name="_nivel" returntype="boolean">
	<cfargument name="nivel" required="yes" type="numeric">
	<cfquery name="data" datasource="#session.DSN#">
		select coalesce(Pvalor, '1') as Pvalor
		from Parametros
		where Ecodigo =  #session.Ecodigo# 
		and Pcodigo = 540
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
	<cfset path  = RepeatString("0", 10-len(trim(form.CCcodigo)) ) & "#trim(form.CCcodigo)#">
	<cfif isdefined("Form.Alta") or isdefined("form.CAMBIO")>
		<cfif isdefined("form.CCidpadre") and len(trim(form.CCidpadre))>
			<cfset _datos = datos(form.CCidpadre) >
			<cfset nivel = _datos.CCnivel + 1>
			<cfset path  = trim(_datos.CCpath) & "/" & trim(path) >
			<cfif not _nivel(nivel) >
				<cf_errorCode	code = "50016" msg = "Ha excedido el nivel máximo para la Clasificación de Servicios.">
			</cfif>
			
		</cfif>
	</cfif>
	
	<cfif isdefined("Form.Alta")>
		<cfquery name="insConceptos" datasource="#Session.DSN#">			
			insert into CConceptos( Ecodigo, CCidpadre, CCcodigo, CCdescripcion, Usucodigo, CCfalta, CCnivel, CCpath,cuentac)
			values(  #session.Ecodigo# ,
					<cfif isdefined("form.CCidpadre") and len(trim(form.CCidpadre))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCidpadre#"><cfelse>null</cfif>,
					<cfqueryparam cfsqltype="cf_sql_char" value="#trim(Ucase(form.CCcodigo))#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#nivel#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#path#">,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#form.cuentac#">)
		</cfquery>
		<cfset modo="ALTA">
		
		<cfquery name="rsConceptoInsertado" datasource="#session.dsn#">
			select CCid
			from CConceptos
			where CCcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Ucase(form.CCcodigo))#">
				and Ecodigo =  #session.Ecodigo# 
		</cfquery>

		<cfelseif isdefined("Form.Baja")>
			<cfquery name="delConceptos" datasource="#Session.DSN#">
				delete from CConceptos
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and CCid = <cfqueryparam value="#Form.CCid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cf_sifcomplementofinanciero action='delete'
				tabla="CConceptos"
				form = "form1"
				llave="#form.CCid#" />					
			<cfset modo="ALTA">

		<cfelseif isdefined("Form.Cambio")>
			<cftransaction>
			<cf_dbtimestamp
				datasource="#session.dsn#"
				table="CConceptos" 
				redirect="CConceptos.cfm"
				timestamp="#form.ts_rversion#"
				field1="Ecodigo,integer,#Session.Ecodigo#"
				field2="CCid,numeric,#form.CCid#">

				<cfquery name="updConceptos" datasource="#Session.DSN#">
					update CConceptos 
					set CCidpadre = <cfif isdefined("form.CCidpadre") and len(trim(form.CCidpadre))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCidpadre#"><cfelse>null</cfif>,
						CCdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCdescripcion#">,
						CCnivel = <cfqueryparam cfsqltype="cf_sql_integer" value="#nivel#">,
						CCpath = <cfqueryparam cfsqltype="cf_sql_varchar" value="#path#">,
						CCcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ucase(form.CCcodigo))#">,
						cuentac = <cfqueryparam cfsqltype="cf_sql_char" value="#form.cuentac#">
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and CCid = <cfqueryparam value="#Form.CCid#" cfsqltype="cf_sql_numeric">
				</cfquery>
				<cf_sifcomplementofinanciero action='update'
					tabla="CConceptos"
					form = "form1"
					llave="#form.CCid#" />	
				<!--- Reordenamiento del arbolito --->	
				<!--- solo si cambia padre o codigo --->
				<cfif (form.CCidpadre neq form._CCidpadre) or (trim(form.CCcodigo) neq trim(form._CCcodigo)) >
					<cfquery name="update_path" datasource="#session.DSN#" >
						  update CConceptos
						  set CCpath =  right( '0000000000'  #_Cat# ltrim(rtrim(CCcodigo)), 10),
							  CCnivel = case when CCidpadre is null then 0 else -1 end
						  where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					</cfquery>

					<cfset nivel  = 0 >	
					
					<cfloop from="0" to="99" index="i">
						<cfquery datasource="#session.DSN#">														  
							update CConceptos 
							set CCpath =    coalesce((select min(p.CCpath)
											from CConceptos p 
											where p.CCid = CConceptos.CCidpadre 
											and p.Ecodigo = CConceptos.Ecodigo 
											and p.CCnivel = #nivel# ), ' ')
											#_Cat# '/' #_Cat# right ( '0000000000' #_Cat# rtrim(ltrim(CCcodigo)) , 10), 
											CCnivel = #nivel + 1#
							 where Ecodigo = #session.Ecodigo# and CCnivel = -1
						</cfquery>
						
						<cfquery name="rsSeguir" datasource="#session.dsn#">
							select count(1) as cantidad
							from CConceptos 
							where Ecodigo= #session.Ecodigo# 
							  and CCnivel=-1
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
					select max(CCnivel) as nivelMaximo
					from CConceptos
					where Ecodigo= #session.Ecodigo# 
				</cfquery>
				<cfset nivel = rsvalidar.nivelMaximo + 1>
				<cfif rsvalidar.Recordcount gt 0 and len(trim(rsvalidar.nivelMaximo))>
					<cfif not _nivel(rsvalidar.nivelMaximo)>
						<cftransaction action="rollback">
						<cf_errorCode	code = "50016" msg = "Ha excedido el nivel máximo para la Clasificación de Servicios.">
					</cfif>
				</cfif>

				<cfquery name="rsConceptos" datasource="#Session.DSN#">
					select Cid from Conceptos
						where CCid=<cfqueryparam value="#Form.CCid#" cfsqltype="cf_sql_numeric">
				</cfquery>
						
				

			</cftransaction>
			<cfloop query="rsConceptos">
					<cfquery name="updGEconceptoGasto" datasource="#Session.DSN#">
						update GEconceptoGasto set
							GECcomplemento=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cuentac#">
							where Cid=#rsConceptos.Cid#
					</cfquery>	
				</cfloop>
			
			<cfset modo="CAMBIO">
		</cfif>
</cfif>

<cfset params = ''>
<cfif isdefined("form.CAMBIO")>
	<cfset params = "?arbol_pos=#form.CCid#" >
<cfelseif isdefined("form.Alta") and isdefined("rsConceptoInsertado") and rsConceptoInsertado.RecordCount gt 0>
	<cfset params = "?arbol_pos=#rsConceptoInsertado.CCid#" >
</cfif>
<cflocation url="CConceptos.cfm#params#">