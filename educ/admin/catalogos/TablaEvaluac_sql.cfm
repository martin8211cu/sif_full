<cfset action = "tablaEvaluac.cfm">

<cfif not isdefined("form.btnNuevoD") and  not isdefined("form.btnNuevoE")>
	<cftry>
		<cfquery name="ABC_TablaEvaluac" datasource="#Session.DSN#">
			<!--- Caso 1: Agregar Encabezado --->
			set nocount on
			<cfif isdefined("Form.btnAgregarE")>
					insert TablaEvaluacion (Ecodigo, TEnombre, TEtipo, TEmas100)
						values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TEnombre#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#form.TEtipo#">,
								<cfif isdefined("form.TEmas100")>1<cfelse>0</cfif>
								)
						select @@identity as id
				<cfset modo="CAMBIO">
			<!--- Caso 1.1: Cambia Encabezado --->
			<cfelseif isdefined("Form.btnCambiarE")>
				update TablaEvaluacion
				set TEnombre = <cfqueryparam value="#form.TEnombre#" cfsqltype="cf_sql_varchar">,
					TEtipo=<cfqueryparam value="#form.TEtipo#" cfsqltype="cf_sql_char">,
					TEmas100=<cfif isdefined("form.TEmas100")>1<cfelse>0</cfif>
				where TEcodigo = <cfqueryparam value="#form.TEcodigo#" cfsqltype="cf_sql_numeric">
				 and ts_rversion = convert(varbinary,#lcase(form.timestampE)#)	
				<cfset modo="CAMBIO">
							
			<!--- Caso 2: Borrar un Encabezado de Tablas de Evaluacion --->
			<cfelseif isdefined("Form.btnBorrarE")>			
				<cfif isdefined("Form.TEcodigo") AND Form.TEcodigo NEQ "">
					delete TablaEvaluacionValor
					where TEcodigo=<cfqueryparam value="#form.TEcodigo#" cfsqltype="cf_sql_numeric">
					
					delete TablaEvaluacion 
					where TEcodigo=<cfqueryparam value="#form.TEcodigo#" cfsqltype="cf_sql_numeric">				
					<cfset modo="ALTA">									
				</cfif>
				<cfset modo="ALTA">
			<!--- Caso 3: Agregar Detalle de Tablas de Evaluacion y opcionalmente modificar el encabezado --->
			<cfelseif isdefined("Form.btnAgregarD")>
					
					insert TablaEvaluacionValor (TEcodigo, TEVvalor, TEVdescripcion, TEVnombre, TEVequivalente )
					values (<cfqueryparam value="#form.TEcodigo#" cfsqltype="cf_sql_numeric">,
							<cfqueryparam value="#form.TEVvalor#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#form.TEVdescripcion#" cfsqltype="cf_sql_varchar">, 
							<cfqueryparam value="#form.TEVnombre#" cfsqltype="cf_sql_varchar">, 
							<cfqueryparam value="#form.TEVequivalente#" cfsqltype="cf_sql_numeric">)
						
					<!--- Modificar Encabezado --->
					update TablaEvaluacion
					set TEnombre = <cfqueryparam value="#form.TEnombre#" cfsqltype="cf_sql_varchar">,
						TEtipo=<cfqueryparam value="#form.TEtipo#" cfsqltype="cf_sql_char">
					where TEcodigo = <cfqueryparam value="#form.TEcodigo#" cfsqltype="cf_sql_numeric">
					 and ts_rversion = convert(varbinary,#lcase(form.timestampE)#)	
					<cfset modo="CAMBIO">
				
			<!--- Caso 4: Modificar Detalle de Tabla de Evaluacion y modificar el encabezado --->			
			<cfelseif isdefined("Form.btnCambiarD")>
				update TablaEvaluacionValor
				set TEVdescripcion   = <cfqueryparam value="#form.TEVdescripcion#" cfsqltype="cf_sql_varchar">, 
					TEVnombre   = <cfqueryparam value="#form.TEVnombre#" cfsqltype="cf_sql_varchar">, 
					TEVequivalente  = <cfqueryparam value="#form.TEVequivalente#" cfsqltype="cf_sql_numeric" scale="2">
				where TEcodigo     = <cfqueryparam value="#form.TEcodigo#"    cfsqltype="cf_sql_numeric">
				  and TEVvalor   	= <cfqueryparam value="#form.TEVvalor#" cfsqltype="cf_sql_varchar">
				   and ts_rversion = convert(varbinary,#lcase(form.timestampD)#)	

				<!--- Modificar Encabezado --->
				update TablaEvaluacion
				set TEnombre = <cfqueryparam value="#form.TEnombre#" cfsqltype="cf_sql_varchar">,
					TEtipo=<cfqueryparam value="#form.TEtipo#" cfsqltype="cf_sql_char">
				where TEcodigo = <cfqueryparam value="#form.TEcodigo#" cfsqltype="cf_sql_numeric">
				 and ts_rversion = convert(varbinary,#lcase(form.timestampE)#)	
				<cfset modo="CAMBIO">				
				
			<!--- Caso 5: Borrar detalle de tabla de Evaluacion --->
			<cfelseif isdefined("Form.btnBorrarD")>
				delete TablaEvaluacionValor
				where TEcodigo=<cfqueryparam value="#form.TEcodigo#" cfsqltype="cf_sql_numeric">
				and TEVvalor=<cfqueryparam value="#form.TEVvalor#" cfsqltype="cf_sql_varchar">				
				<cfset modo="CAMBIO">								
			</cfif>					
			set nocount off				
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="/educ/errorpages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>		
<cfelse>
	<cfif isdefined("form.btnNuevoE")>
		<cfset modo = "ALTA" >
	<cfelse>	
		<cfset modo = "CAMBIO" >
	</cfif>
</cfif>

<!--- Actualizacion de los montos de minimo y maximo solo en ALTA o CAMBIO de Detalle --->
<cftry>
	<cfif isdefined("Form.btnCambiarE") or isdefined("Form.btnAgregarD") or isdefined("Form.btnCambiarD") or isdefined("Form.btnBorrarD")>
		<cfquery name="ABC_TablaEvaluacMinMax" datasource="#Session.DSN#">
			set nocount on
			declare @maximo numeric(6,3)
			select @maximo = max(TEVequivalente)
			  from TablaEvaluacionValor
			 where TEcodigo = <cfqueryparam value="#form.TEcodigo#" cfsqltype="cf_sql_numeric">
			if @maximo < 100 OR (select TEmas100 from TablaEvaluacion where TEcodigo = <cfqueryparam value="#form.TEcodigo#"    cfsqltype="cf_sql_numeric">) = 0
			BEGIN
				select @maximo = 100
				update TablaEvaluacionValor
				   set TEVequivalente = 100
				   from TablaEvaluacionValor ev
				  where ev.TEcodigo      = <cfqueryparam value="#form.TEcodigo#"    cfsqltype="cf_sql_numeric">
					and ev.TEVequivalente = (
						 select max(May.TEVequivalente)
						   from TablaEvaluacionValor May
						  where May.TEcodigo = ev.TEcodigo
						)			
			END
			<cfif form.TEtipo EQ "1"> <!--- Hacia arriba --->
				update TablaEvaluacionValor
				   set TEVminimo = (
						  select convert(numeric(6,3),isnull(max(Ant.TEVequivalente)+0.001,0))
							from TablaEvaluacionValor Ant
						   where Ant.TEcodigo = ev.TEcodigo
							 and Ant.TEVequivalente < ev.TEVequivalente
					   ),
					   TEVmaximo = TEVequivalente
				  from TablaEvaluacionValor ev
				 where ev.TEcodigo      = <cfqueryparam value="#form.TEcodigo#"    cfsqltype="cf_sql_numeric">
			
				update TablaEvaluacionValor
				   set TEVmaximo = @maximo
				   from TablaEvaluacionValor ev
				  where ev.TEcodigo      = <cfqueryparam value="#form.TEcodigo#"    cfsqltype="cf_sql_numeric">
					and ev.TEVequivalente = (
						 select max(May.TEVequivalente)
						   from TablaEvaluacionValor May
						  where May.TEcodigo = ev.TEcodigo
						)			
			<cfelseif form.TEtipo EQ "2"> <!--- Hacia Abajo --->
				update TablaEvaluacionValor
				   set TEVmaximo = (
						 select convert(numeric(6,3),isnull(min(Ant.TEVequivalente)-0.001,@maximo))
						   from TablaEvaluacionValor Ant
						  where Ant.TEcodigo = ev.TEcodigo
							and Ant.TEVequivalente > ev.TEVequivalente
					   ),
					   TEVminimo = TEVequivalente
				   from TablaEvaluacionValor ev
				  where ev.TEcodigo      = <cfqueryparam value="#form.TEcodigo#"    cfsqltype="cf_sql_numeric">

				update TablaEvaluacionValor
				   set TEVminimo = 0
				   from TablaEvaluacionValor ev
				  where ev.TEcodigo      = <cfqueryparam value="#form.TEcodigo#"    cfsqltype="cf_sql_numeric">
					and ev.TEVequivalente = (
						 select min(May.TEVequivalente)
						   from TablaEvaluacionValor May
						  where May.TEcodigo = ev.TEcodigo
						)	
			<cfelseif form.TEtipo EQ "0"> <!--- El mas cercano --->
				update TablaEvaluacionValor
				  set TEVminimo = (
						 select convert(numeric(6,3),isnull((max(Ant.TEVequivalente)+ev.TEVequivalente)/2,0))
						   from TablaEvaluacionValor Ant
						  where Ant.TEcodigo = ev.TEcodigo
							and Ant.TEVequivalente < ev.TEVequivalente
					  ),
					  TEVmaximo = (
						 select convert(numeric(6,3),isnull((min(Ant.TEVequivalente)+ev.TEVequivalente)/2-0.0001,@maximo))
						   from TablaEvaluacionValor Ant
						  where Ant.TEcodigo = ev.TEcodigo
							and Ant.TEVequivalente > ev.TEVequivalente
					  )
				  from TablaEvaluacionValor ev
				 where ev.TEcodigo      = <cfqueryparam value="#form.TEcodigo#"    cfsqltype="cf_sql_numeric">
			</cfif>
			set nocount off
		</cfquery>
	</cfif>
<cfcatch type="any">
	<cfinclude template="/educ/errorpages/BDerror.cfm">
	<cfabort>
</cfcatch>
</cftry>
		
<cfif isdefined("Form.btnAgregarE")>
	<cfset Form.TEcodigo = #ABC_TablaEvaluac.id#>
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