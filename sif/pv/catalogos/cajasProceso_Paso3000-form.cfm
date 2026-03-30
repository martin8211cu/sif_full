<cfset modo = 'ALTA'>
<cfif  isdefined('form.FAM01COD') and len(trim(form.FAM01COD))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfquery name="rsMaq" datasource="#session.dsn#">
	select FAM09MAQ,FAM09DES
	from FAM009
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and FAM09MAQ=<cfqueryparam cfsqltype="cf_sql_tinyint" value="#form.FAM09MAQ#">
</cfquery>	

<cfif modo eq 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select Ocodigo, FAM01COD, FAM01CODD, FAM09MAQ, FAM01DES, FAM01RES, FAM01TIP, FAM01COB,
		FAM01STS, FAM01STP,Ccuenta, I02MOD, CCTcodigoAP, CCTcodigoDE, CCTcodigoFC, CCTcodigoCR,
		CCTcodigoRC, FAM01NPR, FAM01NPA, Aid, Mcodigo, FAM01TIF, FAPDES, ts_rversion
		from FAM001
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FAM01COD#">
	</cfquery>
	

	<!--- QUERY PARA el tag de MONEDAS--->
	<cfquery name="rsMonedas" datasource="#Session.DSN#" >
		Select Mcodigo, Mnombre, Msimbolo, Miso4217, ts_rversion
		from Monedas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Mcodigo#" >
		order by Mnombre
	</cfquery>

	<!--- QUERY PARA el tag de ALMACENES--->
	<cfif len(trim(data.Aid))>
		<cfquery name="rsAlmacenes" datasource="#Session.DSN#" >
			Select Aid, Almcodigo, Bdescripcion
			from Almacen
			where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and Aid=<cfqueryparam value="#data.Aid#" cfsqltype="cf_sql_numeric">
		</cfquery>
	</cfif>

	<!--- QUERY PARA el tag de CCuentas--->
	<cfif len(trim(data.Ccuenta))>
		<cfquery name="rsCuentas" datasource="#Session.DSN#" >
			Select Ccuenta, Cformato, Cdescripcion
			from CContables
			where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and Ccuenta=<cfqueryparam value="#data.Ccuenta#" cfsqltype="cf_sql_numeric">
		</cfquery>
	</cfif>
	
	<!--- QUERY PARA el tag de Oficinas--->
	<cfif len(trim(data.Ocodigo))>
		<cfquery name = "rsOficinas" datasource="#session.DSN#">
			select Pista_id, Ecodigo, Ocodigo, Codigo_pista, Descripcion_pista, Pestado, BMUsucodigo, ts_rversion
			from   Pistas
			where  Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value= "#data.Ocodigo#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value= "#session.Ecodigo#">
		</cfquery>
	</cfif>
</cfif>

<!--- QUERY PARA el tag de TRANSACCIONES--->
<cfquery name="rsTransacciones" datasource="#session.dsn#">
	select CCTcodigo, CCTdescripcion, CCTtipo
	from CCTransacciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by 1      
</cfquery>

