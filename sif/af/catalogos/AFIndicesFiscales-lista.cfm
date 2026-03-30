
<cfset navegacion = "">

<cf_navegacion name="AFFperiodo" default="2007" navegacion="">
<cfif isdefined ("form.AFFperiodo") and len(trim(form.AFFperiodo))>
	<cfset navegacion = navegacion & "&AFFperiodo=#form.AFFperiodo#">
</cfif>

<cfif isdefined ("form.filter") and len(trim(form.filter))>
	<cfset navegacion = navegacion & "&filter=#form.filter#">
</cfif>


<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"  returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsQueryLista#"/>	
	<cfinvokeargument name="desplegar" value="AFFperiodo, Mes, IndiceProm"/>
	<cfinvokeargument name="etiquetas" value="Periodo, Mes, Índice Promedio"/>
	<cfinvokeargument name="formatos" value="S,S,N"/>
	<cfinvokeargument name="align" value="left, left, right"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="chkcortes" value="S"/>
	<cfinvokeargument name="keycorte" value="AFFperiodo"/> 
	<cfinvokeargument name="keys" value="AFFperiodo,AFFmes"/>
	<cfinvokeargument name="showLink" value="true"/>
	<cfinvokeargument name="irA" value="AFIndicesFiscales.cfm"/>
	<cfinvokeargument name="formname" value="linea"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="PageIndex" value="1"/>
	<cfinvokeargument name="showEmptyListMsg" value="yes"/>
	<cfinvokeargument name="Cortes" value="AFFperiodo"/> 
	<cfinvokeargument name="fontsize" value="10"/>
	<cfinvokeargument name="botones" value="Eliminar"/>
</cfinvoke>

<script language="javascript" type="text/javascript">
	function funcEliminar(){
		document.linea.action="AFIndicesFiscales-SQL.cfm";
		document.linea.submit();
	}
</script>