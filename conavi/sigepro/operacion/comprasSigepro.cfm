<cf_templateheader title="Proceso de Compra SIGEPRO">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Proceso de Compra SIGEPRO'>
		  <form name="form1" method="post" action="<cfoutput>#GetFileFromPath(GetTemplatePath())#</cfoutput>">
            <input type="hidden" name="opt" value="1">
			<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
	    		<tr>
			<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pLista"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="CMProcesoCompra a"/>
				<cfinvokeargument name="columnas" value="a.CMPnumero,a.CMPid, a.CMPdescripcion, a.CMPfechapublica, a.CMPfmaxofertas
														"/>
				<cfinvokeargument name="desplegar" value="CMPnumero,CMPdescripcion, CMPfechapublica, CMPfmaxofertas"/>
				<cfinvokeargument name="etiquetas" value="Num. Proceso,Descripci&oacute;n, Fecha de Publicaci&oacute;n, Fecha Cotizaci&oacute;n"/>
				<cfinvokeargument name="formatos" value="V,V,D,D"/>
				<cfinvokeargument name="filtro" value=" a.CMPestado in (0,10)
														and a.Ecodigo = #Session.Ecodigo#
														order by a.CMPfechapublica desc
														"/>
				<cfinvokeargument name="align" value="left, left, center, center, center"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="keys" value="CMPid"/>				
				<cfinvokeargument name="MaxRows" value="20"/>
				<cfinvokeargument name="formName" value="form1"/>
				<cfinvokeargument name="incluyeForm" value="false"/>
				<cfinvokeargument name="usaAjax" value="true"/>						
				<cfinvokeargument name="mostrar_filtro" value="true"/>
				<cfinvokeargument name="filtrar_automatico" value="yes"/>
				<cfinvokeargument name="filtrar_Por=" value="CMPnumero,CMPdescripcion,CMPfechapublica,CMPfmaxofertas"/>
				<cfinvokeargument name="irA" value="procComprasSigeproDet.cfm">
			</cfinvoke>
				</tr>				
			</table>
		  </form>	
		<cf_web_portlet_end>
	<cf_templatefooter>