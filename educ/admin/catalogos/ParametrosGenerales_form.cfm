<!--- Establecimiento del modo --->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modo")>
		<cfset modo="ALTA">
	<cfelseif #form.modo# EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!---       Consultas      --->
<cfif modo NEQ 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
		Select PGdescripcion
			, PGtipo
			, PGvalor
		from ParametrosGenerales
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and PGnombre=<cfqueryparam cfsqltype="cf_sql_char" value="#form.PGnombre#">
	</cfquery>
</cfif>

<script language="JavaScript" src="/cfmx/educ/js/utilesMonto.js">//</script>

<form action="ParametrosGenerales_SQL.cfm" method="post" name="ParametrosGenerales">
	<cfif modo neq 'ALTA'>
		<cfset ts = "">	
		<cfoutput>
			<input type="hidden" name="PGnombre" id="PGnombre" value="#Form.PGnombre#">
		</cfoutput>
	</cfif>
	
	<table border="0" cellpadding="2" cellspacing="0" align="left" width="100%">
		<tr>
			<td class="tituloMantenimiento" colspan="2" align="center">
				<font size="3">
					Modificar Parámetro
				</font>
			</td>
		</tr>
		<tr> 
			<td align="right" valign="baseline">Parámetro:&nbsp;</td>
			<td valign="baseline">
				<cfoutput>#rsForm.PGdescripcion#</cfoutput>
			</td>
		</tr>		
		</tr>		
			<td>&nbsp;</td>
		<tr> 
		<tr> 
			<td align="right" valign="top">Valor:&nbsp;</td>
			<td valign="baseline">
			<cfif rsForm.PGtipo EQ "B">
				<select name="PGvalor">
					<option value="1" <cfif rsForm.PGvalor EQ "1">selected</cfif>>Sí</option>
					<option value="0" <cfif rsForm.PGvalor EQ "0">selected</cfif>>No</option>
				</select>
			<cfelse>
				<input name="PGvalor" align="left" type="text" id="PGvalor" size="20" value="<cfoutput>#rsForm.PGvalor#</cfoutput>" 
					onfocus="javascript:this.select();" 
					<cfif rsForm.PGtipo EQ "N">
					onfocus="javascript:this.value=qf(this); this.select();" onblur="javascript:fm(this,0);"  
					onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" 
					</cfif>
					>
			</cfif>
			</td>
		</tr>
		<tr> 
		  <td align="center">&nbsp;</td>
		  <td align="center">&nbsp;</td>
		</tr>
		<tr> 
		  <td align="center" colspan="2">
			<input type="hidden" name="botonSel" value="">
			<input name="Cambio" type="submit" onSelect="javascript: alert(select);" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion(); " value="Modificar">
		  </td>
		</tr>
	  </table>
</form>	  
