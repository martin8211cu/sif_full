<cf_templateheader title="Mantenimiento de Configuración de la Bitácora">
    <cfinclude template="/home/menu/pNavegacion.cfm">
    <table width="100%" border="0" cellspacing="6">
    	<tr>
        	<td valign="top">            
                <cfquery datasource="asp" name="lista">
                    select PBtabla
                    from PBitacora
                    order by PBtabla
                </cfquery>
    
            	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
                    query="#lista#"
                    desplegar="PBtabla"
                    etiquetas="Tabla"
                    formatos="S"
                    align="left"
                    ira="PBitacora.cfm"
                    form_method="post"
                    keys="PBtabla"/>		
        	</td>
        	<td valign="top">
            	<cfinclude template="buscar2-form.cfm">
        	</td>
      	</tr>
    </table>
<cf_templatefooter>