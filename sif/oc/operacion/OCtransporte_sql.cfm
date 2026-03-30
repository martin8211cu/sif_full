<cfif isdefined("form.btnCerrar") OR isdefined("form.btnVer_Cierre")>
	<cfif not isdefined("form.chk")>
		<cf_errorCode	code = "50442" msg = "No se han escogido Transportes a Cerrar">
	</cfif>

	<!--- Hay que hacer un loop con los Id's de los cheks de la lista --->
	<cfloop list="#form.chk#" index="LvarChk">
		<cfinvoke component="sif.oc.Componentes.OC_transito" 
				method="OC_Cierre_Transporte"

				Ecodigo = "#Session.Ecodigo#"
				OCTid	= "#LvarChk#"
				VerAsiento = "#isdefined("form.btnVer_Cierre")#"
			/>
	</cfloop>

	<cflocation url="OCtransporteCerrar.cfm">
<cfelseif isdefined("form.btnReabrir") OR isdefined("form.btnVer_Reapertura")>
	<cfif not isdefined("form.chk")>
		<cf_errorCode	code = "50443" msg = "No se han escogido Transportes a Reabrir">
	</cfif>

	<!--- Hay que hacer un loop con los Id's de los cheks de la lista --->
	<cfloop list="#form.chk#" index="LvarChk">
		<cfinvoke component="sif.oc.Componentes.OC_transito" 
				method="OC_Cierre_Transporte"

				Ecodigo = "#Session.Ecodigo#"
				OCTid	= "#LvarChk#"
				ReAbrir	= "true"
				VerAsiento = "#isdefined("form.btnVer_Reapertura")#"
			/>
	</cfloop>

	<cflocation url="OCtransporteReabrir.cfm">
</cfif>


