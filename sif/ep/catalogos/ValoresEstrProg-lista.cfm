<cfquery name="rsTiposRep" datasource="#Session.DSN#">
    select ID_Estr, EPcodigo, EPdescripcion
    from CGEstrProg
    where ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#fID_Estr#">
</cfquery>

<cfset filtro = "">

<cfif isdefined("Form.fID_Estr") and Len(Trim(Form.fID_Estr))>
    <cfset filtro = filtro & " and a.ID_Estr = " & Form.fID_Estr>
</cfif>

<cfset LB_ListaClasCtas = t.Translate('LB_ListaClasCtas','Lista de Clasificadores de Cuenta')>
<cfset LB_Clasificador = t.Translate('LB_Clasificador','Clasificador')>
<cfset LB_Plan = t.Translate('LB_Plan','Plan')>

<cfoutput>
    <cfset campos = "">
    <form name="form_2" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0;">
        <input type="hidden" name="fID_Estr" value="<cfif isdefined ("form.fID_Estr") and len(trim(form.fID_Estr))><cfoutput>#form.fID_Estr#</cfoutput></cfif>">
<!---<input type="hidden" name="ID_EstrCtaVal" value="<cfif isdefined ("form.ID_EstrCtaVal") and len(trim(form.ID_EstrCtaVal))><cfoutput>#form.ID_EstrCtaVal#</cfoutput></cfif>">--->

        <input name="tab" type="hidden" value="4">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
    <td class="tituloAlterno" align="center" style="text-transform: uppercase; ">
    <strong>#LB_ListaClasCtas#</strong>
</td>
</tr>
<tr>
<td valign="top">
    <cfif len(campos) gt 0>
        <cfif mid(trim(campos),len(trim(campos)),1) eq "," >
            <cfset campos = "," & mid(trim(campos),1,(len(trim(campos))-1)) & " ">
            <cfelse>
            <cfset campos = "," & campos & " ">
        </cfif>
    </cfif>
			<cfset params = '?tab=4'>
			<!--- <cfif isdefined("Form.fID_Estr") and Len(Trim(Form.fID_Estr))>
                <cfset params = params & " &fID_Estr = " & Form.fID_Estr>
            </cfif> --->
			<!--- <cfif isdefined("Form.ID_EstrCtaVal") and Len(Trim(Form.ID_EstrCtaVal))>
                <cfset params = params & " &ID_EstrCtaVal = " & Form.ID_EstrCtaVal>
            </cfif> --->
			<cfinvoke
        component="sif.Componentes.pListas"
        method="pLista"
        returnvariable="pListaRet"
        columnas="a.ID_EstrCtaVal, a.ID_Estr, a.PCEcatid, a.EPCPcodigo, a.EPCPdescripcion, b.PCEcodigo, b.PCEdescripcion, a.SoloHijos as chcHijo"
        tabla="CGEstrProgVal a
                        left outer join PCECatalogo b
                        on b.CEcodigo = #Session.CEcodigo#
                        and a.PCEcatid = b.PCEcatid"
        filtro="1=1 #PreserveSingleQuotes(filtro)# order by EPCPcodigo"
        desplegar="EPCPcodigo, EPCPdescripcion, PCEcodigo,PCEdescripcion"
        etiquetas="#LB_Clasificador#, #LB_Descripcion#, #LB_Plan#, #LB_Descripcion#"
        formatos="S,S,S,S"
        align="left, left, left, left"
        checkboxes="N"
        ira="CuentasEstrProg.cfm#params#"
        nuevo="CuentasEstrProg.cfm#params#"
        showLink="true"
        showemptylistmsg="true"
        incluyeform="false"
        formname="form_2"
        keys="PCEcatid, ID_EstrCtaVal"
        mostrar_filtro="true"
        filtrar_automatico="true"
        filtrar_por="a.EPCPcodigo, a.EPCPdescripcion, b.PCEcodigo, b.PCEdescripcion,' '"
        maxrows="50"
        navegacion="#navegacion#&tab=4"
        />
    </td>
    </tr>
        <tr>
            <td>&nbsp;</td>
        </tr>
    </table>
    </form>
</cfoutput>

