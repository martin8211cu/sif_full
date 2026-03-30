<cfif ExisteCuenta>
	<cfif form.csub>
		<!---<cfinclude template="/saci/das/gestion/gestion-cobro-cambio.cfm">--->
	<cfelse> 
		<cfoutput>
			<form name="form2" action="#CurrentPage#" style="margin:0" method="post">
				<cfinclude template="gestion-hiddens.cfm">
				<table width="100%"cellpadding="0" cellspacing="0" border="0">
					<tr class="tituloAlterno" align="center"><td>Forma de Cobro Actual</td></tr>
					<!----Pinta la cuenta en solo lectura---->
					<tr><td>
						<cf_cuenta 
							id = "#Form.CTid#"
							idpersona = "#Form.cliente#"
							filtroAgente = ""
							form = "form2"
							Ecodigo = "#Session.Ecodigo#"
							Conexion = "#Session.DSN#"
							paso = "3"
							readOnly = "true"
							porfila="true"
						>
					</td></tr>
					<!---<tr><td> <cf_botones names="Cambiar" values="Cambiar"></td></tr>--->
				</table>
			</form>
			<script language="javascript" type="text/javascript">
				function funcCambiar(){
					document.form2.csub.value=true;
				}
			</script>
		</cfoutput>
	</cfif>
</cfif>