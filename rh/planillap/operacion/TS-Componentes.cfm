<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<html>
<meta content="no-cache" />
<cfparam name="url.RHEid" default="0" >
<cfparam name="url.RHETEid" default="0" >
<cfparam name="url.RHMPPid" default="0" >
<cfparam name="url.RHCid" default="0" >

<cf_templatecss>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="javascript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
<script type="text/javascript" language="javascript1.2">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
	function funcEliminar(prn_RHDTEid){
		if( confirm('¿Desea Eliminar el Registro?') ){
			document.form3.RHDTEidEliminar.value = prn_RHDTEid;
			document.form3.submit();
		}	
	}	
</script>
<!----////////////////////////////////DATOS DEL FRAME DE COMPONENTES/////////////////////////////////----->
<cfset vn_RHEid =''>	<!----Variable con el ID del escenario---->
<cfset vn_RHETEid = ''>	<!----Variable con el ID de la TablaxEscenario---->
<cfset vn_RHCid = ''>	<!----Variable con el ID de la categoria---->
<cfset vn_RHMPPid = ''>	<!----Variable con el ID del puesto---->
<cfset vn_RHTTid = ''>	<!----Variable con el ID de la tabla---->
<cfif (isdefined("url.RHETEid") and len(trim(url.RHETEid))) and (isdefined("url.RHEid") and len(trim(url.RHEid))) and (isdefined("url.RHCid") and len(trim(url.RHCid)))
		and (isdefined("url.RHMPPid") and len(trim(url.RHMPPid)))>
	<!----Cargar variables---->
	<cfset vn_RHEid = url.RHEid>	
	<cfset vn_RHETEid = url.RHETEid>
	<cfset vn_RHCid = url.RHCid>
	<cfset vn_RHMPPid = url.RHMPPid>
	<!----Fechas del escenario--->
	<cfquery name="rsEscenario" datasource="#session.DSN#">	
		select RHEfdesde, RHEfhasta from RHEscenarios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEid#">
	</cfquery>
	<!----Datos de la tabla salarial---->
	<cfquery name="rsTabla" datasource="#session.DSN#">
		select RHTTid,RHETEdescripcion
		from RHETablasEscenario
		where Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHETEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHETEID#">
			and RHEid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEid#">
	</cfquery>
	<cfset vn_RHTTid = rsTabla.RHTTid>
	<!----Datos de la categoría---->
	<cfquery name="rsCategoria" datasource="#session.DSN#">
		select RHCcodigo #LvarCNCT#' - '#LvarCNCT# RHCdescripcion as Categoria from RHCategoria
		where Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">			
			and RHCid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCid#">
	</cfquery>
		<!----Datos del Puesto---->
	<cfquery name="rsPuesto" datasource="#session.DSN#">
		select RHMPPcodigo #LvarCNCT#' - '#LvarCNCT# RHMPPdescripcion as Puesto from RHMaestroPuestoP
		where Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">			
			and RHMPPid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHMPPid#">
	</cfquery>
	<!----Categorias de la tabla salarial/puesto seleccionado---->
	<cfquery name="rsComponentes" datasource="#session.DSN#">
		select 	a.RHDTEid,
				a.CSid,
				a.RHCid,
				a.RHMPPid,
				a.RHTTid,		
				a.RHDTEmonto,
				a.RHDTEfdesde,
				a.RHDTEfhasta,
				ltrim(rtrim(b.CScodigo)) as Codigo,
				rtrim(ltrim(b.CSdescripcion)) as Descripcion,
				'<img border=''0'' onClick=''javascript: funcEliminar("'#LvarCNCT# <cf_dbfunction name="to_char" args="a.RHDTEid"> #LvarCNCT#'");'' src=''/cfmx/rh/imagenes/Borrar01_S.gif''>' as eliminar				
		from RHDTablasEscenario a
			inner join ComponentesSalariales b
				on b.CSid = a.CSid
				and b.Ecodigo = a.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			and a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEid#">
			and a.RHETEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHETEID#">
			and a.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCid#">
			and a.RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHMPPid#">		
		order by b.Codigo, b.Descripcion
	</cfquery>
	<cfset vn_llaves = ValueList(rsComponentes.RHDTEid)>
