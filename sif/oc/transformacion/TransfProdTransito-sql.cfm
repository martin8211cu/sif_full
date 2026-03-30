
<cfset modo = 'ALTA'>
<cfif isDefined("form.ALTA")>
	<cfquery datasource="#session.DSN#" name="rsMesAux">
		select Pvalor 
		from Parametros 
		where Pcodigo=60 
		and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">			
	</cfquery>
	<cfset  Mes = #rsMesAux.Pvalor#>
	
	<cfquery datasource="#session.DSN#" name="rsPeriodosAux">
		select Pvalor 
		from Parametros
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo=50
	</cfquery> 	
	<cfset  Periodo = #rsPeriodosAux.Pvalor#>




	<cftransaction>
		<!--- *********** PASO 1 Agregar encabezado		***********--->
		<cfquery name="RSInsert" datasource="#session.DSN#">
			insert into OCtransporteTransformacion (
				OCTid, 
				OCTTdocumento,
				OCTTfecha,
				OCTTobservaciones,
				OCTTestado,
				Ecodigo,
				OCTTperiodo,
				OCTTmes,
				OCTTmanual,
				BMUsucodigo	
			)	
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCTTdocumento#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.OCTTfecha#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCTTobservaciones#">,
				0,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
				<cfif isdefined("form.OCTTmanual")>1<cfelse>0</cfif>,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			)
			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="RSInsert">
		<cfset form.OCTTid = RSInsert.identity >
 		<cfset modo = 'CAMBIO'>
	</cftransaction>
<cfelseif isDefined("form.BAJA")>
	<cftransaction>
		<!--- *********** PASO 1 borra detalle		***********--->
		<cfquery name="RSInsert" datasource="#session.DSN#">
			delete OCtransporteTransformacionD where 
			Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and OCTTid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTTid#">
		</cfquery>
		<!--- *********** PASO 2 borra encabezado		***********--->
		<cfquery name="RSInsert" datasource="#session.DSN#">
			delete OCtransporteTransformacion where 
			Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and OCTTid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTTid#">
		</cfquery>
	</cftransaction>
