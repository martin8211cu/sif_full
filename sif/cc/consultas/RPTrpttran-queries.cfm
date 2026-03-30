<!--- Parámetros requeridos --->
<cfparam name="form.Speriodo" type="integer">
<cfparam name="form.Smes" type="integer">
<cfparam name="form.Mcodigo" type="integer">

<!--- Consulta de etiquetas para pintar títulos en el reporte --->
<cfquery name="rsEtiquetas" datasource="#session.dsn#">
	select CCTcolrpttranapl, CCTcolrpttranapldesc
	from CCTrpttranapl
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
</cfquery>

<!--- Creación de tablas temporales para armar el query para pintar el reporte --->
<cf_dbtemp name="informe" returnvariable="temp_informe" datasource="#session.dsn#">
	<cf_dbtempcol name="fecha" type="datetime">
	<cf_dbtempcol name="col" type="int">
	<cf_dbtempcol name="descripcion" type="varchar(35)">
	<cf_dbtempcol name="monto" type="money">
</cf_dbtemp>

<cf_dbtemp name="movdiarios" returnvariable="temp_movdiarios" datasource="#session.dsn#">
	<cf_dbtempcol name="fecha" type="datetime">
	<cf_dbtempcol name="col" type="int">
	<cf_dbtempcol name="monto" type="money">	
</cf_dbtemp>

<!--- Declaración explicita de variables locales para asignarles el tipo requerido --->
<cfset Lvar_fecha = now()>
<cfset Lvar_fecha2 = now()>
<cfset Lvar_col = 0>
<cfset Lvar_saldoinicial = 0.00>

<!--- Define los valores iniciales de la variables declaradas previamente --->
<cfset Lvar_fecha = CreateDate(form.Speriodo, form.Smes, 1)>
<cfset Lvar_fecha2 = CreateDate(form.Speriodo, form.Smes, DaysInMonth(Lvar_fecha))>

<cfquery name="rsCol" datasource="#session.dsn#">	
	select coalesce(max(c.CCTcolrpttranapl),1) as Col
	from CCTrpttranapl c
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
</cfquery>

<cfquery name="rsMonedas" datasource="#session.dsn#">
	select Mnombre
	from Monedas
	where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
</cfquery>

<cfif (isdefined("form.SNCEid") and len(trim(form.SNCEid)))>
		<cfif form.SNCDvalor2 LT form.SNCDvalor1>
			<cf_errorCode	code = "50168" msg = "El Valor Final es menor que el valor Inicial. Consulta Abortada!">
		</cfif>
		<cfquery name="rsClas" datasource="#session.dsn#">
			select a.SNCEcodigo, a.SNCEdescripcion, b.SNCDvalor, b.SNCDdescripcion
				from SNClasificacionE a
				 inner join SNClasificacionD b
				  on a.SNCEid = b.SNCEid
			where a.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCEid#">	
			<cfif (isdefined("form.SNCDvalor1") and len(trim(form.SNCDvalor1)))>
			and b.SNCDvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SNCDvalor1)#">
			</cfif>
			union
			select a.SNCEcodigo, a.SNCEdescripcion, b.SNCDvalor, b.SNCDdescripcion
				from SNClasificacionE a
					inner join SNClasificacionD b
						on a.SNCEid = b.SNCEid
			where a.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCEid#">	
			<cfif (isdefined("form.SNCDvalor2") and len(trim(form.SNCDvalor2)))>
				and b.SNCDvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SNCDvalor2)#">
			</cfif>
			order by SNCDvalor
		</cfquery>
</cfif>

<cfset Lvar_col = rsCol.Col>

<cfquery name="rsSI" datasource="#session.dsn#">
	
	select coalesce(sum(a.SIsaldoinicial),0.00) as SI
	from SNSaldosIniciales a
		<cfif (isdefined("form.SNCEid") and len(trim(form.SNCEid)))>
			inner join SNClasificacionSN cs
					inner join SNClasificacionD snd
						on snd.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCEid#">
				 		and snd.SNCDid = cs.SNCDid
				on cs.SNid = a.SNid
		</cfif>
	where a.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
	   and a.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Speriodo#">
	   and a.Smes 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Smes#">
	   and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
   		<cfif (isdefined("form.SNCEid") and len(trim(form.SNCEid)))>
			<cfif (isdefined("form.SNCDvalor1") and len(trim(form.SNCDvalor1)))>
				and snd.SNCDvalor >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SNCDvalor1)#">
			</cfif>
			<cfif (isdefined("form.SNCDvalor2") and len(trim(form.SNCDvalor2)))>
				and snd.SNCDvalor <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SNCDvalor2)#">
			</cfif>
		</cfif>
