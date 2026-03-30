<html>
<head>
<title>M&oacute;dulos</title>

<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">
<link href="/cfmx/sif/framework/css/sif.css" rel="stylesheet" type="text/css">

</head>
<body>

	<cfif isdefined("url.ecodigo2") and not isdefined("form.ecodigo2")>
		<cfset form.ecodigo2 = url.ecodigo2 >
	</cfif>
	<cfif isdefined("url.cliente_empresarial") and not isdefined("form.cliente_empresarial")>
		<cfset form.cliente_empresarial = url.cliente_empresarial >
	</cfif>

	<cfif isdefined("form.cerrar")>
		<script type="text/javascript" language="javascript1.2">
			if ( !window.opener.closed ){
				window.opener.document.lista.CLIENTE_EMPRESARIAL.value = '<cfoutput>#form.cliente_empresarial#</cfoutput>';
				window.opener.document.lista.ECODIGO2.value = '<cfoutput>#form.ecodigo2#</cfoutput>';
				window.opener.document.lista.submit();
			}
			window.close();
		</script>
	</cfif>

	<cfset select = "rtrim(pm.modulo) as modulo, m.nombre as nom_modulo, rtrim(m.sistema) as sistema, s.nombre as nom_sistema, #form.ecodigo2# as ecodigo2, #form.cliente_empresarial# as cliente_empresarial">
	<cfset from   = "
			CuentaClienteEmpresarial cce
			, ClienteContrato cc
			, ClienteContratoPaquetes ccp
			, Paquete p
			, PaqueteModulo pm
			, Modulo m
			, Sistema s">
	<cfset where  = " 
			cce.cliente_empresarial=#form.cliente_empresarial#
			and cce.cliente_empresarial=cc.cliente_empresarial
			and cc.COcodigo=ccp.COcodigo
			and ccp.PAcodigo=p.PAcodigo
			and p.PAcodigo=pm.PAcodigo
			and pm.modulo=m.modulo
			and m.modulo not in (
				select em.modulo 
				from EmpresaModulo em
				where em.modulo = m.modulo
					and em.Ecodigo = #form.ecodigo2#
				)
			and m.sistema=s.sistema" >

	<cfinvoke 
	 component="sif.Componentes.pListas"
	 method="pLista"
	 returnvariable="pListaRet">
		<cfinvokeargument name="tabla" value="#from#"/>
		<cfinvokeargument name="cortes" value="nom_sistema"/>		
		<cfinvokeargument name="columnas" value="#select#"/>
		<cfinvokeargument name="desplegar" value="modulo,nom_modulo"/>
		<cfinvokeargument name="etiquetas" value="Nombre,Módulo"/>
		<cfinvokeargument name="formatos" value="V,V"/>
		<cfinvokeargument name="filtro" value="#where#"/>
		<cfinvokeargument name="align" value="left,left"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="irA" value="EmpresaModulo_sql.cfm"/>
		<cfinvokeargument name="Conexion" value="#session.DSN#"/>
		<cfinvokeargument name="MaxRows" value="30"/>
		<cfinvokeargument name="keys" value="sistema,modulo"/>
		<cfinvokeargument name="navegacion" value="botonSel=Buscar"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/> 
		<cfinvokeargument name="showLink" value="false"/>
		<cfinvokeargument name="botones" value="Agregar"/>
		<cfinvokeargument name="checkboxes" value="S"/>
	</cfinvoke>

	<script type="text/javascript">
		function funcAgregar() {
			if ( checkeados() ) {
				document.lista.CLIENTE_EMPRESARIAL.value = '<cfoutput>#form.cliente_empresarial#</cfoutput>';
				document.lista.ECODIGO2.value = '<cfoutput>#form.ecodigo2#</cfoutput>';
				document.lista.action = 'EmpresaModulo_sql.cfm';
				document.lista.submit();
				return true;
			}
			else{
				alert('No hay módulos seleccionados para el proceso.');
				return false;
			}
		}
		
		function funcCerrar() {
			window.close();
			return false;
		}
		
		function existe(form, name){
		// RESULTADO
		// Valida la existencia de un objecto en el form
		
			if (form[name] != undefined) {
				return true
			}
			else{
				return false
			}
		}
	
		function check_all(obj){
			var form = eval('lista');
			
			if (existe(form, "chk")){
				if (obj.checked){
					if (form.chk.length){
						for (var i=0; i<form.chk.length; i++){
							form.chk[i].checked = "checked";
						}
					}
					else{
						form.chk.checked = "checked";
					}
				}	
			}
		}
	
		function checkeados(){
			var form = document.lista;
			if (existe(form, "chk")){
				if (form.chk.length){
					for (var i=0; i<form.chk.length; i++){
						if (form.chk[i].checked){
							return true;
						}
					}
					return false;
				}
				else{
					if (form.chk.checked){
						return true;
					}
					else{	
						return false;
					}	
				}
			}
		}
	
		
	</script>

</body>
</html>

