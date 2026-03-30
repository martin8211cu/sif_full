<cfinclude template="../../Utiles/sifConcat.cfm">
<cfif isdefined("Form.PCREIid") and Len(Trim(Form.PCREIid))>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfif isdefined("Form.PCRid") and Len(Trim(Form.PCRid))>
	<cfset modoDet = "CAMBIO">
<cfelse>
	<cfset modoDet = "ALTA">
</cfif>

<cfif modo EQ "CAMBIO">
	<cfquery name="rsEncabezado" datasource="#Session.DSN#">
		select a.PCREIid, a.Ecodigo, a.PCREIdescripcion, a.PCREIfecha
		from PCReglasEImportacion a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCREIid#">
	</cfquery>
</cfif>

<cfif modoDet EQ "CAMBIO">
	<cfquery name="rsDetalle" datasource="#Session.DSN#">
		select a.PCREIid, a.PCRid, a.Cmayor, a.PCEMid, a.Ocodigo, rtrim(a.Oformato) as Oformato, a.PCRref, a.PCRrefsys, 
			   a.PCRdescripcion, a.PCRregla, a.PCRvalida, a.PCRdesde, a.PCRhasta, a.PCRerror1, a.PCRerror2, 
			   a.PCRerror3, a.PCRerror4, a.PCRerror5, a.PCRerror6, a.PCRerror7, a.PCRerror8, a.PCRerror9, a.PCRerror10, 
			   a.Usucodigo, a.Ulocalizacion, a.BMUsucodigo, PCRGcodigo,
			   b.PCRregla as PCRrefsys_text
		from PCReglasDImportacion a
			left outer join PCReglas b
				on b.PCRid = a.PCRrefsys
		where a.PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCREIid#">
		and a.PCRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCRid#">
		order by a.PCRid
	</cfquery>
</cfif>

<cfset navegacion = "">
<cfif isdefined("Form.PCREIid") and Len(Trim(Form.PCREIid))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "PCREIid=" & Form.PCREIid>
</cfif>
<cfif isdefined("Form.PCRid") and Len(Trim(Form.PCRid))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "PCRid=" & Form.PCRid>
</cfif>
<cfif isdefined("Form.filtro_PCRid") and Len(Trim(Form.filtro_PCRid))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_PCRid=" & Form.filtro_PCRid>
</cfif>
<cfif isdefined("Form.filtro_Cmayor") and Len(Trim(Form.filtro_Cmayor))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_Cmayor=" & Form.filtro_Cmayor>
</cfif>
<cfif isdefined("Form.filtro_Oformato") and Len(Trim(Form.filtro_Oformato))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_Oformato=" & Form.filtro_Oformato>
</cfif>
<cfif isdefined("Form.filtro_PCRregla") and Len(Trim(Form.filtro_PCRregla))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_PCRregla=" & Form.filtro_PCRregla>
</cfif>
<cfif isdefined("Form.filtro_PCRdesde") and Len(Trim(Form.filtro_PCRdesde))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_PCRdesde=" & Form.filtro_PCRdesde>
</cfif>
<cfif isdefined("Form.filtro_PCRhasta") and Len(Trim(Form.filtro_PCRhasta))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_PCRhasta=" & Form.filtro_PCRhasta>
</cfif>
<cfif isdefined("Form.filtro_PCRvalida") and Len(Trim(Form.filtro_PCRvalida))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_PCRvalida=" & Form.filtro_PCRvalida>
</cfif>
<cfif isdefined("Form.filtro_ErrVal") and Len(Trim(Form.filtro_ErrVal))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_ErrVal=" & Form.filtro_ErrVal>
</cfif>
<!--- Filtro para los grupos de reglas --->
<cfif isdefined("Form.filtro_PCRGcodigo") and Len(Trim(Form.filtro_PCRGcodigo))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_PCRGcodigo=" & Form.filtro_PCRGcodigo>
</cfif>

