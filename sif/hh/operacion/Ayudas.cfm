<!-- InstanceBegin template="/Templates/LMenu03.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		<!-- InstanceBeginEditable name="titulo" --> 
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr class="area"> 
          <td width="220" rowspan="2" valign="middle"><cfinclude template="../../portlets/pEmpresas2.cfm"></td>
          <td width="50%"> 
            <div align="center"></div>
            <div align="center"><span class="superTitulo"><font size="5">Ayudas 
              del Sistema</font></span></div></td>
        </tr>
        <tr class="area"> 
          <td width="50%" valign="bottom" nowrap> 
            </td>
        </tr>
        <tr> 
          <td></td>
          <td></td>
        </tr>
      </table>
      <!-- InstanceEndEditable -->
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
		<br>
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td width="1%" valign="top">
					<!-- InstanceBeginEditable name="menu" -->
						<cfinclude template="/sif/menu.cfm">
					<!-- InstanceEndEditable -->
				</td>
			
				<td valign="top">
					<!-- InstanceBeginEditable name="mantenimiento" -->	
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Mantenimiento 
            de Ayudas'>
	
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td valign="top" nowrap>
					<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pListaRH"
						 returnvariable="pListaRet">
						<cfinvokeargument name="tabla" value="Ayuda a, Idiomas b"/>
						<cfinvokeargument name="columnas" value="convert(varchar,a.Ayid) as Ayid, a.Acodigo, a.Iid, b.Icodigo"/>
						<cfinvokeargument name="desplegar" value="Acodigo"/>
						<cfinvokeargument name="etiquetas" value="Uri"/>
						<cfinvokeargument name="Cortes" value="Icodigo"/>
						<cfinvokeargument name="formatos" value=""/>
						<cfinvokeargument name="filtro" value="	a.Iid = b.Iid order by a.Acodigo"/>
						<cfinvokeargument name="align" value="left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="irA" value="Ayudas.cfm"/>
						<cfinvokeargument name="MaxRows" value="20"/>
						<cfinvokeargument name="Conexion" value="sifcontrol"/>
						<cfinvokeargument name="keys" value="Ayid"/>
					</cfinvoke> 
				  </td>
				  <td width="1%">&nbsp;</td>
				  <td valign="top">
				  	<cfinclude template="FormAyudas.cfm">
				  </td>
              </tr>
			  <tr>
			  <td>
			  </td></tr>
            </table>
            	
		</cf_web_portlet>
	<!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template><!-- InstanceEnd -->