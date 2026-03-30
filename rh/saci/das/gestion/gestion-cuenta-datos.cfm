<cfif ExisteCuenta>
	<cfquery name="rsCuenta" datasource="#session.DSN#">
		select a.CTid, a.Pquien, a.CUECUE, a.ECidEstado, a.CTapertura, a.CTdesde, a.CThasta, a.CTcobrable, 
			   a.CTrefComision, a.CCclaseCuenta, a.GCcodigo, a.CTmodificacion, a.CTpagaImpuestos, a.Habilitado, 
			   a.CTobservaciones, a.CTtipoUso, a.CTcomision, a.BMUsucodigo, a.ts_rversion
			   ,b.ECnombre
		from ISBcuenta a
		
			inner join ISBcuentaEstado b
			on b.ECidEstado = a.ECidEstado
		
		where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
		and a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente#">
	</cfquery>
	
	<cfquery name="rsPaquetes" datasource="#session.DSN#">
	select a.Contratoid,b.PQcodigo,b.PQnombre,b.PQdescripcion,e.TPdescripcion,e.TPinsercion,a.CNfechaRetiro,a.MRid,
		case
			when a.CNfechaRetiro is not null and a.MRid is not null then '<font color="##993300">Retirado</font>'
			when a.CTcondicion = '0' then '<font color="##FFCC00">Pendiente</font>'
			else
				'<font color="##009933">Activo</font>'
		end as estado_contrato
	from ISBproducto a
		inner join ISBpaquete b
			on b.PQcodigo = a.PQcodigo
		inner join ISBcuenta c
			on c.CTid = a.CTid
			and c.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente#">
		left outer join ISBtareaProgramada e
			on e.CTid = a.CTid
			and e.Contratoid = a.Contratoid 
			and TPestado = 'P'
			and TPtipo = 'CP'
	where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cue#">
	and a.CTcondicion not in ('C','X') <!--- Mientras el producto no esté en captura, pendiente de documentación y/o rechazado --->
	order by a.Contratoid
  </cfquery>
</cfif>
<cfoutput>	
<table width="100%"cellpadding="2" cellspacing="2" border="0">
	<tr class="tituloAlterno" align="center"><td colspan="4">Datos de la Cuenta</td></tr>
	
	<tr>
		<td align="right"><label>No. Cuenta</label></td>
		<td>
			<cfif ExisteCuenta and rsCuenta.CUECUE GT 0>#rsCuenta.CUECUE#<cfelseif rsCuenta.CTtipoUso EQ 'U'>&lt;Por Asignar&gt;<cfelseif rsCuenta.CTtipoUso EQ 'A'>(Acceso) &lt;Por Asignar&gt;<cfelseif rsCuenta.CTtipoUso EQ 'F'>(Facturaci&oacute;n) &lt;Por Asignar&gt;</cfif>
		</td>
		<td align="right"><label>Fecha de Apertura</label></td>
		<td>
			<cfset apertura = LSDateFormat(Now(), 'dd/mm/yyyy')>
			<cfif ExisteCuenta>
				<cfset apertura = LSDateFormat(rsCuenta.CTapertura, 'dd/mm/yyyy')>
			</cfif>
			#apertura#
		</td>
	</tr>
	<tr>
		<td align="right" valign="top"><label>Observaciones</label></td>
		<td colspan="3">
		<cfif ExisteCuenta>#HTMLEditFormat(Trim(rsCuenta.CTobservaciones))#</cfif>
		<!---<textarea name="CTobservaciones" id="CTobservaciones" rows="2" style="width: 100%" tabindex="1"><cfif ExisteCuenta>#HTMLEditFormat(Trim(rsCuenta.CTobservaciones))#</cfif></textarea>--->
		</td>
	</tr>
	<cfif ExisteCuenta and form.rol EQ "DAS">
	<tr><td colspan="4">
		<cf_web_portlet_start tipo="box" width="80%">
			<table cellpadding="0" cellspacing="0" border="0" align="center">
				<tr>
					<td class="menuhead" align="center" style="color:##FF0000">
						Estado:&nbsp; #rsCuenta.ECnombre#
					</td>
				</tr>
			</table>
		<cf_web_portlet_end> 
		</td>
	</tr>
	</cfif>
	<tr><td colspan="4"><hr /></td></tr>
	<tr class="tituloAlterno" align="center"><td colspan="4">Paquetes Asociados</td></tr>
	<tr><td colspan="4">	
		<table width="100%"cellpadding="2" cellspacing="0" border="0">
			<tr class="subTitulo">
				<td><strong>Nombre</strong></td>
				<td><strong>Descripci&oacute;n</strong></td>
				<td nowrap="nowrap"><strong>Estado Contrato</strong></td>
			</tr>
			<cfloop query="rsPaquetes">
			<tr>
				<td>#rsPaquetes.PQnombre#</td>
				<td>#rsPaquetes.PQdescripcion#</td>
				<td>#rsPaquetes.estado_contrato#</td>
			</tr>
			</cfloop>
		</table>
	</td></tr>
</table>
</cfoutput>
