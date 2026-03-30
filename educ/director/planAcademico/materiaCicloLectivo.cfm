<cfquery name="rsLSTmateriaCicloLectivo" datasource="#session.DSN#">
	Select convert(varchar,cl.CILcodigo) as CILcodigo
		, CILnombre
		, mcl.CILcodigo as CILcodigo2
	from CicloLectivo cl, MateriaCicloLectivo mcl
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and mcl.Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
	  and mcl.CILcodigo=*cl.CILcodigo
</cfquery>
<cfparam name="form.CILcodigo" default="">
<cfparam name="form.CILcodigoOPR" default="">
<cfif form.CILcodigo NEQ "">
	<cfquery name="rsMateriaCicloLectivo" datasource="#session.DSN#">
		Select MCLmetodologia
			, isnull(mcl.TRcodigo, cl.TRcodigo) as TRcodigo
			, isnull(mcl.PEVcodigo, cl.PEVcodigo) as PEVcodigo
			, isnull(mcl.MCLtipoCalificacion, cl.CILtipoCalificacion) as MCLtipoCalificacion
			, isnull(mcl.MCLpuntosMax, cl.CILpuntosMax) as MCLpuntosMax
			, isnull(mcl.MCLunidadMin, cl.CILunidadMin) as MCLunidadMin
			, isnull(mcl.MCLredondeo, cl.CILredondeo) as MCLredondeo
			, isnull(mcl.TEcodigo, cl.TEcodigo) as TEcodigo
			, isnull(mcl.MCLtipoCicloDuracion, cl.CILtipoCicloDuracion) as MCLtipoCicloDuracion
			, mcl.CILcodigo as CILcodigo2
		from CicloLectivo cl, MateriaCicloLectivo mcl
		where cl.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and cl.CILcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CILcodigo#">
		  and mcl.Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
		  and mcl.CILcodigo=*cl.CILcodigo
	</cfquery>
	<cfquery name="rsLSTmateriaCicloEvaluacion" datasource="#session.DSN#">
		Select convert(varchar,mce.MCEsecuencia) as MCEsecuencia
			, isnull(cie.CIEnombre, cil.CLTcicloEvaluacion + ' ordinario') as CIEnombre
		from MateriaCicloEvaluacion mce, CicloLectivo cil, CicloEvaluacion cie
		where mce.Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
		  and mce.CILcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CILcodigo#">
		  and cil.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and mce.CILcodigo=cil.CILcodigo
		  and mce.CIEcodigo*=cie.CIEcodigo
	</cfquery>

	<cfquery datasource="#Session.DSN#" name="rsTablaEvaluacion">
		Select 	convert(varchar,TEcodigo) as TEcodigo,
					TEnombre, TEtipo, ts_rversion
		from TablaEvaluacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
	</cfquery>
	<cfquery datasource="#Session.DSN#" name="rsMateriaCicloLectivoTipo">
		Select CLTcicloEvaluacion , Ecodigo , CLTciclos , CLTsemanas , ts_rversion       
		from CicloLectivoTipo
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
		order by CLTciclos desc
	</cfquery>
	<cfquery datasource="#Session.DSN#" name="rsTablaResultado">
		Select 	convert(varchar,TRcodigo) as TRcodigo,
					TRnombre,  ts_rversion
		from TablaResultado
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
	</cfquery>
	<cfquery datasource="#Session.DSN#" name="rsPlanEvaluacion">
		Select 	convert(varchar,PEVcodigo) as PEVcodigo,
					substring(PEVnombre,1,50) as PEVnombre,  ts_rversion
		from PlanEvaluacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
	</cfquery>
</cfif>
<form name="formMateriaCicloLectivo2" method="post" action="materiaCicloLectivo_SQL.cfm">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
  <td width="50%" valign="top">
  <table border="0" cellspacing="0" cellpadding="0">
          <tr bgcolor="#CCCCCC"> 
            <td width="44">&nbsp;</td>
            <td width="144"><strong>Tipos de Ciclo Lectivo</strong></td>
          </tr>
          <cfif isdefined('rsLSTmateriaCicloLectivo') and rsLSTmateriaCicloLectivo.recordCount GT 0>
            <cfoutput query="rsLSTmateriaCicloLectivo"> 
              <tr class="<cfif rsLSTmateriaCicloLectivo.currentRow mod 2 EQ 0>ListaPar<cfelse>ListaNon</cfif>"
			      onmouseover="GvarColorLista=style.backgroundColor; style.backgroundColor='##E4E8F3'; style.cursor='hand'" onmouseout="style.backgroundColor=GvarColorLista; style.cursor='default'"
				  onclick="	javascript: 
							document.formMateriaCicloLectivo2.CILcodigo.value=this.getElementsByTagName('INPUT')[0].value;
							document.formMateriaCicloLectivo2.action='';
							document.formMateriaCicloLectivo2.submit();
							"> 
                <td align="right" nowrap>
				<cfif #CILcodigo# EQ #form.CILcodigo#>
				  <img src="#Session.JSroot#/imagenes/lista/addressGo.gif" width="16" height="16"> 
				</cfif>
				<cfif CILcodigo2 eq "">
				  <img src="#Session.JSroot#/imagenes/iconos/check_off.gif">
				<cfelse>
				  <img src="#Session.JSroot#/imagenes/iconos/check_on.gif">
				</cfif>
                <input type="hidden" value="#CILcodigo#">
				</td>
                <td>#CILnombre#</td>
              </tr>
            </cfoutput> 
          </cfif>
        </table>
  </td>
 <td width="50%">
  		<table>
          <tr> 
            <td align="center" colspan="2">
