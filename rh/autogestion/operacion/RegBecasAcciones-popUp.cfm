<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Sesion" Default="Sesi&oacute;n" XmlFile="/rh/generales.xml" returnvariable="LB_Sesion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Articulo" Default="Art&iacute;culo" XmlFile="/rh/generales.xml" returnvariable="LB_Articulo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha" Default="Fecha" XmlFile="/rh/generales.xml" returnvariable="LB_Fecha"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Justificacion" Default="Justificaci&oacute;n" XmlFile="/rh/generales.xml" returnvariable="LB_Justificacion"/><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><cfif Tipo eq 1>Aprobar<cfelseif Tipo eq 2>Rechazar</cfif></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>

<cfset readonly = "true">
<cfset botones = "Cerrar">
<cfset nombres = "Cerrar">
<cfset accion = url.accion>
<cfif Tipo eq 1>
	<cfset botones = botones & ",Aprobar">
    <cfset nombres = nombres & ",Aprobar">
<cfelseif Tipo eq 2>
	<cfset botones = botones & ",Rechazar">
    <cfset nombres = nombres & ",Rechazar">
</cfif>
<cfoutput>
	<table width="100%" border="0" cellspacing="1" cellpadding="1">
        <form name="form1" method="post" action="">
        <tr>
            <td colspan="2" bgcolor="##EEEEEE" align="right" style="border-top: 1px solid darkgray; border-bottom: 1px solid darkgray ">
                <cf_botones formName="form2" values="#botones#" names="#nombres#" align="right">
            </td>
        </tr>
        <cfif accion eq 'jefe'>
			<cfif Tipo eq 1>
            <tr>
                <td align="right"><strong>#LB_Sesion#:&nbsp;</strong></td>
                <td><input type="text" name="RHEBEsesionJef" id="RHEBEsesionJef" value="" size="50" maxlength="60"></td>
            </tr>
            <tr>
                <td align="right"><strong>#LB_Articulo#:&nbsp;</strong></td>
                <td><input type="text" name="RHEBEarticuloJef" id="RHEBEarticuloJef" value="" size="50" maxlength="60"></td>
            </tr>
            <tr>
                <td align="right"><strong>#LB_Fecha#:&nbsp;</strong></td>
                <td><cf_sifcalendario name="RHEBEfechaJef" value="#LSDateFormat(Now(),'DD/MM/YYYY')#"></td>
            </tr>
            <cfelseif Tipo eq 2>
            <tr>
                <td align="right" width="10%" nowrap><strong>#LB_Justificacion#:&nbsp;</strong></td>
                <td><textarea name="RHEBEjustificacionJef" id="RHEBEjustificacionJef" rows="3" style="width:100%"></textarea></td>
            </tr>
            </cfif>
        <cfelseif accion eq 'vice'>
        	<tr>
                <td align="right" width="10%" nowrap><strong>#LB_Justificacion#:&nbsp;</strong></td>
                <td><textarea name="RHEBEjustificacionVic" id="RHEBEjustificacionVic" rows="3" style="width:100%"></textarea></td>
            </tr>
        </cfif>
        <tr>
            <td colspan="2" bgcolor="##EEEEEE" align="right" style="border-top: 1px solid darkgray; border-bottom: 1px solid darkgray ">
                <cf_botones formName="form2" values="#botones#" names="#nombres#" align="right">
            </td>
        </tr>
        </form>
	</table>
</cfoutput>
<script language="javascript1.2" type="text/javascript">
	
	<cfif Tipo eq 1>
	function funcAprobar(){
		errores = "";
		
		<cfif accion eq 'jefe'>
			session = document.getElementById('RHEBEsesionJef').value;
			if(trim(session).length == 0)
				errores = errores + " -La sesión es requerido.\n";
			
			articulo = document.getElementById('RHEBEarticuloJef').value;
			if(trim(articulo).length == 0)
				errores = errores + " -La artículo es requerido.\n";
			
			fecha = document.getElementById('RHEBEfechaJef').value;
			if(trim(fecha).length == 0)
				errores = errores + " -La fecha es requerida.\n";

			window.opener.document.form1.RHEBEsesionJef.value = session;
			window.opener.document.form1.RHEBEarticuloJef.value = articulo;
			window.opener.document.form1.RHEBEfechaJef.value = fecha;
		</cfif>
		if(errores.length > 0){
			alert("Se presentaron los siguientes errores:\n" + errores);
			return false;
		}
		if(confirm("Este seguro de aprobar la(s) beca(s)?")){
			window.opener.document.form1.submit();
			funcCerrar();
		}else
			return false;
	}
	<cfelseif Tipo eq 2>
	function funcRechazar(){
		errores = "";
		<cfif accion eq 'jefe'>
			just = document.getElementById('RHEBEjustificacionJef').value;
			if(trim(just).length == 0)
				errores = errores + " -La justificación es requerida.\n";
			window.opener.document.form1.RHEBEjustificacionJef.value = just;
		<cfelseif accion eq 'vice'> 
			just = document.getElementById('RHEBEjustificacionVic').value;
			if(trim(just).length == 0)
				errores = errores + " -La justificación es requerida.\n";		
			window.opener.document.form1.RHEBEjustificacionVic.value = just;
		</cfif>
		if(errores.length > 0){
			alert("Se presentaron los siguientes errores:\n" + errores);
			return false;
		}
		if(confirm("Este seguro de rechazar la(s) beca(s)?")){
			window.opener.document.form1.submit();
			funcCerrar();
		}else
			return false;
	}
	</cfif>
	
	function trim(cad){  
    	return cad.replace(/^\s+|\s+$/g,"");  
	}
	
	function funcCerrar(){
		window.close();
	}
	
</script>
</body>
</html>