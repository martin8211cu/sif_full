<cfif isdefined('form.RHCRPTid')>
<cfquery name="rsDeducciones" datasource="#session.DSN#">
	select a.RHCCRPTid, a.TDid, b.TDcodigo, b.TDdescripcion
    from RHConceptosColumna a
    inner join TDeduccion b
    	on b.TDid = a.TDid
    where a.RHCRPTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCRPTid#">
</cfquery>
<cfquery name="rsIncidencias" datasource="#session.DSN#">
	select a.RHCCRPTid, a.CIid,b.CIcodigo, b.CIdescripcion
    from RHConceptosColumna a
    inner join CIncidentes b
    	on b.CIid = a.CIid
    where a.RHCRPTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCRPTid#">
</cfquery>
<cfquery name="rsCargas" datasource="#session.DSN#">
	select a.RHCCRPTid, a.DClinea,b.DCcodigo, b.DCdescripcion
    from RHConceptosColumna a
    inner join DCargas b
    	on b.DClinea = a.DClinea
    where a.RHCRPTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCRPTid#">
</cfquery>
</cfif>
<cfoutput>
<form name="form2" action="ReportesDinamicos-sql.cfm" method="post">
	<cfoutput>
    <input name="RHCRPTid" type="hidden" value="<cfif isdefined('form.RHCRPTid')>#RHCRPTid#</cfif>">
    <input name="RHRPTNid" type="hidden" value="<cfif isdefined('form.RHRPTNid')>#RHRPTNid#</cfif>">
    <input name="RHCCRPTid" type="hidden" value="">
    </cfoutput>
