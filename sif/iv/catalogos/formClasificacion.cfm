<!-- Establecimiento del modo -->
<cfset modo = 'ALTA'>
<cfif isdefined("url.arbol_pos") and len(trim(url.arbol_pos))>
	<cfset modo = 'CAMBIO'>
	<cfset form.Ccodigo = url.arbol_pos>
</cfif>
<!-- Consultas -->
<cfif modo neq 'ALTA'>
	<cfquery datasource="#session.DSN#" name="rsForm">
		select Ccodigo, rtrim(Ccodigoclas) as Ccodigoclas, Cdescripcion, coalesce(Ctolerancia, 0) as Ctolerancia,
				coalesce(Ccodigopadre, -1) as Ccodigopadre, Ccomision, Ctexto, ts_rversion, cuentac, CAid
		,Cformato,Creqcert, Cconsecutivo,'' as Cdescripcion2,'' as Ccuenta
		from Clasificaciones
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
		and Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.arbol_pos#" >
	</cfquery>
	<cfquery name="rsClasificacion" datasource="#session.DSN#">
		select Ccodigo as Ccodigopadre, Ccodigoclas as Ccodigoclaspadre, Cdescripcion as Cdescpadre, Cnivel as Nnivel<!---,Cformato,
        coalesce(Cdescripcion2,'') as Cdescripcion2,Ccuenta--->
		from Clasificaciones
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsForm.Ccodigopadre#">
	</cfquery>
</cfif>

<cfquery name="rsProfundidad" datasource="#session.DSN#">
	select coalesce(Pvalor,'1') as Pvalor
	from Parametros
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo=530
</cfquery>

<cfquery name="rsMascaraCodArt" datasource="#session.DSN#">
	select coalesce(Pvalor,'0') as Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo   = 5300
</cfquery>

<cfquery name="rsCtasServicio" datasource="#session.DSN#">
	select Pvalor
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Pcodigo = 892
</cfquery>

<!---<script src="../../js/utilesMonto.js" language="javascript1.2" type="text/JavaScript"></script> --->
<script language="JavaScript" type="text/JavaScript" src="../../js/utilesMonto.js"></script>

