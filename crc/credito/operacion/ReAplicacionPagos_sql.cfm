<cfset returnTo="ReAplicacionPagos_form.cfm">
<cfset modoC="">

<cfif isdefined('form.CAMBIO')>
	<cfset condonacionID = "">
	<cfset cont = 1>
	<cfset arr = listToArray (#form.PagadoRP#)>
	<cfset arrDescu = listToArray(#form.DescuentoRP#)>
	<cfloop list="#form.IdMovCuenta#" index="i">
		<cfset movCuentaId = "#i#">
			<cfset pagado = arr[cont]>
			<cfset descuento = arrDescu[cont]>
			<cfquery name="q_insert" datasource="#session.DSN#">
				update CRCMovimientoCuenta set 
					Pagado = #pagado#, Descuento = #descuento#
					where id = #movCuentaId#	
			</cfquery> 

			<cfquery name="q_MovCuenta" datasource="#session.DSN#">
				select mc.id, mc.Corte, t.CRCCuentasid 
				from CRCMovimientoCuenta mc
				inner join CRCTransaccion t
					on mc.CRCTransaccionid = t.id
				where mc.id = #movCuentaId#
			</cfquery>

			<cfset CRCTransaccion = createObject("component","crc.Componentes.transacciones.CRCTransaccion")>
			<cfset CRCTransaccion.init(session.dsn,session.ecodigo)>
			<cfset CRCTransaccion.caMccPorCorteCuenta(cortes=q_MovCuenta.Corte,CuentaID=q_MovCuenta.CRCCuentasid)>

		<cfset cont++>
	</cfloop>
	<cfset form.id = form.id>
	<cfset modoC="CAMBIO">
</cfif>

<cfif isDefined('form.corteAnterior') and #form.corteAnterior# neq '' and #form.corteAnterior# eq 'on'>
	<!---Invoca al componente de reprocesarCorte--->
	<cfinvoke component="crc.Componentes.cortes.CRCReProcesoCorte"  method="reProcesarCorte" cuentaID="#form.IdCuenta#">
<cfelse>
	<!---NO hace nada mas que actualizar los valores--->
</cfif>



<cfif isdefined('form.REGRESAR') or isdefined('form.BTNREGRESAR') >
	<cfset returnTo="ReAplicacionPagos.cfm">
</cfif>

<cfif isdefined('form.APLICAR')>
	
</cfif>


<!---VALIDADOR--->

<cfoutput>
	<form action="#returnTo#" method="post" name="sql">
		<cfif isdefined("Form.Nuevo")>
			<input name="Nuevo" type="hidden" value="Nuevo">
		</cfif>
		<cfif isdefined("Form.Regresar")>
			<input name="Regresar" type="hidden" value="Regresar">
		</cfif>
		
		<input name="modoC" type="hidden" value="<cfif isdefined("modoC")>#modoC#</cfif>">

		<cfif modoC neq 'ALTA' and modoC neq ''>
			<input name="id" type="hidden" value="<cfif isdefined("form.id")>#Form.id#</cfif>">
		</cfif>

		<input name="SNcodigo" id="SNcodigo"  type="hidden" value="#form.SNcodigo#">
	</form>

	<HTML>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
		<body>
			<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
		</body>
	</HTML>

</cfoutput>