<cfoutput> 
                <input type="hidden" name="MODO" value="CAMBIO">
                <input type="hidden" name="Mcodigo" value="#form.Mcodigo#">
                <input type="hidden" name="CILcodigo" id="CILcodigo" value="#form.CILcodigo#">
</cfoutput> 
<cfif form.CILcodigo NEQ ""> 
<cfoutput> 
			    <cfif rsMateriaCicloLectivo.CILcodigo2 EQ "">
				  <input type="submit" value="Agregar" name="btnMCLagregar"> 
                <cfelse>
                  <input type="submit" value="Modificar" name="btnMCLmodificar">
                  &nbsp; 
                  <input type="submit" value="Eliminar" name="btnMCLeliminar">
                  &nbsp; 
                  <input type="button" value="Perídos Eval." name="btnMCLperiodos">
                </cfif> 
			</td>
          </tr>
          <tr> 
            <td align="left" nowrap><strong>Los Cursos duran</strong></td>
            <td align="left" nowrap> <select name="MCLtipoCicloDuracion"
			<cfif rsMateriaCicloLectivo.CILcodigo2 NEQ "">
			  onChange="javascript: 
			  	if (this.value != document.formMateriaCicloLectivo2.MCLtipoCicloDuracionAnterior.value && 
					!confirm('PRECAUCION: Si modifica la duración del curso, se va a perder \nla programación de los Períodos de Evaluación.\n\n¿Desea realizar el cambio?')) 
				  this.value = document.formMateriaCicloLectivo2.MCLtipoCicloDuracionAnterior.value;"
			</cfif>
			>
                <option value="E" <cfif rsMateriaCicloLectivo.MCLtipoCicloDuracion EQ "E">SELECTED</cfif>>Solo 
                un Periodo Evaluacion</option>
                <option value="L" <cfif rsMateriaCicloLectivo.MCLtipoCicloDuracion EQ "L">SELECTED</cfif>>Todo 
                el Ciclo Lectivo</option>
              </select>
              <cfoutput>
                <input type="hidden" name="MCLtipoCicloDuracionAnterior" id="MCLtipoCicloDuracionAnterior" value="#rsMateriaCicloLectivo.MCLtipoCicloDuracion#">
              </cfoutput> </td>
          </tr>
          <tr> 
            <td align="left" nowrap>Tabla de Resultados</td>
            <td align="left" nowrap> <select name="TRcodigo" >
                </cfoutput> <cfoutput query="rsTablaResultado"> 
                  <option value="#rsTablaResultado.TRcodigo#" <cfif rsTablaResultado.TRcodigo EQ rsMateriaCicloLectivo.TRcodigo>selected</cfif>>#rsTablaResultado.TRnombre#</option>
                </cfoutput> <cfoutput> </select> </td>
          </tr>
          <tr> 
            <td align="left" nowrap>Plan de Evaluaci&oacute;n</td>
            <td align="left" nowrap> <select name="PEVcodigo" >
                </cfoutput> <cfoutput query="rsPlanEvaluacion"> 
                  <option value="#rsPlanEvaluacion.PEVcodigo#" <cfif rsPlanEvaluacion.PEVcodigo EQ rsMateriaCicloLectivo.PEVcodigo>selected</cfif>>#rsPlanEvaluacion.PEVnombre# 
                  </option>
                </cfoutput> <cfoutput> </select> </td>
          </tr>
          <tr> 
            <td align="left" nowrap>Tipo Calificaci&oacute;n</td>
            <td align="left" nowrap> <select name="MCLtipoCalificacion" id="MCLtipoCalificacion" tabindex="1" 
			    onChange="javascript: cambioTipoCalificacion(this);">
                <option value="1" <cfif rsMateriaCicloLectivo.MCLtipoCalificacion EQ "1">SELECTED</cfif>>Porcentaje</option>
                <option value="2" <cfif rsMateriaCicloLectivo.MCLtipoCalificacion EQ "2">SELECTED</cfif>>Puntaje</option>
                <option value="T" <cfif rsMateriaCicloLectivo.MCLtipoCalificacion EQ "T">SELECTED</cfif>>Tabla 
                de Evaluación</option>
              </select> </td>
          </tr>
          <tr id="trTipoCalifica1"> 
            <td align="left" nowrap>&nbsp;</td>
            <td align="left" nowrap> <div style="margin: 0" id="divTipoCalifica2"> 
                <table>
                  <tr> 
                    <td> Puntaje M&aacute;x.</td>
                    <td> <input name="MCLpuntosMax" type="text" id="MCLpuntosMax" size="6" maxlength="6"  value="#rsMateriaCicloLectivo.MCLpuntosMax#" style="text-align: right;" onBlur="javascript:fm(this,0); "  onFocus="javascript: this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"> 
                    </td>
                  </tr>
                  <tr> 
                    <td> Unidad M&iacute;n.</td>
                    <td> <input name="MCLunidadMin" type="text" id="MCLunidadMin" size="6" maxlength="6"  value="#rsMateriaCicloLectivo.MCLunidadMin#" style="text-align: right;" onBlur="javascript:fm(this,2);"  onFocus="javascript: this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"> 
                    </td>
                  </tr>
                  <tr> 
                    <td> Redondeo </td>
                    <td> <select name="MCLredondeo" id="MCLredondeo" tabindex="1">
                        <option value="0" <cfif rsMateriaCicloLectivo.MCLredondeo EQ "0">SELECTED</cfif>>Al 
                        más cercano</option>
                        <option value="0.499" <cfif rsMateriaCicloLectivo.MCLredondeo EQ "0.499">SELECTED</cfif>>Hacia 
                        Arriba</option>
                        <option value="-0.499" <cfif rsMateriaCicloLectivo.MCLredondeo EQ "-0.499">SELECTED</cfif>>Hacia 
                        Abajo</option>
                      </select> </td>
                  </tr>
                </table>
              </div>
              <div style="margin: 0" id="divTipoCalificaT">Tabla Evaluaci&oacute;n<br>
                <select name="TEcodigo">
                  </cfoutput> <cfoutput query="rsTablaEvaluacion"> 
                    <option value="#rsTablaEvaluacion.TEcodigo#" <cfif rsTablaEvaluacion.TEcodigo EQ rsMateriaCicloLectivo.TEcodigo>selected</cfif>>#rsTablaEvaluacion.TEnombre# 
                    </option>
                  </cfoutput> <cfoutput> 
                </select>
              </div></td>
          </tr>
          <tr> 
            <td align="left" nowrap valign="top"> <input type="checkbox" name="verMetodologia" value="1"
				 onClick="javascript: var obj = document.getElementById('MCLmetodologia'); if (this.checked) obj.rows = 5; else obj.rows = 1;"
				 >
              Metodologia</td>
            <td align="left" nowrap valign="top"> <textarea name="MCLmetodologia" id="MCLmetodologia" cols="20" rows="1"></textarea>
