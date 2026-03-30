<cfif isdefined("Form.CPTTid") and len(trim(form.CPTTid)) NEQ 0>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>

<cfif isDefined("session.Ecodigo") and isDefined("Form.CPTTid") and len(trim(#Form.CPTTid#)) NEQ 0>
	<cfquery name="rsCPTT" datasource="#Session.DSN#" >
		Select CPTTid, Ecodigo, CPTTcodigo, CPTTtipo, CPTTdescripcion
				, CPTTaprobacion, CPTTverificaciones, CPTTtramites, CPTTtipoCta
				, ts_rversion
        from CPtipoTraslado
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo# ">
		and CPTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPTTid#" >		  
		order by CPTTdescripcion asc
	</cfquery>
</cfif>

<cfoutput>
<form name="form1" action="tiposSql.cfm" method="post">
	<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
	<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">	
	<input name="filtro_CPTTcodigo" type="hidden" value="<cfif isdefined('form.filtro_CPTTcodigo')>#form.filtro_CPTTcodigo#</cfif>">
	<input name="filtro_CPTTdescripcion" type="hidden" value="<cfif isdefined('form.filtro_CPTTdescripcion')>#form.filtro_CPTTdescripcion#</cfif>">
	<input name="filtro_CPTTtipo" type="hidden" value="<cfif isdefined('form.filtro_CPTTtipo')>#form.filtro_CPTTtipo#</cfif>">
	
	<table width="67%" height="75%" align="center" cellpadding="2" cellspacing="0">
		<tr> 
			<td align="right" nowrap>C&oacute;digo:&nbsp;</td>
			<td>
				<input name="CPTTcodigo" tabindex="1" type="text"
				value="<cfif modo neq "ALTA" >#rsCPTT.CPTTcodigo#</cfif>" 
				size="10" maxlength="10"  alt="El Código del Concepto" <cfif modo NEQ 'ALTA'> class="cajasinborde" readonly</cfif>> 
			</td>
		</tr>
		<tr> 
			<td align="right" nowrap>Tipo de Autorización:&nbsp;</td>
			<td align="left"> 
				<select name="CPTTtipo" tabindex="1">
						<option value="I" <cfif (isDefined("rsCPTT.CPTTtipo") and trim(rsCPTT.CPTTtipo) EQ "I")>selected</cfif> >Interna</option>
						<option value="E" <cfif (isDefined("rsCPTT.CPTTtipo") and trim(rsCPTT.CPTTtipo) EQ "E")>selected</cfif> >Externa</option>
				</select>
			</td>
		</tr>

		<tr> 
			<td align="right" nowrap>Descripci&oacute;n:&nbsp;</td>
			<td>
				<input name="CPTTdescripcion" tabindex="1" type="text"  value="<cfif modo neq "ALTA"><cfoutput>#rsCPTT.CPTTdescripcion#</cfoutput></cfif>" size="50" maxlength="50" onFocus="this.select();"  alt="La Descripción del Concepto">
			</td>
		</tr>

<!---
		<tr> 
			<td align="right" nowrap>Tipo de Aprobación:&nbsp;</td>
			<td>
				<select name="CPTTaprobacion">
					<option value="0" <cfif isDefined("rsCPTT.CPTTaprobacion") and rsCPTT.CPTTaprobacion EQ 0>selected</cfif>>Aprobación por Centro Funcional "JOIN"</option>
					<option value="1" <cfif isDefined("rsCPTT.CPTTaprobacion") and rsCPTT.CPTTaprobacion EQ 1>selected</cfif>>Aprobación por Trámite</option>
					<option value="2" <cfif isDefined("rsCPTT.CPTTaprobacion") and rsCPTT.CPTTaprobacion EQ 2>selected</cfif>>Trámite por Oficina</option>
				</select>
			</td>
		</tr>
--->
		<cfset rsCPTT.CPTTaprobacion = 1>
		<input type="hidden" name="CPTTaprobacion" value="1"/>
		<cfif rsCPTT.CPTTaprobacion EQ 1>
			<!----Obtener lista de trámites---->
			<cfinvoke component="sif.Componentes.Workflow.plantillas" method="CrearPkg" returnvariable="WfPackage">
				<cfinvokeargument name="PackageBaseName" value="TPRES"/>
			</cfinvoke>

			<cfquery name="rsProcesos" datasource="#Session.DSN#">
				select p.ProcessId, p.Name, upper(p.Name) as upper_name, p.PublicationStatus
				  from WfProcess p
					inner join WfPackage pk 
						 on pk.PackageId=p.PackageId 
						and pk.Name like 'TPRES%'				  
				 where p.Ecodigo = #session.Ecodigo# 
				   and p.PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#WfPackage.PackageId#"> 
				   and p.PublicationStatus = 'RELEASED'
				 order by upper_name
			</cfquery>
			<cfset LvarTramites   = "">
			<cfset LvarID_tramite = "">
			<cfset LvarID_tramite = "">
			<cfif modo NEQ "ALTA">
				<cfset LvarTramites   = listLast(rsCPTT.CPTTtramites,"|")>
				<cfset LvarID_tramite = listFirst(LvarTramites)>
				<cfset LvarID_tramite = trim(LvarID_tramite)>
			</cfif>

			<cfif LvarID_tramite NEQ "" AND LvarID_tramite NEQ "0">
				<cfquery name="rsTramite" datasource="#Session.DSN#">
					select upper(Name) as upper_name
					  from WfProcess
					 where WfProcess.Ecodigo = #session.Ecodigo# 
					   and ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarID_tramite#"> 
				</cfquery>
				<cfset LvarTramite = rsTramite.upper_name>
			<cfelse>
				<cfset LvarTramite = "">
			</cfif>
			<tr> 
				<td align="right" nowrap>Trámite:&nbsp;</td>
				<td>
					<select name="CPTTtramites">
						<option value="0">Aprobación por Centro Funcional "JOIN"</option>
						<cfloop query="rsProcesos"> 
							<option value="#rsProcesos.ProcessId#" 
									<cfif  rsProcesos.upper_name eq LvarTramite>selected</cfif>
							>#rsProcesos.upper_name#</option>
						</cfloop>
					</select>
				</td>
			</tr>
		</cfif>	
		<tr> 
			<td align="right" nowrap>Base de Traslado:&nbsp;</td>
			<td>
				<select name="CPTTtipoCta">
					<option value="0" <cfif isDefined("rsCPTT.CPTTtipoCta") and rsCPTT.CPTTtipoCta EQ 0>selected</cfif>>De total a total</option>
					<option value="1" <cfif isDefined("rsCPTT.CPTTtipoCta") and rsCPTT.CPTTtipoCta EQ 1>selected</cfif>>De cuenta a cuenta</option>
				</select>
			</td>
		</tr>

		<tr><td colspan="2">&nbsp;</td></tr>

		<tr> 
			<td colspan="2" align="center" nowrap>
				<cf_botones modo="#modo#" tabindex="1">
			</td>
		</tr>


	<!--- *************************************************** --->
	<cfif modo NEQ 'ALTA'>
		<tr><td>&nbsp;</td></tr>
		<tr> 
			<td colspan="2" align="center" style=" border-bottom:solid 1px ##000000">
				<strong>Verificaciones</strong>
			</td>
		</tr>
		<tr> 
			<td>
				Tipo Verificación:
			</td>
			<td>
				<select name="CPTTverificacionTipo" id="CPTTverificacion" onChange="sbCPTTverificacion(this.value);" onBlur="sbCPTTverificacion(this.value);">
					<option value="">(Escoger el tipo de Verificación)</option>
					<optgroup label="Verificación de Centros Funcionales">
						<option value="1">Sólo del mismo Centro Funcional</option>
						<option value="2">Sólo de la misma Oficina</option>
						<option value="3">Sólo de un Grupo de Oficinas</option>
						<option value="7">Sólo del mismo Grupo de Oficinas de un Tipo</option>
						<option value="-1">Sólo de diferentes Centros Funcionales</option>
						<option value="-2">Sólo de diferentes Oficinas</option>
						<option value="-7">Sólo de diferentes Grupos de Oficinas de un Tipo</option>
					</optgroup>
					<optgroup label="Verificación de Cuentas">
						<option value="4">Sólo un mismo nivel de Cuenta</option>
						<option value="5">Sólo un mismo valor de Catálogo</option>
						<option value="6">Sólo una misma Clasificación de Catálogos</option>
					</optgroup>
				</select>
				<script>
					function sbCPTTverificacion(tipo)
					{
						document.getElementById("ValidacionTit").value = "";
						document.getElementById("ValidacionGO").style.display = "none";
						document.getElementById("ValidacionGOT").style.display = "none";
						document.getElementById("ValidacionNiv").style.display = "none";
						document.getElementById("ValidacionCat").style.display = "none";
						document.getElementById("ValidacionCla").style.display = "none";
						document.getElementById("ValidacionGO").disabled = true;
						document.getElementById("ValidacionGOT").disabled = true;
						document.getElementById("ValidacionNiv").disabled = true;
						document.getElementById("ValidacionCat").disabled = true;
						document.getElementById("ValidacionCla").disabled = true;
						if (tipo == 3)
						{
							document.getElementById("ValidacionTit").value = "Grupo:";
							document.getElementById("ValidacionGO").style.display = "";
							document.getElementById("ValidacionGO").disabled = false;
						}
						else if ((tipo == 7) || (tipo == -7))
						{
							document.getElementById("ValidacionTit").value = "Tipo de Grupo:";
							document.getElementById("ValidacionGOT").style.display = "";
							document.getElementById("ValidacionGOT").disabled = false;
						}
						else if (tipo == 4)
						{
							document.getElementById("ValidacionTit").value = "Nivel:";
							document.getElementById("ValidacionNiv").style.display = "";
							document.getElementById("ValidacionNiv").disabled = false;
						}
						else if (tipo == 5)
						{
							document.getElementById("ValidacionTit").value = "Catálogo:";
							document.getElementById("ValidacionCat").style.display = "";
							document.getElementById("ValidacionCat").disabled = false;
						}
						else if (tipo == 6)
						{
							document.getElementById("ValidacionTit").value = "Clasificacion:";
							document.getElementById("ValidacionCla").style.display = "";
							document.getElementById("ValidacionCla").disabled = false;
						}
					}
				</script>
			</td>
		</tr>
		<!--- Pantalla de Agregar Validaciones --->
		<tr> 
			<td nowrap="nowrap">
				<!--- Titulo --->
				<input type="submit" value="Agregar" name="AddValidacion" onClick="if (document.getElementById('CPTTverificacion').value == '') return false;">
				<input id="ValidacionTit" style="border:none; text-align:right" size="15" value="" align="right">
			</td>
			<td>
				<!--- Grupo de Oficinas --->
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					select GOid, GOcodigo, GOnombre
					  from AnexoGOficina o
					 where Ecodigo = #session.Ecodigo# 
					order by Ecodigo, GOcodigo
				</cfquery>
				<select name="CPTTverificacionValorGO" id="ValidacionGO" style="display:none">
				<cfloop query="rsSQL">
					<option value="#rsSQL.GOid#">#rsSQL.GOcodigo# - #rsSQL.GOnombre#</option>
				</cfloop>
				</select>
				<!--- Tipo de Grupos de Oficinas --->
				<cfquery name="rsSQL" datasource="#session.DSN#">
					select a.GOTid, a.GOTcodigo, a.GOTnombre
					  from AnexoGOTipo a
					 where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo# ">
					order by Ecodigo, GOTcodigo
				</cfquery>
				<select name="CPTTverificacionValorGOT" id="ValidacionGOT" style="display:none">
				<cfloop query="rsSQL">
					<option value="#rsSQL.GOTid#">#rsSQL.GOTcodigo# - #rsSQL.GOTnombre#</option>
				</cfloop>
				</select>
				<!--- Nivel de Cuenta --->
				<input name="CPTTverificacionValorNIV" id="ValidacionNiv" size="3" value="" align="right" style="display:none; text-align:right">
				<!--- Catálogo --->
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					select PCEcatid, PCEcodigo, PCEdescripcion
					  from PCECatalogo
				</cfquery>
				<select name="CPTTverificacionValorCAT" id="ValidacionCat" style="display:none">
				<cfloop query="rsSQL">
					<option value="#rsSQL.PCEcatid#">#rsSQL.PCEcodigo# - #mid(rsSQL.PCEdescripcion,1,30)#</option>
				</cfloop>
				</select>
				<!--- Clasificacion --->
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					select PCCEclaid, PCCEcodigo, PCCEdescripcion
					  from PCClasificacionE
					 where CEcodigo = #session.CEcodigo#
				</cfquery>
				<select name="CPTTverificacionValorCLA" id="ValidacionCla" style="display:none">
				<cfloop query="rsSQL">
					<option value="#rsSQL.PCCEclaid#">#rsSQL.PCCEcodigo# - #mid(rsSQL.PCCEdescripcion,1,30)#</option>
				</cfloop>
				</select>
			</td>
		</tr>
		<cfset LvarVerifica_tipos =  listToArray(listFirst(rsCPTT.CPTTverificaciones,"|"))>
		<cfset LvarVerifica_valors = listToArray(listLast(rsCPTT.CPTTverificaciones,"|"))>
		<cfloop index="i" from="1" to="#arrayLen(LvarVerifica_tipos)#">
		<!--- Lista de Validaciones --->
		<cfif i EQ 1>
		<tr>
			<td colspan="2">
				Sólo permitir transferencia entre:
			</td>
		</tr>
		</cfif>
		<tr> 
			<td colspan="2">
				&nbsp;&nbsp;&nbsp;&nbsp;
				<img 	src="/cfmx/sif/imagenes/Borrar01_S.gif"
						style="cursor:pointer"
						onClick="location.href='tiposSql.cfm?DelValidacion&CPTTid=#form.CPTTid#&r=#i#&pagina=#form.pagina#';"
				>
			<cfif LvarVerifica_tipos[i] EQ 1>
				<!--- Mismo Centro Funcional --->
				El mismo Centro Funcional
			<cfelseif LvarVerifica_tipos[i] EQ -1>
				<!--- Diferentes Centros Funcionales --->
				Diferentes Centros Funcionales
			<cfelseif LvarVerifica_tipos[i] EQ 2>
				<!--- Misma Oficina --->
				La misma Oficina
			<cfelseif LvarVerifica_tipos[i] EQ -2>
				<!--- Diferentes Oficinas --->
				Diferentes Oficinas
			<cfelseif LvarVerifica_tipos[i] EQ 3>
				<!--- Grupo de Oficinas --->
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					select GOid, GOcodigo, GOnombre
					  from AnexoGOficina o
					 where Ecodigo = #session.Ecodigo# 
					   and GOid = #LvarVerifica_valors[i]#
				</cfquery>
				Oficinas del Grupo <strong>#rsSQL.GOcodigo# - #rsSQL.GOnombre#</strong>
			<cfelseif LvarVerifica_tipos[i] EQ 7>
				<!--- Mismo Grupo dentro de un Tipo de Grupo de Oficinas --->
				<cfquery name="rsSQL" datasource="#session.DSN#">
					select a.GOTid, a.GOTcodigo, a.GOTnombre
					  from AnexoGOTipo a
					 where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo# ">
					   and GOTid = #LvarVerifica_valors[i]#
				</cfquery>
				Oficinas del mismo Grupo del Tipo <strong>#rsSQL.GOTcodigo# - #rsSQL.GOTnombre#</strong>
			<cfelseif LvarVerifica_tipos[i] EQ -7>
				<!--- Diferentes Grupos dentro de un Tipo de Grupo de Oficinas --->
				<cfquery name="rsSQL" datasource="#session.DSN#">
					select a.GOTid, a.GOTcodigo, a.GOTnombre
					  from AnexoGOTipo a
					 where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo# ">
					   and GOTid = #LvarVerifica_valors[i]#
				</cfquery>
				Oficinas de diferentes Grupos del Tipo <strong>#rsSQL.GOTcodigo# - #rsSQL.GOTnombre#</strong>
			<cfelseif LvarVerifica_tipos[i] EQ 4>
				<!--- Nivel de Cuenta --->
				Un mismo nivel de Cuenta = #LvarVerifica_valors[i]#
			<cfelseif LvarVerifica_tipos[i] EQ 5>
				<!--- Valor de Catálogo --->
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					select PCEcatid, PCEcodigo, PCEdescripcion
					  from PCECatalogo
					 where PCEcatid = #LvarVerifica_valors[i]#
				</cfquery>
				Un mismo valor del Catálogo <strong>#rsSQL.PCEcodigo# - #rsSQL.PCEdescripcion#</strong>
			<cfelseif LvarVerifica_tipos[i] EQ 6>
				<!--- Valor de Catálogo Clasificado --->
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					select PCCEclaid, PCCEcodigo, PCCEdescripcion
					  from PCClasificacionE
					 where CEcodigo = #session.CEcodigo#
					   and PCCEclaid = #LvarVerifica_valors[i]#
				</cfquery>
				Una misma Clasificación de Catálogos <strong>#rsSQL.PCCEcodigo# - #rsSQL.PCCEdescripcion#</strong>
			</cfif>
			
			</td>
		</tr>
		</cfloop>
		<tr> 
			<td colspan="2" style=" border-bottom:solid 1px ##000000">&nbsp;</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</cfif>	
	<!--- *************************************************** --->  
	</table>

	<cfset ts = "">
	<cfif modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsCPTT.ts_rversion#"/>
		</cfinvoke>
	</cfif>  

  <input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>" size="32">
  <input type="hidden" name="CPTTid" value="<cfif modo NEQ "ALTA"><cfoutput>#rsCPTT.CPTTid#</cfoutput></cfif>">
	
 </form>
 </cfoutput>
 <script language="javascript">
 	function funcAlta()
	{
		return funcCambio();
	}
 	function funcCambio()
	{
		if (document.form1.CPTTcodigo.value == '')
		{
			alert ("Código no puede quedar en blanco");
			document.form1.CPTTcodigo.focus();
			return false;
		}
		if (document.form1.CPTTdescripcion.value == '')
		{
			alert ("Descripción no puede quedar en blanco");
			document.form1.CPTTdescripcion.focus();
			return false;
		}
	}
</script>

<script language="JavaScript" type="text/JavaScript">
 	<cfif modo NEQ "ALTA">
 		document.form1.CPTTdescripcion.focus();
	<cfelse>
		document.form1.CPTTcodigo.focus();
 	</cfif> 
</script>


<!---
		<cfelseif rsCPTT.CPTTaprobacion EQ 2>
			<cfset LvarOficinas = listFirst(rsCPTT.CPTTtramites,"|")>
			<cfset LvarTramites = listLast(rsCPTT.CPTTtramites,"|")>
			<tr> 
				<td colspan="2">
					<table width="100%">
						<tr>
							<td colspan="2" style=" border-bottom:solid 1px ##000000">
								Oficina
							</td>
							<td style=" border-bottom:solid 1px ##000000">
								Trámite
							</td>
						<tr>
					<cfquery name="rsOficinas" datasource="#Session.DSN#" >
						Select Ocodigo, Oficodigo, Odescripcion
						  from Oficinas
						 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo# ">
						 order by Oficodigo
					</cfquery>
					<cfloop query="rsOficinas">
						<tr>
							<td>#rsOficinas.Oficodigo#</td>
							<td>#rsOficinas.Odescripcion#</td>
							<td>
								<cfset LvarPto = listFind(LvarOficinas, rsOficinas.Ocodigo)>
								<cfif LvarPto EQ 0>
									<cfset LvarID_tramite = "">
								<cfelse>
									<cfset LvarID_tramite = listGetAt(LvarTramites,LvarPto)>
								</cfif>
								<cfif LvarID_tramite NEQ "" AND LvarID_tramite NEQ "0">
									<cfquery name="rsTramite" datasource="#Session.DSN#">
										select upper(Name) as upper_name
										  from WfProcess
										 where WfProcess.Ecodigo = #session.Ecodigo# 
										   and ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarID_tramite#"> 
									</cfquery>
									<cfset LvarTramite = rsTramite.upper_name>
								<cfelse>
									<cfset LvarTramite = "">
								</cfif>
								<input type="hidden" name="CPTTtramites_Ofis" value="#rsOficinas.Ocodigo#">
								<select name="CPTTtramites_Trms">
									<option value="0">Aprobación por Centro Funcional "JOIN"</option>
									<cfloop query="rsProcesos"> 
										<option value="#rsProcesos.ProcessId#" 
												<cfif  rsProcesos.upper_name eq LvarTramite>selected</cfif>
										>#rsProcesos.upper_name#</option>
									</cfloop>
								</select>
							</td>
						</tr>
					</cfloop>
					</table>
				</td>
			</tr>
--->