</cfquery>

<cfset Lvar_saldoinicial = rsSI.SI>
<!--- Inserta en temp_informe el Saldo Inicial del primer día del mes correspondiente al periodo mes definidos por el usuario, Columnas con 0.00 para cada etiqueta, 0.00 para Movimientos, 0.00 para Saldo Final para el mismo día. --->
<cfquery datasource="#session.dsn#">
	insert into #temp_informe# (fecha, col, descripcion, monto)
	select 	<cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_fecha#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="0">, 
			<cfqueryparam cfsqltype="cf_sql_char" value="Saldo Inicial">, 
			<cfqueryparam cfsqltype="cf_sql_money" value="#Lvar_saldoinicial#">
	from dual
</cfquery>

<cfquery datasource="#session.dsn#">
	insert into #temp_informe# (fecha, col, descripcion, monto)
	select 	<cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_fecha#">, 
			c.CCTcolrpttranapl, 
			c.CCTcolrpttranapldesc, 
			<cfqueryparam cfsqltype="cf_sql_money" value="0.00">
	from CCTrpttranapl c
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
</cfquery>

<cfquery datasource="#session.dsn#">
	insert into #temp_informe# (fecha, col, descripcion, monto)
	select 	<cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_fecha#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Col + 1#">, 
			<cfqueryparam cfsqltype="cf_sql_char" value="Movimientos">, 
			<cfqueryparam cfsqltype="cf_sql_money" value="0.00">
	from dual
</cfquery>

<cfquery datasource="#session.dsn#">
	insert into #temp_informe# (fecha, col, descripcion, monto)
	select 	<cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_fecha#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Col + 2#">, 
			<cfqueryparam cfsqltype="cf_sql_char" value="Saldo Final">, 
			<cfqueryparam cfsqltype="cf_sql_money" value="0.00">
	from dual
</cfquery>

<!--- Inserta en temp_informe el Saldo Inicial con 0.00, Columnas con 0.00 para cada etiqueta, 0.00 para Movimientos, 0.00 para Saldo Final para los demás días del mes --->

<cfset Lvar_fecha = DateAdd('d',1,Lvar_fecha)>

<cfloop condition="Lvar_fecha LTE Lvar_fecha2">

	<cfquery datasource="#session.dsn#">
		insert into #temp_informe# (fecha, col, descripcion, monto)
		select 	<cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_fecha#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="0">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="Saldo Inicial">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="0.00">
		from dual
	</cfquery>
	
	<cfquery datasource="#session.dsn#">
		insert into #temp_informe# (fecha, col, descripcion, monto)
		select 	<cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_fecha#">, 
				c.CCTcolrpttranapl, 
				c.CCTcolrpttranapldesc, 
				<cfqueryparam cfsqltype="cf_sql_money" value="0.00">
		from CCTrpttranapl c
		where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
	</cfquery>
	
	<cfquery datasource="#session.dsn#">
		insert into #temp_informe# (fecha, col, descripcion, monto)
		select 	<cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_fecha#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Col + 1#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="Movimientos">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="0.00">
		from dual
	</cfquery>
	
	<cfquery datasource="#session.dsn#">
		insert into #temp_informe# (fecha, col, descripcion, monto)
		select 	<cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_fecha#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Col + 2#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="Saldo Final">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="0.00">
		from dual
	</cfquery>
	
	<cfset Lvar_fecha = DateAdd('d',1,Lvar_fecha)>

</cfloop>

<!--- Se vuelven a definir las fechas por el procesamiento anterior --->
<cfset Lvar_fecha = CreateDate(form.Speriodo, form.Smes, 1)>

<cfset Lvar_fecha2 = DateAdd('m',1,Lvar_fecha)>


