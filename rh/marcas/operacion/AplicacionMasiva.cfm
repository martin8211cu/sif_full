<cfif isdefined("url.RHPMid") and len(trim(url.RHPMid)) neq 0>
	<cfset form.RHPMid = url.RHPMid> 
</cfif>
<cfif isdefined("form.RHPMid")>	
	<cfquery name="FechaMin" datasource="#session.DSN#">
		select Min(RHCMfregistro)as fecha from RHControlMarcas 
		where RHPMid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPMid#"> 
	</cfquery>
	<cfquery name="FechaMax" datasource="#session.DSN#">
		select Max(RHCMfregistro)as fecha from RHControlMarcas 
		where RHPMid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPMid#">
	</cfquery>	
</cfif>

<SCRIPT language="javascript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></SCRIPT>
<SCRIPT language="javascript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="javascript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>
<!----================= TRADUCCION ===================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Aprobar"
	Default="Aprobar"
	returnvariable="BTN_Aprobar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Esta_seguro_de_que_desea_aprobar_la_justificacion_ahora"
	Default="Esta seguro de que desea aprobar la justificación ahora?"	
	returnvariable="MSG_Esta_seguro_de_que_desea_aprobar_la_justificacion_ahora"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_El_campo_de_Fecha_es_requerido"
	Default="El campo de Fecha es requerido."	
	returnvariable="MSG_El_campo_de_Fecha_es_requerido"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_El_campo_de_Situacion_es_requerido"
	Default="El campo de Situación es requerido."	
	returnvariable="MSG_El_campo_de_Situacion_es_requerido"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_El_campo_de_Justificacion_es_requerido"
	Default="El campo de Justificación es requerido."	
	returnvariable="MSG_El_campo_de_Justificacion_es_requerido"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_El_campo_de_Hora_Entrada_es_requerido"
	Default="El campo de Hora Entrada es requerido."	
	returnvariable="MSG_El_campo_de_Hora_Entrada_es_requerido"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_El_campo_de_Hora_Salida_es_requerido"
	Default="El campo de Hora Salida es requerido."	
	returnvariable="MSG_El_campo_de_Hora_Salida_es_requerido"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_El_campo_de_Horas_a_Descontar_es_requerido"
	Default="El campo de Horas a Descontar es requerido."	
	returnvariable="MSG_El_campo_de_Horas_a_Descontar_es_requerido"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_El_campo_de_Horas_a_Agregar_es_requerido"
	Default="El campo de Horas a Agregar es requerido."	
	returnvariable="MSG_El_campo_de_Horas_a_Agregar_es_requerido"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Fecha"
	Default="Fecha"	
	returnvariable="MSG_Fecha"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Situacion"
	Default="Situación"	
	returnvariable="MSG_Situacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Justificacion"
	Default="Justificación"	
	returnvariable="MSG_Justificacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Hora_Entrada"
	Default="Hora Entrada"	
	returnvariable="MSG_Hora_Entrada"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Hora_Salida"
	Default="Hora Salida"	
	returnvariable="MSG_Hora_Salida"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Horas_a_Agregar"
	Default="Horas a Agregar"	
	returnvariable="MSG_Horas_a_Agregar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Horas_a_Descontar"
	Default="Horas a Descontar"	
	returnvariable="MSG_Horas_a_Descontar"/>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Aprobación Masiva de Marcas</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
