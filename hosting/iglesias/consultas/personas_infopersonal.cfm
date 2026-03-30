<cfquery name="rsMEPersona" datasource="#Session.DSN#">
	select Pnombre, Papellido1, Papellido2, Pdireccion, Pdireccion2, Pciudad, Pprovincia, PcodPostal, 
			Pnacimiento, Psexo, Poficina, Pcasa, Pcelular, Pfax, Pemail1, 
			Ppais = isnull(Ppais, '-1'), MEOid = isnull(MEOid,-1)
			from MEPersona
	where MEpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MEpersona#">
</cfquery>
<cfoutput>
<fieldset><legend>Datos Generales</legend>
<table cellpadding="2" cellspacing="0" align="center">
  <tr>
	<td rowspan="16" align="center">&nbsp;</td>
  <tr>
	<th width="1%" align="left" nowrap class="formatoFont"><strong>Nombre:&nbsp;</strong></th>
	<td class="formatoFont2" nowrap><div align="left">#rsMEPersona.Pnombre#&nbsp;#rsMEPersona.Papellido1#&nbsp;#rsMEPersona.Papellido2#</div></td>
  <tr>
	<th align="left" valign="top" nowrap class="formatoFont"><strong>Direcci&oacute;n 1:&nbsp;</strong></th>
	<td class="formatoFont2" nowrap>
		<div align="left">#rsMEPersona.Pdireccion#
	      </div></td>
  </tr>
  <tr>
	<th align="left" valign="top" nowrap class="formatoFont"><strong>Direcci&oacute;n 2:&nbsp; </strong></th>
	<td class="formatoFont2" nowrap>
		<div align="left">#rsMEPersona.Pdireccion2#
	      </div></td>
  </tr>
  <tr>
	<th align="left" nowrap class="formatoFont"><strong>Ciudad:</strong></th>
	<td class="formatoFont2" nowrap>
		<div align="left">#rsMEPersona.Pciudad#
	      </div></td>
  </tr>
  <tr>
	<th align="left" nowrap class="formatoFont"><strong>Estado:&nbsp;</strong></th>
	<td class="formatoFont2" nowrap>
		<div align="left">#rsMEPersona.Pprovincia#
	      </div></td>
  </tr>
  <tr>
	<th align="left" nowrap class="formatoFont"><strong>C&oacute;digo Postal: </strong></th>
	<td class="formatoFont2" nowrap>
		<div align="left">#rsMEPersona.PcodPostal#
	      </div></td>
  </tr>
  <tr>
	<th align="left" nowrap class="formatoFont"><strong>Pa&iacute;s:&nbsp;</strong></th>
	<td class="formatoFont2" nowrap>
		<div align="left">
		  <cfquery name="rsPais" datasource="asp">
			  select Pnombre
			  from Pais
			  where Ppais = 
			  <cfqueryparam cfsqltype="cf_sql_char" value="#rsMEPersona.Ppais#">
		  </cfquery>
	  <cfif rsPais.RecordCount gt 0>#rsMEPersona.Ppais#&nbsp;-&nbsp;#rsPais.Pnombre#</cfif></div></td>
  </tr>
  <tr>
	<th align="left" nowrap class="formatoFont"><strong>Nacimiento:&nbsp;</strong></th>
	<td class="formatoFont2" align="left" nowrap>
		<div align="left">#rsMEPersona.Pnacimiento#
      </div></td>
  </tr>
  <tr>
	<th align="left" nowrap class="formatoFont"><strong>Sexo:&nbsp; </strong></th>
	<td class="formatoFont2" align="left" nowrap>
	  <div align="left">
	    <cfif rsMEPersona.Psexo EQ 'M'>
    Masculino
      <cfelse>
    Femenino
	      </cfif>
	    </div></td>
</tr>
  <tr>
	<th align="left" nowrap class="formatoFont"><strong>Profesi&oacute;n:</strong></th>
	<td class="formatoFont2" nowrap>
		<div align="left">
		  <cfquery name="rsOcupacion" datasource="#Session.DSN#">
			  select MEOnombre
			  from MEOcupacion
			  where MEOid = 
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMEPersona.MEOid#">
		  </cfquery>
		  #rsOcupacion.MEOnombre#
      </div></td>
  </tr>
  <tr>
	<th align="left" nowrap class="formatoFont"><strong>Tel. Diurno: </strong></th>
	<td class="formatoFont2" nowrap> <div align="left">#rsMEPersona.Poficina# </div></td>
</tr>
  <tr>
	<th align="left" nowrap class="formatoFont"><strong>Tel. Nocturno:&nbsp;</strong></th>
	<td class="formatoFont2" nowrap> <div align="left">#rsMEPersona.Pcasa# </div></td>
</tr>
  <tr>
	<th align="left" nowrap class="formatoFont"><strong>Tel. Celular:&nbsp;</strong></th>
	<td class="formatoFont2" nowrap> <div align="left">#rsMEPersona.Pcelular# </div></td>
</tr>
  <tr>
	<th align="left" nowrap class="formatoFont"><strong>Fax:&nbsp; </strong></th>
	<td class="formatoFont2" nowrap> <div align="left">#rsMEPersona.Pfax# </div></td>
</tr>
  <tr>
	<th align="left" nowrap class="formatoFont"><strong>E-mail:</strong></th>
	<td class="formatoFont2" nowrap>
		<div align="left">#rsMEPersona.Pemail1#
      </div></td>
  </tr>
  <tr>
	<td colspan="3">&nbsp;</td>
  </tr>
</table>
</fieldset>
</cfoutput>