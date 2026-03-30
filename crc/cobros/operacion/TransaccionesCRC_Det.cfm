<cf_Confirm width="92" index="1" title="#titleDialog#" botones="Cancelar">
 	<div id="detallesDiv">
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td  width="60%">
					<table border="0" cellpadding="1" cellspacing="0" style="width:100%">
						<!------------------------------------------------------------------------------------->
						<!--- Item, Centro Funcional --->
						<!------------------------------------------------------------------------------------->
						<tr>
							<!--- Item --->
							<td align="right">
								<cfquery name="rsCuentas" datasource="#session.dsn#">
									select c.id as CuentaID, c.Numero, c.Tipo,
										case
											when c.Tipo = 'D' then 'Vales'
											when c.Tipo = 'TC' then 'Tarjeta Crédito'
											else 'Tarjeta Crédito Mayorista'
										end as TipoDesc
									from SNegocios sn
									inner join CRCCuentas c
										on sn.SNid = c.SNegociosSNid
										and sn.Ecodigo = c.Ecodigo
									where sn.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTransaccion.SNcodigo#" >
										and sn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
								</cfquery>

								<label id="crcCuentaLabel" class="etiqueta">Cuenta:</label>
							</td>
							<td>
								<select id="crcCuenta" name="crcCuenta" tabindex="2"> <!--- onChange="javascript:limpiarDetalle();cambiarDetalle();" --->
					            <option value="">--Seleccione una Cuenta --</option>
					            <cfoutput query="rsCuentas">
					            	<option value="#CuentaID#">
										#Numero# - #StrReplace(TipoDesc)#
					            	</option>
					            </cfoutput>
					          </select>
							</td>
						</tr>

						<tr>
							<td align="right">
								 <label class="etiqueta">Centro Funcional:</label>
							</td>
							<td>
						        <cfset valuesArrayCF = ArrayNew(1)>
								<cfif isdefined("rsLinea.CFid") and len(trim(rsLinea.CFid))>
									<cfquery datasource="#Session.DSN#" name="rsSN">
										select
										CFid,
										CFcodigo,
										CFdescripcion
										from CFuncional
										where Ecodigo = #session.Ecodigo#
										and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLinea.CFid#">
									</cfquery>

									<cfset ArrayAppend(valuesArrayCF, rsSN.CFid)>
									<cfset ArrayAppend(valuesArrayCF, rsSN.CFcodigo)>
									<cfset ArrayAppend(valuesArrayCF, rsSN.CFdescripcion)>

								</cfif>
								<cfquery name="rsCFUncionalDefault" datasource="#session.dsn#">
									select CFcodigo from CFuncional where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTransaccion.CFid#">
								</cfquery>
								<cf_conlis
									Campos="CFidD,CFcodigoD,CFdescripcionD"
									valuesArray="#valuesArrayCF#"
									Desplegables="N,S,S"
									Modificables="N,S,N"
									Size="0,10,20"
									tabindex="5"
									Title="Lista de Centros Funcionales"
									Tabla="CFuncional cf
									inner join Oficinas o
									on o.Ecodigo=cf.Ecodigo
									and o.Ocodigo=cf.Ocodigo"
									Columnas="distinct cf.CFid as CFidD,cf.CFcodigo as CFcodigoD  ,cf.CFdescripcion #LvarCNCT# ' (Oficina: ' #LvarCNCT# rtrim(o.Oficodigo) #LvarCNCT# ')' as CFdescripcionD"
									Filtro=" cf.Ecodigo = #Session.Ecodigo# order by cf.CFcodigo"
									Desplegar="CFcodigoD,CFdescripcionD"
									Etiquetas="Codigo,Descripcion"
									filtrar_por="cf.CFcodigo,CFdescripcion"
									Formatos="S,S"
									Align="left,left"
									form="form1"
									Asignar="CFidD,CFcodigoD,CFdescripcionD"
									traerinicial="true"
						            traerfiltro="CFcodigo = '#rsCFUncionalDefault.CFcodigo#'"
									Asignarformatos="S,S,S,S"
								/>
						    </td>
						</tr>
						<!------------------------------------------------------------------------------------->
						<!---- Descripcion, Descripcion Alterna--->
						<!------------------------------------------------------------------------------------->
						<tr>
							<!--- Descripcion --->
							<td align="right">
								<label id="DescripcionLabel" class="etiqueta">Descripci&oacute;n:</label>
							</td>
       						<td>
       							<input name="DTdescripcion" tabindex="2"
       								   onFocus="javascript:document.form1.DTdescripcion.select();" type="text"
       								   value="<cfif modoDet NEQ "ALTA"><cfoutput>#HTMLEditFormat(rsLinea.DTdescripcion)#</cfoutput></cfif>" size="40" maxlength="255">
       						</td>
						</tr>
						<!------------------------------------------------------------------------------------->
						<!---- Departamento, Actividad Empresarial--->
						<!------------------------------------------------------------------------------------->
						<tr>
							<!--- Departamento --->
							<td align="right">
								<label id="DepLabel" class="etiqueta">Departamento:</label>
							</td>
							<td>
								<select name="Dcodigo" tabindex="2"
								        onChange="javascript: TraerCuentaConcepto(document.form1.Cid.value,this.value);">
					            	<cfoutput query="rsDepartamentos">
					                	<option value="#rsDepartamentos.Dcodigo#"
					                	        <cfif modoDet NEQ "ALTA" and rsDepartamentos.Dcodigo EQ rsLinea.Dcodigo>selected</cfif>>
					                	        #rsDepartamentos.Ddescripcion#
					                	</option>
					            	</cfoutput>
								</select>
							</td>
							<!--- Actividad Empresarial --->
							<cfif validaActividadEmpresarial.Pvalor EQ 'S'>
								<td align="right">
									<label id="ActEmLabel" class="etiqueta">Actividad Empresarial:</label>
								</td>
							</cfif>
				            <cfset idActividad = "">
							<cfset valores = "">
				            <cfset lvarReadonly = false>
				            <cfif modoDet NEQ "ALTA">
				            	<cfset idActividad = rsLinea.FPAEid>
				                <cfset valores = rsLinea.CFComplemento>
				                <cfset lvarReadonly = false>
				            </cfif>

							<!--- <cfdump var="#rsLinea#">
				            <cfdump var="#idActividad#">
				            <cfdump var="#valores#">
				            <cfdump var="#LvarReadonly#">
				            <cf_dump var="break"> --->

				        	<td valign="top">
				        		<cf_ActividadEmpresa etiqueta="" idActividad="#idActividad#"
				        		                     valores="#valores#" name="CFComplemento" nameId="FPAEid" formname="form1"
				        		                     readonly="#lvarReadonly#">
				        	</td>
						</tr>
					</table>
				</td>


				<!--- MONTOS --->


				<td width="40%">
					<div id="divPagar">

					</div>
				</td>
			</tr>
			<!--- Botones ---><!--- Botones ---><!--- Botones ---><!--- Botones ---><!--- Botones ---><!--- Botones ---><!--- Botones --->
			<!--- Botones ---><!--- Botones ---><!--- Botones ---><!--- Botones ---><!--- Botones ---><!--- Botones ---><!--- Botones --->
			<!--- Botones ---><!--- Botones ---><!--- Botones ---><!--- Botones ---><!--- Botones ---><!--- Botones ---><!--- Botones --->
		    <tr>
		        <td colspan="2" align="center">
				    <cfif rsTransaccion.ETestado NEQ "T">
		            	<cfif modoDet EQ "ALTA">
		              		<input name="AgregarDCRC" tabindex="3" type="submit" class="btnGuardar" value="Agregar" onclick="if(window.funcAgregar){return funcAgregar();}">
					  		       <!--- onclick="javascript: return prepararDatos();" --->
		            	<cfelse>
		            		<cfif isDefined('rsLinea.DTExterna') and  rsLinea.DTExterna NEQ 'S'>
		            			<input name="CambiarD" tabindex="3" type="submit"
		            			 	   class="btnGuardar" value="Modificar"
		            			 	   onClick="javascript: return prepararDatos();">
		            		</cfif>
						  	<input name="BorrarD" class="btnEliminar"
						  		   tabindex="3" type="submit" value="Borrar Linea"
						  		   onclick="javascript:if (confirm('Desea borrar esta l&iacute;nea del documento? \n En caso de ser una linea externa, ser&aacute; devuelta a la lista de recuperaraci&oacute;n.')) return true; else return false;">

						</cfif>
		  		    </cfif>
		        </td>
		    </tr>
		</table>
		<!--- HIDDENS --->
		<cfoutput>
            <input name="Cid" type="hidden" value="<cfif modoDet NEQ "ALTA">#rsLinea.Cid#</cfif>">
            <input name="Aid" type="hidden" value="<cfif modoDet NEQ "ALTA">#rsLinea.Aid#</cfif>">
            <input name="DTtipo" type="hidden" value="<cfif modoDet NEQ "ALTA">#rsLinea.DTtipo#</cfif>">
            <input name="DTfecha" type="hidden" value="<cfif modoDet NEQ "ALTA">#LSDateFormat(rsLinea.DTfecha,'DD/MM/YYYY')#<cfelse>#LSDateFormat(Now(),'DD/MM/YYYY')#</cfif>">
            <input name="DTlinea" type="hidden" value="<cfif modoDet NEQ "ALTA">#rsLinea.DTlinea#</cfif>">
            <input name="CcuentaDet" type="hidden" value="<cfif modoDet NEQ "ALTA">#rsLinea.Ccuenta#</cfif>">
            <input name="CcuentadesDet" type="hidden" value="<cfif modoDet NEQ "ALTA">#rsLinea.Ccuentades#</cfif>">
            <input name="DTlineaext" type="hidden" value="<cfif modoDet NEQ "ALTA">#rsLinea.DTlineaext#</cfif>">
            <input name="DTcodigoext" type="hidden" value="<cfif modoDet NEQ "ALTA">#rsLinea.DTcodigoext#</cfif>">
            <input name="ModPrecio" type="hidden" value="1">
            <input name="CambioEncabezado" type="hidden" value="">
            <!--- ts_rversion del Detalle --->
            <cfset tsD = "">
            <cfif modoDet NEQ "ALTA">
              <cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsLinea.ts_rversion#" returnvariable="tsD">
              </cfinvoke>
            </cfif>
            <input name="timestampD" type="hidden" value="<cfif modoDet NEQ "ALTA">#tsD#</cfif>">
         </cfoutput>
 	</div>
</cf_Confirm>

<cffunction  name="StrReplace">
	<cfargument  name="str" required="true">
	<cfset str = Replace(str, 'á', '&aacute;', 'all')>
	<cfset str = Replace(str, 'é', '&eacute;', 'all')>
	<cfset str = Replace(str, 'í', '&iacute;', 'all')>
	<cfset str = Replace(str, 'ó', '&oacute;', 'all')>
	<cfset str = Replace(str, 'ú', '&uacute;', 'all')>
	<cfset str = Replace(str, 'Á', '&Aacute;', 'all')>
	<cfset str = Replace(str, 'É', '&Eacute;', 'all')>
	<cfset str = Replace(str, 'Í', '&Iacute;', 'all')>
	<cfset str = Replace(str, 'Ó', '&Oacute;', 'all')>
	<cfset str = Replace(str, 'Ú', '&Uacute;', 'all')>
	<cfreturn str>
</cffunction>

<script>
	function funcAgregar(){
		if (document.form1.DTotraCant == undefined){
			alert("Debe escoger una cuenta");
			return false;
		}else{
			if(parseFloat(document.form1.DTotraCant.value) <= 0){
				alert("Debe agregar un monto mayor a cero");
				return false;
			}
		}
		return true;
	}
</script>