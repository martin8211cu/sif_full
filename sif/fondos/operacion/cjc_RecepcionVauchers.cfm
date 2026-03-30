<cfif isdefined("session.fondos.fondo") and len(trim(session.fondos.fondo)) GT 0 >
	<!---***************************************************** --->
	<!---**es necesario agregar estos templatearea ** --->
	<!---***************************************************** --->
	<cfset session.sitio.template = "/plantillas/Fondos/Plantilla.cfm">

	<cfif isdefined("url.RESPOSTEO")>
		<script language="JavaScript">
			Resultado = "<cfoutput>#url.RESPOSTEO#</cfoutput>"
			alert(Resultado)
		</script>
	</cfif>
	
	<!---**************************************** --->
	<!---**es necesario agrega este portlets   ** --->
	<!---**************************************** 
	<cfinclude template="../portlets/pNavegacionFT.cfm">--->
	<SCRIPT LANGUAGE='Javascript'  src="../../js/qForms/qforms.js"></SCRIPT>
	<script language="JavaScript1.2" type="text/javascript">
		qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
		qFormAPI.include("*");
	</SCRIPT>
	
<cf_templateheader title="Recepcion de Vouchers de Banco">	
	
	<cfif IsDefined("url.IDSESSION")>
		<cflocation url="../operacion/cjc_RecepcionVauchers.cfm">
	</cfif>
	<!--- *********************** --->
	<!---** AREA DE PINTADO    ** --->
	<!---************************ --->
	
	<table width="100%" border="0" >
		<tr>
			<td>													
				<cfinclude template="../operacion/cjc_formRecepcionVauchers.cfm">
			</td>
		</tr>
	</table>
	<!---***************************************************** --->
<cf_templatefooter>
<cfelse>
	<p>&nbsp;</p>
	<p>&nbsp;</p>
	<p>&nbsp;</p>
	<table width='380' border='0' height='115' align='center' cellpadding='5' cellspacing='8' bgcolor='#CCCCCC'> 
		<tr bgcolor='#006699'>
			<td>
				<div align='center'><b><font color='#FFFFFF' size='3'>
					El usuario <cfoutput>#session.usuario#</cfoutput> no tiene un fondo asociado o no es un encargado</font></b>
				</div>
			</td>
		</tr>
	</table>
</cfif>


