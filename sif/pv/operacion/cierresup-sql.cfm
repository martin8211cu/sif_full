<cfif isdefined("form.FAM01COD") and isdefined("form.FechaCierre")>

	<cfinvoke 
		component="sif.Componentes.PV_CerreDiario" 
		method="PV_CerreDiario" 
		returnvariable="Ret_PV_CerreDiario" 
		caja="#form.FAM01COD#" 
		debug="false"
		stfechahoy="#form.FechaCierre#"/> 
	<cflocation url="cierresup.cfm"/>
<cfelse>
	<cf_errorCode	code = "50575" msg = "Error en Cierre de Caja Supervisor, Debe seleccionar la caja de desea cerrar antes de ejecutar este proceso, Proceso Cancelado!">>
</cfif>



