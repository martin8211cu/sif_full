<cfif isdefined('url.RHASid') and not isdefined('form.RHASid')>
	<cfset form.RHASid = url.RHASid>
</cfif>
<cfif isdefined('url.EEid') and not isdefined('form.EEid')>
	<cfset form.EEid = url.EEid>
</cfif>
<cfif isdefined('url.modo')>
	<cfset modo = url.modo>
</cfif>

<cfif modo EQ "CAMBIO">
	<cfquery name="rsDatosASalarial" datasource="#Session.DSN#">
		select  a.RHASid, a.Ecodigo, a.EEid, a.ETid, a.Eid, a.Mcodigo, a.NoSalario, a.RHASdescripcion, a.RHASref, a.RHASaplicar, a.RHASnumper, a.BMUsucodigo, 
				b.EEnombre, c.ETdescripcion, d.Edescripcion, e.Mnombre
		from RHASalarial a
			inner join EncuestaEmpresa b
				on b.EEid = a.EEid
			inner join EmpresaOrganizacion c
				on c.ETid = a.ETid
			inner join Encuesta d
				on d.Eid = a.Eid
			inner join Monedas e
				on e.Mcodigo = a.Mcodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
	</cfquery>
</cfif>

<cfoutput>
	<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">
	  <tr>
		<td width="1">
			<img border="0" src="/cfmx/rh/imagenes/number#Form.paso#_64.gif" align="absmiddle">
		</td>
		<td style="padding-left: 10px;" valign="top">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td style="border-bottom: 1px solid black " nowrap><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#titulo#</strong></td>
			  </tr>
			<cfif modo EQ "CAMBIO">
			  <tr>
			    <td class="tituloListas" align="left" nowrap>Modificando: <font color="##003399"><strong>#rsDatosASalarial.RHASdescripcion#</strong></font></td>
			  </tr>
			<cfelse>
				<cfif Form.paso EQ 0>
				  <tr>
					<td class="tituloListas" align="left" nowrap>Seleccione el reporte que desea modificar</td>
				  </tr>
				<cfelse>
				  <tr>
					<td class="tituloListas" align="left" nowrap>Configure los par&aacute;metros del nuevo reporte</td>
				  </tr>
			  	</cfif>
			</cfif>
			</table>
		</td>
	  </tr>
	</table>
</cfoutput>
