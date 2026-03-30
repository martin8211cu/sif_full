<form method="post" name="form1" action="prospectos-apply.cfm" style="margin:0">
	<cfinclude template="prospectos-hiddens.cfm">
	<table width="100%" border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td valign="top">
			<cfparam name="form.PquienProsp" default="">
			<cf_prospecto
				id="#form.PquienProsp#"
				pais = "#session.saci.pais#"
				porFila = "true"
				verNombApPost = "true"
				Conexion = "#session.DSN#"
				Ecodigo = "#session.Ecodigo#"
				readonly = "#Len(Trim(form.PquienProsp))#"
			>
		</td>
	</tr>
	<tr align="center">
		<td>
			<cf_botones values="Venta Infructuosa,Registrar como Cliente,Contactado,Regresar" names="Descartar,Registrar,Contactado,Regresar">		
		</td>
	</tr>
	</table>	
</form>
<script type="text/javascript">
<!--
	function funcRegistrar(){
		if(confirm('Desea registrar el prospecto como cliente ?')){
			return true;
		}
		return false;
	}
	function funcDescartar(){
		if(confirm('Desea Descartar el prospecto ?')){
			return true;
		}
		return false;
	}	
//-->
</script>