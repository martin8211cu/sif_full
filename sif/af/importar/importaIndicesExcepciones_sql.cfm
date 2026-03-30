
<!--- Tabla Temporal de Errores --->
<cf_dbtemp name="AF_INICIO_ERROR" returnvariable="AF_INICIO_ERROR" datasource="#session.dsn#">
	<cf_dbtempcol name="Mensaje" type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="DatoIncorrecto" type="varchar(40)" mandatory="no">
	<cf_dbtempcol name="ErrorNum" type="integer" mandatory="yes">
</cf_dbtemp>

<!---validar Categoria--->
<cfquery datasource="#session.dsn#" name="rsCategoria">
    insert into #AF_INICIO_ERROR# (Mensaje, DatoIncorrecto, ErrorNum)
	select '201. Categoria No Existente' as Mensaje, 
	<cf_dbfunction name="to_char" args="a.CodigoCategoria"> as DatoIncorrecto,
	201 as ErrorNum
  	from #table_name# a
		where not exists
		(
		select 1 
			from  ACategoria b
			 where b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			 and a.CodigoCategoria = b.ACcodigodesc
		)
</cfquery>

<!---Validar Clasificacion--->
<cfquery datasource="#session.dsn#">
    insert into #AF_INICIO_ERROR# (Mensaje, DatoIncorrecto, ErrorNum)
	select '202. Clasificación No Existente' as Mensaje, 
	<cf_dbfunction name="to_char" args="a.CodigoClasificación"> as DatoIncorrecto,
	202 as ErrorNum
  	from #table_name# a
		where not exists
		(
		select 1 
			from  AClasificacion b
			 where b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			 and a.CodigoClasificación = b.ACcodigodesc
		)
</cfquery>

<!--- Valida relacion - Categoria Clase--->
<cfquery datasource="#session.dsn#">
    insert into #AF_INICIO_ERROR# (Mensaje, DatoIncorrecto, ErrorNum)
	select '203. La categoría y la clase no Coinciden' as Mensaje, 
	{fn concat(<cf_dbfunction name="to_char" args="a.CodigoCategoria">, {fn concat('-', <cf_dbfunction name="to_char" args="a.CodigoClasificación">)} )}as DatoIncorrecto,
	203 as ErrorNum
  	from #table_name# a
		where not exists
		(
		select 1 
			from  AClasificacion b, ACategoria c
			 where b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			 and a.CodigoCategoria = c.ACcodigodesc
			 and a.CodigoClasificación = b.ACcodigodesc
		)
</cfquery>

<!---Validar Mes---->
<cfquery datasource="#session.dsn#">
    insert into #AF_INICIO_ERROR# (Mensaje, DatoIncorrecto, ErrorNum)
	select '205. Mes invalido' as Mensaje, 
	<cf_dbfunction name="to_char" args="a.AFImes"> as DatoIncorrecto,
	205 as ErrorNum
  	from #table_name# a
		where AFImes not between 1 and 12
</cfquery>
<!---Validar Oficina--->
<cfquery datasource="#session.dsn#">
 insert into #AF_INICIO_ERROR# (Mensaje, DatoIncorrecto, ErrorNum)
	select '206. Oficina No Existe' as Mensaje, 
	<cf_dbfunction name="to_char" args="a.Oficodigo"> as DatoIncorrecto,
	206 as ErrorNum
  	from #table_name# a
		where not exists
		(
		select 1 
			from  Oficinas b
			 where b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			 and a.Oficodigo = b.Oficodigo
		)
</cfquery>
<!---Validar Relacion repetida en Archivo---->
<cfquery datasource="#session.dsn#">
 insert into #AF_INICIO_ERROR# (Mensaje, DatoIncorrecto, ErrorNum)
	select '207. La relacion esta repetida (Categoria- Clase-Periodo-Mes-Oficina)' as Mensaje, 
	{fn concat(<cf_dbfunction name="to_char" args="a.CodigoCategoria"> ,{ fn concat ('-',
	{fn concat(<cf_dbfunction name="to_char" args="a.CodigoClasificación">,{ fn concat ('-',
	{fn concat(<cf_dbfunction name="to_char" args="a.AFIperiodo">,{ fn concat ('-',
	{fn concat(<cf_dbfunction name="to_char" args="a.AFImes">,{ fn concat ('-', <cf_dbfunction name="to_char" args="a.Oficodigo">)})})})})})})})}
	as DatoIncorrecto,
	207 as ErrorNum
  	from #table_name# a
		group by CodigoCategoria,CodigoClasificación,AFIperiodo,AFImes, Oficodigo 
		having count(1)> 1
		
