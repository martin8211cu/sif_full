<cfinvoke xmlfile="/rh/admin/catalogos/calendarioPagos.xml" Key="LB_Normal"   Default="Normal" 		returnvariable="vNormal" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke xmlfile="/rh/admin/catalogos/calendarioPagos.xml" Key="LB_Anticipo" Default="Anticipo" 	returnvariable="vAnticipo" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke xmlfile="/rh/admin/catalogos/calendarioPagos.xml" Key="LB_Especial" Default="Especial" 	returnvariable="vEspecial" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke xmlfile="/rh/admin/catalogos/calendarioPagos.xml" Key="LB_ConceptosDePago" Default="Conceptos de Pago" returnvariable="LB_ConceptosDePago" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke xmlfile="/rh/admin/catalogos/calendarioPagos.xml" Key="LB_TiposDeDeduccionAExcluir" Default="Tipos de Deducci&oacute;n a Excluir" returnvariable="LB_TiposDeDeduccionAExcluir" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke xmlfile="/rh/admin/catalogos/calendarioPagos.xml" Key="LB_creditosfiscales" Default="Cr&eacute;ditos Fiscales a Excluir" returnvariable="LB_creditosfiscales" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke xmlfile="/rh/admin/catalogos/calendarioPagos.xml" Key="LB_cargas" Default="Cargas a Excluir" returnvariable="LB_cargas" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke xmlfile="/rh/generales.xml" Key="LB_NoSeEncontraronRegistros" Default="No se encontraron registros" returnvariable="LB_NoReg" component="sif.Componentes.Translate" method="Translate"/>

<!--- Datos del Calendario de Pagos --->
<cfquery name="data" datasource="#session.DSN#">
	select a.CPid, 
		   a.CPcodigo, 
		   a.CPdescripcion, 
		   a.CPdesde, 
		   a.CPhasta,
		   a.CPfpago,
		   a.Tcodigo,
		   a.CPtipo,
		   case a.CPtipo when 0 then '#vNormal#' when 1 then '#vEspecial#' else '#vAnticipo#' end as tipo,
		   a.CPperiodo,
		   a.CPmes,
		   tn.Tdescripcion
	from CalendarioPagos a, TiposNomina tn
	where a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
	and tn.Ecodigo = a.Ecodigo
	and tn.Tcodigo = a.Tcodigo
</cfquery>

<cfset v_mes = '' >
<cfset lista_meses = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre' >
<cfquery name="rs_mes" datasource="#session.DSN#">
	select a.VSvalor, a.VSdesc as mes
	from VSidioma a , Idiomas b
	where a.Iid = b.Iid
	and b.Icodigo = '#session.idioma#'
	and a.VSgrupo = 1
	and a.VSvalor='#data.CPmes#111'
</cfquery>
<cfset v_mes = rs_mes.mes >
<cfif len(trim(v_mes)) is 0 >
	<cfset v_mes = listgetat(lista_meses, data.CPmes) >
</cfif>
<!--- dependencias ---------------------------------------------------->

<!---- tipos de deducciones a excluir---->

