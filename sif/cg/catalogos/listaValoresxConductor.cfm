
<cfset navegacion = "">

<cf_navegacion name="CGCperiodo" default="2007" navegacion="">
<cfif isdefined ("form.CGCperiodo") and len(trim(form.CGCperiodo))>
	<cfset navegacion = navegacion & "&CGCperiodo=#form.CGCperiodo#">
</cfif>

<cfif isdefined ("form.filter") and len(trim(form.filter))>
	<cfset navegacion = navegacion & "&filter=#form.filter#">
</cfif>

<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"  returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsQueryLista#"/>	
	<cfinvokeargument name="desplegar" value="CGCperiodo, CGCmes, Catalogo, CGCvalor"/>
	<cfinvokeargument name="etiquetas" value="Periodo, Mes, Catalogo/UEN, Valor"/>
	<cfinvokeargument name="formatos" value="S,S,S,S,S"/>
	<cfinvokeargument name="align" value="left, left, left, right"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="chkcortes" value="S"/>
	<cfinvokeargument name="keycorte" value="CGCdescripcion"/> 
	<cfinvokeargument name="keys" value="CGCperiodo, CGCmes, CGCvalor, CGCid, F_Catalogo, HDCGCMODO"/>
	<cfinvokeargument name="showLink" value="true"/>
	<cfinvokeargument name="irA" value="ValoresxConductor.cfm"/>
	<cfinvokeargument name="formname" value="linea"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="PageIndex" value="1"/>
	<cfinvokeargument name="showEmptyListMsg" value="yes"/>
	<cfinvokeargument name="Cortes" value="CGCdescripcion,Tipo"/>
	<cfinvokeargument name="fontsize" value="10"/>
	<cfinvokeargument name="botones" value="Eliminar"/>
</cfinvoke>

<script language="javascript" type="text/javascript">
	function funcEliminar(){
		document.linea.action="SQLValoresxConductor.cfm";
		document.linea.submit();
	}
</script>