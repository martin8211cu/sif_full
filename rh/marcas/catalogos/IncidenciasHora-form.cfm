<cfif isdefined("Form.RHIHid")>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfif modo EQ "CAMBIO">
	<cfquery name="rsIncidenciaHora" datasource="#Session.DSN#">
		select a.RHIHid, a.CIid, 
			   case when datepart(hh, a.RHIHhinicio) > 12 then datepart(hh, a.RHIHhinicio) - 12 when datepart(hh, a.RHIHhinicio) = 0 then 12 else datepart(hh, a.RHIHhinicio) end as hinicio,
			   datepart(mi, a.RHIHhinicio) as minicio,
			   case when datepart(hh, a.RHIHhinicio) < 12 then 'AM' else 'PM' end as tinicio,
			   case when datepart(hh, a.RHIHhfinal) > 12 then datepart(hh, a.RHIHhfinal) - 12 when datepart(hh, a.RHIHhfinal) = 0 then 12 else datepart(hh, a.RHIHhfinal) end as hfinal,
			   datepart(mi, a.RHIHhfinal) as mfinal,
			   case when datepart(hh, a.RHIHhfinal) < 12 then 'AM' else 'PM' end as tfinal,
			   a.RHIHfrige, a.RHIHfhasta, a.ts_rversion,
			   b.CIid, b.CIcodigo, b.CIdescripcion
		from RHIncidenciasHora a, CIncidentes b
		where a.RHIHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHIHid#">
		and a.CIid = b.CIid
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
</cfif>
<SCRIPT language="javascript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="javascript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>	

  	<cfoutput>
<table width="100%" border="0">
<tr>
  <td colspan="2">&nbsp;</td>
