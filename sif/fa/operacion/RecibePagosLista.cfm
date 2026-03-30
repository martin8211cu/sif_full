<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Facturaci&oacute;n - Recibir Pagos
	</cf_templatearea>
	
	<cf_templatearea name="body">
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Recibir Pagos'>
			
			<script language="JavaScript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
 			<script language="JavaScript1.2" type="text/javascript">
				function regresar(){
					document.lista.action = "../MenuFA.cfm";
					document.lista.submit();
				}
				
				function validar(){
					document.filtro.total_productos.value = qf(document.filtro.total_productos.value)
					document.filtro.fprima.value = qf(document.filtro.fprima.value)
				}
			</script>
			
			<cfoutput>
			<table border="0" width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td nowrap colspan="9"><cfinclude template="../../portlets/pNavegacionFA.cfm"></td>
				</tr>
				<!--- filtro --->
				<tr>
					<td>
						<form style="margin:0"  name="filtro" method="post" onSubmit="javascript: validar();">
						<table class="areaFiltro" width="100%" border="0">
							<!--- Titulos e Inputs --->
							<tr>
								<td nowrap><strong>C&eacute;dula:</strong></td>
								<td nowrap>
									<input type="text" name="fcedula_cliente" size="30" maxlength="60" value="<cfif isdefined("form.fcedula_cliente") and len(trim(form.fcedula_cliente))>#form.fcedula_cliente#</cfif>">
								</td>

								<td nowrap><strong>Nombre:</strong></td>
								<td nowrap>
									<input type="text" name="fnombre_cliente" size="30" maxlength="60" value="<cfif isdefined("form.fcedula_cliente") and len(trim(form.fcedula_cliente))>#form.fcedula_cliente#</cfif>">
								</td>
								
								<td nowrap><strong>Monto:</strong></td>
								<td nowrap>
									<input type="text" name="total_productos" size="20" maxlength="20" value="<cfif isdefined("form.total_productos") and len(trim(form.total_productos))>#form.total_productos#</cfif>" 
										style="text-align: right;" 
										onfocus="javascript:this.value=qf(this); this.select();" 
										onblur="javascript: fm(this,2);"  
										onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"   
										alt="El Monto" >
								</td>
								
								<td nowrap><strong>Prima:</strong></td>
								<td nowrap>
									<input type="text" name="fprima" size="20" maxlength="20" value="<cfif isdefined("form.fprima") and len(trim(form.fprima))>#form.fprima#</cfif>" 
										style="text-align: right;" 
										onblur="javascript: fm(this,2);" 
										onfocus="javascript:this.value=qf(this); this.select();"  
										onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
										alt="La Prima" >
								</td>
								<td nowrap>
									<input type="submit" name="btnFiltrar" value="Filtrar">&nbsp;
									<input type="reset" name="btnLimpiar" value="Limpiar">
								</td>
							</tr>
						</table>
						</form>
						
					</td>
				</tr>

				<tr>
					<td nowrap>
                    	<cfinclude template="../../Utiles/sifConcat.cfm">
						<cfquery name="rsLista" datasource="#session.DSN#">
							select 	a.VentaID, 
									a.fecha, 
									a.nombre_cliente, 
									a.cedula_cliente, 
									a.total_productos, 
									a.prima, 
									a.moneda, 
									a.cedula_cliente#_Cat#'-'#_Cat#a.nombre_cliente as Cliente, 
									b.Mnombre, 
									convert(varchar,a.FVid)#_Cat#'-'#_Cat#c.FVnombre as Vendedor,
									a.estado 
							from VentaE a
								left join Monedas b
									on a.Ecodigo = b.Ecodigo
									and a.moneda = b.Miso4217 
								left join FVendedores c
									on a.FVid = c.FVid 
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
								and a.estado = 40
								<!---
								and a.monto_recibido = 0 
								and a.total_productos <> 0 
								--->
								<cfif isdefined("form.fcedula_cliente") and len(trim(form.fcedula_cliente)) gt 0 >
									and upper(cedula_cliente) like upper('%#form.fcedula_cliente#%') 
								</cfif>
								<cfif isdefined("form.fnombre_cliente") and len(trim(form.fnombre_cliente)) gt 0 >
									and upper(nombre_cliente) like upper('%#form.fnombre_cliente#%')
								</cfif>
								<cfif isdefined("form.total_productos") and len(trim(form.total_productos)) gt 0 and form.total_productos NEQ 0>
									and total_productos <= #form.total_productos#
								</cfif>
								<cfif isdefined("form.fprima") and len(trim(form.fprima)) gt 0  and form.fprima NEQ 0>
									and prima <= #form.fprima#
								</cfif>
	
						</cfquery>

						<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="desplegar" value="Vendedor, nombre_cliente, cedula_cliente, fecha, total_productos, prima"/>
							<cfinvokeargument name="etiquetas" value="Vendedor, Cliente, C&eacute;dula, Fecha, Monto de la Factura, Prima"/>
							<cfinvokeargument name="formatos" value="V, V, V, D, M, M"/>
							<cfinvokeargument name="align" value="left, left, left, left, right, right"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="RecibePagos.cfm"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="VentaID"/>
							<cfinvokeargument name="cortes" value="Cliente,Mnombre"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="debug" value="N"/>
						</cfinvoke>
					</td>
				</tr>
				
				<tr><td nowrap>&nbsp;</td></tr>
				
				<tr>
					<td nowrap align="center">
						<input type="button" name="btnRegresar" value="Regresar" onClick="javascript:regresar();">
					</td>
				</tr>
				<tr>
				<td height="10">&nbsp;</td>
			  </tr>
			</table>		  
			</cfoutput>
			
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>