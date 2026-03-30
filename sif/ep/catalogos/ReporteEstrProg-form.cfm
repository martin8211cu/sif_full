
<cfif isdefined("form.ID_RepEstrProg") and len(trim(form.ID_RepEstrProg))>
	<cfset modo2 = 'CAMBIO'>
<cfelse>
	<cfset modo2 = 'ALTA'>
</cfif>

<cfquery name="rsReportes" datasource="asp">
<!---    select * from SProcesos
    where SScodigo='SIF' and
    SMcodigo='ESTRPROG'
--->
    select rtrim(ltrim(p.SPcodigo)) SPcodigo,p.SPdescripcion,p.SPorden from dbo.SProcesos p
    inner join dbo.SMenues m
    on p.SMcodigo=m.SMcodigo and p.SPcodigo=m.SPcodigo
    where p.SScodigo='SIF' and p.SMcodigo='ESTRPROG'
    and m.SMNcodigoPadre in (select SMNcodigo from dbo.SMenues where upper(SMNtitulo) like upper('Reporte%') and
    SScodigo='SIF' and SMcodigo='ESTRPROG')
    order by p.SPorden
</cfquery>


<cfquery name="rsCGReEstrProg" datasource="#Session.DSN#">
	select rtrim(ltrim(SPcodigo)) SPcodigo,ID_Firma from CGReEstrProg
	<cfif modo2 eq 'CAMBIO'>
       	where ID_RepEstrProg = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID_RepEstrProg#">
	</cfif>
</cfquery>
<!--- <cf_dump var="#rsCGReEstrProg#"> --->

<cfquery name="rsReporte" dbtype="query">
    select rsReportes.SPcodigo,rsReportes.SPdescripcion from rsReportes
   		where rsReportes.SPcodigo
		<cfif modo2 EQ 'ALTA'> NOT </cfif> IN (#trim(ListQualify(ValueList(rsCGReEstrProg.SPcodigo),"'"))#)
	order by rsReportes.SPorden
</cfquery>


<cfquery name="rsEstrProg" datasource="#Session.DSN#">
    select ID_Estr,EPcodigo,EPdescripcion from CGEstrProg
    where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsEstrProgFirma" datasource="#Session.DSN#">
    select ID_Firma,Fdescripcion from CGEstrCatFirma
    where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
</cfquery>


<cfoutput>
	<fieldset>
	<legend><strong>Relaci&oacute;n reporte por estructura</strong>&nbsp;</legend>
	<form name="form" method="post" action="ReporteEstrProg-sql.cfm" style="margin: 0;">
    	<cfif isdefined("form.ID_RepEstrProg") and len(trim(form.ID_RepEstrProg))>
			<input type="hidden" name="ID_RepEstrProg" value="#Form.ID_RepEstrProg#" tabindex="-1">
        </cfif>
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
            <tr>
                <td align="left"><strong>Reporte:</strong>
                    <select name="SPcodigo" tabindex="1"
                        onChange=<!---"javascript:this.form.action='ReporteEstrProg.cfm?ID_RepEstrProg=#form.ID_RepEstrProg#';this.form.submit();"--->>
                        <cfloop query="rsReporte">
                            <option value="#rsReporte.SPcodigo#"
                                <cfif modo2 NEQ "ALTA" or isdefined("form.SPcodigo")>
                                        <cfif (rsReporte.SPcodigo EQ form.SPcodigo)>
                                            selected
                                        </cfif>
                                </cfif>>
                                #rsReporte.SPcodigo# : #rsReporte.SPdescripcion#
                            </option>
                        </cfloop>
                    </select>
          		</td>

                <td>
                    <strong>Estructura Program&aacute;tica:</strong>
                   <select name="ID_Estr" tabindex="2" >
						<cfloop query="rsEstrProg">
                            <option value="#rsEstrProg.ID_Estr#"
                                <cfif modo2 NEQ "ALTA" or isdefined("form.ID_Estr")>
                                        <cfif (rsEstrProg.ID_Estr EQ form.ID_Estr)>
                                            selected
                                        </cfif>
                                </cfif>>
                                #rsEstrProg.EPcodigo# : #rsEstrProg.EPdescripcion#
                            </option>
                        </cfloop>
                    </select>
                </td>
			</tr>
            <tr>
				<td>&nbsp</td>
				<td>
                    <strong>Firma:</strong>
                   <select name="ID_Firma" tabindex="2" >
						<option value=""> Ninguno </option>
                        <cfloop query="rsEstrProgFirma">
                            <option value="#rsEstrProgFirma.ID_Firma#"
                                <cfif modo2 NEQ "ALTA" or isdefined("form.ID_Firma")>
                                        <cfif (rsEstrProgFirma.ID_Firma EQ rsCGReEstrProg.ID_Firma)>
                                            selected
                                        </cfif>
                                </cfif>>
                                #rsEstrProgFirma.Fdescripcion#
                            </option>
                        </cfloop>
                    </select>
                </td>
            </tr>
            <tr>
            	<td colspan="4">&nbsp;</td>
            </tr>
            <tr>
                <td colspan="4">
                    <cfif modo2 NEQ "ALTA">
                        <cf_botones values="Eliminar,Nuevo,Modificar" tabindex="2">
                    <cfelse>
                        <cf_botones values="Agregar" tabindex="2">
					</cfif>
                </td>
            </tr>
    	</table>
	</form>
	</fieldset>
</cfoutput>

<!---<cf_qforms form="form2" objForm="objForm2">
<script language="JavaScript" type="text/javascript">
		objForm.EPCPdescripcion.description = "Descripción";

		objForm.EPCPdescripcion.required = true;

		<cfif modo2 NEQ 'ALTA'>
			document.form2.EPCPdescripcion.focus();
		<cfelse>
			document.form2.EPCPcodigo.focus();
			objForm.EPCPcodigo.description   = "Código";
			objForm.EPCPcodigo.required      = true;
		</cfif>
</script>
--->