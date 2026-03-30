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
	select MIGPaid,MIGPacodigo,MIGPadescripcion
	from  MIGPais
	where MIGPaid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MIGPaid#">
</cfquery>

<table width="50%" border="0" align="left">
	<tr><td align="left" nowrap="nowrap"><span class="style1"><span class="style2">Pa&iacute;s:</span>#rsJerarquia.MIGPacodigo#-#rsJerarquia.MIGPadescripcion#</span></td>
	</tr>
	<tr>
		<td width="434" align="left" nowrap="nowrap"> 
			<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
				tabla="MIGRegion a
						inner join MIGPais b
							on a.MIGPaid=b.MIGPaid
							and a.Dactiva=1
							and b.Dactiva=1"
				columnas="a.MIGRid,b.MIGPaid,a.MIGRcodigo,a.MIGRdescripcion"
				desplegar="MIGRcodigo, MIGRdescripcion"
				etiquetas="C&oacute;digo, Descripci&oacute;n"
				formatos="S,S"
				filtro="a.MIGPaid=#form.MIGPaid# and a.Ecodigo=#session.Ecodigo# Order By a.MIGRcodigo"
				align="left,left"
				checkboxes="N"
				keys="MIGRid"
				showLink="false"
				MaxRows="15"
				pageindex="65"
				filtrar_por="MIGRcodigo, MIGRdescripcion, &nbsp;, &nbsp;"
				ira="Pais.cfm"
				showEmptyListMsg="true">
		</td>
	</tr>
</table>

<form name="f1" method="post" action="PaisSQL.cfm" onSubmit="return validar2(this);">
<cfif isdefined('form.MIGPaid')>
	<input type="hidden" name="MIGPaid" id="MIGPaid" value="#form.MIGPaid#" />
	<input type="hidden" name="MIGPadescripcion" id="MIGPadescripcion" value="#rsJerarquia.MIGPadescripcion#" />
</cfif>	  
<table align="right" border="0" width="50%">
	<tr>
		<td align="right" nowrap="nowrap"><strong>Regi&oacute;n Asociada:</strong></td>
		<td width="1%"  align="left" >
			<cf_conlis title="Lista Regiones"
					campos = "MIGRid,MIGRcodigo,MIGRdescripcion" 
					desplegables = "N,S,S"
					modificables = "N,S,S"  
					tabla="MIGRegion"
					columnas="MIGRid,MIGPaid,MIGRcodigo,MIGRdescripcion"
					filtro="Ecodigo=#session.Ecodigo#"
					desplegar="MIGRcodigo, MIGRdescripcion"
					etiquetas="Codigo,Descripción"
					formatos="S,S"
					align="left,left"
					form="f1"
					filtrar_por="MIGRcodigo,MIGRdescripcion"
					tabindex="1"
					fparams="MIGRid"
					/>
					   
		</td>
		<td><img border='0' src='/cfmx/mig/imagenes/plus.gif' onClick='javascript:return funcOpen();'>	</td>
	</tr>
	<tr>
		<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td align="left"  colspan="2">
		<input name="ASDir" type="submit" value="Asociar" tabindex="1"></td>
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
			nuevo = window.open('RegionForm.cfm?bandera=1&modo=ALTA&MIGPaid=#form.MIGPaid#','Caracteristicas','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
			</cfoutput>
			nuevo.focus();
			window.onfocus = closePopUp;
			
			return false;	
		}
		

function closePopUp(){
	if(nuevo) {
		if(!nuevo.closed) nuevo.close();
		nuevo=null;
		document.f1.submit();
  	}
}
</script>
<script type="text/javascript">
function validar2(formulario)	{
		var error_input;
		var error_msg = '';
		if (formulario.MIGRid.value == "") {
			error_msg += "\n - La Región no puede quedar en blanco.";
			error_input = formulario.MIGRid;
		}	
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
		else{
					var CodigoReg=formulario.MIGRdescripcion.value;
					var CodigoPais=formulario.MIGPadescripcion.value; 
					if ( confirm('Desea Asociar la Región: '+ CodigoReg +'   al País:  ' + CodigoPais ) ){ 
						if (window.deshabilitarValidacion) deshabilitarValidacion(); 
						return true;
					}
					else{ 
						return false;
					}
		}
}
</script>