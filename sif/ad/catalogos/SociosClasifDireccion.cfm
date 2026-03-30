<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 03 de marzo del 2006
	Motivo: Dejar la consulta de las clases tomando solamente la tabla de clasificaciones de direcciones.
 --->
<cfquery datasource="#session.dsn#" name="clases">
	select e.SNCEid, e.SNCEcorporativo, 
		e.SNCEcodigo, e.SNCEdescripcion, e.PCCEobligatorio,
		d.SNCDid , d.SNCDvalor, d.SNCDdescripcion, 
		case when e.Ecodigo is null then 0 else 1 end as local,
		case when sn.SNCDid is null then 0 else 1 end as existe
	from SNClasificacionE e
		join SNClasificacionD d
			on d.SNCEid = e.SNCEid
		left outer join SNClasificacionSND sn
			on sn.SNCDid = d.SNCDid
			and sn.SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocios.SNid#">
			and sn.id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">
	where e.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and ( e.Ecodigo is null or e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
	  and e.PCCEactivo = 1
	 	  
	order by local, e.SNCEcodigo, e.SNCEdescripcion, e.SNCEid, 
		d.SNCDdescripcion 
</cfquery>


<cfquery datasource="#session.dsn#" name="rsDirecciones">
	select
		snd.id_direccion,
		snd.SNcodigo,
		snd.SNDcodigo,
		d.direccion1,
		case when snd.SNDfacturacion = 1 then 'X' else ' ' end as facturacion,
		case when snd.SNDenvio       = 1 then 'X' else ' ' end as envio,
		case when snd.SNDactivo      = 1 then 'X' else ' ' end as activo,
		snd.SNDlimiteFactura,
		{fn concat ( {fn concat ( {fn concat ( {fn concat ( 
		de.DEnombre , ' '  )}, de.DEapellido1  )}, ' '  )}, de.DEapellido2  )} as nombre
	from SNDirecciones snd
		left join DatosEmpleado de
			on de.DEid = snd.DEid
		join DireccionesSIF d
			on snd.id_direccion = d.id_direccion
	where snd.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and snd.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
	  and d.id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">
</cfquery>

<form action="SociosClasifDireccion_sql.cfm" method="post" style="margin:0 ">
<cfoutput>
	<input type="hidden" name="id_direccion" value="#HTMLEditFormat(form.id_direccion)#">
	<input type="hidden" name="SNid" value="#HTMLEditFormat(rsSocios.SNid)#">
	<input type="hidden" name="SNcodigo" value="#HTMLEditFormat(rsSocios.SNcodigo)#">
</cfoutput>
<!--- <cfdump var="#form#">
<cfdump var="#url#"> --->
<table align="center" border="0">
	<tr>
	  <td valign="middle" nowrap><div align="right"><strong>C&oacute;digo&nbsp;Direcci&oacute;n:</strong>&nbsp;&nbsp;</div></td>
	  <td valign="middle" nowrap colspan="3"><cfif modo NEQ 'ALTA'><cfoutput>#trim(rsform.SNDcodigo)#</cfoutput></cfif><cfif modo EQ 'ALTA'>#trim(rsSocios.SNnumero) & '-' & (rsConsecutivo.cuenta +1)#</cfif></td>
	</tr>
	<tr>
	  <td valign="middle" nowrap><div align="right"><strong>Direcci&oacute;n:</strong>&nbsp;</div></td>
	  <td valign="middle" nowrap colspan="3"><cfif modo NEQ 'ALTA'><cfoutput>#trim(rsDirecciones.direccion1)#</cfoutput></cfif></td>
	</tr>
	<tr align="left"><td colspan="4" align="right"><hr align="left" width="100%"></td></tr>
<cfoutput query="clases" group="local">
<tr><td colspan="4" class="tituloListas">
<cfif local>Clasificaciones locales<cfelse>Clasificaciones corporativas</cfif>
</td></tr>
<cfoutput group="SNCEid">
<tr>
  <td width="73">&nbsp;</td>
  <td width="247">#HTMLEditFormat(SNCEdescripcion)#</td>

<td width="55">&nbsp;</td>
  <td width="311"><select name="clax2" style="width:200px;" <cfif SNCEcorporativo And  session.Ecodigo neq session.Ecodigocorp and Len(session.Ecodigocorp)>disabled</cfif>>
<cfif PCCEobligatorio EQ 0>
<option value="">-Ninguno-</option>
</cfif>

<cfoutput>
<cfif existe or SNCEcorporativo EQ 0 or session.Ecodigo eq session.Ecodigocorp or not Len(session.Ecodigocorp ) >
<option value="#HTMLEditFormat(SNCDid)#" <cfif existe eq 1>selected</cfif>>#HTMLEditFormat(SNCDdescripcion)#</option>
</cfif>
</cfoutput>
</select></td>
</tr>
</cfoutput>
</cfoutput>
<cfif clases.RecordCount EQ 0>
<tr><td colspan="4">&nbsp;</td></tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr><td colspan="4" align="center" style="font-size:18px;"><a href="SNClasificaciones.cfm">No hay clasificaciones definidas.<br>Haga clic aqu&iacute; para definirlas.</a></td></tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr><td colspan="4">&nbsp;</td></tr>
<cfelse>
<tr><td colspan="4">&nbsp;</td></tr>
<tr><td colspan="4">
			<cf_botones names="Cambio" values="Modificar">
</td></tr>
</cfif>
</table>
</form>