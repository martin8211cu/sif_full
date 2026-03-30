
		<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
		<cfset LobjControl.CreaTablaIntPresupuesto()>

		<cfquery datasource="#session.DSN#">
			insert into #request.intPresupuesto#
				(
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					
					NumeroLinea, 
					CPPid, CPCano, CPCmes, CPcuenta, Ocodigo,
					TipoMovimiento,								--- RP=Provisión Presupuestaria o T=Traslado
					Mcodigo, 	MontoOrigen, 
					TipoCambio, Monto,
					NAPreferencia, LINreferencia
				)
			select ...
		</cfquery>
		
		<cfset LvarNAP = LobjControl.ControlPresupuestario("PRCO", rsEncabezado.CPDEnumeroDocumento, "", rsEncabezado.CPDEfechaDocumento, rsEncabezado.CPCano, rsEncabezado.CPCmes)>
		<!---
			<cfinvoke 
				 component		= "PRES_Presupuesto"
				 method			= "ControlPresupuestario"
				 returnvariable	= "LvarNAP">
						<cfinvokeargument name="ModuloOrigen"  		value="PRCO"/>
						<cfinvokeargument name="NumeroDocumento" 	value="#rsEncabezado.CPDEnumeroDocumento#"/>
						<cfinvokeargument name="NumeroReferencia" 	value=""/>
						<cfinvokeargument name="FechaDocumento" 	value="#rsEncabezado.CPDEfechaDocumento#"/>
						<cfinvokeargument name="AnoDocumento"		value="#rsEncabezado.CPCano#"/>
						<cfinvokeargument name="MesDocumento"		value="#rsEncabezado.CPCmes#"/>
			</cfinvoke>
		 --->
		<cfif LvarNAP LT 0>
			<cfquery datasource="#session.dsn#">
			   update CPDocumentoE
				  set NRP   = #-LvarNAP#
				where Ecodigo = #Session.Ecodigo#
				  and CPDEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.CPDEid#">
			</cfquery>
	
			<cf_errorCode	code = "50499"
							msg  = "RECHAZO EN CONTROL PRESUPUESTARIO: El documento generó el Numero de Rechazo Presupuestario NRP=@errorDat_1@ porque existe un exceso de presupuesto no autorizado"
							errorDat_1="#abs(LvarNAP)#"
			>
		<cfelse>
			<cfquery datasource="#session.dsn#">
			   update CPDocumentoE
				  set NAP   = #LvarNAP#
				where Ecodigo = #Session.Ecodigo#
				  and CPDEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.CPDEid#">
			</cfquery>
		</cfif>




