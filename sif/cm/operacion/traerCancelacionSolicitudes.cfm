<cfif isdefined("url.formulario") and len(trim(url.formulario))>
	<cfset form.formulario = url.formulario>
</cfif>

<cfif isdefined("url.fESnumero") and len(trim(url.fESnumero))>
	<cfquery name="rsTraeSolicitud" datasource="#session.DSN#">
		select 	a.ESnumero,
			a.ESobservacion
		from ESolicitudCompraCM a
				inner join DSolicitudCompraCM b
				on b.ESidsolicitud = a.ESidsolicitud
				and b.Ecodigo = a.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and a.ESnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.fESnumero#">
			and a.ESestado in (20,25,40)
			and a.ESidsolicitud not in (select DOrdenCM.ESidsolicitud 
										from DOrdenCM inner join EOrdenCM on DOrdenCM.EOidorden = EOrdenCM.EOidorden 
										where DOrdenCM.ESidsolicitud = a.ESidsolicitud 	and EOrdenCM.EOestado < 10)
			and a.ESidsolicitud not in (select CMLineasProceso.ESidsolicitud 
										from CMLineasProceso inner join CMProcesoCompra on CMProcesoCompra.CMPid = CMLineasProceso.CMPid 
										and (CMProcesoCompra.CMPestado < 50 OR
                                        	 CMProcesoCompra.CMPestado = 79 OR <!---► 79 Aprobación de Cotizaciones(Solicitante)--->
                                             CMProcesoCompra.CMPestado = 81 OR <!---► 81 Aprobadas por el solicitante--->
                                             CMProcesoCompra.CMPestado = 83    <!---► 83 Canceladas por el solicitante--->
                                            )
                                        )
			and (b.DScant - b.DScantsurt) > 0

		order by ESnumero
	</cfquery>

	<script language="javascript1.2" type="text/javascript">
		<cfoutput>
		<cfif rsTraeSolicitud.recordCount gt 0>
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.fESnumero.value = '#rsTraeSolicitud.ESnumero#';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.fESobservacion.value = '#rsTraeSolicitud.ESobservacion#';
		<cfelse>			
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.fESnumero.value = '';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.fESobservacion.value = '';
		</cfif>
		</cfoutput>
	</script>
</cfif>