</head>
<body>	
<cfoutput>
	<form name="form1" action="AplicacionMasiva-sql.cfm" onSubmit="javascript: return valida(this); "method="post">		
		<cfif isdefined("form.RHPMid") and len(trim(form.RHPMid)) neq 0>
			<input name="RHPMid" type="hidden" value="#form.RHPMid#">
			<input name="FMin" type="hidden" value="#LSDateFormat(FechaMin.fecha,'yyyy-mm-dd')#">
			<input name="FMax" type="hidden" value="#LSDateFormat(FechaMax.fecha,'yyyy-mm-dd')#">
		</cfif>		
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
		  <tr>
			<td align="right"><strong>#MSG_Fecha#:</strong></td>
			<td>
				<cf_sifcalendario  form="form1" name="RHJMUfecha" value="">
			</td>
		</tr>
		<tr>
			<td align="right"><strong>#MSG_Situacion#:</strong></td>
			<td>
				
			<cfinvoke
				Component= "rh.Componentes.RH_inconsistencias"
				method="RHInconsistencias"
				returnvariable="rhIncons">	
				<cfinvokeargument name="funcion" value="muestraCampos()"/>				
			</cfinvoke>	
		  <!--- <select name="RHJMUsituacion" onChange="javascript: muestraCampos();">
			<option value=""></option>
			<option value="1">Omisión de marca de entrada</option>
			<option value="2">Omisión de marca de salida</option>
			<option value="3">Llegada Tardía</option>
			<option value="4">Salida Anticipada</option>
			<option value="5">Horas extras antes de la marca</option>
			<option value="6">Horas extras después de la marca</option>
			<option value="7">Día libre</option>
		  </select> --->
			</td>
		</tr>
		<tr>
			<td valign="top" align="right"><strong>#MSG_Justificacion#:</strong></td>
			<td>
				<textarea name="RHJMUjustificacion" rows="4" cols="50"></textarea>
			</td>
		</tr>
		<tr>
			<td align="right"><strong>
				<label id="label1"><cf_translate key="LB_Hora_Entrada">Hora Entrada</cf_translate>:</label>
				<label id="label2"><cf_translate key="LB_Hora_Salida">Hora salida</cf_translate>:</label>
				<label id="label3"><cf_translate key="LB_Horas_a_Agregar">Horas a Agregar</cf_translate>:</label>
				<label id="label4"><cf_translate key="LB_Horas_a_Descontar">Horas a Descontar</cf_translate>:</label></strong>
			</td>
			<td>
				 <select  id="campo1" name='campo1'>
				  <cfloop index="i" from="1" to="12">
					<option value="#i#"><cfif Len(Trim(i)) EQ 1>0</cfif>#i#</option>
				  </cfloop>
				</select> <label id="puntos1">:</label>
				<select id="campo11" name='campo11'>
				  <cfloop index="i" from="0" to="59">
					<option value="#i#"><cfif Len(Trim(i)) EQ 1>0</cfif>#i#</option>
				  </cfloop>
				</select>
				<select id="campo12"  name="campo12">
					<option value="AM">AM</option>
					<option value="PM">PM</option>
				</select>
				
				<select id="campo2"  name='campo2'>
				  <cfloop index="i" from="1" to="12">
					<option value="#i#"><cfif Len(Trim(i)) EQ 1>0</cfif>#i#</option>
				  </cfloop>
				</select> <label id="puntos2">:</label>
				<select id="campo21"  name='campo21'>
				  <cfloop index="i" from="0" to="59">
					<option value="#i#"><cfif Len(Trim(i)) EQ 1>0</cfif>#i#</option>
				  </cfloop>
				</select>
				<select  id="campo22" name="campo22">
					<option value="AM">AM</option>
					<option value="PM">PM</option>
				</select>
				
				<input id="campo3" name="campo3" type="text" size="5" maxlength="5" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="">
				<input id="campo4" name="campo4" type="text" size="5" maxlength="5" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;"  value="">
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr align="center">
			<td colspan="2"><input type="submit"  name="btnAprobar" value="#BTN_Aprobar#"></td>
		</tr>
	  </table>
	</form>
</cfoutput>
</body>
</html>
<!--- <cfset idList= '1,2,3,4,5,6,7,8'>
					<cfset incosList=
							'Omisión de Marca de Entrada,
							Omision de Marca de Salida,
							Dia Extra,
							Dia de Ausencia,
							Llegada Anticipada,
							Llegada Tardía,
							Salida Anticipada,
							Salida Tardía'>	 --->

<script>
function muestraCampos()
{
	var index = document.form1.RHIid.value; 
	
	document.getElementById('label1').style.display='none';
	document.getElementById('label2').style.display='none';
	document.getElementById('label3').style.display='none';
	document.getElementById('label4').style.display='none';
	
	document.getElementById('campo1').style.display='none';			/*Hora de Entrada*/
	document.getElementById('campo11').style.display='none';
	document.getElementById('campo12').style.display='none';
	document.getElementById('puntos1').style.display='none';
	
	document.getElementById('campo2').style.display='none';			/*Hora de salida*/
	document.getElementById('campo21').style.display='none';
	document.getElementById('campo22').style.display='none';
	document.getElementById('puntos2').style.display='none';
	
	document.getElementById('campo3').style.display='none';			/*Horas a Agregar*/
	document.getElementById('campo4').style.display='none';			/*Horas a Descontar*/

	
	if(index == 0) 
	{
		document.getElementById('label1').style.display='';
		document.getElementById('campo1').style.display='';
		document.getElementById('campo11').style.display='';
		document.getElementById('campo12').style.display='';
		document.getElementById('puntos1').style.display='';
	}
	if(index == 1) 
	{
		document.getElementById('label2').style.display='';
		document.getElementById('campo2').style.display='';
		document.getElementById('campo21').style.display='';
		document.getElementById('campo22').style.display='';
		document.getElementById('puntos2').style.display='';
	}
	if(index == 2) 
	{
		document.getElementById('label3').style.display='';
		document.getElementById('campo3').style.display='';
	}
	
	if((index == 4) || (index == 7))
	{
		document.getElementById('label3').style.display='';
		document.getElementById('campo3').style.display='';
	}
	if((index == 5) || (index == 6))
	{
		document.getElementById('label4').style.display='';
		document.getElementById('campo4').style.display='';
	}
	return false;
}

