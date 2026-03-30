<cfset exito = false>
<cfif isdefined("url.pkg_n")and len(trim(url.pkg_n))>
	<cfset exito = true>
	<cfquery name="rsLogines" datasource="#session.dsn#">
		select distinct a.LGlogin, b.SLpassword
		from ISBlogin a
		inner join ISBserviciosLogin b
			on b.LGnumero = a.LGnumero
		where a.Contratoid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.pkg_n#">
	</cfquery>
	<cfset mensaje='Se agregó con éxito el nuevo servicio:"#rsPaquete.PQnombre#"'>
<cfelse>
	<cfset mensaje='Error: no se agregó con éxito el nuevo servicio, por favor consulte con su agente.'>
</cfif>

<cfif Len(url.recargaok)>
	<cfif url.recargaok is 1>
		<cf_message text="El pago ha sido aceptado" type="information">
	<cfelse>
		<cf_message text="La transacción ha sido rechazada" type="error">
	</cfif>
</cfif>
<cfoutput>
	<form method="post" name="form1" action="gestion.cfm" onsubmit="return valida_continuar();">
		<cfinclude template="gestion-hiddens.cfm">
		<table cellpadding="4" cellspacing="4" width="100%" height="200">
			<tr><td align="center">
				
				<table cellpadding="0" cellspacing="0">
					
					<tr><td align="center" class="menuhead">#mensaje#</td></tr>
					
					<cfif exito>
					<tr><td>&nbsp;</td></tr>
					<tr><td align="center">
						<cf_web_portlet_start tipo="Box" width="70%">
						<table cellpadding="1" cellspacing="0" width="100%" class="cfmenu_menu">
							<tr><td width="50%"><label>Login</label></td><td width="50%" ><label>Clave</label></td></tr>
							<cfloop query="rsLogines">
							<tr><td>#rsLogines.LGlogin#</td><td>#rsLogines.SLpassword#</td></tr>
							</cfloop>
						</table>
						<cf_web_portlet_end>
					</td></tr>
					</cfif>
					
					<cfif exito>
					<tr><td>&nbsp;</td></tr>
					<tr><td align="center"><table cellpadding="0" cellspacing="0" width="70%"><tr>
						<td style="color:##FF0000; font-size:10px"><strong>IMPORTANTE:</strong> la clave que se asignada a cada login es provicional y es válida unicamente por un día, por lo que debe cambiar la clave del(os) login(es) en el plazo de un día. Gracias.</td>
					</tr></table></td></tr>
					
					</cfif>
					<tr><td>&nbsp;</td></tr>
					<td align="center"><cf_botones values="Aceptar" names="Aceptar"></td></tr>
					
				</table>
				
			</td></tr>
		</table>
		
	</form>
	<script language="javascript" type="text/javascript">
		function funcAceptar(){
			document.form1.adser.value = 1;
			document.form1.PQcodigo_n.value = "";
			return true;
		}
	</script>
</cfoutput>