</cfoutput> 
</cfif> 
            </td>
          </tr>
          <tr> 
            <td colspan="2" align="left" valign="top" nowrap>
			  <table border="0" cellspacing="0" cellpadding="0">
					  <cfif isdefined('rsLSTmateriaCicloEvaluacion') and rsLSTmateriaCicloEvaluacion.recordCount GT 0>
					  <tr bgcolor="#CCCCCC"> 
						
                    <td><strong>Tipos de Períodos de Evaluaci&oacute;n a programar</strong></td>
					  </tr>
					    <cfoutput query="rsLSTmateriaCicloEvaluacion"> 
						  <tr class="<cfif rsLSTmateriaCicloEvaluacion.currentRow mod 2 EQ 0>ListaPar<cfelse>ListaNon</cfif>"
							  onmouseover="GvarColorLista=style.backgroundColor; style.backgroundColor='##E4E8F3'; style.cursor='hand'" onmouseout="style.backgroundColor=GvarColorLista; style.cursor='default'"
						  > 
							<td>
							  <input type="hidden" value="#rsLSTmateriaCicloEvaluacion.MCEsecuencia#">
							  #rsLSTmateriaCicloEvaluacion.CIEnombre#
							</td>
						  </tr>
						</cfoutput>
					  </cfif>
					</table>
			</td>
          </tr>
        </table>
      </td>
  </tr>
  </table>
  <script language="JavaScript">
    <cfif form.CILcodigo NEQ "">
	  cambioTipoCalificacion (document.getElementById("MCLtipoCalificacion"));
    </cfif>
	function cambioTipoCalificacion(obj){
		var conntrTipoCalifica1 	= document.getElementById("trTipoCalifica1");
		var conndivTipoCalifica2 	= document.getElementById("divTipoCalifica2");
		var conndivTipoCalificaT 	= document.getElementById("divTipoCalificaT");
	
		if(obj.value == '1'){
			document.getElementById("MCLpuntosMax").value = 100;
			document.getElementById("MCLunidadMin").value = 0.01;
			document.getElementById("MCLredondeo").value = "0";
			trTipoCalifica1.style.display = "none";
		}
		else
			trTipoCalifica1.style.display = "";
			
		if(obj.value == '2')
			conndivTipoCalifica2.style.display = "";
		else
			conndivTipoCalifica2.style.display = "none";
		if(obj.value == 'T')
			conndivTipoCalificaT.style.display = "";
		else
			conndivTipoCalificaT.style.display = "none";
	}
</script>		  

</form>