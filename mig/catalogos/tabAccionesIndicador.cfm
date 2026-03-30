<table  border="0" align="center"><tr valign="top"><td valign="top">

<cfparam name="form.tipo" default="">

<cfquery name="rsTipo" datasource="#session.DSN#">
	select MIGMtipodetalle, MIGMescorporativo,Ecodigo
	from MIGMetricas
	where MIGMid = #form.MIGMID#
</cfquery>


<cfparam name="form.MIGIDETid" default="">
<cfquery name="rsDetalle" datasource="#session.DSN#">
	select * from MIGIndicadorDetalle
	where MIGMid = #form.MIGMID#
	and MIGIdetactual  = 1
</cfquery>
<cfif rsDetalle.recordCount gt 0>
	<cfset form.MIGIDETid = rsDetalle.MIGIDETid>
</cfif>

 <cfquery name="rsMod" datasource="#session.DSN#">
	select count(1) as si
	from F_Resumen
	where MIGMid = #form.MIGMID#
</cfquery>

<cfoutput>

 <cfform enctype="multipart/form-data" name="FormAccionesIndicador" id="FormAccionesIndicador" method="post" action="IndicadoresSQL.cfm" onSubmit="return valida(this);">

 	<input type="hidden" name="CambioAccionesIndicador" id="CambioAccionesIndicador" value="true">
	<input type="hidden" name="MODO" id="MODO" value="CAMBIO">
 	<input type="hidden" name="pagenum1" id="pagenum1" value="#pagenum#">
	 <cfinput name="MIGIDETid"      value="#form.MIGIDETid#" id="MIGIDETid"       type="hidden">
	 <cfinput name="MIGMID"      value="#form.MIGMID#" id="MIGMID"       type="hidden">
	 <cfinput name="modificable" value="#rsMod.si#"    id="modificable"  type="hidden">
	 <cfinput name="tab" value="#tabChoice#" id="tab"  type="hidden">

	 <!---Filtro General--->
	  <cfif isdefined('rsTipo.MIGMescorporativo') and rsTipo.MIGMescorporativo EQ 1>
	 	<cfset filtro =  "CEcodigo=#session.CEcodigo#  order by MIGFCcodigo, MIGFCdescripcion">
	 <cfelse>
	 	<cfset filtro =  "Ecodigo=#session.Ecodigo# and CEcodigo=#session.CEcodigo#  order by MIGFCcodigo, MIGFCdescripcion">
	 </cfif>

	<!---Selected Factor Critico--->
	<cfset MIGFCid = ''>
	<cfset FCIniciales = false>
	<cfif isdefined('rsDetalle.MIGFCid') and len(trim(rsDetalle.MIGFCid))>
		<cfset MIGFCid = rsDetalle.MIGFCid>
		<cfset FCIniciales = true>
	</cfif>
	<!---Selected Estrategia--->
	<cfset MIGESTid = ''>
	<cfset ESTIniciales = false>
	<cfif isdefined('rsDetalle.MIGESTid') and len(trim(rsDetalle.MIGEstid))>
		<cfset MIGESTid = rsDetalle.MIGESTid>
		<cfset ESTIniciales = true>
	</cfif>

	<!---Selected Objetivo Estrategico--->
	<cfset MIGOEid = ''>
	<cfset OEIniciales = false>
	<cfif isdefined('rsDetalle.MIGOEid') and len(trim(rsDetalle.MIGOEid))>
		<cfset MIGOEid = rsDetalle.MIGOEid>
		<cfset OEIniciales = true>
	</cfif>

	<table cellpadding="0" cellspacing="0" border="0">
	<tr><td>
	 <strong>Factor Cr&iacute;tico:</strong>
	 </td><td>
	 <!---PODEMOS AGREGAR LA EMPRESA PARA UNA MEJOR DESCRIPCION--->
	 <cf_conlis title="Lista de factores cr&iacute;ticos de &eacute;xito."
			campos = "MIGFCid,MIGFCcodigo,MIGFCdescripcion"
			desplegables = "N,S,S"
			modificables = "N,S,N"
			tabla="MIGFCritico"
			columnas="MIGFCid,MIGFCcodigo,MIGFCdescripcion"
			filtro="#filtro#"
			desplegar="MIGFCcodigo,MIGFCdescripcion"
			etiquetas="Codigo,Factor Critico"
			formatos="S,S"
			align="left,left"
			size="0,20,60"
			traerInicial="#FCIniciales#"
			traerFiltro="MIGFCid=#MIGFCid#"
			filtrar_por="MIGFCcodigo,MIGFCdescripcion"
			tabindex="1"
			form="FormAccionesIndicador"
			funcion="refreshThis"/>
	</td></tr>
	<tr><td><strong>Estrategia:</strong></td><td>

	 <cf_conlis title="Lista de Estrategias."
			campos = "MIGEstid,MIGEstcodigo,MIGEstdescripcion"
			desplegables = "N,S,S"
			modificables = "N,S,N"
			tabla="MIGEstrategia"
			columnas="MIGEstid,MIGEstcodigo,MIGEstdescripcion"
			filtro=""
			desplegar="MIGEstcodigo,MIGEstdescripcion"
			etiquetas="Codigo,Estrategia"
			formatos="S,S"
			align="left,left"
			size="0,20,60"
			traerInicial="#ESTIniciales#"
			traerFiltro="MIGEstid=#MIGESTid#"
			filtrar_por="MIGEstcodigo,MIGEstdescripcion"
			tabindex="1"
			form="FormAccionesIndicador"
			funcion="refreshThis"/>
	</td></tr>

	<tr><td><strong>Objetivo Estrat&eacute;gico:</strong></td><td>
	 <cf_conlis title="Lista de Objetivos Estrat&eacute;gicos."
			campos = "MIGOEid,MIGOEcodigo,MIGOEdescripcion"
			desplegables = "N,S,S"
			modificables = "N,S,N"
			tabla="MIGOEstrategico"
			columnas="MIGOEid,MIGOEcodigo,MIGOEdescripcion"
			filtro=""
			desplegar="MIGOEcodigo,MIGOEdescripcion"
			etiquetas="Codigo,Estrategia"
			formatos="S,S"
			align="left,left"
			size="0,20,60"
			traerInicial="#OEIniciales#"
			traerFiltro="MIGOEid=#MIGOEid#"
			filtrar_por="MIGOEcodigo,MIGOEdescripcion"
			tabindex="1"
			form="FormAccionesIndicador"
			funcion="refreshThis"/>
	</td></tr>

	<tr><td align="center" colspan="2">
		<cf_botones values="Guardar">
	</td></tr>
	</table>


 </cfform>

