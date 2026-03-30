<cfif ExisteCliente>
	<cfquery name="rsTipoPersoneria" datasource="#Session.DSN#">
		select Ppersoneria from ISBpersona 
		where Pquien=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cli#">
	</cfquery>
	
	<!---<cfif rsTipoPersoneria.Ppersoneria EQ 'J'>--->
	
		<cfquery name="rsTiposIdent" datasource="#Session.DSN#">
			select a.Ppersoneria
			from ISBtipoPersona a
			where a.Pfisica = 1
		</cfquery>
		<cfset personerias = ValueList(rsTiposIdent.Ppersoneria, ',')>
		<cfoutput>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			
			  <tr> 
				<cfif not isdefined("url.Pquien_CT") and not isdefined("url.Nuevo")>
					<td valign="top" width="50%"> <!--- style="padding-right: 5px;"--->
						<cfset form.Pquien=form.cli>
						<cfinclude template="gestion-representante-lista.cfm">
					</td> 
				<cfelse>
					<td valign="top" width="50%"> 
						<form name="form1" method="post" style="margin: 0;" action="gestion-representantes-apply.cfm" onSubmit="javascript: return ValidarRepresentante(this);"><!---funcion que se encuentra en el tag de representante--->
							<input type="hidden" name="Pquien" value="#form.cli#"/>
							<input type="hidden" name="Pquien_Camb" value="<cfif isdefined("url.Pquien_CT") and Len(Trim(url.Pquien_CT))>#url.Pquien_CT#</cfif>" />
							
							<cfinclude template="gestion-hiddens.cfm">
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr><td class="subTitulo" align="center">Datos del Contacto</td></tr>
								<tr>
									<td>
										<!--- Datos de la persona --->
										<cfset duenno = form.cli>
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
											personeria = "#rsTipoPersoneria.Ppersoneria#"
										>
									</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
								</tr>
								<tr><td align="center" width="100%">
									<cfif Len(Trim(representante))>
										<cfset names = "Regresar,Guardar,Eliminar,Nuevo">
										<cfset values = "Regresar,Guardar,Eliminar,Nuevo">
									<cfelse>
										<cfset names = "Regresar,Guardar,Nuevo">
										<cfset values = "Regresar,Guardar,Nuevo">
									</cfif>
									<cf_botones names="#names#" values="#values#" tabindex="1">
								</td></tr>
							</table>
						</form>
					</td> 
				</cfif>
			  </tr>
			</table>
		</cfoutput>
		
		<script type="text/javascript" language="javascript">
		<!--
			function funcNuevo() {
				tab_set_current('2', document.form1);
				return false;
			}
			
			function funcRegresar() {
				tab_set_current('2', document.form1);
				return false;
			}
			
			function funcFiltrar() {
				document.form1.botonSel.value='Filtrar';
				
				//envia los filtros y la pagina
				var extraParams = 'PageNum=' +  document.form1.PageNum.value;
				if( document.form1.filtro_Pnombre_CT.value != ""){
					extraParams = extraParams + '&filtro_Pnombre_CT=' + document.form1.filtro_Pnombre_CT.value + '&hfiltro_Pnombre_CT=' + document.form1.filtro_Pnombre_CT.value;
				}
				if(document.form1.filtro_Pid_CT.value != ""){
					extraParams = extraParams + '&filtro_Pid_CT=' + document.form1.filtro_Pid_CT.value + '&hfiltro_Pid_CT=' + document.form1.filtro_Pid_CT.value;
				}
				
				tab_set_current('2', document.form1,extraParams);
				return false ;
			}
		//-->
		</script>
	
	<!---<cfelse>
		<cfoutput>
		<div style="height: 300">
		<form name="form1" method="post" style="margin: 0;" action="#CurrentPage#">
			<input type="hidden" name="Pquien" value="#form.cli#" />
			<cfinclude template="gestion-hiddens.cfm">
			<p align="center"><strong>Solamente se deben agregar representantes cuando la personer&iacute;a es jur&iacute;dica</strong></p>
		</form>
		</div>
		</cfoutput>
	</cfif>--->
</cfif>