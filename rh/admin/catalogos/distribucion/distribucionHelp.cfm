<table width="100%" border="0">
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_se_realizara_de_la_siguiente_manera"
	Default="se realizar&aacute; de la siguiente manera:"
	returnvariable="se_realizara_de_la_siguiente_manera"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_La distribucion_contable"
	Default="La distribuci&oacute;n contable"
	returnvariable="distribucion_contable"/>    
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Salario"
	Default="Salario"
	returnvariable="MSG_Salario"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Incidencias"
	Default="Incidencias"
	returnvariable="MSG_Incidencias"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Cargas"
	Default="Cargas"
	returnvariable="MSG_Cargas"/>

  <cfoutput>
  <tr>
    <td nowrap="nowrap" >
		<font  style="font-size:11px; color:##0000FF">
        #distribucion_contable#
        </font>
	</td>
  <tr>
  <tr>
    <td nowrap="nowrap" >
		<font  style="font-size:11px; color:##0000FF">
        #se_realizara_de_la_siguiente_manera#
        </font>
	</td>
   </tr> 
  <tr>
    <td  >
		&nbsp;
	</td>
   </tr>   
  <cfif tabChoice eq 1>
      <tr>
        <td valign="top">
            <fieldset><legend>#MSG_Salario#</legend>
            <table width="100%" border="0" cellpadding="0" cellspacing="0" style="height:100px;">
              <tr>
                 <td align="justify">
                    <font  style="font-size:11px; color:##0000FF">Caso 1</font><font  style="font-size:10px">-Si no hay Distribuci&oacute;n Contable, el Salario se contabilizar&aacute; al Centro Funcional al cual pertenece la plaza del empleado.
                    </font>
                 </td>
              </tr>
              <tr>
                 <td>&nbsp;
                    
                 </td>
              </tr>
              <tr>
                 <td align="justify">
                    <font  style="font-size:11px; color:##0000FF">Caso 2</font><font  style="font-size:10px">-Si existe Distribuci&oacute;n Contable, el Salario se contabilizar&aacute; en los diferentes Centros Funcionales definidos en este mantenimiento, seg&uacute;n sus porcentajes.
                    </font>
                 </td>
              </tr>
            </table>	
            </fieldset>
        </td>
    </tr>
</cfif>
<cfif tabChoice eq 2>
    <tr>
        <td  valign="top">
            <fieldset><legend>#MSG_Incidencias#</legend>
            <table width="100%" border="0" cellpadding="0" cellspacing="0" style="height:100px;">
              <tr>
                 <td align="justify">
                    <font  style="font-size:11px; color:##0000FF">Caso 1</font><font  style="font-size:10px">-Cuando el Concepto de Pago se registra indicando el Centro Funcional de Servicio, entonces se contabilizar&aacute; 
                    en el Centro Funcional de Servicio, sin tomar en cuenta si existe o no Distribuci&oacute;n Contable.
                    </font>
                 </td>
              </tr>
              <tr>
                 <td>&nbsp;
                    
                 </td>
              </tr>
              <tr>
                 <td align="justify">
                    <font  style="font-size:11px; color:##0000FF">Caso 2</font><font  style="font-size:10px">-Cuando el Concepto de Pago se registra sin indicar el Centro Funcional de Servicio, entonces:<br />
                    &nbsp;&nbsp;&nbsp;a) Si existe Distribuci&oacute;n Contable se contabilizar&aacute; en los diferentes Centros Funcionales que definidos en este mantenimiento, seg&uacute;n sus porcentajes.<br/>
                    &nbsp;&nbsp;&nbsp;b) Si no existe Distribuci&oacute;n Contable se contabilizar&aacute; en el Centro Funcional al cual pertenece la plaza del empleado.
                    </font>
                 </td>
              </tr>
            </table>	
    
            </fieldset>
    </tr>
</cfif>
<cfif tabChoice eq 3>
    <tr>   
        <td valign="top">
            <fieldset><legend>#MSG_Cargas#</legend>
            <table width="100%" border="0" cellpadding="0" cellspacing="0" style="height:100px;">
              <tr>
                 <td align="justify">
                    <font  style="font-size:11px; color:##0000FF">Caso 1</font><font  style="font-size:10px">-Si no existe Distribuci&oacute;n Contable para el Salario, ni para las Incidencias, ni para las Cargas Obrero-Patronal,
                    entonces las Cargas se contabilizarán al Centro Funcional al cual pertenece la plaza del empleado.
                    </font>
                 </td>
              </tr>
              <tr>
                 <td>&nbsp;
                    
                 </td>
              </tr>
              <tr>
                 <td align="justify">
                    <font  style="font-size:11px; color:##0000FF">Caso 2</font><font  style="font-size:10px">-Si existe Distribuci&oacute;n Contable ya sea para Salarios o para Incidencias pero no para las Cargas Sociales, se realizar&aacute; 
                    la distribuci&oacute;n contable de las Cargas seg&uacute;n los Centros Funcionales definidos para el Salario y las Incidencias, respectivamente.
                    </font>
                 </td>
              </tr>
              <tr>
                 <td>&nbsp;
                 </td>
              </tr>	
              <tr>
                 <td align="justify">
                    <font  style="font-size:11px; color:##0000FF">Caso 3</font><font  style="font-size:10px">-Si existe Distribuci&oacute;n Contable para las Cargas Sociales, sin importar si existe distribuci&oacute;n 
                    contable para Salarios o Incidencias, las Cargas se contabilizar&aacute;n 
                    en los diferentes Centros Funcionales definidos en este mantenimiento, según sus porcentajes.
                    </font>
                 </td>
              </tr>
            </table>	
            </fieldset>
        </td>
     </tr>
 </cfif> 
  </cfoutput>
</table>
