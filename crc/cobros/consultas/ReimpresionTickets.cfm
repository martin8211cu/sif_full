<cfset LB_Title = "Reimpresion de Recibos de Pago">



<cfset numCuenta_Filtro = ''>
<cfset SN_Filtro = ''>
<cfset FInicio_Filtro = ''>
<cfset FFin_Filtro = ''>
<cfset type_Filtro = ''>

<cfif isDefined('form.BFiltrar')>
	<cfif isDefined('form.NUMCUENTA')>
		<cfset numCuenta_Filtro = "#form.NUMCUENTA#">
	</cfif>
	<cfif isDefined('form.FInicio')>
		<cfset FInicio_Filtro = "#form.FInicio#">
	</cfif>
	<cfif isDefined('form.FFin')>
		<cfset FFin_Filtro = "#form.FFin#">
	</cfif>
	<cfif isDefined('form.TipoCuenta')>
		<cfset type_Filtro = "#form.TipoCuenta#">
	</cfif>
	<cfif isDefined('form.SNid') && trim(form.SNid) neq ''>
		<cfset SN_Filtro = [form.SNid,form.SNnumero,form.SNnombre]>
	</cfif>
</cfif>

<cfoutput>
<cf_templateheader title="#LB_Title#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_Title#">
		<table width="75%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td>
					<cfinclude template="/home/menu/pNavegacion.cfm">
				</td>
			</tr>
			<tr>
				<td>
					<form name="formfiltro" action="ReimpresionTickets.cfm" method="POST">
						<table>
							<tr>
								<td colspan="2">
									Socio de Negocio:&nbsp;
									<cf_conlis
										Campos="SNid,SNnumero,SNnombre"
										Desplegables="N,S,S"
										Modificables="N,S,N"
										Size="0,10,30"
										tabindex="2"
										ValuesArray="#SN_Filtro#"
										Tabla="Snegocios"
										Columnas="SNid,SNnumero,SNnombre"
										form="formfiltro"
										Filtro="Ecodigo = #Session.Ecodigo# and (disT = 1 or TarjH = 1 or Mayor = 1)
												order by SNnombre"
										Desplegar="SNnumero,SNnombre"
										Etiquetas="Codigo, Nombre"
										filtrar_por="SNnumero,SNnombre"
										Formatos="S,S"
										Align="left,left"
										Asignar="SNid,SNnumero,SNnombre"
										Asignarformatos="S,S,S"/>
								</td>
								<td>&emsp;</td>
								<td>Numero de Cuenta:&nbsp;</td>
								<td>
									<input name="numCuenta" type="text" value="#numCuenta_Filtro#">
								</td>
								<td width="200px" align="right">
									<input type="submit" name="bFiltrar" value="   Filtrar" class="btnFiltrar" <!--- onclick="location.href='##';" --->>
								</td>
							</tr>
							<tr>
								<td>Inicio:&nbsp;<cf_sifcalendario form="formfiltro" name="FInicio" value="#FInicio_Filtro#"></td>
								<td>Fin:&nbsp;<cf_sifcalendario form="formfiltro" name="FFin" value="#FFin_Filtro#"></td>
								<td></td>
								<td>Tipo de Cuenta:&nbsp;</td>
								<td>
									<select name="tipoCuenta">
										<option value="" <cfif type_Filtro eq ''>selected</cfif>>Todos</option>
										<option value="D" <cfif type_Filtro eq 'D'>selected</cfif>>Distribuidor</option>
										<option value="TC" <cfif type_Filtro eq 'TC'>selected</cfif>>Tarjeta Credito</option>
										<option value="TM" <cfif type_Filtro eq 'TM'>selected</cfif>>Tarjeta Mayorista</option>
									</select>
								</td>
								<td width="200px" align="right">
									<input type="submit" name="bLimpiar" value="Limpiar" class="btnFiltrar" <!--- onclick="location.href='##';" --->>
								</td>
							</tr>
						</table>
					</form>
					<br><br>
				<td>
			</tr>
			<tr>
				<cfinclude  template="ReimpresionTickets_lista.cfm">
			</tr>
			<tr>
				<td>
					&nbsp;
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
</cfoutput>