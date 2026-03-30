<!---NOTA: La Forma de Cobro debe pasar a ser un combo con los valores de la tabla SSXCOB, por ahora esta estatica--->
<cfquery name="rsEntidades" datasource="#Attributes.Conexion#">
	select rtrim(a.EFid) as EFid, a.EFnombre
	from ISBentidadFinanciera a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
	and a.Habilitado = 1
	order by a.EFnombre, a.EFid
</cfquery>

<cfif ExisteCuenta>
	<cfquery name="rsCobroCuenta" datasource="#Attributes.Conexion#">
		select CTid, CTcobro, CTtipoCtaBco, CTbcoRef, CTmesVencimiento, CTanoVencimiento, CTverificadorTC, EFid, MTid, PpaisTH, CTcedulaTH, CTnombreTH, CTapellido1TH, CTapellido2TH, BMUsucodigo
		from ISBcuentaCobro 
		where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#val(rsCuenta.CTid)#">
	</cfquery>
	
	<cfif isdefined('rsCuenta') and ListFind('1,3',rsCuenta.Habilitado)>
		<cfset Attributes.readOnly = true >
	</cfif>
</cfif>



<cfoutput>
	<script language="javascript" type="text/javascript" src="../../js/saci.js">//</script>
	<input type="hidden" name="CTid" value="<cfif ExisteCuenta>#rsCuenta.CTid#</cfif>">
	<table width="100%" border="0" cellspacing="0" cellpadding="2">

	<cfif Attributes.readOnly>
	 <tr><td align="center">
	 	<table cellpadding="0" cellspacing="0" border="0">
			 <tr>
				<td width="23%" align="#Attributes.alignEtiquetas#" nowrap><label>Forma de Cobro</label></td>
				<td>	
					  	  <!---				1	RECIBO TELEFONICO
				2	CARGO SUJETO A TARJETA
				3	CARGO SUJETO A CUENTA BANCARIA
				4	CARGO A CUENTA CORRIENTE RACSA
				5	COBRANZA A DOMICILIO
