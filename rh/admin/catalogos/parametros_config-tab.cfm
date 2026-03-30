<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Title" Default="Configuracion de Parametros" returnvariable="LB_Title"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Codigo" Default="Codigo" returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripcion" returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Modulo" Default="Modulo" returnvariable="LB_Modulo"/>


<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td colspan="2">
            <cfinclude template="/home/menu/pNavegacion.cfm">
        </td>
    </tr>
    <tr>
        <td width="50%" valign="top">
            <cfquery name="rsParametros" datasource="#session.dsn#">
                select Pcodigo,Pdescripcion, Ecodigo
                from RHParametros
                where Adicional = 1 and Ecodigo=#session.Ecodigo#
            </cfquery>
            <table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
                <tr>
                  <td align="center"> <fieldset>
                   <table align="center" width="100%">
                      <tr>
                        <td nowrap><b>C&oacute;digo</b></td>
                        <td nowrap><b>Descripci&oacute;n</b></td>
                        <td nowrap>&nbsp;</td>
                      </tr>
                      <cfoutput query="rsParametros">
                        <tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
                          <td nowrap>#Pcodigo#</td>
                          <td nowrap>#Pdescripcion#</td>
                          <td nowrap>
                            <a href="Parametros.cfm?tab=8&Pcodigo=#Pcodigo#"><img alt="Editar elemento" src="/sif/imagenes/edit_o.gif" width="16" height="16"></a>
                          </td>
                        </tr>
                      </cfoutput>
                      <tr>
                        <td nowrap><input type="hidden" name="Eulin"></td>
                        <td nowrap>&nbsp;</td>
                      </tr>
                    </table>
                    </fieldset></td>
                </tr>
              </table>
        </td>
        <td width="50%">
            <cfinclude template="parametros_config-tab-form.cfm">
        </td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
</table>



<script>
    function EditarParam(pcodigo) {
			alert(pcodigo);
		}
</script>