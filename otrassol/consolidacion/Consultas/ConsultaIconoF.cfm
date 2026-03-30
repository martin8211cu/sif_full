<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>

<cfset fnIconoF()>

<cf_templateheader title="Icono F Consolidado">
<cfinclude template="../../../sif/portlets/pNavegacionCG.cfm">
<form name="form1" method="post" action="ConsultaIconoF_SQL.cfm" onsubmit="return sinbotones()">

<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Icono F Consolidado'>
<cfoutput>
	<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<!---	<tr><td colspan="5" align="right"><cf_sifayudaRoboHelp name="imAyuda" imagen="1" Tip="true" width="500" url="Balance_comprobacion.htm"></td></tr>
--->	
        <tr> 
          <td nowrap> <div align="right"></div></td>
          <td width="25%" nowrap> <div align="right"></div></td>
          <td colspan="3">&nbsp;</td>
        </tr>
<!---        <tr>
            <td nowrap width="23%">&nbsp;</td>
            <td align="right" nowrap><strong>Empresa a Consultar:&nbsp;</strong> </td>	
            <td>		
                <cfquery name="rsEmpresas" datasource="#session.DSN#">
                    select Ecodigo, Edescripcion 
                    from Empresas
                    where Ecodigo in (Select Ecodigo from AnexoGEmpresaDet where GEid=#gpoElimina.Pvalor#) and
                          Ecodigo <> #session.Ecodigo#
                    order by Ecodigo
                </cfquery>			
                <select name="Empresa" id="Empresa" tabindex="1">
                    <cfloop query="rsEmpresas">
                        <option value="#rsEmpresas.Ecodigo#"> #rsEmpresas.Edescripcion# </option>
                    </cfloop>
                </select>
            </td>	
        </tr>                            
--->        <tr> 
            <td nowrap width="23%">&nbsp;</td>
            <td nowrap><div align="right"><strong>Periodo:&nbsp;</strong></div></td>
            <td width="52%" align="left">
                <select name="periodo" id=Periodo tabindex="2">
                    <option value="#periodo_actual.Pvalor#" >#periodo_actual.Pvalor#</option>
                    <cfloop step="-1" from="#periodo_actual.Pvalor-1#" to="#periodo_actual.Pvalor-3#" index="i"  >
                        <option value="#i#" >#i#</option>
                    </cfloop>
                </select>
            </td>
        </tr>
        <tr>
          <td nowrap >&nbsp;</td>
          <td nowrap><div align="right"><strong>Mes:&nbsp;</strong></div></td>
          <td width="52%">
            <select name="mes" size="1" tabindex="3">
              <option value="1" >Enero</option>
              <option value="2" >Febrero</option>
              <option value="3" >Marzo</option>
              <option value="4" >Abril</option>
              <option value="5" >Mayo</option>
              <option value="6" >Junio</option>
              <option value="7" >Julio</option>
              <option value="8" >Agosto</option>
              <option value="9" >Setiembre</option>
              <option value="10" >Octubre</option>
              <option value="11" >Noviembre</option>
              <option value="12" >Diciembre</option>
            </select>
            </td>
          </tr>
			<tr>
          <td nowrap >&nbsp;</td>
          <td nowrap><div align="right"><strong>Formato:&nbsp;</strong></div></td>
			  <td  >
				<select name="formato" tabindex="15">
					<option value="Excel">Excel</option>
					<option value="HTML">HTML</option>
				  </select>
			  </td>
			</tr>		
       	<tr>
          <td>&nbsp;</td>
        </tr>
		<tr> 
          <td colspan="5"> 
            <div align="center"> 
              <input type="submit" name="Submit" value="Consultar" tabindex="4">&nbsp;
            </div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
	</table>
</cfoutput>	
	<cf_web_portlet_end>
</form>
<cf_templatefooter>
	
<cffunction name="fnIconoF" output="no" access="private">
<!---	<cfquery name="gpoElimina" datasource="#Session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = #Session.Ecodigo#
		and Pcodigo = 1330
	</cfquery>
--->
	<cfquery name="periodo_actual" datasource="#Session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = #Session.Ecodigo#
		and Pcodigo = 30
	</cfquery>
</cffunction>