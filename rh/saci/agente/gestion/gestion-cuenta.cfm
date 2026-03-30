<cfif ExisteCuenta>
	
	<cfquery name="rsCuenta" datasource="#session.DSN#">
		select a.CTid, a.Pquien, a.CUECUE, a.ECidEstado, a.CTapertura, a.CTdesde, a.CThasta, a.CTcobrable, 
			   a.CTrefComision, a.CCclaseCuenta, a.GCcodigo, a.CTmodificacion, a.CTpagaImpuestos, a.Habilitado, 
			   a.CTobservaciones, a.CTtipoUso, a.CTcomision, a.BMUsucodigo, a.ts_rversion
		from ISBcuenta a
		where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
		and a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente#">
	</cfquery>
	
	<cfquery name="rsPaquetes" datasource="#session.DSN#">
	select a.Contratoid,b.PQcodigo,b.PQnombre,b.PQdescripcion,e.TPdescripcion,e.TPinsercion  
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
	and a.CTcondicion not in ('C','0','X') <!--- Mientras el producto no esté en captura, pendiente de documentación y/o rechazado --->
	order by a.Contratoid
  </cfquery>
</cfif>

<cfoutput>
<table width="100%"cellpadding="0" cellspacing="0" border="0">
  <tr class="tituloAlterno" align="center"><td colspan="4">Datos de la Cuenta</td></tr>

  <tr>
	<td width="15%" align="left">No. Cuenta</td>
	<td>
		<cfif ExisteCuenta and rsCuenta.CUECUE GT 0>#rsCuenta.CUECUE#<cfelseif rsCuenta.CTtipoUso EQ 'U'>&lt;Por Asignar&gt;<cfelseif rsCuenta.CTtipoUso EQ 'A'>(Acceso) &lt;Por Asignar&gt;<cfelseif rsCuenta.CTtipoUso EQ 'F'>(Facturaci&oacute;n) &lt;Por Asignar&gt;</cfif>
	</td>
	<td align="left">Fecha de Apertura</td>
	<td>
		<cfset apertura = LSDateFormat(Now(), 'dd/mm/yyyy')>
		<cfif ExisteCuenta>
			<cfset apertura = LSDateFormat(rsCuenta.CTapertura, 'dd/mm/yyyy')>
		</cfif>
		<input type="hidden" name="CTapertura" value="#apertura#" />
		#apertura#
	</td>
  </tr>
  <tr>
	<td align="left" valign="top" nowrap>Observaciones</td>
	<td colspan="3">
		<cfif ExisteCuenta>#HTMLEditFormat(Trim(rsCuenta.CTobservaciones))#</cfif>
		<!---<textarea name="CTobservaciones" id="CTobservaciones" rows="2" style="width: 100%" tabindex="1"><cfif ExisteCuenta>#HTMLEditFormat(Trim(rsCuenta.CTobservaciones))#</cfif></textarea>--->
	</td>
  </tr>
 <tr><td colspan="4"><hr /></td></tr>
  <tr class="tituloAlterno" align="center"><td colspan="4">Paquetes Asociados</td></tr>
  <tr><td colspan="4">	
	<table width="100%"cellpadding="2" cellspacing="0" border="0">
	  <tr class="tituloAlterno">
		<td><strong>C&oacute;digo</strong></td>
		<td><strong>Nombre</strong></td>
		<td><strong>Descripci&oacute;n</strong></td>
	  </tr>
	  <cfloop query="rsPaquetes">
	  <tr>
		<td>#rsPaquetes.PQcodigo#</td>
		<td>#rsPaquetes.PQnombre#</td>
		<td>#rsPaquetes.PQdescripcion#</td>
	  </tr>
	  </cfloop>
	</table>
 </td></tr>
 <tr><td colspan="4"><hr /></td></tr>
  <tr class="tituloAlterno" align="center"><td colspan="4">Tarea Programada por Paquete</td></tr>
  <tr><td colspan="4">
  	<table width="100%"cellpadding="2" cellspacing="0" border="0">
	  <tr class="tituloAlterno">
		<td><strong>Paquete</strong></td>
		<td><strong>Descripci&oacute;n</strong></td>
		<td><strong>Fecha Generada</strong></td>
	  </tr>
	  <cfloop query="rsPaquetes">
	  <tr>
		<td>#rsPaquetes.PQcodigo#-#rsPaquetes.PQnombre#</td>
		<td>#rsPaquetes.TPdescripcion#</td>
		<td>#LSDateFormat(rsPaquetes.TPinsercion, 'dd/mm/yyyy')#</td>
	  </tr>
	  </cfloop>
	</table>
  </td></tr>
</table>
</cfoutput>