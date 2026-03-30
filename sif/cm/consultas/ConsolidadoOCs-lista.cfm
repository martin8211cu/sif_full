<!--- Se crea la navegación --->
<cfset navegacion = "">
<cfif isdefined("form.btnFiltrar")>
	<cfset navegacion = navegacion & "&btnFiltrar=#form.btnFiltrar#">
</cfif>
<cfif isdefined("form.fECOCnumeroI") and len(trim(form.fECOCnumeroI)) gt 0>
	<cfset navegacion = navegacion & "&fECOCnumeroI=#form.fECOCnumeroI#">
</cfif>
<cfif isdefined("form.fECOCnumeroF") and len(trim(form.fECOCnumeroF)) gt 0>
	<cfset navegacion = navegacion & "&fECOCnumeroF=#form.fECOCnumeroF#">
</cfif>
<cfif isdefined("form.fECOCfechaI") and len(trim(form.fECOCfechaI)) gt 0>
	<cfset navegacion = navegacion & "&fECOCfechaI=#form.fECOCfechaI#">
</cfif>
<cfif isdefined("form.fECOCfechaF") and len(trim(form.fECOCfechaF)) gt 0>
	<cfset navegacion = navegacion & "&fECOCfechaF=#form.fECOCfechaF#">
</cfif>
<cfif isdefined("form.fSNcodigo") and len(trim(form.fSNcodigo)) gt 0>
	<cfset navegacion = navegacion & "&fSNcodigo=#form.fSNcodigo#">
</cfif>
<cfif isdefined("form.fMcodigo") and len(trim(form.fMcodigo)) gt 0>
	<cfset navegacion = navegacion & "&fMcodigo=#form.fMcodigo#">
</cfif>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsListaConsolidaciones" datasource="#session.dsn#">
	select 	ecoc.ECOCid, eo.SNcodigo, eo.Mcodigo,
			sn.SNidentificacion #_Cat# ' - ' #_Cat# sn.SNnombre as Proveedor,
			ecoc.ECOCnumero,
			max(ecoc.ECOCfechaconsolida) as ECOCfechaconsolida,
			mon.Mnombre,
            sum(
                round(docm.DOtotal * ((docm.DOcantidad - docm.DOcantsurtida) / docm.DOcantidad), 2)
                - round(docm.DOtotal * ((docm.DOcantidad - docm.DOcantsurtida) / docm.DOcantidad) * (docm.DOporcdesc / 100.00), 2)
                + round(docm.DOtotal * ((docm.DOcantidad - docm.DOcantsurtida) / docm.DOcantidad) * (1.00 - (docm.DOporcdesc / 100.00)) * (imp.Iporcentaje / 100.00), 2)
            ) as EOsaldo,
			'<img	src="OrdenesCompra-email.gif"
					style="cursor:pointer" 
					onclick="javascript: enviarCorreo(' #_Cat# <cf_dbfunction name="to_char" datasource="#session.dsn#" args="ecoc.ECOCid">
													    #_Cat# ', ' #_Cat# <cf_dbfunction name="to_char" datasource="#session.dsn#" args="eo.SNcodigo">
														#_Cat# ', ' #_Cat# <cf_dbfunction name="to_char" datasource="#session.dsn#" args="eo.Mcodigo">
														#_Cat# 
							');" 
					border="0" width="37" height="12">' as EnviarCorreo,
			case when sum(dcoc.DCOCrrenviado) > 0 and sum(dcoc.DCOCrdenviado) > 0
					then 'Resumido y Detallado'
				 when sum(dcoc.DCOCrrenviado) > 0
					then 'Resumido'
				 when sum(dcoc.DCOCrdenviado) > 0
					then 'Detallado'
				 else ''
			end as ReportesEnviados

	from EConsolidadoOrdenCM ecoc
	
		inner join DConsolidadoOrdenCM dcoc
			on dcoc.ECOCid = ecoc.ECOCid
			and dcoc.Ecodigo = ecoc.Ecodigo
			
			inner join EOrdenCM eo
				on eo.EOidorden = dcoc.EOidorden
				and eo.Ecodigo = dcoc.Ecodigo
				
				inner join SNegocios sn
					on sn.SNcodigo = eo.SNcodigo
					and sn.Ecodigo = eo.Ecodigo
					
				inner join Monedas mon
					on mon.Mcodigo = eo.Mcodigo
					and mon.Ecodigo = eo.Ecodigo
				
				inner join DOrdenCM docm
					on docm.EOidorden = eo.EOidorden
					
					inner join Impuestos imp
						on imp.Icodigo = docm.Icodigo
						and imp.Ecodigo = docm.Ecodigo

	where ecoc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and eo.EOestado = 10
		and docm.DOcantidad > docm.DOcantsurtida
		<cfif isdefined("form.fECOCnumeroI") and len(trim(form.fECOCnumeroI)) gt 0>
			and ecoc.ECOCnumero >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fECOCnumeroI#">
		</cfif>
		<cfif isdefined("form.fECOCnumeroF") and len(trim(form.fECOCnumeroF)) gt 0>
			and ecoc.ECOCnumero <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fECOCnumeroF#">
		</cfif>
		<cfif isdefined("form.fECOCfechaI") and len(trim(form.fECOCfechaI)) gt 0>
			and ecoc.ECOCfechaconsolida >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fECOCfechaI)#">
		</cfif>
		<cfif isdefined("form.fECOCfechaF") and len(trim(form.fECOCfechaF)) gt 0>
			and ecoc.ECOCfechaconsolida <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', 1, LSParseDateTime(form.fECOCfechaF))#">
		</cfif>
		<cfif isdefined("form.fSNcodigo") and len(trim(form.fSNcodigo)) gt 0>
			and eo.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fSNcodigo#">
		</cfif>
		<cfif isdefined("form.fMcodigo") and len(trim(form.fMcodigo)) gt 0 and form.fMcodigo neq -1>
			and eo.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fMcodigo#">
		</cfif>
	group by ecoc.ECOCid, eo.Ecodigo, eo.SNcodigo, eo.Mcodigo,
			 ecoc.ECOCnumero, mon.Mnombre, sn.SNidentificacion, sn.SNnombre
	order by sn.SNnombre, ecoc.ECOCnumero, mon.Mnombre
</cfquery>

<cfinvoke 
		component="sif.Componentes.pListas"
		method="pListaQuery"
		returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsListaConsolidaciones#"/>
	<cfinvokeargument name="cortes" value="Proveedor"/>
	<cfinvokeargument name="desplegar" value="ECOCnumero, ECOCfechaconsolida, Mnombre, EOsaldo, ReportesEnviados, EnviarCorreo"/>
	<cfinvokeargument name="etiquetas" value="Número de Consolidado, Fecha de Consolidación, Moneda, Saldo, Reportes Enviados, &nbsp;"/>
	<cfinvokeargument name="formatos" value="V, D, V, M, V, IMG"/>
	<cfinvokeargument name="align" value="left, left, left, right, center, left"/>
	<cfinvokeargument name="ajustar" value="N, N, N, N, S, S"/>
	<cfinvokeargument name="irA" value="ConsolidadoOCs-filtro.cfm"/>
	<cfinvokeargument name="funcion" value="mostrarReporte"/>
	<cfinvokeargument name="fparams" value="ECOCid, SNcodigo, Mcodigo"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="maxRows" value="15"/>
</cfinvoke>
