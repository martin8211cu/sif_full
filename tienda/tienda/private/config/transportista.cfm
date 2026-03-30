<cf_template>
<cf_templatearea name="title"> Transportistas</cf_templatearea>
<cf_templatearea name="left"> </cf_templatearea>
<cf_templatearea name="header"> </cf_templatearea>
<cf_templatearea name="body">

<cfinclude template="/home/menu/pNavegacion.cfm">


        <cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cat&aacute;logo 
            de Transportistas'>      <table width="100%" border="0" cellspacing="0" cellpadding="0">

        <tr> 
          <td valign="top"> 
            <cfinvoke component="sif.Componentes.pListas" method="pLista"
				 returnvariable="pLista">
              <cfinvokeargument name="tabla" value="Transportista"/>
              <cfinvokeargument name="columnas" value="convert(varchar,transportista) as transportista, nombre_transportista,orden"/>
              <cfinvokeargument name="desplegar" value="nombre_transportista,orden"/>
              <cfinvokeargument name="etiquetas" value="Nombre transportista,Orden"/>
              <cfinvokeargument name="formatos" value=""/>
              <cfinvokeargument name="filtro" value="Ecodigo = #session.Ecodigo# order by orden, nombre_transportista"/>
              <cfinvokeargument name="align" value="left,right"/>
              <cfinvokeargument name="ajustar" value="N,N"/>
              <cfinvokeargument name="checkboxes" value="N"/>
              <cfinvokeargument name="irA" value="transportista.cfm"/>
            </cfinvoke>
          </td>
          <td valign="top"><cfinclude template="transportista_p.cfm"></td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        </table>
		</cf_web_portlet>
		
		
</cf_templatearea>
</cf_template>