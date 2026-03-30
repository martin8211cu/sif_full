<style type="text/css">
<!--
.style2 {color: #000000}
.style4 {font-size: 10px; font-weight: bold; color: #0000CC; }
-->
</style>
<cfoutput>
<cfif isdefined ('form.MIGSDid')>
	<cfquery name="rsJerarquia" datasource="#session.dsn#">
		select a.MIGDid,a.MIGDcodigo,a.MIGDnombre,b.MIGSDcodigo,b.MIGSDdescripcion
		from  MIGDireccion a
			inner join MIGSDireccion b
				on a.MIGDid=b.MIGDid
		where b.MIGSDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MIGSDid#">
	</cfquery>
</cfif>
<table width="50%" border="0" align="left">
	<tr>
		<td align="left"><span class="style4"><span class="style2">Direcci&oacute;n:</span>#rsJerarquia.MIGDcodigo#-#rsJerarquia.MIGDnombre#</span></td>
	</tr>
	<tr>
		<td><span class="style4"><span class="style2">Sub_Direcci&oacute;n:</span>#rsJerarquia.MIGSDcodigo#-#rsJerarquia.MIGSDdescripcion#</span></td>
	</tr>
	<tr>
		<td  nowrap="nowrap" align="left" colspan="2"> 
			<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
				tabla="MIGGerencia a
						inner join MIGSDireccion b
							on a.MIGSDid=b.MIGSDid
							and a.Ecodigo=b.Ecodigo
							and a.Dactiva=1
							and b.Dactiva=1"
				columnas="a.MIGGid,b.MIGSDid,a.MIGGcodigo,a.MIGGdescripcion"
				desplegar="MIGGcodigo, MIGGdescripcion"
				etiquetas="C&oacute;digo, Descripci&oacute;n"
				formatos="S,S,S"
				filtro="a.Ecodigo=#session.Ecodigo# and b.MIGSDid=#form.MIGSDid# Order By a.MIGGcodigo"
				align="left,left,left"
				checkboxes="N"
				keys="MIGGid"
				MaxRows="15"
				showLink="false"
				pageindex="65"
				filtrar_por="MIGGcodigo, MIGGdescripcion, &nbsp;, &nbsp;"
				ira="Sub_Direccion.cfm"
				showEmptyListMsg="true">
			</td>
		</tr>
</table>
<form name="form2" method="post" action="Sub_DireccionSQL.cfm" onSubmit="return validarF(this);">
<cfif isdefined('form.MIGSDid')>
	<input type="hidden" name="MIGSDid" id="MIGSDid" value="#form.MIGSDid#" />
	<input type="hidden" name="MIGSDcodigo" id="MIGSDcodigo" value="#rsJerarquia.MIGSDcodigo#" />
</cfif>
	<table width="50%" align="right" border="0">
		<tr>
		  <td width="56%" align="right" ><strong>Gerencia Asociada:</strong></td>
			<td width="1%" align="left">
				<cf_conlis title="Lista Gerencias"
						campos = "MIGGid,MIGGcodigo,MIGGdescripcion" 
						desplegables = "N,S,S"
						modificables = "N,S,S"  
						tabla="MIGGerencia"
						columnas="MIGGid,MIGGcodigo,MIGGdescripcion"
						filtro="Ecodigo = #Session.Ecodigo#"
						desplegar="MIGGcodigo, MIGGdescripcion"
						etiquetas="Codigo,Descripción"
						formatos="S,S"
						align="left,left"
						form="form2"
						filtrar_por="MIGGcodigo,MIGGdescripcion"
						tabindex="1"
						fparams="MIGGid"
						/>   
			
		  </td>
			<td width="6%"><img border='0' src='/cfmx/mig/imagenes/plus.gif' onClick='javascript:return funcOpen();'>	</td>
		</tr>
		<tr>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td align="left"  colspan="2"><input name="ASDir" type="submit" value="Asociar" tabindex="1"></td>
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
			nuevo = window.open('GerenciaForm.cfm?bandera=1&modo=ALTA&MIGSDid=#form.MIGSDid#','Caracteristicas','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
			</cfoutput>
			nuevo.focus();
			window.onfocus = closePopUp;
			
			return false;	
		}
		

function closePopUp(){
	if(nuevo) {
		if(!nuevo.closed) nuevo.close();
		nuevo=null;
		document.form2.submit();
  	}
}
</script>
<script type="text/javascript">
function validarF(formulario)	{
		var error_input;
		var error_msg = '';
		if (formulario.MIGGid.value == "") {
			error_msg += "\n - La Gerencia no puede quedar en blanco.";
			error_input = formulario.MIGSDcodigo;
		}	
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
		else{
					var CodigoGe=formulario.MIGGcodigo.value;
					var CodigoSub=formulario.MIGSDcodigo.value; 
					if ( confirm('Desea Asociar la Gerencia: '+ CodigoGe +'   a la Sub_Dirección: ' + CodigoSub ) ){ 
						if (window.deshabilitarValidacion) deshabilitarValidacion(); 
						return true;
					}
					else{ 
						return false;
					}
		}	
}
</script>