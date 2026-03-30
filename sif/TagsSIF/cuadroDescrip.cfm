
<cfparam  name="Attributes.txtAreaName"		type="string" 	default="Observaciones">	<!--- Nombre del TextArea --->
<cfparam  name="Attributes.txtAreaCols"		type="string" 	default="50">				<!--- Columnas del TextArea --->
<cfparam  name="Attributes.txtAreaRows"		type="string" 	default="5">				<!--- Filas del TextArea --->
<cfparam  name="Attributes.txtAreaMax"		type="string" 	default="255">				<!--- Tamaño Maximo de Caracteres del TextArea --->
<cfparam  name="Attributes.txtAreaValue" 	type="string" 	default="">					<!--- Contenido del TextArea --->
<cfparam  name="Attributes.txtAreaReadonly" type="boolean" 	default="false">			<!--- propiedad readonly del TextArea --->
<cfparam  name="Attributes.txtAreaRequired" type="boolean" 	default="false">			<!--- propiedad required del TextArea --->
 
<cfoutput>

<textarea name="#Attributes.txtAreaName#" 
			cols="#Attributes.txtAreaCols#" 
			rows="#Attributes.txtAreaRows#" 
			<cfif Attributes.txtAreaReadonly> readonly </cfif>
			<cfif Attributes.txtAreaRequired> required </cfif>
			maxlength="#Attributes.txtAreaMax#" onkeyup="countCharacter(this.value);">#Attributes.txtAreaValue#</textarea>
<br/>
<div style="font-size:80%" name="#Attributes.txtAreaName#_Counter" align="left"><div>

<script language = "JavaScript">
	function countCharacter(v){
		document.getElementsByName("#Attributes.txtAreaName#_Counter")[0].innerHTML=v.length+"/#Attributes.txtAreaMax#";
		document.getElementsByName("#Attributes.txtAreaName#")[0].innerHTML=document.getElementsByName("#Attributes.txtAreaName#")[0].innerHTML.replace('\n','');
		document.getElementsByName("#Attributes.txtAreaName#")[0].value=document.getElementsByName("#Attributes.txtAreaName#")[0].value.replace('\n','');
	}
</script>

</cfoutput>