<!--- Inserta en temp_movdiarios todos los documentos generados por las fechas --->
<cfquery datasource="#session.dsn#">
	
	insert into #temp_movdiarios# (fecha, col, monto)
	select 
		<cf_dbfunction name="to_datechar" args="a.Dfecha">,
		b.CCTcolrpttranapl,
		sum(a.Dtotal * case b.CCTtipo when 'D' then 1 else -1 end)
	from  BMovimientos a
		inner join CCTransacciones b
			 on b.CCTcodigo = a.CCTcodigo
			and b.Ecodigo = a.Ecodigo
		inner join CCTrpttranapl c
			 on c.CCTcolrpttranapl = b.CCTcolrpttranapl
			and c.Ecodigo = b.Ecodigo
		<cfif (isdefined("form.SNCEid") and len(trim(form.SNCEid)))>
			inner join SNegocios sn
			on sn.SNcodigo = a.SNcodigo
			and sn.Ecodigo = a.Ecodigo
			inner join SNClasificacionSN snc
			on snc.SNid = sn.SNid
			inner join SNClasificacionD snd
			on snd.SNCDid = snc.SNCDid
			and snd.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCEid#">
			<cfif (isdefined("form.SNCDvalor1") and len(trim(form.SNCDvalor1)))>
				and snd.SNCDvalor >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SNCDvalor1)#">
			</cfif>
			<cfif (isdefined("form.SNCDvalor2") and len(trim(form.SNCDvalor2)))>
				and snd.SNCDvalor <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SNCDvalor2)#">
			</cfif>
		</cfif>
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
	   and a.Dfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_fecha#">
	   and a.Dfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_fecha2#">
	   and a.CCTcodigo = a.CCTRcodigo
	   and a.Ddocumento = a.DRdocumento
	   and a.Mcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
	group by a.Dfecha, b.CCTcolrpttranapl
	
</cfquery>

<!--- Recibos de Dinero: CCTcodigo tiene CCTtipo = 'C' y  CCTpago = 1.  CCTRcodigo tiene CCTtipo = 'D'  --->
<cfquery datasource="#session.dsn#">
	
	insert into #temp_movdiarios# (fecha, col, monto)
	select 
		<cf_dbfunction name="to_datechar" args="a.Dfecha">,
		b.CCTcolrpttranapl,
		sum(a.Dtotal * case b.CCTtipo when 'D' then 1 else -1 end)
	from  BMovimientos a
		inner join CCTransacciones b
			 on b.CCTcodigo = a.CCTcodigo
			and b.Ecodigo = a.Ecodigo
			and b.CCTtipo   = 'C'
			and b.CCTpago = 1
		inner join CCTransacciones t2
			on   t2.CCTcodigo = a.CCTRcodigo
			and t2.Ecodigo      = a.Ecodigo
			and t2.CCTtipo      = 'D'
		inner join CCTrpttranapl c
			 on c.CCTcolrpttranapl = b.CCTcolrpttranapl
			and c.Ecodigo = b.Ecodigo
		<cfif (isdefined("form.SNCEid") and len(trim(form.SNCEid)))>
			inner join SNegocios sn
			on sn.SNcodigo = a.SNcodigo
			and sn.Ecodigo = a.Ecodigo
			inner join SNClasificacionSN snc
			on snc.SNid = sn.SNid
			inner join SNClasificacionD snd
			on snd.SNCDid = snc.SNCDid
			and snd.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCEid#">
			<cfif (isdefined("form.SNCDvalor1") and len(trim(form.SNCDvalor1)))>
				and snd.SNCDvalor >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SNCDvalor1)#">
			</cfif>
			<cfif (isdefined("form.SNCDvalor2") and len(trim(form.SNCDvalor2)))>
				and snd.SNCDvalor <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SNCDvalor2)#">
			</cfif>
		</cfif>
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
	   and a.Dfecha  >= <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_fecha#">
	   and a.Dfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_fecha2#">
	   and a.Mcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
	group by a.Dfecha, b.CCTcolrpttranapl
	
</cfquery>

