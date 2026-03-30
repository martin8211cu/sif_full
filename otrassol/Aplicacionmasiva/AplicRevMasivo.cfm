
<!--- Modificado por Gabriel Ernesto Sanchez Huerta  para  AppHost  06/09/2010 --->

<cfif isdefined('url.tipoCuenta') >
	<cfset form.tipoCuenta = url.tipoCuenta>
</cfif>

<cfquery name="rsQuery" datasource="#session.dsn#">
    <cfif #form.tipoCuenta# EQ 0>
        select
        a.CCTcodigo,a.Ddocumento,b.CCTCodigoRef 
        from Documentos a
        inner join CCTransacciones b
        ON b.Ecodigo   = a.Ecodigo
        AND b.CCTcodigo = a.CCTcodigo
        AND b.CCTestimacion = 1
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        and a.Dsaldo <> 0.00	
        and a.Dsaldo = a.Dtotal
    <cfelse>
        select
        a.CPTcodigo,a.IDdocumento,a.Ddocumento 
        from EDocumentosCP a        
        inner join CPTransacciones b
        ON b.Ecodigo   = a.Ecodigo
        AND b.CPTcodigo = a.CPTcodigo
        AND b.CPTestimacion = 1
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        and a.EDsaldo <> 0.00				
        and a.EDsaldo = a.Dtotal
    </cfif>
</cfquery>




<cf_templateheader title="Reversión Masiva de Estimación">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reverso Masivo de Estimaci&oacute;n'>
    <cfinclude template="../../sif/portlets/pNavegacion.cfm">
    <cfoutput>
    <br><table width="99%" align="center" border="0" cellpadding="0" cellspacing="0"><tr>
	<td>
          <form action="StatusReverso.cfm?show_process=1" method="post" name="lista" style="margin:0;" onSubmit="javascript: return funcAplicar()" target="proceso_importador">
          <input name="tipoCuenta" type="hidden" tabindex="-1" value= "#form.tipoCuenta#">
          <table width="100%" border="1">
            <tr>
<!---                    <td>
        #application.myappvarCC#
        </td>
--->
                <td width="15%" align = "left" nowrap>&nbsp;&nbsp;&nbsp;<strong>Tipo de reversi&oacute;n</strong> :</td>
                <td width="5
                1%" nowrap>
                <select name="TIPO">
                    <option value="">(Escoja un Tipo de Reversión...)</option>
                    <option value="false">Por cuenta contable de balance</option>
                    <option value="true">Por cuenta contable de origen</option>
                </select>
                </td>
                <td align = "Center" nowrap><strong>Se reversar&aacute;n: #rsQuery.recordCount# Documentos</strong>
                </td>
                <td width="14%" align = "left" nowrap><input type="submit" name="btnFiltro"  value="Aplicar" /></td>
            </tr>
          </form>
        </table>
    <br></td></tr>
    <tr>
    	<td align="left">
            <iframe align="middle" src="about:blank" id="status_importador" name="status_importador" frameborder="0" style="width:950px" height="300">
            </iframe>
            <iframe align="middle" src="about:blank" id="proceso_importador" name="proceso_importador" frameborder="0">
            </iframe>
        </td>
    </tr>
    </table>
    
	<script language="JavaScript1.2" type="text/javascript">
        function funcAplicar() {
            if (document.lista.TIPO.value =='') 
            {
                alert('Debe seleccionar un Tipo de Reversión');
                return false;
            }
			
			if (confirm("¿Está seguro de que desea aplicar los documentos seleccionados?"))
			{
				document.getElementById("status_importador").src="StatusReverso.cfm?show_status=1";
				return true;
			}
			else
			{
				return false;
			}
        }
    </script>
    
    </cfoutput>
    <cf_web_portlet_end>
<cf_templatefooter>