</cfif>
<!-----////////////////////// MANTENIMIENTO DE COMPONETES PARA UNA TABLA/PUESTO/CATEGORIA ////////////////////////////----->
<form name="form3" action="" method="post">
	<cfoutput>
		<input type="hidden" name="RHEid" 	value="#vn_RHEid#">
		<input type="hidden" name="RHETEid" value="#vn_RHETEid#">
		<input type="hidden" name="RHCid" 	value="#vn_RHCid#">
		<input type="hidden" name="RHMPPid" value="#vn_RHMPPid#">
		<input type="hidden" name="RHTTid" 	value="#vn_RHTTid#">
		<input type="hidden" name="RHEfdesde" value="<cfif isdefined("rsEscenario") and rsEscenario.RecordCount NEQ 0>#DateFormat(rsEscenario.RHEfdesde,'dd/mm/yyyy')#</cfif>">
		<input type="hidden" name="RHEfhasta" value="<cfif isdefined("rsEscenario") and rsEscenario.RecordCount NEQ 0>#DateFormat(rsEscenario.RHEfhasta,'dd/mm/yyyy')#</cfif>">
		<input type="hidden" name="vn_llaves" value="<cfif isdefined("vn_llaves")>#vn_llaves#</cfif>">
		<input type="hidden" name="RHDTEidEliminar" value="">
	</cfoutput>
	<table width="100%" cellpadding="1" cellspacing="0">
	  <tr>
		<td width="14%" nowrap="nowrap" class="tituloListas" align="right">
			<strong style="color:#003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">Tabla Salarial:</strong></td>
		<td width="86%" colspan="5" class="tituloListas">
			<strong style="color:#003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">
				<cfif isdefined("rsTabla") and rsTabla.RecordCount NEQ 0><cfoutput>#rsTabla.RHETEdescripcion#</cfoutput></cfif>
			</strong>		</td>
	  </tr>
	  <tr>
		<td class="tituloListas" align="right"><strong style="color:#003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">Puesto:</strong></td>
		<td class="tituloListas" colspan="5">
			<strong style="color:#003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">
				<cfif isdefined("rsPuesto") and rsPuesto.RecordCount NEQ 0><cfoutput>#rsPuesto.Puesto#</cfoutput></cfif>
			</strong>		
		</td>
	  </tr>  
	  <tr>
		<td class="tituloListas" align="right"><strong style="color:#003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">Categoría:</strong></td>
		<td class="tituloListas" colspan="5">
			<strong style="color:#003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">
				<cfif isdefined("rsCategoria") and rsCategoria.RecordCount NEQ 0><cfoutput>#rsCategoria.Categoria#</cfoutput></cfif>
			</strong>		
		</td>
	  </tr>
	  <tr><td class="tituloListas" colspan="6">&nbsp;</td></tr>
	  <!---<tr>
		<td class="tituloListas" colspan="6" align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:13pt; font-variant:small-caps; font-weight:bolder;">Detalle de Categorías/Puesto</strong></td>
	  </tr>----->
		<tr bgcolor="#CCCCCC">
		  <td colspan="6"><table width="100%" cellpadding="0" cellspacing="0">
            <tr>
				<td width="26%">&nbsp;</td>
            </tr>
			<tr>
				<td width="26%"><strong>&nbsp;Componente&nbsp;</strong></td>
				<td width="20%" ><strong>&nbsp;Monto&nbsp;</strong></td>
				<td width="13%" nowrap="nowrap"><strong>&nbsp;Fecha Desde&nbsp;</strong></td>
				<td width="12%" nowrap="nowrap"><strong>&nbsp;Fecha Hasta&nbsp;</strong></td>
			  <td colspan="3">&nbsp;</td>
			</tr>
            <tr>
				<td width="26%" height="33">
					<cf_conlis 
						campos="CSid, CScodigo, CSdescripcion"
						asignar="CSid, CScodigo, CSdescripcion"
						size="0,8,20"
						desplegables="N,S,S"
						modificables="N,S,N"						
						title="Lista de Componentes"
						tabla="ComponentesSalariales a"
						columnas="CSid, CScodigo, CSdescripcion"
						filtro=" a.Ecodigo = #Session.Ecodigo# 
								and a.CSid not in (select CSid from RHDTablasEscenario 
												where RHEid = #vn_RHEid#
													and RHETEid = #vn_RHETEid#
													and RHCid = #vn_RHCid#
													and RHMPPid = #vn_RHMPPid#
													and Ecodigo = #session.Ecodigo#		
												)"
						filtrar_por="CScodigo, CSdescripcion"
						desplegar="CScodigo, CSdescripcion"
						etiquetas="C&oacute;digo, Descripci&oacute;n"
						formatos="S,S"
						align="left,left"								
						asignarFormatos="S,S,S"
						form="form3"
						showEmptyListMsg="true"
						EmptyListMsg=" --- No se encontraron registros --- "
					/>              
			  </td>
				<td width="20%">
					<input type="text" name="RHDTEmontoNuevo" value="" tabindex="2" size="25" maxlength="30" style="text-align: right;" onBlur="javascript:fm(this,2); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
				</td>
				<td width="13%">
					<cf_sifcalendario conexion="#session.DSN#" form="form3" name="fdesdeNuevo">
		      </td>
				<td width="12%">
					<cf_sifcalendario conexion="#session.DSN#" form="form3" name="fhastaNuevo">              
		  	  </td>
			  	<td width="12%" valign="middle">
					<input type="submit" value="+ Componente" name="btn_nuevo" 	onclick="javascript: return funcHabilitarValidacion()" />
			  	</td>
			  	<td width="8%"  valign="middle">
					<input  type="submit" value="Guardar" name="btn_modifica" onClick="javascript: return funcValidacionUpdate()" />
			  	</td>
			  	<td width="9%" align="center" valign="middle">
					<cfoutput>	
						<input type="button" name="btn_regresar" value="<< Anterior" onClick="javascript: window.parent.funcRegresaCategoria('#vn_RHEid#','#vn_RHETEid#');" />
					</cfoutput> 
			  	</td>
				<!----
				<td width="228" valign="bottom" align="center" colspan="2">
					<cfoutput>
						<input type="button" name="btn_regresar" value="<< Anterior" onClick="javascript: window.parent.funcRegresaCategoria('#vn_RHEid#','#vn_RHETEid#');" />
					</cfoutput> 
				</td>
				----->
            </tr>
            <tr>
				<td>&nbsp;</td>
            </tr>
          </table></td>
		</tr>
		<tr>
			<td colspan="6">
			<fieldset><legend align="center" style="color:#003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">Detalle de Categorías/Puesto</legend>
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr class="titulocorte">
					<td width="5%"><strong>Código</strong></td>
					<td width="20%"><strong>Componente</strong></td>
					<td width="10%"><strong>Fecha Desde</strong></td>
					<td width="10%"><strong>Fecha Hasta</strong></td>
					<td width="20%" align="right"><strong>Monto</strong></td>
					<td width="5%" align="right">&nbsp;</td>
				</tr>
				<cfif isdefined("rsComponentes") and rsComponentes.RecordCount NEQ 0>
					<cfoutput query="rsComponentes">
						<tr class="<cfif rsComponentes.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
							<td width="5%">#rsComponentes.Codigo#</td>
							<td width="20%">#rsComponentes.Descripcion#</td>
							<td width="10%">
								<cf_sifcalendario conexion="#session.DSN#" form="form3" name="fdesde_#rsComponentes.RHDTEid#" value="#LSDateFormat(rsComponentes.RHDTEfdesde,'dd/mm/yyyy')#">							</td>
							<td width="10%">
								<cf_sifcalendario conexion="#session.DSN#" form="form3" name="fhasta_#rsComponentes.RHDTEid#" value="#LSDateFormat(rsComponentes.RHDTEfhasta,'dd/mm/yyyy')#">							</td>
							<td align="right" width="20%">					
								<input type="hidden" name="RHDTEid" value="#rsComponentes.RHDTEid#">
								<input type="text" name="RHDTEmonto_#rsComponentes.RHDTEid#" value="#LSNumberFormat(rsComponentes.RHDTEmonto,',9.00')#" size="30" maxlength="30" style="text-align: right;" onBlur="javascript:fm(this,2); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
							</td>							
							<td align="right" style="cursor:pointer;" width="5%">#rsComponentes.eliminar#</td>
						</tr>
					</cfoutput>
				<cfelse>						
					<tr><td colspan="6" align="center"><strong>------  No hay componentes asignados al Puesto/Categor&iacute;a del escenario ------</strong></td></tr>									
				</cfif>	
			</table>
			</fieldset>			
			</td>
		</tr>			
		<tr><td colspan="6">&nbsp;</td></tr>
	</table>
