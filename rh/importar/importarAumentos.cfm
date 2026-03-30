<!---
	Importador de Aumentos
	Este archivo asume la existencia de la tabla temporal #table_name# "Datos de Entrada"
	Este archivo procesa los datos de entrada y genera el registro (s) de relación de aumentos correspondiente a los mismos.
 --->
 
<!--- DEFINICIONES INICIALES --->

<cfscript>
	bcheck1 = false;
	bcheck2 = false;
	bcheck3 = false;
	bcheck4 = false;
	bcheck5 = false;
	bcheck6 = false;
	bcheck7 = false;
	bok = false;
	nlote = 0;
	nlave = 0;
	dfecha = Now();
</cfscript>

<!---  tipo de aumento --->
<cfset ntipo = session.importarAumento.tipo >

<!--- VALIDACIONES --->
<!--- Check1. Validar Existencia del Empleado --->
<cfquery name="rsCheck1" datasource="#session.dsn#">
	select count(1) as check1
	from #table_name# a
	where not exists(
		select 1
		from DatosEmpleado b, LineaTiempo c
		where b.DEidentificacion = a.DEidentificacion
		and b.NTIcodigo = a.NTIcodigo
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and b.DEid = c.DEid
		and a.RHAfdesde between c.LTdesde and c.LThasta
	)
</cfquery>

<cfset bcheck1 = rsCheck1.check1 LT 1>
<cfif bcheck1>
	<!--- Check2. Validarque no existan Empleados repetidos en el archivo --->
	<cfquery name="rsCheck2" datasource="#session.dsn#">
		select count(1) as check2
		from #table_name#
		group by NTIcodigo, DEidentificacion
		having count(1) > 1
	</cfquery>
	<cfset bcheck2 = rsCheck2.check2 LT 1>
	<cfif bcheck2>
		<!--- Check3. Validar que no existan montos negativos en los datos a importar --->
		<cfquery name="rsCheck3" datasource="#session.dsn#">
			select count(1) as check3
			from #table_name#
			where RHDvalor < 0.00
		</cfquery>
		<cfset bcheck3 = rsCheck3.check3 LT 1>
		<cfif bcheck3>
			<!--- Check4. Si el tipo de aumento es porcentaje, debe ser un rango entre 1 y 100 --->
			<cfif ntipo eq 'P'>
				<cfquery name="rsCheck4" datasource="#session.dsn#">
					select count(1) as check4
					from #table_name#
					where RHDvalor <= 0 or RHDvalor > 100 
				</cfquery>
				<cfset bcheck4 = rsCheck4.check4 eq 0 >
			<cfelse>
				<cfset bcheck4 = true >
			</cfif>
			<cfif bcheck4>
				<!--- Check5. Validar que la fecha de Aumento en el Lote no haya sido registrado anteriormente para un empleado --->
				<cfquery name="rsCheck5" datasource="#session.dsn#">
					select count(1) as check5
					from #table_name# a
					where exists(
						select 1
						from RHEAumentos b, RHDAumentos e
						where b.RHAfdesde = a.RHAfdesde
						   and e.RHAid = b.RHAid
						   and e.NTIcodigo = a.NTIcodigo
						   and e.DEidentificacion = a.DEidentificacion
					)
				</cfquery>
				<cfset bcheck5 = rsCheck5.check5 LT 1>
				<cfif bcheck5>
					<!--- Check6. Valida que los tipos de Identificación sean válidos --->
					<cfquery name="rsCheck6" datasource="#session.dsn#">
						select count(1) as check6
						from #table_name# a
						where not exists(
							select 1
							from NTipoIdentificacion b
							where b.NTIcodigo = a.NTIcodigo
						)
					</cfquery>
					<cfset bcheck6 = rsCheck6.check6 LT 1>

					<cfif bcheck6>
						<!--- Check7. Valida que los tipos de aumento sean P o M--->
						<!---
						<cfquery name="rsCheck7" datasource="#session.dsn#">
							select count(1) as check7
							from #table_name# a
							where tipo not in ('P','M')
						</cfquery>
						<cfset bcheck7 = rsCheck7.check7 LT 1>--->
						<cfset bcheck7 = true>
						<cfif bcheck7>
							<cfset bok = true>
						</cfif><!--- Check7 --->
					</cfif><!--- Check6 --->
				</cfif><!--- Check5 --->
			</cfif><!--- Check4 --->
		</cfif><!--- Check3 --->
	</cfif><!--- Check2 --->
