<cfif isDefined('session.idTransaccion') and session.idTransaccion neq "">
	<cfquery datasource="#session.dsn#">
		delete TESDatosOPImportador where IdTransaccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.idTransaccion#">
	</cfquery>
</cfif>
<cfif isDefined('url.Completado') and url.Completado eq "OK">
	<cfinvoke component="home.Componentes.Notifier" method="insertFlashMeesage"
   		message="Ordenes de Pago aplicadas correctamente"
	   	type="sucess"
   		closeOnClick="true">
	</cfinvoke>
</cfif>
<cfset session.idTransaccion ="">
<cfset session.HashB = "">
<cfset session.IdBitacora = 0>
<cfset url.Completado = "">

<cf_templateheader title="Importaci&oacute;n de Ordenes de Pago">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importaci&oacute;n de Ordenes de Pago">
<table width="100%" border="0" cellspacing="1" cellpadding="1">
  <tr>
	<td valign="top" width="60%">
		<cf_sifFormatoArchivoImpr EIcodigo = 'IMORDPAGO'>
	</td>
	<td align="center" style="padding-left: 15px " valign="top">
		<cf_sifimportar EIcodigo="IMORDPAGO" mode="in" />
	</td>
  </tr>
	<tr>
		<td colspan="3" align="center">
			<input type="submit" name="Ver Registros" value="Ver Registros" onSubmit="" onClick="validaEnviar()">
		</td>
	</tr>
	<tr>
		<td colspan="3" align="center">&nbsp;</td>
	</tr>
	<input type="hidden" name="status" id="status">
</table>
	<cf_web_portlet_end>
<cf_templatefooter>
<script type="text/javascript">

	function validaEnviar()
	{
		var status = document.getElementById("status");

		<cfoutput>
			<cfif not isDefined('session.idTransaccion')>
				alert('No se ha cargado ningun archivo');
				return false;
			</cfif>
		</cfoutput>
		validaContenidoXAjax();
	}

	function validaContenidoXAjax()
	{
		var status = document.getElementById("status");
		$.ajax({
			type: "POST",
			url: "ajaxValidaOCImportador.cfc?method=ValidaContenido",
			success: function(obj)
			{
				var opts = $.parseJSON(obj);
				if(opts[0] == 1)
				{
					status.value = "SI";
					document.location = 'OrdenesPagoCargadas_form.cfm';
				}
				else
				{
					status.value = "NO";
					if(opts[1] == '')
					{
						alert(opts[2]);
					}
					else
					{
						alert(opts[1]);
					}
				}
			},
	        error: function(XMLHttpRequest, textStatus, errorThrown)
	        {
	        	alert("Ocurrio error");
	        	alert(errorThrown+' '+textStatus+' '+errorThrown);
	       }
		});
	}
</script>