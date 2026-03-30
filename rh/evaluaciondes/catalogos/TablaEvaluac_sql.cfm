<cfset action = "tablaEvaluac.cfm">

<cfif not isdefined("form.btnNuevoD") and  not isdefined("form.btnNuevoE")>
	
		<!--- Caso 1: Agregar Encabezado --->
		<cfif isdefined("Form.btnAgregarE")>
			<cftransaction>
				<cfquery name="ABC_TablaEvaluac" datasource="#Session.DSN#">
					insert into TablaEvaluacion (Ecodigo, TEnombre, TEtipo, TEmas100)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TEnombre#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#form.TEtipo#">,
							<cfif isdefined("form.TEmas100")>1<cfelse>0</cfif>
					)
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="ABC_TablaEvaluac">	
			</cftransaction>
			<cfset modo="CAMBIO">
		
		<!--- Caso 1.1: Cambia Encabezado --->
		<cfelseif isdefined("Form.btnCambiarE")>
			<cf_dbtimestamp datasource="#session.dsn#"
			table="TablaEvaluacion"
			redirect="tablaEvaluac.cfm"
			timestamp="#form.timestampE#"
			field1="TEcodigo" 
			type1="numeric" 
			value1="#form.TEcodigo#">
			
			<cfquery name="ABC_TablaEvaluac" datasource="#Session.DSN#">
				update TablaEvaluacion
				set TEnombre = <cfqueryparam value="#form.TEnombre#" cfsqltype="cf_sql_varchar">,
					TEtipo=<cfqueryparam value="#form.TEtipo#" cfsqltype="cf_sql_char">,
					TEmas100=<cfif isdefined("form.TEmas100")>1<cfelse>0</cfif>
				where TEcodigo = <cfqueryparam value="#form.TEcodigo#" cfsqltype="cf_sql_numeric">
			</cfquery>	
			<cfset modo="CAMBIO">
							
		<!--- Caso 2: Borrar un Encabezado de Tablas de Evaluacion --->
		<cfelseif isdefined("Form.btnBorrarE")>			
			<cfif isdefined("Form.TEcodigo") AND Form.TEcodigo NEQ "">
				<cfquery name="ABC_TablaEvaluac" datasource="#Session.DSN#">
					delete from TablaEvaluacionValor
					where TEcodigo=<cfqueryparam value="#form.TEcodigo#" cfsqltype="cf_sql_numeric">
				</cfquery>
				<cfquery name="ABC_TablaEvaluac" datasource="#Session.DSN#">	
					delete from TablaEvaluacion 
					where TEcodigo=<cfqueryparam value="#form.TEcodigo#" cfsqltype="cf_sql_numeric">				
				</cfquery>
				<cfset modo="ALTA">									
			</cfif>
			<cfset modo="ALTA">
		<!--- Caso 3: Agregar Detalle de Tablas de Evaluacion y opcionalmente modificar el encabezado --->
		<cfelseif isdefined("Form.btnAgregarD")>
			<cfquery name="ABC_TablaEvaluac" datasource="#Session.DSN#">
				insert into TablaEvaluacionValor (TEcodigo, TEVvalor, TEVdescripcion, TEVnombre, TEVequivalente )
				values (<cfqueryparam value="#form.TEcodigo#" cfsqltype="cf_sql_numeric">,
						<cfqueryparam value="#form.TEVvalor#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#form.TEVdescripcion#" cfsqltype="cf_sql_varchar">, 
						<cfqueryparam value="#form.TEVnombre#" cfsqltype="cf_sql_varchar">, 
						<cfqueryparam value="#form.TEVequivalente#" cfsqltype="cf_sql_numeric">)
			</cfquery>
			<!--- Modificar Encabezado --->
			<cf_dbtimestamp datasource="#session.dsn#"
				table="TablaEvaluacion"
				redirect="tablaEvaluac.cfm"
				timestamp="#form.timestampE#"
				field1="TEcodigo" 
				type1="numeric" 
				value1="#form.TEcodigo#">			
			
			
			<cfquery name="ABC_TablaEvaluac" datasource="#Session.DSN#">
				update TablaEvaluacion
				set TEnombre = <cfqueryparam value="#form.TEnombre#" cfsqltype="cf_sql_varchar">,
					TEtipo=<cfqueryparam value="#form.TEtipo#" cfsqltype="cf_sql_char">
				where TEcodigo = <cfqueryparam value="#form.TEcodigo#" cfsqltype="cf_sql_numeric">
			</cfquery>	
			<cfset modo="CAMBIO">
				
		<!--- Caso 4: Modificar Detalle de Tabla de Evaluacion y modificar el encabezado --->			
		<cfelseif isdefined("Form.btnCambiarD")>
			<cf_dbtimestamp datasource="#session.dsn#"
				table="TablaEvaluacion"
				redirect="tablaEvaluac.cfm"
				timestamp="#form.timestampE#"
				field1="TEcodigo" 
				type1="numeric" 
				value1="#form.TEcodigo#">	
			
			<cf_dbtimestamp datasource="#session.dsn#"
				table="TablaEvaluacionValor"
				redirect="tablaEvaluac.cfm"
				timestamp="#form.timestampD#"
				field1="TEcodigo" 
				type1="numeric" 
				value1="#form.TEcodigo#"
				field2="TEVvalor" 
				type2="varchar" 
				value2="#form.TEVvalor#"
				>		
			
			<cfquery name="ABC_TablaEvaluac" datasource="#Session.DSN#">
				update TablaEvaluacionValor
				set TEVdescripcion = <cfqueryparam value="#form.TEVdescripcion#" cfsqltype="cf_sql_varchar">, 
					TEVnombre = <cfqueryparam value="#form.TEVnombre#" cfsqltype="cf_sql_varchar">, 
					TEVequivalente = <cfqueryparam value="#form.TEVequivalente#" cfsqltype="cf_sql_numeric" scale="2">
				where TEcodigo = <cfqueryparam value="#form.TEcodigo#"    cfsqltype="cf_sql_numeric">
					and TEVvalor = <cfqueryparam value="#form.TEVvalor#" cfsqltype="cf_sql_varchar">
			</cfquery>	

			<!--- Modificar Encabezado --->
			<cfquery name="ABC_TablaEvaluac" datasource="#Session.DSN#">			
				update TablaEvaluacion
				set TEnombre = <cfqueryparam value="#form.TEnombre#" cfsqltype="cf_sql_varchar">,
					TEtipo=<cfqueryparam value="#form.TEtipo#" cfsqltype="cf_sql_char">
				where TEcodigo = <cfqueryparam value="#form.TEcodigo#" cfsqltype="cf_sql_numeric">
			</cfquery>	
			<cfset modo="CAMBIO">				
				
		<!--- Caso 5: Borrar detalle de tabla de Evaluacion --->
		<cfelseif isdefined("Form.btnBorrarD")>
			<cfquery name="ABC_TablaEvaluac" datasource="#Session.DSN#">			
			delete from TablaEvaluacionValor
			where TEcodigo=<cfqueryparam value="#form.TEcodigo#" cfsqltype="cf_sql_numeric">
				and TEVvalor=<cfqueryparam value="#form.TEVvalor#" cfsqltype="cf_sql_varchar">				
			</cfquery>	
			<cfset modo="CAMBIO">								
		</cfif>					
