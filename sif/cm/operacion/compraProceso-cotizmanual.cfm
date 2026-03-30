<!--- Pasa parámetros del url al form --->
<cfif (isdefined("url.ecid"))><cfset form.ecid = url.ecid></cfif>
<cfif (isdefined("url.btnnuevo"))><cfset form.btnnuevo = url.btnnuevo></cfif>
<cfif (isdefined("url.btnaplicar"))><cfset form.btnaplicar = url.btnaplicar></cfif>
<!--- Importa Cotizaciones de sif publica --->
<cfif isdefined("Form.btnAplicar")>
	<cfquery name="rsECotizacionesCM" datasource="#session.dsn#">
		select coalesce(a.ECtotal,0) as ECtotal, ECfechacot
		from ECotizacionesCM a
			inner join SNegocios b
				on b.SNcodigo = a.SNcodigo
				and b.Ecodigo = a.Ecodigo
			inner join CMCompradores c
				on c.CMCid = a.CMCid
				and c.Ecodigo = a.Ecodigo
		where a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.ProcesoCompra.CMPid#"> 
			and a.ECestado = 0
		order by ECfechacot
	</cfquery>
	<cfif isdefined("rsECotizacionesCM") and rsECotizacionesCM.RecordCount NEQ 0>
		<cfif rsECotizacionesCM.ECtotal EQ 0>
			<cf_errorCode	code = "50293" msg = " El Monto total de la Compra debe ser mayor que cero para aplicarlo!">
		<cfelse>
			<cfinclude template="compraProceso-cotizmanual-aplicar.cfm">
		</cfif>
	</cfif>
</cfif>
<table width="99%%" align="center" border="0" cellspacing="0" cellpadding="0"><tr><td>

<cfif isdefined("url.btnNuevo")>
	<cfset form.btnNuevo = url.btnNuevo>
</cfif>

<!---- Variable para indicar en el modo CAMBIO si se realiza la verificación por proveedor o no ----->
<cfset vnVerifica = 0>

<!--- Si es el modo cambio---->
<!----<cfif (isdefined("form.ecid") and len(trim(form.ecid))) or isdefined("form.btnNuevo")>	<!---or (isdefined("url.modo") and url.modo EQ 'CAMBIO')>---->----->
<cfif isdefined("form.btnNuevo")> 	
	<!--- Vista de una Cotización --->
	<cfif isdefined("url.opcion") and url.opcion EQ 0>
		<cfinclude template="compraProceso-cotizmanualProceso-form.cfm">
	<cfelseif isdefined("url.opcion") and url.opcion EQ 1>
		<cfinclude template="compraProceso-cotizmanual-form.cfm">
	</cfif>
	<!----<cfinclude template="compraProceso-cotizmanual-form.cfm">---->
<!--- Si se seleccionó el botón de cotización del proceso ---->
<cfelseif (isdefined("form.ecid") and len(trim(form.ecid)))>
	<cfinclude template="compraProceso-cotizmanualProceso-form.cfm">	
<cfelseif isdefined("form.btnNueva_cotizacion_del_proceso")>
	<cfinclude template="compraProceso-cotizmanualProceso-form.cfm">	
<!--- Si se seleccionó el botón de cotización del proveedor ----->
<cfelseif isdefined("form.btnNueva_cotizacion_proveedor")>	
	<cfinclude template="compraProceso-cotizmanual-form.cfm">
<cfelse>	
	<!--- Form para mantener la navegación --->
	<form name="form1" method="post" action="<cfoutput>#GetFileFromPath(GetTemplatePath())#</cfoutput>">
		<input type="hidden" name="opt" value="">
		<!---<input type="hidden" name="opcion" value="">--->
	</form>
	<!--- Lista de Cotizaciones --->
	<cfinclude template="compraProceso-cotizmanual-lista.cfm">
</cfif>

</td></tr></table>

<script language="javascript1.2" type="text/javascript">
function funcVerificar_Garantia_de_Proveedores()
{
   window.open('GarantiaDetalleP.cfm?CMPid=<cfif isdefined('form.CMPid') and len(trim(#form.CMPid#))><cfoutput>#form.CMPid#</cfoutput></cfif>','popup','width=1200,height=700,left=100,top=50,scrollbars=yes');<!---?CMPid='+LvarCMPid--->
}
</script>	


