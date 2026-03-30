<!---
    modificado por danim,2005-09-06, para 
    incluir los parametros de Grupo de Empresas
    y Grupo de Oficinas
	Tanto en AnexoCalculo como en AnexoVarValor,
		Ecodigo debe ser -1 cuando GEcodigo != -1,
		es decir, la información para grupos de
		empresas se guarda sin indicar una empresa
		específica, esto permite realizar las búsquedas
		con la empresa -1
--->
<cfif isdefined("url.CVGE")>
	<cfparam name="url.AVano">
	<cfparam name="url.AVmes">
	<cfparam name="url.AVid">
	<cfparam name="url.GEid">
	<cfparam name="url.U">
	<cfparam name="url.V">
	
	<cfset Lvar_Avano = url.AVano>
	<cfset Lvar_AVmes = url.AVmes>
	<cfset funcCalcularGE (url.GEid,url.AVid)>
	<cflocation url="index.cfm?AVano=#url.AVano#&AVmes=#url.AVmes#&ubicacion=#url.U#&AVid=#url.V#">
<cfelseif isdefined("url.CVGO")>
	<cfparam name="url.AVano">
	<cfparam name="url.AVmes">
	<cfparam name="url.AVid">
	<cfparam name="url.GOid">
	<cfparam name="url.U">
	<cfparam name="url.V">
	
	<cfset Lvar_Avano = url.AVano>
	<cfset Lvar_AVmes = url.AVmes>
	<cfset funcCalcularGO (url.GOid,url.AVid)>
	<cflocation url="index.cfm?AVano=#url.AVano#&AVmes=#url.AVmes#&ubicacion=#url.U#&AVid=#url.V#">
</cfif>

<cfparam name="form.AVano">
<cfparam name="form.AVmes">
<cfparam name="form.AVid">
<cfparam name="form.ubicacion">

<cfset Lvar_Avano = form.AVano>
<cfset Lvar_AVmes = form.AVmes>