<!--- Pintado de la pantalla --->
<cfoutput>
	<form action="SQLClasificacion.cfm" method="post" name="form1" enctype="multipart/form-data">
		<table width="100%" border="0" cellpadding="2" cellspacing="0">
			<tr><td colspan="2"></tr>
			<tr>
				<td align="right" width="1%">C&oacute;digo:&nbsp;</td>
				<td>
					<input type="text" name="Ccodigoclas" size="10" tabindex="1" 
						<cfif modo NEQ 'ALTA'>readonly="true"</cfif> maxlength="5" 
						value="<cfif modo NEQ 'ALTA'>#rsForm.Ccodigoclas#</cfif>" 
						alt="C&oacute;digo de la Clasificaci&oacute;n" 
						onFocus="javascript:this.select();" >
				</td>
			</tr>
			<tr>
				<td align="right">Descripci&oacute;n:&nbsp;</td>
				<td>
					<input type="text" name="CdescripcionCL" size="60"  maxlength="80" tabindex="1" 
						value="<cfif modo NEQ 'ALTA'>#rsForm.Cdescripcion#</cfif>" 
						alt="La descripci&oacute;n de la Clasificaci&oacute;n" 
						onFocus="javascript:this.select();">
				</td>
			</tr>
			<tr>
				<td align="right" nowrap valign="middle">Clasificaci&oacute;n Padre:&nbsp;</td>
				<td>
					<cfif modo neq 'ALTA'>
						<cf_sifclasificacionarticulo query="#rsClasificacion#" id="Ccodigopadre" name="Ccodigoclaspadre" desc="Cdescpadre" tabindex="1">
					<cfelse>
						<cf_sifclasificacionarticulo id="Ccodigopadre" name="Ccodigoclaspadre" desc="Cdescpadre" tabindex="1">
					</cfif>
				</td>
			</tr>

			<tr>
				<td valign="baseline" align="right">C&oacute;digo Aduanal:&nbsp;</td>
				<td>
					<cfif isdefined('rsForm') and len(trim(rsForm.CAid)) gt 0>
						<cfquery name="rsCodAduanal" datasource="#session.dsn#">
							select CAid,CAcodigo,CAdescripcion 
							from CodigoAduanal
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
							  and CAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CAid#">
						</cfquery>
					</cfif>
					<cfset ArrayOF=ArrayNew(1)>
					<cfif isdefined("rsCodAduanal.CAid") and len(trim(rsCodAduanal.CAid))> 
						<cfset ArrayAppend(ArrayOF,rsCodAduanal.CAid)>
						<cfset ArrayAppend(ArrayOF,rsCodAduanal.Cacodigo)>
						<cfset ArrayAppend(ArrayOF,rsCodAduanal.CAdescripcion)>
					</cfif>
					<cf_conlis
						Campos="CAid,CAcodigo,CAdescripcion "
						Desplegables="N,S,S"
						Modificables="N,S,N"
						Size="0,10,40"
						ValuesArray="#ArrayOF#" 
						Title="Lista de Códigos Aduanales"
						Tabla="CodigoAduanal"
						Columnas="CAid,CAcodigo,CAdescripcion"
						Filtro=""
						Desplegar="CAcodigo,CAdescripcion"
						Etiquetas="C&oacute;digo,Descripci&oacute;n"
						filtrar_por="CAcodigo,CAdescripcion"
						Formatos="S,S"
						Align="left,left"
						Asignar="CAid,CAcodigo,CAdescripcion"
						Asignarformatos="S,S,S"
						MaxRowsQuery="200"
						MaxRows="15"
						top="225"
						left="200"
						height="400"
						tabindex="1"
						/>	
				</td>
			</tr>
			<tr>
				<td align="right" nowrap valign="middle">Porcentaje de Comisi&oacute;n:&nbsp;</td>
				<td>
					<input type="text" name="Ccomision" size="6" maxlength="6" style="text-align: right;" tabindex="1" 
						value="<cfif modo NEQ 'ALTA'>#LSCurrencyFormat(rsForm.Ccomision,'none')#<cfelse>0.00</cfif>" 
						onBlur="javascript:fm(this,2); porcentaje(this);"  
						onFocus="javascript:this.value=qf(this); this.select();"  
						onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
				</td>
			</tr>
			<tr>
				<td align="right" nowrap valign="middle">Tolerancia:&nbsp;</td>
				<td>
					<input 
						type="text" 
						name="Ctolerancia" 
						value="<cfif modo NEQ 'ALTA'>#LSCurrencyFormat(rsForm.Ctolerancia,'none')#<cfelse>0.00</cfif>"  
						size="6" 
						maxlength="6" 
						tabindex="1"
						style="text-align: right;" 
						onBlur="javascript:fm(this,2);"  
						onFocus="javascript:this.value=qf(this); this.select();"  
						onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
				</td>
			</tr>
            
                <tr style="display:<cfif trim(rsMascaraCodArt.Pvalor) eq "" or rsMascaraCodArt.Pvalor eq '0'>none</cfif>">
                    <td align="right" nowrap valign="middle">Consecutivo:&nbsp;</td>
                    <td>
                        <input 	type="text" 
                                name="consecutivo" 
                                value="<cfif modo neq 'ALTA'>#rsForm.Cconsecutivo#</cfif>"
                                size="6" 
                                maxlength="5" 
                                tabindex="1"
                                style="text-align: right;" 
                                onkeypress="return acceptNum(event)">
                    </td>
                </tr>
            
			 <tr>
			    <td align="right">
					<input name="Creqcert" type="checkbox" value="C" id="Creqcert" tabindex="1"
						<cfif modo neq 'ALTA' and isdefined("rsForm.Creqcert") and rsForm.Creqcert eq 1>checked</cfif>  >
				</td>
				<td nowrap valign="middle">
					<label for="Creqcert" style="font-style:normal; font-variant:normal; font-weight:normal">Certificaci&oacute;n</label>
				</td>
			</tr>
            <tr>
			    <td align="right">Cuenta de Gasto por Consumo:&nbsp;</td>
                <td nowrap>
                    <cfif modo EQ "ALTA">
                        <cf_cuentasanexo
                        auxiliares="S" 
                        movimiento="N"
                        conlis="S"
                        ccuenta="Ccuenta" 
                        cdescripcion="Cdescripcion2" 
                        cformato="Cformato" 
                        conexion="#Session.DSN#"
                        form="form1"
                        frame="frCuentac"
                        comodin="?" tabindex="7">
                    <cfelse>	
                        <cfquery name="rsCformato" dbtype="query">
                            select Ccuenta, Cdescripcion2 as cdescripcion, Cformato from rsForm
                        </cfquery>
						<cf_cuentasanexo
                        auxiliares="S" 
                        movimientos="N"
                        conlis="S"
                        ccuenta="Ccuenta" 
                        cdescripcion="Cdescripcion2" 
                        cformato="Cformato" 
                        conexion="#Session.DSN#"
                        form="form1"
                        frame="frCuentac"
                        query="#rsCformato#"
                        comodin="?" tabindex="7">
                    </cfif>
                </td>
            </tr>
            
            <tr>
            	<td>&nbsp;</td>
            <cfif rsCtasServicio.Pvalor EQ 1>
                <td colspan="3">Complementos: ! = Centro Funcional ? = Objeto de Gasto</td>
            <cfelseif rsCtasServicio.Pvalor EQ 2>
                <td colspan="3">Complementos: ! = Centro Funcional ? = Socio de Negocio</td>
            </cfif>
            </tr>
            
			<tr>
				<td align="right" nowrap valign="middle">Objeto de Gasto:&nbsp;</td>
				<td>
					<input name="cuentac" type="text" size="35" maxlength="100" style="text-align:left" tabindex="1"
						value="<cfif modo NEQ "ALTA">#rsForm.cuentac#</cfif>" 
						 onFocus="javascript:this.select();">
				</td>
			</tr>

			<tr>
				<td align="right" nowrap valign="middle">Imagen:&nbsp;</td>
				<td><input type="file" name="Cbanner" tabindex="1"></td>
			</tr>
			<tr>
				<td align="right" valign="top">Descripci&oacute;n Alterna:&nbsp;</td>
				<td>
					<textarea name="Ctexto" rows="5" cols="40" style="font-size:11px;" tabindex="1"><cfif modo neq 'ALTA'>#rsForm.Ctexto#</cfif></textarea>
				</td>
			</tr>
		<!--- *************************************************** --->
		<cfif modo NEQ 'ALTA'>
			<tr>
			  <td colspan="2" align="center" class="tituloListas">Complementos Contables</td>
			</tr>
			<tr><td colspan="2" align="center">
			<cf_sifcomplementofinanciero action='display'
					tabla="Clasificaciones"
					form = "form1"
					llave="#form.Ccodigo#" />
			</td></tr>
		</cfif>
		<!--- *************************************************** --->
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td align="center" valign="baseline" colspan="2" nowrap>
					<cfif modo neq "ALTA">
						<cfset masbotones = "Caracteristicas,Aplicar,AplicarCertificacion">
						<cfset masbotonesv = "Características,Aplicar Código Aduanal a Artículos,Aplicar Certificación a Artículos">
					<cfelse>
						<cfset masbotones = "">
						<cfset masbotonesv = "">
					</cfif>
					<cf_botones modo="#modo#" include="#masbotones#"  includevalues="#masbotonesv#" tabindex="1" >
				</td>
			</tr>
			<cfif modo neq 'ALTA'>
			<tr>
				<td align="center" valign="baseline" colspan="2">
                  <cfinclude template="formClasificacion-imagen.cfm">
				</td>	
			</tr>
			</cfif>
		</table>

		<cfif modo neq 'ALTA'>
			<cfset ts = "">	
			<cfinvoke 
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
			<input type="hidden" name="Ccodigo" value="#rsForm.Ccodigo#" >
			<input type="hidden" name="_Ccodigoclas" value="#rsForm.Ccodigoclas#" >
			<input type="hidden" name="ts_rversion" value="#ts#">
			<input type="hidden" name="_Ccodigopadre" value="#rsForm.Ccodigopadre#" >
		</cfif>
	    <input type="hidden" name="profundidad" value="<cfoutput>#trim(rsProfundidad.Pvalor)#</cfoutput>">
	</form>