--->
				<cfif rsCobroCuenta.RecordCount eq 0 or rsCobroCuenta.CTcobro eq 4> 
					&nbsp;Cuenta Corriente RACSA
				<cfelseif isdefined("rsCobroCuenta") and  isdefined("rsCobroCuenta.CTcobro") and rsCobroCuenta.CTcobro EQ "2">
					&nbsp;Descargo autom&aacute;tico a tarjeta
				<!---<cfelseif isdefined("rsCobroCuenta") and  isdefined("rsCobroCuenta.CTcobro") and rsCobroCuenta.CTcobro EQ "3">
					Pago autom&aacute;tico de recibos--->
				</cfif>
				</td>
			  </tr>
		</table>
	 </td></tr>
	<cfelse>
	  <tr>
		<!---<td align="#Attributes.alignEtiquetas#" nowrap><label>Forma de Cobro</label></td>--->
		<td align="center">
			<table <cfif not Attributes.porfila>width="100%"</cfif> border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td align="right"><input type="radio" name="CTcobro#Attributes.sufijo#" id="CTcobro1#Attributes.sufijo#" value="4" onclick="javascript: mostrarCTcobro(this.value);" tabindex="1" 
				<cfif isdefined("rsCobroCuenta") and rsCobroCuenta.RecordCount GT 0><cfif rsCobroCuenta.CTcobro EQ "4">checked</cfif></cfif>/></td>
				<td><label for="CTcobro1#Attributes.sufijo#">Cuenta Corriente RACSA</label></td>

			<cfif Attributes.porfila></tr><tr></cfif>	
				<td align="right"><input type="radio" name="CTcobro#Attributes.sufijo#" id="CTcobro2#Attributes.sufijo#"  value="2" onclick="javascript: mostrarCTcobro(this.value);" tabindex="1"
				<cfif isdefined("rsCobroCuenta") and rsCobroCuenta.RecordCount GT 0><cfif rsCobroCuenta.CTcobro EQ "2">checked</cfif></cfif>/></td>
				<td><label for="CTcobro2#Attributes.sufijo#">Descargo autom&aacute;tico a tarjeta</label></td>
			
			<cfif Attributes.porfila></tr><tr></cfif>
				<td align="right"><input type="radio" style="visibility:hidden; display:none" name="CTcobro#Attributes.sufijo#" id="CTcobro3#Attributes.sufijo#" value="3" onclick="javascript: mostrarCTcobro(this.value);" tabindex="1"
				<cfif isdefined("rsCobroCuenta") and rsCobroCuenta.RecordCount GT 0><cfif rsCobroCuenta.CTcobro EQ "3">checked</cfif></cfif>/></td>
				<td><label for="CTcobro3#Attributes.sufijo#" style="visibility:hidden; display:none">Pago autom&aacute;tico de recibos </label></td>
			  </tr>
			</table>
		</td>
	  </tr>
	 </cfif>
	  
	   <tr id="TC">
		<td width="100%">
			<table width="100%" border="0" cellpadding="2"  cellspacing="0">
			  <tr>
				<td class="subTitulo" align="center"><label>Tarjeta Cr&eacute;dito / D&eacute;bito</label></td>
			  </tr>
			  <tr>
				<td>
 					<cfif isdefined("rsCobroCuenta") and rsCobroCuenta.RecordCount GT 0 and rsCobroCuenta.CTcobro EQ "2">
						<cfquery name="rsDatosTarjeta" datasource="#Attributes.Conexion#">
							select CTbcoRef as NumTarjeta,
									CTmesVencimiento as MesTarjeta,
									CTanoVencimiento as AnoTarjeta,
									CTverificadorTC as VerificaTarjeta,
									PpaisTH as Ppais,
									MTid as MTid,
									CTcedulaTH as CedulaTarjeta,
									CTnombreTH as NombreTarjeta ,
									CTapellido1TH as Apellido1Tarjeta,
									CTapellido2TH as Apellido2Tarjeta
							from ISBcuentaCobro 
							where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuenta.CTid#">
						</cfquery>
					<cf_tarjeta
							query="#rsDatosTarjeta#"
							readonly="#Attributes.readOnly#"
							form="#Attributes.form#"
							sufijo="#Attributes.sufijo#"
							porfila="#Attributes.porfila#">
							
					<cfelse>
						<cf_tarjeta
						readonly="#Attributes.readOnly#"
						form="#Attributes.form#"
						sufijo="#Attributes.sufijo#"
						porfila="#Attributes.porfila#">
						
					</cfif> 						
				</td></tr>
			</table>
		</td>
	  </tr>
	  
	  <tr id="CB">
		<td width="100%">
			<table  width="100%" border="0" cellpadding="2"  cellspacing="0">
				  <tr>
					<td class="subTitulo" align="center"><label>Cuenta Bancaria</label></td>
				  </tr>
				  <tr>
					<td>
						<table width="100%" border="0" cellspacing="0" cellpadding="2">
						  <tr>
								<td align="#Attributes.alignEtiquetas#" nowrap><label>Banco</label></td>
								<td>
								
									<cfif isdefined("rsCobroCuenta") and rsCobroCuenta.RecordCount GT 0 and rsCobroCuenta.CTcobro EQ "3">
										 <cfset id_entidad = rsCobroCuenta.EFid>
									<cfelse>
										 <cfset id_entidad = "">
									</cfif>
									<cf_entidad
										id="#id_entidad#"
										readonly="#Attributes.readOnly#"
										sufijo="#Attributes.sufijo#"
										IFCCOD = "true"
										>
								</td>
								
							<cfif Attributes.porfila></tr><tr></cfif>
							
								<td align="#Attributes.alignEtiquetas#" nowrap><label>Tipo Cuenta</label></td>
								<td>
									<cfif Attributes.readOnly>
										<cfif isdefined("rsCobroCuenta") and  isdefined("rsCobroCuenta.CTtipoCtaBco") and rsCobroCuenta.CTtipoCtaBco EQ "C">
											Corriente
										<cfelseif isdefined("rsCobroCuenta") and  isdefined("rsCobroCuenta.CTtipoCtaBco") and rsCobroCuenta.CTtipoCtaBco EQ "A">
											Ahorro
										</cfif>										
									<cfelse>
										<select name="CuentaTipo#Attributes.sufijo#" tabindex="1">
											<option value="C"<cfif isdefined("rsCobroCuenta") and rsCobroCuenta.RecordCount GT 0 and rsCobroCuenta.CTtipoCtaBco EQ "C" and rsCobroCuenta.CTcobro EQ "3">selected</cfif>>Corriente</option>
											<option value="A"<cfif isdefined("rsCobroCuenta") and rsCobroCuenta.RecordCount GT 0 and rsCobroCuenta.CTtipoCtaBco EQ "A" and rsCobroCuenta.CTcobro EQ "3">selected</cfif>>Ahorro</option>
										</select>
									</cfif>
								</td>
						  </tr>
						  <tr>
								<td align="#Attributes.alignEtiquetas#" nowrap><label>N&uacute;m. Cuenta</label></td>
								<td>
									<cfif Attributes.readOnly>
										<cfif isdefined("rsCobroCuenta.CTbcoRef")and len(trim(rsCobroCuenta.CTbcoRef))>#HTMLEditFormat(rsCobroCuenta.CTbcoRef)#</cfif>
									<cfelse>	
										<!---<input type="text" name="NumCuenta#Attributes.sufijo#" onblur="javascript: validaBlancos(this);" value="<cfif isdefined("rsCobroCuenta") and rsCobroCuenta.RecordCount GT 0 and rsCobroCuenta.CTcobro EQ "3">#HTMLEditFormat(rsCobroCuenta.CTbcoRef)#</cfif>" size="30" maxlength="20" tabindex="1" />--->
										<cfset numCuenta = "">
										<cfif isdefined("rsCobroCuenta") and rsCobroCuenta.RecordCount GT 0 and rsCobroCuenta.CTcobro EQ "3">
											<cfset numCuenta = rsCobroCuenta.CTbcoRef>
										</cfif>
										<cf_campoNumerico name = "NumCuenta#Attributes.sufijo#" value = "#HTMLEditFormat(numCuenta)#" decimales="0" maxlength="20" tabindex="1">
									</cfif>
								</td>
						  <cfif Attributes.porfila></tr><tr></cfif>
								<td align="#Attributes.alignEtiquetas#" nowrap><label>C&eacute;dula</label></td>
								<td>
									<cfif Attributes.readOnly>
										<cfif isdefined("rsCobroCuenta.CTcedulaTH")and len(trim(rsCobroCuenta.CTcedulaTH))>#HTMLEditFormat(rsCobroCuenta.CTcedulaTH)#</cfif>
									<cfelse>
										<input type="text" name="CedulaCuenta#Attributes.sufijo#" onblur="javascript: quitaBlancos(this);" value="<cfif isdefined("rsCobroCuenta") and rsCobroCuenta.RecordCount GT 0>#HTMLEditFormat(rsCobroCuenta.CTcedulaTH)#</cfif>" size="25" maxlength="20" tabindex="1" />
									</cfif>
								</td>
						  </tr>
						  <tr>
								<td align="#Attributes.alignEtiquetas#" nowrap><label>Nombre</label></td>
								<td>
									<cfif Attributes.readOnly>
										<cfif isdefined("rsCobroCuenta.CTnombreTH")and len(trim(rsCobroCuenta.CTnombreTH))>#HTMLEditFormat(rsCobroCuenta.CTnombreTH)#</cfif>
									<cfelse>
										<input type="text" name="NombreCuenta#Attributes.sufijo#" onblur="javascript: validaBlancos(this);" value="<cfif isdefined("rsCobroCuenta") and rsCobroCuenta.RecordCount GT 0>#HTMLEditFormat(rsCobroCuenta.CTnombreTH)#</cfif>" size="25" maxlength="80" tabindex="1" />
									</cfif>
								</td>
						 
						 <cfif Attributes.porfila></tr><tr></cfif>
						 
								<td align="#Attributes.alignEtiquetas#" nowrap><label>Apellidos</label></td>
								<td>
									<table cellpadding="0" cellspacing="0" border="0">
										<tr>
											<td><cfif Attributes.readOnly>
													<cfif isdefined("rsCobroCuenta.CTapellido1TH")and len(trim(rsCobroCuenta.CTapellido1TH))>#HTMLEditFormat(rsCobroCuenta.CTapellido1TH)#</cfif>
												<cfelse>
													<input type="text" name="Apellido1Cuenta#Attributes.sufijo#" onblur="javascript: validaBlancos(this);" value="<cfif isdefined("rsCobroCuenta") and rsCobroCuenta.RecordCount GT 0>#HTMLEditFormat(rsCobroCuenta.CTapellido1TH)#</cfif>" size="25" maxlength="30" tabindex="1"/>
												</cfif>
											</td>
											<td><cfif Attributes.readOnly>
													<cfif isdefined("rsCobroCuenta.CTapellido2TH")and len(trim(rsCobroCuenta.CTapellido2TH))>#HTMLEditFormat(rsCobroCuenta.CTapellido2TH)#</cfif>
												<cfelse>
													<input type="text" name="Apellido2Cuenta#Attributes.sufijo#" value="<cfif isdefined("rsCobroCuenta") and rsCobroCuenta.RecordCount GT 0>#HTMLEditFormat(rsCobroCuenta.CTapellido2TH)#</cfif>" size="25" maxlength="30" tabindex="1"/>
												</cfif>
											</td>
										</tr>
									</table>
								</td>
						  </tr>
						</table>
					</td>
				  </tr>
				</table>
			</td>
		  </tr>
	</table>
	<script language="javascript1.2" type="text/javascript">
		function mostrarCTcobro(radio){
			//var CTcobro = radio.value;
			
			var CTcobro = radio;
			if(CTcobro == "4"){
				document.getElementById("TC").style.display="none";
				document.getElementById("CB").style.display="none";
			}
			else if(CTcobro == '2'){
				document.getElementById("TC").style.display="";
				document.getElementById("CB").style.display="none";
			}
			else if(CTcobro == '3'){
				document.getElementById("TC").style.display="none";
				document.getElementById("CB").style.display="";
			} 
		}
		
		<cfif ExisteCuenta and Isdefined('rsCobroCuenta') and Len(Trim(rsCobroCuenta.CTcobro))>
			mostrarCTcobro("#rsCobroCuenta.CTcobro#");
		<cfelse>
			mostrarCTcobro("4");
		</cfif>
		
		//mostrarCTcobro(document.form1.CTcobro.value);
	</script>
</cfoutput>