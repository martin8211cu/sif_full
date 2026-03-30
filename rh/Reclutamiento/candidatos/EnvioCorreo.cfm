<title>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_CurriculumVitae"
		Default="Envio de Curriculum Vitae"
		returnvariable="Titulo"/>
		<cfoutput>#Titulo#</cfoutput>
</title>

<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="Enviado_por"
		Default="Enviado por"
		returnvariable="Enviado_por"/>
		
<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Para"
		Default="Para"
		returnvariable="LB_Para"/>

<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Enviar"
		Default="Enviar por correo"
		returnvariable="LB_Enviar"/>
		
<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Cerrar"
		Default="Cerrar"
		returnvariable="LB_Cerrar"/>		

<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_es_requerido"
		Default="es requerido"
		returnvariable="LB_es_requerido"/>
<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Se_presentaron_los_siguientes_errores"
		Default="Se presentaron los siguientes errores"
		returnvariable="LB_Se_presentaron_los_siguientes_errores"/>
<cfoutput>

<form style="margin:0" name="correo" method="post">
	<fieldset><legend>#Titulo#</legend>
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td valign="top" >
				<font  style="font-size:12px"><b>#Enviado_por#</b></font>
			</td>
			<td valign="top">
			<input 
				name="CorreoDe" 
				type="text" 
				id="CorreoDe" 
				tabindex="1" 
				maxlength="100"
				size="45"
				style="font-size:12px"
				value="#session.datos_personales.EMAIL1#">			
			</td> 
		</tr>
		<tr>
			<td valign="top" >
				<font  style="font-size:12px"><b>#LB_Para#</b></font>
			</td>
			<td valign="top">
			<input 
				name="CorreoPAra" 
				type="text" 
				style="font-size:12px"
				id="CorreoPAra" 
				maxlength="100"
				size="45"
				tabindex="1" 
				value="">
			</td> 			
		</tr>	
		<tr>
			<td valign="top" colspan="2" align="center">
				<input type="button" name="Enviar" value="#LB_Enviar#" onClick="javascript: return fnenviar();" />
				<input type="button" name="Cerrar" value="#LB_Cerrar#" onClick="javascript: return fncerrar();" />
				
			</td>
		</tr>
	</table>
	</fieldset>
</form>
</cfoutput>
<script language="javascript" type="text/javascript">
		function validar(){
			var error='';
			
			if ( document.correo.CorreoDe.value == '' ){
				error = ' - <cfoutput>#Enviado_por# #LB_es_requerido#</cfoutput>.';
			}
			
			if ( document.correo.CorreoPAra.value == '' ){
				error = ' - <cfoutput>#LB_Para# #LB_es_requerido#</cfoutput>.';
			}
			
			if (error != '' ){
				alert( '<cfoutput>#LB_Se_presentaron_los_siguientes_errores#</cfoutput>:\n' + error )
				return false;
			}
			
			return true;
		}

	function  fnenviar(){
		if(validar()){
			 window.opener.document.form1.CorreoDe.value = document.correo.CorreoDe.value;
			window.opener.document.form1.CorreoPAra.value = document.correo.CorreoPAra.value;
			window.opener.document.form1.AccionAEjecutar.value ="CORREO";
			window.opener.document.form1.submit();
			window.close();
		}
	}
</script>
