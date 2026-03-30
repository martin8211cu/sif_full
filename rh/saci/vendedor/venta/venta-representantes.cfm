
<!---<cfif rsDatosPersona.Ppersoneria EQ 'J'>--->


	<cfquery name="rsTiposIdent" datasource="#Session.DSN#">
		select a.Ppersoneria
		from ISBtipoPersona a
		where a.Pfisica = 1
	</cfquery>
	<cfset personerias = ValueList(rsTiposIdent.Ppersoneria, ',')>
	
	<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<cfif ExistePersona>
		  <tr>
			<td align="center" colspan="2" class="menuhead">
				#rsDatosPersona.Pid#&nbsp;&nbsp;#rsDatosPersona.NombreCompleto#
			</td>
		  </tr>
		</cfif>
		  <tr> 
			<td valign="top" width="40%" style="padding-right: 5px;"> 
				<cfinclude template="venta-representantes-lista.cfm">
			</td> 
			<td valign="top"> 
				<form name="form1" method="post" style="margin: 0;" action="venta-representantes-apply.cfm" onsubmit="javascript: return ValidarRepresentante(this);"><!---funcion que se encuentra en el tag de representante--->
					<input type="hidden" name="Pquien" value="<cfif isdefined("form.Pquien") and Len(Trim(form.Pquien))>#form.Pquien#<cfelseif isdefined("form.pq") and Len(Trim(form.pq))>#form.pq#</cfif>" />
					<input type="hidden" name="Pquien_Camb" value="<cfif isdefined("url.Pquien_CT") and Len(Trim(url.Pquien_CT))>#url.Pquien_CT#</cfif>" />
					
					<cfinclude template="venta-hiddens.cfm">
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr><td class="subTitulo" align="center">Datos del Contacto</td></tr>
						<tr>
							<td>
								<!--- Datos de la persona --->
								<cfset duenno = form.Pquien>
								<cfset representante = "">
								<cfif isdefined("url.Pquien_CT") and Len(Trim(url.Pquien_CT))>
									<cfset representante = url.Pquien_CT>
								</cfif>
								<cf_representante
									id_duena = "#duenno#"
									id_representante = "#representante#"
									form="form1"
									filtrarPersoneria = "#Trim(personerias)#"
									porFila = "true"
									sufijo = "_CT"
									personeria = "#rsDatosPersona.Ppersoneria#"
								>
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr><td align="center" width="100%">
							<cfif isdefined("url.Pquien_CT") and Len(Trim(url.Pquien_CT))>
								<cfset names = "Guardar,Eliminar,Nuevo">
								<cfset values = "Guardar,Eliminar,Nuevo">
							<cfelse>
								<cfset names = "Guardar,Nuevo">
								<cfset values = "Guardar,Nuevo">
							</cfif>
							<cf_botones names="#names#" values="#values#" tabindex="1">
						</td></tr>
					</table>
				</form>
			</td> 
		  </tr>
		</table>
	</cfoutput>
	<script type="text/javascript" language="javascript">
	<!--
		function funcNuevo() {
			tab_set_current('2');
			return false;
		}
	//-->
	</script>

<!---<cfelse>
	<cfoutput>
	<div style="height: 300">
	<form name="form1" method="post" style="margin: 0;" action="#CurrentPage#">
		<input type="hidden" name="Pquien" value="<cfif isdefined("form.Pquien") and Len(Trim(form.Pquien))>#form.Pquien#<cfelseif isdefined("form.pq") and Len(Trim(form.pq))>#form.pq#</cfif>" />
		<cfinclude template="venta-hiddens.cfm">
		<p align="center"><strong>Solamente se deben agregar representantes cuando el agente tiene personer&iacute;a jur&iacute;dica</strong></p>
	</form>
	</div>
	</cfoutput>
</cfif>
--->
