<cfparam name="url.id_portlet" default="">


<cfquery datasource="asp" name="data">
	select id_portlet,nombre_portlet,url_portlet,
		w_portlet,h_portlet,BMfecha,BMUsucodigo,ts_rversion
	from SPortlet
	where id_portlet = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_portlet#" null="#Len(url.id_portlet) Is 0#">
</cfquery>



<cfoutput>

<script language="javascript1.2" type="text/javascript">
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function closePopup() {
		if (window.gPopupWindow != null && !window.gPopupWindow.closed ) {
			window.gPopupWindow.close();
			window.gPopupWindow = null;
		}
	}

	function conlisFiles() {
		closePopup();
		window.gPopupWindow = window.open('../../portal/catalogos/files.cfm?p='+escape(document.form1.url_portlet.value),'_blank',
			'left=50,top=50,width=300,height=400,status=no,toolbar=no,title=no');
		window.onfocus = closePopup;
	}
	
	function conlisFilesSelect(filename){
		document.form1.url_portlet.value = filename;
		closePopup();
		window.focus();
		document.form1.url_portlet.focus();
	}
	// ===========================================================================================
</script>


<script type="text/javascript">
<!--
	function validar(formulario)
	{
		var error_input;
		var error_msg = '';
		// Validando tabla: SPortlet - Portlet Reutilizable
				// Columna: nombre_portlet nombre_portlet varchar(30)
				if (formulario.nombre_portlet.value == "") {
					error_msg += "\n - nombre_portlet no puede quedar en blanco.";
					error_input = formulario.nombre_portlet;
				}
			
		
			
			
				// Columna: url_portlet url_portlet varchar(255)
				if (formulario.url_portlet.value == "") {
					error_msg += "\n - url_portlet no puede quedar en blanco.";
					error_input = formulario.url_portlet;
				}
			
		
			
			
		
			
			
		
			
			
					
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			error_input.focus();
			return false;
		}
		return true;
	}
//-->
</script>

<form action="SPortlet-apply.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
	<table summary="Tabla de entrada">
	<tr><td colspan="3" class="subTitulo">
	Portlet Reutilizable
	</td></tr>
	
	
		
		
			
		
	
		
		
		<tr>
		  <td colspan="2" valign="top"><strong>Nombre</strong></td><td width="67" valign="top">&nbsp;</td>
		</tr>
		
	
		
		
		<tr>
		  <td colspan="2" valign="top"><input name="nombre_portlet" type="text" id="nombre_portlet"
				onFocus="this.select()" value="#HTMLEditFormat(data.nombre_portlet)#" size="60" 
				maxlength="30"  ></td>
		  <td valign="top">&nbsp;</td>
	  </tr>
		<tr>
		  <td colspan="2" valign="top"><strong>URL</strong></td><td valign="top">&nbsp;</td>
		</tr>
		
	
		<tr>
		  <td colspan="2" valign="top"><input name="url_portlet" type="text" id="url_portlet"
				onFocus="this.select()" value="#HTMLEditFormat(data.url_portlet)#" size="60" 
				maxlength="255"  ></td>
		  <td valign="top"><a href="javascript:conlisFiles()" ><img width="16" height="16" src="foldericon.png" border="0"></a> </td>
	  </tr>
		
		
			
		
	
		
		
			
		
	
		
		
			
		
	
	    <tr>
	      <td class="formButtons"><strong>Alto</strong></td>
	      <td class="formButtons"><strong>Ancho</strong></td>
	      <td class="formButtons">&nbsp;</td>
      </tr>
	    <tr>
	      <td width="168" class="formButtons"><input name="h_portlet" type="text" id="h_portlet"
				onFocus="this.select()" value="#HTMLEditFormat(data.h_portlet)#" size="10" 
				maxlength="255"  >
	        px</td>
          <td width="188" class="formButtons"><input name="w_portlet" type="text" id="w_portlet"
				onFocus="this.select()" value="#HTMLEditFormat(data.w_portlet)#" size="10" 
				maxlength="255"  >
            px</td>
          <td class="formButtons">&nbsp;</td>
      </tr>
      <tr><td colspan="3" class="formButtons">
		<cfif data.RecordCount>
			<cf_botones modo='CAMBIO'>
		<cfelse>
			<cf_botones modo='ALTA'>
		</cfif>
	</td></tr>
	</table>
	
	
		
			<input type="hidden" name="id_portlet" value="#HTMLEditFormat(data.id_portlet)#">
		
	
		
			<input type="hidden" name="BMfecha" value="#HTMLEditFormat(data.BMfecha)#">
		
	
		
			<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(data.BMUsucodigo)#">
		
	
		
			<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
		
	
</form>

</cfoutput>


