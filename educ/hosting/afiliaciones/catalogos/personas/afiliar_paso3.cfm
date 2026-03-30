<cfparam name="form.id_persona" type="numeric">
<cfparam name="form.id_programa" type="numeric">
<cfparam name="form.id_vigencia" type="numeric">

<cftransaction>
<!--- 1: verificar que no esté ya afiliado --->
<cfquery datasource="#session.dsn#" name="sa_afiliaciones">
	select id_persona
	from sa_afiliaciones
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">
	  and id_programa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_programa#">
	  and id_vigencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_vigencia#">
</cfquery>

<!--- 2: afiliar segun vigencia --->
<cfquery datasource="#session.dsn#" name="progs">
	select 
		p.id_programa, p.nombre_programa,
		v.id_vigencia, v.nombre_vigencia, v.costo, v.moneda, v.periodicidad, v.tipo_periodo,
		v.fecha_desde, v.fecha_hasta, v.cantidad_carnes, v.generar_carnes
	from sa_programas p
		join sa_vigencia v
			on p.id_programa = v.id_programa
	where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and p.id_programa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_programa#">
	  and v.id_programa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_programa#">
	  and v.id_vigencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_vigencia#">
</cfquery>
<cfif sa_afiliaciones.RecordCount is 0>
	<cfquery datasource="#session.dsn#">
		insert into sa_afiliaciones (
			id_persona, id_programa, id_vigencia,
			costo, moneda,
			fecha_desde, fecha_hasta,
			CEcodigo, Ecodigo, BMfechamod, BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_programa#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_vigencia#">,

			<cfqueryparam cfsqltype="cf_sql_numeric" value="#progs.costo#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#progs.moneda#">,
			
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#progs.fecha_desde#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#progs.fecha_hasta#">,
			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
</cfif>

<!--- 3: generar entradas y codigo de barras --->

<cfif progs.generar_carnes and progs.cantidad_carnes>
	<cfset cantidad_de_entradas = 0>
	<cfif sa_afiliaciones.RecordCount>
		<cfquery datasource="#session.dsn#" name="sa_entradas">
			select codigo_barras
			from sa_entrada
			where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">
			  and id_programa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_programa#">
			  and id_vigencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_vigencia#">
		</cfquery>
		<cfset cantidad_de_entradas = sa_entradas.RecordCount>
		<!--- actualizar los numeros de carnet --->
		<cfloop query="sa_entradas">
			<cfquery datasource="#session.dsn#">
				update sa_entrada
				set fila = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form['fila'&sa_entradas.CurrentRow]#">,
					asiento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form['asiento'&sa_entradas.CurrentRow]#">
				where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">
				  and id_programa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_programa#">
				  and id_vigencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_vigencia#">
				  and codigo_barras = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sa_entradas.codigo_barras#">
			</cfquery>
		</cfloop>
	</cfif>
	<cfloop from="#cantidad_de_entradas+1#" to="#progs.cantidad_carnes#" index="i">
		<cfloop from="1" to="500" index="dummy_01">
			<cfset codigo_barras = NumberFormat(Rand()*10000000000,'0000000000')>
			<cfquery datasource="#session.dsn#" name="carnet_repetido">
				select codigo_barras
				from sa_entrada
				where codigo_barras = <cfqueryparam cfsqltype="cf_sql_varchar" value="#codigo_barras#">
			</cfquery>
			<cfif carnet_repetido.RecordCount is 0><cfbreak></cfif>
		</cfloop>
	
		<cfoutput>Carne numero #i# : #codigo_barras#<br></cfoutput>
		<cfquery datasource="#session.dsn#">
			insert into sa_entrada (
				id_programa, id_vigencia, id_persona,
				codigo_barras, fila, asiento,
				CEcodigo, Ecodigo, BMfechamod, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_programa#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_vigencia#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#codigo_barras#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form['fila'&i]#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form['asiento'&i]#">,
		
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
		</cfquery>
	</cfloop>
<cfelse>
	Sin carnets.
</cfif>

</cftransaction>

<cflocation url="afiliar_paso4.cfm?back_prog=#URLEncodedFormat(form.back_prog)#&id_persona=#URLEncodedFormat(form.id_persona)#&id_programa=#URLEncodedFormat(form.id_programa)#&id_vigencia=#URLEncodedFormat(form.id_vigencia)#">
