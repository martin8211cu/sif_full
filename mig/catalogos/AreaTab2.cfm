<style type="text/css">
<!--
.style2 {color: #000000}
.style4 {font-size: 10px; font-weight: bold; color: #0000CC; }
-->
</style>

<cfoutput>
	<cfquery name="rsJerarquia" datasource="#session.dsn#">
		select a.MIGPaid,a.MIGPacodigo,a.MIGPadescripcion,b.MIGRid,b.MIGRcodigo,b.MIGRdescripcion,c.MIGArcodigo,c.MIGArdescripcion
		from  MIGPais a
			inner join MIGRegion b
				on a.MIGPaid=b.MIGPaid
			inner join MIGArea c
				on b.MIGRid=c.MIGRid
		where c.MIGArid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MIGArid#">
	</cfquery>	
<table width="50%" border="0" align="left">
	<tr>
		<td align="left"><span class="style4"><span class="style2">Pa&iacute;s:</span>#rsJerarquia.MIGPacodigo#-#rsJerarquia.MIGPadescripcion#</span></td>
	</tr>
	<tr>
		<td><span class="style4"><span class="style2">Regi&oacute;n:</span>#rsJerarquia.MIGRcodigo#-#rsJerarquia.MIGRdescripcion#</span></td>
	</tr>
	<tr>
		<td><span class="style4"><span class="style2">&Aacute;rea:</span>#rsJerarquia.MIGArcodigo#-#rsJerarquia.MIGArdescripcion#</span></td>
	</tr>
	<tr>
		<td width="434" align="left" nowrap="nowrap"> 
			<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
				tabla="MIGDistrito a
						inner join MIGArea b
							on a.MIGArid=b.MIGArid
							and a.Dactiva=1
							and b.Dactiva=1"
				columnas="a.MIGDiid,a.MIGArid,b.MIGArid,a.MIGDicodigo,a.MIGDidescripcion"
				desplegar="MIGDicodigo, MIGDidescripcion"
				etiquetas="C&oacute;digo, Descripci&oacute;n"
				formatos="S,S"
				filtro="a.MIGArid=#form.MIGArid# Order By a.MIGDicodigo"
				align="left,left"
				checkboxes="N"
				keys="MIGDiid"
				showLink="false"
				MaxRows="15"
				pageindex="65"
				filtrar_por="MIGDicodigo, MIGDidescripcion, &nbsp;, &nbsp;"
				ira="Area.cfm"
				showEmptyListMsg="true">
		</td>
	</tr>
</table>

<form name="f2" method="post" action="AreaSQL.cfm" onSubmit="return validar2(this);">
<cfif isdefined('form.MIGArid')>
	<input type="hidden" name="MIGArid" id="MIGArid" value="#form.MIGArid#" />
	<input type="hidden" name="MIGArdescripcion" id="MIGArdescripcion" value="#rsJerarquia.MIGArdescripcion#" />
</cfif>	  
<table align="right" border="0" width="50%">
	<tr>
		<td align="right" nowrap="nowrap"><strong>Distrito Asociado:</strong></td>
		<td width="1%"  align="left" >
			<cf_conlis title="Lista Distritos"
					campos = "MIGDiid,MIGDicodigo,MIGDidescripcion" 
					desplegables = "N,S,S"
					modificables = "N,S,S"  
					tabla="MIGDistrito"
					columnas="MIGDiid,MIGArid,MIGDicodigo,MIGDidescripcion"
					filtro="Ecodigo=#session.Ecodigo#"
					desplegar="MIGDicodigo, MIGDidescripcion"
					etiquetas="Codigo,Descripción"
					formatos="S,S"
					align="left,left"
					form="f2"
					filtrar_por="MIGDicodigo,MIGDidescripcion"
					tabindex="1"
					fparams="MIGDiid"
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
			nuevo = window.open('DistritoForm.cfm?bandera=1&modo=ALTA&MIGArid=#form.MIGArid#','Caracteristicas','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
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
		if (formulario.MIGDicodigo.value == "") {
			error_msg += "\n - El Distrito no puede quedar en blanco.";
			error_input = formulario.MIGDicodigo;
		}	
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
		else{
					var CodigoD=formulario.MIGDidescripcion.value;
					var CodigoA=formulario.MIGArdescripcion.value; 
					if ( confirm('Desea Asociar el Distrito: '+ CodigoD +'   al Área:  ' + CodigoA ) ){ 
						if (window.deshabilitarValidacion) deshabilitarValidacion(); 
						return true;
					}
					else{ 
						return false;
					}
		}
}
</script>