<!--- Consultas. --->
<cf_dbfunction name="concat" args="B.ACcodigodesc,' ',B.ACdescripcion" returnvariable="nombreCategoria">
<cf_dbfunction name="concat" args="C.ACcodigodesc,' ',C.ACdescripcion" returnvariable="nombreClasificacion">
<cf_dbfunction name="to_char"	args="A.ACid"     returnvariable="ACid">
<cf_dbfunction name="to_char"	args="A.ACcodigo" returnvariable="ACcodigo">
<cf_dbfunction name="concat" args="'<img border=''0'' onClick=''eliminar('+#ACid#+','+#ACcodigo#+');'' src=''/cfmx/sif/imagenes/Borrar01_S.gif'' >'" delimiters="+" returnvariable="Eliminar">

<cfset columnas = "
	A.ACid,
	A.ACcodigo,
	B.ACdescripcion AS dCategoria,
	#nombreCategoria# as nombreCategoria,
	#nombreClasificacion# as nombreClasificacion,
	#PreserveSingleQuotes(Eliminar)# as Eliminar">
	
<cfset tabla = "
	CRAClasificacion A
		inner join ACategoria B on
			A.Ecodigo    = B.Ecodigo and
			A.ACcodigo = B.ACcodigo
		inner join AClasificacion C on
			A.Ecodigo    = C.Ecodigo and
			A.ACcodigo = C.ACcodigo and
			A.ACid           = C.ACid">
			
<cfset filtro = "A.Ecodigo = #Session.Ecodigo#">
<cfif isDefined("form.CRCCid") and len(trim(form.CRCCid))>
	<cfset filtro = filtro & " and A.CRCCid = #form.CRCCid#">
</cfif>
<cfset filtro = filtro & " Order By B.ACcodigodesc,C.ACcodigodesc">

<!--- Lista --->
<cfinvoke 
	component="sif.Componentes.pListas"
	method="pListaRH"
	returnvariable="pListaRet"
		tabla="#tabla#"
		columnas="#columnas#"
		desplegar="dCategoria,nombreClasificacion,Eliminar"
		etiquetas="Categor&iacute;a,Clasificaci&oacute;n,&nbsp;"
		formatos="S,S,U"
		filtro="#filtro#"
		align="left,left,left"
		ajustar="N,N,N"
		checkboxes="N"
		keys="ACid,ACcodigo"
		MaxRows="5"
		filtrar_automatico="true"
		mostrar_filtro="true"
		showLink="false"
		incluyeForm="true"
		cortes="nombreCategoria"
		formName="lista"
		filtrar_por="B.ACdescripcion,#nombreClasificacion#,&nbsp;"
		irA="Clasificacion-Custodia-sql.cfm"
		showEmptyListMsg="true" />

<cfoutput>
<script language="javascript1.2" type="text/javascript">
	function funcFiltrar() {
		document.lista.action = "CentroCustodia.cfm?CRCCid=#form.CRCCid#&tab=#form.tab#"
		return true;
	}

	function eliminar(llave,llave2){
		if (confirm('¿Desea eliminar la Clasificación?')){
			document.lista.action = "Clasificacion-Custodia-sql.cfm?CRCCid=#form.CRCCid#&tab=#form.tab#&modoE=BAJA&ACid="+llave+"&ACcodigo="+llave2;
			document.lista.submit();
		}else{
			return false;
		}
	}
</script>
</cfoutput>