<!--- Recibos de Dinero que generaron NC: CCTcodigo tiene CCTtipo = 'C' y  CCTpago = 0.  CCTRcodigo tiene CCTtipo = 'C'  and CCTpago = 1  --->
<cfquery datasource="#session.dsn#">
	
	insert into #temp_movdiarios# (fecha, col, monto)
	select 
		<cf_dbfunction name="to_datechar" args="a.Dfecha">,
		b.CCTcolrpttranapl,
		sum(a.Dtotal * case b.CCTtipo when 'D' then 1 else -1 end)
	from  BMovimientos a
		inner join CCTransacciones b
			  on b.CCTcodigo = a.CCTRcodigo
			and b.Ecodigo = a.Ecodigo
			and b.CCTtipo   = 'C'
			and b.CCTpago = 1
		inner join CCTransacciones t2
			on   t2.CCTcodigo = a.CCTcodigo
			and t2.Ecodigo      = a.Ecodigo
			and t2.CCTtipo      = 'C'
			and t2.CCTpago   = 0
		inner join CCTrpttranapl c
			 on c.CCTcolrpttranapl = b.CCTcolrpttranapl
			and c.Ecodigo = b.Ecodigo
		<cfif (isdefined("form.SNCEid") and len(trim(form.SNCEid)))>
			inner join SNegocios sn
			on sn.SNcodigo = a.SNcodigo
			and sn.Ecodigo = a.Ecodigo
			inner join SNClasificacionSN snc
			on snc.SNid = sn.SNid
			inner join SNClasificacionD snd
			on snd.SNCDid = snc.SNCDid
			and snd.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCEid#">
			<cfif (isdefined("form.SNCDvalor1") and len(trim(form.SNCDvalor1)))>
				and snd.SNCDvalor >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SNCDvalor1)#">
			</cfif>
			<cfif (isdefined("form.SNCDvalor2") and len(trim(form.SNCDvalor2)))>
				and snd.SNCDvalor <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SNCDvalor2)#">
			</cfif>
		</cfif>
	where a.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
	   and a.Dfecha  >= <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_fecha#">
	   and a.Dfecha  < <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_fecha2#">
	   and a.Mcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
	group by a.Dfecha, b.CCTcolrpttranapl
	
</cfquery>

<!--- ************** SECCION NO ANSI ******************* --->

<!--- Actualiza en temp_informe el monto de las columnas --->
<cfquery datasource="#session.dsn#">	
	update #temp_informe#
	set monto = coalesce((
		select sum(m.monto)
		from #temp_movdiarios# m
		where m.fecha 	= #temp_informe#.fecha
		  and m.col 	= #temp_informe#.col
		), 0.00)
	where col > 0
	  and col <= #Lvar_Col#
</cfquery>

<cfquery datasource="#session.dsn#">	
	update #temp_informe#
	set monto = coalesce((
		select sum(monto)
		from #temp_movdiarios# m
		where m.fecha = #temp_informe#.fecha
			and m.col > 0
			and m.col < #Lvar_Col# + 1
		), 0.00)
	where col = #Lvar_Col# + 1
</cfquery>

<!--- Actualizar el saldo final del dia y el saldo del siguiente dia  --->
<cfloop condition="Lvar_fecha LT Lvar_fecha2">
	
	<cfquery datasource="#session.dsn#">
		update #temp_informe#
		set monto = coalesce((
			select sum(monto)
			from #temp_informe# i
			where i.fecha = #temp_informe#.fecha
				and i.col <= #Lvar_Col#
			), 0.00)
		where fecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_Fecha#">
		  and col = #Lvar_Col# + 2
	</cfquery>
	
	<cfquery datasource="#session.dsn#">
		update #temp_informe#
		set monto = coalesce((
			select monto
			from #temp_informe# i
			where i.fecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_Fecha#">
				and i.col = #Lvar_Col# + 2
			), 0.00)
		where fecha = <cf_dbfunction name="dateadd" args="1, #Lvar_Fecha#">
			and col = 0
	</cfquery>	
	
	<cfset Lvar_fecha = DateAdd('d',1,Lvar_fecha)>
	
</cfloop>
<!--- *********** FIN DE SECCION NO ANSI *************** --->

<cfquery name="rsConsulta" datasource="#session.dsn#">	
	select * 
	from #temp_informe#
	order by fecha, col
</cfquery>


