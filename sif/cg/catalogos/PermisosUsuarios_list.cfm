<cfif isdefined("Url.PCRGid") and (not isdefined("Form.PCRGid") or not len(trim(Form.PCRGid)))>
	<cfset Form.PCRGid = Url.PCRGid>
</cfif>
<cf_dbfunction name="to_char" args="a.Usucodigo"   returnvariable="codigo_tochar" >
<cf_dbfunction name="concat" args="c.Pnombre,' ',c.Papellido1,' ',c.Papellido2"   returnvariable="nombreusuario" >
<cf_dbfunction name="concat" args="'<img border=''0'' onClick=''eliminar('? #codigo_tochar#?');'' src=''/cfmx/sif/imagenes/Borrar01_S.gif'' >'" delimiters="?"   returnvariable="img_concat" >
<cfset columnas = "
		a.PCRGid,
		a.Usucodigo,
		b.Usulogin,
		#PreserveSingleQuotes(nombreusuario)# as Nombre,
		#PreserveSingleQuotes(img_concat)# as Eliminar">
<cfset tabla = "
		PCUsuariosReglaGrp a
			inner join Usuario b 
				on a.Usucodigo = b.Usucodigo
			inner join DatosPersonales c 
				on b.datos_personales = c.datos_personales
			inner join PCReglaGrupo d 
				on d.PCRGid = a.PCRGid 
				and d.Ecodigo = a.Ecodigo">
<cfset filtro = "   1=1 
				and a.Ecodigo = #session.Ecodigo# 
				and d.PCRGid = " & #Form.PCRGid# & "
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
		filtrar_por="Usulogin,#PreserveSingleQuotes(nombreusuario)#,&nbsp,&nbsp;"
		irA="PermisosUsuarios_sql.cfm"
		showEmptyListMsg="true" />


		
        

<cfoutput>
<script language="javascript1.2" type="text/javascript">
	function funcFiltrar() {
		document.lista.action = "PermisosUsuarios.cfm?PCRGid=#Form.PCRGid#";
		return true;
	}
	function eliminar(llave){
		if (confirm('¿Desea eliminar el usuario?')){
			document.lista.action = "PermisosUsuarios_sql.cfm?PCRGid=#Form.PCRGid#&modo=BAJA&Usucodigo="+llave;
			document.lista.submit();
		}else{
			return false;
		}
	}	
</script>
</cfoutput>