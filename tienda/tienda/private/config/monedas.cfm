<cf_template>
<cf_templatearea name="title"> Monedas</cf_templatearea>
<cf_templatearea name="left"> </cf_templatearea>
<cf_templatearea name="header"> </cf_templatearea>
<cf_templatearea name="body">

<cfinclude template="/home/menu/pNavegacion.cfm">

        <cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" 
		titulo='Cat&aacute;logo de Monedas'>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">

        <tr> 
          <td valign="top"> 
            <cfinvoke component="sif.Componentes.pListas" method="pLista"
				 returnvariable="pLista">
              <cfinvokeargument name="tabla" value="Monedas"/>
              <cfinvokeargument name="columnas" value="convert(varchar,Mcodigo) as Mcodigo, Mnombre"/>
              <cfinvokeargument name="desplegar" value="Mnombre"/>
              <cfinvokeargument name="etiquetas" value="Descripción"/>
              <cfinvokeargument name="formatos" value=""/>
              <cfinvokeargument name="filtro" value="Ecodigo = #session.Ecodigo# order by Mnombre"/>
              <cfinvokeargument name="align" value="left"/>
              <cfinvokeargument name="ajustar" value="N"/>
              <cfinvokeargument name="checkboxes" value="N"/>
              <cfinvokeargument name="irA" value="monedas.cfm"/>
            </cfinvoke>
          </td>
          <td valign="top"><cfinclude template="monedas_p.cfm"></td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        </table>

		
		</cf_web_portlet>

</cf_templatearea>
</cf_template>