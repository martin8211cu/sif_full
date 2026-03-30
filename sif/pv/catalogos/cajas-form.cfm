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

	<!---  <cfabort> QUERY PARA el tag de MONEDAS--->
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
			Select Aid, Almcodigo,substring(Bdescripcion, 1, 25)as  Bdescripcion
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
			Select Ocodigo, Oficodigo, Odescripcion
		    from Oficinas
		    where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and Ocodigo=<cfqueryparam value="#data.Ocodigo#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>
</cfif>

<!--- QUERY PARA el tag de TRANSACCIONES--->
<cfquery name="rsTransacciones" datasource="#session.dsn#">
	select CCTcodigo, substring(CCTdescripcion, 1, 25)as CCTdescripcion, CCTtipo
	from CCTransacciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by 1      
</cfquery>



<!--- SE UTILIZA PARA DESPLEGAR ---> 
<cfoutput>
<form name="form1" method="post" action="cajas-sql.cfm" onSubmit="javascript: return validar(this);">
	<cfif modo neq 'ALTA'>
				<input type="hidden" name="FAM01COD" value="#data.FAM01COD#">
	</cfif>
	<table width="100%" cellpadding="3" cellspacing="0">
		
			
		<tr>
			<!--- dibuja CODIGO EXTERNO--->
			<td align="right">C&oacute;digo&nbsp;</td>
			<!--- dibuja el filtro--->
			<td><input type="text" name="FAM01CODD" size="10" maxlength="4" value="<cfif modo neq 'ALTA'>#data.FAM01CODD#</cfif>"></td>
		
						
			<!--- dibuja CODIGO MAQUINA--->
			<td align="right">M&aacute;quina&nbsp;</td>
				   	<!--- dibuja el filtro--->
			 <td><input type="text" name="FAM09MAQ" size="10" maxlength="4" value="<cfif modo neq 'ALTA'>#data.FAM09MAQ#</cfif>"></td>
		         
			</tr>
			
			<tr>
			<!--- dibuja DESCRIPCION--->
			<td align="right">Descripci&oacute;n&nbsp;</td>
			<!--- dibuja el filtro--->
			<td><input type="text" name="FAM01DES" size="20" maxlength="40" value="<cfif modo neq 'ALTA'>#data.FAM01DES#</cfif>"></td>
			
					
				
			<!--- dibuja RES--->
			<td align="right">Responsable&nbsp;</td>
			<!--- dibuja el filtro---> 
			<td><input type="text" name="FAM01RES" size="20" maxlength="40" value="<cfif modo neq 'ALTA'>#data.FAM01RES#</cfif>"></td>
		</tr>
		<tr>
			<!--- dibuja INTERFAZ DE ENTRADA--->
			<td align="right">Interfaz de Entrada&nbsp;</td>
			<!--- dibuja el filtro--->
			<td><input type="text" name="FAM01NPR" size="20" maxlength="50" value="<cfif modo neq 'ALTA'>#data.FAM01NPR#</cfif>"></td>
		
				
			<!--- dibuja INTERFAZ DE SALIDA--->
			<td align="right">Interfaz de Salida&nbsp;</td>
			<!--- dibuja el filtro--->
			<td><input type="text" name="FAM01NPA" size="20" maxlength="50" value="<cfif modo neq 'ALTA'>#data.FAM01NPA#</cfif>"></td>
		
			
		</tr>	
		
		<tr>
			<!--- dibuja TIPO DE DOCUMENTO--->
			<td align="right">Tipo&nbsp;</td>
			<!---  dibuja el filtro--->
		   	<td> <select name="FAM01TIP">
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
		        </select></td>
		
			<!--- dibuja TIPO DE COBRO--->
			<td align="right">Tipo de Cobro&nbsp;</td>
			<td><select name="FAM01COB">
			    <option value="">-seleccionar-</option>
			    <option value="0"<cfif modo NEQ 'ALTA' and data.FAM01COB EQ 0> selected </cfif>>Default Contado</option>
			    <option value="1"<cfif modo NEQ 'ALTA' and data.FAM01COB EQ 1> selected </cfif>>Default Cr&eacute;dito</option>
			    <option value="2"<cfif modo NEQ 'ALTA' and data.FAM01COB EQ 2> selected </cfif>>Solo Contado</option>
			    <option value="3"<cfif modo NEQ 'ALTA' and data.FAM01COB EQ 0> selected </cfif>>Solo Cr&eacute;dito</option>
		      </select></td>
			
		</tr>

         <tr>
			<!--- dibuja ESTATUS--->
			  <td align="right">Estatus&nbsp;</td>
			  <td><select name="FAM01STS">
			      <option value="">-seleccionar-</option>   
				  <option value="0"<cfif modo NEQ 'ALTA' and data.FAM01STS EQ 0> selected </cfif>>Caja Cerrada</option>
				  <option value="1"<cfif modo NEQ 'ALTA' and data.FAM01STS EQ 1> selected </cfif>>Caja Abierta</option>
			    </select>
			 </td>
		    
			
			
			<!--- dibuja ESTADO DE PROCESO--->
			<td align="right">Estado del Proceso&nbsp;</td>
			<td><select name="FAM01STP">
			    <option value="">-seleccionar-</option>
			    <option value="0" <cfif modo NEQ 'ALTA' and data.FAM01STP EQ 0> selected </cfif>>SiApertura de Caja</option>
			    <option value="10"<cfif modo NEQ 'ALTA' and data.FAM01STP EQ 10> selected </cfif>>Registro de Transacciones</option>
			    <option value="30"<cfif modo NEQ 'ALTA' and data.FAM01STP EQ 30> selected </cfif>>Cierre de Usuario</option>
			    <option value="40"<cfif modo NEQ 'ALTA' and data.FAM01STP EQ 40> selected </cfif>>Cierre de Supervisor</option>
			    <option value="50"<cfif modo NEQ 'ALTA' and data.FAM01STP EQ 50> selected </cfif>>Cierre Diario Contabilizado</option>
			    </select></td>
		</tr>
        
			
		<tr>
			<!--- dibuja IO2MOD--->
			<td nowrap align="right">Bodega Modificable&nbsp;</td>
			<td><select name="IO2MOD">
			    <option value="">-seleccionar-</option>
			    <option value="1" <cfif modo NEQ 'ALTA' and data.I02MOD EQ 1> selected </cfif>>Si</option>
			    <option value="0" <cfif modo NEQ 'ALTA' and data.I02MOD EQ 0> selected </cfif>>No</option>
	            </select>
			</td>
						
		    <!--- LLAMADA AL TAG DE MONEDAS --->
			<td width="50%" align="right">Monedas&nbsp;</td>

			<td width="50%">
			    <cfif modo NEQ "ALTA">
			        <cf_sifmonedas query="#rsMonedas#" CrearMoneda = 'false'> 
				<cfelse>
					 <cf_sifmonedas CrearMoneda = 'false'>
				</cfif> 		
		    </td>		
			
		</tr>
             
		<tr>
			
			<!--- dibuja DESCRIPCIONES ALTERNAS --->
			<td nowrap align="right">Descripciones Alternas&nbsp;</td>
			<td> <select name="FAPDES">
			   <option value="">-seleccionar-</option>
			   	<option value="1" <cfif modo NEQ 'ALTA' and data.FAPDES EQ 1> selected</cfif>>Si</option>
			    <option value="0" <cfif modo NEQ 'ALTA' and data.FAPDES EQ 0> selected</cfif>>No</option>
	          </select></td>
			
			<!--- dibuja FAM01TIF --->
			<td align="right">Item a Facturar&nbsp;</td>
			<td>	<select name="FAM01TIF">
			    <option value="">-seleccionar-</option>
				<option value="A" <cfif modo NEQ 'ALTA' and data.FAM01TIF EQ 'A'> selected</cfif>>Articulo </option>
			    <option value="S" <cfif modo NEQ 'ALTA' and data.FAM01TIF EQ 'S'> selected</cfif>>Servicio</option>
	          </select></td>
			
		 </tr>
		 	 
			 
		<tr>
			<!--- dibuja CCTcodigoAP  a todos estos hay que llamarles tag--->
			<td nowrap align="right">Documento de Apartado&nbsp;</td>
			<td>
			<select name="CCTcodigoAP">
				  <option value="">-seleccionar-</option>
				  <cfif isdefined('rsTransacciones') and rsTransacciones.recordCount GT 0>
					<cfloop query="rsTransacciones">
						<cfif rsTransacciones.CCTtipo eq 'D'>
							<option value="#rsTransacciones.CCTcodigo#" <cfif modo neq 'ALTA' and rsTransacciones.CCTcodigo eq data.CCTcodigoAP>selected</cfif> >#rsTransacciones.CCTdescripcion#</option>
						</cfif>
					</cfloop>
				  </cfif>
				</select>
			</td>
			
			<!--- dibuja CCTcodigoDE--->
			<td nowrap align="right">Documento Devolucion&nbsp;</td>
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
			
			<!--- dibuja CCTcodigoFC--->
			<td nowrap align="right">Factura de Contado&nbsp;</td>
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
			
			
			<!--- dibuja CCTcodigoCR--->
			<td nowrap align="right">Factura de Credito&nbsp;</td>
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
			
			<!--- dibuja CCTcodigoAP--->
				<td nowrap align="right">Recibo de Caja&nbsp;</td>
			<td>
			<select name="CCTcodigoRC">
				  <option value="">-seleccionar-</option>
				  <cfif isdefined('rsTransacciones') and rsTransacciones.recordCount GT 0>
					<cfloop query="rsTransacciones">
						<cfif rsTransacciones.CCTtipo eq 'C'>
							<option value="#rsTransacciones.CCTcodigo#" <cfif modo neq 'ALTA' and rsTransacciones.CCTcodigo eq data.CCTcodigoRC>selected</cfif> >#rsTransacciones.CCTdescripcion#</option>
						</cfif>
					</cfloop>				  
				  </cfif>				  
				</select>
			</td>
		</tr>
		
		<tr>
		    <!--- LLAMADA DEL TAG DE ALMACENES--->
			<td width="50%" align="right">Almacenes&nbsp;</td>
             <td width="50%">
			    <cfif modo NEQ "ALTA" and len(trim(data.Aid))>
			        <cf_sifalmacen query="#rsAlmacenes#"> 
				<cfelse>
					 <cf_sifalmacen>
				</cfif> 		
		    </td>
			
			<!--- dibuja tag oficina--->
			<td nowrap align="right"><strong>Estación:</strong></td>
			<td nowrap>							
			<cfif modo NEQ 'ALTA' and len(trim(data.Ocodigo))>
					<cf_sifoficinas form="form1" id="#rsOficinas.Ocodigo#">
			<cfelse>
					<cf_sifoficinas form="form1" Ocodigo="Ocodigo">
			</cfif>							
			</td>
        
		</tr>
		
		<tr>
		    <!--- LLAMADA AL TAG DE CCUENTAS --->
			<td width="50%" align="right">Cuentas&nbsp;</td>

			<td width="30%" colspan="3">
			    <cfif modo NEQ "ALTA" and len(trim(data.Ccuenta))>
			        <cf_cuentas query="#rsCuentas#"> 
				<cfelse>
					 <cf_cuentas>
				</cfif> 		
		   </td>  
		
		</tr>--->
		 
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center">
				<cfif modo neq 'ALTA'  >
					<cf_botones modo='CAMBIO'>
				<cfelse>
					<cf_botones modo='ALTA'>
				</cfif>
			</td>
		</tr>

	</table>
	
	<cfif modo neq 'ALTA'>
		<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
			artimestamp="#data.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		
	</cfif>
	
</form>--->



<!-- MANEJA LOS ERRORES--->

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
		
	}
	
	function funcFinalizar(){
	    location.href = 'cajasProceso.cfm';
		return false;
	}
	//-->
</script>
</cfoutput>
