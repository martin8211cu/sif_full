<!--- 
	Modificado por: Ana Villaviencio
	Fecha: 13 de febrero del 2006
	Motivo: corregir error cuando el empleado no tiene registro dentro de la tabla de EVacacionesEmpleado, se hace la consulta
			para la insercion del registro de vacaciones y el registro en Bregimen.
			Se corrigió para q mantuviera los filtros.
 --->
<cfif isdefined('form.Cambio')>
	<cftransaction>
		<cfset LvarTemp = LSDateFormat(form.EVfanual, 'dd/mm/yyyy')>
		<cfset vEVfanual = CreateDate(ListGetAt(LvarTemp, 3, '/'), ListGetAt(LvarTemp, 2, '/'), ListGetAt(LvarTemp, 1, '/'))>
		<cfset LvarTemp = LSDateFormat(form.EVfvacas, 'dd/mm/yyyy')>
		<cfset vEVfvacas = CreateDate(ListGetAt(LvarTemp, 3, '/'), ListGetAt(LvarTemp, 2, '/'), ListGetAt(LvarTemp, 1, '/'))>
		<cfquery name="rsUpdateEVacEmpl" datasource="#session.DSN#">
			update EVacacionesEmpleado
			   set EVfanual = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vEVfanual#">,
				   EVdiaanual = <cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('d', vEVfanual)#">,
				   EVmesanual = <cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('m', vEVfanual)#">,
				   EVfvacas = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vEVfvacas#">
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		</cfquery>
		
		<cfquery name="rsBregimenInsert" datasource="#session.DSN#">
			insert into BRegimen ( 	DEid, 
								   	EVfantig, 
								   	EVdia, 
								   	EVmes, 
									EVfvacas, 
							  		EVfanual,
									EVdiaanual, 
									EVmesanual,  
							  		EVfanualant, 
									EVdiaanualant, 
									EVmesanualant,
							  		EVfantigant, 
									EVdiaant,
									EVmesant, 
									EVfvacasant,
									BMUsucodigo )
				select 	DEid, 
						EVfantig, 
						EVdia, 
						EVmes, 
						<cfqueryparam cfsqltype="cf_sql_date" value="#vEVfvacas#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#vEVfanual#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('d', vEVfanual)#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('m', vEVfanual)#">, 
						<cfif isdefined('form.EVfanualant') and LEN(TRIM(form.EVfanualant))>
							<cfqueryparam cfsqltype="cf_sql_date" value="#form.EVfanualant#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EVdiaanualant#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EVmesanualant#">, 
						<cfelse>
							null,
							null,
							null,
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_date" value="#EVfantigant#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EVdiaant#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EVmesant#">, 
						<cfqueryparam cfsqltype="cf_sql_date" value="#form.EVfvacasant#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">

				from EVacacionesEmpleado

				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		</cfquery>
	</cftransaction>
