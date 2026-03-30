
	<cfquery name="slActivo" datasource="#session.dsn#">
		select Avalrescate from Activos where Aid=#url.activo#
	</cfquery>

	<cfquery name="slDescrip" datasource="#session.dsn#">
		select Adescripcion from Activos where Aid=#url.activo#
	</cfquery>

	<!---Valor del activo--->
	<cfquery name="rsActivo" datasource="#session.dsn#">
		select AFSvaladq
		from AFSaldos
		where Aid = #url.activo#
	</cfquery>

<cfoutput>

	<!---Caso 1 Actualizar el monto de Valor Rescate--->
	<cfif url.tipo eq 1 and len(trim(url.valor)) gt 0>
		<cfif url.valor lt rsActivo.AFSvaladq>
				<cfif slActivo.Avalrescate neq url.valor>
					<cfquery name="upValor" datasource="#session.dsn#">
						update AFTRelacionCambioD set AFTDvalrescate=#url.valor# where Aid=#url.activo# and AFTRid=#url.id#
					</cfquery>
				</cfif>
		<cfelse>
			<script language="javascript1.2" type="text/javascript">
				 alert ("No se puede ingresar un valor de rescate mayor que el costo del Activo");
				 window.parent.document.getElementById("Activo_" + #url.Activo#).value = "#slActivo.Avalrescate#";
			</script>
		</cfif>
	</cfif>

	<!---Caso 2 Actualizar la descripcion del activo--->
	<cfif url.tipo eq 2 and len(trim(url.descrip)) gt 0>
			<cfif #slDescrip.Adescripcion# neq #descrip#>
						<cfquery name="upDescrip" datasource="#session.dsn#">
							update AFTRelacionCambioD set AFTDdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.descrip#">
							 where Aid=#url.activo# and AFTRid=#url.id#
						</cfquery>
			</cfif>
	</cfif>
	<!---Caso 3 Actualizar ambos--->
	<cfif url.tipo eq 3>
			<cfquery name="upfecha" datasource="#session.dsn#">
					update AFTRelacionCambioD set
					AFTDfechainidep=<cfqueryparam cfsqltype="cf_sql_date" value="#LSparseDatetime(url.fecha)#">
					 where Aid=#url.activo# and AFTRid=#url.id#
				</cfquery>

	</cfif>
<!---Caso 5 Actualiza Marca por Garantia---><!---Se agrega para cambio de Valores de Activo por Garantia --->

	<cfif url.tipo eq 5>
		<cfquery name="rsSalida" datasource="#session.dsn#">
			select AEntradaSalida, Adescripcion
			from Activos
			where Aid = #url.activo#
		</cfquery>
		
		<cfif isdefined("rsSalida.AEntradaSalida") and rsSalida.AEntradaSalida eq 2>
			<cfthrow message="El activo '#rsSalida.Adescripcion#' se encuentra en estatus de salida, por lo tanto no puede ser modificado.">
		</cfif>
		
		<cfif isdefined("rsSalida.AEntradaSalida") and rsSalida.AEntradaSalida eq 3>
			<cfthrow message="El activo '#rsSalida.Adescripcion#' se encuentra en estatus de salida por comodato, por lo tanto no puede ser modificado.">
		</cfif>
		 
	</cfif>

	<cfif url.tipo eq 5 and url.Cambio eq "Marca">
			<cfquery name="upfecha" datasource="#session.dsn#">
					update AFTRelacionCambioD set
					AFMid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Marca#">,
                    AFMMid = null
					where Aid=#url.activo# and AFTRid=#url.id#
			</cfquery>

	</cfif>

    <cfif url.tipo eq 5 and url.Cambio eq "Modelo">
			<cfquery name="upfecha" datasource="#session.dsn#">
					update AFTRelacionCambioD set
					AFMMid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.modelo#">
					 where Aid=#url.activo# and AFTRid=#url.id#
		    </cfquery>

	</cfif>

	<!---
    <cfif url.tipo eq 5 and url.Cambio eq "Tipo">
			<cfquery name="upfecha" datasource="#session.dsn#">
					update AFTRelacionCambioD set
					AFCcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.AFCcodigo#">
					 where Aid=#url.activo# and AFTRid=#url.id#
			</cfquery>
	</cfif>
	--->

	<!--- JMRV. Inicio.  Para garantias, actualiza los valores de Aserie y Observaciones en la tabla AFTRelacionCambioD. 18/07/2014 --->

	<cfif url.tipo eq 5 and url.Cambio eq "Aserie">
			<cfquery name="upfecha" datasource="#session.dsn#">
					update AFTRelacionCambioD set
					Aserie=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Aserie#">
					where Aid=#url.activo# and AFTRid=#url.id#
			</cfquery>
	</cfif>

	<cfif url.tipo eq 5 and url.Cambio eq "Observacion">
			<cfquery name="upfecha" datasource="#session.dsn#">
					update AFTRelacionCambioD set
					Observaciones=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Observacion#">
					where Aid=#url.activo# and AFTRid=#url.id#
			</cfquery>
	</cfif>

	<!--- JMRV. Fin. 18/07/2014 --->



</cfoutput>