</cfif><!--- Check1 --->

<!--- ERRORES --->
<cfif not bcheck1>
	<cfquery name="ERR" datasource="#session.dsn#">
		select distinct 'Empleado no Existe o no esta Nombrado' as Error, NTIcodigo as TipoIdentificacion, DEidentificacion as Empleado
		from #table_name# a
		where not exists(
			select 1
			from DatosEmpleado b, LineaTiempo c
			where b.DEidentificacion = a.DEidentificacion
			and b.NTIcodigo = a.NTIcodigo
			and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and b.DEid = c.DEid
			and a.RHAfdesde between c.LTdesde and c.LThasta
		)
	</cfquery>
<cfelseif not bcheck2>
	<cfquery name="ERR" datasource="#session.dsn#">
		select { fn concat('Empleado con mas de un Aumento Salarial. Identificación: ', { fn concat(DEidentificacion,'.')})} as MSG,
				'FATAL' as LVL
		from #table_name#
		group by NTIcodigo, DEidentificacion
		having count(1) > 1	
	</cfquery>
<cfelseif not bcheck3>
	<cfquery name="ERR" datasource="#session.dsn#">
		select { fn concat('Aumento NO puede ser negativo. Identificación: ', { fn concat(DEidentificacion, { fn concat('. Valor: ',<cf_dbfunction name='to_char' args='RHDvalor'> )})})} as MSG,
				'FATAL' as LVL
		from #table_name#
		where RHDvalor < 0.00	
	</cfquery>
<cfelseif ntipo eq 'P' and not bcheck4>
	<cf_dbfunction name='to_char' args='RHDvalor' returnvariable="error_valor">
	<cf_dbfunction name='concat' args="'Porcentajes de aumento no puede ser mayor a 100. Identificación: ',DEidentificacion,'. Valor: ', #error_valor#" returnvariable="error_check4">
	<cfquery name="ERR" datasource="#session.dsn#" >
		select #preservesinglequotes(error_check4)# as MSG,
				'FATAL' as LVL
		from #table_name#
		where RHDvalor > 100
	</cfquery>

<cfelseif not bcheck5>
	<cfquery name="ERR" datasource="#session.dsn#">
		select distinct { fn concat('Fecha de Aumento en el Lote ya fue registrado para este empleado. Fecha: ', { fn concat(<cf_dbfunction name='to_char' args='a.RHAfdesde'>, { fn concat('. Identificación: ',a.DEidentificacion)})})} as MSG, 
				'FATAL' as LVL
		from #table_name# a
		where exists(
			select 1
			from RHEAumentos b, RHDAumentos e
			where b.RHAfdesde = a.RHAfdesde
			   and e.RHAid = b.RHAid
			   and e.NTIcodigo = a.NTIcodigo
			   and e.DEidentificacion = a.DEidentificacion
		)
	</cfquery>
<cfelseif not bcheck6>
	<cfquery name="ERR" datasource="#session.dsn#">
		select 	distinct { fn concat('Tipo de Identificación Inválido. Tipo de Identifación: ',NTIcodigo)} as MSG, 
				'FATAL' as LVL
		from #table_name# a
		where not exists(
			select 1
			from NTipoIdentificacion b
			where b.NTIcodigo = a.NTIcodigo
		)
	</cfquery>
<cfelseif not bcheck7>
	<cfquery name="ERR" datasource="#session.dsn#">
		select 	distinct { fn concat('Tipo de Aumento Inválido. Tipo: ',tipo)} as MSG, 
				'FATAL' as LVL
		from #table_name# a
		where tipo not in ('P','M')
	</cfquery>
</cfif>