<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="javascript" type="text/javascript">
	<cfif modo EQ "CAMBIO">
	function funcFiltrar() {
		document.listaform1.PCREIID.value = '<cfoutput>#Form.PCREIid#</cfoutput>';
	}
	
	function funcNuevo() {
		var params = "";
		<cfoutput>
		location.href = 'ReglasImport.cfm?PCREIid=#Form.PCREIid#'+params;
		</cfoutput>
		return false;
	}
	</cfif>

	function funcEliminarLote() {
		if (confirm('Esta seguro de que desea eliminar este lote de reglas?')) {
			return true;
		} else {
			return false;
		}
	}

	function funcListado() {
		location.href = 'ReglasImport.cfm';
		return false;
	}
</script>

<cfoutput>
	<form name="formEncabezado" method="post" action="ReglasImport-sql.cfm" style="margin: 0;">
		<cfif modo EQ "CAMBIO">
			<input type="hidden" name="PCREIid" value="#Form.PCREIid#">
		</cfif>
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  <tr>
		  	<td colspan="5" class="tituloAlterno">Lote de Reglas</td>
		  </tr>
		  <tr>
			<td class="fileLabel" align="right">
				Descripci&oacute;n:
			</td>
			<td>
				<input type="text" name="PCREIdescripcion" size="40" maxlength="255" value="<cfif modo EQ "CAMBIO">#rsEncabezado.PCREIdescripcion#</cfif>">
			</td>
			<td class="fileLabel" align="right">
				Fecha:
			</td>
			<td>
				<cfif modo EQ "CAMBIO">
					<cfset fecha = LSDateFormat(rsEncabezado.PCREIfecha, 'dd/mm/yyyy')>
				<cfelse>
					<cfset fecha = LSDateFormat(Now(), 'dd/mm/yyyy')>
				</cfif>
				<cf_sifcalendario form="formEncabezado" name="PCREIfecha" value="#fecha#">
			</td>
			<td>
				<cfif modo EQ "CAMBIO">
					<cf_botones names="ModificarLote, EliminarLote, ValidarReglas, Aplicar, Listado" values="Modificar Lote, Eliminar Lote, Validar Reglas, Aplicar, Listado">
				<cfelse>
					&nbsp;
				</cfif>
			</td>
		  </tr>
		  <tr>
			<td colspan="5">&nbsp;</td>
		  </tr>
		</table>
	</form>

	<cfif modo EQ "CAMBIO">
	<form name="form1" method="post" action="ReglasImport-sql.cfm" onSubmit="return validar();" style="margin: 0;">
		<input type="hidden" name="PCREIid" value="#Form.PCREIid#">
		<input type="hidden" name="CtaFinal" value="<cfif modoDet EQ "CAMBIO">#rsDetalle.PCRregla#</cfif>">
		<!--- HIDDENS --->
		<cfif isdefined("Form.PageNum")>
			<input type="hidden" name="PageNum" value="#Form.PageNum#">
		<cfelseif isdefined("Form.PageNum_lista")>
			<input type="hidden" name="PageNum" value="#Form.PageNum_lista#">
		</cfif>
		<cfif isdefined("Form.filtro_PCRid")>
			<input type="hidden" name="filtro_PCRid" value="#Form.filtro_PCRid#">
		</cfif>
		<cfif isdefined("Form.filtro_Cmayor")>
			<input type="hidden" name="filtro_Cmayor" value="#Form.filtro_Cmayor#">
		</cfif>
		<cfif isdefined("Form.filtro_Oformato")>
			<input type="hidden" name="filtro_Oformato" value="#Form.filtro_Oformato#">
		</cfif>
		<cfif isdefined("Form.filtro_PCRregla")>
			<input type="hidden" name="filtro_PCRregla" value="#Form.filtro_PCRregla#">
		</cfif>
		<cfif isdefined("Form.filtro_PCRvalida")>
			<input type="hidden" name="filtro_PCRvalida" value="#Form.filtro_PCRvalida#">
		</cfif>
		<cfif isdefined("Form.filtro_PCRdesde")>
			<input type="hidden" name="filtro_PCRdesde" value="#Form.filtro_PCRdesde#">
		</cfif>
		<cfif isdefined("Form.filtro_PCRhasta")>
			<input type="hidden" name="filtro_PCRhasta" value="#Form.filtro_PCRhasta#">
		</cfif>
		<cfif isdefined("Form.filtro_ErrVal")>
			<input type="hidden" name="filtro_ErrVal" value="#Form.filtro_ErrVal#">
		</cfif>
        <cfif isdefined("Form.filtro_PCRGcodigo")>
			<input type="hidden" name="filtro_PCRGcodigo" value="#Form.filtro_PCRGcodigo#">
		</cfif>
		
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  <tr>
		  	<td colspan="9" class="tituloAlterno">
				<cfif modoDet EQ "CAMBIO">
				  Modificaci&oacute;n de Regla
				  <cfelse>
				  Nueva Regla
				</cfif>
			</td>
		  </tr>
		  <tr>
			<td align="right" nowrap class="fileLabel">Consecutivo:</td>
		    <td nowrap>
				<cfif modoDet EQ "CAMBIO">
					#rsDetalle.PCRid#
					<input name="PCRid" type="hidden" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);"  onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modoDet EQ "CAMBIO">#rsDetalle.PCRid#</cfif>">
				<cfelse>
					<input name="PCRid" type="text" size="15" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);"  onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modoDet EQ "CAMBIO">#rsDetalle.PCRid#</cfif>">
				</cfif>
			</td>
		    <td align="right" nowrap class="fileLabel">Oficina:</td>
		    <td nowrap>
				<input name="Oformato" type="text" id="Oformato" size="15" maxlength="10" value="<cfif modoDet EQ "CAMBIO">#rsDetalle.Oformato#</cfif>">
			</td>
		    <td align="right" nowrap class="fileLabel">Regla de Validaci&oacute;n:</td>
		  	<td colspan="1" nowrap>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td>
						<input type="text" name="Cmayor" maxlength="4" size="4" width="100%" onBlur="javascript:CargarCajas(this.value)" value="<cfif modoDet EQ "CAMBIO">#rsDetalle.Cmayor#</cfif>">
					</td>
					<td>
						<iframe marginheight="0" 
						marginwidth="0" 
						scrolling="no" 
						name="cuentasIframe" 
						id="cuentasIframe" 
						width="100%" 
						height="25" 
						<cfif modoDet EQ "CAMBIO">
							src="/cfmx/sif/Utiles/generacajas.cfm?Cmayor=#rsDetalle.Cmayor#&MODO=#modoDet#&formatocuenta=#rsDetalle.PCRregla#"
						</cfif>
						frameborder="0"></iframe>
					</td>
				  </tr>
				</table>
			</td>
            <!--- Nuevo Campo para el grupo de reglas de Validacion --->
            <td align="right" nowrap class="fileLabel">Grupo de Regla:</td>
            <td align="left" nowrap>
            	<input type="text" id="PCRGcodigo" maxlength="10" size="10" name="PCRGcodigo" value="<cfif modoDet EQ "CAMBIO">#rsDetalle.PCRGcodigo#</cfif>">
            </td>
		    <td nowrap>&nbsp;</td>
		  </tr>
		  <tr>
		    <td align="right" nowrap class="fileLabel">Fecha Inicio:</td>
		    <td nowrap><cfif modoDet EQ "CAMBIO">
                <cfset fdesde = LSDateFormat(rsDetalle.PCRdesde, 'dd/mm/yyyy')>
                <cfelse>
                <cfset fdesde = "">
              </cfif>
                <cf_sifcalendario form="form1" name="PCRdesde" value="#fdesde#"> </td>
		    <td align="right" nowrap class="fileLabel">Fecha Fin:</td>
		    <td nowrap><cfif modoDet EQ "CAMBIO">
                <cfset fhasta = LSDateFormat(rsDetalle.PCRhasta, 'dd/mm/yyyy')>
                <cfelse>
                <cfset fhasta = "">
              </cfif>
                <cf_sifcalendario form="form1" name="PCRhasta" value="#fhasta#"> </td>
		    <td align="right" nowrap class="fileLabel">
				<input name="PCRvalida" type="checkbox" id="PCRvalida" value="1" <cfif modoDet EQ "CAMBIO" and rsDetalle.PCRvalida EQ 'S'> checked</cfif>>
            </td>
		    <td nowrap><strong>Regla es V&aacute;lida</strong></td>
		    <td align="right" nowrap class="fileLabel">Referencia:</td>
		    <td nowrap>
				<!--- <input name="PCRref" type="text" id="PCRref" size="20" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this);"  onKeyUp="if(snumber(this,event)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modoDet EQ "CAMBIO">#rsDetalle.PCRref#</cfif>"> --->
                <input name="PCRref" type="text" id="PCRref" size="20" maxlength="18" style="text-align: right;"  onkeypress="return esNumero(event);" value="<cfif modoDet EQ "CAMBIO">#rsDetalle.PCRref#</cfif>">
            </td>
		    <td nowrap>&nbsp;</td>
		  </tr>
		  <tr>
		    <td align="right" nowrap class="fileLabel">Observaciones:</td>
		    <td colspan="5" nowrap>
				<input type="text" name="PCRdescripcion" maxlength="255" style="width: 100%" value="<cfif modoDet EQ "CAMBIO">#rsDetalle.PCRdescripcion#</cfif>">
            </td>
		    <td align="right" nowrap class="fileLabel">Referencia Sistema:</td>
	        <td nowrap>
				<input type="hidden" name="PCRrefsys" value="<cfif modoDet EQ "CAMBIO">#rsDetalle.PCRrefsys#</cfif>">
				<input type="text" name="PCRrefsys_text" size="30" value="<cfif modoDet EQ "CAMBIO">#rsDetalle.PCRrefsys_text#</cfif>" readonly>
				<a href="javascript: doConlisReglasN1();"><img src="/cfmx/sif/imagenes/Description.gif" border="0" title="Lista de Reglas"></a>
				<a href="javascript: eliminarRef();"><img src="/cfmx/sif/imagenes/Borrar01_S.gif" border="0" title="Eliminar Referencia"></a>
			</td>
		    <td nowrap>&nbsp;</td>
		  </tr>
		  <tr>
		    <td colspan="9" nowrap>&nbsp;</td>
		  </tr>
		  <tr>
		    <td colspan="8" align="center" nowrap>
				<cf_botones modo="#modoDet#">
			</td>
			<td>
				<a href="javascript: doConlisAyudaEV();"><img src="/cfmx/sif/imagenes/Help02_T.gif" border="0" title="Leyenda de Errores de Validaci&oacute;n"></a>
			</td>
	      </tr>
		  <tr>
		    <td colspan="9" align="center" nowrap>&nbsp;</td>
	      </tr>
		</table>
	</form>
	
	<form name="filtroLista" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0;">
		<input type="hidden" name="PCREIid" value="#Form.PCREIid#">
		<cfif modoDet EQ "CAMBIO">
			<input type="hidden" name="PCRid" value="#Form.PCRid#">
		</cfif>
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td align="center"><strong>Consec</strong></td>
			<td align="center"><strong>Oficina</strong></td>
			<td align="center"><strong>Mayor</strong></td>
			<td align="center"><strong>Regla</strong></td>
			<td align="center"><strong>V&aacute;lida</strong></td>
			<td align="center"><strong>Desde</strong></td>
			<td align="center"><strong>Hasta</strong></td>
			<td align="center"><strong>Error en Validaciones</strong></td>
		    <td align="center">&nbsp;</td>
		  </tr>
		  <tr>
		    <td align="center">
				<input type="text" name="filtro_PCRid" size="10" maxlength="10" onBlur="javascript: fm(this,0);"  onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif isdefined("Form.filtro_PCRid")>#Form.filtro_PCRid#</cfif>">
			</td>
		    <td align="center">
				<input type="text" name="filtro_Oformato" size="10" maxlength="10" value="<cfif isdefined("Form.filtro_Oformato")>#Form.filtro_Oformato#</cfif>">
			</td>
		    <td align="center">
				<input type="text" name="filtro_Cmayor" size="4" maxlength="4" value="<cfif isdefined("Form.filtro_Cmayor")>#Form.filtro_Cmayor#</cfif>">
			</td>
		    <td align="center">
				<input type="text" name="filtro_PCRregla" size="30" value="<cfif isdefined("Form.filtro_PCRregla")>#Form.filtro_PCRregla#</cfif>">
			</td>
		    <td align="center">
				<select name="filtro_PCRvalida">
					<option value="">Todas</option>
					<option value="S"<cfif isdefined("Form.filtro_PCRvalida") and Form.filtro_PCRvalida EQ "S"> selected</cfif>>S&iacute;</option>
					<option value="N"<cfif isdefined("Form.filtro_PCRvalida") and Form.filtro_PCRvalida EQ "N"> selected</cfif>>No</option>
				</select>
			</td>
		    <td align="center">
				<cfif isdefined("Form.filtro_PCRdesde")>
					<cfset fdesde = Form.filtro_PCRdesde>
				<cfelse>
					<cfset fdesde = "">
				</cfif>
				<cf_sifcalendario form="filtroLista" name="filtro_PCRdesde" value="#fdesde#">
			</td>
		    <td align="center">
				<cfif isdefined("Form.filtro_PCRhasta")>
					<cfset fhasta = Form.filtro_PCRhasta>
				<cfelse>
					<cfset fhasta = "">
				</cfif>
				<cf_sifcalendario form="filtroLista" name="filtro_PCRhasta" value="#fhasta#">
			</td>
		    <td align="center">
				<select name="filtro_ErrVal">
					<option value="">&nbsp;</option>
					<option value="0"<cfif isdefined("Form.filtro_ErrVal") and Form.filtro_ErrVal EQ "0"> selected</cfif>>Error en cualquier validaci&oacute;n</option>
					<option value="1"<cfif isdefined("Form.filtro_ErrVal") and Form.filtro_ErrVal EQ "1"> selected</cfif>>Error en Validaci&oacute;n 1</option>
					<option value="2"<cfif isdefined("Form.filtro_ErrVal") and Form.filtro_ErrVal EQ "2"> selected</cfif>>Error en Validaci&oacute;n 2</option>
					<option value="3"<cfif isdefined("Form.filtro_ErrVal") and Form.filtro_ErrVal EQ "3"> selected</cfif>>Error en Validaci&oacute;n 3</option>
					<option value="4"<cfif isdefined("Form.filtro_ErrVal") and Form.filtro_ErrVal EQ "4"> selected</cfif>>Error en Validaci&oacute;n 4</option>
					<option value="5"<cfif isdefined("Form.filtro_ErrVal") and Form.filtro_ErrVal EQ "5"> selected</cfif>>Error en Validaci&oacute;n 5</option>
					<option value="6"<cfif isdefined("Form.filtro_ErrVal") and Form.filtro_ErrVal EQ "6"> selected</cfif>>Error en Validaci&oacute;n 6</option>
					<option value="7"<cfif isdefined("Form.filtro_ErrVal") and Form.filtro_ErrVal EQ "7"> selected</cfif>>Error en Validaci&oacute;n 7</option>
                    <option value="8"<cfif isdefined("Form.filtro_ErrVal") and Form.filtro_ErrVal EQ "8"> selected</cfif>>Error en Validaci&oacute;n 8</option>
				</select>
			</td>
		    <td align="center">
				<input type="submit" name="btnFiltrar" value="Filtrar">
			</td>
		  </tr>
		  <tr>
		    <td colspan="9">&nbsp;</td>
	      </tr>
	  </table>
	</form>

	<cfquery name="rsListaImportacion" datasource="#Session.DSN#">
		select a.PCREIid, a.PCRid, a.Ecodigo, a.PCRGcodigo, a.Cmayor, a.PCEMid, a.Ocodigo, rtrim(a.Oformato) as Oformato, a.PCRref, a.PCRrefsys, 
				   case when a.PCRvalida = 'S' then '<img src=''/cfmx/sif/imagenes/checked.gif''>' else '<img src=''/cfmx/sif/imagenes/unchecked.gif''>' end as PCRvalida, 
				   a.PCRdescripcion, a.PCRregla, a.PCRdesde, a.PCRhasta, 
				   case when a.PCRerror1 = '1' then '<img src=''/cfmx/sif/imagenes/checked.gif''>' else '<img src=''/cfmx/sif/imagenes/unchecked.gif''>' end as PCRerror1, 
				   case when a.PCRerror2 = '1' then '<img src=''/cfmx/sif/imagenes/checked.gif''>' else '<img src=''/cfmx/sif/imagenes/unchecked.gif''>' end as PCRerror2, 
				   case when a.PCRerror3 = '1' then '<img src=''/cfmx/sif/imagenes/checked.gif''>' else '<img src=''/cfmx/sif/imagenes/unchecked.gif''>' end as PCRerror3, 
				   case when a.PCRerror4 = '1' then '<img src=''/cfmx/sif/imagenes/checked.gif''>' else '<img src=''/cfmx/sif/imagenes/unchecked.gif''>' end as PCRerror4, 
				   case when a.PCRerror5 = '1' then '<img src=''/cfmx/sif/imagenes/checked.gif''>' else '<img src=''/cfmx/sif/imagenes/unchecked.gif''>' end as PCRerror5, 
				   case when a.PCRerror6 = '1' then '<img src=''/cfmx/sif/imagenes/checked.gif''>' else '<img src=''/cfmx/sif/imagenes/unchecked.gif''>' end as PCRerror6, 
				   case when a.PCRerror7 = '1' then '<img src=''/cfmx/sif/imagenes/checked.gif''>' else '<img src=''/cfmx/sif/imagenes/unchecked.gif''>' end as PCRerror7, 
				   case when a.PCRerror8 = '1' then '<img src=''/cfmx/sif/imagenes/checked.gif''>' else '<img src=''/cfmx/sif/imagenes/unchecked.gif''>' end as PCRerror8, 
				   case when a.PCRerror9 = '1' then '<img src=''/cfmx/sif/imagenes/checked.gif''>' else '<img src=''/cfmx/sif/imagenes/unchecked.gif''>' end as PCRerror9, 
				   case when a.PCRerror10 = '1' then '<img src=''/cfmx/sif/imagenes/checked.gif''>' else '<img src=''/cfmx/sif/imagenes/unchecked.gif''>' end as PCRerror10, 
				   a.Usucodigo, a.Ulocalizacion, a.BMUsucodigo
				<cfif isdefined("Form.filtro_PCRid") and Len(Trim(Form.filtro_PCRid))>
				  ,'#Form.filtro_PCRid#' as filtro_PCRid
				</cfif>
				<cfif isdefined("form.filtro_Cmayor") and Len(Trim(form.filtro_Cmayor))>
				  ,'#Form.filtro_Cmayor#' as filtro_Cmayor
				</cfif>
				<cfif isdefined("Form.filtro_Oformato") and Len(Trim(Form.filtro_Oformato))>
				  ,'#Form.filtro_Oformato#' as filtro_Oformato
				</cfif>
				<cfif isdefined("Form.filtro_PCRvalida") and Len(Trim(Form.filtro_PCRvalida))>
				  ,'#Form.filtro_PCRvalida#' as filtro_PCRvalida
				</cfif>
				<cfif isdefined("Form.filtro_PCRregla") and Len(trim(form.filtro_PCRregla))>
				  ,'#Form.filtro_PCRregla#' as filtro_PCRregla
				</cfif>
				<cfif isdefined("form.filtro_PCRdesde") and Len(Trim(form.filtro_PCRdesde))>
				  ,'#Form.filtro_PCRdesde#' as filtro_PCRdesde
				</cfif>
				<cfif isdefined("form.filtro_PCRhasta") and Len(Trim(form.filtro_PCRhasta))> 
				  ,'#Form.filtro_PCRhasta#' as filtro_PCRhasta
				</cfif>
				<cfif isdefined("Form.filtro_ErrVal") and Len(Trim(Form.filtro_ErrVal))>
				  ,'#Form.filtro_ErrVal#' as filtro_ErrVal
				</cfif>
                <cfif isdefined("Form.filtro_PCRGcodigo") and Len(Trim(Form.filtro_PCRGcodigo))>
				  ,'#Form.filtro_PCRGcodigo#' as filtro_PCRGcodigo
				</cfif>
		from PCReglasDImportacion a
		where a.PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCREIid#">
		<cfif isdefined("Form.filtro_PCRid") and Len(Trim(Form.filtro_PCRid))>
			and a.PCRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.filtro_PCRid#">
		</cfif>
		<cfif isdefined("form.filtro_Cmayor") and Len(Trim(form.filtro_Cmayor))>
			and upper(a.Cmayor) like <cfqueryparam cfsqltype="cf_sql_char" value="%#UCase(Trim(form.filtro_Cmayor))#%">
		</cfif>
		<cfif isdefined("Form.filtro_Oformato") and Len(Trim(Form.filtro_Oformato))>
			and upper(a.Oformato) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(trim(Form.filtro_Oformato))#%">
		</cfif>
		<cfif isdefined("Form.filtro_PCRvalida") and Len(Trim(Form.filtro_PCRvalida))>
			and a.PCRvalida = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.filtro_PCRvalida#">
		</cfif>
         <cfif isdefined("Form.filtro_PCRGcodigo") and Len(Trim(Form.filtro_PCRGcodigo))>
			and '#Form.filtro_PCRGcodigo#' as filtro_PCRGcodigo
		</cfif>
		<cfif isdefined("Form.filtro_PCRregla") and Len(trim(form.filtro_PCRregla))>
			and (
				upper(a.PCRregla) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(form.filtro_PCRregla))#%">
				or
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Trim(form.filtro_PCRregla))#"> like '%' #_Cat# upper(a.PCRregla) #_Cat# '%'
			)
		</cfif>
		<cfif isdefined("form.filtro_PCRdesde") and Len(Trim(form.filtro_PCRdesde)) and isdefined("form.filtro_PCRhasta") and Len(Trim(form.filtro_PCRhasta))>
			and a.PCRdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.filtro_PCRdesde#">
			and a.PCRhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.filtro_PCRhasta#">
		<cfelseif isdefined("form.filtro_PCRdesde") and Len(Trim(form.filtro_PCRdesde))>
			and a.PCRdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.filtro_PCRdesde#">
		<cfelseif isdefined("form.filtro_PCRhasta") and Len(Trim(form.filtro_PCRhasta))> 
			and a.PCRhasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.filtro_PCRhasta#">
		</cfif>
		<cfif isdefined("Form.filtro_ErrVal") and Len(Trim(Form.filtro_ErrVal))>
			<cfif Form.filtro_ErrVal EQ 0>
				and (
					a.PCRerror1 = '1'
				 or a.PCRerror2 = '1'
				 or a.PCRerror3 = '1'
				 or a.PCRerror4 = '1'
				 or a.PCRerror5 = '1'
				 or a.PCRerror6 = '1'
				 or a.PCRerror7 = '1'
                 or a.PCRerror8 = '1'
				)
			<cfelse>
				and a.PCRerror#Form.filtro_ErrVal# = '1'
			</cfif>
		</cfif>
		order by a.PCRid
	</cfquery>

	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
		conexion="#Session.DSN#"
		query="#rsListaImportacion#"
		desplegar="PCRid, Oformato, Cmayor, PCRregla, PCRvalida, PCRdesde, PCRhasta, PCRref, PCRerror1, PCRerror2, PCRerror3, PCRerror4, PCRerror5, PCRerror6, PCRerror7, PCRerror8"
		etiquetas="Consec, Oficina, Mayor, Regla, V&aacute;lida, Desde, Hasta, Ref, EV1, EV2, EV3, EV4, EV5, EV6, EV7, EV8"
		formatos="I,S,S,S,S,D,D,I,S,S,S,S,S,S,S,S"
		align="left,left,left,left,center,center,center,center,center,center,center,center,center,center,center,center"
		mostrar_filtro="false"
		filtrar_automatico="false"
		irA="ReglasImport.cfm"
		formName="listaform1"
		keys="PCREIid,PCRid"
		showEmptyListMsg="true"
		navegacion="#navegacion#"
		/>
		
		<br>
