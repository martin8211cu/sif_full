<cfif isdefined("Form.MEVid") and Len(Trim(Form.MEVid)) NEQ 0>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfif modo EQ 'CAMBIO'>
	<cfquery name="rsDatosActividad" datasource="#Session.DSN#">
		select datepart(hh, MEVinicio) as horainicio1,
			   datepart(mi, MEVinicio) as horainicio2,
			   datepart(hh, MEVfin) as horafin1,
			   datepart(mi, MEVfin) as horafin2,
			   convert(varchar, MEVfecha, 103) as MEVfecha,
			   MEVevento,
			   MEVdesc
		from MEEvento
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and MEVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MEVid#">
	</cfquery>

</cfif>

<cfoutput>
	<form name="form1" id="form1" action="actividades-sql.cfm" method="post" enctype="multipart/form-data">
		<cfif modo EQ 'CAMBIO'>
			<input type="hidden" name="MEVid" value="#Form.MEVid#">
		</cfif>
		<table cellpadding="2" cellspacing="0" width="95%" align="center">
		  <tr>
		    <td class="fileLabel" align="right" nowrap>Actividad o Evento:</td>
		    <td nowrap>
				<input name="MEVevento" type="text" id="MEVevento" size="60" maxlength="255" value="<cfif modo EQ 'CAMBIO'>#rsDatosActividad.MEVevento#</cfif>">
			</td>
	      </tr>
		  <tr>
		    <td class="fileLabel" align="right" nowrap>Descripci&oacute;n de la Actividad: </td>
		    <td nowrap>
				<textarea name="MEVdesc" id="MEVdesc" style="width: 100%" rows="6"><cfif modo EQ 'CAMBIO'>#rsDatosActividad.MEVdesc#</cfif></textarea>
			</td>
	      </tr>
		  <tr>
			<td align="right" nowrap><span class="fileLabel">Fecha de la Actividad:</span></td>
		    <td nowrap>
              <cfset fecha = LSDateFormat(Now(),'DD/MM/YYYY')>
              <cfif modo EQ 'CAMBIO'>
                <cfset fecha = rsDatosActividad.MEVfecha>
              </cfif>
              <cf_sifcalendario form="form1" value="#fecha#" name="MEVfecha"> 
			</td>
		  </tr>
		  <tr>
		    <td align="right" nowrap class="fileLabel">Hora de Inicio:</td>
		    <td nowrap>
					<select name="MEVinicio1" id="MEVinicio1">
					  <cfloop index="i" from="0" to="23">
						<option value="#i#"<cfif modo EQ 'CAMBIO' and rsDatosActividad.horainicio1 EQ i> selected</cfif>>#Iif(Len(i) EQ 1, DE("0" & i), DE(i))#</option>
					  </cfloop>
					</select>
					horas
					<select name="MEVinicio2" id="MEVinicio2">
					  <cfloop index="i" from="0" to="59">
						<option value="#i#"<cfif modo EQ 'CAMBIO' and rsDatosActividad.horainicio2 EQ i> selected</cfif>>#Iif(Len(i) EQ 1, DE("0" & i), DE(i))#</option>
					  </cfloop>
					</select>
					minutos
			</td>
	      </tr>
		  <tr>
		    <td align="right" nowrap><span class="fileLabel">Hora de Fin:</span></td>
		    <td nowrap>
					<select name="MEVfin1" id="MEVfin1">
					  <cfloop index="i" from="0" to="23">
						<option value="#i#"<cfif modo EQ 'CAMBIO' and rsDatosActividad.horafin1 EQ i> selected</cfif>>#Iif(Len(i) EQ 1, DE("0" & i), DE(i))#</option>
					  </cfloop>
					</select>
					horas
					<select name="MEVfin2" id="MEVfin2">
					  <cfloop index="i" from="0" to="59">
						<option value="#i#"<cfif modo EQ 'CAMBIO' and rsDatosActividad.horafin2 EQ i> selected</cfif>>#Iif(Len(i) EQ 1, DE("0" & i), DE(i))#</option>
					  </cfloop>
					</select>
					minutos
			</td>
	      </tr>
		  <tr>
		    <td align="right" nowrap>&nbsp;</td>
		    <td nowrap>&nbsp;</td>
	      </tr>
		  <tr>
		    <td colspan="2" align="center" nowrap>
				<cfif modo EQ 'ALTA'>
					<input type="submit" name="btnAgregar" value="Agregar">
				<cfelse>
					<input type="submit" name="btnCambiar" value="Modificar">
					<input type="submit" name="btnEliminar" value="Eliminar">
					<input type="submit" name="btnNuevo" value="Nuevo">
				</cfif>
			</td>
	      </tr>
		  <tr>
		    <td align="right" nowrap>&nbsp;</td>
		    <td nowrap>&nbsp;</td>
	      </tr>
		</table>
	</form>
	
</cfoutput>
