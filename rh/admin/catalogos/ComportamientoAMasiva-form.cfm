<!-- Establecimiento del modo -->
<cfif isdefined("form.CAMid") and len(trim(form.CAMid))>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>

<!--- Consultas de Tipo de Acción Masiva --->
<cfif modo EQ "CAMBIO">
	<cfquery name="rsForm" datasource="asp">
		select 	CAMid, rtrim(CAMAcodigo) as CAMAcodigo, rtrim(CAMdescripcion) as CAMdescripcion, rtrim(CAMcomponente) as CAMcomponente, 
				CAMcempresa, CAMctiponomina, CAMcregimenv, CAMcoficina, 
				CAMcdepto, CAMcplaza, CAMcpuesto, CAMccomp, CAMcsalariofijo, 
				CAMccatpaso, CAMcjornada, CAMidliquida, BMUsucodigo
		from ComportamientoAMasiva
		where CAMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CAMid#">
	</cfquery>
</cfif>

<cfif isdefined("Url.PageNum_lista")>
	<cfparam name="Form.PageNum_lista" default="#Url.PageNum_lista#">
</cfif>

<!--- Pintado de la Pantalla de Componentes de Acciones Masivas --->
<cfoutput>
<form name="form1" method="post" action="ComportamientoAMasiva-sql.cfm" style="margin: 0;">
	
	<cfif modo EQ "CAMBIO">
		<input type="hidden" name="CAMid" value="#rsForm.CAMid#" />
	</cfif> 
	<cfif isdefined("Form.PageNum_lista")>
		<input type="hidden" name="PageNum_lista" value="#Form.PageNum_lista#" />
	<cfelseif isdefined("Form.PageNum")>
		<input type="hidden" name="PageNum_lista" value="#Form.PageNum#" />
	</cfif>

	<table width="100%" border="0" cellpadding="2" cellspacing="0">
		<tr> 
			<td colspan="4" align="center" class="tituloAlterno"> 
				<cfif modo EQ "CAMBIO"> 
					Modificaci&oacute;n Comportamiento de Acci&oacute;n Masiva 
				<cfelse> 
					Nuevo Comportamiento de Acci&oacute;n Masiva
				</cfif> 
			</td>
		</tr>
		<tr> 
			<td align="right" width="15%" class="fileLabel">C&oacute;digo:</td>
			<td colspan="3">
				<input name="CAMAcodigo" type="text" value="<cfif modo EQ "CAMBIO">#rsForm.CAMAcodigo#</cfif>" size="6" maxlength="5" > 
			</td>
		</tr>
		<tr> 
			<td align="right" class="fileLabel">Descripci&oacute;n:</td>
			<td colspan="3"> 
				<input name="CAMdescripcion" type="text" value="<cfif modo EQ "CAMBIO">#rsForm.CAMdescripcion#</cfif>" maxlength="80" size="80" >
			</td>
		</tr>
		<tr> 
			<td align="right" class="fileLabel">Componente:</td>
			<td colspan="3"> 
				<input name="CAMcomponente" type="text" value="<cfif modo EQ "CAMBIO">#rsForm.CAMcomponente#</cfif>" maxlength="80" size="80" >
			</td>
		</tr>
		<tr>
			<td align="right"><input name="CAMidliquida" type="checkbox"<cfif modo EQ "CAMBIO" and rsForm.CAMidliquida EQ 1> checked</cfif>></td>
			<td colspan="3">Permite Liquidaci&oacute;n</td>
		</tr>		
		<tr>
			<td colspan="4">
				<fieldset>
				<legend><b>&nbsp;Permite Modificar&nbsp;&nbsp;</b></legend>
					<table width="80%" border="0" cellpadding="1" cellspacing="0">
						<tr>
							<td><input type="checkbox" <cfif modo eq "CAMBIO" and rsForm.CAMctiponomina eq 1>checked</cfif> name="CAMctiponomina" value="checkbox"></td>
							<td nowrap>Tipo de N&oacute;mina</td>
							<td><input type="checkbox" <cfif modo eq "CAMBIO" and rsForm.CAMcregimenv eq 1>checked</cfif> name="CAMcregimenv" value="checkbox"></td>
							<td nowrap>R&eacute;gimen de Vacaciones</td>
							<td><input type="checkbox" <cfif modo eq "CAMBIO" and rsForm.CAMcoficina eq 1>checked</cfif> name="CAMcoficina" value="checkbox"></td>
							<td nowrap>Oficina</td>
						</tr>
						<tr>
							<td><input type="checkbox" <cfif modo eq "CAMBIO" and rsForm.CAMcjornada eq 1>checked</cfif> name="CAMcjornada" value="checkbox"></td>
							<td nowrap>Jornada</td>
							<td><input type="checkbox" <cfif modo eq "CAMBIO" and rsForm.CAMcsalariofijo eq 1>checked</cfif> name="CAMcsalariofijo" value="checkbox"></td>
							<td nowrap>% Salario Fijo</td>
							<td><input type="checkbox" <cfif modo eq "CAMBIO" and rsForm.CAMcempresa eq 1>checked</cfif> name="CAMcempresa" value="checkbox"></td>
							<td nowrap>Empresa</td>
						</tr>
						<tr>
							<td><input type="checkbox" <cfif modo eq "CAMBIO" and rsForm.CAMcdepto eq 1>checked</cfif> name="CAMcdepto" value="checkbox"></td>
							<td nowrap>Departamento</td>
							<td><input type="checkbox" <cfif modo eq "CAMBIO" and rsForm.CAMccomp eq 1>checked</cfif> name="CAMccomp" value="checkbox"></td>
							<td nowrap>Componentes Salariales</td>
							<td><input type="checkbox" <cfif modo eq "CAMBIO" and rsForm.CAMcpuesto eq 1>checked</cfif> name="CAMcpuesto" value="checkbox"></td>
							<td nowrap>Puesto</td>
						</tr>
						<tr>
							<td><input type="checkbox" <cfif modo eq "CAMBIO" and rsForm.CAMccatpaso eq 1>checked</cfif> name="CAMccatpaso" value="checkbox"></td>
							<td colspan="5">Categor&iacute;a / Paso </td>
						</tr>
					</table>
				</fieldset>
			</td>
		</tr>
		<tr>
			<td colspan="4" align="center"><cf_botones modo="#modo#"></td>
		</tr>
		<tr>
			<td colspan="4" align="center">&nbsp;</td>
		</tr>
	</table> 
</form>
</cfoutput>


<cf_qforms>	
<script language="javascript" type="text/javascript">

	objForm.CAMAcodigo.required = true;
	objForm.CAMAcodigo.description = "Código";
	
	objForm.CAMdescripcion.required = true;
	objForm.CAMdescripcion.description = "Descripción";
	
	objForm.CAMcomponente.required = true;
	objForm.CAMcomponente.description = "Componente";

</script>