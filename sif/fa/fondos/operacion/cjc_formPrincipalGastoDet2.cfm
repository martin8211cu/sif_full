<style type="text/css">
	.estilo {  
	 border-style: solid; 
	 border-width: 1px; 
	 padding: 1px;
	 border-top: 1px solid buttonshadow;
	 border-left: 1px solid buttonshadow;
	 border-right: 1px solid buttonshadow;
	 border-bottom: 1px solid buttonshadow;
	 color: #000000;
	}
</style>

<!--- class="estilo"  --->
	<!---************************************************************ --->
	<!---*********            ACFI -Activos Fijos        	********* --->
	<!---************************************************************ --->
	<div id='ACFI' style=" display:none ">
	<table >
		<tr>
			<td><strong>Placa</strong></td>
			<td><INPUT ONFOCUS=""  NAME="AF4PL" ID="AF4PL" VALUE="" size= "20" MAXLENGTH= "17" tabindex="3"></td>
		</tr>
		<tr>		
			<td><strong>Cédula</strong></td>
			<td><INPUT ONFOCUS=""  NAME="AF25C" ID="AF25C" VALUE="" size= "20" MAXLENGTH= "25" tabindex="3"></td>
		</tr>
		<tr>		
			<td><strong>Categoría</strong></td>
			<td><INPUT ONFOCUS=""  NAME="AF2CA" ID="AF2CA" VALUE="" size= "20" MAXLENGTH= "8" tabindex="3"></td>
		</tr>
		<tr>		
			<td><strong>Clase</strong></td>
			<td><INPUT ONFOCUS=""  NAME="AF3CO" id="AF3CO" VALUE="" size= "20" MAXLENGTH= "5" tabindex="3"></td>
		</tr>
		<tr>		
			<td><strong>Centro Func.</strong></td>	
			<td><INPUT ONFOCUS=""  NAME="CENFU"  id="CENFU" VALUE="" size= "20" MAXLENGTH= "13" tabindex="3"></td>
		</tr>
	</table>
	</div>
	<!---************************************************************ --->
	<!---*********            CA06 -Auxiliar Empleados		********* --->
	<!---************************************************************ --->
	<div id='CA06' style=" display:none ">
	<table >
		<tr>
			<td><strong>Ced. Fisica</strong></td>
			<td><INPUT ONFOCUS=""  NAME="CEDF" id= "CEDF"	VALUE="" size= "20" MAXLENGTH= "15" tabindex="3"></td>
		</tr>
		<tr>
			<td><strong>Empleado</strong></td>
			<td><INPUT ONFOCUS=""  NAME="EMPL" id="EMPL" 	VALUE="" size= "20" MAXLENGTH= "50" tabindex="3"></td>
		</tr>	
	</table>
	</div>
	<!---************************************************************ --->
	<!---*********            CA01 -Aux Empleados Herram 	********* --->
	<!---************************************************************ --->
	<div id='CA01' style=" display:none ">
	<table >
		<td><strong>Vale &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong></td>
			<td><INPUT ONFOCUS=""  NAME="VALE" id="VALE"	VALUE="" size= "20" MAXLENGTH= "15" tabindex="3"></td>
		</tr>	
	</table>
	</div>
	<!---************************************************************ --->
	<!---*********            CA02 -Auxiliar Empresas		********* --->
	<!---************************************************************ --->
	<div id='CA02' style=" display:none ">
	<table >
		<tr>
			<td><strong>Orden de Compra</strong></td>
			<td><INPUT ONFOCUS=""  NAME="ORDEN"  ID="ORDEN" VALUE="" size= "20" MAXLENGTH= "15" tabindex="3"></td>
		</tr>
		<tr>
			<td><strong>Empresa</strong></td>	
			<td><INPUT ONFOCUS=""  NAME="NOME" ID="NOME" 	VALUE="" size= "20" MAXLENGTH= "50" tabindex="3"></td>
		</tr>	
	</table>
	</div>
	<!---************************************************************ --->
	<!---*********            CA07 -Aux. Empresas Impor		********* --->
	<!---************************************************************ --->
	<div id='CA07' style=" display:none ">
	<table >
		<tr>
			<td><strong>No. Poliza  &nbsp;&nbsp;&nbsp;</strong></td>
			<td><INPUT ONFOCUS=""  NAME="POLIZ"  ID="POLIZ" VALUE="" size= "20" MAXLENGTH= "10" tabindex="3"></td>
		</tr>
	</table>
	</div>	
	<!---************************************************************ --->
	<!---*********            C1 -Fecha					 	********* --->
	<!---************************************************************ --->
	<div id='C1' style=" display:none ">
	<table >
		<tr>
			<td><strong>Fecha&nbsp; &nbsp; &nbsp;</strong></td>	
			<!---<td><INPUT ONFOCUS=""  NAME="FECHA" ID="FECHA" VALUE="" size= "20" MAXLENGTH= "10"></td>--->
			<td><cf_CJCcalendario tabindex    ="3" name="FECHA" form="form1" ><td>
		</tr>
	</table>
	</div>
	<!---************************************************************ --->
	<!---*********            C2 -Tipo Entidad		.		********* --->
	<!---************************************************************ --->
	<div id='C2' style=" display:none ">
	<table >
		<tr>
			<td><strong>Tipo Entidad</strong></td>
			<td>
			<select name="TIPEN"  ID="TIPEN" tabindex="3">
			<option value="1">Céd. Jurídica</option>
			<option value="2">Céd. Fisica</option>
			<option value="3">Pasaporte</option>
			<option value="7">Num. Teléfono</option>
			<option value="10">Num. Cheque</option>
			</select>
			</td>
		</tr>
	</table>
	</div>
	
	<!---************************************************************ --->
	<!---*********            CA03 -Aux Pagares Telef.		********* --->
	<!---************************************************************ --->
	<div id='CA03' style=" display:none ">
	<table >
		<tr>
			<td><strong>Número</strong></td>
			<td><INPUT ONFOCUS=""  NAME="NUM"  ID="NUM"	VALUE="" size= "20" MAXLENGTH= "15" tabindex="3"></td>
		</tr>
		<tr>
			<td><strong>Nombre</strong></td>
			<td><INPUT ONFOCUS=""  NAME="NOM" 	ID="NOM" VALUE="" size= "20" MAXLENGTH= "50" tabindex="3"></td>
		</tr>
		<tr>
			<td><strong>Recibo</strong></td>
			<td><INPUT ONFOCUS=""  NAME="RECIB"  ID="RECIB" VALUE="" size= "20" MAXLENGTH= "15" tabindex="3"></td>
		</tr>
	</table>
	</div>
	<!---************************************************************ --->
	<!---*********            C4 -Número &	Nombre			********* --->
	<!---************************************************************ --->
	<div id='C4' style=" display:none ">
	<table >
		<tr>
			<td><strong>Número &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong></td>
			<td><INPUT ONFOCUS=""  NAME="NUMEN" ID="NUMEN" VALUE="" size= "20" MAXLENGTH= "15" tabindex="3"></td>
		</tr>
		<tr>
			<td><strong>Nombre &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong></td>
			<td><INPUT ONFOCUS=""  NAME="NOMEN" ID="NOMEN" VALUE="" size= "20" MAXLENGTH= "50" tabindex="3"></td>
		</tr>
	</table>
	</div>
	<!---************************************************************ --->
	<!---*********            CA04 -Dev. Cheq_Cobro Judi	********* --->
	<!---************************************************************ --->
	<div id='CA04' style=" display:none ">
	<table >
		<tr>
			<td><strong>Tipo Doc.</strong></td>
			<td>
				<INPUT ONFOCUS=""  NAME="TIPDO" ID="TIPDO" VALUE="" size= "20" MAXLENGTH= "2"
				ONBLUR="javascript: fm(this,0);" 
				ONFOCUS="javascript: this.value=qf(this); this.select(); " 
			    ONKEYUP="javascript: if(snumber(this,event,0)){ if(Key(event)=='13'){this.blur();}} "
				tabindex="3" >
			</td>
		</tr>
		<tr>
			<td><strong>Documento</strong></td>
			<td><INPUT ONFOCUS=""  NAME="DOC"  ID="DOC" VALUE="" size= "20" MAXLENGTH= "15" tabindex="3"></td>	
		</tr>
	</table>
	</div>
	<!---************************************************************ --->
	<!---*********            CA05 -Depositos Garantia		********* --->
	<!---************************************************************ --->
	<div id='CA05' style=" display:none ">
	<table >
		<tr>
			 <td><strong>Núm. Recibo</strong></td>
			<td><INPUT ONFOCUS=""  NAME="NUMRE" ID="NUMRE" VALUE="" size= "20" MAXLENGTH= "15" tabindex="3"></td>
		</tr>	
	</table>
	</div>
	<!---************************************************************ --->
	<!---*********            C3 -Fecha Recibo				********* --->
	<!---************************************************************ --->
	<div id='C3' style=" display:none ">
	<table >
		<tr>
			<td><strong>Fecha Recibo</strong></td>
			<!---<td><INPUT ONFOCUS=""  NAME="FECRE" ID="FECRE" VALUE="" size= "20" MAXLENGTH= "10"></td>--->
			<td><cf_CJCcalendario  tabindex    ="3" name="FECRE" form="form1" ><td> 	
		</tr>
	</table>
	</div>
	<!---************************************************************ --->
	<!---*********            TRAN2-Transportes para rep	********* --->
	<!---************************************************************ --->
	<div id='TRAN2' style=" display:none ">
	<table >
		<tr>
			<td><strong>No. Vehículo&nbsp;</strong></td>
			<td><INPUT ONFOCUS=""  NAME="NOVEH" ID="NOVEH" VALUE="" size= "20" MAXLENGTH= "16"
				ONBLUR="javascript: fm(this,0);" 
				ONFOCUS="javascript: this.value=qf(this); this.select(); " 
			    ONKEYUP="javascript: if(snumber(this,event,0)){ if(Key(event)=='13'){this.blur();}} "
				tabindex="3"
				></td>
		</tr>
		<tr>
			<td><strong>Kilometraje&nbsp;</strong></td>
			<td><INPUT ONFOCUS=""  NAME="KILOM" ID="KILOM" VALUE="" size= "20" MAXLENGTH= "16"
				ONBLUR="javascript: fm(this,0);" 
				ONFOCUS="javascript: this.value=qf(this); this.select(); " 
			    ONKEYUP="javascript: if(snumber(this,event,0)){ if(Key(event)=='13'){this.blur();}} "
				tabindex="3"
				></td>		
		</tr>	
	</table>
	</div>
	<!---************************************************************ --->
	<!---*********            TRANS-Transportes				********* --->
	<!---************************************************************ --->
	<div id='TRANS' style=" display:none ">
	<table >
		<tr>
			<td><strong>Cantidad Lts.</strong></td>
			<td><INPUT ONFOCUS=""  NAME="CANT" ID="CANT" 	VALUE="" size= "20" MAXLENGTH= "6"
				ONBLUR="javascript: fm(this,2);" 
				ONFOCUS="javascript: this.value=qf(this); this.select(); " 
			    ONKEYUP="javascript: if(snumber(this,event,2)){ if(Key(event)=='13'){this.blur();}} "
				tabindex="3"
				></td>
		</tr>
	</table>
	</div>