</cfoutput>

<!--- Iframe para los códigos aduanales --->
<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>
<script language="JavaScript" type="text/JavaScript">
		function porcentaje(){
			var porcentaje = new Number(this.value)	
	
			if (porcentaje < 0){
				this.error = "El porcentaje debe ser mayor o igual a cero ";
			}		
			if (porcentaje > 100){
				this.error = "El porcentaje debe ser  menor o igual al 100 %";
			}
		}

	function Tolerancia_valida(){
		var Tolerancia = new Number(this.value)	

		if (Tolerancia < 0){
			this.error = "La tolerancia debe ser mayor o igual a cero ";
		}		
		if (Tolerancia > 100){
			this.error = "La tolerancia debe ser  menor o igual al 100 %";
		}
	}	
	document.form1.Ccodigoclas.focus();
	
	function funcCaracteristicas(){
		deshabilitarValidacion();
		document.form1.action = 'ClasificacionesDato.cfm';
		//document.form1.submit();
	}
	
	function funcCcodigoclaspadre(){
		if( document.form1.profundidad.value <= (parseInt(document.form1.Nnivel.value))+1 ){
			alert('El nivel de Clasificación seleccionada no corresponde al nivel máximo definido en Parámetros.\n Debe seleccionar otra Clasificación.');
			document.form1.Ccodigopadre.value = '';
			document.form1.Ccodigoclaspadre.value = '';
			document.form1.Cdescpadre.value = '';
			document.form1.Nnivel.value = '';
		}
	}
	//Valida solo Numeros 
	function acceptNum(evt){	
		var key = nav4 ? evt.which : evt.keyCode;	
		return (key <= 13 || (key >= 48 && key <= 57) || key == 46); 
	}