<cfelseif isDefined("form.CAMBIO")>
	<cftransaction>
		<!--- *********** PASO 1 Actualiza encabezado	***********--->
		<cfparam name="form.OCTTmanual" default="0">
		<cfif form.OCTTmanual NEQ "0">
			<cfset form.OCTTmanual = "1">
		</cfif>
		<cfquery datasource="#session.dsn#">
			update OCtransporteTransformacion
			set OCTTdocumento 		= <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#form.OCTTdocumento#">
				, OCTTfecha 		= <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#form.OCTTfecha#">
				, OCTTobservaciones = <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#form.OCTTobservaciones#">
				, OCTTmanual		= <cfqueryparam cfsqltype="cf_sql_bit" 			value="#form.OCTTmanual#">
			where Ecodigo	=  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and OCTTid		=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTTid#">
		</cfquery>
		<!--- *********** PASO 2 borra detalle		***********--->
		<cfquery name="RSInsert" datasource="#session.DSN#">
			delete OCtransporteTransformacionD where 
			Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and OCTTid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTTid#">
		</cfquery>

		<!--- *********** PASO 3 inserta detalles origenes ***********--->
		<cfset LvarCostoTotal = 0>
		<cfloop list="#form.Aid_Ori#" index="LvarAid">
			<cfset LvarCantidad = replace(evaluate("form.CantidadOri_#LvarAid#"),",","","ALL")>

			<cfif isnumeric(LvarCantidad) AND LvarCantidad NEQ 0>
				<cfset LvarCosto = replace(evaluate("form.CostoProd_#LvarAid#"),",","","ALL")>
				<cfset LvarCosto = LvarCosto + replace(evaluate("form.CostoNoProd_#LvarAid#"),",","","ALL")>
				<cfset LvarCostoTotal = LvarCostoTotal + LvarCosto>
				<cfquery datasource="#session.dsn#">
					insert into OCtransporteTransformacionD
						(
						   OCTTid,
						   OCTTDtipoOD,
						   OCTid,
						   Aid,
						   Ucodigo,
						   Ecodigo,
						   OCTTDcantidad,
						   OCTTDcostoUnitario,
						   OCTTDcostoTotal,
						   BMUsucodigo
						)
					select 
						  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTTid#">
						, 'O'
						, (select OCTid from OCtransporteTransformacion where OCTTid = <cfqueryparam cfsqltype="cf_sql_numeric"	value="#form.OCTTid#">)
						, Aid
						, Ucodigo
						, Ecodigo
						, <cfqueryparam cfsqltype="cf_sql_float"	value="#LvarCantidad#">
						, <cfqueryparam cfsqltype="cf_sql_money"	value="#LvarCosto/LvarCantidad#">
						, <cfqueryparam cfsqltype="cf_sql_money"	value="#LvarCosto#">
						, #session.Usucodigo#
					  from Articulos
					 where Ecodigo	= #session.Ecodigo#
					   and Aid		= #LvarAid#
				</cfquery> 
			</cfif>
		</cfloop>

		<!--- *********** PASO 4 inserta detalles Destino ***********--->
		<cfset LvarCantidadTotal = 0>
		<cfloop list="#form.Aid_Dst#" index="LvarAid">
			<cfset LvarCantidad = replace(evaluate("CantidadDst_#LvarAid#"),",","","ALL")>
			<cfparam name="form.Manual_#LvarAid#" default="0">
			<cfset LvarPrpManual = replace(evaluate("form.Manual_#LvarAid#"),",","","ALL")>

			<cfif isnumeric(LvarCantidad) AND LvarCantidad NEQ 0>
				<cfset LvarCantidadTotal = LvarCantidadTotal + LvarCantidad>
				<cfquery datasource="#session.dsn#">
					insert into OCtransporteTransformacionD
						(
						   OCTTid,
						   OCTTDtipoOD,
						   OCTid,
						   Aid,
						   Ucodigo,
						   Ecodigo,
						   OCTTDcantidad,
						   OCTTDcostoUnitario,
						   OCTTDcostoTotal,
						   OCTTDproporcionManualDst,
						   BMUsucodigo
						)
					select 
						  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTTid#">
						, 'D'
						, (select OCTid from OCtransporteTransformacion where OCTTid = <cfqueryparam cfsqltype="cf_sql_numeric"	value="#form.OCTTid#">)
						, Aid
						, Ucodigo
						, Ecodigo
						, <cfqueryparam cfsqltype="cf_sql_float"	value="#LvarCantidad#">
						, 0
						, 0
						, <cfqueryparam cfsqltype="cf_sql_float"	value="#LvarPrpManual#">
						, #session.Usucodigo#
					  from Articulos
					 where Ecodigo	= #session.Ecodigo#
					   and Aid		= #LvarAid#
				</cfquery> 
			</cfif>
		</cfloop>

		<!--- *********** PASO 3 actualiza costos Destino		***********--->
		<cfif LvarCantidadTotal EQ 0>
			<cfset LvarCostoUntitario = 0>
		<cfelse>
			<cfset LvarCostoUntitario = LvarCostoTotal / LvarCantidadTotal>
		</cfif>
		<cfif form.OCTTmanual EQ "0">
			<cfquery datasource="#session.dsn#">
				update OCtransporteTransformacionD
				   set  OCTTDcostoTotal		= round(<cfqueryparam cfsqltype="cf_sql_money"	value="#LvarCostoUntitario#"> * OCTTDcantidad,2)
					   ,OCTTDcostoUnitario	= <cfqueryparam cfsqltype="cf_sql_money"		value="#LvarCostoUntitario#">
				 where OCTTid = <cfqueryparam cfsqltype="cf_sql_numeric"	value="#form.OCTTid#">
				   and OCTTDtipoOD = 'D'
			</cfquery>
		<cfelse>
			<cfquery datasource="#session.dsn#">
				update OCtransporteTransformacionD
				   set   OCTTDcostoTotal	= round(<cfqueryparam cfsqltype="cf_sql_money"	value="#LvarCostoTotal#">*OCTTDproporcionManualDst/100,2)
				   		,OCTTDcostoUnitario	= <cfqueryparam cfsqltype="cf_sql_money"		value="#LvarCostoTotal#">*OCTTDproporcionManualDst/100 / OCTTDcantidad
				 where OCTTid = <cfqueryparam cfsqltype="cf_sql_numeric"	value="#form.OCTTid#">
				   and OCTTDtipoOD = 'D'
			</cfquery>
		</cfif>
	</cftransaction>
	<cfset modo = 'CAMBIO'>
<cfelseif isDefined("form.btnAplicar")>
	<cfinvoke component="sif.oc.Componentes.OC_transito" 
			method	= "OC_CreaTablas" 
			returnvariable="OC_DETALLE"
			
			Conexion= "#session.DSN#"
	/>

	<cfloop list="#form.chk#" index="LvarChk">
		<cfinvoke component="sif.oc.Componentes.OC_transito" 
				method	= "OC_Aplica_TRANSFORMACION" 
				returnvariable="rsSql"
				
				Ecodigo = "#Session.Ecodigo#"
				OCTTid	= "#LvarChk#"
				Conexion= "#session.DSN#"
			/>
	</cfloop>
<cfelseif isDefined("form.Aplicar") OR isDefined("form.VerAplicacion")>
	<cfinvoke component="sif.oc.Componentes.OC_transito" 
			method	= "OC_CreaTablas" 
			returnvariable="OC_DETALLE"
			
			Conexion= "#session.DSN#"
	/>
	<cfinvoke component="sif.oc.Componentes.OC_transito" 
			method	= "OC_Aplica_TRANSFORMACION" 
			returnvariable="rsSql"
			
			Ecodigo = "#Session.Ecodigo#"
			OCTTid	= "#form.OCTTid#"
			Conexion= "#session.DSN#"
			
			VerAsiento="#isDefined('form.VerAplicacion')#"
		/>
</cfif>

<form action="TransfProdTransito.cfm" method="post" name="sql">
	<cfoutput>
		<input type="hidden" name="modo" value="<cfif isdefined("modo") and len(trim(modo))>#modo#</cfif>">
		<cfif modo eq "CAMBIO">
			<input type="hidden" name="OCTTid" value="<cfif isdefined("form.OCTTid") and len(trim(form.OCTTid))>#form.OCTTid#</cfif>">
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

