
<cfset navegacion = "">

<cf_navegacion name="AFIperiodo" default="2007" navegacion="">
<cfif isdefined ("form.AFIperiodo") and len(trim(form.AFIperiodo))>
	<cfset navegacion = navegacion & "&AFIperiodo=#form.AFIperiodo#">
</cfif>

<cfif isdefined ("form.filter") and len(trim(form.filter))>
	<cfset navegacion = navegacion & "&filter=#form.filter#">
</cfif>


<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"  returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsQueryLista#"/>	
	<cfinvokeargument name="desplegar" value="Clase, AFIperiodo, AFImes, IndiceProm"/>
	<cfinvokeargument name="etiquetas" value="Clase, Periodo, Mes, Índice Promedio"/>
	<cfinvokeargument name="formatos" value="S,S,S,S"/>
	<cfinvokeargument name="align" value="left, left, left, right"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="chkcortes" value="S"/>
	<cfinvokeargument name="keycorte" value="ACcodigoClas"/> 
	<cfinvokeargument name="keys" value="ACcodigoCat,ACcodigoClas,ACidClas,AFIperiodo,AFImes"/>
	<cfinvokeargument name="showLink" value="true"/>
	<cfinvokeargument name="irA" value="AFIndices.cfm"/>
	<cfinvokeargument name="formname" value="linea"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="PageIndex" value="1"/>
	<cfinvokeargument name="showEmptyListMsg" value="yes"/>
	<cfinvokeargument name="Cortes" value="Categoria"/>
	<cfinvokeargument name="fontsize" value="10"/>
	<cfinvokeargument name="botones" value="Eliminar"/>
</cfinvoke>

<script language="javascript" type="text/javascript">
	function funcEliminar(){
		document.linea.action="SQLAFIndices.cfm";
		document.linea.submit();
	}
</script>