<cfif rsDatosPersona.Ppersoneria EQ 'J'>

	<cfquery name="rsTiposIdent" datasource="#Session.DSN#">
		select a.Ppersoneria
		from ISBtipoPersona a
		where a.Pfisica = 1
	</cfquery>
	<cfset personerias = ValueList(rsTiposIdent.Ppersoneria, ',')>
	
	<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<cfif ExisteVendedor>
		  <tr>
			<td align="center" colspan="2" class="menuhead">
				#rsDatosPersona.Pid#&nbsp;&nbsp;#rsDatosPersona.NombreCompleto#
			</td>
		  </tr>
		</cfif>
		  <tr> 
			<td valign="top" width="40%" style="padding-right: 5px;"> 
				<cfinclude template="vendedor-representantes-lista.cfm">
			</td> 
			<td valign="top"> 
				<form name="form1" method="post" style="margin: 0;" action="vendedor-representantes-apply.cfm" onsubmit="javascript: return validar(this);">
					<input type="hidden" name="Vid" value="<cfif isdefined("form.Vid") and Len(Trim(form.Vid))>#form.Vid#<cfelseif isdefined("form.ven") and Len(Trim(form.ven))>#form.ven#</cfif>" />
					<input type="hidden" name="Pquien" value="<cfif isdefined("form.Pquien") and Len(Trim(form.Pquien))>#form.Pquien#<cfelseif isdefined("form.pq") and Len(Trim(form.pq))>#form.pq#</cfif>" />
					<cfinclude template="vendedor-hiddens.cfm">
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr><td class="subTitulo" align="center">Datos del Representante</td></tr>
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
								>
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr><td align="center" width="100%">
							<cfset names = "Guardar">
							<cfset values = "Guardar">
							<cfif Len(Trim(representante))>
								<cfset names = names & ",Eliminar">
								<cfset values = values & ",Eliminar">
							</cfif>
							<cfset names = names & ",Nuevo,Lista">
							<cfset values = values & ",Nuevo,Lista Agentes">
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
	
		function validar(formulario) {
			return ValidarRepresentante(formulario);//esta funcion se encuentra dentro del tag de representante
		}
	//-->
	</script>

<cfelse>
	<cfoutput>
	<div style="height: 300">
	<form name="form1" method="post" style="margin: 0;" action="#CurrentPage#">
		<cfinclude template="vendedor-hiddens.cfm">
		<input type="hidden" name="Vid" value="<cfif isdefined("form.Vid") and Len(Trim(form.Vid))>#form.Vid#<cfelseif isdefined("form.ven") and Len(Trim(form.ven))>#form.ven#</cfif>" />
		<p align="center"><strong>Solamente se deben agregar representantes cuando el agente tiene personer&iacute;a jur&iacute;dica</strong></p>
	</form>
	</div>
	</cfoutput>
</cfif>