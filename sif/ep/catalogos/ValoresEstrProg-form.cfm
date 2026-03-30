<cfif isdefined("form.ID_EstrCtaVal") and len(trim(form.ID_EstrCtaVal))>
    <cfset modo2 = 'CAMBIO'>
    <cfelse>
    <cfset modo2 = 'ALTA'>
</cfif>

<cfif isdefined("url.fID_EstrCtaVal") and len(trim(url.fID_EstrCtaVal))>
    <cfset form.ID_EstrCtaVal = #url.fID_EstrCtaVal#>
</cfif>

<cfquery name="rsCuentaMayor" datasource="#Session.DSN#">
	select CGEPCtaMayor from CGEstrProgCtaM
    where ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTiposRep.ID_Estr#">
</cfquery>

<cfquery name="rsForm" datasource="#Session.DSN#">
	select ID_EstrCtaVal, ID_Estr, PCEcatid, EPCPcodigo, EPCPdescripcion, SoloHijos, ID_Grupo, EPCPcodigoref, EPCPnota
	from CGEstrProgVal
	where ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTiposRep.ID_Estr#">
    <cfif isdefined("form.ID_EstrCtaVal") and Len(Trim(form.ID_EstrCtaVal))>
        and ID_EstrCtaVal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID_EstrCtaVal#">
    </cfif>
</cfquery>

<cfquery name="rsTiposGrupos" datasource="#Session.DSN#">
    select ID_Grupo, ID_Estr, EPGcodigo, EPGdescripcion
    from CGGrupoCtasMayor
    where ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTiposRep.ID_Estr#">
    and EPTipoAplica = 2
</cfquery>

<cfset LB_Titulo = t.Translate('LB_Titulo','Clasificadores al Plan')>
<cfset LB_Codigo = t.Translate('LB_Codigo','C&oacute;digo')>
<cfset LB_Descripcion = t.Translate('LB_Descripcion','Descripci&oacute;n')>
<cfset LB_PlanContable = t.Translate('LB_PlanContable','Plan Contable')>
<cfset LB_CapturarCuentaMayor = t.Translate('LB_CapturarCuentaMayor','Capturar cuenta de mayor para la estructura')>
<cfset LB_ValoresHijo = t.Translate('LB_ValoresHijo','Valores Hijo')>
<cfset LB_Grupo = t.Translate('LB_Grupo','Grupo')>
<cfset LB_ReferenciaNota = t.Translate('LB_ReferenciaNota','Referencia Nota')>
<cfset LB_Nota = t.Translate('LB_Nota','Nota')>

<cfoutput>
    <fieldset>
    <legend><strong>#LB_Titulo#</strong>&nbsp;</legend>
<form name="form2" method="post" action="ValoresEstrProg-sql.cfm" style="margin: 0;">
    <cfif isdefined("Form.PageNum_lista") and Len(Trim(Form.PageNum_lista))>
            <input type="hidden" name="PageNum_lista" value="#Form.PageNum_lista#" tabindex="-1">
        <cfelseif isdefined("Form.PageNum") and Len(Trim(Form.PageNum))>
            <input type="hidden" name="PageNum_lista" value="#Form.PageNum#" tabindex="-1">
    </cfif>
    <cfif isdefined("form.ID_EstrCtaVal") and Len(Trim(form.ID_EstrCtaVal))>
            <input type="hidden" name="ID_EstrCtaVal" value="#form.ID_EstrCtaVal#" tabindex="-1">
    </cfif>

        <input type="hidden" name="ID_Estr" value="#rsTiposRep.ID_Estr#" tabindex="-1">

    <cfif isdefined("Form.fID_Estr") and Len(Trim(Form.fID_Estr))>
            <input type="hidden" name="fID_Estr" value="#Form.fID_Estr#" tabindex="-1">
    </cfif>

    <table width="100%" border="0" cellspacing="0" cellpadding="2">
    <tr>
    <td align="left"><strong>#LB_Codigo#:</strong></td>
<td>
        <input name="EPCPcodigo" <cfif modo2 NEQ "ALTA"> class="cajasinbordeb" readonly tabindex="-1" <cfelse>
               tabindex="1"</cfif> type="text" value="<cfif modo2 NEQ "ALTA">#rsForm.EPCPcodigo#</cfif>"
               size="5" maxlength="5" />
</td>
    <td>&nbsp;</td>
<td align="left"><strong>#LB_Grupo#:</strong></td>
<td align="left">
<select name="ID_Grupo" tabindex="2" onChange="">
    <option value=0 selected="selected">Ninguno</option>
    <cfloop query="rsTiposGrupos">
            <option value="#rsTiposGrupos.ID_Grupo#"
            <cfif modo2 NEQ "ALTA" or isdefined("rsForm.ID_Grupo")>
                <cfif (rsTiposGrupos.ID_Grupo EQ rsForm.ID_Grupo)>
                    selected
                </cfif>
            </cfif>>
            #rsTiposGrupos.EPGcodigo# : #rsTiposGrupos.EPGdescripcion#
            </option>
    </cfloop>
    </select>
    </td>
    </tr>
    <tr>
    <td align="left"><strong>#LB_Descripcion#:</strong></td>
