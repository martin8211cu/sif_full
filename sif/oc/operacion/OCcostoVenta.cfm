<cf_templateheader title="Generación del Costo de Venta Pendiente">
	<cf_web_portlet_start titulo="Generación del Costo de Venta Pendiente">

		<cf_navegacion name="OCid" default="" navegacion="">
	<cf_dbfunction name="OP_concat" returnvariable="_Cat">
		<form 	name="form1" 
				action="OCcostoVenta_sql.cfm" method="post"
		>
		<table align="center">
			<cfquery name="rsSQL" datasource="#session.DSN#">
				select Pvalor
				  from Parametros 
				 where Ecodigo = #session.Ecodigo#
				   and Pcodigo = 490
			</cfquery>
			<cfset LvarCostoVentaPendiente = rsSQL.Pvalor>
			<tr>
				<td>&nbsp; </td>
			</tr>
			<tr>
				<td nowrap="nowrap">
					<strong>Parámetro General: Generar Costo de Ventas</strong>
				</td>
				<td nowrap="nowrap">
					 
					<cfif rsSQL.Pvalor EQ "">
						No se ha configurado
					<cfelseif rsSQL.Pvalor EQ "0">
						Durante la Aplicación del documento CxC
					<cfelse>
						Mantener Pendiente para final mes
					</cfif>
				</td>
	
			<tr>
				<td>&nbsp; </td>
			</tr>
			<cfquery name="rsSQL" datasource="#session.DSN#">
				select 	count (1) as  Movimientos
					 ,	count (distinct <cf_dbfunction name="concat" args="CCTcodigo, Ddocumento">) as Facturas
					 ,	count (distinct Aid) as Articulos
				  from CCVProducto cv
				 where Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				   and DDtipo 		= 'A'		<!--- Articulos --->
				   and CCVPestado	= 0			<!--- Pendientes --->
				   and exists (
				   		select 1
						  from HDDocumentos cc
						 where cc.Ecodigo	= cv.Ecodigo
						   and cc.CCTcodigo	= cv.CCTcodigo
						   and cc.Ddocumento	= cv.Ddocumento
					)
			</cfquery>
			<cfoutput>
			<tr>
				<td><strong>Costo de Artículos Vendidos de Inventario</strong>&nbsp;&nbsp;&nbsp;</td>
				<td>
					<input type="checkbox" name="chkArticulos"
						value="1"
						<cfif rsSQL.Movimientos EQ 0>
								disabled
						<cfelse>
							checked
						</cfif>  
					 />
					<cfif rsSQL.Movimientos EQ 0>
						No existen Movimientos de Costo de Venta Pendientes
					<cfelse>
						Existen #rsSQL.Movimientos# Movimientos de Costo de Venta Pendientes: 
						#rsSQL.Articulos# Artículos en #rsSQL.Facturas# Documentos
					</cfif>
				</td>
			</tr>
			</cfoutput>
			
			
			<tr>
				<td>&nbsp;</td>
			</tr>
			<cfquery name="rsSQL" datasource="#session.DSN#">
				select 	count (1) as  Movimientos
					 ,	count (distinct <cf_dbfunction name="concat" args="cv.CCTcodigo, cv.Ddocumento">) as Facturas
					 ,	count (distinct cv.Aid) as Articulos
				  from CCVProducto cv
					inner join HDDocumentos cc
						on cc.Ecodigo	 = cv.Ecodigo
					   and cc.CCTcodigo	 = cv.CCTcodigo
					   and cc.Ddocumento = cv.Ddocumento
					   and cc.DDtipo = 'O'
					   and cc.DDcodartcon	= cv.Aid
				 where cv.Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				   and cv.DDtipo 		= 'O'	<!--- Ordenes Comerciales --->
				   and CCVPestado	= 0			<!--- Pendientes --->
			</cfquery>
			<cfoutput>
			<tr>
				<td><strong>Productos de Órdenes Comerciales en Tránsito</strong>&nbsp;&nbsp;&nbsp;</td>
				<td>
					<cfif rsSQL.Movimientos NEQ 0>
						<script language="javascript">
							function onLoadSet(LvarNewEvent)
							{
								var LvarOldEvent = false;
								if (window.Event)
									LvarOldEvent = window.onload ? window.onload : false;
								else
									LvarOldEvent = document.body.onload ? document.body.onload : false;
							
								if (LvarOldEvent)
								{
									LvarOldEvent = LvarOldEvent.toString();
									if (LvarOldEvent.indexOf(LvarNewEvent) == -1)
										LvarNewEvent += LvarOldEvent.substring(LvarOldEvent.indexOf("{"),LvarOldEvent.lastIndexOf("}")+1);
									else
										return;
								}
							
								if (window.Event)
									window.onload = new Function(LvarNewEvent);
								else
									document.body.onload = new Function(LvarNewEvent);
							}
							onLoadSet ("document.form1.chkVerAsiento.click();")
						</script>
						<input type="checkbox" name="chkVerAsiento" id="chkVerAsiento" value="1"
								onclick="
									this.form.btnGenerar.disabled = this.checked;
									document.form5.btnGenerar_Marcados.disabled = this.checked;
									if (this.checked) alert('Haga click en el documento a consultar');
									"
						>
						<strong>Únicamente consultar cálculo preliminar Costo Venta de Órdenes Comerciales</strong>
					</cfif>
				</td>
			</tr>
			</cfoutput>

			<cfquery name="rsSQL" datasource="#session.DSN#">
				select 	count (1) as  Movimientos
					 ,	count (distinct <cf_dbfunction name="concat" args="cv.CCTcodigo, cv.Ddocumento">) as Facturas
					 ,	count (distinct cv.Aid) as Articulos
				  from CCVProducto cv
					inner join HDDocumentos cc
						inner join OCordenComercial oc
							 on oc.OCid = cc.OCid
							and oc.OCtipoIC <>'V'
						on cc.Ecodigo	 = cv.Ecodigo
					   and cc.CCTcodigo	 = cv.CCTcodigo
					   and cc.Ddocumento = cv.Ddocumento
					   and cc.DDtipo = 'O'
					   and cc.DDcodartcon	= cv.Aid
				 where cv.Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				   and cv.DDtipo 		= 'O'	<!--- Ordenes Comerciales --->
				   and CCVPestado	= 0			<!--- Pendientes --->
			</cfquery>
			<cfoutput>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;<strong>- Costo Venta de Productos en Tránsito</strong>&nbsp;&nbsp;&nbsp;</td>
				<td>
					<input type="checkbox" name="chkOCs_DC" value="1"
						<cfif rsSQL.Movimientos EQ 0>
							disabled
						<cfelse>
							checked
						</cfif>  
					 />
					<cfif rsSQL.Movimientos EQ 0>
						No existen Movimientos de Costo de Venta Pendientes
					<cfelse>
						Existen #rsSQL.Movimientos# Movimientos de Costo de Venta Pendientes: 
						#rsSQL.Articulos# Artículos en #rsSQL.Facturas# Documentos
					</cfif>
				</td>
			</tr>
			</cfoutput>

			<cfquery name="rsSQL" datasource="#session.DSN#">
				select 	count (1) as  Movimientos
					 ,	count (distinct <cf_dbfunction name="concat" args="cv.CCTcodigo, cv.Ddocumento">) as Facturas
					 ,	count (distinct cv.Aid) as Articulos
				  from CCVProducto cv
					inner join HDDocumentos cc
						inner join OCordenComercial oc
							 on oc.OCid = cc.OCid
							and oc.OCtipoIC = 'V'
						on cc.Ecodigo	= cv.Ecodigo
					   and cc.CCTcodigo	= cv.CCTcodigo
					   and cc.Ddocumento	= cv.Ddocumento
					   and cc.DDtipo = 'O'
					   and cc.DDcodartcon	= cv.Aid
				 where cv.Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				   and cv.DDtipo 		= 'O'	<!--- Ordenes Comerciales --->
				   and CCVPestado	= 0			<!--- Pendientes --->
			</cfquery>
			<cfoutput>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;<strong>- Costo Venta Directa de Almacén</strong>&nbsp;&nbsp;&nbsp;</td>
				<td>
					<input type="checkbox" name="chkOCs_DV" value="1"
						<cfif rsSQL.Movimientos EQ 0>
							disabled
						<cfelse>
							checked
						</cfif>  
					 />
					<cfif rsSQL.Movimientos EQ 0>
						No existen Movimientos de Costo de Venta Pendientes
					<cfelse>
						Existen #rsSQL.Movimientos# Movimientos de Costo de Venta Pendientes: 
						#rsSQL.Articulos# Artículos en #rsSQL.Facturas# Documentos
					</cfif>
				</td>
			</tr>
			</cfoutput>
	
			<tr>
				<td>&nbsp; </td>
			</tr>
			<tr>
				<td>&nbsp; </td>
			</tr>
			<tr>
				<td></td>
				<td>
					<input type="submit" name="btnGenerar" value="Generar Pendientes"
						onclick="
							var LvarVerAsiento = (document.getElementById('chkVerAsiento').checked ? 1 : 0);
							if (LvarVerAsiento == 1)
							{
								alert ('No se puede consultar en forma preliminar los Costos de mas de un documento, haga click en el documento deseado');
								return false;
							}
							if (!document.form1.chkArticulos.checked && !document.form1.chkOCs.checked) 
							{
								alert('Debe marcar por lo menos un tipo de Costos Pendientes');
								return false;	
							}
							var LvarTipo = document.form1.cboAnoMes.options[document.form1.cboAnoMes.selectedIndex].text;
							return confirm('¿Desea generar todos los Costos de Ventas: ' + LvarTipo + '?');
						"
					>
					<select name="cboAnoMes" 
							onchange="
								if (this.value != 0) 
								{
									this.form.chkArticulos.disabled = true; 
								}
								else
								{
									this.form.chkArticulos.disabled = false; 
								}
							">
						<option value="0">Todos los Pendientes</option>
						<option value="-1">Anteriores a 2007</option>
						<option value="1">Enero 2007</option>
						<option value="2">Febrero 2007</option>
						<option value="3">Marzo 2007</option>
						<option value="4">Abril 2007</option>
						<option value="5">Mayo 2007</option>
					</select>
				</td>
			</tr>
		</table>
		</form>
		<cfquery name="rsCCVProductoP" datasource="#session.dsn#">
			select count(1) as cantidad
			  from CCVProducto cv
			 where cv.Ecodigo = #session.Ecodigo# and cv.CCVPestado = 0
		</cfquery>
		<cfif rsCCVProductoP.cantidad GT 0>
			<cfinvoke 
				component="sif.Componentes.pListas" 
				method="pLista"
				returnvariable="rsLista"
				Ajustar 			= "S"
				columnas			= " 
										distinct 
											cv.CCTcodigo, 
											rtrim(cv.Ddocumento) as Ddocumento, 1 as btnGenerarDoc,
											coalesce(dd.EDtipocambioFecha, dd.Dfecha) as Fecha, 
											cv.DDtipo #_Cat# oc.OCtipoIC as Tipo,
											cv.CCVPmsg, 0 as chkVerAsiento
										"
				tabla				= 	"
										  CCVProducto cv
											inner join HDDocumentos cc
												inner join HDocumentos dd
													 on dd.Ecodigo		= cc.Ecodigo
													and dd.CCTcodigo	= cc.CCTcodigo
													and dd.Ddocumento	= cc.Ddocumento
												left join OCordenComercial oc
													 on oc.OCid = cc.OCid
												on cc.Ecodigo	 	= cv.Ecodigo
											   and cc.CCTcodigo	 	= cv.CCTcodigo
											   and cc.Ddocumento 	= cv.Ddocumento
											   and cc.DDtipo 		= cv.DDtipo
											   and cc.DDcodartcon	= cv.Aid
										"
				filtro				= "cv.Ecodigo = #session.Ecodigo# and cv.CCVPestado = 0"

				Desplegar			= "CCTcodigo, Ddocumento, Fecha, Tipo, CCVPmsg"
				Etiquetas			= "TT, Documento, Fecha, Tipo, Último&nbsp;Error"
				Formatos			= "S,S,D,S,S"
				Align				= "left,left,center,left,left"
					checkboxes			= "S"
					maxrows				= "20"
					mostrar_filtro		= "true"
					filtrar_automatico  = "true"
					filtrar_por			= "cv.CCTcodigo, cv.Ddocumento, dd.EDtipocambioFecha, cv.DDtipo #_Cat# oc.OCtipoIC, CCVPmsg"
	
					IrA					= "OCcostoVenta_sql.cfm"
					Navegacion 			= ""
					IncluyeForm			= "yes"
					FormName			= "form5"
					Keys				= "CCTcodigo,Ddocumento"
					showEmptyListMsg	= "true"
					botones				= "Generar_Marcados"
				funcion = "fnEjecutar"
				fparams	 = "CCTcodigo,Ddocumento,Tipo,CurrentRow"
			/>
			<script language="javascript">
				function fnEjecutar(CCTcodigo,Ddocumento,Tipo,pRow)
				{
					var LvarVerAsiento = (document.getElementById("chkVerAsiento").checked ? 1 : 0);
					if (LvarVerAsiento == 1 && Tipo == "A ")
					{
						alert ('Sólo se puede consultar en forma preliminar los Costos de Órdenes Comerciales');
						return false;
					}
					else if (LvarVerAsiento != 1)
					{
						if (!confirm('¿Desea generar en firme el Costo de Ventas pendientes del documento?'))
							return false;
					}
					eval('document.form5.CHKVERASIENTO_'+pRow+'.value = LvarVerAsiento');
					return Procesar(pRow,'0','form5');
				}

				function funcGenerar_Marcados()
				{
					var LvarVerAsiento = (document.getElementById("chkVerAsiento").checked ? 1 : 0);
					if (LvarVerAsiento == 1)
					{
						alert ('No se puede consultar en forma preliminar los Costos de mas de un documento, haga click en el documento deseado');
						return false;
					}
					if (document.form5.chk) {
						if (document.form5.chk.value) {
							if (document.form5.chk.checked) { 
								return true;
							}
						} else {
							for (var counter = 0; counter < document.form5.chk.length; counter++) {
								if (document.form5.chk[counter].checked) {
									return true;
								}
							}
						}
					}
					alert('Debe marcar por lo menos un documento');
					return false;
				}
			</script>
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>
