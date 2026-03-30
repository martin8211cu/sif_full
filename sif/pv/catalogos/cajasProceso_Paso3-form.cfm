<cfset modo = 'ALTA'>
<cfif  isdefined('form.FAM01COD') and len(trim(form.FAM01COD))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfquery name="rsMaq" datasource="#session.dsn#">
	select FAM09MAQ,FAM09DES
	from FAM009
	where Ecodigo = #session.Ecodigo#
	 and FAM09MAQ = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#form.FAM09MAQ#">
</cfquery>	

<!--- QUERY PARA ORIGENES DE INTERFAZ--->
<cfquery name="rsOriInter" datasource="#session.dsn#">
	select Ecodigo,FAX01ORIGEN,OIDescripcion 
	   from OrigenesInterfazPV
	  where Ecodigo = #session.Ecodigo#
</cfquery>	

<cfif modo eq 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select Ocodigo, FAM01COD, FAM01CODD, FAM09MAQ, FAM01DES, FAM01RES, FAM01TIP, FAM01COB,
		FAM01STS, FAM01STP,CFcuenta, I02MOD, CCTcodigoAP, CCTcodigoDE, CCTcodigoFC, CCTcodigoCR,
		CCTcodigoRC, FAM01NPR, FAM01NPA, FAM01NPTP, Aid, Mcodigo, CFid, FAM01TIF, FAPDES, ts_rversion,
		CFcuentaSobrantes, CFcuentaFaltantes,CalculoDesc, FAX01ORIGEN
		from FAM001
		where Ecodigo = #session.Ecodigo#
		and FAM01COD  = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FAM01COD#">
	</cfquery>
	
	<cfquery name="dataTS" datasource="#session.DSN#">	
		select  ts_rversion
		from FAM001
		where Ecodigo = #session.Ecodigo#
		and FAM01COD  = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FAM01COD#">		
	</cfquery>

	<!---  <cfabort> QUERY PARA el tag de MONEDAS--->
	<cfquery name="rsMonedas" datasource="#Session.DSN#" >
		Select Mcodigo, Mnombre, Msimbolo, Miso4217, ts_rversion
		from Monedas
		where Ecodigo = #session.Ecodigo#
		and Mcodigo   = #data.Mcodigo#
		order by Mnombre
	</cfquery>

	<!--- QUERY PARA el tag de ALMACENES--->
	<cfif len(trim(data.Aid))>
		<cfquery name="rsAlmacenes" datasource="#Session.DSN#" >
			Select Aid, Almcodigo,substring(Bdescripcion, 1, 25)as  Bdescripcion
			from Almacen
			where Ecodigo = #Session.Ecodigo#
			 and Aid      = #data.Aid#
		</cfquery>
	</cfif>

	<!--- QUERY PARA el tag de CFcuentas--->
	<cfif len(trim(data.CFcuenta))>
		<cfquery name="rsCuentas" datasource="#Session.DSN#" >
			Select  Ccuenta, CFcuenta, CFformato, CFdescripcion
			from CFinanciera
			where Ecodigo = #Session.Ecodigo#
			and CFcuenta  = #data.CFcuenta#
		</cfquery>
	</cfif>
	
	<!--- QUERY PARA el tag de CFcuentaSobrantes--->
	<cfif len(trim(data.CFcuentaSobrantes))>
		<cfquery name="rsCuentasSobrantes" datasource="#Session.DSN#" >
			Select  Ccuenta, CFcuenta, CFformato, CFdescripcion
			from CFinanciera
			where Ecodigo = #Session.Ecodigo#
			and CFcuenta  = #data.CFcuentaSobrantes#
		</cfquery>
	</cfif>
	<!--- QUERY PARA el tag de CFcuentaFaltantes--->
	<cfif len(trim(data.CFcuentaFaltantes))>
		<cfquery name="rsCuentasFaltantes" datasource="#Session.DSN#" >
			Select  Ccuenta, CFcuenta, CFformato, CFdescripcion
			from CFinanciera
			where Ecodigo = #Session.Ecodigo#
			and CFcuenta  = #data.CFcuentaFaltantes#
		</cfquery>
	</cfif>

	<!--- QUERY PARA el tag de Oficinas--->
	<cfif len(trim(data.Ocodigo))>
		<cfquery name = "rsOficinas" datasource="#session.DSN#">
			Select Ocodigo, Oficodigo, Odescripcion
		    from Oficinas
		    where Ecodigo = #Session.Ecodigo#
			and Ocodigo   = #data.Ocodigo#
		</cfquery>
	</cfif>
	<cfif isdefined('data') and data.CFid NEQ ''>
		<cfquery name="rsCentros" datasource="#session.DSN#">
			Select *
			from CFuncional
			where Ecodigo = #session.Ecodigo#
			and CFid      = #data.CFid#
		</cfquery>
	</cfif>