<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
  		<td align="right"><strong>#LB_CODIGO#:&nbsp;</strong></td>
		<td><input name="RHCRPTcodigo" type="text" tabindex="1" maxlength="12" value="<cfif modo NEQ 'ALTA' and modoD NEQ 'ALTA'>#rsFormD.RHCRPTcodigo#</cfif>"></td>
	</tr>
	<tr>
   		<td align="right"><strong>#LB_DESCRIPCION#:</strong>&nbsp;</td>
        <td><input name="RHCRPTdescripcion" type="text" tabindex="1" size="38" value="<cfif modo NEQ 'ALTA' and modoD NEQ 'ALTA'>#rsFormD.RHCRPTdescripcion#</cfif>"></td>
    </tr>
    <tr>
   		<td align="right"><strong>#LB_Origendedatos#:</strong>&nbsp;</td>
        <td>
            <select name="RHRPTNOrigen" id="RHRPTNOrigen">
              <option value="0" <cfif modo NEQ 'ALTA' and modoD NEQ 'ALTA' and rsFormD.RHRPTNOrigen EQ 0>selected="true"</cfif>>Empresa Actual</option>
              <option value="1" <cfif modo NEQ 'ALTA' and modoD NEQ 'ALTA' and rsFormD.RHRPTNOrigen EQ 1>selected="true"</cfif>>Otros Patronos</option>
              <option value="2" <cfif modo NEQ 'ALTA' and modoD NEQ 'ALTA' and rsFormD.RHRPTNOrigen EQ 2>selected="true"</cfif>>Expatronos</option>
            </select>
        </td>
    </tr>
     <tr>
   		<td align="right"><strong>#LB_Posicion#:</strong>&nbsp;</td>
        <td>
        <input name="RHCRPTPosicion" type="text" tabindex="1" size="38" value="<cfif modo NEQ 'ALTA' and modoD NEQ 'ALTA'>#rsFormD.RHRPTNcolumna#<cfelse>0</cfif>">
        </td>
    </tr>
    <tr>
    	<td colspan="2"><cf_botones modo="#modoD#" sufijo='D' form="form2" tabindex="1"></td>
    </tr>
    <tr>
    	<td colspan="2">&nbsp;</td>
   </tr>
    <cfif modoD NEQ 'ALTA'>
    <tr>
    	<td colspan="2" align="center">
        	<table width="90%" cellpadding="0" cellspacing="0">
            	<tr>
                	<td align="right" nowrap><strong>#LB_ConceptoDePago#:</strong>&nbsp;</td>
                    <td nowrap><cf_rhcincidentes tabindex="1" size="30" form="form2"></td>
                    <td><cf_botones values="+" names="AgregaI" tabindex="1"></td>
                </tr>
				<cfif isdefined('rsIncidencias') and rsIncidencias.REcordCount>
                	<tr><td colspan="3" class="tituloListas">#LB_ConceptosDePago#</td></tr>
                    <tr  class="tituloListas">
                    	<td>#LB_CODIGO#</td>
                        <td colspan="3">#LB_DESCRIPCION#</td>
                    </tr>
                    <cfloop query="rsIncidencias">
						<tr>
                        	<td>&nbsp;#CIcodigo#</td>
                            <td>&nbsp;#CIdescripcion#</td>
                            <td align="center">
                                <img src="/cfmx/rh/imagenes/Borrar01_S.gif" onclick="javascript: funcEliminar(#RHCCRPTid#,0); "  />
                            </td>
                        </tr>
					</cfloop>
                </cfif>
            	<tr><td>&nbsp;</td></tr>
                <tr>
                	<td align="right"><strong>#LB_Deduccion#:</strong>&nbsp;</td>
                    <td><cf_rhtipodeduccion form="form2" size="30" tabindex="1"></td>
                    <td><cf_botones values="+" names="AgregaD" tabindex="1"></td>
                </tr>
                <cfif isdefined('rsDeducciones') and rsDeducciones.REcordCount>
                	<tr><td colspan="3" class="tituloListas">#LB_Deducciones#</td></tr>
                    <tr  class="tituloListas">
                    	<td>#LB_CODIGO#</td>
                        <td colspan="2">#LB_DESCRIPCION#</td>
                    </tr>
                    <cfloop query="rsDeducciones">
						<tr>
                        	<td>&nbsp;#TDcodigo#</td>
                            <td>&nbsp;#TDdescripcion#</td>
                            <td align="center">
                                <img src="/cfmx/rh/imagenes/Borrar01_S.gif" onclick="javascript: funcEliminar(#RHCCRPTid#,1);"  />
                            </td>
                        </tr>
					</cfloop>
                </cfif>
                <tr><td>&nbsp;</td></tr>
                <tr>
                	<td align="right"><strong>#LB_Carga#:</strong>&nbsp;</td>
                    <td>
						<cf_conlis 
							campos="DCdescripcion,DClinea,ECauto,DCmetodo"
							asignar="DCdescripcion,DClinea,ECauto,DCmetodo"
							size="50,0,0,0"
							desplegables="S,N,N,N"
							modificables="N,N,N,N"						
							title="Lista de Cargas Obrero Patronales"
							tabla="DCargas a,ECargas b"
							columnas="a.ECid,ECdescripcion,DClinea,DCdescripcion,ECauto,DCmetodo,a.DCvaloremp,a.DCvalorpat"
							filtro="a.ECid=b.ECid
									and b.Ecodigo= #Session.Ecodigo# 
									order by a.ECid, DCdescripcion"
							filtrar_por="DCdescripcion"
							desplegar="DCdescripcion"
							etiquetas="#LB_DESCRIPCION#"
							formatos="S"
							align="left"								
							asignarFormatos="S,S,S,S"
							form="form2"
							showEmptyListMsg="true"
							Cortes="ECdescripcion"
							funcion="funcPreCarga"
							fparams="DCvaloremp,DCvalorpat"
						/>
					</td>
                    <td><cf_botones values="+" names="AgregaC" tabindex="1"></td>
                </tr>
                <cfif isdefined('rsCargas') and rsCargas.REcordCount>
                	<tr><td colspan="3" class="tituloListas">#LB_Cargas#</td></tr>
                    <tr  class="tituloListas">
                    	<td>#LB_CODIGO#</td>
                        <td colspan="2">#LB_DESCRIPCION#</td>
                    </tr>
                    <cfloop query="rsCargas">
						<tr>
                        	<td>&nbsp;#DCcodigo#</td>
                            <td>&nbsp;#DCdescripcion#</td>
                            <td align="center">
                                <img src="/cfmx/rh/imagenes/Borrar01_S.gif" onclick="javascript: funcEliminar(#RHCCRPTid#,1);"  />
                            </td>
                        </tr>
					</cfloop>
                </cfif>
            </table>
        </td>
    </tr>
    </cfif>
</table>
</form>
</cfoutput>
<cf_qforms form="form2"  objForm='objForm2'>
  <cf_qformsrequiredfield args="RHCRPTcodigo,#MSG_CODIGO#">
  <cf_qformsrequiredfield args="RHCRPTdescripcion,#MSG_DESCRIPCION#">
</cf_qforms>
<script type="text/javascript" language="javascript1.2">
	function funcEliminar(ID,tipo){
		var f = document.form2;
		if (confirm('<cfoutput>#MSG_DeseaEliminarElRegistro#</cfoutput>')){
			f.RHCCRPTid.value = ID;
			f.submit();	
		}
		return false;
	}
	function funcAgregaI(){
		var f = document.form2;
		if (f.CIid.value == ''){
			alert('<cfoutput>#MSG_DebeSeleccionarUnConceptoDePago#</cfoutput>');
			return false;
		}
		f.submit();
	}
	function funcAgregaD(){
		var f = document.form2;
		if (f.TDid.value == ''){
			alert('<cfoutput>#MSG_DebeSeleccionarUnaDeduccion#</cfoutput>');
			return false;
		}
		f.submit();
	}
	function funcAgregaC(){
		var f = document.form2;
		if (f.DClinea.value == ''){
			alert('<cfoutput>#MSG_DebeSeleccionarUnaCarga#</cfoutput>');
			return false;
		}
		f.submit();
	}
</script>