<cfparam name="URL.id">

<cfinvoke component="cmMisFunciones" 
	returnvariable="rs" 
	method="fnVerMonedas">
	<cfinvokeargument name="id" value="#URL.id#">
</cfinvoke>

<form name="f1">
	<table width="381">
		<tr>
			<td width="272">Id: <input type="text" name="txtId" width="50" 
				onClick="javascript:fnFocus(this)"
				onKeyPress="javascript:fnSiguiente(event,this,'txtNombre')"
			 	value="<cfoutput>#rs.Ecodigo#</cfoutput>">
			</td>
		</tr>
		<tr>
			<td>Moneda: <input type="text" name="txtNombre" width="200"
				onClick="javascript:fnFocus(this)"
				onKeyPress="javascript:fnSiguiente(event,this,'txtNombre')"				
				value="<cfoutput>#rs.Mnombre#</cfoutput>">
			</td>
		</tr>
		<tr>
			<td>Simbolo: <input type="text" name="txtSimbolo" width="20"
				onClick="javascript:fnFocus(this)"
				onKeyPress="javascript:fnSiguiente(event,this,'txtNombre')"				
				value="<cfoutput>#rs.Msimbolo#</cfoutput>">
			</td>
			<td width="113"><input type="button"
				value="Regresar" 
				onClick="javascript:fnUbicar('origen.cfm')">
			</td>
		</tr>    
  </table>
</form>

<script language="javascript1.2" type="text/javascript">
	function fnUbicar(url) {
		location.href=url;
	}
	
	function fnFocus(campo) {
		campo.select();
	}

	function fnSiguiente(tecla,campo,destino) {
		if (tecla.keyCode == 13) {
			switch(campo.name) {
				case 'txtId':fnFocus(document.forms.f1.txtNombre); break;
				case 'txtNombre':fnFocus(document.forms.f1.txtSimbolo); break;
				case 'txtSimbolo':fnFocus(document.forms.f1.txtId); break;
			}
		}
	}
</script>