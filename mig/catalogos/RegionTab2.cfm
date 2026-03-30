<style type="text/css">
<!--
.style2 {color: #000000}
.style4 {font-size: 10px; font-weight: bold; color: #0000CC; }
-->
</style>

<cfoutput>
	<cfquery name="rsJerarquia" datasource="#session.dsn#">
		select a.MIGPaid,a.MIGPacodigo,a.MIGPadescripcion,b.MIGRid,b.MIGRcodigo,b.MIGRdescripcion
		from  MIGPais a
			inner join MIGRegion b
				on a.MIGPaid=b.MIGPaid
		where b.MIGRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MIGRid#">
	</cfquery>	
<table width="50%" border="0" align="left">
	<tr>
		<td align="left"><span class="style4"><span class="style2">Pa&iacute;s:</span>#rsJerarquia.MIGPacodigo#-#rsJerarquia.MIGPadescripcion#</span></td>
	</tr>
	<tr>
		<td><span class="style4"><span class="style2">Regi&oacute;n:</span>#rsJerarquia.MIGRcodigo#-#rsJerarquia.MIGRdescripcion#</span></td>
	</tr>
	<tr>
		<td width="434" align="left" nowrap="nowrap"> 
			<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
				tabla="MIGArea a
						inner join MIGRegion b
							on a.MIGRid=b.MIGRid
							and a.Dactiva=1
							and b.Dactiva=1"
				columnas="a.MIGArid,a.MIGRid,b.MIGRid,a.MIGArcodigo,a.MIGArdescripcion"
				desplegar="MIGArcodigo, MIGArdescripcion"
				etiquetas="C&oacute;digo, Descripci&oacute;n"
				formatos="S,S"
				filtro="b.MIGRid=#form.MIGRid# and a.Ecodigo=#session.Ecodigo#Order By a.MIGArcodigo"
				align="left,left"
				checkboxes="N"
				showLink="false"
				keys="MIGArid"
				ira="Region.cfm"
				MaxRows="65"
				pageindex="1"
				filtrar_por="MIGArcodigo, MIGArdescripcion, &nbsp;, &nbsp;"
				showEmptyListMsg="false">
		</td>
	</tr>
</table>

<form name="f2" method="post" action="RegionSQL.cfm" onSubmit="return validar2(this);">
<cfif isdefined('form.MIGRid')>
	<input type="hidden" name="MIGRid" id="MIGRid" value="#form.MIGRid#" />
	<input type="hidden" name="MIGRdescripcion" id="MIGRdescripcion" value="#rsJerarquia.MIGRdescripcion#" />
</cfif>	  
<table align="right" border="0" width="50%">
	<tr>
		<td align="right" nowrap="nowrap"><strong>&Aacute;rea Asociada:</strong></td>
		<td width="1%"  align="left" >
			<cf_conlis title="Lista Áreas"
					campos = "MIGArid,MIGArcodigo,MIGArdescripcion" 
					desplegables = "N,S,S"
					modificables = "N,S,S"  
					tabla="MIGArea"
					columnas="MIGArid,MIGArcodigo,MIGArdescripcion"
					filtro="Ecodigo=#session.Ecodigo#"
					desplegar="MIGArcodigo, MIGArdescripcion"
					etiquetas="Codigo,Descripción"
					formatos="S,S"
					align="left,left"
					form="f2"
					filtrar_por="MIGArcodigo,MIGArdescripcion"
					tabindex="1"
					fparams="MIGArid"
					/>
					   
		</td>
		<td><img border='0' src='/cfmx/mig/imagenes/plus.gif' onClick='javascript:return funcOpen();'>	</td>
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
			nuevo = window.open('AreaForm.cfm?bandera=1&modo=ALTA&MIGRid=#form.MIGRid#','Caracteristicas','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
			</cfoutput>
			nuevo.focus();
			window.onfocus = closePopUp;
			
			return false;	
		}
		

function closePopUp(){
	if(nuevo) {
		if(!nuevo.closed) nuevo.close();
		nuevo=null;
		document.f2.submit();
  	}
}
</script>
<script type="text/javascript">
function validar2(formulario)	{
		var error_input;
		var error_msg = '';
		if (formulario.MIGArcodigo.value == "") {
			error_msg += "\n - El Área no puede quedar en blanco.";
			error_input = formulario.MIGArcodigo;
		}	
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
		else{
					var CodigoA=formulario.MIGArdescripcion.value;
					var CodigoReg=formulario.MIGRdescripcion.value; 
					if ( confirm('Desea Asociar el Área: '+ CodigoA +'   a la Región:  ' + CodigoReg ) ){ 
						if (window.deshabilitarValidacion) deshabilitarValidacion(); 
						return true;
					}
					else{ 
						return false;
					}
		}
}
</script>