</cfif>
</cfoutput>

<cfif modo EQ "CAMBIO">
	<cf_qforms form="form1" objForm="objForm">
	<cf_qforms form="formEncabezado" objForm="objFormE">
</cfif>

<script language="javascript" type="text/javascript">
	<cfif modo EQ "CAMBIO">
		function funcModificarLote() {
			objFormE.PCREIdescripcion.required = true;
			objFormE.PCREIfecha.required = true;
		}

		function funcEliminarLote() {
			objFormE.PCREIdescripcion.required = false;
			objFormE.PCREIfecha.required = false;
		}

		function funcValidarReglas() {
			objFormE.PCREIdescripcion.required = false;
			objFormE.PCREIfecha.required = false;
		}

		function funcAplicar() {
			objFormE.PCREIdescripcion.required = false;
			objFormE.PCREIfecha.required = false;
		}

		function habilitarValidacion() {
			objForm.PCRid.required = true;
			objForm.Oformato.required = true;
			objForm.Cmayor.required = true;
			objForm.PCRdesde.required = true;
			objForm.PCRhasta.required = true;
			objForm.PCRGcodigo.required = true;
		}

		function deshabilitarValidacion() {
			objForm.PCRid.required = false;
			objForm.Oformato.required = false;
			objForm.Cmayor.required = false;
			objForm.PCRdesde.required = false;
			objForm.PCRhasta.required = false;
			objForm.PCRGcodigo.required = false;
		}
		objForm.PCRGcodigo.required = true;
		objForm.PCRGcodigo.description = "Grupo de Reglas";
		objForm.PCRid.required = true;
		objForm.PCRid.description = "Consecutivo";
		objForm.Oformato.required = true;
		objForm.Oformato.description = "Oficina";
		objForm.Cmayor.required = true;
		objForm.Cmayor.description = "Regla de Validacion";
		objForm.PCRdesde.required = true;
		objForm.PCRdesde.description = "Fecha Inicio";
		objForm.PCRhasta.required = true;
		objForm.PCRhasta.description = "Fecha Fin";

		objFormE.PCREIdescripcion.required = true;
		objFormE.PCREIdescripcion.description = "Descripcion";
		objFormE.PCREIfecha.required = true;
		objFormE.PCREIfecha.description = "Fecha";
	</cfif>

	function validar() {
		document.form1.CtaFinal.value = "";
		FrameFunction();
		return true;
	}

	function CargarCajas(Cmayor) {
		if (document.form1.Cmayor.value != '') {
			var a = '0000' + document.form1.Cmayor.value;
			a = a.substr(a.length-4, 4);
			document.form1.Cmayor.value = a;
		}
		var fr = document.getElementById("cuentasIframe");
		fr.src = "/cfmx/sif/Utiles/generacajas.cfm?Cmayor="+document.form1.Cmayor.value+"&MODO=ALTA"
	}

	//Dispara la funcion del iframe que retorna los datos de la cuenta
	function FrameFunction() {
		// RetornaCuenta2() es máscara completa, rellena con comodín
		window.parent.cuentasIframe.RetornaCuenta2();
	}

	function doConlisReglasN1() {
		var width = 850;
		var height = 480;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		var params = '?f=form1&p1=PCRrefsys&p2=PCRrefsys_text';
		var nuevo = window.open('/cfmx/sif/Utiles/ConlisReglasN1.cfm'+params,'Reglas','menu=no,scrollbars=no,top='+top+',left='+left+',width='+width+',height='+height);
		if (nuevo) nuevo.focus();
	}

	function doConlisAyudaEV() {
		var width = 600;
		var height = 200;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		var nuevo = window.open('ReglasImport-errorLegend.cfm','Reglas','menu=no,scrollbars=no,top='+top+',left='+left+',width='+width+',height='+height);
		if (nuevo) nuevo.focus();
	}

	function eliminarRef() {
		document.form1.PCRrefsys.value = '';
		document.form1.PCRrefsys_text.value = '';
	}
		
	function esNumero(evento)
	{		
		evento = (evento) ? evento : event;
		var charCode = (evento.charCode) ? evento.charCode : ((evento.keyCode) ? evento.keyCode : ((evento.which) ? evento.which : 0));
		var res = true;
		if (charCode > 31 && (charCode < 48 || charCode > 57))
		{
			res= false;
		}
		return res;
	}
</script>