<cfelseif isdefined('form.Aceptar') and isdefined('form.InsertEV')>

	<cfquery name="rsFechaUltA" datasource="#session.DSN#">
		select max(DLfvigencia) as vigencia
		from DLaboralesEmpleado
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	</cfquery>

	<cfif isdefined('rsFechaUltA') and rsFechaUltA.RecordCount>
		<cfset Fdesde = rsFechaUltA.vigencia>
	<cfelse>
		<cfset Fdesde = Now()>
	</cfif>
	<cfquery name="insVacaciones" datasource="#session.DSN#">
		insert into EVacacionesEmpleado( DEid, 
										 EVfantig, 
										 EVfecha, 
										 EVmes, 
										 EVdia, 
										 EVinicializar )
		values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('m', Fdesde)#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('d', Fdesde)#">, 
				0 )
	</cfquery>

	<cfquery name="rsDatos" datasource="#session.DSN#">
		select EVfvacas,
			   EVfanual, 
			   EVdiaanual, 
			   EVmesanual, 
			   EVfantig, 
			   EVmes,  
			   EVdia

		from EVacacionesEmpleado 

		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	</cfquery>

	<cfif isdefined('rsDatos') and rsDatos.RecordCount>
		<cfset form.EVfanualant = rsDatos.EVfanual>
		<cfset form.EVfvacasant = rsDatos.EVfvacas>
		<cfset form.EVfanualant = LSDateFormat(rsDatos.EVfanual,'dd/mm/yyyy')>
		<cfset form.EVdiaanualant = rsDatos.EVdiaanual>
		<cfset form.EVmesanualant = rsDatos.EVmesanual>
		<cfset form.EVfantigant = rsDatos.EVfantig>
		<cfset form.EVdiaant = rsDatos.EVdia>
		<cfset form.EVmesant = rsDatos.EVmes>
		<cfset form.EVfvacasant = LSDateFormat(rsDatos.EVfvacas,'dd/mm/yyyy')>
	</cfif>
	<cfset LvarTemp = LSDateFormat(form.EVfanual, 'dd/mm/yyyy')>
	<cfset vEVfanual = CreateDate(ListGetAt(LvarTemp, 3, '/'), ListGetAt(LvarTemp, 2, '/'), ListGetAt(LvarTemp, 1, '/'))>
	<cfset LvarTemp = LSDateFormat(form.EVfvacas, 'dd/mm/yyyy')>
	<cfset vEVfvacas = CreateDate(ListGetAt(LvarTemp, 3, '/'), ListGetAt(LvarTemp, 2, '/'), ListGetAt(LvarTemp, 1, '/'))>
	<cfquery name="rsBregimenInsert" datasource="#session.DSN#">
		insert into BRegimen ( 	DEid, 
								EVfantig, 
								EVdia, 
								EVmes, 
								EVfvacas, 
								EVfanual,
								EVdiaanual, 
								EVmesanual,  
								EVfanualant, 
								EVdiaanualant, 
								EVmesanualant,
								EVfantigant, 
								EVdiaant,
								EVmesant, 
								EVfvacasant,
								BMUsucodigo )
			select 	DEid, 
				   	EVfantig, 
					EVdia, 
					EVmes, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#vEVfvacas#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#vEVfanual#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('d', vEVfanual)#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('m', vEVfanual)#">, 
					<cfif isdefined('form.EVfanualant') and LEN(TRIM(form.EVfanualant))>
						<cfqueryparam cfsqltype="cf_sql_date" value="#form.EVfanualant#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EVdiaanualant#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EVmesanualant#">, 
					<cfelse>
						null,
						null,
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_date" value="#EVfantigant#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EVdiaant#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EVmesant#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#form.EVfvacasant#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">

			from EVacacionesEmpleado

			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	</cfquery>
</cfif>

<form action="CambioFAnualidad.cfm" method="post" name="sql">
	<cfoutput>
		<cfif isdefined('form.Aceptar')>
		<input name="DEid" type="hidden" value="#form.DEid#">
		<input name="Aceptar" type="hidden" value="#form.Aceptar#">
			<input name="EVfanual" type="hidden" value="#form.EVfanual#">
			<input name="EVfvacas" type="hidden" value="#form.EVfvacas#">
			<input name="EVfanualant" type="hidden" value="#form.EVfanualant#">
			<input name="EVdiaanualant" type="hidden" value="#form.EVdiaanualant#">
			<input name="EVmesanualant" type="hidden" value="#form.EVmesanualant#">
			<input name="EVfantigant" type="hidden" value="#form.EVfantigant#">
			<input name="EVdiaant" type="hidden" value="#form.EVdiaant#">
			<input name="EVmesant" type="hidden" value="#form.EVmesant#">
			<input name="EVfvacasant" type="hidden" value="#form.EVfvacasant#">
		</cfif>
		<input name="Filtro_DEidentificacion" type="hidden" value="#form.Filtro_DEidentificacion#">
		<input name="Filtro_Empleado" type="hidden" value="#form.Filtro_Empleado#">
		<input name="HFiltro_DEidentificacion" type="hidden" value="#form.Filtro_DEidentificacion#">
		<input name="HFiltro_Empleado" type="hidden" value="#form.Filtro_Empleado#">
		<input name="Pagina" type="hidden" value="#form.Pagina#">
	</cfoutput>
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>