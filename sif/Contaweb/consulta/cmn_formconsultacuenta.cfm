 <!---*********************** --->
<!---** AREA DE PINTADO    ** --->
<!---************************ --->
<!---********************************* --->
<!---** AREA DE IMPORTACION DE JS   ** --->
<!---********************************* --->
<SCRIPT LANGUAGE='Javascript'  src="../js/utilies.js"></SCRIPT>

<table width="100%" border="0" >
	<tr>
		<td width="100%">
		<!---********************************************************************************* --->
		<!---** 					INICIA PINTADO DE LA PANTALLA 							** --->
		<!---********************************************************************************* --->
			<form method="post" name="form1" 
			onSubmit="javascript:verificar()">
			<cfoutput>
			<table width="100%" border="0">
				<tr>
					<td>
						<strong>Segmento :</strong>
					</td>						
					<td>
						<cf_cjcConlis 	
							size		="5"  
							tabindex    ="1"
							name 		="CGE5COD" 
							desc 		="CGE5DES" 
							cjcConlisT 	="cjc_traeUEN"
							frame		="CGE5COD_FRM"
							>
					</td>
				</tr>
				<!---********************************************************************************* --->
				<tr>
					<cfinclude template="../reportes/CajaNegra/CajaNegraCuentas.cfm">
				</tr>
				<!---********************************************************************************* --->
				<tr>
					<td width="8%">
						<strong>Mascara :</strong>
					</td>
					<td width="92%">
						<strong><INPUT 	TYPE="textbox" 
							NAME="MASCARA" 
							VALUE="" 
							SIZE="50" 
							tabindex="1"
							MAXLENGTH="50" 
							readonly=""
							ONBLUR="" 
							ONFOCUS="this.select(); " 
							ONKEYUP="" 
							style="border: medium none; text-align:left; size:auto;"
						></strong>
						<input type="button"  id="verificar" name="verificar" value="verificar" onClick="consultar();">			
					</td>
				</tr>
				<!---********************************************************************************* --->
				<tr>
					<td  colspan=" 2" width="20%">
						<iframe id="FRAMECJNEGRA2" name="FRAMECJNEGRA2" marginheight="0" marginwidth="0" frameborder="0" height="500" width="750" src="" style="visibility:hiddens"></iframe>
					</td> 
				</tr>
				<!---********************************************************************************* --->
			</table>
			</cfoutput>

			<INPUT type="hidden" style="visibility:hidden" name="NivelDetalle" value="">
			<INPUT type="hidden" style="visibility:hidden" name="NivelTotal" value="">
			<INPUT type="hidden" style="visibility:hidden" name="ORIGEN" value="C">
		    </form>
		<!---********************************************************************************* --->
		<!---** 					   FIN PINTADO DE LA PANTALLA 						    ** --->
		<!---********************************************************************************* --->
		</td>
  	</tr>
</table>

<!---********************** --->
<!---** AREA DE SCRIPTS  ** --->
<!---********************** --->
<script language="JavaScript1.2" type="text/javascript">
	function valida(){
		if (document.form1.CGE5COD.value == "" || document.form1.CGE5DES.value == "") { alert("Debe digitar el segmento");  document.form1.CGE5COD.focus();return false}
		if (document.form1.CGM1IM.value == "") { alert("Debe digitar la cuenta mayor");  document.form1.CGM1IM.focus();return false}
		if (document.form1.CGM1CD.value == "") { alert("Debe digitar la cuenta detalle");  document.form1.CGM1CD.focus();return false}
		return true
	}
	function  consultar(){
		cargadetalle()		
		if(valida()){
			var  params = "?CGE5COD="+document.form1.CGE5COD.value+"&CGM1IM="+document.form1.CGM1IM.value+"&CGM1CD="+document.form1.CGM1CD.value;
			var frame  = document.getElementById("FRAMECJNEGRA2");
			frame.src 	= "/cfmx/sif/Contaweb/reportes/CajaNegra/cmn_validacion.cfm"+params;
		}
	}
</script> 