function valida() 
{
<cfoutput>
	var index = document.form1.RHIid.value;
	
	var mens='';
	if (confirm('#MSG_Esta_seguro_de_que_desea_aprobar_la_justificacion_ahora#')) {
		
		var dato1 = document.form1.RHJMUfecha.value;
		var dato2 = document.form1.RHIid.value;
		var dato3 = document.form1.RHJMUjustificacion.value;
		var dato4 = '';
		
		if(dato1 == "") mens = mens + '#MSG_El_campo_de_Fecha_es_requerido#';
		if(dato2 == "") mens = mens + '#MSG_El_campo_de_Situacion_es_requerido#';
		if(dato3 == "") mens = mens + '#MSG_El_campo_de_Justificacion_es_requerido#';
		
		if(index == '')					
				dato4 ='inactivo'; 
		if(index == 0){
		 		dato4 = document.form1.campo1.value;
				if(dato4 == "") mens = mens + '#MSG_El_campo_de_Hora_Entrada_es_requerido#';
		}
		if(index == 1){ 
				dato4 = document.form1.campo2.value;
				if(dato4 == "") mens = mens + '#MSG_El_campo_de_Hora_Salida_es_requerido#';
		}
		if((index ==5) || (index == 6))	{
				dato4 = document.form1.campo4.value;
				if((dato4 == "")) mens = mens + '#MSG_El_campo_de_Horas_a_Descontar_es_requerido#'; 
				//if((dato4 == "")||(dato4 == 0.00)) mens = mens + 'El campo de Horas a Descontar es requerido.';
		}
		if((index ==4) || (index == 7) || (index == 2))	{
				dato4 = document.form1.campo3.value;
				if((dato4 == "")) mens = mens + '#MSG_El_campo_de_Horas_a_Agregar_es_requerido#';
				//if((dato4 == "")||(dato4 == 0.00)) mens = mens + 'El campo de Horas a Agregar es requerido.';
		}
		if(index == 7){ 	
				dato4 = 'inactivo'; 
		}
		if(mens != ''){	
			alert(mens);
			return false;
		}
		else
			return true;
		
	} 
	else {
		return false;
	}
</cfoutput>
}

onLoad=muestraCampos();

/*limpia el campo de Justificacion*/
var justificacion = document.form1.RHJMUjustificacion.value;
document.form1.RHJMUjustificacion.value='';
if(justificacion != '')
{
	document.form1.RHJMUjustificacion.value= justificacion;
}

</script>

<cf_qforms>
<script language="javascript" type="text/javascript">
	<!--//
	function habilitarValidacion(){
		<cfoutput>
		var index = document.form1.RHIid.value;
			
		objForm.RHJMUfecha.required = true;
		objForm.RHJMUfecha.description = "#MSG_Fecha#";
		
		objForm.RHIid.required = true;
		objForm.RHIid.description = "#MSG_Situacion#";
		
		objForm.RHJMUjustificacion.required = true;
		objForm.RHJMUjustificacion.description = "#MSG_Justificacion#";
		
		if(index == 1){
		 		objForm.campo1.required = true;
				objForm.campo1.description = "#MSG_Hora_Entrada#";
		}
		if(index == 2){ 
				objForm.campo2.required = true;
				objForm.campo2.description = "#MSG_Hora_Salida#";
		}
		if((index ==3) || (index == 4))	{
				objForm.campo4.required = true;
				objForm.campo4.description = "#MSG_Horas_a_Agregar#";
		}
		if((index ==5) || (index == 6))	{
				objForm.campo3.required = true;
				objForm.campo3.description = "#MSG_Horas_a_Descontar#";
		}
		</cfoutput>		
	}
	
	function deshabilitarValidacion(){
		
		objForm.RHJMUfecha.required = false;
		objForm.RHIid.required = false;
		objForm.RHJMUjustificacion.required = false;
		objForm.campo1.required = false;
		objForm.campo2.required = false;
		objForm.campo3.required = false;
		objForm.campo4.required = false;
	}
	
	//habilitarValidacion();
	
	
</script>