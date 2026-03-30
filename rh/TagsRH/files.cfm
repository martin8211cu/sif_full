<cfparam name="Attributes.name" 	default="ruta"	type="string"> 		<!--- nombre del objeto --->
<cfparam name="Attributes.value" 	default="" 		type="string"> 	<!--- value del objeto --->
<cfparam name="Attributes.index" 	default="" 		type="String"> 		<!--- si hay varios campos iguales en pantalla, los diferencia con este atributo --->
<cfparam name="Attributes.form" 	default="form1" type="string"> 		<!--- nombre del form de la pagina --->
<cfparam name="Attributes.size" 	default="60"	type="string">  	<!--- tamanno del campo --->
<cfoutput>

<table>
	<tr>
		<td width="1%"><input name="#trim(attributes.name)##trim(attributes.index)#" type="text" id="#trim(attributes.name)##trim(attributes.index)#" onFocus="this.select();" value="#trim(attributes.value)#" size="#attributes.size#" maxlength="255" ></td>
		<td><a href="javascript:conlisFiles#attributes.index#()"><img src="/cfmx/rh/imagenes/foldericon.png" width="16" height="16" border="0"></a></td>
		</td>
	</tr>
</table>

<script>
	function closePopup#trim(attributes.index)#() {
		if (window.gPopupWindow#trim(attributes.index)# != null && !window.gPopupWindow#attributes.index#.closed ) {
			window.gPopupWindow#trim(attributes.index)#.close();
			window.gPopupWindow#trim(attributes.index)# = null;
		}
	}

	function conlisFiles#attributes.index#(){
		closePopup#trim(attributes.index)#();
		window.gPopupWindow#trim(attributes.index)# = window.open( '/cfmx/rh/Utiles/files.cfm?c=1&f=#trim(attributes.form)#&n=#trim(attributes.name)##trim(attributes.index)#&p='+escape(document.#trim(attributes.form)#.#trim(attributes.name)##trim(attributes.index)#.value),
															 '_blank',
															 'left=50,top=50,width=300,height=400,status=no,toolbar=no,title=no');
		window.onfocus = closePopup#trim(attributes.index)#;
	}
</script>
</cfoutput>