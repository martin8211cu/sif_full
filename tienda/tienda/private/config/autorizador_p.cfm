<cfparam name="form.ex" default="">
<cfparam name="form.autorizador" default="">
<cfparam name="form.comercio" default="">

<cfquery datasource="aspsecure" name="autorizador">
	select autorizador, nombre_autorizador, id_direccion
	from Autorizador
	where autorizador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(form.autorizador)#" null="#Len(Trim(form.autorizador)) Is 0#">
</cfquery>

<cfquery datasource="aspsecure" name="tarjetas">
	select tc_tipo
	from AutorizadorTipoTarjeta
	where autorizador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(form.autorizador)#" null="#Len(Trim(form.autorizador)) Is 0#">
	order by 1
</cfquery>

<cfquery datasource="aspsecure" name="comercio">
	select autorizador, comercio, moneda, id_direccion, comisionporc, comisionfija
	from ComercioAfiliado
	where autorizador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(form.autorizador)#" null="#Len(Trim(form.autorizador)) Is 0#">
	  and comercio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(form.comercio)#" null="#Len(Trim(form.comercio)) Is 0#">
</cfquery>

<cfquery datasource="aspsecure" name="autemp">
	select prioridad
	from AutorizadorEmpresa
	where autorizador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(form.autorizador)#" null="#Len(Trim(form.autorizador)) Is 0#">
	  and comercio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(form.comercio)#" null="#Len(Trim(form.comercio)) Is 0#">
	  and Ecodigosdc = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(session.EcodigoSDC)#" null="#Len(Trim(session.EcodigoSDC)) Is 0#">
</cfquery>

<cfquery datasource="aspsecure" name="cantidad">
	select max ( ae.prioridad ) as cantidad
	from AutorizadorEmpresa ae, ComercioAfiliado c, Autorizador a
	where ae.Ecodigosdc = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(session.EcodigoSDC)#" null="#Len(Trim(session.EcodigoSDC)) Is 0#">
	  and ae.autorizador = c.autorizador
	  and ae.comercio = c.comercio
	  and a.autorizador = ae.autorizador
	  and a.autorizador = c.autorizador
</cfquery>

<cfoutput><form name="form1" method="post" action="autorizador_go.cfm">
<input type="hidden" name="comercio" value="#comercio.comercio#">
<input type="hidden" name="autorizador" value="#autorizador.autorizador#">
  <table border="0" width="100%">
    <tr>
      <td class="tituloListas" colspan="2"><cfif autemp.RecordCount>Ver autorizador<cfelse>Afiliar autorizador</cfif></td>
      </tr>
    <tr>
      <td valign="top">Autorizador</td>
      <td valign="top">#autorizador.nombre_autorizador#</td>
    </tr>
    <tr>
      <td valign="top">Direcci&oacute;n</td>
      <td valign="top"><cf_direccion action="label" key="#autorizador.id_direccion#" title=""></td>
    </tr>
    <tr>
      <td valign="top">Moneda</td>
      <td valign="top">#comercio.moneda#</td>
    </tr>
    <tr>
      <td valign="top">Comisi&oacute;n</td>
      <td valign="top">#NumberFormat(comercio.comisionporc,'0.00')# %</td>
    </tr>
    <tr>
      <td valign="top">Comisi&oacute;n</td>
      <td valign="top">#comercio.moneda# #LSCurrencyFormat(comercio.comisionfija,'none')#</td>
    </tr>
    <tr>
      <td valign="top">Tarjetas aceptadas </td>
      <td valign="top">#ValueList(tarjetas.tc_tipo)#</td>
    </tr>
    <tr>
      <td valign="top">Prioridad</td>
      <td valign="top"><select name="prioridad" id="prioridad">
	  <cfloop from="1" to="#cantidad.cantidad + 1#" index="i">
		<option value="#i#" <cfif i is autemp.prioridad>selected</cfif>>#i#</option>
	  </cfloop>
      </select></td>
    </tr>
    <tr>
      <td colspan="2" valign="top">
	  <cfif autemp.RecordCount Is 0>
	    <input name="btnAdd" type="submit" id="btnAdd" value="Incluir autorizador">
	  <cfelse>
        <input name="btnDelete" type="submit" id="btnDelete" value="Excluir autorizador">
        <input name="btnUpdate" type="submit" id="btnUpdate" value="Actualizar prioridad"></td>
	  </cfif>
      </tr>
  </table>
</form></cfoutput>