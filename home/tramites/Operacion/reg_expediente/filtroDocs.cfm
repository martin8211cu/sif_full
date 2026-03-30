<cfquery name="rsDocum" datasource="#session.tramites.dsn#">
	select 	distinct t.id_tipo,
		   	d.nombre_documento
	from DDRegistro r	
		inner join DDCampo c
		on c.id_registro=r.id_registro
		
		inner join DDTipo t
		on t.id_tipo=r.id_tipo
		
		inner join TPDocumento d
		on d.id_tipo=t.id_tipo
			and d.es_tipoident = <cfqueryparam cfsqltype="cf_sql_bit" value="#modo_ident#">
	
	where r.id_persona =<cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_persona#">
	order by t.id_tipo
</cfquery>


<input type="hidden" name="tabexp" value="exp4">
<cfoutput>
<table width="100%"  border="0" cellspacing="0" cellpadding="5">
    <tr>
      <td align="right"><strong>Documento:</strong></td>
      <td><select name="id_tipo_F" id="id_tipo_F">
        <option value="-1">-- Todos --</option>
        <cfloop query="rsDocum">
          <option value="#rsDocum.id_tipo#" <cfif isdefined('form.id_tipo_F') and form.id_tipo_F EQ rsDocum.id_tipo> selected</cfif>>#rsDocum.nombre_documento#</option>
        </cfloop>
      </select></td>
      <td align="right" nowrap><strong>A partir de fecha:</strong></td>
      <td>
		<cfset fechadoc = ''>
		<cfif isdefined('form.BMfechamod_F') and form.BMfechamod_F NEQ ''>
			<cfset fechadoc = LSDateFormat(form.BMfechamod_F,'dd/mm/yyyy') >
		</cfif>
	  
	  	<cf_sifcalendario value="#fechadoc#" form="form3" name="BMfechamod_F">	 	  
	  </td>
    <td width="16%" align="center" valign="middle"><input name="btnFiltrarDocs" type="submit" id="btnFiltrarDocs2" value="Filtrar"></td>
    </tr>
</table>
</cfoutput>