</cfquery>
<!---Valida que no se halla asignando un indice para esa relacion--->
<cfquery datasource="#session.dsn#" name="rsValidaIndice">
 insert into #AF_INICIO_ERROR# (Mensaje, DatoIncorrecto, ErrorNum)
	select '208. Registro ya existente (Categoria- Clase-Periodo-Mes-Oficina)' as Mensaje, 
	{fn concat(<cf_dbfunction name="to_char" args="a.CodigoCategoria"> ,{ fn concat ('-',
	{fn concat(<cf_dbfunction name="to_char" args="a.CodigoClasificación">,{ fn concat ('-',
	{fn concat(<cf_dbfunction name="to_char" args="a.AFIperiodo">,{ fn concat ('-',
	{fn concat(<cf_dbfunction name="to_char" args="a.AFImes">,{ fn concat ('-', <cf_dbfunction name="to_char" args="a.Oficodigo">)})})})})})})})}
	as DatoIncorrecto,
	208 as ErrorNum
  	from #table_name# a
		inner join ACategoria cat
			on cat.Ecodigo=#session.Ecodigo#
			and a.CodigoCategoria = cat.ACcodigodesc
		inner join AClasificacion acl
			on a.CodigoClasificación=acl.ACcodigodesc
			and acl.Ecodigo=#session.Ecodigo#
			and cat.ACcodigo=acl.ACcodigo
			inner join AFIndicesExc b 
				on acl.ACid = b.ACid
					and a.AFIperiodo = b.AFIperiodo	
					and a.AFImes = b.AFImes
					and a.AFIindice = b.AFIindice
			
		inner join Oficinas c
			on a.Oficodigo = c.Oficodigo
			and b.Ocodigo = c.Ocodigo
			and c.Ecodigo=#session.Ecodigo#			   		   		   		
</cfquery>

<cfquery name="err" datasource="#session.dsn#">
	select DatoIncorrecto, Mensaje
	from #AF_INICIO_ERROR#
	order by DatoIncorrecto, ErrorNum
</cfquery>



<!---Inserta los retiros de Activos por Aplicar---->
<cfquery name="rstemporal" datasource="#session.dsn#">
	select * from #table_name#
</cfquery>

<cfif (err.recordcount) EQ 0>
	<cfquery name="rsIndiceTemporal" datasource="#session.dsn#">
		select a.AFIindice as ITemp, b.AFIindice as Indice	 
		from #table_name# a
			inner join AClasificacion acl
				on a.CodigoClasificación=acl.ACcodigodesc
				inner join AFIndicesExc b 
					on acl.ACid = b.ACid
						and a.AFIperiodo = b.AFIperiodo	
						and a.AFImes = b.AFImes
						and a.AFIindice != b.AFIindice
				and a.AFImes = b.AFImes
				
			inner join Oficinas c
				on a.Oficodigo = c.Oficodigo
				and b.Ocodigo = c.Ocodigo
				and c.Ecodigo=#session.Ecodigo#
	</cfquery>
	
	<cfif (rsIndiceTemporal.recordcount) EQ 0 >
	
<!---		<cf_dbfunction name="date_format"	args="#Now()#,YYYYMMDD" returnavariable="Fecha">
--->		<cfquery datasource="#Session.Dsn#" name="inserta">
			insert into AFIndicesExc (Ecodigo, ACcodigo, ACid, AFIperiodo, AFImes, AFIindice, AFIfecha, AFIusuario,BMUsucodigo,Ocodigo)
			select 
				#session.Ecodigo#, 
				acl.ACcodigo,  
				acl.ACid, 
				a.AFIperiodo,
				a.AFImes, 
				a.AFIindice,
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#" >,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Session.Usuario#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
				b.Ocodigo
			from #table_name# a
				inner join ACategoria cat
					on cat.Ecodigo=#session.Ecodigo#
					and a.CodigoCategoria = cat.ACcodigodesc
				inner join AClasificacion acl
					on acl.Ecodigo=#session.Ecodigo#
					and cat.ACcodigo=acl.ACcodigo
					and a.CodigoClasificación=acl.ACcodigodesc
				inner join Oficinas b
					on b.Ecodigo=#session.Ecodigo# 
					and a.Oficodigo = b.Oficodigo
	</cfquery>
	<cfelse>
		
		<cfquery name="actualiza" datasource="#session.dsn#">
			UPDATE AFIndicesExc
				set AFIindice=a.AFIindice,
					AFIfecha=<cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(Now(),'YYYY/MM/DD')#">,
					AFIusuario=<cfqueryparam value="#Session.Usuario#" cfsqltype="cf_sql_varchar">
				from #table_name# a
				inner join AClasificacion acl
					on a.CodigoClasificación=acl.ACcodigodesc
					and acl.Ecodigo=#session.Ecodigo#
				inner join Oficinas c
					on a.Oficodigo = c.Oficodigo
					and c.Ecodigo=#session.Ecodigo#
					
				where acl.ACid = AFIndicesExc.ACid
				and a.AFIperiodo = AFIndicesExc.AFIperiodo	
				and a.AFImes = AFIndicesExc.AFImes
				and a.AFIindice != AFIndicesExc.AFIindice
		</cfquery>
	
	</cfif>

	
</cfif>
