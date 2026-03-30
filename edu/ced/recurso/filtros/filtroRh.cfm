<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 24-1-2006.
		Motivo: Actualizar. Utilización del componente de listas, cf_botones, cf_qforms.
 --->

<form name="formFiltroListaPers" method="post" action="listaRH.cfm" style="margin:0">
	<input type="hidden" name="filtrado" value="<cfif isdefined('form.btnFiltrar') or isdefined('form.filtrado')>Filtrar</cfif>">
	<input type="hidden" name="sel" value="<cfif isdefined('form.sel') and form.sel NEQ 0><cfoutput>#form.sel#</cfoutput><cfelse>0</cfif>">				
	<table border="0" class="tituloListas" cellpadding="0" cellspacing="0" width="100%">
		<tr> 
			<td align="right">Nombre:&nbsp;</td>
			<td><input name="Filtro_RHnombre" type="text" id="Filtro_RHnombre" size="20" onFocus="this.select()" maxlength="80" value="<cfif isdefined("Form.Filtro_RHnombre") AND #Form.Filtro_RHnombre# NEQ "" ><cfoutput>#Form.Filtro_RHnombre#</cfoutput></cfif>"></td>
			<td align="right">Identificaci&oacute;n:&nbsp;</td>
			<td><input name="Filtro_RhPid" type="text" size="10" onFocus="this.select()" maxlength="60" value="<cfif isdefined("Form.Filtro_RhPid") AND #Form.Filtro_RhPid# NEQ "" ><cfoutput>#Form.Filtro_RhPid#</cfoutput></cfif>"></td>
			<td align="right">Tipo:&nbsp;</td>
			<td>
				<select name="Filtro_Tipo" tabindex="5">
					<option value="-1" <cfif isdefined('form.Filtro_Tipo') and form.Filtro_Tipo EQ '-1'>selected</cfif>>Todos</option>
					<option value="A" <cfif isdefined('form.Filtro_Tipo') and form.Filtro_Tipo EQ 'A'>selected</cfif>>Asistente</option>
					<option value="E" <cfif isdefined('form.Filtro_Tipo') and form.Filtro_Tipo EQ 'E'>selected</cfif>>Encargado</option>
					<option value="D" <cfif isdefined('form.Filtro_Tipo') and form.Filtro_Tipo EQ 'D'>selected</cfif>>Docente</option>
					<option value="DR" <cfif isdefined('form.Filtro_Tipo') and form.Filtro_Tipo EQ 'DR'>selected</cfif>>Director</option>
				</select>
		  	</td>
			<td align="right">Mail&nbsp;Principal:&nbsp;</td>
			<td><input name="Filtro_Pmail1" type="text" size="10" onFocus="this.select()" maxlength="30" value="<cfif isdefined("Form.Filtro_Pmail1") AND #Form.Filtro_Pmail1# NEQ "" ><cfoutput>#Form.Filtro_Pmail1#</cfoutput></cfif>"></td>
		</tr>
		<tr>
			<td align="right">Teléfono&nbsp;Casa:&nbsp;</td>
			<td><input name="Filtro_Pcasa" type="text" id="Filtro_Pcasa" size="10" onFocus="this.select()" maxlength="30" value="<cfif isdefined("Form.Filtro_Pcasa") AND #Form.Filtro_Pcasa# NEQ "" ><cfoutput>#Form.Filtro_Pcasa#</cfoutput></cfif>"></td>
			<td align="right">Teléfono&nbsp;Oficina:&nbsp;</td>
			<td><input name="Filtro_Poficina" type="text" size="10" onFocus="this.select()" maxlength="30" value="<cfif isdefined("Form.Filtro_Poficina") AND Form.Filtro_Poficina NEQ "" ><cfoutput>#Form.Filtro_Poficina#</cfoutput></cfif>"></td>
			<td align="right">Teléfono&nbsp;Celular:&nbsp;</td>
			<td><input name="Filtro_Pcelular" type="text" size="11" onFocus="this.select()" maxlength="30" value="<cfif isdefined("Form.Filtro_Pcelular") AND #Form.Filtro_Pcelular# NEQ "" ><cfoutput>#Form.Filtro_Pcelular#</cfoutput></cfif>"></td>
			<td align="right">Mail&nbsp;Secundario:&nbsp;</td>
			<td><input name="Filtro_Pmail2" type="text" size="10" onFocus="this.select()" maxlength="30" value="<cfif isdefined("Form.Filtro_Pmail2") AND #Form.Filtro_Pmail2# NEQ "" ><cfoutput>#Form.Filtro_Pmail2#</cfoutput></cfif>"></td>
		</tr>
		<tr>
			<td align="right">Teléfono&nbsp;Pager:&nbsp;</td>
			<td><input name="Filtro_Pagertel" type="text" id="Filtro_Pagertel" size="10" onFocus="this.select()" maxlength="30" value="<cfif isdefined("Form.Filtro_Pagertel") AND #Form.Filtro_Pagertel# NEQ "" ><cfoutput>#Form.Filtro_Pagertel#</cfoutput></cfif>"></td>
			<td align="right">Número&nbsp;Pager:&nbsp;</td>
			<td><input name="Filtro_Pagernum" type="text" size="10" onFocus="this.select()" maxlength="30" value="<cfif isdefined("Form.Filtro_Pagernum") AND #Form.Filtro_Pagernum# NEQ "" ><cfoutput>#Form.Filtro_Pagernum#</cfoutput></cfif>"></td>
			<td align="right">Fax:&nbsp;</td>
			<td><input name="Filtro_Pfax" type="text" size="11" onFocus="this.select()" maxlength="30" value="<cfif isdefined("Form.Filtro_Pfax") AND #Form.Filtro_Pfax# NEQ "" ><cfoutput>#Form.Filtro_Pfax#</cfoutput></cfif>"></td>
			<td colspan="2"><cf_botones values="Filtrar"></td>
		</tr>
		<tr><td colspan="8">&nbsp;</td></tr>
  </table>
</form>