
	<cfif isdefined("session.deduccion_empleado")>
		<cfset structDelete(session, 'deduccion_empleado')>
	</cfif>

	 <cfset session.deduccion_empleado.DEid = form.DEid >
	<cfset session.deduccion_empleado.TDid = form.TDid >
	<cfset session.deduccion_empleado.Dreferencia = form.RHIDreferencia >
	<cfset session.deduccion_empleado.Ddescripcion = form.RHIDdesc>
	<cfset session.deduccion_empleado.SNcodigo = form.SNcodigo >
	<cfset session.deduccion_empleado.Dmonto = form.RHIDmonto>
	<cfset session.deduccion_empleado.Dtasa = form.RHIDtasa >
	<cfset session.deduccion_empleado.Dtasainteresmora = form.RHIDtasamora >
	<cfset session.deduccion_empleado.Dfechaini = form.RHIDfechadesde >
	<cfset session.deduccion_empleado.Dfechadoc = form.RHIDfechadoc >
	<cfset session.deduccion_empleado.Dobservacion = form.RHIDObs >
	<cfset session.deduccion_empleado.Tcodigo = form.Tcodigo >
	<cfset session.deduccion_empleado.Dnumcuotas = form.RHIDcuotas >
	<cfset session.deduccion_empleado.Dperiodicidad = form.Dperiodicidad >
	<cflocation url="registroDeduccionesConfirma.cfm">
	
	
	
