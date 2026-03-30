<!--- 
	Modificado por: Gustavo Fonseca H.
		Fecha: 10-3-2006.
		Motivo: Se corrige la navegaciÃ³n del form por tabs para que tenga un orden lÃ³gico.
 --->

<script language="javascript" type="text/javascript">
	function delValor(cod) {
		if (confirm('Esta seguro de que desea eliminar el valor?')) {
			document.form2.CGARDid.value = cod;
			document.form2.BajaD.value = "1";
			document.form2.submit();
		}
	}
</script>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td class="tituloAlterno" align="center" style="text-transform: uppercase; ">
		Agregar Valores de Cat&aacute;logo de Cuenta al &Aacute;rea de Responsabilidad
	</td>
  </tr>
</table>

<script type="text/javascript" language="javascript1.2">
	var popUpWin=null;
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlis(CGARid){
		popUpWindow('/cfmx/sif/cg/catalogos/conlisValores.cfm?CGARid='+CGARid,250,200,650,550);
	}
	
	function TraeDato(CGARid, id) {
		var params ="";
		params = "?CGARid="+CGARid + "&id=" + id;

		if (id!="") {
			var fr = document.getElementById("framev");
			fr.src = "/cfmx/sif/cg/catalogos/sifvaloresquery.cfm"+params;
		}
		else{
			document.form2.PCDcatid.value = '';
			document.form2.PCDvalor.value = '';
			document.form2.PCDdescripcion.value = '';
		}
		return;
	}	
</script>

<form name="form2" method="post" action="AreaResponsabilidad-sqlValores.cfm" style="margin: 0;">
  	<cfinclude template="AreaResponsabilidad-hiddens.cfm">
	<input type="hidden" name="CGARDid" value="" tabindex="-1">
	<input type="hidden" name="BajaD" value="0" tabindex="-1">
	<table width="80%" border="0" cellspacing="0" cellpadding="0" align="center">
	  <tr>
		<td class="fileLabel" align="right">
		Valor de Cat&aacute;logo:
		</td>
		<td>
			<input type="hidden" name="PCDcatid" value="" tabindex="-1">
			<input type="text" size="20" maxlength="20" tabindex="3" name="PCDvalor" value="" onblur="javascript:TraeDato(<cfoutput>#Form.CGARid#</cfoutput>, this.value)" />
			<input type="text" size="62" readonly="readonly" tabindex="-1" maxlength="80" name="PCDdescripcion" value="" />
			<a href="javascript:doConlis(<cfoutput>#Form.CGARid#</cfoutput>);" tabindex="-1">
				<img src="/cfmx/sif/imagenes/Description.gif"
					alt="Valores de Cat&aacute;logo de Cuenta"
					name="imagen1"
					width="18" height="14"
					border="0" align="absmiddle">
			</a>		

			

			<!---
			<cf_conlis title="Valores de Cat&aacute;logo de Cuenta"
				campos = "PCDcatid, PCDvalor, PCDdescripcion" 
				desplegables = "N,S,S" 
				size = "0,20,80"
				tabla="CGAreaResponsabilidad a
						inner join PCDCatalogo b
						on b.PCEcatid = a.PCEcatid"
				columnas="b.PCEcatid, b.PCDcatid, b.PCDvalor, b.PCDdescripcion"
				filtro="a.CGARid = #Form.CGARid# order by b.PCDvalor"
				desplegar="PCDvalor, PCDdescripcion"
				etiquetas="Valor, Descripci&oacute;n"
				formatos="S,S"
				align="left,left"
				asignar="PCDcatid, PCDvalor, PCDdescripcion"
				asignarformatos="S,S,S"
				form="form2"
				showEmptyListMsg="true"
				debug="false">
				--->
		</td>
		<td align="right">
			<input type="submit" name="Alta" value="Agregar" tabindex="3">
		</td>
	  </tr>
	</table>
</form>

<table width="80%" border="0" cellspacing="0" cellpadding="2" align="center">
  <tr>
	<td>
		<div id="divValores" style="overflow:auto; height: 150; margin:0;" >
		<!--- <cf_dbfunction name="concat" returnvariable="LvarClick" args="<img border=''0'' src=''/cfmx/sif/imagenes/Borrar01_S.gif'' onClick=''javascript: delValor('''+#CGARDid_char#+''');''  onmouseover=javascript: this.style.cursor=''pointer'';>" delimiters="+"> --->
			<cf_dbfunction name="to_char" args="a.CGARDid" returnvariable="CGARDid_char">
			<cf_dbfunction name="concat" returnvariable="LvarClick" args="<img border=''0'' src=''/cfmx/sif/imagenes/Borrar01_S.gif'' onClick=''javascript:delValor('+#CGARDid_char#+')'' onmouseover=this.style.cursor=''pointer''>" delimiters="+">
		
			<cfinvoke
			 component="sif.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaDed">
				<cfinvokeargument name="tabla" value="CGAreaResponsabilidadD a
														inner join PCDCatalogo b
														 on b.PCDcatid = a.PCDcatid"/>
				<cfinvokeargument name="columnas" value="a.CGARDid, b.PCEcatid, b.PCDcatid, b.PCDvalor, b.PCDdescripcion, '#LvarClick#' as borrar"/>
				<cfinvokeargument name="filtro" value="a.CGARid = #Form.CGARid#"/>
				<cfinvokeargument name="desplegar" value="PCDvalor, PCDdescripcion, borrar"/>
				<cfinvokeargument name="etiquetas" value="Valor, Descripci&oacute;n, &nbsp;"/>
				<cfinvokeargument name="formatos" value="S,S,S"/>
				<cfinvokeargument name="align" value="left,left,right"/>
				<cfinvokeargument name="ajustar" value="S"/>
				<cfinvokeargument name="formName" value="formListaValores"/>
				<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="PageIndex" value="2"/>
				<cfinvokeargument name="keys" value="CGARDid"/>
				<cfinvokeargument name="maxRows" value="0"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="showLink" value="false"/>
				<cfinvokeargument name="debug" value="N"/>
			</cfinvoke>
		</div>
	</td>
  </tr>
</table>

<iframe id="framev" name="framev" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="no"></iframe>

<cf_qforms form="form2" objForm="objform2">

<script language="javascript" type="text/javascript">
	objform2.PCDvalor.required = true;
	objform2.PCDvalor.description = 'Valor de Catalogo';
</script>


