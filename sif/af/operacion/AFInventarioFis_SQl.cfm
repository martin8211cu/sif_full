<!--- <cf_dump var="#form#"> --->
<cfset modo = 'ALTA'>
	<cfif isDefined("form.Agregar")>
			<cftransaction>
				<!--- *********** PASO 1 Agregar encabezado		***********--->
				 <cfquery name="RSInsert" datasource="#session.DSN#">
					insert into AFEListaConteoActivos (
						LCAdescripcion, 
						Ocodigo, 
						CFid, 
						LCAfecha,
						LCAfechacie, 
						LCAusureg, 
						LCAusucie, 
						LCAusuapl,
						Ecodigo,
						BMUsucodigo)
						values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.LCAdescripcion#">,
						<cfif isdefined("form.Oficodigo") and len(trim(form.Oficodigo))> 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Oficodigo#">,
						<cfelse>
							null,
						</cfif>
						<cfif isdefined("form.CFid") and len(trim(form.CFid))> 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">,
						<cfelse>
							null,
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.LCAfecha#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.LCAfechacie#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">,
						null,
						null,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
						<cf_dbidentity1 datasource="#session.DSN#">
				 </cfquery>
				 <cf_dbidentity2 datasource="#session.DSN#" name="RSInsert">
				 <cfset form.LCAid = RSInsert.identity >
				 
				<!--- *********** PASO 2  Agregar Detalle	 	***********--->
				 <cfquery name="RSInsert2" datasource="#session.DSN#">
					insert into AFDListaConteoActivos (
						LCAid,
						Aid,
						LCAcantidad,
						LCAfecha,
						Ecodigo,
						BMUsucodigo)
					select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LCAid#">, 
						a.Aid, 
						0, 
						null,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					from Activos a
					inner join AFSaldos b
						on b.Aid = a.Aid
						and b.Ecodigo = a.Ecodigo
					inner join CFuncional c
						on b.CFid = c.CFid
						and b.Ecodigo = c.Ecodigo
					where b.AFSperiodo = 2002
						and b.AFSmes = 1
						<cfif isdefined("form.Oficodigo") and len(trim(form.Oficodigo))>
							and c.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Oficodigo#">
						</cfif>
						<cfif isdefined("form.CFid") and len(trim(form.CFid))>
							and c.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">		
						</cfif>	
						and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				 </cfquery>
				 <cfset modo = 'CAMBIO'>
			</cftransaction>
	<cfelseif isdefined("Form.lista")>		
		<cflocation url="listaInventarios.cfm">
	<cfelseif isDefined("form.Nuevo")>
		<cfset modo = 'ALTA'>
	<cfelseif isdefined("Form.Importar")>		
		<cfquery name="rsimportar" datasource="#session.DSN#">
			declare @i int
			select @i = rand()
			update AFDListaConteoActivos 
			set LCAcantidad =  convert(int, (rand(@i) * 10)) , @i = @i + 1
			where LCAid = #form.LCAid#
		</cfquery>
		<cfset modo = 'CAMBIO'>
	</cfif>
<form action="AFInventarioFis.cfm" method="post" name="sql">
	<cfoutput>
		<input type="hidden" name="modo" value="<cfif isdefined("modo") and len(trim(modo))>#modo#</cfif>">
		<cfif modo eq "CAMBIO">
			<input type="hidden" name="LCAid" value="<cfif isdefined("form.LCAid") and len(trim(form.LCAid))>#form.LCAid#</cfif>">
		</cfif>
	</cfoutput>
</form>
<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>