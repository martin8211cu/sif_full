<!---<cf_dump var="#form#">--->
<cffunction name="datos" returntype="query">
	<cfargument name="padre" required="yes" type="numeric">

	<cfquery name="data" datasource="#session.DSN#">
		select coalesce(AFCnivel,0) as AFCnivel, AFCpath 
		from AFClasificaciones
		where Ecodigo = #session.Ecodigo#
		and AFCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.padre#">
	</cfquery>	
	<cfreturn data >
</cffunction>

<cffunction name="_nivel" returntype="boolean">
	<cfargument name="nivel" required="yes" type="numeric">
	<cfquery name="data" datasource="#session.DSN#">
		select coalesce(Pvalor, '1') as Pvalor
		from Parametros
		where Ecodigo = #session.Ecodigo#
		and Pcodigo = 530
	</cfquery>

	<cfif (nivel+1) gt data.Pvalor>
		<cfreturn false>
	<cfelse>
		<cfreturn true>
	</cfif>
</cffunction>

<cfparam name="modo" default="ALTA">
<cfparam name="form.AFCcodigo"  default="#form.AFCcodigoclas#">

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta") or isdefined("form.CAMBIO")>
		<cfif form.AFCcodigoclas EQ form.AFCcodigopadre>
			<cfthrow message="Padre no puede ser el mismo Hijo">
		</cfif>

		<cfset current = form.AFCcodigopadre>
		<cfset path2 = form.AFCcodigoclas>
		<cfloop from="1" to="100" index="dummy">
			<cfif Len(current) is 0><cfbreak></cfif>
			<cfif listFind(path2,current)>
				<cfthrow message="Padre no puede ser un Descendiente">
			</cfif>
			<cfset path2 = ListAppend(path2,current)>
			<cfquery datasource="#session.dsn#" name="siguiente">
				select AFCcodigopadre as padre 
				from AFClasificaciones
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and AFCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#current#">
			</cfquery>
			<cfset anterior = current>
			<cfset current = siguiente.padre>
		</cfloop>
	</cfif>

	<cfset nivel = 0 >
	<cfset path  = RepeatString("*", 20-len(trim(form.AFCcodigoclas)) ) & "#trim(form.AFCcodigoclas)#" >
	<cfif isdefined("Form.Alta") or isdefined("form.CAMBIO")>
		<cfif isdefined("form.AFCcodigopadre") and len(trim(form.AFCcodigopadre))>			
			<cfset _datos = datos(form.AFCcodigopadre) >				
			<cfif _datos.RecordCount NEQ 0>
				<cfset nivel = _datos.AFCnivel + 1>
				<cfset path  = trim(_datos.AFCpath) & "/" & trim(path) >				
				<cfif not _nivel(nivel) >
					<cf_errorCode	code = "50043" msg = "Ha excedido el nivel máximo para la Clasificación de Artículos.">
				</cfif>			
			</cfif>
		</cfif>
	</cfif>
	
	<cfif isdefined("Form.Alta")>
	
		<!--- Si ya existe un registro con AFCcodigoclas no permite insertarlo --->
		<cftry>
			<cfquery name="rsVerifica" datasource="#session.DSN#">
				select AFCcodigoclas
				from AFClasificaciones
				where Ecodigo = #Session.Ecodigo#			
				  and upper(AFCcodigoclas) = <cfqueryparam cfsqltype="cf_sql_char" value="#UCase(Trim(Form.AFCcodigoclas))#"> 
			</cfquery>	
	
			<cfif #rsVerifica.recordCount# eq 0>		
				<cfquery name="rsconsecutivo" datasource="#session.DSN#">
					select coalesce(max(AFCcodigo),0) as codigo
					from AFClasificaciones
					where Ecodigo= #session.Ecodigo#
				</cfquery>
				<cfset consecutivo = 1 >
				<cfif rsconsecutivo.recordcount gt 0 and len(trim(rsconsecutivo.codigo))>
					<cfset consecutivo = rsconsecutivo.codigo + 1>
				</cfif>
			
				<cfquery name="insert" datasource="#session.DSN#">
					insert into AFClasificaciones (Ecodigo, AFCcodigo, AFCcodigopadre, AFCcodigoclas,AFCdescripcion, AFCpath, AFCnivel, BMUsucodigo)
						values(	<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#consecutivo#" cfsqltype="cf_sql_integer">,
								<cfif isdefined("form.AFCcodigopadre") and len(trim(form.AFCcodigopadre))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.AFCcodigopadre#"><cfelse>null</cfif>,
								<cfqueryparam value="#Form.AFCcodigoclas#" cfsqltype="cf_sql_char">,
								<cfqueryparam value="#Form.AFCdescripcion#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#path#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#nivel#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
								) 
				</cfquery>
				<cfset modo="CAMBIO">
			<cfelse> 
				<cf_errorCode	code = "50044" msg = "No se puede ingresar. Ya existe una clasificación asignada.">
			</cfif>
	
			<cfcatch type="any">
				<cfinclude template="/sif/errorPages/BDerror.cfm">
				<cfabort>
			</cfcatch>		
		</cftry>
			
	<cfelseif isdefined("Form.Baja")>
		<cftry>
			<cfquery name="rsVerifica" datasource="#session.DSN#">
				select AFCcodigo
				from AFSaldos
				where Ecodigo   = #Session.Ecodigo#
				  and AFCcodigo = <cfqueryparam value="#Form.AFCcodigo#" cfsqltype="cf_sql_numeric">
			</cfquery>

			<cfif #rsVerifica.recordCount# eq 0>
				<cfquery name="delete" datasource="#session.DSN#">
					delete from AFClasificaciones
					where Ecodigo   = #Session.Ecodigo#
					  and AFCcodigo = <cfqueryparam value="#Form.AFCcodigo#" cfsqltype="cf_sql_numeric">
				</cfquery>
				<cfset modo="ALTA">
			<cfelse>
				<cf_errorCode	code = "50045" msg = "No se puede borrar. Existen tipos de activos asignados a los saldos.">
			</cfif>

			<cfcatch type="any">
				<cfinclude template="/sif/errorPages/BDerror.cfm">
				<cfabort>
			</cfcatch>		
		</cftry>

	<cfelseif isdefined("Form.Cambio")>
	<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

	
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="AFClasificaciones" 
			redirect="tipoactivo.cfm?arbol_pos=#form.AFCcodigo#"
			timestamp="#form.ts_rversion#"
			field1="Ecodigo,integer,#Session.Ecodigo#"
			field2="AFCcodigo,integer,#form.AFCcodigo#">

		<cftransaction>
			<cfquery name="update" datasource="#session.DSN#">
				update AFClasificaciones
				set AFCdescripcion = <cfqueryparam value="#Form.AFCdescripcion#" cfsqltype="cf_sql_varchar">,
					AFCcodigoclas = <cfqueryparam value="#Form.AFCcodigoclas#" cfsqltype="cf_sql_char">,
					AFCnivel = <cfqueryparam cfsqltype="cf_sql_integer" value="#nivel#">,
					AFCpath = <cfqueryparam cfsqltype="cf_sql_varchar" value="#path#">,
					AFCcodigopadre = <cfif isdefined("form.AFCcodigopadre") and len(trim(form.AFCcodigopadre))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.AFCcodigopadre#"><cfelse>null</cfif>
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and AFCcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AFCcodigo#">
			</cfquery>

				<!--- Reordenamiento del arbolito --->	
				<!--- solo si cambia padre o codigo --->
				<cfif (form.AFCcodigopadre neq form._AFCcodigopadre) or (trim(form.AFCcodigoclas) neq trim(form._AFCcodigoclas)) >
					<cfquery name="update_path" datasource="#session.DSN#" >
						  update AFClasificaciones
						  set AFCpath = right( '*****'  #_Cat# ltrim(rtrim(AFCcodigoclas)), 5),
					  		AFCnivel =  case when AFCcodigopadre is null then 0 else -1 end
						  where Ecodigo= #session.Ecodigo#
					</cfquery>
						
					<cfset nivel  = 0 >	
					<cfset session.debug=true>
					<cfoutput>
						<cfloop from="0" to="99" index="i">
						
						<cfquery name="clasifica" datasource="#session.dsn#">
							select p.AFCpath  as AFCpath
								from AFClasificaciones p inner join AFClasificaciones c
								on p.AFCcodigo = c.AFCcodigopadre
								 and p.Ecodigo = c.Ecodigo
								 and p.AFCnivel = #nivel#
						</cfquery>
							
						
						<cfquery datasource="#session.DSN#">
							update AFClasificaciones set 
								AFCpath = '#clasifica.AFCpath#'
							 
								#_Cat#  '/' #_Cat#  right ('*****' #_Cat#  rtrim(ltrim(AFClasificaciones.AFCcodigoclas)), 5),
								 AFCnivel = #nivel + 1#
								where Ecodigo = #session.Ecodigo#
								and AFCnivel = -1 
						</cfquery>
													
						<cfquery datasource="#session.dsn#" name="rsSeguir">
							select count(1) as cantidad
							from AFClasificaciones 
							where Ecodigo= #session.Ecodigo#
							  and AFCnivel=-1
						</cfquery>
						
						<cfif rsSeguir.cantidad eq 0>
							<cfbreak>
						</cfif>
						<cfset nivel = nivel + 1 >
						
						<cfif nivel gt 100 >
							<cf_errorCode	code = "50046" msg = "El arbol no puede tener más de 100 niveles">
						</cfif>
					</cfloop>
					</cfoutput>						
				</cfif><!--- reordenamiento --->

				<cfquery name="rsvalidar" datasource="#session.DSN#">
					select max(AFCnivel) as nivelMaximo
					from AFClasificaciones
					where Ecodigo= #session.Ecodigo#
				</cfquery>

				<cfif rsvalidar.Recordcount gt 0 and len(trim(rsvalidar.nivelMaximo))>
					<cfif not _nivel(rsvalidar.nivelMaximo) >
						<cftransaction action="rollback">
						<cf_errorCode	code = "50043" msg = "Ha excedido el nivel máximo para la Clasificación de Artículos.">
					</cfif>
				</cfif>
			</cftransaction>
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<cfoutput>
	<cfset parametros = ''>	
	<cfif isdefined("form.Cambio")>
		<cfset parametros = '?arbol_pos=#form.AFCcodigo#'>
	<cfelseif isdefined("form.Alta")>
		<cfset parametros = '?arbol_pos=#consecutivo#'>
	</cfif>
	<cflocation url="tipoactivo.cfm#parametros#">
</cfoutput>