</cfif>

<!--- QUERY PARA el tag de TRANSACCIONES--->
<cfquery name="rsTransacciones" datasource="#session.dsn#">
	select CCTcodigo, substring(CCTdescripcion, 1, 25)as CCTdescripcion, CCTtipo
	from CCTransacciones
	where Ecodigo = #session.Ecodigo#
	order by 1      
</cfquery>

<!---pinta el formulario--->

<cfoutput>
	<form name="form1" method="post" action="cajasProceso_Paso3-sql.cfm">
	<cfif modo eq 'CAMBIO'>
		<input type="hidden" name="FAM01COD" value="#form.FAM01COD#">
		<input type="hidden" name="Mcodigo" value="">
		<input type="hidden" name="FaxOrigen" value="">
		<cfset LvarMiso4217 = ''>
		<cfset LvarMnombre = ''>
		<cfif isdefined('rsMonedas.Miso4217') and rsMonedas.recordcount GT 0>
			<cfset LvarMiso4217 = rsMonedas.Miso4217>
			<cfset LvarMnombre = rsMonedas.Mnombre>
		</cfif>
		<input type="hidden" name="Miso4217" value="#LvarMiso4217#">
		<input type="hidden" name="Mnombre" value="#LvarMnombre#">

	</cfif>
	<input type="hidden" name="FAM09MAQ" value="#form.FAM09MAQ#">
		<table border="0" cellpadding="1" cellspacing="1" width="100%">
        	<tr>
            	<td width="100%"><strong>Oficina</strong></td>
				<td colspan="4">
					<cfif modo NEQ 'ALTA' and len(trim(data.Ocodigo))>
        				<cf_sifoficinas form="form1" id="#rsOficinas.Ocodigo#">
        			<cfelse>
        				<cf_sifoficinas form="form1">
      				</cfif>
				</td>
          </tr>
          <tr>
         		<td><strong>C&oacute;digo</strong></td>
           		<td><input type="text" name="FAM01CODD" id="FAM01CODD" size="10" maxlength="4" value="<cfif modo neq 'ALTA'>#data.FAM01CODD#</cfif>"></td>
				<td>&nbsp;</td>
				<td><strong>Descripci&oacute;n </strong> </td>
            	<td>
					<strong>
						<input type="text" name="FAM01DES" id="FAM01DES" size="40" maxlength="40" value="<cfif modo neq 'ALTA'>#data.FAM01DES#</cfif>">
					</strong>
				</td>
          </tr>
          <tr>
          		<td><strong>Responsable</strong></td>
            	<td>
					<strong>
              			<input type="text" name="FAM01RES" id="FAM01RES" size="20" maxlength="40" value="<cfif modo neq 'ALTA'>#data.FAM01RES#</cfif>">
            		</strong>
				</td>
            	<td>&nbsp;</td>
            	<td><strong>Estatus</strong></td>
				<td>
					<strong>
						<select name="FAM01STS" id="FAM01STS">
							<option value="1"<cfif modo NEQ 'ALTA' and data.FAM01STS EQ 1> selected </cfif>>Caja Abierta</option>
							<option value="0"<cfif modo NEQ 'ALTA' and data.FAM01STS EQ 0> selected </cfif>>Caja Cerrada</option>
						</select>
            		</strong>
				</td>
          </tr>
          <tr>
            	<td><strong>Tipo</strong></td>
            	<td><select name="FAM01TIP" id="FAM01TIP">
					<cfif modo eq 'ALTA'>
              		<option value="7">Factura y Cobro de Ambos</option>
              		</cfif>
					<option value="1"<cfif modo NEQ 'ALTA' and data.FAM01TIP EQ 1> selected </cfif>>Factura de Inventario</option>
              		<option value="2"<cfif modo NEQ 'ALTA' and data.FAM01TIP EQ 2> selected </cfif>>Factura de Servicios</option>
              		<option value="3"<cfif modo NEQ 'ALTA' and data.FAM01TIP EQ 3> selected </cfif>>Factura de Cobro de Inventario</option>
              		<option value="4"<cfif modo NEQ 'ALTA' and data.FAM01TIP EQ 4> selected </cfif>>Factura de Cobro de Servicios</option>
              		<option value="5"<cfif modo NEQ 'ALTA' and data.FAM01TIP EQ 5> selected </cfif>>Factura de Ambos</option>
              		<option value="6"<cfif modo NEQ 'ALTA' and data.FAM01TIP EQ 6> selected </cfif>>Cajas Cotizadoras sin Reservados</option>
              		<option value="7"<cfif modo NEQ 'ALTA' and data.FAM01TIP EQ 7> selected </cfif>>Factura y Cobro de Ambos</option>
					<option value="8"<cfif modo NEQ 'ALTA' and data.FAM01TIP EQ 8> selected </cfif>>Cajas Cotizadoras con Reservados</option>
              		<option value="9"<cfif modo NEQ 'ALTA' and data.FAM01TIP EQ 9> selected </cfif>>Cobro de Transacciones Externas</option>
              		<option value="10"<cfif modo NEQ 'ALTA' and data.FAM01TIP EQ 10> selected </cfif>>Cobro de Transacciones Externas sin Recalculo</option>					
            		</select>
				</td>
            	<td>&nbsp;</td>
            	<td nowrap><strong>Tipo de Cobro&nbsp;</strong></td>
            	<td>
					<select name="FAM01COB" id="FAM01COB">
						<cfif modo eq 'ALTA'>
              				<option value="0">Default Contado</option>
              			</cfif>
              			<option value="0"<cfif modo NEQ 'ALTA' and data.FAM01COB EQ 0> selected </cfif>>Default Contado</option>
              			<option value="1"<cfif modo NEQ 'ALTA' and data.FAM01COB EQ 1> selected </cfif>>Default Cr&eacute;dito</option>
              			<option value="2"<cfif modo NEQ 'ALTA' and data.FAM01COB EQ 2> selected </cfif>>Solo Contado</option>
              			<option value="3"<cfif modo NEQ 'ALTA' and data.FAM01COB EQ 3> selected </cfif>>Solo Cr&eacute;dito</option>
            		</select>
				</td>
          </tr>
          <tr>
          		<td><strong>Proceso</strong></td>
            	<td>
					<select name="FAM01STP" id="FAM01STP">
					 	<cfif modo eq 'ALTA'>
              				<option value="0">Apertura de Caja</option>
              			</cfif>
            			<option value="0"<cfif modo NEQ 'ALTA' and data.FAM01STP EQ 10> selected </cfif>>Apertura de Caja</option>
             			<option value="10"<cfif modo NEQ 'ALTA' and data.FAM01STP EQ 10> selected </cfif>>Registro de Transacciones</option>
              			<option value="30"<cfif modo NEQ 'ALTA' and data.FAM01STP EQ 30> selected </cfif>>Cierre de Usuario</option>
              			<option value="40"<cfif modo NEQ 'ALTA' and data.FAM01STP EQ 40> selected </cfif>>Cierre de Supervisor</option>
              			<option value="50"<cfif modo NEQ 'ALTA' and data.FAM01STP EQ 50> selected </cfif>>Cierre Diario Contabilizado</option>
            		</select>
				</td>
            	<td>&nbsp;</td>
            	<td><strong>Monedas&nbsp;</strong></td>
            	<td>
				<cfif modo NEQ "ALTA">
        				<cf_sifmonedas query="#rsMonedas#" crearmoneda = 'false'>
        			<cfelse>
        				<cf_sifmonedas crearmoneda = 'false'>
   				  </cfif>
				</td>
          </tr>	
          <tr>
          		<td><strong>Item</strong></td>
            	<td>
					<select name="FAM01TIF" id="FAM01TIF">
						<cfif modo eq 'ALTA'>
              				<option value="A">Artículo</option>
              			</cfif>
              			<option value="A" <cfif modo NEQ 'ALTA' and data.FAM01TIF EQ 'A'> selected</cfif>>Artículo </option>
						<option value="S" <cfif modo NEQ 'ALTA' and data.FAM01TIF EQ 'S'> selected</cfif>>Servicio</option>
					</select>
			    </td>
            	<td>&nbsp;</td>
            	<td><strong>Almac&eacute;n&nbsp;</strong></td>
           		<td>
					<cfif modo NEQ "ALTA" and len(trim(data.Aid))>
        				<cf_sifalmacen id="#rsAlmacenes.Aid#">
        			<cfelse>
        				<cf_sifalmacen>
      				</cfif>
				</td>
          </tr>
          <tr>
            <td><strong>Fac Contado</strong></td>
            <td>
				<select name="CCTcodigoFC" id="CCTcodigoFC">
					<option value="">-seleccionar-</option>
					<cfif isdefined('rsTransacciones') and rsTransacciones.recordCount GT 0>
						<cfloop query="rsTransacciones">
							<cfif rsTransacciones.CCTtipo eq 'D'>
								<option value="#rsTransacciones.CCTcodigo#" <cfif modo neq 'ALTA' and trim(rsTransacciones.CCTcodigo) eq trim(data.CCTcodigoFC)>selected</cfif> >#CCTcodigo#-#rsTransacciones.CCTdescripcion#</option>
							</cfif>
						</cfloop>
					</cfif>
            	</select>
			</td>
            <td>&nbsp;</td>
            <td><strong>Fac Cr&eacute;dito</strong></td>
            <!--- dibuja TIPO  --->
            <td>
				<select name="CCTcodigoCR" id="CCTcodigoCR">
					<option value="">-seleccionar-</option>
					<cfif isdefined('rsTransacciones') and rsTransacciones.recordCount GT 0>
						<cfloop query="rsTransacciones">
							<cfif rsTransacciones.CCTtipo eq 'D'>
								<option value="#rsTransacciones.CCTcodigo#" <cfif modo neq 'ALTA' and trim(rsTransacciones.CCTcodigo) eq trim(data.CCTcodigoCR)>selected</cfif> >#CCTcodigo#-#rsTransacciones.CCTdescripcion#</option>
							</cfif>
						</cfloop>
					</cfif>
	            </select>
			</td>
            <!--- dibuja TIPO DE COBRO--->
          </tr>
          <tr>
            <td height="23" nowrap><strong>Doc Apartado</strong></td>
            <td><select name="CCTcodigoAP" id="CCTcodigoAP">
              <option value="">-seleccionar-</option>
              <cfif isdefined('rsTransacciones') and rsTransacciones.recordCount GT 0>
                <cfloop query="rsTransacciones">
                  <cfif rsTransacciones.CCTtipo eq 'D'>
                    <option value="#rsTransacciones.CCTcodigo#" <cfif modo neq 'ALTA' and trim(rsTransacciones.CCTcodigo) eq trim(data.CCTcodigoAP)>selected</cfif>>#CCTcodigo#-#rsTransacciones.CCTdescripcion#</option>
                  </cfif>
                </cfloop>
              </cfif>
            </select></td>
            <td>&nbsp;</td>
            <td nowrap><strong>Doc Devoluci&oacute;n</strong></td>
            <td><select name="CCTcodigoDE" id="CCTcodigoDE">
              <option value="">-seleccionar-</option>
              <cfif isdefined('rsTransacciones') and rsTransacciones.recordCount GT 0>
                <cfloop query="rsTransacciones">
                  <cfif rsTransacciones.CCTtipo eq 'C'>
                    <option value="#rsTransacciones.CCTcodigo#" <cfif modo neq 'ALTA' and trim(rsTransacciones.CCTcodigo) eq trim(data.CCTcodigoDE)>selected</cfif> >#CCTcodigo#-#rsTransacciones.CCTdescripcion#</option>
                  </cfif>
                </cfloop>
              </cfif>
            </select></td>
          </tr>
          <tr>
            <td><strong>Recibo</strong></td>
            <td><select name="CCTcodigoRC" id="CCTcodigoRC">
              <option value="">-seleccionar-</option>
              <cfif isdefined('rsTransacciones') and rsTransacciones.recordCount GT 0>
                <cfloop query="rsTransacciones">
                  <cfif rsTransacciones.CCTtipo eq 'C'>
                    <option value="#rsTransacciones.CCTcodigo#" <cfif modo neq 'ALTA' and trim(rsTransacciones.CCTcodigo) eq trim(data.CCTcodigoRC)>selected</cfif> >#CCTcodigo#-#rsTransacciones.CCTdescripcion#</option>
                  </cfif>
                </cfloop>
              </cfif>
            </select></td>
            <td>&nbsp;</td>
            <td><strong>Origen: </strong></td>
            <td>
				<select name="FAX01ORIGEN_E">
		  			<cfif isdefined('rsOriInter') and rsOriInter.recordCount GT 0>
						<cfloop query="rsOriInter">
							<option value="#rsOriInter.FAX01ORIGEN#" <cfif modo neq 'ALTA' and trim(rsOriInter.FAX01ORIGEN) eq trim(data.FAX01ORIGEN)>selected</cfif> >#rsOriInter.FAX01ORIGEN#-#rsOriInter.OIDescripcion#</option>
						</cfloop>
		 			 </cfif>
				</select>
			</td>
          </tr>
          <tr>
            	<td align="right"><input name="IO2MOD" id="IO2MOD2" type="checkbox" value="S" <cfif modo NEQ "ALTA" and data.I02MOD eq 1> checked</cfif>></td>
            	<td><strong>Bodega Modificable</strong></td>
            	<td>&nbsp;</td>
            	<td align="right"><input name="FAPDES" id="FAPDES" type="checkbox" value="S" <cfif modo NEQ "ALTA" and data.FAPDES eq 1> checked</cfif>></td>
            	<td><strong>Descripciones Alternas</strong></td>
          </tr>		  
          <tr>
            <td nowrap><strong>Centro Funcional</strong></td>
          <td colspan="4"><cfif modo neq 'ALTA' and isdefined('data') and data.CFid NEQ '' and isdefined('rsCentros')>
            <cf_rhcfuncional form="form1" query="#rsCentros#">
            <cfelse>            
            <cf_rhcfuncional form="form1" size="30" titulo="Seleccione un Centro Funcional">
          </cfif></td>
          </tr>
		  
		  <tr>
            <td><strong>Cuenta</strong></td>
			
            <td colspan="4">
			 
				 <cfif modo NEQ "ALTA" and len(trim(data.CFcuenta))>
			        <cf_cuentas query="#rsCuentas#" Ccuenta="c1" CFcuenta="CFcuenta1" Cmayor="Cmayor1" Cformato="Cformato1" Cdescripcion="Cdescripcion1" frame="iframe1"> 
				<cfelse>
					<cf_cuentas Ccuenta="c1" CFcuenta="CFcuenta1" Cmayor="Cmayor1" Cformato="Cformato1" Cdescripcion="Cdescripcion1" frame="iframe1">
				</cfif>
			</td>
          </tr>
		  <tr>
            <td nowrap><strong>Cuenta Sobrantes</strong></td>
			
            <td colspan="4">
			 
				 <cfif modo NEQ "ALTA" and len(trim(data.CFcuentaSobrantes))>
			        <cf_cuentas query="#rsCuentasSobrantes#" Ccuenta="c2" CFcuenta="CFcuentaSobrantes" Cmayor="Cmayor2" Cformato="Cformato2" Cdescripcion="Cdescripcion2" frame="iframe1"> 
				<cfelse>
					<cf_cuentas Ccuenta="c2" CFcuenta="CFcuentaSobrantes" Cmayor="Cmayor2" Cformato="Cformato2" Cdescripcion="Cdescripcion2" frame="iframe1">
				</cfif>
			</td>
          </tr>
		  <tr>
            <td><strong>Cuenta Faltantes</strong></td>
			
            <td colspan="4">
			 
				 <cfif modo NEQ "ALTA" and len(trim(data.CFcuentaFaltantes))>
			        <cf_cuentas query="#rsCuentasFaltantes#" Ccuenta="c3" CFcuenta="CFcuentaFaltantes" Cmayor="Cmayor3" Cformato="Cformato3" Cdescripcion="Cdescripcion3" frame="iframe1"> 
	
				<cfelse>
					<cf_cuentas Ccuenta="c3" CFcuenta="CFcuentaFaltantes" Cmayor="Cmayor3" Cformato="Cformato3" Cdescripcion="Cdescripcion3" frame="iframe1">
				</cfif>
			</td>
          </tr>
          <tr>
            <td colspan="5">
			<fieldset><legend><strong>Cálculo del Descuento</strong></legend>
				<table cellpadding="1" cellspacing="1" width="100%">
					<tr>
						<td align="right"><input name="CalculoDesc" type="radio" <cfif modo NEQ "ALTA" and data.CalculoDesc eq 0> checked<cfelse> checked</cfif> value="0">					    </td>
						<td><strong>Por Monto </strong></td>			  
						<td align="right"><input name="CalculoDesc" type="radio" <cfif modo NEQ "ALTA" and data.CalculoDesc eq 1> checked</cfif> value="1"></td>				
					<td><strong>Por Porcentaje </strong></td>
					</tr>
			  	</table>			
			</fieldset>
			
			</td>
          </tr>	          
          <tr>
            <td colspan="5">&nbsp;</td>
          </tr>
		 <tr>
			 <td colspan="5" valign="top">
			 	  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  	<tr>
						<!---Interfaces--->
						<td width="30%" valign="top">
							<fieldset><legend><strong>Interfaces</strong></legend>
							  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
								<td><strong>Entrada</strong></td></tr>
								<tr>
								<td><input type="text" name="FAM01NPR" size="40" maxlength="50" value="<cfif modo neq 'ALTA'>#data.FAM01NPR#</cfif>"></td></tr>
								<tr>
								<td><strong>Salida</strong></td></tr>
								<tr>
								  <td><input type="text" name="FAM01NPA" size="40" maxlength="50" value="<cfif modo neq 'ALTA'>#data.FAM01NPA#</cfif>"></td>
								</tr>
								<tr>
								  <td><strong>Documentos Pendientes </strong></td>
								</tr>
								<tr>
								<td><input type="text" name="FAM01NPTP" size="40" maxlength="50" value="<cfif modo neq 'ALTA'>#data.FAM01NPTP#</cfif>"></td></tr>
							  </table>
							</fieldset>
					  </td>
						<!---Formato de Documento--->
						<td width="70%" valign="top">
							<cfif modo eq 'CAMBIO'>
								<fieldset><legend><strong>Formatos por Tipos de Documentos</strong></legend>
									<cfinclude template="formatos_tipo_doc.cfm"> 
								</fieldset>	
				  			</cfif>	
					  </td>
					</tr>
				  </table>
			</td>
		 <tr><td colspan="5">&nbsp;</td></tr>
		 <tr>
		 	<td colspan="5" align="center" valign="top">
				<cf_botones modo="#modo#">
			</td>
		</tr>
		<tr>
			<td colspan="5" align="center" valign="top">	
				<cf_botones names="Anterior,Finalizar" values="<< Anterior, Finalizar">
			</td>
		</tr>					
  </table>
  <cfif modo neq 'ALTA'>
   	<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#dataTS.ts_rversion#" returnvariable="ts"/>
		<input type="hidden" name="ts_rversion" value="#ts#">
	</cfif>
</form>
		
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
		
		objForm.CCTcodigo.required = false;
		objForm.FMT01COD.required = false;
		objForm.FAX01ORIGEN.required = false;
		
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
		
		objForm.CCTcodigo.required = false;
		objForm.FMT01COD.required = false;
		objForm.FAX01ORIGEN.required = false;
		
	}
</script>
</cfoutput>