<cfif isdefined("Url.PCEcatid") and (not isdefined("Form.PCEcatid") or not len(trim(Form.PCEcatid)))>
	<cfset Form.PCEcatid = Url.PCEcatid>
</cfif>
<cf_dbfunction name='concat' args="c.Papellido1 + ' ' +  c.Papellido2  + ' ' + c.Pnombre" returnvariable='LvarNombre' delimiters='+'>

<cf_dbfunction name='to_char' args="a.Usucodigo" returnvariable='LvarUsucodigoChar'>
<cf_dbfunction name='concat' args="' + #LvarUsucodigoChar# + '" returnvariable='LvarUsucodigo' delimiters='+'>


<cfset columnas = "
		a.PCEcatid,
		a.Usucodigo,
		b.Usulogin,
		#LvarNombre#  as Nombre,
		'<img border=''0'' onClick=''eliminar( #LvarUsucodigo# );'' src=''/cfmx/sif/imagenes/Borrar01_S.gif'' >' as Eliminar">
<cfset tabla = "
		PCECatalogoUsr a
			inner join Usuario b 
				on a.Usucodigo = b.Usucodigo
			inner join DatosPersonales c 
				on b.datos_personales = c.datos_personales">
<cfset filtro = "   1=1 
				and a.Ecodigo = #session.Ecodigo# 
				and a.PCEcatid = " & #Form.PCEcatid# & "
			Order By c.Papellido1,c.Papellido2,c.Pnombre">

<cfinvoke 
	component="sif.Componentes.pListas"
	method="pListaRH"
	returnvariable="pListaRet"
		tabla="#tabla#"
		columnas="#columnas#"
		desplegar="Usulogin,Nombre,Eliminar"
		etiquetas="Identificaci&oacute;n,Nombre,&nbsp;"
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
		filtrar_por="Usulogin,c.Pnombre +/*cat*/ ' ' +/*cat*/  c.Papellido1  +/*cat*/ ' ' +/*cat*/  c.Papellido2,&nbsp,&nbsp;"
		irA="UsuxCatalogo_sql.cfm"
		showEmptyListMsg="true" />

<cfoutput>
<script language="javascript1.2" type="text/javascript">
	function funcFiltrar() {
		document.lista.action = "UsuxCatalogo.cfm?PCEcatid=#Form.PCEcatid#";
		return true;
	}
	function eliminar(llave){
		if (confirm('¿Desea eliminar el usuario?')){
			document.lista.action = "UsuxCatalogo_sql.cfm?PCEcatid=#Form.PCEcatid#&modo=BAJA&Usucodigo="+llave;
			document.lista.submit();
		}else{
			return false;
		}
	}	
</script>
</cfoutput>
