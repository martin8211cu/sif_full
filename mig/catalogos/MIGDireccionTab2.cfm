<style type="text/css">
<!--
.style1 {
	font-size: 12px;
	font-weight: bold;
	color: #0000CC;
}
.style2 {color: #000000}
-->
</style>
<cfoutput>
<cfquery name="rsJerarquia" datasource="#session.dsn#">
	select MIGDid,MIGDcodigo,MIGDnombre
	from  MIGDireccion
	where MIGDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MIGDid#">
</cfquery>

<table width="50%" border="0" align="left">
	<tr><td align="left" nowrap="nowrap"><span class="style1"><span class="style2">Direcci&oacute;n:</span>#rsJerarquia.MIGDcodigo#-#rsJerarquia.MIGDnombre#</span></td>
	</tr>
	<tr>
		<td width="434" align="left" nowrap="nowrap" colspan="2"> 
			<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
				tabla="MIGSDireccion a
						inner join MIGDireccion b
							on a.MIGDid=b.MIGDid
							and a.Ecodigo=b.Ecodigo
							and a.Dactiva=1
							and b.Dactiva=1"
				columnas="a.MIGSDid,b.MIGDid,a.MIGSDcodigo,a.MIGSDdescripcion"
				desplegar="MIGSDcodigo, MIGSDdescripcion"
				etiquetas="C&oacute;digo, Descripci&oacute;n"
				formatos="S,S"
				filtro="a.Ecodigo=#session.Ecodigo# and a.MIGDid=#form.MIGDid# Order By a.MIGSDcodigo"
				align="left,left"
				checkboxes="N"
				showLink="false"
				keys="MIGSDid"
				MaxRows="15"
				pageindex="65"
				filtrar_por="MIGSDcodigo, MIGSDdescripcion, &nbsp;, &nbsp;"
				ira="MIGDireccion.cfm"
				showEmptyListMsg="true">
		</td>
	</tr>
	<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
</table>

<form name="NuevoForm" method="post" action="MIGDireccionSQL.cfm" onSubmit="return validar2(this);">
<cfif isdefined('form.MIGDid')>
	<input type="hidden" name="MIGDid" id="MIGDid" value="#form.MIGDid#" />
	<input type="hidden" name="MIGDcodigo" id="MIGDcodigo" value="#rsJerarquia.MIGDcodigo#" />
</cfif>
<!---<cfset LvarIDS="">
<cfset LvarIniciales=false>
traerInicial="#LvarIniciales#"
					traerFiltro="MIGSDid=#LvarIDS#"
--->
<table align="right" border="0" width="35%">
	<tr>
		<td width="73%" align="right" nowrap="nowrap"><strong>Sub_Direc Asociada:</strong></td>
		<td width="1%" align="left" >
			<cf_conlis title="LISTA DE SUB_DIRECCIONES"
					campos = "MIGSDid,MIGSDcodigo,MIGSDdescripcion" 
					desplegables = "N,S,S"
					modificables = "N,S,S"  
					tabla="MIGSDireccion "
					columnas="MIGSDid,MIGDid,MIGSDcodigo,MIGSDdescripcion"
					filtro="Ecodigo = #Session.Ecodigo#"
					desplegar="MIGSDcodigo, MIGSDdescripcion"
					etiquetas="C&oacute;d Sub_D,Desc Sub_D"
					formatos="S,S"
					align="left,left"
					form="NuevoForm"
					filtrar_por="MIGSDcodigo,MIGSDdescripcion"
					tabindex="1"
					fparams="MIGSDid"
					/>
				   
		</td>
		<td width="26%"><img border='0' src='/cfmx/mig/imagenes/plus.gif' onClick='javascript:return funcOpen();'>	</td>
	</tr>
	<tr>
		<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td align="left"  colspan="2">
		<input name="ASDir" type="submit" value="Asociar" tabindex="1" 
		onclick=""></td>
	</tr>
</table>


</form>
</cfoutput>
<script language="JavaScript1.2" type="text/javascript">
	var nuevo=0;
	function funcOpen(id) {
			var width = 900;
			var height = 450;
			var top = (screen.height - height) / 2;
			var left = (screen.width - width) / 2;
			<cfoutput>
			nuevo = window.open('Sub_DireccionForm.cfm?bandera=1&modo=ALTA&MIGDid=#form.MIGDid#','Caracteristicas','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
			</cfoutput>
			nuevo.focus();
			window.onfocus = closePopUp;			
			return false;		
		}
		

function closePopUp(){
	if(nuevo) {
		if(!nuevo.closed) nuevo.close();
		nuevo=null;
		document.NuevoForm.submit();
  	}
}
</script>

<script type="text/javascript">
function validar2(formulario)	{
		var error_input;
		var error_msg = '';
		if (formulario.MIGSDcodigo.value == "") {
			error_msg += "\n - La Sub_Dirección no puede quedar en blanco.";
			error_input = formulario.MIGSDcodigo;
		}
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
			else{
					var CodigoSub=formulario.MIGSDcodigo.value;
					var CodigoDir=formulario.MIGDcodigo.value; 
					if ( confirm('Desea Asociar la Sub_Dirección: '+ CodigoSub +'   a la Dirección:  ' + CodigoDir ) ){ 
						if (window.deshabilitarValidacion) deshabilitarValidacion(); 
						return true;
					}
					else{ 
						return false;
					}
		}
}
</script>