<!---inicio comentado para ocultar--->
<!---
<cfform enctype="multipart/form-data" name="FormAI" id="FormAI" method="post" action="IndicadoresSQL.cfm">
<cfinput type="hidden" 		name="MODO" id="MODO" value="CAMBIO">
<cfinput type="hidden" 		name="pagenum1" id="pagenum1" value="#pagenum#">
<cfinput name="MIGIDETid"      value="#form.MIGIDETid#" id="MIGIDETid"       type="hidden">
<cfinput name="MIGMID"      value="#form.MIGMID#" id="MIGMID"       type="hidden">
<cfinput name="modificable" value="#rsMod.si#"    id="modificable"  type="hidden">
<cfinput name="tab" value="#tabChoice#" id="tab"  type="hidden">

<table cellpadding="0" cellspacing="0" border="0">
	<tr><td align="center" colspan="2">
		<br><br><br><br>
	</td></tr>

	<cfquery datasource="#session.dsn#" name="rsDatos">
		select MIGAEID as id, MIGAECODIGO as codigo, MIGAEDESCRIPCION as descripcion
		from MIGAccion where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
	<tr><td align="center">
		 <strong>Acciones</strong>
	</td><td>
		 <select name="MIGAEID" id="MIGAEID"  style="width:300px">
			<cfloop query="rsDatos">
			<option value="#rsDatos.id#" title="#rsDatos.codigo#-#rsDatos.descripcion#">#rsDatos.codigo#-#rsDatos.descripcion#</option>
			</cfloop>
		</select>&nbsp;&nbsp;&nbsp;<input type="submit" value=" + " name="AddAccion"/>
	</td></tr>
</table>
</cfform>

<cfoutput>
<cfif len(trim(form.MIGIDETid))>
	<cfquery datasource="#session.DSN#" name="rsAccionesRel">
		select MIGAEID as id, MIGAECODIGO as codigo, MIGAEDESCRIPCION as descripcion
		from MIGAccion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and MIGAEID in (select x.MIGAEID from MIGACCIONPOROBJETIVO x  where x.MIGIDETid = #form.MIGIDETid# and x.Ecodigo = #session.Ecodigo#)
		order by b.MIGAECODIGO
	</cfquery>

	<table align="center" border="0" cellpadding="2" cellspacing="2" width="100%">
		<tr>
			<td valign="top" width="20">
				<strong>Codigo</strong>
			</td>
			<td valign="top" width="150">
				<strong>Descripcion</strong>
			</td>
			<td valign="top" width="150">
				&nbsp;
			</td>
		</tr>
		<cfloop query="rsAccionesRel">
			<cfset id_actual = rsAccionesRel.id>
			<cfset codigo_actual = rsAccionesRel.codigo>
			<cfset descripcion_actual = rsAccionesRel.descripcion>

			<tr>
				<td valign="top" width="20">
					#codigo_actual#
				</td>
				<td valign="top" width="150">
					#descripcion_actual#
				</td>
				<td><img src="../imagenes/Borrar01_S.gif" onclick="javascript: BorrarDetalle(#form.MIGMID#,#rsDatosSelect.id#,#MIGMid_actual#)"/>
				</td>
			</tr>

		</cfloop>
		</table>
	</cfif>
<script>
	function BorrarDetalle(MIGMIDpadre,detalleId,MIGMidhijo){
		if(confirm('Esta seguro que desea borrar el detalle?')){
			document.getElementById('BajaFiltrosIndicadores').value = true;
 			document.getElementById('MIGMdetalleid').value = detalleId;
			document.getElementById('MIGMidPadre').value = MIGMIDpadre;
			document.getElementById('MIGMidHijo').value = MIGMidhijo;
			document.FormAccionesIndicador.submit();
		}
	}
</script>
</cfoutput>--->
<!---fin comentado para ocultar--->

<script>
function valida(formulario)	{
		var error_msg="";
		var desp = document.form1.MIGMnombre.value;
		var formulario = document.FormAccionesIndicador;
		desp = desp.replace(/(^\s*)|(\s*$)/g,"");
		
		if (desp.length==0){
			error_msg += "\n - El nombre de Indicador no puede quedar en blanco.";
			error_input = document.form1.MIGMnombre;
		}
		
		if (formulario.MIGFCcodigo.value.length==0){
			error_msg += "\n - El factor critico no puede quedar en blanco.";
			error_input = formulario.MIGFCcodigo;
		}
		
		if (formulario.MIGEstcodigo.value.length==0){
			error_msg += "\n - La estrategia no puede quedar en blanco.";
			error_input = formulario.MIGEstcodigo;
		}
		
		if (formulario.MIGOEcodigo.value.length==0){
			error_msg += "\n - El objetivo estrategico no puede quedar en blanco.";
			error_input = formulario.MIGOEcodigo;
		}
		

		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
}
</script>

</cfoutput>

</td></tr></table>