</form>	
<script language="JavaScript" type="text/javascript">	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form3");

	objForm.fhastaNuevo.description="Fecha hasta";				
	objForm.fdesdeNuevo.description="Fecha desde";	
	objForm.CSid.description = "Componente";
	objForm.RHDTEmontoNuevo.description = "Monto";
	
	function funcHabilitarValidacion(){
		objForm.fhastaNuevo.required = true;
		objForm.fdesdeNuevo.required = true;
		objForm.CSid.required = true;		
		objForm.RHDTEmontoNuevo.required = true;		
		if (document.form3.fdesdeNuevo.value != '' && document.form3.fhastaNuevo.value != ''){
			if (!funcValidaFechas(document.form3.fdesdeNuevo,document.form3.fhastaNuevo)){
				return false;			
			}		
		}
	}
	
	function funcValidaFechas(pro_fechadesde, pro_fechahasta){		
		var fechadesde = pro_fechadesde.value.split('/'); 					//Fecha desde seleccionada
		var fechahasta = pro_fechahasta.value.split('/');					//Fecha hasta seleccionada
		var RHEfdesde  = document.form3.RHEfdesde.value.split('/');			//Fecha desde escenario
		var RHEfhasta  = document.form3.RHEfhasta.value.split('/');			//Fecha hasta escenarios
		if (fechadesde[2]+fechadesde[1]+fechadesde[0] > fechahasta[2]+fechahasta[1]+fechahasta[0]){
			alert("La fecha desde no puede ser mayor que la fecha hasta");
			return false;
		}	
		if ((fechadesde[2]+fechadesde[1]+fechadesde[0] < RHEfdesde[2]+RHEfdesde[1]+RHEfdesde[0]) || (fechahasta[2]+fechahasta[1]+fechahasta[0] > RHEfhasta[2]+RHEfhasta[1]+RHEfhasta[0])){
			alert("El rango de fechas está fuera del rango de fechas del Escenario");			
			return false;
		}	
		else{
			return true;
		}			
	}	
	
	function funcValidacionUpdate(){
		var prn_valores = document.form3.vn_llaves.value.split(','); 	
		var vb_regreso  = true;
		//Validar todos los campos tipo fecha
		for (i=0;i<=prn_valores.length-1;i++){
			if(!funcValidaFechas(document.form3['fdesde_'+prn_valores[i]],document.form3['fhasta_'+prn_valores[i]])){
				vb_regreso = false;
			}
		}
		if (vb_regreso==false){
			return false;
		}
		else{
			return true;
		}
		
	}	