<td colspan="5">
        <input type="text" name="EPCPdescripcion" maxlength="130" size="130" id="EPCPdescripcion" tabindex="1" style="border-spacing:inherit" value="<cfif modo2 NEQ 'ALTA'>#trim(rsForm.EPCPdescripcion)#</cfif>"/>
</td>
</tr>
<tr>
<td align="left" nowrap="nowrap">
<strong>#LB_PlanContable#:</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
<td colspan="2">
    <cfif rsCuentaMayor.RecordCount gt 0 >
        <cfif modo2 Neq "ALTA">
            <cfparam name="form.PCDcatid" default="1">
            <cfquery name="rsValores" datasource="#Session.DSN#">
    	            	        select distinct cg.ID_Estr,m.PCEcatid,b.PCEcodigo,b.PCEdescripcion
        	            	    from CGEstrProgCtaM cg
            	            	inner join CtasMayor c
                	        	on cg.CGEPCtaMayor=c.Cmayor
                    	    	inner join PCNivelMascara m
                        	    on c.PCEMid=m.PCEMid
                            	inner join CGEstrProgVal cv
	                            on cg.ID_Estr=cv.ID_Estr
    	                        left outer join PCECatalogo b
        	                        on b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
            	                    and b.PCEcatid = m.PCEcatid
                	        	where
								 	cv.ID_EstrCtaVal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID_EstrCtaVal#">
									 and PCEcodigo is not NULL
							</cfquery>
            <cfelse>
            <cfquery name="rsValores" datasource="#Session.DSN#">
        	    	           	select distinct cg.ID_Estr,m.PCEcatid,b.PCEcodigo,b.PCEdescripcion
                    	        from CGEstrProgCtaM cg
                        	    inner join CtasMayor c
	                            on cg.CGEPCtaMayor=c.Cmayor
    	                        inner join PCNivelMascara m on c.PCEMid=m.PCEMid
        	                    left outer join PCECatalogo b
            	                on b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
                	            and b.PCEcatid = m.PCEcatid
	                	        where m.PCEcatid <> 0
    	                	    and cg.ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTiposRep.ID_Estr#">
            </cfquery>
        </cfif>
        <select name="PCEcatid" tabindex="2" onChange="">
        <cfloop query="rsValores">
                <option value="#rsValores.PCEcatid#"
                <cfif modo2 NEQ "ALTA" or isdefined("form.PCEcatid")>
                    <cfif (rsValores.PCEcatid EQ form.PCEcatid)>
                        selected
                    </cfif>
                </cfif>>
                #rsValores.PCEcodigo# : #rsValores.PCEdescripcion#
                </option>
        </cfloop>
        </select>
        </td>
        <cfelse>
            <strong>#LB_CapturarCuentaMayor#</strong>
    </cfif>
        </td>
    </tr>
    <tr>
    <td><input type="checkbox" name="chcHijo" id="chcHijo" align="left" <cfif #modo2# eq 'CAMBIO' and rsForm.SoloHijos EQ 1>checked</cfif>>#LB_ValoresHijo#</td>
</tr>
<tr>
<td><strong>#LB_ReferenciaNota#</strong></td>
<td><strong>#LB_Nota#</strong></td>
</tr>
<tr>
<td>
        <input type="text" name="EPCPcodigoref" maxlength="5" size="5" id="EPCPcodigoref" tabindex="1" style="border-spacing:inherit" value="<cfif modo2 NEQ 'ALTA'>#trim(rsForm.EPCPcodigoref)#</cfif>"/>
</td>
<td colspan="5">
        <input type="text" name="EPCPnota" maxlength="250" size="100" id="EPCPnota" tabindex="1" style="border-spacing:inherit" value="<cfif modo2 NEQ 'ALTA'>#trim(rsForm.EPCPnota)#</cfif>"/>
</td>
</tr>
<tr>
<td colspan="5">
    <cfif modo2 NEQ "ALTA">
					<cf_botones values="Eliminar,Nuevo,Modificar" tabindex="2">
				<cfelse>
            		<cfif rsCuentaMayor.RecordCount gt 0 >
        <cf_botones values="Agregar" tabindex="2">
    </cfif>
				</cfif>
    </td>
    </tr>
        <tr>
            <td colspan="5">&nbsp;</td>
        </tr>
    </table>
    </form>
    </fieldset>
</cfoutput>

<cf_qforms form="form2" objForm="objForm2">
<script language="JavaScript" type="text/javascript">

document.form2.EPCPdescripcion.required = true;
<cfif modo2 NEQ 'ALTA'>
    document.form2.EPCPcodigo.required = false;
    <cfelse>
    document.form2.EPCPcodigo.required = true;
</cfif>

<!---	<cfif modo2 EQ 'ALTA'>
            <!---objForm.EPCPdescripcion.description = "Descripción";
            objForm.EPCPdescripcion.required = true;
            document.form2.EPCPdescripcion.focus();
        <cfelse>--->
            document.form2.EPCPcodigo.focus();
            objForm.EPCPcodigo.description   = "Código";
            objForm.EPCPcodigo.required      = true;
        </cfif>--->

</script>
