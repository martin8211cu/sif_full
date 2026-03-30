<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfif isdefined("form.alta")>
	<cfset lvar_ruta = trim(form.GAcodigo)>
	<cfset lvar_profundidad = 0>
	<cfif len(form.GApadre)>
		<!--- En modo alta puede obtener la ruta y profundidad del padre como base para la ruta y profundidad del nuevo registro porque el nuevo registro 
		no tiene hijos asociados. En las siguientes lneas se obtienen estos datos y se completan con la informacin del nuevo registro para insertarlos.  --->
		<cfquery name="rsPadre" datasource="#session.dsn#">
			select GAruta, GAprofundidad
			 from AnexoGrupo 
			where CEcodigo =  #session.cecodigo# 
			  and GAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GApadre#">
		</cfquery>
		<cfif rsPadre.recordcount eq 0>
			<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=<strong>Error. El Padre Seleccionado es incorrecto. Proceso Cancelado!.</strong>" addtoken="no">
			<cfabort> 
		</cfif>
		<cfset lvar_ruta = rsPadre.GAruta & '/' & trim(form.GAcodigo)>
		<cfset lvar_profundidad = rsPadre.GAprofundidad + 1>
	</cfif>
	
	<cftransaction>
		<cfquery name="rssql" datasource="#session.dsn#">
			insert into AnexoGrupo 
			(CEcodigo, GAcodigo, GAnombre, GAdescripcion, GApadre, GAruta, GAprofundidad, BMfecha, BMUsucodigo)
			values ( #session.cecodigo# , 
				<cfqueryparam cfsqltype="cf_sql_varchar"   value="#trim(form.GAcodigo)#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar"   value="#form.GAnombre#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar"   value="#form.GAdescripcion#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric"   value="#form.GApadre#" null="#len(form.GApadre) eq 0#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar"   value="#lvar_ruta#">, 
				<cfqueryparam cfsqltype="cf_sql_integer"   value="#lvar_profundidad#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
				 #session.usucodigo# )
			<cf_dbidentity1 datasource="#session.dsn#">
		</cfquery>
		    <cf_dbidentity2 name="rssql" datasource="#session.dsn#">
				
		<cfquery datasource="#session.dsn#">
			insert into AnexoGrupoCubo (CEcodigo, GApadre, GAhijo, GAprofundidad)
			values( 
					 #session.cecodigo# ,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rssql.identity#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rssql.identity#">,
					0
				  )
		</cfquery>
		
		<cfif len(form.GApadre)>
			<!--- Debe insertarse un registro que me dice 
			que yo soy hijo del padre seleccionado en el cubo --->
			<cfquery datasource="#session.dsn#">
				insert into AnexoGrupoCubo (CEcodigo, GApadre, GAhijo, GAprofundidad)
				values( 
						 #session.cecodigo# ,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GApadre#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rssql.identity#">,
						1
					  )
			</cfquery>
		</cfif>
	</cftransaction>
		
<cfelseif isdefined("form.cambio")>
	<cf_dbtimestamp
				datasource="#session.dsn#"
				table="AnexoGrupo" 
				redirect="index.cfm?GAid=#form.GAid#"
				timestamp="#form.ts_rversion#"
				field1="CEcodigo,numeric,#session.cecodigo#"
				field2="GAid,numeric,#form.GAid#">
	<cftransaction>
		<cfquery name="rssql" datasource="#session.dsn#">
			update AnexoGrupo 
			set GAcodigo = 		<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.GAcodigo#">,
				GAnombre = 		<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.GAnombre#">,
				GAdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.GAdescripcion#">,
				GApadre = 		<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.GApadre#" null="#len(form.GApadre) eq 0#">,
				BMfecha = 		<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#Now()#">,
				BMUsucodigo =  	#session.usucodigo# 
			where CEcodigo =  	#session.cecodigo# 
			  and GAid = 		<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.GAid#">
		</cfquery>
		<cfquery datasource="#session.dsn#">
			update AnexoGrupo 
			set GAruta = GAcodigo,
				GAprofundidad = case when GApadre is null then 0 else -1 end
			where CEcodigo =  #session.cecodigo# 
		</cfquery>
		
		<cfquery datasource="#session.dsn#">
			delete from AnexoGrupoCubo
			where CEcodigo =  #session.cecodigo# 
		</cfquery>
		
		<cfquery datasource="#session.dsn#">
			insert into AnexoGrupoCubo (CEcodigo, GApadre, GAhijo, GAprofundidad)
			select  #session.cecodigo# ,
				GAid, GAid, 0
			from AnexoGrupo
			where CEcodigo =  #session.cecodigo# 
		</cfquery>
		
		<cfloop from="0" to="99" index="nivel">
		
			<cfquery datasource="#session.dsn#">
				insert into AnexoGrupoCubo (CEcodigo, GApadre, GAhijo, GAprofundidad)
				select  #session.cecodigo# ,
					g.GApadre, c.GAhijo, c.GAprofundidad + 1 
				from AnexoGrupo g
					join AnexoGrupoCubo c
						on c.GApadre = g.GAid
				where g.CEcodigo =  #session.cecodigo# 
				  and c.GAprofundidad = #nivel#
				  and g.GApadre is not null
			</cfquery>
			
			<cfquery datasource="#session.dsn#">
				update AnexoGrupo
					set GAruta = (select padre.GAruta #_Cat# '/' #_Cat# AnexoGrupo.GAcodigo
								 	from AnexoGrupo padre
								  where padre.GAid          = AnexoGrupo.GApadre
								    and padre.CEcodigo      = AnexoGrupo.CEcodigo
								    and padre.GAprofundidad = #nivel#),
					GAprofundidad = #nivel + 1#
				where CEcodigo =  #session.cecodigo#
				  and GAprofundidad = -1
				  and (select count(1)
						 from AnexoGrupo padre
						where padre.GAid          = AnexoGrupo.GApadre
						  and padre.CEcodigo      = AnexoGrupo.CEcodigo
						  and padre.GAprofundidad = #nivel#
					  ) > 0
			</cfquery>
			
			<cfquery name="rsValidate" datasource="#session.dsn#">
				select 1
				from AnexoGrupo
				where CEcodigo =  #session.cecodigo# 
				and GAprofundidad = -1
			</cfquery>
			<cfif rsValidate.recordcount eq 0>
				<cfbreak>
			</cfif>
			<cfif nivel gt 98>
				<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errMsg=<strong>Error. Error Actualizando ruta y profundidad. Proceso Cancelado!!.</strong>" addtoken="no">
				<cfabort> 
			</cfif>
		</cfloop>
	</cftransaction>
<cfelseif isdefined("form.baja")>
	
	<cfquery name="rsExiste" datasource="#session.dsn#">
		select 1
		from AnexoGrupo 
		where CEcodigo =  #session.cecodigo# 
		and GApadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GAid#">
	</cfquery>
	<cfif rsExiste.recordcount>
			<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errMsg=<strong>Error. El grupo que desea asociar tiene 1 o ms grupos hijos, primero elimine sus hijos antes de eliminar el grupo. Proceso Cancelado!!.</strong>" addtoken="no">
			<cfabort> 
	</cfif>
	
	<!--- Borra del cubo --->
	<cfquery name="rssqlcubo" datasource="#session.dsn#">
		delete from AnexoGrupoCubo
		where GAhijo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GAid#">
	</cfquery>	
	
	<cfquery name="rssql" datasource="#session.dsn#">
		delete from AnexoGrupo 
		where CEcodigo =  #session.cecodigo# 
		and GAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GAid#">
	</cfquery>
</cfif>
<cflocation url="index.cfm">