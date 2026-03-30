
<!---REINTEGRO--->
	<cfif isdefined ('url.CCHid') and len(trim(url.CCHid)) gt 0 and url.Tipo eq 'REINTEGRO'>
		<cfquery name="rsBus" datasource="#session.dsn#">
			select sum(CCHTAmonto) as disponible from CCHTransaccionesAplicadas where CCHTtipo='GASTO' and CCHTAreintegro < 0 and CCHid= #url.CCHid#
		</cfquery>
		
		<cfif rsBus.disponible gt 0>
			<cfset disponible=rsBus.disponible>
		<cfelse>
			<cfset disponible=0.00>
		</cfif>
			<cfoutput>
				<cf_inputNumber name="montoA" size="20" value="#disponible#" enteros="13" decimales="2" maxlenght="15" readOnly="true">
			</cfoutput>
	<cfelseif (not isdefined ('url.CCHid') or len(trim(url.CCHid)) eq 0) and url.Tipo eq 'REINTEGRO'>
		<cf_errorCode	code = "50744" msg = "Si desea realizar un Reintegro debe de seleccionar primero la caja y luego la transaccion">
		<cf_inputNumber name="montoA" size="20" value="" enteros="13" decimales="2" maxlenght="15">
	<cfelseif isdefined ('url.CCHid') and len(trim(url.CCHid)) gt 0 and (url.Tipo neq 'CIERRE' and url.Tipo neq 'REINTEGRO')>
		<cf_inputNumber name="montoA" size="20" value="" enteros="13" decimales="2" maxlenght="15" >
	</cfif>
	

	<!---CIERRE--->
	<cfoutput>
		<cfif isdefined ('url.CCHid') and len(trim(url.CCHid)) gt 0 and url.Tipo eq 'CIERRE'>
			<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="MDisponible" returnvariable="disponible">
				<cfinvokeargument name="CCHid" value="#url.CCHid#"/>
			</cfinvoke>
		<cfif disponible gt 0>
			<cfset monto=disponible>
		<cfelse>
			<cfset monto=0.00>
		</cfif>
		<cfoutput>
			<cf_inputNumber name="montoA" size="20" value="#monto#" enteros="13" decimales="2" maxlenght="15" readOnly="true">
		</cfoutput>
	<cfelseif (not isdefined ('url.CCHid') or len(trim(url.CCHid)) eq 0) and url.Tipo eq 'CIERRE'>
		<cf_errorCode	code = "50745" msg = "Si desea realizar un cierre debe de seleccionar primero la caja y luego la transaccion">
			<cf_inputNumber name="montoA" size="20" value="" enteros="13" decimales="2" maxlenght="15">
<!---	<cfelseif isdefined ('url.CCHid') and len(trim(url.CCHid)) gt 0 and (url.Tipo neq 'CIERRE' or url.Tipo neq 'REINTEGRO') >
			<cf_inputNumber name="montoA" size="20" value="" enteros="13" decimales="2" maxlenght="15" >--->
	</cfif>
</cfoutput>


