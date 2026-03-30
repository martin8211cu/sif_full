<!--- Consultas --->
<cf_dbfunction name="concat"  args="c.Pnombre,' ',c.Papellido1,' ',c.Papellido2" returnvariable="DEnombrecompleto" >
<cf_dbfunction name="to_char" args="a.Usucodigo" returnvariable="Usucodigo">
<cf_dbfunction name="concat"  args="'<img border=''0'' onClick=''eliminar('+#Usucodigo#+');'' src=''/cfmx/sif/imagenes/Borrar01_S.gif'' >'" delimiters= "+" returnvariable="Eliminar" >
<cfset columnas = "
		a.Usucodigo,
		b.Usulogin,
		#DEnombrecompleto#  as nombre,
		#PreserveSingleQuotes(Eliminar)# as Eliminar">
<cfset tabla = "
		CRCCUsuarios a
			inner join Usuario b on a.Usucodigo = b.Usucodigo
			inner join DatosPersonales c on b.datos_personales = c.datos_personales">

<cfif isDefined("form.CRCCid") and len(trim(form.CRCCid))>
	<cfset filtro = "
		a.CRCCid = #form.CRCCid#">
</cfif>
<cfset filtro = filtro & " Order By c.Papellido1,c.Papellido2,c.Pnombre">
	
<cfinvoke 
	component="sif.Componentes.pListas"
	method="pListaRH"
	returnvariable="pListaRet"
		tabla="#tabla#"
		columnas="#columnas#"
		desplegar="Usulogin,nombre,Eliminar"
		etiquetas="Identificaci&oacute;n,Nombre"
		formatos="S,S,U"
		filtro="#filtro#"
		align="left,left,left"
		ajustar="N,N,N"
		checkboxes="N"
		keys="Usucodigo"
		MaxRows="10"
		filtrar_automatico="true"
		mostrar_filtro="true"
		showLink="false"
		incluyeForm="true"
		formName="lista"
		filtrar_por="Usulogin,#DEnombrecompleto#,&nbsp;"
		irA="Usuarios-Custodia-sql.cfm"
		showEmptyListMsg="true" />

<cfoutput>
<script language="javascript1.2" type="text/javascript">
	function funcFiltrar() {
		document.lista.action = "CentroCustodia.cfm?CRCCid=#form.CRCCid#&tab=#form.tab#";
		return true;
	}
	function eliminar(llave){
		if (confirm('¿Desea eliminar el usuario?')){
			document.lista.action = "Usuarios-Custodia-sql.cfm?CRCCid=#form.CRCCid#&tab=#form.tab#&modo=BAJA&Usucodigo="+llave;
			document.lista.submit();
		}else{
			return false;
		}
	}	
</script>
</cfoutput>