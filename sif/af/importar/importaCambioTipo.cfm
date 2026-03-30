<!--- Tabla Temporal de Errores --->
<cf_dbtemp name="ERRORES_TEMP" returnvariable="ERRORES_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="Mensaje" type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="ErrorNum" type="integer" mandatory="yes">
</cf_dbtemp> 
<!--- Valida que tengan registros duplicados  --->
<cfquery name="rsCheck1" datasource="#session.DSN#">
	select distinct upper(ltrim(rtrim(Aplaca))) as APLACA
	from #table_name# 
</cfquery>
<cfquery name="rsCheck1D" datasource="#session.DSN#">
	select  upper(ltrim(rtrim(Aplaca))) as APLACA
	from #table_name# 
</cfquery>

<cfif rsCheck1D.RecordCount NEQ rsCheck1.RecordCount>
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
		values('Existen placas repetidas en el archivo de importación',1)
	</cfquery>
</cfif>
<!--- Valida que las placas sean validas  --->
<cfquery name="INS_Error" datasource="#session.DSN#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select <cf_dbfunction name="concat" args="'La placa :', x.Aplaca ,' no existe'">  ,2
	from #table_name# x
	where  ltrim(rtrim(x.Aplaca)) not in (
		select ltrim(rtrim(a.Aplaca)) 
		from Activos a 
		where a.Ecodigo =  #session.Ecodigo# )
</cfquery>
<!--- Valida que las placas este activas  --->
<cfquery name="INS_Error" datasource="#session.DSN#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select <cf_dbfunction name="concat" args="'La placa :' , x.Aplaca ,' se encuentra inactiva'"> ,3
	from #table_name# x
	where  ltrim(rtrim(x.Aplaca)) in (
			select ltrim(rtrim(a.Aplaca)) 
			from Activos a 
			where a.Ecodigo =  #session.Ecodigo# 
			and a.Astatus = 60)
</cfquery>
<!--- Valida el tipo  --->
<cfquery name="INS_Error" datasource="#session.DSN#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select <cf_dbfunction name="concat" args="'El tipo de Activo: ' , x.AFCcodigoclas ,' no existe.'"> ,4 
	from #table_name# x
		where  ltrim(rtrim(x.AFCcodigoclas)) not in (
			select a.AFCcodigoclas 
			from AFClasificaciones a 
			where a.Ecodigo =  #session.Ecodigo# )
</cfquery>
<!--- Valida el tipo ultimo nivel--->
<cfquery name="INS_Error" datasource="#session.DSN#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select  <cf_dbfunction name="concat" args="'El tipo de Activo:', x.AFCcodigoclas,' no se encuentran a último nivel '">  ,5
	from #table_name# x
		where  ltrim(rtrim(x.AFCcodigoclas)) in (
			select AFCcodigoclas 
			from AFClasificaciones a
			where Ecodigo =  #session.Ecodigo# 
			   and exists (	select 1 
							from AFClasificaciones b
							where b.Ecodigo = a.Ecodigo
								and b.AFCcodigopadre != a.AFCcodigo))						
</cfquery>
<!--- Valida relacion valida entre placa, periodo, mes---->

<!--- Periodo--->
<cfquery name="rsPeriodo" datasource="#session.DSN#">
	select p1.Pvalor as value 
	  from Parametros p1 
	where Ecodigo =  #session.Ecodigo# 
	and Pcodigo = 50
</cfquery>

<!--- Mes --->
<cfquery name="rsMes" datasource="#session.DSN#">
	select p1.Pvalor as value 
	 from Parametros p1 
	where Ecodigo =  #session.Ecodigo# 
	 and Pcodigo = 60
</cfquery>

<cfquery name="INS_Error" datasource="#session.DSN#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select <cf_dbfunction name="concat" args="'No existe existe relación en la tabla saldos entre la Placa del Activo (' + tt.Aplaca + '), el Periodo (#rsPeriodo.value#) y el Mes (#rsPeriodo.value#)'" delimiters= "+"> ,6
	from #table_name# tt
		inner join Activos ta
		   on tt.Aplaca = ta.Aplaca
		   and ta.Ecodigo =  #session.Ecodigo# 
	where not exists (select 1
				       from AFSaldos a
				      where a.Aid = ta.Aid
				      and a.Ecodigo = ta.Ecodigo
				      and a.AFSperiodo =  #rsPeriodo.value# 
				      and a.AFSmes =  #rsMes.value#)
</cfquery>

<!--- Valida que la placa no se encuetra en un proceso ---->
<cfquery name="INS_Error" datasource="#session.DSN#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select <cf_dbfunction name="concat" args="'La Placa del Activo (' + tt.Aplaca + ') ya se encuentra en un grupo de cambios de tipo'" delimiters= "+"> ,7
	from #table_name# tt
		inner join Activos ta
		   on tt.Aplaca = ta.Aplaca
		   and ta.Ecodigo =  #session.Ecodigo# 
	where exists (select 1
		           from ADTProceso xyz
		          where xyz.Ecodigo = ta.Ecodigo
		          and xyz.Aid = ta.Aid
		          and xyz.IDtrans = 7)
</cfquery>

<cfquery name="err" datasource="#session.dsn#">
	select Mensaje
	from #ERRORES_TEMP#
	order by Mensaje,ErrorNum
</cfquery>

<!--- Si hay errores los devuelve, si no realiza el proceso de importación --->

<cfset descripcion = 'Importación de archivo por '& #session.usulogin# & ' ('& LSDateFormat(Now(), "dd/mm/yyyy")& ' : ' & LSTimeFormat(Now(), 'hh:mm') &')'>

<cfif (err.recordcount) EQ 0>
	<!--- Crea la FechaAux a partir del periodo / mes de auxiliares y le pone el último día del mes --->
	<cfset rsFechaAux.value = CreateDate(fnIsNull(rsPeriodo.value,01), fnIsNull(rsMes.value,01), 01)>
	<cfset rsFechaAux.value = DateAdd("m",1,rsFechaAux.value)>
	<cfset rsFechaAux.value = DateAdd("d",-1,rsFechaAux.value)>
	
	<!--- Obtiene la Moneda Local --->
	<cfquery name="rsMoneda" datasource="#session.DSN#">
		select Mcodigo as value
		  from Empresas 
		where Ecodigo =  #session.Ecodigo# 
	</cfquery>
	<cfif not isdefined("form.AGTPid")>
		<!--- inserta el encabezado --->
        <cfinvoke component="sif.Componentes.AF_CAMTIPO" method="AF_CAMTIPOACT"
                returnvariable="rsResultadosDA">
            <cfinvokeargument name="AGTPdescripcion" value="#descripcion#">
            <cfinvokeargument name="debug" value="false">
        </cfinvoke>
        <cfset form.AGTPid = rsResultadosDA>
    </cfif>
   
	<!--- inserta el detalle --->
	<cfquery datasource="#session.DSN#">
		insert into ADTProceso 
			(
			Ecodigo, 
			AGTPid, 
			Aid, 
			IDtrans, 
			CFid, 
			TAperiodo, 
			TAmes, 
			TAfecha, 
			TAfalta, 
			TAmontooriadq, 
			TAmontolocadq, 
			TAmontoorimej, 
			TAmontolocmej, 
			TAmontoorirev, 
			TAmontolocrev, 
			Mcodigo,
			TAtipocambio, 
			Usucodigo, 
			BMUsucodigo,
			AFCcodigoAnt, 
			AFCcodigoNuevo
			)
			(
		select
		    #session.Ecodigo# ,
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.AGTPid#">,
			a.Aid,
			7,
			af.CFid,
			#rsPeriodo.value#  as TAperiodo_de_auxiliares,
			#rsMes.value#  as TAmes_de_auxiliares,
			#rsFechaAux.value# as TAfecha_de_auxiliares,
			#now()# as TAfalta,
			af.AFSvaladq,
			af.AFSvaladq,
			af.AFSvalmej,
			af.AFSvalmej,
			af.AFSvalrev,
			af.AFSvalrev,
			#rsMoneda.value#  as Mcodigo,
			1.00 as TAtipocambio,
			#session.Usucodigo#  as Usucodigo,
			#session.Usucodigo#  as BMUsucodigo,
			a.AFCcodigo,
			(select min(AFC.AFCcodigo)
				from AFClasificaciones AFC
			  where AFC.Ecodigo =  #session.Ecodigo# 
			  and rtrim(ltrim(AFC.AFCcodigoclas)) = rtrim(ltrim(tn.AFCcodigoclas))
			)
			from #table_name# tn
			  inner join Activos a
				 on a.Aplaca = tn.Aplaca
				and a.Ecodigo =  #session.Ecodigo# 
			  inner join 	AFSaldos af	
				 on af.Aid = a.Aid
				and af.Ecodigo = a.Ecodigo	
				and af.AFSperiodo =  #rsPeriodo.value# 
				and af.AFSmes =  #rsMes.value# 
				and af.Aid = a.Aid
		)
	</cfquery>
</cfif>

<cffunction name="fnIsNull" access="private" returntype="boolean" output="false">
	<cfargument name="lValue"       required="yes" type="any">
	<cfargument name="IValueIfNull" required="yes" type="any">
	<cfif len(trim(lValue))>
		<cfreturn lValue>
	<cfelse>
		<cfreturn lValueIfNull>
	</cfif>
</cffunction>