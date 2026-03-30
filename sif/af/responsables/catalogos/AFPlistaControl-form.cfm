<cfif NOT isdefined('SScodigo') OR NOT isdefined('SMcodigo')>
	<cfthrow message="Antes de incluir este fuente se debe especificar el Sistema y Modulo">
</cfif>

<cfinvoke component="sif.Componentes.PlistaControl" method="SetControlDefault">
	<cfinvokeargument name="SScodigo" value="#SScodigo#">
   	<cfinvokeargument name="SMcodigo" value="#SMcodigo#">
</cfinvoke>

<cfinvoke component="sif.Componentes.PlistaControl" method="GetControl" returnvariable="rsListControl">
	<cfinvokeargument name="SScodigo" value="#SScodigo#">
   	<cfinvokeargument name="SMcodigo" value="#SMcodigo#">
    <cfinvokeargument name="ReadOnly" value="false">
</cfinvoke>

<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
    <cfinvokeargument name="query" 			  value="#rsListControl#"/>
    <cfinvokeargument name="desplegar" 		  value="SPcodigo,SPdescripcion, MaxRow"/>
    <cfinvokeargument name="etiquetas" 		  value="Código,Proceso,Cantidad Maxima de registros"/>
    <cfinvokeargument name="formatos" 		  value="S,S,S"/>
    <cfinvokeargument name="align" 			  value="left,left,left"/>
    <cfinvokeargument name="keys"	 		  value="PLCid"/>
    <cfinvokeargument name="showEmptyListMsg" value="true"/>
    <cfinvokeargument name="showLink"		  value="false"/>
    <cfinvokeargument name="incluyeForm"	  value="false"/>
    <cfinvokeargument name="MaxRows" 		  value="0"/>
    <cfinvokeargument name="ajustar" 		  value="s"/>
    <cfinvokeargument name="checkedcol"       value="checkedcol"/>
</cfinvoke>
<iframe name="ifrUpdateMaxRow" id="ifrUpdateMaxRow" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto"></iframe>	

<script language="javascript" type="text/javascript">
	function fnUpdateMaxRow(PLCid, MaxRow)
	{
		if (MaxRow != "")
		{
			document.getElementById('ifrUpdateMaxRow').src='<cfoutput>#IRA#</cfoutput>?MaxRow='+qf(MaxRow)+'&PLCid='+PLCid+'&btnModificar=true';
		}
		else
		document.getElementById('Plista_'+PLCid).value = '0.00';
	}
</script>


