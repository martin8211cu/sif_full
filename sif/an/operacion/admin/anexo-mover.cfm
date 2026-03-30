<cfset LvarAnexoId = HTMLEditFormat( url.AnexoId )>

<cfquery name="rsHojas" datasource="#Session.dsn#">
	SELECT distinct AnexoHoja
	FROM AnexoCel
	WHERE AnexoId  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAnexoId#">
	ORDER BY AnexoHoja
</cfquery>

<cfquery name="rsAnexoDest" datasource="#session.dsn#">
	select coalesce(g.GAnombre, 'Sin agrupar') as GAnombre, g.GAid,
		a.AnexoId, coalesce (a.AnexoDes, 'Sin nombre') as AnexoDes
	from Anexo a
		left join AnexoGrupo g
			on g.GAid = a.GAid
		join AnexoPermisoDef pd
			on (pd.GAid = a.GAid or pd.AnexoId = a.AnexoId)
			and pd.Usucodigo = #session.Usucodigo#
			and pd.APedit = 1
		join AnexoEm ae
			on ae.AnexoId = a.AnexoId
			and ae.Ecodigo = #session.Ecodigo#
	where a.CEcodigo = #session.CEcodigo#
	order by g.GAnombre, a.AnexoDes
</cfquery>

<script language="javascript" type="text/javascript">
	<!-- 
		//Browser Support Code
		function ajaxFunction_ComboHojasDest(){
			var ajaxRequest;  // The variable that makes Ajax possible!
			var vAnexodst ='';
			vAnexodst = document.formmover.sel_Anexodst.value;
			vAnexosrc = '<cfoutput>#LvarAnexoId#</cfoutput>';
			try{
				// Opera 8.0+, Firefox, Safari
				ajaxRequest = new XMLHttpRequest();
			} catch (e){
				// Internet Explorer Browsers
				try{
					ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
				} catch (e) {
					try{
						ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
					} catch (e){
						// Something went wrong
						alert("Your browser broke!");
						return false;
					}
				}
			}
		
			ajaxRequest.open("GET", '/cfmx/sif/Utiles/Anexo_Combo.cfm?Anexodst='+vAnexodst+'&Anexosrc='+vAnexosrc, false);
			ajaxRequest.send(null);
			document.getElementById("contenedor_HojasDest").innerHTML = ajaxRequest.responseText;
		}
	//-->
</script>

<form name="formmover" method="get" action="anexo.cfm" style="margin:0" onsubmit="return validarCopia(this);">
	<cfoutput>
		<input type="hidden" name="tab" value="2">
		<input type="hidden" name="Mover2" value="1">
		<input type="hidden" name="AnexoId" value="# HTMLEditFormat( url.AnexoId ) #">
	</cfoutput>
	<table width="793" border="0" align="center" cellpadding="2" cellspacing="0">
	  <tr>
		<td width="10">&nbsp;</td>
		<td colspan="5" class="subTitulo">&nbsp;</td>
		<td width="34">&nbsp;</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
		<td colspan="5" class="subTitulo">Mover anexos </td>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
		<td colspan="5">Utilice esta página para mover la definición de una hoja de un anexo a otro, o al mismo anexo si se utiliza un nombre del hoja diferente. </td>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
		<td colspan="4">Para utilizar esta página, antes debe haber creado los rangos en el documento origen del anexo. Puede comprobar esto validando la 
		<cfoutput><a href="anexo.cfm?tab=2&AnexoId=# URLEncodedFormat(  url.AnexoId ) #">lista de rangos</a></cfoutput> del anexo seleccionado. </td>
		<td width="423" rowspan="10" align="center"><img src="../../images/anexo-rango-copy-srcdst.gif" alt="origen y destino" width="320" height="191" align="baseline"></td>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
		<td colspan="4" class="subTitulo">Mover del Origen </td>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
		<td>Hoja</td>
		<td colspan="3">
		<cfoutput>
			<select name="sel_Hojasrc">
				<cfloop query="rsHojas">
				  <option  value="#rsHojas.AnexoHoja#" <cfif rsHojas.CurrentRow is 1> selected</cfif> >#rsHojas.AnexoHoja#</option>
				</cfloop>
		  </select>
		</cfoutput>
		  </td>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
		<td colspan="4" class="subTitulo">Mover al Destino</td>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
		<td>Anexo</td>
		<td colspan="3">
		<cfoutput>
			<select name="sel_Anexodst" onchange="ajaxFunction_ComboHojasDest();">
			  <option  value="-1" selected>-- Seleccionar --</option>
				<cfloop query="rsAnexoDest">
				  <option  value="#rsAnexoDest.AnexoID#">#rsAnexoDest.AnexoDes#</option>
				</cfloop>
		  </select>
		</cfoutput>
		  </td>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
		<td>Hoja</td>
		<td colspan="3">
			<span id="contenedor_HojasDest">
				<cfoutput>
					<select name="sel_Hojadst" id="sel_Hojadst">
					</select>
				</cfoutput>
			</span>
		</td>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
	  	<td>&nbsp;</td>
	  	<td nowrap="nowrap" style="width:1%"><input name="SoloExistan" type="checkbox" id="SoloExistan" tabindex="1" value="1" /></td>
		<td colspan="5" ><label for="SoloExistan">Unicamente Rangos Existentes en el Destino</label></td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
		<td colspan="5">&nbsp;</td>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
		<td colspan="5">&nbsp;</td>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
		<td colspan="5" align="center"><cfoutput>
		  <input type="submit" name="Validar" value="Validar">
		  <input type="button" name="Cancelar" value="Cancelar" onclick="location.href='anexo.cfm?tab=2&amp;AnexoId=# URLEncodedFormat( url.AnexoId ) #'"></td>
		  </cfoutput>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
		<td colspan="5">&nbsp;</td>
		<td>&nbsp;</td>
	  </tr>
	</table>
</form>

<script type="text/javascript">
<!--

function validarCopia(f) {
	var msg = "";

	
	if(f.sel_Anexodst.value==<cfoutput>#LvarAnexoId#</cfoutput>) {
		if(f.sel_Hojasrc.value == f.sel_Hojadst.value) 
			{
			msg += "\n - El origen y destino de la copia no pueden traslaparse";
			}
	 }
	if(f.sel_Hojasrc.value == "") {
		msg += "\n - La Hoja Origen es requerida";
	}   

	if(f.sel_Anexodst.value == "" || f.sel_Anexodst.value == "-1") {
		msg += "\n - El Anexo Destino es requerido";
	} 
	 

	if (msg){
		alert("Valide la siguiente información:"+msg);
		return false;
	}
	
	return true;
}
//-->
</script>