</tr>
<tr>
  <td valign="top" width="50%">
	<cfinvoke 
	 component="rh.Componentes.pListas"
	 method="pListaRH"
	 returnvariable="pListaRet">
		<cfinvokeargument name="tabla" value="CIncidentes a, RHIncidenciasHora b"/>
		<cfinvokeargument name="columnas" value="b.RHIHid, a.CIdescripcion, b.RHIHfrige, b.RHIHfhasta, b.RHIHhinicio, b.RHIHhfinal"/>
		<cfinvokeargument name="desplegar" value="CIdescripcion, RHIHfrige, RHIHfhasta, RHIHhinicio, RHIHhfinal"/>
		<cfinvokeargument name="etiquetas" value="#vConcepto#, #vFechaRige#, #vFechaVence#, #vHoraInicio#, #vHoraFin#"/>
		<cfinvokeargument name="formatos" value="V, D, D, H, H"/>
		<cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo#
											   and a.CIid = b.CIid
											   order by b.RHIHhinicio, b.RHIHhfinal, b.RHIHfhasta desc, b.RHIHfrige desc"/>
		<cfinvokeargument name="align" value="left, center, center, center, center"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="checkboxes" value="N"/>
		<cfinvokeargument name="keys" value="RHIHid"/>
		<cfinvokeargument name="irA" value="IncidenciasHora.cfm"/>
		<cfinvokeargument name="maxRows" value="20"/>
	</cfinvoke>
  </td>
  <td valign="top" width="50%">
	<form name="form1" method="post" action="IncidenciasHora-SQL.cfm">
		<cfif modo EQ "CAMBIO">
			<input type="hidden" name="RHIHid" value="#rsIncidenciaHora.RHIHid#">
			<input type="hidden" name="PageNum" value="#Form.PageNum#">
		</cfif>
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  <tr>
		    <td class="fileLabel" align="right" nowrap>#vConcepto#: </td>
		    <td nowrap>
				  <cfif modo EQ "CAMBIO">
					<cf_rhCIncidentes query="#rsIncidenciaHora#" IncluirTipo="0">
				  <cfelse>
					<cf_rhCIncidentes IncluirTipo="0">
				  </cfif>			
			</td>
		    </tr>
		  <tr>
		    <td class="fileLabel" align="right" nowrap>#vFechaRige#: </td>
		    <td nowrap>
				<cfif modo EQ "CAMBIO">
					<cfset frige = LSDateFormat(rsIncidenciaHora.RHIHfrige, 'dd/mm/yyyy')>
				<cfelse>
					<cfset frige = "">
				</cfif>
				<cf_sifcalendario form="form1" name="RHIHfrige" value="#frige#">
			</td>
	      </tr>
		  <tr>
		    <td class="fileLabel" align="right" nowrap>#vFechaVence#: </td>
		    <td nowrap>
				<cfif modo EQ "CAMBIO">
					<cfset fvence = LSDateFormat(rsIncidenciaHora.RHIHfhasta, 'dd/mm/yyyy')>
				<cfelse>
					<cfset fvence = "">
				</cfif>
				<cf_sifcalendario form="form1" name="RHIHfhasta" value="#fvence#">
			</td>
	      </tr>
		  <tr>
			<td class="fileLabel" align="right" nowrap>#vHoraInicio#: </td>
			<td nowrap>
				<select name='RHIHhinicio1'>
				  <cfloop index="i" from="1" to="12">
					<option value="#i#"<cfif modo EQ "CAMBIO" and rsIncidenciaHora.hinicio EQ i> selected</cfif>><cfif Len(Trim(i)) EQ 1>0</cfif>#i#</option>
				  </cfloop>
				</select> :
				<select name='RHIHhinicio2'>
				  <cfloop index="i" from="0" to="59">
					<option value="#i#"<cfif modo EQ "CAMBIO" and rsIncidenciaHora.minicio EQ i> selected</cfif>><cfif Len(Trim(i)) EQ 1>0</cfif>#i#</option>
				  </cfloop>
				</select>
				<select name="RHIHhinicio3">
					<option value="AM"<cfif modo EQ "CAMBIO" and rsIncidenciaHora.tinicio EQ 'AM'> selected</cfif>>AM</option>
					<option value="PM"<cfif modo EQ "CAMBIO" and rsIncidenciaHora.tinicio EQ 'PM'> selected</cfif>>PM</option>
				</select>
			</td>
		  </tr>
		  <tr>
			<td class="fileLabel" align="right" nowrap>#vHoraFin#: </td>
			<td nowrap>
				<select name='RHIHhfinal1'>
				  <cfloop index="i" from="1" to="12">
					<option value="#i#"<cfif modo EQ "CAMBIO" and rsIncidenciaHora.hfinal EQ i> selected</cfif>><cfif Len(Trim(i)) EQ 1>0</cfif>#i#</option>
				  </cfloop>
				</select> :
				<select name='RHIHhfinal2'>
				  <cfloop index="i" from="0" to="59">
					<option value="#i#"<cfif modo EQ "CAMBIO" and rsIncidenciaHora.mfinal EQ i> selected</cfif>><cfif Len(Trim(i)) EQ 1>0</cfif>#i#</option>
				  </cfloop>
				</select>
				<select name="RHIHhfinal3">
					<option value="AM"<cfif modo EQ "CAMBIO" and rsIncidenciaHora.tfinal EQ 'AM'> selected</cfif>>AM</option>
					<option value="PM"<cfif modo EQ "CAMBIO" and rsIncidenciaHora.tfinal EQ 'PM'> selected</cfif>>PM</option>
				</select>
			</td>
		  </tr>
			<cfset ts = "">	
			<cfif modo EQ "CAMBIO">
				<cfinvoke 
					component="sif.Componentes.DButils"
					method="toTimeStamp"
					returnvariable="ts">
					<cfinvokeargument name="arTimeStamp" value="#rsIncidenciaHora.ts_rversion#"/>
				</cfinvoke>
			</cfif>
			<tr><td colspan="2"><input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>"></td></tr>
		  <tr align="center">
		    <td colspan="2" nowrap>
				<cfinclude template="/rh/portlets/pBotones.cfm">
			</td>
		  </tr>
		</table>
	</form>

  </td>
</tr>
<tr>
  <td colspan="2">&nbsp;</td>
</tr>
</table>
<script language="javascript" type="text/javascript">
	function habilitarValidacion() {
		objForm.CIcodigo.required = true;
		objForm.RHIHfrige.required = true;
		objForm.RHIHfhasta.required = true;
	}

	function deshabilitarValidacion() {
		objForm.CIcodigo.required = false;
		objForm.RHIHfrige.required = false;
		objForm.RHIHfhasta.required = false;
	}

	qFormAPI.errorColor = "##FFFFCC";
	objForm = new qForm("form1");
	
	objForm.CIcodigo.required = true;
	objForm.CIcodigo.description = "#vConcepto#";
	objForm.RHIHfrige.required = true;
	objForm.RHIHfrige.description = "#vFechaRige#";
	objForm.RHIHfhasta.required = true;
	objForm.RHIHfhasta.description = "#vFechaVence#";
	
</script>
	</cfoutput>