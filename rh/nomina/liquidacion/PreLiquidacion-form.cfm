<cfinvoke component="sif.Componentes.Translate"	method="Translate"	key="BTN_Agregar" default="Agregar"	xmlfile="/rh/generales.xml"	returnvariable="BTN_Agregar"/>

<cfinvoke key="MSG_Empleado" default="Empleado"	 returnvariable="MSG_Empleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Tipo_de_Accion" default="Tipo de Acción"	 returnvariable="MSG_Tipo_de_Accion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Fecha_Rige" default="Fecha Rige"	 returnvariable="MSG_Fecha_Rige" component="sif.Componentes.Translate" method="Translate"/>


<script src="/cfmx/sif/js/qForms/qforms.js"></script>

<cfoutput>

<form name="form1" method="post" action="/cfmx/rh/nomina/liquidacion/PreLiquidacion-sql.cfm">
    <table width="95%" border="0" cellspacing="0" cellpadding="2" align="center">
        <tr>
            <td align="right" class="fileLabel"><cf_translate key="LB_Empleado">Empleado</cf_translate>:</td>
            <td colspan="3"><cf_rhempleado tabindex="1" TipoId ="-1">&nbsp;</td>
        </tr>
    
        <tr> 
            <td align="right" nowrap class="fileLabel"><cf_translate key="LB_Tipo_de_Accion">Tipo de Acci&oacute;n</cf_translate>:</td>
            <td nowrap>
                 <cf_rhtipoaccion combo="true" tabindex="1" FiltroExtra="RHTcomportam = 2"> 
	        </td>
            <td align="right" nowrap class="fileLabel"><cf_translate key="LB_Fecha_Rige">Fecha Rige</cf_translate>:</td>
            <td nowrap>
                <cfset fecha = LSDateFormat(Now(), 'DD/MM/YYYY')>
                <cf_sifcalendario form="form1" value="#fecha#" name="DLfvigencia" tabindex="3">	
            </td>
      </tr>
      <tr><td colspan="4" align="center">
      <input name="btnAgregar" type="submit" value="<cfoutput>#BTN_Agregar#</cfoutput>" tabindex="7">
      </td></tr>
      <tr>
      	<td colspan="4">
        	
           <!--- <cfinclude template="PreLiquidacion-listaform.cfm">--->
        </td>
      </tr>
   </table>
</form>
</cfoutput>
<cf_qforms> <!--- Siempre debe de ir al final despues del </form> --->

<script language="javascript" type="text/javascript">
<cfoutput>
	objForm.DEidentificacion.required = true;
	objForm.DEidentificacion.description = "#MSG_Empleado#";
	objForm.RHTcodigo.required = true;
	objForm.RHTcodigo.description = "#MSG_Tipo_de_Accion#";
	objForm.DLfvigencia.required = true;
	objForm.DLfvigencia.description = "#MSG_Fecha_Rige#";
</cfoutput>
</script>