<!---pinta el formulario--->
<cfoutput>
	<form name="form1" method="post" action="cajasProceso_Paso3-sql.cfm" onSubmit="javascript: return validar(this);">
		<input type="hidden" name="FAM01COD" value="#form.FAM01COD#">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr><!--- dibuja CODIGO MAQUINA--->
				<td width="46%"><strong>M&aacute;quina</strong></td>
				<!--- dibuja CODIGO EXTERNO--->
				<td width="54%"><strong>C&oacute;digo</strong></td>
			</tr>
			<tr>
				<td>
					#rsMaq.FAM09DES#
					<input type="hidden" id="FAM09MAQ" name="FAM09MAQ" value="#rsMaq.FAM09MAQ#">				
				</td>
				<td><input type="text" name="FAM01CODD" size="10" maxlength="4" value="<cfif modo neq 'ALTA'>#data.FAM01CODD#</cfif>"></td>
			</tr>
			<tr>
				<td><strong>Descripci&oacute;</strong></td><!--- dibuja DESCRIPCION--->
				<td><strong>Responsable</strong></td><!--- dibuja RESPONSABLE--->
			</tr>
			<tr>
				<td><input type="text" name="FAM01DES" size="20" maxlength="40" value="<cfif modo neq 'ALTA'>#data.FAM01DES#</cfif>"></td>
				<td><input type="text" name="FAM01RES" size="20" maxlength="40" value="<cfif modo neq 'ALTA'>#data.FAM01RES#</cfif>"></td>
			</tr>
			<tr>
				<td><strong>Interfaz de Entrada&nbsp;</strong></td><!--- dibuja INTERFAZ DE ENTRADA--->
				<td><strong>Interfaz de Salida&nbsp;</strong></td><!--- dibuja INTERFAZ DE SALIDA--->
			</tr>
			<tr>
				<td><input type="text" name="FAM01NPR" size="20" maxlength="50" value="<cfif modo neq 'ALTA'>#data.FAM01NPR#</cfif>"></td>
				<td><input type="text" name="FAM01NPA" size="20" maxlength="50" value="<cfif modo neq 'ALTA'>#data.FAM01NPA#</cfif>"></td>
			</tr>
			<tr>
				<td><strong>Tipo</strong></td><!--- dibuja TIPO  --->
				<td><strong>Tipo de Cobro&nbsp;</strong></td><!--- dibuja TIPO DE COBRO--->
			</tr>
			<tr>
				<td height="23">
					<select name="FAM01TIP">
						<option value="">-seleccionar-</option>
						<option value="1"<cfif modo NEQ 'ALTA' and data.FAM01TIP EQ 1> selected </cfif>>Factura de Inventario</option>
						<option value="2"<cfif modo NEQ 'ALTA' and data.FAM01TIP EQ 2> selected </cfif>>Factura de Servicios</option>
						<option value="3"<cfif modo NEQ 'ALTA' and data.FAM01TIP EQ 3> selected </cfif>>Factura de Cobro de Inventario</option>
						<option value="4"<cfif modo NEQ 'ALTA' and data.FAM01TIP EQ 4> selected </cfif>>Factura de Cobro de Servicios</option>
						<option value="5"<cfif modo NEQ 'ALTA' and data.FAM01TIP EQ 5> selected </cfif>>>Factura de Ambos</option>
						<option value="6"<cfif modo NEQ 'ALTA' and data.FAM01TIP EQ 6> selected </cfif>>Cajas Cotizadoras sin Reservados</option>
						<option value="7"<cfif modo NEQ 'ALTA' and data.FAM01TIP EQ 7> selected </cfif>>Factura y cobro de Ambos</option>
						<option value="8"<cfif modo NEQ 'ALTA' and data.FAM01TIP EQ 8> selected </cfif>>Cajas Cotizadoras con Reservados</option>
						<option value="9"<cfif modo NEQ 'ALTA' and data.FAM01TIP EQ 9> selected </cfif>>Cobro de Transacciones Externas</option>
					</select>
				</td>
				<td>
					<select name="FAM01COB">
					  <option value="">-seleccionar-</option>
					  <option value="0"<cfif modo NEQ 'ALTA' and data.FAM01COB EQ 0> selected </cfif>>Default Contado</option>
					  <option value="1"<cfif modo NEQ 'ALTA' and data.FAM01COB EQ 1> selected </cfif>>Default Cr&eacute;dito</option>
					  <option value="2"<cfif modo NEQ 'ALTA' and data.FAM01COB EQ 2> selected </cfif>>Solo Contado</option>
					  <option value="3"<cfif modo NEQ 'ALTA' and data.FAM01COB EQ 0> selected </cfif>>Solo Cr&eacute;dito</option>
					</select>
			   </td>
		  </tr>
		  <tr>
			   <td><strong>Estatus</strong></td><!--- dibuja ESTATUS --->
			  <td><strong>Estado del Proceso</strong></td><!--- dibuja ESTADO DEL PROCESO --->
		  </tr>
		  <tr>
			  <td>
				<select name="FAM01STS">
					<option value="">-seleccionar-</option>
					<option value="0"<cfif modo NEQ 'ALTA' and data.FAM01STS EQ 0> selected </cfif>>Caja Cerrada</option>
					<option value="1"<cfif modo NEQ 'ALTA' and data.FAM01STS EQ 1> selected </cfif>>Caja Abierta</option>
				</select>
			 </td>
			 <td>
				<select name="FAM01STP">
					<option value="">-seleccionar-</option>
					<option value="0" <cfif modo NEQ 'ALTA' and data.FAM01STP EQ 0> selected </cfif>>SiApertura de Caja</option>
					<option value="10"<cfif modo NEQ 'ALTA' and data.FAM01STP EQ 10> selected </cfif>>Registro de Transacciones</option>
					<option value="30"<cfif modo NEQ 'ALTA' and data.FAM01STP EQ 30> selected </cfif>>Cierre de Usuario</option>
					<option value="40"<cfif modo NEQ 'ALTA' and data.FAM01STP EQ 40> selected </cfif>>Cierre de Supervisor</option>
					<option value="50"<cfif modo NEQ 'ALTA' and data.FAM01STP EQ 50> selected </cfif>>Cierre Diario Contabilizado</option>
				</select>
			</td>
		 </tr>
		 <tr>
			<td><strong>Bodega Modificable&nbsp;</strong></td><!--- dibuja BODEGA MODIFICABLE --->
			<td><strong>Monedas&nbsp;</strong></td> <!--- dibuja TAG DE MONEDAS --->
		 </tr>
		 <tr>
			<td>
				<select name="IO2MOD">
					<option value="">-seleccionar-</option>
					<option value="1" <cfif modo NEQ 'ALTA' and data.I02MOD EQ 1> selected </cfif>>Si</option>
					<option value="0" <cfif modo NEQ 'ALTA' and data.I02MOD EQ 0> selected </cfif>>No</option>
				</select></td>
			<td>
				<cfif modo NEQ "ALTA">
					<cf_sifmonedas query="#rsMonedas#" CrearMoneda = 'false'> 
				<cfelse>
					<cf_sifmonedas CrearMoneda = 'false'>
				</cfif>
			</td>
		</tr>
		<tr>
			<td><strong>Descripciones Alternas</strong></td> <!--- dibuja DESCRIPCIONES ALTERNAS --->
			<td><strong>&Iacute;tem a Facturar&nbsp;</strong></td> <!--- dibuja ITEM A FACTURAR --->
		</tr>
		<tr>
			<td>
				<select name="FAPDES">
					<option value="">-seleccionar-</option>
					<option value="1" <cfif modo NEQ 'ALTA' and data.FAPDES EQ 1> selected</cfif>>Si</option>
					<option value="0" <cfif modo NEQ 'ALTA' and data.FAPDES EQ 0> selected</cfif>>No</option>
				</select>
			</td>
			<td>
				<select name="FAM01TIF">
					<option value="">-seleccionar-</option>
					<option value="A" <cfif modo NEQ 'ALTA' and data.FAM01TIF EQ 'A'> selected</cfif>>Articulo </option>
					<option value="S" <cfif modo NEQ 'ALTA' and data.FAM01TIF EQ 'S'> selected</cfif>>Servicio</option>
				</select>
			</td>
	   </tr>
	   <tr>
			<td><strong>Documento de Apartado&nbsp;</strong></td> <!--- dibuja DOCUMENTO DE APARTADO --->
			<td><strong>Documento Devoluci&oacute;n&nbsp;</strong></td> <!--- dibuja DOCUEMNTO DE DEVOLUCION --->
	   </tr>
	   <tr>
			<td>
				<select name="CCTcodigoAP">
					<option value="">-seleccionar-</option>
					<cfif isdefined('rsTransacciones') and rsTransacciones.recordCount GT 0>
						<cfloop query="rsTransacciones">
							<cfif rsTransacciones.CCTtipo eq 'D'>
								<option value="#rsTransacciones.CCTcodigo#" <cfif modo neq 'ALTA' and rsTransacciones.CCTcodigo eq data.CCTcodigoAP>selected</cfif>>#rsTransacciones.CCTdescripcion#</option>
							</cfif>
						</cfloop>
					</cfif>
				</select>
		   </td>
		   <td>
				<select name="CCTcodigoDE">
					<option value="">-seleccionar-</option>
						<cfif isdefined('rsTransacciones') and rsTransacciones.recordCount GT 0>
							<cfloop query="rsTransacciones">
								<cfif rsTransacciones.CCTtipo eq 'C'>
									<option value="#rsTransacciones.CCTcodigo#" <cfif modo neq 'ALTA' and rsTransacciones.CCTcodigo eq data.CCTcodigoDE>selected</cfif> >#rsTransacciones.CCTdescripcion#</option>
								</cfif>
							</cfloop>
						</cfif>
				</select>
		 </td>
	  </tr>
	  <tr>
			<td><strong>Factura de Contado</strong></td>  <!--- dibuja FACTURA DE CONTADO --->
			<td><strong>Factura de Cr&eacute;dito&nbsp;</strong></td> <!--- dibuja FACTURA DE CREDITO --->
	  </tr>
	  <tr>
			<td>
				<select name="CCTcodigoFC">
					<option value="">-seleccionar-</option>
					<cfif isdefined('rsTransacciones') and rsTransacciones.recordCount GT 0>
						<cfloop query="rsTransacciones">
							<cfif rsTransacciones.CCTtipo eq 'D'>
								<option value="#rsTransacciones.CCTcodigo#" <cfif modo neq 'ALTA' and rsTransacciones.CCTcodigo eq data.CCTcodigoFC>selected</cfif> >#rsTransacciones.CCTdescripcion#</option>
							</cfif>
						</cfloop>
					</cfif>
				</select>
			</td>
			<td>
				<select name="CCTcodigoCR">
					<option value="">-seleccionar-</option>
						<cfif isdefined('rsTransacciones') and rsTransacciones.recordCount GT 0>
							<cfloop query="rsTransacciones">
								<cfif rsTransacciones.CCTtipo eq 'D'>
									<option value="#rsTransacciones.CCTcodigo#" <cfif modo neq 'ALTA' and rsTransacciones.CCTcodigo eq data.CCTcodigoCR>selected</cfif> >#rsTransacciones.CCTdescripcion#</option>
								 </cfif>
							</cfloop>
						</cfif>
				 </select>
			</td>
	   </tr>
	   <tr>
			<td><strong>Recibo de Caja&nbsp;</strong></td> <!--- dibuja RECIBO DE CAJA --->
			<td><strong>Almac&eacute;n&nbsp;</strong></td> <!--- dibuja TAG DE ALMACEN --->
	   </tr>
	   <tr>
			<td>
				<select name="CCTcodigoRC">
					<option value="">-seleccionar-</option>
					<cfif isdefined('rsTransacciones') and rsTransacciones.recordCount GT 0>
						<cfloop query="rsTransacciones">
							<cfif rsTransacciones.CCTtipo eq 'C'>
								 <option value="#rsTransacciones.CCTcodigo#" <cfif modo neq 'ALTA' and trim(rsTransacciones.CCTcodigo) eq trim(data.CCTcodigoRC)>selected</cfif> >#CCTcodigo#-#rsTransacciones.CCTdescripcion#</option>
							</cfif>
						 </cfloop>
					</cfif>
				</select>
		   </td>
		   <td>
				<cfif modo NEQ "ALTA" and len(trim(data.Aid))>
					<cf_sifalmacen query="#rsAlmacenes#"> 
				<cfelse>
					<cf_sifalmacen>
				</cfif> 		
			</td>
	   </tr>
	   <tr>
			<td><strong>Estaci&oacute;n&nbsp;</strong></td><!--- dibuja TAG DE OFICINAS--->
			<td><strong>&nbsp;</strong></td> <!--- dibuja TAG DE CUENTA --->
	   </tr>
	   <tr>
			<td>
				<cfif modo NEQ 'ALTA' and len(trim(data.Ocodigo))>
					<cf_sifoficinas form="form1" id="#rsOficinas.Ocodigo#">
				<cfelse>
					<cf_sifoficinas form="form1">
				</cfif>	
			</td>
	   </tr>
		</tr>
			<tr>
			  <td colspan="2"><strong>Cuenta</strong></td>
		  </tr>
			<td colspan="2">
				<cfif modo NEQ "ALTA" and len(trim(data.Ccuenta))>
					<cf_cuentas query="#rsCuentas#"> 
				<cfelse>
					<cf_cuentas>
				</cfif> 
			</td>
	   </tr>
	   <tr>
			<td colspan="2" nowrap align="center">
				<cf_botones modo="#modo#">
				<table>
					<tr>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td><cf_botones names="Anterior,Finalizar" values="<< Anterior, Finalizar"></td>
					</tr>
				</table>
			</td>
		</tr>
	 </table>
	
	<cfif modo neq 'ALTA'>
		<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#data.ts_rversion#" returnvariable="ts"/>
		<input type="hidden" name="ts_rversion" value="#ts#">
	</cfif>
	</form>
