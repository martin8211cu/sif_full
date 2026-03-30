<cf_dbtemp name="ERRORES_TEMP1" returnvariable="ERRORES_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="Mensaje" 	type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="ErrorNum" 	type="integer" 		mandatory="yes">
	<cf_dbtempcol name="Articulo" 	type="varchar(20)" 	mandatory="no">
</cf_dbtemp>
<!--- VALIDA QUE EL ARCHIVO A IMPORTAR NO VENGA VACIO --->
<cfquery name="rsCheck1" datasource="#Session.DSN#">
	select 1
	from #table_name#
</cfquery>

<cfif isdefined("rsCheck1") and  rsCheck1.recordcount EQ 0>
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,Articulo)
		values('El archivo de importaci&oacute;n no tiene l&iacute;neas',1,null)
	</cfquery>
<cfelse>
	<!--- VALIDA QUE EL ARCHIVO A IMPORTAR NO TENGA REGISTROS DUPLICADOS PARA UN ARTICULO,MONEDA,PERIODO Y MES --->
	<cfquery name="rsCheck2" datasource="#Session.Dsn#">
		select  count(distinct Acodigo) as cant_reg  
		 from #table_name# 
	</cfquery>
	<cfif isdefined("rsCheck2") and  rsCheck1.recordcount neq rsCheck2.cant_reg>
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje,ErrorNum,Articulo)
			values('El archivo de importaci&oacute;n tiene art&iacute;culos duplicados ',1,null)
		</cfquery>
	</cfif>
	<!--- VALIDA QUE EL COSTO SEA MAYOR QUE CERO --->
	<cfquery name="rsCheck3" datasource="#Session.Dsn#">
		select 1
		from #table_name#
		where Costo <= 0
	</cfquery>
	<cfif isdefined("rsCheck3") and  rsCheck3.recordcount gt 0>
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje,ErrorNum,Articulo)
			values('El archivo de importaci&oacute;n tiene art&iacute;culos con costo menor o igual a cero ',1,null)
		</cfquery>
	</cfif>	
	<!--- VALIDA QUE EL COSTO SEA MAYOR QUE CERO --->
	<cfquery name="rsCheck4" datasource="#Session.Dsn#">
		select 1
		from #table_name#
		where PrecioMercado <= 0
	</cfquery>
	<cfif isdefined("rsCheck4") and  rsCheck4.recordcount gt 0>
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje,ErrorNum,Articulo)
			values('El archivo de importaci&oacute;n tiene art&iacute;culos con precio de mercado menor o igual a cero ',1,null)
		</cfquery>
	</cfif>	
	<!--- VALIDA ARTICULOS --->
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,Articulo)
		select <cf_dbfunction name="concat" args="'El articulo: ''',x.Acodigo,''' no existe en el catalogo de articulos'">,4,x.Acodigo
		from #table_name# x
		where  ltrim(rtrim(x.Acodigo)) not in (
			select ltrim(rtrim(b.Acodigo)) 
			from Articulos b
			where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
	</cfquery>	
	<!--- VALIDA MONEDA --->
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,Articulo)
		select <cf_dbfunction name="concat" args="'El articulo: '''+x.Acodigo+''' tiene una moneda que no existe ('+ x.Moneda +')'" delimiters='+'>,4,x.Acodigo
		from #table_name# x
		where  ltrim(rtrim(x.Moneda)) not in (
			select ltrim(rtrim(b.Miso4217)) 
			from Monedas b
			where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
	</cfquery>
</cfif>

<cfquery name="err" datasource="#session.dsn#">
	select Mensaje
	from #ERRORES_TEMP#
	order by Articulo,ErrorNum
</cfquery>	

<cfif (err.recordcount) EQ 0>
	<!--- BUSCA EL PERIODO  --->
	<cfquery name="rsPeriodo" datasource="#session.dsn#">
		select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as Pvalor
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Pcodigo = 50
		and Mcodigo = 'GN'
	</cfquery>
	<cfset Periodo = rsPeriodo.Pvalor >
	<!--- BUSCA EL MES  --->
	<cfquery name="rsMes" datasource="#session.dsn#">
		select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as Pvalor
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Pcodigo = 60
		and Mcodigo = 'GN'
	</cfquery>
	<cfset Mes = rsMes.Pvalor >
	<!--- BUSCA EL MONEDA LOCAL  --->
	<cfquery name="rsMonloc" datasource="#session.dsn#">
		 select Mcodigo from Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
	<cfset Monloc =  rsMonloc.Mcodigo>
	
	<!--- BUSCA LAS EMPRESAS DE LA COORPORACION QUE TIENEN LA MISMA MONEDA LOCAL.   --->
	<cfquery name="rsEmpresa" datasource="asp">
		select  Ecodigo from Empresa 
		where CEcodigo = #session.CEcodigo#
		and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Monloc#">
		and Ereferencia is not null
	</cfquery>
	
	<cfset empresas =''>
	<cfloop query="rsEmpresa">
		<cfset empresas= empresas & rsEmpresa.Ecodigo & ','>
	</cfloop>
	<cfset empresas = empresas & '-1'>
	
	<cfoutput>
			<cfquery name="rs_CostoProduccionSTD" datasource="#session.dsn#">
				select coalesce(x.Costo,0) as Costo, coalesce(x.PrecioMercado, 0) as PrecioMercado 
				from CostoProduccionSTD cp
					inner join Empresas e
						on cp.Ecodigo = e.Ecodigo
						and e.EcodigoSDC in (#empresas#)
					inner join Articulos a
						on a.Ecodigo = e.Ecodigo
						and a.Aid     = cp.Aid
					inner join #table_name# x
						on x.Acodigo = a.Acodigo
				WHERE cp.CTDperiodo = #Periodo#
				and cp.CTDmes     = #Mes#
			</cfquery>
			
			
			
			<cfif rs_CostoProduccionSTD.recordcount gt 0>
			<cfquery datasource="#session.dsn#">
				update CostoProduccionSTD set 
					CTDcosto = #rs_CostoProduccionSTD.Costo#,
					CTDprecio = #rs_CostoProduccionSTD.PrecioMercado#,
					fechaalta = #now()#
			</cfquery>
		 </cfif>

<!---		<cf_dbupdate table="CostoProduccionSTD" datasource="#session.dsn#">
			<cf_dbupdate_join table="Empresas e">
					 on CostoProduccionSTD.Ecodigo = e.Ecodigo
					and e.EcodigoSDC in (#empresas#)
			</cf_dbupdate_join>
			<cf_dbupdate_join table="Articulos a">
					 on a.Ecodigo = e.Ecodigo
					and a.Aid     = CostoProduccionSTD.Aid
			</cf_dbupdate_join>
			<cf_dbupdate_join table="#table_name# x">
					   on x.Acodigo = a.Acodigo
			</cf_dbupdate_join>
			<cf_dbupdate_set name='CTDcosto' expr="coalesce(x.Costo,0)" />
			<cf_dbupdate_set name='CTDprecio' expr="coalesce(x.PrecioMercado, 0)" />
			<cf_dbupdate_set name='fechaalta' expr="'#DateFormat(now(), "YYYYMMDD HH:MM")#'" />
			<cf_dbupdate_where>
				WHERE CostoProduccionSTD.CTDperiodo = <cf_dbupdate_param type="integer" value="#Periodo#">
				  and CostoProduccionSTD.CTDmes     = <cf_dbupdate_param type="integer" value="#Mes#">
			</cf_dbupdate_where>						
		</cf_dbupdate>				
--->	</cfoutput>	

	<cfquery name="RSregistros" datasource="#session.dsn#">
		insert into CostoProduccionSTD ( Aid, Ecodigo, CTDcosto, CTDprecio, CTDperiodo, CTDmes, Mcodigo, fechaalta , BMUsucodigo )
		select 
			a.Aid, 
			a.Ecodigo, 
			x.Costo, 
			x.PrecioMercado, 
			#periodo#, 
			#mes#, 
			m.Mcodigo, 
			<cf_jdbcquery_param value="#now()#" cfsqltype="cf_sql_timestamp">,
			#session.Usucodigo#
		from #table_name# x, Empresas e, Articulos a, Monedas m
		where e.EcodigoSDC in (#empresas#)
		  and a.Ecodigo = e.Ecodigo
		  and a.Acodigo = x.Acodigo
		  and m.Miso4217 = x.Moneda
		  and m.Ecodigo  = a.Ecodigo
		  and not exists (
		  		select 1
				from CostoProduccionSTD cp
				where cp.Aid = a.Aid
				  and cp.CTDperiodo = #Periodo#
				  and cp.CTDmes     = #Mes#
				) 
	</cfquery>
</cfif>