<cfelse>
	<cfif isdefined("form.btnNuevoE")>
		<cfset modo = "ALTA" >
	<cfelse>	
		<cfset modo = "CAMBIO" >
	</cfif>
</cfif>

<!--- Actualizacion de los montos de minimo y maximo solo en ALTA o CAMBIO de Detalle --->
	<cfif isdefined("Form.btnCambiarE") or isdefined("Form.btnAgregarD") or isdefined("Form.btnCambiarD") or isdefined("Form.btnBorrarD")>
		<cfquery name="rsmaximo" datasource="#Session.DSN#">
			select max(b.TEVequivalente) as maximo, a.TEmas100
			from TablaEvaluacion a,TablaEvaluacionValor b
			where a.TEcodigo = <cfqueryparam value="#form.TEcodigo#" cfsqltype="cf_sql_numeric">
			and a.TEcodigo = b.TEcodigo
			group by a.TEmas100
		</cfquery>
		<cfif rsmaximo.recordCount GT 0 and (rsmaximo.maximo lt 100 or rsmaximo.TEmas100 eq 0) >
			<cfset maximo = 100>
			<cfquery name="rsmaximo" datasource="#Session.DSN#">
				update TablaEvaluacionValor
				set TEVequivalente = #maximo#
				where TablaEvaluacionValor.TEcodigo      = <cfqueryparam value="#form.TEcodigo#"    cfsqltype="cf_sql_numeric">
				and TablaEvaluacionValor.TEVequivalente = (
										select max(May.TEVequivalente)
										from TablaEvaluacionValor May
										where May.TEcodigo = TablaEvaluacionValor.TEcodigo
				)		
			</cfquery>
			
			<cfquery name="rsTablaEvaluacionValor" datasource="#Session.DSN#">
				 select a.TEVequivalente,
				 coalesce((select max(max.TEVequivalente) from TablaEvaluacionValor max where max.TEcodigo  = #form.TEcodigo# and max.TEVequivalente < a.TEVequivalente ),0) as max_TEVequivalente,
				 coalesce((select min(min.TEVequivalente) from TablaEvaluacionValor min where min.TEcodigo  = #form.TEcodigo# and min.TEVequivalente < a.TEVequivalente),a.TEVequivalente) as min_TEVequivalente,
				 coalesce((select max(max.TEVequivalente) from TablaEvaluacionValor max where max.TEcodigo  = #form.TEcodigo# and max.TEVequivalente > a.TEVequivalente ),0) as max_TEVequivalente2,
				 coalesce((select min(min.TEVequivalente) from TablaEvaluacionValor min where min.TEcodigo  = #form.TEcodigo# and min.TEVequivalente > a.TEVequivalente),a.TEVequivalente) as min_TEVequivalente2
				 
				 from TablaEvaluacionValor a
				 where a.TEcodigo      = #form.TEcodigo#
				 order by TEVequivalente				 
			</cfquery>
			<cfset 	var_TEVequivalente 	     =  0>
			<cfset 	var_max_TEVequivalente   =  0>
			<cfset 	var_min_TEVequivalente   =  0>
			<cfset 	var_max_TEVequivalente2  =  0>
			<cfset 	var_min_TEVequivalente2  =  0>
			<cfif rsTablaEvaluacionValor.recordCount GT 0>
				<cfloop query="rsTablaEvaluacionValor">
					<cfset 	var_TEVequivalente 		 =  rsTablaEvaluacionValor.TEVequivalente>
					<cfset 	var_max_TEVequivalente   =  rsTablaEvaluacionValor.max_TEVequivalente>
					<cfset 	var_min_TEVequivalente   =  rsTablaEvaluacionValor.min_TEVequivalente>
					<cfset 	var_max_TEVequivalente2  =  rsTablaEvaluacionValor.max_TEVequivalente2>
					<cfset 	var_min_TEVequivalente2  =  rsTablaEvaluacionValor.min_TEVequivalente2>
					<cfif form.TEtipo EQ "1"> <!--- Hacia arriba --->
						<cfquery name="rs_update" datasource="#Session.DSN#">
							update TablaEvaluacionValor
							set TEVminimo = #var_max_TEVequivalente# + 0.001,
							TEVmaximo = TEVequivalente
							where TEcodigo      = <cfqueryparam value="#form.TEcodigo#"    cfsqltype="cf_sql_numeric">
							and   TEVequivalente =  #var_TEVequivalente#
						</cfquery>	
						
						<cfif #var_max_TEVequivalente# eq #var_TEVequivalente#>
							<cfquery name="rs_update" datasource="#Session.DSN#">
								update TablaEvaluacionValor
								set TEVmaximo = #maximo#
								where TEcodigo      = <cfqueryparam value="#form.TEcodigo#"    cfsqltype="cf_sql_numeric">
								and   TEVequivalente =  #var_TEVequivalente#
							</cfquery>
						</cfif>
					<cfelseif form.TEtipo EQ "2"> <!--- Hacia Abajo --->
						<cfquery name="rs_update" datasource="#Session.DSN#">
							update TablaEvaluacionValor
							set TEVmaximo = #var_max_TEVequivalente2# - 0.001,
							TEVminimo = TEVequivalente
							where TEcodigo      = <cfqueryparam value="#form.TEcodigo#"    cfsqltype="cf_sql_numeric">
							and   TEVequivalente =  #var_TEVequivalente#
						</cfquery>	
						<cfif #var_max_TEVequivalente2# eq #var_TEVequivalente#>
							<cfquery name="rs_update" datasource="#Session.DSN#">
								update TablaEvaluacionValor
								set TEVminimo = 0
								where TEcodigo      = <cfqueryparam value="#form.TEcodigo#"    cfsqltype="cf_sql_numeric">
								and   TEVequivalente =  #var_TEVequivalente#
							</cfquery>
						</cfif>
					<cfelseif form.TEtipo EQ "0"> <!--- El mas cercano --->
						<cfquery name="rs_update" datasource="#Session.DSN#">
							update TablaEvaluacionValor
							set TEVminimo = (TEVequivalente + #var_max_TEVequivalente#)/2,
							TEVmaximo = ((TEVequivalente + #var_min_TEVequivalente#)/2)-0.0001
							where TEcodigo      = <cfqueryparam value="#form.TEcodigo#"    cfsqltype="cf_sql_numeric">
							and   TEVequivalente =  #var_TEVequivalente#
						</cfquery>
					</cfif>
				</cfloop>
			</cfif>
		</cfif> 
	</cfif>
		
<cfif isdefined("Form.btnAgregarE")>
	<cfset Form.TEcodigo = ABC_TablaEvaluac.identity >
</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="TEcodigo" type="hidden" value="<cfif modo EQ "CAMBIO">#Form.TEcodigo#</cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>