<cfquery name="rsTiposDeduccionEX" datasource="#Session.DSN#">
	select a.CPid, b.TDid, c.TDdescripcion 
	from CalendarioPagos a, RHExcluirDeduccion b, TDeduccion c
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	  and a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.CPid#">
	  and rtrim(a.Tcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(data.Tcodigo)#">
	  and a.CPid = b.CPid
	  and b.TDid = c.TDid																							
</cfquery>

<!--- Conceptos de Pago --->
<cfquery name="rsConceptos" datasource="#Session.DSN#">
	select a.CPid, b.CIid, c.CIcodigo, c.CIdescripcion
	from CalendarioPagos a, CCalendario b, CIncidentes c
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	  and a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.CPid#">
	  and rtrim(a.Tcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(data.Tcodigo)#">
	  and a.CPid = b.CPid
	  and b.CIid = c.CIid																									
</cfquery>



<!---- creditos fiscales a excluir---->
<cfquery name="rs_creditos" datasource="#session.DSN#">
               select a.CDid, b.CDcodigo, b.CDdescripcion
				from RHExcluirCFiscal a, ConceptoDeduc b
				where a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
				and b.CDid = a.CDid
				order by b.CDcodigo
</cfquery>	


<!---- cargas a excluir---->
<cfquery name="rsCargas" datasource="#session.DSN#">
	select a.DClinea, b.DCcodigo, DCdescripcion
	from RHCargasExcluir a, DCargas b
	where a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
	and b.DClinea=a.DClinea
</cfquery>


<cfoutput>
<form id="form1" name="form1" action="calendarioReplicar-sql.cfm" method="post" onsubmit="return validar();"  >
<input type="hidden" name="CPid" value="#form.CPid#" />
<input type="hidden" name="Tcodigo" value="#data.Tcodigo#" />
<table align="center" width="80%" cellpadding="4" cellspacing="0" border="0">
	<tr>
		<td colspan="6" bgcolor="##CCCCCC"><strong><cf_translate xmlfile="/rh/admin/catalogos/calendarioPagos.xml" key="LB_Proceso_de_Replicacion_de_Calendarios_de_Pago">Proceso de Replicaci&oacute;n de Calendarios de Pago</cf_translate></strong></td>
	</tr>
		<tr bgcolor="##fafafa">
		<td  nowrap="nowrap" ><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Tipo">Tipo</cf_translate>:</strong></td>
		<td  nowrap="nowrap" >#data.tipo#</td>
		<td  nowrap="nowrap" ><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_TipoDeNomina">Tipo de N&oacute;mina</cf_translate>:</strong></td>
		<td  nowrap="nowrap" >#trim(data.Tcodigo)# - #data.Tdescripcion#</td>
	</tr>

	<tr bgcolor="##fafafa">

		<td nowrap="nowrap" width="1%"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Periodo">Per&iacute;odo</cf_translate>:</strong></td>
		<td width="32%">#data.CPperiodo#</td>
		<td nowrap="nowrap" width="1%"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Mes">Mes</cf_translate>:</strong></td>
		<td width="32%">#v_mes#</td>
	</tr>
	<tr bgcolor="##fafafa">
		<td nowrap="nowrap" width="1%"><strong><cf_translate xmlfile="/rh/admin/catalogos/calendarioPagos.xml" key="LB_FechaDesde">Fecha Desde</cf_translate>:</strong></td>
		<td>#LSDateFormat(data.CPdesde, 'dd/mm/yyyy')#</td>
		<td nowrap="nowrap"><strong><cf_translate xmlfile="/rh/admin/catalogos/calendarioPagos.xml" key="LB_FechaHasta">Fecha Hasta</cf_translate>:</strong></td>
		<td width="1%">#LSDateFormat(data.CPhasta, 'dd/mm/yyyy')#</td>
		<td width="1%" nowrap="nowrap"><strong><cf_translate xmlfile="/rh/admin/catalogos/calendarioPagos.xml" key="LB_FechaDePago">Fecha de Pago</cf_translate>:</strong></td>
		<td >#LSDateFormat(data.CPfpago, 'dd/mm/yyyy')#</td>
		
	</tr>
	<tr  bgcolor="##fafafa">
		<td nowrap="nowrap" ><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_CalendarioDePago">Descripci&oacute;n</cf_translate>:</strong></td>
		<td nowrap="nowrap" colspan="3">#data.CPdescripcion#</td>

	</tr>

<!--- pintando las dependencias del calendario de pagos ---->
		
		

		<!--- pintando tipos de deduccion --->
		<tr>
			<td colspan="6">
				<table width="100%" cellpadding="1" style=" border:1px solid ##cccccc;" >
					<tr bgcolor="##EEEEEE"><td><strong>#LB_TiposDeDeduccionAExcluir#</strong></td></tr>
					<cfloop query="rsTiposDeduccionEX">
						<tr ><td>#rsTiposDeduccionEX.TDdescripcion#</td></tr>
					</cfloop>
					<cfif rsTiposDeduccionEX.recordcount eq 0 >
						<tr ><td align="center">-#LB_NoReg#-</td></tr>
					</cfif>
				</table>
			</td>
		</tr>

		<!--- pintando conceptos de pago --->
		<tr >
			<td colspan="6">
				<table width="100%" cellpadding="1" style=" border:1px solid ##cccccc;" >
					<tr bgcolor="##EEEEEE"><td><strong>#LB_ConceptosDePago#</strong></td></tr>
					<cfloop query="rsConceptos">
						<tr ><td>#trim(rsConceptos.CIcodigo)# - #rsConceptos.CIdescripcion#</td></tr>
					</cfloop>
					<cfif rsConceptos.recordcount eq 0 >
						<tr><td align="center">-#LB_NoReg#-</td></tr>
					</cfif>
				</table>
			</td>
		</tr>
		
		<!--- pintando creditos fiscales --->
		<tr >
			<td colspan="6">
				<table width="100%" cellpadding="1" style=" border:1px solid ##cccccc;" >
					<tr bgcolor="##EEEEEE"><td><strong>#LB_creditosfiscales#</strong></td></tr>
					<cfloop query="rs_creditos">
						<tr ><td>#trim(rs_creditos.CDcodigo)# - #rs_creditos.CDdescripcion#</td></tr>
					</cfloop>
					<cfif rsConceptos.recordcount eq 0 >
						<tr><td align="center">-#LB_NoReg#-</td></tr>
					</cfif>
				</table>
			</td>
		</tr>
		<!--- pintando cargas a excluir --->
		<tr >
			<td colspan="6">
				<table width="100%" cellpadding="1" style=" border:1px solid ##cccccc;" >
					<tr bgcolor="##EEEEEE"><td><strong>#LB_cargas#</strong></td></tr>
					<cfloop query="rsCargas">
						<tr ><td>#trim(rsCargas.DCcodigo)# - #rsCargas.DCdescripcion#</td></tr>
					</cfloop>
					<cfif rsConceptos.recordcount eq 0 >
						<tr><td align="center">-#LB_NoReg#-</td></tr>
					</cfif>
				</table>
			</td>
		</tr>
		
		
		<tr>
			<td colspan="6">
				<table width="100%" cellpadding="1" cellspacing="0" >
					<tr bgcolor="##CCCCCC"><td><strong>N&oacute;minas en las que se desea replicar</strong></td></tr>
					<tr>
						<td>
							<table cellpadding="3" width="75%" border="0">
								<tr>
									<td width="1%" valign="middle"><input type="radio" name="todos" checked value="S" onClick="javascript:nominas();"></td>
									<td valign="middle" width="40%" nowrap="nowrap"><label><cf_translate xmlfile="/rh/admin/catalogos/calendarioPagos.xml" key="LB_Copiar_a_todos_los_Tipos_de_Nomina">Copiar a todos los Tipos de N&oacute;mina</cf_translate></label></td>
									<td valign="middle" width="1%"><input type="radio" name="todos" value="N"  onClick="javascript:nominas();"></td>
									<td valign="middle"><label><cf_translate xmlfile="/rh/admin/catalogos/calendarioPagos.xml" key="LB_Seleccionar_Tipos_de_Nomina">Seleccionar Tipos de N&oacute;mina</cf_translate></label></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr id="tr_opcion" style="display:none;">
						<td >
					
						
							<table width="100%" cellpadding="2" cellspacing="0" border="0" style="border:1px solid ##cccccc;">
								<tr bgcolor="##EEEEEE">
									<td width="1%" nowrap="nowrap" valign="middle"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Tipo_de_Nomina">Tipo de N&oacute;mina</cf_translate>:</strong>&nbsp;</td>
									<td valign="middle"><cf_rhtiponomina index="1"></td>
									<td valign="middle"><input type="button" name="Agregar" class="btnNormal" value="Agregar Tipo de N&oacute;mina" onclick="javascript:insRow();"></td>
								</tr>
								<tr>
									<td colspan="3">
										<table id="myTable" width="100%" cellpadding="2" cellspacing="0" bgcolor="##fafafa">
										</table>
									</td>
								</tr>
							</table>
			
				
						</td>
					</tr>
					
					<tr>  	<!--- fecha desde y fechas---->
				
										
										
							<tr bgcolor="##CCCCCC"><td><strong>Informaci&oacute;n  a replicar</strong></td></tr>
							<table width="50%" border="0" cellspacing="0" cellpadding="0" > <!--- Tabla: filtro --->
							
											<tr>
												<td align="left" class="FileLabel"><cf_translate   key="LB_Hasta">Nuevo C&oacute;digo</cf_translate></td>
												<td align="left" class="FileLabel">
													<cf_translate   key="LB_Hasta">Fecha Hasta</cf_translate>
												</td>
												<td width="15%" align="left" class="FileLabel"><cf_translate   key="LB_Pago">Fecha Pago</cf_translate>
												</td>
							
											</tr>
											<tr>
												<td width="15%" nowrap="nowrap" >
												
													<cfif isDefined("data.CPcodigo") and len(trim(data.CPcodigo)) gt 0>
														<cfoutput>
														<cf_sifmaskstring form="form1" name="fCPcodigo" formato="****-**-***" size="15" maxlenght="11" mostrarmascara="false" value="#data.CPcodigo#">
														</cfoutput>
													<cfelse>
														<cf_sifmaskstring form="form1" name="fCPcodigo" formato="****-**-***" size="15" maxlenght="11" mostrarmascara="false" >
													</cfif>	
													
													
												</td>
												
												<td   width="15%"  align="left" >
													<cfif isDefined("data.CPhasta") and len(trim(data.CPhasta)) gt 0>
														<cfoutput>
															<cfset data.CPhasta = LSDateFormat(data.CPhasta,"DD/MM/YYYY")>
															<cf_sifcalendario form="form1" value="#data.CPhasta#" name="fCPhasta">
														</cfoutput>
													<cfelse>
														<cf_sifcalendario form="form1" name="fCPhasta">
													</cfif>	
												</td>
												
												<td width="15%" align="left" >
													<cfif isDefined("data.CPfpago") and len(trim(data.CPfpago)) gt 0>
														<cfoutput>
														<cfset data.CPfpago = LSDateFormat(data.CPfpago,"DD/MM/YYYY")>
															<cf_sifcalendario form="form1" value="#data.CPfpago#" name="fCPfpago">
														</cfoutput>
													<cfelse>
														<cf_sifcalendario form="form1" name="fCPfpago">
													</cfif>	
												</td>
												
											</tr>
			
									</table> 

											
					</tr> <!--- fin tabla fecha hasta, fecha pago--->	
					
				
				
					
				</table>
				
	
		
			</td>
			
			
			
		</tr>
		
		
		
		
		<tr>
			<td colspan="6" align="center">
				<input type="submit" name="Generar" class="btnAplicar" value="Generar" onclick="javascript: return generar();">
				<input type="submit" name="Regresar" class="btnAnterior" value="Regresar" onclick="javascript: return regresar();">				
			</td>
		</tr>
		
		

</table>


</form>

</cfoutput> 	
	
<script type="text/javascript" language="javascript1.2">

	function nominas(){
		if ( document.form1.todos[0].checked ){
			document.getElementById('tr_opcion').style.display = 'none';
		}
		else{
			document.getElementById('tr_opcion').style.display = '';		
		}
	}
	
	// insercion dinamica de ofilas, columnas a la tabla de tipos de nomina
	var cont = 0;
	var atras=0;
	function insRow(){
		var x = document.getElementById('myTable').insertRow(cont);
		cont++;
		
		if (cont % 2){ x.bgColor = '#fafafa'; } else{ x.bgColor = '#FFFFFF'; }
		
		var y = x.insertCell(0);
		var z = x.insertCell(1);
		y.width='35%'
		y.innerHTML = document.form1.Tcodigo1.value + ' - ' + document.form1.Tdescripcion1.value;
		z.innerHTML = "<img id='img_"+cont+"' src='/cfmx/rh/imagenes/Borrar01_S.gif'>";
		
	  	/* se agregan inputs de esta manera, pues si no el submit no los ve al irse a otra pantalla */
		var v_form = document.getElementById('form1')
		var LvarInp   = document.createElement("INPUT");
	  	LvarInp.type = 'hidden';
	  	LvarInp.name = 'codigos';
	  	LvarInp.value = document.form1.Tcodigo1.value;
	  	v_form.appendChild(LvarInp);
		
		var obj = document.getElementById('img_'+cont);
		obj.onclick=function(){	eliminar(x); }

		document.form1.Tcodigo1.value = '';
		document.form1.Tdescripcion1.value = '';
	}
	function eliminar(obj, valor){
		document.getElementById('myTable').deleteRow(obj.rowIndex);
		if (cont > 0 ){
			cont--;
		}
	}

	function generar(){
			if (confirm('Va a generar Calendarios de Pago para las opciones seleccionadas.\n Desea continuar?')){
				return true;
			}
		return false;
	}

	function regresar(){
		document.form1.action = 'calendarioPagos.cfm';
		atras=1;
	}
	
	function validar(){//valida los campos para la realizacion de la replicacion
		if (document.form1.fCPcodigo.value=='' && atras==0){
				alert('Debe digitar el campo C\u00f3digo!');
				return false;   
		}

		if (document.form1.fCPcodigo.value.length<11 && atras==0){
				alert('El tama\u00f1o del c\u00f3digo debe ser de 11 caracteres');
				return false;   
		}
		
		
		if (document.form1.todos[1].checked && atras==0){
			if ( cont == 0 ){
				alert('Debe seleccionar al menos un Tipo de N\u00f3mina para ejecutar el proceso.');
				return false;
			}                       
		}
		if (document.form1.fCPhasta.value > document.form1.fCPfpago.value && atras==0){
				alert('Debe de seleccionar una Fecha Pago posterior o igual a Fecha Hasta');
				return false;                 
		}

		if (document.form1.fCPhasta.value ==''  && atras==0){
		alert('Debe digitar la Fecha Hasta');
		return false;                 
		}
		
		if (document.form1.fCPfpago.value=='' && atras==0){
				alert('Debe digitar la Fecha Pago!');
				return false;   
		}
		
		return true;
	}


</script>