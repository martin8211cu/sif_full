<style type="text/css">
<!--
.style1 {
	font-size: 10px;
	font-weight: bold;
	color: #0000CC;
}
.style2 {color: #000000}
-->
</style>
<cfoutput>
<cfif isdefined ('form.MIGGid')>
	<cfquery name="rsJerarquia" datasource="#session.dsn#">
		select a.MIGDid,a.MIGDcodigo,a.MIGDnombre,b.MIGSDcodigo,b.MIGSDdescripcion,c.MIGGcodigo,c.MIGGdescripcion
		from  MIGDireccion a
			inner join MIGSDireccion b
				on a.MIGDid=b.MIGDid
			inner join MIGGerencia c
				on b.MIGSDid=c.MIGSDid
		where c.MIGGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MIGGid#">
	</cfquery>
</cfif>
<table width="47%" border="0" align="left">
	<tr>
		<td align="left"><span class="style1"><span class="style2">Direcci&oacute;n:</span>#rsJerarquia.MIGDcodigo#-#rsJerarquia.MIGDnombre#</span></td>
	</tr>
	<tr>
		<td align="left"><span class="style1"><span class="style2">Sub_Direcci&oacute;n:</span>#rsJerarquia.MIGSDcodigo#-#rsJerarquia.MIGSDdescripcion#</span></td>
	</tr>
	<tr>
		<td align="left"><span class="style1"><span class="style2">Gerencia:</span>#rsJerarquia.MIGGcodigo#-#rsJerarquia.MIGGdescripcion#</span></td>
	</tr>
	<tr>
		<td align="left" nowrap="nowrap" colspan="3"> 
			<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
				tabla="Departamentos a
						inner join MIGGerencia b
							on a.MIGGid=b.MIGGid
							and a.Ecodigo=b.Ecodigo
							and b.Dactiva=1"
				columnas="a.Dcodigo,b.MIGGid,a.Deptocodigo,a.Ddescripcion"
				desplegar="Deptocodigo, Ddescripcion"
				etiquetas="C&oacute;digo, Descripci&oacute;n"
				formatos="S,S"
				filtro="a.Ecodigo=#session.Ecodigo# and b.MIGGid=#form.MIGGid# Order By a.Deptocodigo"
				align="left,left,left"
				checkboxes="N"
				keys="Dcodigo"
				MaxRows="10"
				pageindex="65"
				showLink="false"
				filtrar_por="Deptocodigo, Ddescripcion, &nbsp;, &nbsp;"
				ira="Gerencia.cfm"
				showEmptyListMsg="true">
	  	</td>
	</tr>
</table>
<form name="form3" method="post" action="GerenciaSQL.cfm" onSubmit="return valida(this);">
<cfif isdefined ('form.MIGGid')>
	<input type="hidden" value="#form.MIGGid#" id="MIGGid" name="MIGGid" />
	<input type="hidden" value="#rsJerarquia.MIGGcodigo#"  name="MIGGcodigo" id="MIGGcodigo"/>
</cfif>
	<table  width="50%" border="0" align="right">
		<tr>
			<td width="61%" align="right" nowrap="nowrap"><strong>Departamento Asociado:</strong></td>
			<td width="1%" align="left" nowrap="nowrap">
				
				<cf_conlis title="Lista Departamentos"
						campos = "Dcodigo,Deptocodigo,Ddescripcion" 
						desplegables = "N,S,S"
						modificables = "N,S,S"  
						tabla="Departamentos"
						columnas="Dcodigo,Deptocodigo,Ddescripcion"
						filtro="Ecodigo = #Session.Ecodigo#"
						desplegar="Deptocodigo, Ddescripcion"
						etiquetas="Codigo,Descripción"
						formatos="S,S"
						align="left,left"
						form="form3"
						filtrar_por="Deptocodigo,Ddescripcion"
						tabindex="1"
						fparams="Dcodigo"
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
			var width = 750;
			var height = 450;
			var top = (screen.height - height) / 2;
			var left = (screen.width - width) / 2;
			<cfoutput>
			nuevo = window.open('formDepartamentos.cfm?bandera=1&modo=ALTA&MIGGid=#form.MIGGid#','Caracteristicas','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
			</cfoutput>
			nuevo.focus();
			window.onfocus = closePopUp;
			
			return false;	
		}
		

function closePopUp(){
	if(nuevo) {
		if(!nuevo.closed) nuevo.close();
		nuevo=null;
		document.form3.submit();
  	}
}
</script>
<script type="text/javascript">
function valida(formulario)	{
		var error_input;
		var error_msg = '';
		if (formulario.Dcodigo.value == "") {
			error_msg += "\n - La Gerencia no puede quedar en blanco.";
			error_input = formulario.Deptocodigo;
		}	
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
		else{
					var CodigoGe=formulario.MIGGcodigo.value;
					var CodigoDep=formulario.Deptocodigo.value; 
					if ( confirm('Desea Asociar el Departamento: '+ CodigoDep +'   a la Gerencia: ' + CodigoGe ) ){ 
						if (window.deshabilitarValidacion) deshabilitarValidacion(); 
						return true;
					}
					else{ 
						return false;
					}
		}		
}
</script>