<!--- IMPORTACION --->
<cfif bok>
	<cfquery name="rsLote" datasource="#session.dsn#">
		select coalesce(max(RHAlote)+1, 1) as lote
		from RHEAumentos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfset nlote = rsLote.lote>
	<cfquery name="rsFecha" datasource="#session.dsn#" maxrows="1">
		select RHAfdesde as fecha
		from #table_name#
	</cfquery>
	<cfset dFecha = rsFecha.fecha>
	
	<!--- query para procesar los datos a insertar --->
	<!--- esto porque se requiere cortes por fecha --->
	<cfquery name="rsdatosaumento" datasource="#session.DSN#">
		select NTIcodigo as tipoid, DEidentificacion as id, RHDvalor as valor, RHAfdesde as desde
		from #table_name#
		order by RHAfdesde
	</cfquery>
	
	<cftransaction>
	<cfoutput query="rsdatosaumento" group="desde">
		<cfquery name="rs_aumento" datasource="#session.dsn#">
			insert into RHEAumentos (Ecodigo, RHAlote, Usucodigo, RHAfecha, RHAfdesde, RHAestado, RHAusucodigo, RHAfautoriza, RHAtipo)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#nlote#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#desde#">, 
				0, null, null,
				<cfqueryparam cfsqltype="cf_sql_char" value="#ntipo#"> )
			<cf_dbidentity1>
		</cfquery>
		<cf_dbidentity2 name="rs_aumento">
			
		<cfquery datasource="#session.dsn#">
			insert into RHDAumentos (RHAid, NTIcodigo, DEidentificacion, RHDtipo, RHDvalor, RHDporcentaje)
			select <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_aumento.identity#">, 
					NTIcodigo, 
					DEidentificacion, 
					0, 
					<cfif ntipo eq 'M'>RHDvalor<cfelse>0</cfif>,
					<cfif ntipo eq 'P'>RHDvalor<cfelse>0</cfif>
			from #table_name#
			where RHAfdesde = <cfqueryparam cfsqltype="cf_sql_date" value="#rsdatosaumento.desde#">
		</cfquery>

		<!--- REALIZA EL SIGUIENTE PROCESO para todos los empleados de la relacion: 
				1. 	Si el tipo de aumento es por monto, calcula el porcentaje asociado al aumento.
					Debe modificar el campo porcentaje de la tabla
				2.	Si el tipo de aumento es por porcentaje, calcula el monto asociado al porcentaje.
		--->
	
		<!--- actualiza los DEid de los empleados --->
		<cfquery datasource="#session.DSN#">
			update RHDAumentos
			set DEid = (select DEid
						 from DatosEmpleado
						 where NTIcodigo = RHDAumentos.NTIcodigo
						   and DEidentificacion = RHDAumentos.DEidentificacion 
						   and Ecodigo = #session.Ecodigo#
						   and RHDAumentos.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_aumento.identity#"> )
		</cfquery>
	
		<!--- aumento por porcentaje --->
		<cfif Ntipo eq 'P'>
			<cfquery datasource="#session.DSN#">
				update RHDAumentos
				set RHDvalor = (	select	coalesce(((d.LTsalario * RHDAumentos.RHDporcentaje)/100), 0)
									from RHEAumentos c, LineaTiempo d
									where c.RHAid = RHDAumentos.RHAid
									  and c.Ecodigo = #Session.Ecodigo#
									  and d.DEid=RHDAumentos.DEid
									  and c.RHAfdesde between d.LTdesde and d.LThasta
								)
				where RHAid = #rs_aumento.identity#
			</cfquery>
		
		<!--- aumento por monto --->
		<cfelse>
			<cfquery datasource="#session.DSN#">
				update RHDAumentos
				set RHDporcentaje = ( select coalesce((case when d.LTsalario > 0 then ((RHDAumentos.RHDvalor*100)/d.LTsalario) else 0 end), 0)
									  from RHEAumentos c, LineaTiempo d
									  where c.RHAid = RHDAumentos.RHAid
										and c.Ecodigo = #Session.Ecodigo#
										and d.DEid=RHDAumentos.DEid
										and c.RHAfdesde between d.LTdesde and d.LThasta )
				where RHAid = #rs_aumento.identity#
			</cfquery>
		</cfif>

		<cfset nlote = nlote + 1 >
	</cfoutput>
	</cftransaction>
</cfif>