</cfoutput>			
		
<cf_qforms>
<script language="javascript">
	<!--//
	objForm.CCTcodigoAP.description = "#JSStringFormat('Documento de Apartado')#";
	objForm.CCTcodigoDE.description = "#JSStringFormat('Documento Devolución')#";
	objForm.CCTcodigoFC.description = "#JSStringFormat('Factura de Contado')#";
	objForm.CCTcodigoCR.description = "#JSStringFormat('Factura de Crédito')#";
	objForm.CCTcodigoRC.description = "#JSStringFormat('Recibo de Caja')#";
	objForm.FAM01CODD.description = "#JSStringFormat('Código')#";
	objForm.FAM09MAQ.description = "#JSStringFormat('Máquinas')#";
	objForm.FAM01DES.description = "#JSStringFormat('Descripción')#";
	objForm.FAM01RES.description = "#JSStringFormat('Responsable')#";
	objForm.FAM01TIP.description = "#JSStringFormat('Tipo')#";
	objForm.FAM01COB.description = "#JSStringFormat('Tipo de cobro')#";
	objForm.FAM01STS.description = "#JSStringFormat('Estatus')#";
	objForm.FAM01STP.description = "#JSStringFormat('Estado del Proceso')#";
	objForm.IO2MOD.description = "#JSStringFormat('Bodega Modificable')#";
	
	function habilitarValidacion(){
		objForm.CCTcodigoAP.required = true;
		objForm.CCTcodigoDE.required = true;
		objForm.CCTcodigoFC.required = true;
		objForm.CCTcodigoCR.required = true;
		objForm.CCTcodigoRC.required = true;
		objForm.FAM01CODD.required = true;
		objForm.FAM09MAQ.required = true;
		objForm.FAM01DES.required = true;
		objForm.FAM01RES.required = true;
		objForm.FAM01TIP.required = true;
		objForm.FAM01COB.required = true;
		objForm.FAM01STS.required = true;
		objForm.FAM01STP.required = true;
		objForm.IO2MOD.required = true;
	}

	function deshabilitarValidacion(){
		objForm.CCTcodigoAP.required = false;
		objForm.CCTcodigoDE.required = false;
		objForm.CCTcodigoFC.required = false;
		objForm.CCTcodigoCR.required = false;
		objForm.CCTcodigoRC.required = false;
		objForm.FAM01CODD.required = false;
		objForm.FAM09MAQ.required = false;
		objForm.FAM01DES.required = false;
		objForm.FAM01RES.required = false;
		objForm.FAM01TIP.required = false;
		objForm.FAM01COB.required = false;
		objForm.FAM01STS.required = false;
		objForm.FAM01STP.required = false;
		objForm.IO2MOD.required = false;
	}
	
	function funcFinalizar(){
		return false;
	}
	//-->
</script>