</script>
<!----////////////////////////// INSERTAR NUEVO COMPONENTE, ELIMINAR UNO, Y MODIFICAR////////////////////////////////////----->
<cfif isdefined("form.btn_nuevo") or isdefined("form.btn_modifica") or (isdefined("form.RHDTEidEliminar") and len(trim(form.RHDTEidEliminar)))>
	<!---Insertado de nuevo componente salarial---->
	<cfif isdefined("form.btn_nuevo") and isdefined("form.RHEid") and len(trim(form.RHEid)) and isdefined("form.RHETEid") and len(trim(form.RHETEid))
		and isdefined("form.RHTTid") and len(trim(form.RHTTid)) and isdefined("form.RHMPPid") and len(trim(form.RHMPPid))
		and isdefined("form.RHCid") and len(trim(form.RHCid))>	
		<cftransaction>
			<cfquery name="rsMoneda" datasource="#session.DSN#">
				select Mcodigo
				from Empresas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<cfquery name="Inserta" datasource="#session.DSN#">
				insert into RHDTablasEscenario (Ecodigo, 
												RHETEid, 
												RHEid, 
												RHTTid, 
												RHMPPid, 
												RHCid, 
												CSid, 
												RHDTEmonto, 
												Mcodigo, 
												RHDTEfdesde, 
												RHDTEfhasta, 
												BMfecha, 
												BMUsucodigo)
					values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHETEid#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTTid#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHMPPid#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#">,
							 <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.RHDTEmontoNuevo,',','','all')#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMoneda.Mcodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fdesdeNuevo)#">,
							 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fhastaNuevo)#">,
							 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
							)
			</cfquery>	
		</cftransaction>	
	<!----Modificacion de montos y fechas------>
	<cfelseif isdefined("form.btn_modifica")>
		<cftransaction>
			<cfloop list="#form.RHDTEid#" index="i">				
				<cfquery datasource="#session.DSN#">
					update RHDTablasEscenario 
						set RHDTEmonto = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form['RHDTEmonto_#i#'],',','','all')#">
						<cfif isdefined("form.fdesde_#i#") and len(trim(form['fdesde_#i#']))>
							, RHDTEfdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form['fdesde_#i#'])#">
						</cfif>
						<cfif isdefined("form.fhasta_#i#") and len(trim(form['fhasta_#i#']))>
							, RHDTEfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form['fhasta_#i#'])#">
						</cfif>
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and RHDTEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">						
				</cfquery>
			</cfloop>
		</cftransaction>		
	<!----Borrado de componente---->
	<cfelseif isdefined("form.RHDTEidEliminar") and len(trim(form.RHDTEidEliminar))>
		<cfquery name="Delete" datasource="#session.DSN#">
			delete from RHDTablasEscenario
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and RHDTEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDTEidEliminar#">	
		</cfquery>
	</cfif>	
	<script type="text/javascript" language="javascript1.2">
		document.form3.submit();	
	</script>
</cfif>
</html>