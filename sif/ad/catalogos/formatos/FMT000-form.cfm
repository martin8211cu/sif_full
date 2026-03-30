<cfif isdefined("Form.FMT00COD") and len(trim(form.FMT00COD)) NEQ 0>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>

<script type="text/javascript">
<!--
	function funcExportar_Sybase() {
		location.href='exportar-tipo.cfm?dbms=syb&FMT00COD=<cfoutput>#URLEncodedFormat(url.FMT00COD)#</cfoutput>';
		return false;
	}
	function funcExportar_Oracle() {
		location.href='exportar-tipo.cfm?dbms=ora&FMT00COD=<cfoutput>#URLEncodedFormat(url.FMT00COD)#</cfoutput>';
		return false;
	}
	
	function switchSize(txt, size1, size2, cols1, cols2) {
		txt.rows = txt.rows == size1 ? size2 : size1;
		txt.cols = txt.cols == cols1 ? cols2 : cols1;
		txt.focus();
	}

	function validar(formulario)
	{
		var thisinput;
		// Validando tabla: FMT000 - FMT000
			
				// Columna: FMT00COD FMT00COD int
				thisinput = formulario.FMT00COD;
				if (thisinput.value == "") {
					alert("FMT00COD no puede quedar en blanco.");
					thisinput.focus();
					return false;
				}
			
				// Columna: FMT00DES FMT00DES varchar(80)
				thisinput = formulario.FMT00DES;
				if (thisinput.value == "") {
					alert("FMT00DES no puede quedar en blanco.");
					thisinput.focus();
					return false;
				}
			
				// Columna: FMT01SP2 FMT01SP2 varchar(30)
				thisinput = formulario.FMT01SP2;
				if (thisinput.value == "") {
					alert("FMT01SP2 no puede quedar en blanco.");
					thisinput.focus();
					return false;
				}
			
				// Columna: FMT01SP1 FMT01SP1 varchar(30)
				thisinput = formulario.FMT01SP1;
				if (thisinput.value == "") {
					alert("FMT01SP1 no puede quedar en blanco.");
					thisinput.focus();
					return false;
				}
			
					
		// Validacion terminada
		return true;
	}
//-->
</script>


	<cfquery datasource="sifcontrol" name="data">
		select FMT00COD, FMT00DES, FMT01SP1, FMT01SP2, FMT01SQL, ts_rversion
		from FMT000
		
			where 
			FMT00COD =
			<cfqueryparam cfsqltype="cf_sql_integer" value="#url.FMT00COD#" null="#Len(url.FMT00COD) Is 0#">
	</cfquery>
	<cfoutput>
		<form action="FMT000-apply.cfm" onsubmit="return validar(this);" method="post" name="formFMT000" id="formFMT000">
			
				
				
			
				
				
			
				
				
			
				
				
			
				
				
			
				
				
					
		
			<table summary="Tabla de entrada">
			<tr>
			  <td colspan="2" class="subTitulo">
			Definici&oacute;n del Tipo de Formato </td>
			</tr>
			
				
				
				<tr>
				  <td colspan="2" valign="top">N&uacute;mero</td>
			  </tr>
				<tr>
				  <td colspan="2" valign="top">
				
				  <input name="FMT00COD" type="text" value="#data.FMT00COD#" 
						<cfif Len(data.FMT00COD)>readonly</cfif>
						maxlength="11"
						onfocus="this.select()"  />				</td>
			    </tr>
				
			
				
				
				<tr>
				  <td colspan="2" valign="top">Descripci&oacute;n</td>
			  </tr>
				<tr>
				  <td colspan="2" valign="top">
				
				  <input name="FMT00DES" type="text" value="#data.FMT00DES#" 
						maxlength="80" size="45"
						onfocus="this.select()"  />				</td>
			    </tr>
				<tr>
				  <td colspan="2" valign="top">Consulta SQL <a tabindex="-1" href="javascript:switchSize(document.formFMT000.FMT01SQL, 10, 40, 40, 100  )" shape="rect">[agrandar / encoger]</a> </td>
			  </tr>
				<tr><td colspan="2" valign="top">
				  <textarea name="FMT01SQL" wrap="off" id="FMT01SQL" cols="40" rows="10" 
				  style="font-family:Arial, Helvetica, sans-serif;font-size:11px ">#HTMLEditFormat(data.FMT01SQL)#</textarea>
				</td></tr>
				
				<tr>
				  <td valign="top">Stored Proc Datos (*) </td>
				  <td rowspan="4" valign="top" style="border-left:2px solid gray">(*) Estos dos campos<br> 
				    no 
			      se van a utilizar <br>
			      en adelante,<br> 
			      solamente est&aacute;n para<br> 
			      compatibilidad con <br>
			      formatos viejos </td>
			  </tr>
				<tr>
				  <td valign="top">
				
				  <input name="FMT01SP1" type="text" value="#data.FMT01SP1#" 
						maxlength="30"
						onfocus="this.select()"  />					</td>
			    </tr>
				
				
				<tr>
				  <td valign="top">Stored Proc Columnas (*)</td>
			  </tr>
				<tr>
				  <td valign="top">
				
				  <input name="FMT01SP2" type="text" value="#data.FMT01SP2#" 
						maxlength="30"
						onfocus="this.select()"  />				</td>
			    </tr>
				
			
				
				
				
				
			
			<tr><td colspan="2" class="formButtons" nowrap>
				<cfif data.RecordCount>
					<cf_botones modo='CAMBIO' include='Exportar_Sybase,Exportar_Oracle'>
				<cfelse>
					<cf_botones modo='ALTA'>
				</cfif>
			</td></tr>
			<tr>
			  <td colspan="2" nowrap></td>
			  </tr>
			</table>
			<cfset ts = "">
			<cfif modo NEQ "ALTA">
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
					<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
				</cfinvoke>
			</cfif>  
			  <input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>" size="32">
		</form>
		
	</cfoutput>
	

