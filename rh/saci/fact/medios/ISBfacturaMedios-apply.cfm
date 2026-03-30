<cfif IsDefined('form.btnReenviar')>
	<cfif IsDefined('form.chk') and Len(form.chk)>
		<cfloop list="#form.chk#" index="LFlote">
			<cfinvoke component="saci.comp.facturaMedios" method="enviarFactura"
				dsn="#session.dsn#" LFlote="#LFlote#" />
		</cfloop>
		<cflocation url="index.cfm?tab=fact&sentok=1">
	</cfif>
<cfelseif IsDefined('form.btnFacturar_Pendientes')>
	<cfinvoke component="saci.comp.facturaMedios" method="crearFactura"
		dsn="#session.dsn#"/>
</cfif>
<cflocation url="index.cfm?tab=fact">