<cffunction name="funcUpdateValor" access="private" returntype="string" output="false">
	<cfargument name="AVid" type="numeric" required="true">
	<cfargument name="AVano" type="numeric" required="true">
	<cfargument name="AVmes" type="numeric" required="true">
	<cfargument name="UbicaID" type="numeric" required="true">
	<cfargument name="AVvalor" type="string" required="true">

	<cfset myEcodigo = IIf(ListFirst(form.ubicacion) EQ 'ge', -1, session.Ecodigo)>
	<cfset myGEid    = IIf(ListFirst(form.ubicacion) EQ 'ge', Arguments.UbicaID, -1)>
	<cfset myGOid    = IIf(ListFirst(form.ubicacion) EQ 'go', Arguments.UbicaID, -1)>
	<cfset myOcodigo = IIf(ListFirst(form.ubicacion) EQ 'of', Arguments.UbicaID, -1)>

	<cfquery name="var_info" datasource="#session.dsn#">
		select AVtipo, AVvalor_anual
		from AnexoVar
		where AVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.AVid#">
	</cfquery>

	<!--- Verifica si existe el valor --->
	<cfquery name="rsAnexoVarValor" datasource="#session.dsn#">
		select AVvalor
		from AnexoVarValor
		where AVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.AVid#">
			and AVano = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.AVano#">
	  		<cfif var_info.AVvalor_anual EQ "1">
				and AVmes = 1
			<cfelse>
				and AVmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.AVmes#">
			</cfif>
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#myEcodigo#">
			and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#myOcodigo#">
			and GEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#myGEid#">
			and GOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#myGOid#">
	</cfquery>

	<cfif var_info.AVtipo NEQ 'C'>
		<cfset Arguments.AVvalor = Replace(Arguments.AVvalor, ',', '', 'all')>
	</cfif>

	<cfif rsAnexoVarValor.recordcount>
		<!--- Actualiza el valor si existe y cambio --->
		<cfquery datasource="#session.dsn#">
			update AnexoVarValor
			set AVvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.AVvalor#">,
				BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			where AVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.AVid#">
				and AVano = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.AVano#">
	  		<cfif var_info.AVvalor_anual EQ "1">
				and AVmes = 1
			<cfelse>
				and AVmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.AVmes#">
			</cfif>
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#myEcodigo#">
				and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#myOcodigo#">
				and GEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#myGEid#">
				and GOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#myGOid#">
		</cfquery>
		<cfset Lvar_return = 'OLD'>
	<cfelse>
		<!--- Inserta el valor si no existe --->
		<cfquery datasource="#session.dsn#">
			insert into AnexoVarValor
				(AVid,AVano,AVmes,Ecodigo,Ocodigo,GEid,GOid,AVvalor,BMfecha,BMUsucodigo)
			values
				(<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.AVid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.AVano#">,
				  		<cfif var_info.AVvalor_anual EQ "1">
							1,
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.AVmes#">,
						</cfif>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#myEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#myOcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#myGEid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#myGOid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.AVvalor#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
		</cfquery>
		<cfset Lvar_return = 'NEW'>
	</cfif>
	<cfreturn Lvar_return>
</cffunction>

<cfif isdefined("form.btnGuardar")>
	<cfloop list="#form.campos#" index="campo">
		<cfset Lvar_Valor = form['valor_' & campo]>
		<cfset Lvar_Avid = ListFirst(campo,'_')>
		<cfset Lvar_UbicaID = ListRest(campo,'_')>
		<cfoutput>#campo#,#Lvar_Valor#,#Lvar_Avid#,#Lvar_UbicaID#</cfoutput><br>
		<cfset funcUpdateValor(Lvar_Avid,Lvar_Avano,Lvar_AVmes,Lvar_UbicaID,Lvar_Valor)>
	</cfloop>
<cfelseif isdefined("form.btnCalcular_Valores")>
	<cfif ListFirst(form.ubicacion) EQ 'ge'>
		<cfif ListLen(form.ubicacion) EQ 1>
			<cfset LvarGEid = -1>
			<cfset LvarAVid = form.AVid>
		<cfelse>
			<cfset LvarGEid = ListGetAt(form.ubicacion,2)>
			<cfset LvarAVid = -1>
		</cfif>
		<cfset funcCalcularGE (LvarGEid,LvarAVid)>
	<cfelseif ListFirst(form.ubicacion) EQ 'go'>
		<cfif ListLen(form.ubicacion) EQ 1>
			<cfset LvarGOid = -1>
			<cfset LvarAVid = form.AVid>
		<cfelse>
			<cfset LvarGOid = ListGetAt(form.ubicacion,2)>
			<cfset LvarAVid = -1>
		</cfif>
		<cfset funcCalcularGO (LvarGOid,LvarAVid)>
	<cfelse>
		<cfthrow message="No se envió el Grupo de Empresas">
	</cfif>
</cfif>
<cflocation url="index.cfm?AVano=#form.AVano#&AVmes=#form.AVmes#&ubicacion=#form.ubicacion#&AVid=#form.AVid#">

<cffunction name="funcCalcularGE" access="private" returntype="void" output="false">
	<cfargument name="GEid" type="numeric" required="true">
	<cfargument name="AVid" type="numeric" required="true">

	<cfif Arguments.GEid EQ -1 AND Arguments.AVid EQ -1>
		<cfthrow message="No se envió ni Grupo de Empresas ni variable">
	</cfif>

	<cfquery datasource="#session.dsn#">
		delete from AnexoVarValor
		 where AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Avano#">
		   and AVmes = 
				case when
						(
							select count(1) 
							  from AnexoVar
							 where AVid = AnexoVarValor.AVid 
							   and AVvalor_anual = 1
						) > 0
					then 1
					else <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_AVmes#">
				end
		<cfif Arguments.GEid NEQ -1>
			and GEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEid#">
		<cfelse>
			and coalesce(GEid,-1) <> -1
		</cfif>
		<cfif Arguments.AVid NEQ -1>
			and AVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AVid#">
		</cfif>
		  and (
		  		select count(1) 
				  from AnexoVar
				 where AVid = AnexoVarValor.AVid 
				   and AVusar_oficina = 0
				   and AVtipo in ('F','M')
				) > 0
	</cfquery>
	
	<cfquery datasource="#session.dsn#">
		insert into AnexoVarValor (
    		AVid, AVano, AVmes, 
			GEid, Ecodigo, Ocodigo, GOid, 
			AVvalor, 
			BMfecha, BMUsucodigo
		)
		<cf_dbfunction name="to_float" args="AVvalor" returnvariable="LvarAVvalorFloat">
		select av.AVid, avv.AVano, avv.AVmes, 
				ged.GEid, -1, -1, -1, 
    			<cf_dbfunction name="to_char" args="sum(#LvarAVvalorFloat#)"> as AVvalor,
    			<cf_dbfunction name="now">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		  from AnexoVarValor avv
			inner join AnexoVar av on avv.AVid = av.AVid 
			inner join AnexoGEmpresaDet ged on avv.Ecodigo = ged.Ecodigo
		 where avv.AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Avano#">
		   and avv.AVmes = case when av.AVvalor_anual = 1 then 1 else <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_AVmes#"> end
		<cfif Arguments.GEid NEQ -1>
			and ged.GEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEid#">
		</cfif>
		<cfif Arguments.AVid NEQ -1>
			and avv.AVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AVid#">
		</cfif>
		  and av.AVtipo in ('F','M')
		  and av.AVusar_oficina = 0
		group by ged.GEid,av.AVid, avv.AVano, avv.AVmes
	</cfquery>
</cffunction>

<cffunction name="funcCalcularGO" access="private" returntype="void" output="false">
	<cfargument name="GOid" type="numeric" required="true">
	<cfargument name="AVid" type="numeric" required="true">

	<cfif Arguments.GOid EQ -1 AND Arguments.AVid EQ -1>
		<cfthrow message="No se envió ni Grupo de Oficinas ni variable">
	</cfif>

	<cfquery datasource="#session.dsn#">
		delete from AnexoVarValor
		 where AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Avano#">
		   and AVmes = 
				case when
						(
							select count(1) 
							  from AnexoVar
							 where AVid = AnexoVarValor.AVid 
							   and AVvalor_anual = 1
						) > 0
					then 1
					else <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_AVmes#">
				end
		<cfif Arguments.GOid NEQ -1>
			and GOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GOid#">
		<cfelse>
			and coalesce(GOid,-1) <> -1
		</cfif>
		<cfif Arguments.AVid NEQ -1>
			and AVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AVid#">
		</cfif>
		  and (
		  		select count(1) 
				  from AnexoVar
				 where AVid = AnexoVarValor.AVid 
				   and AVusar_oficina = 1
				   and AVtipo in ('F','M')
				) > 0
	</cfquery>
	
	<cfquery datasource="#session.dsn#">
		insert into AnexoVarValor (
    		AVid, AVano, AVmes, 
			GOid, Ecodigo, Ocodigo, GEid, 
			AVvalor, 
			BMfecha, BMUsucodigo
		)
		<cf_dbfunction name="to_float" args="AVvalor" returnvariable="LvarAVvalorFloat">
		select av.AVid, avv.AVano, avv.AVmes, 
				god.GOid, #session.Ecodigo#, -1, -1, 
    			<cf_dbfunction name="to_char" args="sum(#LvarAVvalorFloat#)"> as AVvalor,
    			<cf_dbfunction name="now">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		  from AnexoVarValor avv
			inner join AnexoVar av on avv.AVid = av.AVid 
			inner join AnexoGOficinaDet god on avv.Ecodigo = god.Ecodigo and avv.Ocodigo = god.Ocodigo
		 where avv.AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Avano#">
		   and avv.AVmes = case when av.AVvalor_anual = 1 then 1 else <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_AVmes#"> end
		<cfif Arguments.GOid NEQ -1>
			and god.GOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GOid#">
		</cfif>
		<cfif Arguments.AVid NEQ -1>
			and avv.AVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AVid#">
		</cfif>
		  and av.AVtipo in ('F','M')
		  and av.AVusar_oficina = 1
		group by god.GOid,av.AVid, avv.AVano, avv.AVmes
	</cfquery>
</cffunction>