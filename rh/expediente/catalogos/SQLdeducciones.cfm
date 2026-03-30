<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso">
<cfset modo="ALTA">
<cfset AccionJN = "Alta">
	<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("Form.Alta")>
			<cfquery name="rsTDeduccionRenta" datasource="#session.DSN#">
				select 1
				from TDeduccion
				where TDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">
				and TDrenta > 0
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>
			<cfif rsTDeduccionRenta.RecordCount GT 0>
				<cfquery name="rsTDeduccionRentaOtra" datasource="#session.DSN#">
					select 1
					from DeduccionesEmpleado
					where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
					and TDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">
					and (<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.Dfechaini)#">
						between Dfechaini and Dfechafin
						or <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.Dfechafin)#">
						between Dfechaini and Dfechafin
						)
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				</cfquery>
				<cfif rsTDeduccionRentaOtra.RecordCount GT 0>
					<cfthrow message="Transacción Cancelada.
					Está definiendo una deducción
					de tipo renta, pero ya tiene otra
					de tipo renta definida para el rango
					de fechas dado, Proceso Cancelado!">
				</cfif>
			</cfif>

			<!--- Concepto SAT de Credito Infonavit --->
			<cfquery name="rsCredInf" datasource="#session.dsn#">
				select * from RHCFDIConceptoSAT
				where RHCSATtipo = 'D' and RHCSATcodigo = '010' <!--- RHCSATid --->
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>

			<cfquery name="rsEsValido" datasource="#session.dsn#">
				select RHCSATid from TDeduccion
				where TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>

			<cfif form.Dmetodo eq 2 and rsCredInf.RHCSATid neq rsEsValido.RHCSATid>
				<cfthrow message="Transacción Cancelada.
					Está definiendo una deducción que no es de tipo Crédito Infonavit,
					solo estas se pueden calcular en veces UMA, Proceso Cancelado!">
			</cfif>

			<cfif Form.Dmetodo eq 3>
				<cfinvoke component="rh.componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="14600706" default="0" returnvariable="vUMI"/>
				<cfif vUMI lte 0>
					<cfthrow message="Parametro Din&aacute;mico RH." detail="No se ha configurado el Parametro para la Unidad Mixta Infonavit (UMI) con el codigo: 14600706, Proceso Cancelado!">
				</cfif>
			</cfif>
			
			<cfquery name="ABC_Insdeducciones" datasource="#Session.DSN#">
				insert Into DeduccionesEmpleado ( DEid, Ecodigo, <cfif isdefined('form.SNcodigo')>SNcodigo,</cfif> TDid, Ddescripcion, Dmetodo, Dvalor, Dfechaini, Dfechafin,
											 Dmonto, Dtasa, Dsaldo, Dmontoint,DmontoFOA,DinteresFOA, Destado, Usucodigo, Ulocalizacion, Dactivo,
											 Dcontrolsaldo, Dreferencia<cfif isdefined("form.Dinicio")>,Dinicio</cfif>,DFA) <!---SML. Modificacion para insertar el Prestamos FOA --->
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfif isdefined('form.SNcodigo')><cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">,</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">,
					<cfif Len(Trim(Form.Ddescripcion)) NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ddescripcion#">,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TDdescripcion#">,
					</cfif>
					<cfif rsTDeduccionRenta.RecordCount EQ 0>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Dmetodo#">
					<cfelse>1</cfif>,
					<cfqueryparam cfsqltype="cf_sql_money" value="#form.Dvalor#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.Dfechaini)#">,
					<cfif isdefined("form.Dfechafin") and len(trim(form.Dfechafin))>
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.Dfechafin)#">,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="01/01/6100">,
					</cfif>
					<cfif isdefined("form.Dcontrolsaldo") and form.Dcontrolsaldo eq '1' and rsTDeduccionRenta.RecordCount EQ 0>
							<cfqueryparam cfsqltype="cf_sql_money" value="#form.Dmonto#"><cfelse>0</cfif>,
					<cfif isdefined("form.Dcontrolsaldo") and form.Dcontrolsaldo eq '1' and rsTDeduccionRenta.RecordCount EQ 0>
							<cfqueryparam cfsqltype="cf_sql_float" value="#form.Dtasa#"><cfelse>0</cfif>,
					<cfif isdefined("form.Dcontrolsaldo") and form.Dcontrolsaldo eq '1' and rsTDeduccionRenta.RecordCount EQ 0>
							<cfqueryparam cfsqltype="cf_sql_money" value="#form.Dsaldo#"><cfelse>0</cfif>,
					<cfif isdefined("form.Dcontrolsaldo") and form.Dcontrolsaldo eq '1' and rsTDeduccionRenta.RecordCount EQ 0>
							<cfqueryparam cfsqltype="cf_sql_money" value="#form.Dmontoint#"><cfelse>0</cfif>,
                    <cfif isdefined("form.Dcontrolsaldo") and form.Dcontrolsaldo eq '1' and rsTDeduccionRenta.RecordCount EQ 0>
							<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.DTmontointeres,',','')#"><cfelse>0</cfif>, <!---SML. Inicio Modificacion para insertar el Prestamos FOA --->
                    <cfif isdefined("form.Dcontrolsaldo") and form.Dcontrolsaldo eq '1' and rsTDeduccionRenta.RecordCount EQ 0>
							<cfqueryparam cfsqltype="cf_sql_money" value="#form.Dinteres#"><cfelse>0</cfif>,
                   <!--- <cfif isdefined("form.Dcontrolsaldo") and form.Dcontrolsaldo eq '1' and rsTDeduccionRenta.RecordCount EQ 0>
							<cfqueryparam cfsqltype="cf_sql_money" value="#form.Dminteres#"><cfelse>0</cfif>,---><!---SML. Final Modificacion para insertar el Prestamos FOA --->
					1,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
					<cfif isdefined("form.Dactivo")>1<cfelse>0</cfif>,
					<cfif isdefined("form.Dcontrolsaldo") and form.Dcontrolsaldo eq '1' and rsTDeduccionRenta.RecordCount EQ 0>
							1<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.Dreferencia#">
					<cfif isdefined("form.Dinicio")>
						, #form.Dinicio#
					</cfif>
                    <!--- Agregar el valor del  campo DFA tipo deduccion fondo  ahorro 1 IRR--->
                    <cfif isdefined("form.DfondoAhorro") and form.DfondoAhorro eq 1>
                    	, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DfondoAhorro#">
                     <cfelse>
                     	,0
                    </cfif>
				)
				<cfset modo="ALTA">
			</cfquery>
            <cfset AccionJN = "Alta">
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="ABC_Deldeducciones" datasource="#Session.DSN#">
				delete from DeduccionesEmpleado
				where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<cfset modo="ALTA">
            <cfset AccionJN = "Baja">
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="VABC_Upddeducciones" datasource="#Session.DSN#">
				select 1
				from DeduccionesEmpleado
				where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and Dcontrolsaldo = 1
				  and (Dsaldo > 0
				  	or Dtasa > 0
				  	or Dmonto > 0)
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>
			<cfquery name="rsTDeduccionRenta" datasource="#session.DSN#">
				select 1
				from TDeduccion
				where TDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">
				and TDrenta > 0
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>
			<cfif rsTDeduccionRenta.RecordCount GT 0>
				<cfquery name="rsTDeduccionRentaOtra" datasource="#session.DSN#">
					select 1
					from DeduccionesEmpleado
					where Did<><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
					and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
					and TDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">
					and (<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.Dfechaini)#">
						between Dfechaini and Dfechafin
						or <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.Dfechafin)#">
						between Dfechaini and Dfechafin
						)
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				</cfquery>
				<cfif rsTDeduccionRentaOtra.RecordCount GT 0>
					<cfthrow message="Transacción Cancelada.
					Está definiendo una deducción
					de tipo renta, pero ya tiene otra
					de tipo renta definida para el rango
					de fechas dado, Proceso Cancelado!">
				</cfif>
			</cfif>
			<cfif VABC_Upddeducciones.recordcount and rsTDeduccionRenta.recordcount>
				<cfthrow message="Transacción Cancelada.
					Está definiendo una deducción
					de tipo renta que controla saldo,
					y tiene saldo, tasa o monto, Proceso
					Cancelado!">
			</cfif>
			<!--- Concepto SAT de Credito Infonavit --->
			<cfquery name="rsCredInf" datasource="#session.dsn#">
				select * from RHCFDIConceptoSAT
				where RHCSATtipo = 'D' and RHCSATcodigo = '010' <!--- RHCSATid --->
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>

			<cfquery name="rsEsValido" datasource="#session.dsn#">
				select RHCSATid from TDeduccion
				where TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>

			<cfif form.Dmetodo eq 2 and rsCredInf.RHCSATid neq rsEsValido.RHCSATid>
				<cfthrow message="Transacción Cancelada.
					Está definiendo una deducción que no es de tipo Credito Infonavit,
					solo estas se pueden calcular en veces UMA, Proceso Cancelado!">
			</cfif>

			<cfif Form.Dmetodo eq 3>
				<cfinvoke component="rh.componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="14600706" default="0" returnvariable="vUMI"/>
				<cfif vUMI lte 0>
					<cfthrow message="Parametro Din&aacute;mico RH." detail="No se ha configurado el Parametro para la Unidad Mixta Infonavit (UMI) con el codigo: 14600706, Proceso Cancelado!">
				</cfif>
			</cfif>

			<cfquery name="ABC_Upddeducciones" datasource="#Session.DSN#">
				update DeduccionesEmpleado set
					TDid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">,
					<cfif Len(Trim(Form.Ddescripcion)) NEQ 0>
						Ddescripcion	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ddescripcion#">,
					<cfelse>
						Ddescripcion	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TDdescripcion#">,
					</cfif>
                    <cfif isdefined('form.SNcodigo')>SNcodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">,</cfif>
					Dmetodo			= <cfif rsTDeduccionRenta.RecordCount EQ 0>
											<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Dmetodo#">
										<cfelse>1</cfif>,
					Dvalor 			= <cfqueryparam cfsqltype="cf_sql_money" value="#form.Dvalor#">,
					Dfechaini		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.Dfechaini)#">,
					Dfechafin 		= <cfif isdefined("form.Dfechafin") and len(trim(form.Dfechafin))>
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.Dfechafin)#">,
									  <cfelse>
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="01/01/6100">,
									  </cfif>
					Dmonto 			= <cfif isdefined("form.Dcontrolsaldo") and form.Dcontrolsaldo eq '1' and rsTDeduccionRenta.RecordCount EQ 0>
											<cfqueryparam cfsqltype="cf_sql_money" value="#form.Dmonto#">
										<cfelse>0</cfif>,
					Dtasa			= <cfif isdefined("form.Dcontrolsaldo") and form.Dcontrolsaldo eq '1' and rsTDeduccionRenta.RecordCount EQ 0>
											<cfqueryparam cfsqltype="cf_sql_float" value="#form.Dtasa#">
										<cfelse>0</cfif>,
					Dsaldo			= <cfif isdefined("form.Dcontrolsaldo") and form.Dcontrolsaldo eq '1' and rsTDeduccionRenta.RecordCount EQ 0>
											<cfqueryparam cfsqltype="cf_sql_money" value="#form.Dmonto#">
										<cfelse>0</cfif>,
					Dmontoint		= <cfif isdefined("form.Dcontrolsaldo") and form.Dcontrolsaldo eq '1' and rsTDeduccionRenta.RecordCount EQ 0>
											<cfqueryparam cfsqltype="cf_sql_money" value="#form.Dmontoint#">
										<cfelse>0</cfif>,
                    DmontoFOA			= <cfif isdefined("form.Dcontrolsaldo") and form.Dcontrolsaldo eq '1' and rsTDeduccionRenta.RecordCount EQ 0>
											<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.DTmontointeres,',','')#">
										<cfelse>0</cfif>,
                    DinteresFOA		= <cfif isdefined("form.Dcontrolsaldo") and form.Dcontrolsaldo eq '1' and rsTDeduccionRenta.RecordCount EQ 0>
											<cfqueryparam cfsqltype="cf_sql_money" value="#form.Dinteres#">
										<cfelse>0</cfif>,
					Dactivo         = <cfif isdefined("form.Dactivo")>1<cfelse>0</cfif>,
					Dcontrolsaldo   = <cfif isdefined("form.Dcontrolsaldo") and form.Dcontrolsaldo eq '1' and form.Dcontrolsaldo eq '1' and rsTDeduccionRenta.RecordCount EQ 0>
										1<cfelse>0</cfif>,
					Dreferencia		= <cfqueryparam cfsqltype="cf_sql_char" value="#form.Dreferencia#">
					<cfif isdefined("form.Dinicio")>
						,Dinicio 	= #form.Dinicio#
					</cfif>
                    <cfif isdefined("form.DfondoAhorro") > <!--- Actualización  del valor del  campo DFA tipo deduccion fondo  ahorro 1 IRR--->
                    	, DFA=1
                     <cfelse>
                     	, DFA=0
                    </cfif>
				where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<cfset modo="CAMBIO">
            <cfset AccionJN = "Cambio">
		</cfif>
	</cfif>
<cfparam name="form.irA" default="expediente-cons.cfm">
<HTML>
<head></head>
<body>
<form action="<cfoutput>#form.irA#</cfoutput>" method="post" name="sql">
    <cfif isdefined("Form.Cambio")>
        <input name="Did" type="hidden" value="<cfoutput>#form.Did#</cfoutput>">
    </cfif>
    <cfif isdefined("form.DEid")><input name="DEid" type="hidden" value="<cfoutput>#form.DEid#</cfoutput>"></cfif>
    <cfif isdefined("modo")><input name="modo" type="hidden" value="<cfoutput>#modo#</cfoutput>"></cfif>
    <input name="o" type="hidden" value="8">
    <input name="sel" type="hidden" value="1">
    <input name="AccionJN" type="hidden" value="<cfoutput>#AccionJN#</cfoutput>">

</form>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