</script>
<cf_qforms>
	<cf_qformsRequiredField name="Ccodigoclas" description="Código">
	<cf_qformsRequiredField name="CdescripcionCL" description="Descripción">
	<cf_qformsRequiredField name="Ccomision" description="Porcentaje de Comisión" validate="porcentaje">
	<cf_qformsRequiredField name="Ctolerancia" description="Tolerancia" validate="Tolerancia_valida">
</cf_qforms>

<script language="JavaScript" type="text/JavaScript">
	function funcEliminarImg(){
		deshabilitarValidacion();
	}
	<!--// //poner a código javascript 
		//Form1
		/*objForm = new qForm("form1");
		<cfoutput>
		objForm.Ccodigoclas.description = "#JSStringFormat('Código')#";
		objForm.CdescripcionCL.description = "#JSStringFormat('Descripción')#";
		objForm.Ccodigopadre.description = "#JSStringFormat('Clasificación Padre')#";
		objForm.Ccomision.description = "#JSStringFormat('Porcentaje de Comisión')#";
		objForm.Ctolerancia.description = "#JSStringFormat('Tolerancia')#";
		_addValidator("isTolerancia", Tolerancia_valida);
		objForm.Ctolerancia.validateTolerancia();
		</cfoutput>
		
		}
		
		function habilitarValidacion(){
		objForm.Ccodigoclas.required = true;
		objForm.CdescripcionCL.required = true;
		objForm.Ccomision.required = true;
		objForm.Ctolerancia.required = true;
		}
		function deshabilitarValidacion(){
		objForm.Ccodigoclas.required = false;
		objForm.CdescripcionCL.required = false;
		objForm.Ccomision.required = false;
		objForm.Ctolerancia.required = false;
		}
		habilitarValidacion();*/
		
	//-->
	
	

	/*var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function traerCodAduanal(value){
		if (value!=''){
			document.getElementById("fr").src = '../../cm/operacion/traerCodAduanal.cfm?formulario=form1&CAcodigo='+value;
		}
		else{
			document.form1.CAid.value = '';
			document.form1.CAcodigo.value = '';
			document.form1.CAdescripcion.value = '';
		}
	}

	function doConlisCodAduanal() {
		popUpWindow("../../cm/operacion/conlisCodigosAduanales.cfm?formulario=form1",250,150,550,400);
	}*/

</script>