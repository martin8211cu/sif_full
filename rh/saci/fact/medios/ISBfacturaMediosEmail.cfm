<cfparam name="FMEinout" default="">
<cfif Not ListFind('in,out',FMEinout)>
	<cfset FMEinout = 'in'>
</cfif>
<form style="margin:0" action="_self" method="get" name="lista" id="lista" >
<cfoutput><input type="hidden" name="tab" value="#url.tab#" /></cfoutput>

<cfif FMEinout is 'in'>
	<cfset desplegar="fromto,FMEsubject,estado,lineas,errores,FMErecibido">
	<cfset etiquetas="De,Asunto,Estado,Líneas,Errores,Recibido">
	<cfset formatos="S,S,S,S,S,DT">
	<cfset align="left,left,left,center,center,left">
<cfelseif FMEinout is 'out'>
	<cfset desplegar="fromto,FMEsubject,estado,FMErecibido">
	<cfset etiquetas="Para,Asunto,Estado,Enviado">
	<cfset formatos="S,S,S,DT">
	<cfset align="left,left,left,left">
</cfif>


<cfinvoke component="sif.Componentes.pListas" method="pLista"
	tabla="ISBfacturaMediosEmail"
	columnas="FMEmailid,case when FMEinout = 'in' then FMEfrom else FMEto end as fromto,FMEsubject,FMEinout,
		case FMEestado when 'N' then 'Nuevo' when 'P' then 'Procesando' when 'T' then 'Terminado' else FMEestado end as estado,
		FMErecibido
		, (select sum(d.FMEtotal) from ISBfacturaMediosArchivo d where d.FMEmailid = ISBfacturaMediosEmail.FMEmailid) as lineas
		, (select sum(d.FMEerrores) from ISBfacturaMediosArchivo d where d.FMEmailid = ISBfacturaMediosEmail.FMEmailid) as errores"
	filtro="FMEinout = '#FMEinout#' order by FMErecibido desc "
	desplegar="#desplegar#"
	etiquetas="#etiquetas#"
	formatos="#formatos#"
	align="#align#"
	funcion="DetalleCorreo"
	fparams="FMEmailid"
	form_method="get"
	keys="FMEmailid"
	mostrar_filtro="yes"
	filtrar_automatico="yes"
	incluyeform="false">
<cfif FMEinout is 'in'>
	<cfinvokeargument name="botones" value="Revisar_Correo"/>
</cfif>
</cfinvoke>
</form>

<form name="hiddenform" action="ISBfacturaMediosEmail-apply.cfm" style="margin:0" method="post">
<input type="hidden" name="chk" id="hiddenchk" />
<input type="hidden" name="" id="hiddenbutton"/>
</form>
<script type="text/javascript">
<!--
	function funcRevisar_Correo() {
		document.hiddenform.hiddenbutton.name = 'Revisar_Correo';
		document.hiddenform.submit();
		return false;
	}
	function DetalleCorreo(FMEmailid){
		document.location.href = 'index.cfm?tab=<cfoutput>#url.tab#</cfoutput>&FMEmailid=' + escape(FMEmailid);
	}
-->
</script>