	<script>
	function MostrarDatos()
	{		
		document.form1.action = "cmn_Activos.cfm";
		document.form1.bandera.value = 2;
		document.form1.submit();
	}
	function ParaDepreciacion(indice)
	{	
		if (indice==1)
		{    			
			document.getElementById("tbldep").style.visibility = "visible"
			document.getElementById("tbl_asiento").style.visibility = "hidden"						
		}
		else
		{
			document.getElementById("tbldep").style.visibility = "hidden"
			document.getElementById("tbl_asiento").style.visibility = "visible"
		}
		document.getElementById("Generar").style.visibility = "hidden"
	}
	</script>

	<cfset H_ACTUAL = Hour(Now())>
	<cfset T_ACTUAL = "AM">
	<cfif H_ACTUAL gt 12>
		<cfset H_ACTUAL = H_ACTUAL - 12>
		<cfset T_ACTUAL = "PM">
	</cfif>
	<cfset M_ACTUAL = Minute(Now())>

	<cfoutput>
	<!--- <form name="form1" method="post" action="cmn_IniciaPoceso.cfm" onSubmit=""> --->
	<form name="form1" method="post" action="cmn_Activos.cfm" onSubmit="">
	<table width="100%" border="0">
  	<tr>
    	<td>
				<!--- ---------------------------------------- --->
				<!--- --     INICIA PINTADO DE LA PANTALLA     --->
				<!--- ---------------------------------------- --->
			  	<table width="100%" border="0">
			  	<tr>
						<td align="left" colspan="4">
						    <input type="submit" name="CONSULTAR" value="Consultar" onClick="javascript:MostrarDatos()" tabindex="10">						    
							<input type="reset" name="Limpiar" onClick="javascript:document.location='cmn_ProcesosAF.cfm'" value="Limpiar" tabindex="10">
							<input type="button" name="CrearLista" onClick="javascript:document.location='cmn_ListaProcesosAF.cfm'" value="Lista de Tareas" tabindex="10">														
							<cfif isdefined("CONSULTAR")>
								<input type="submit" name="GENERAR" value="Generar" onClick="" tabindex="10">
							</cfif>
							<input type="hidden" name="bandera" value="1">
							<!--- <input type="button" name="LISTA" value="Ver lista" onClick="javascript:if (window.verlista) verlista() ;"  tabindex="10"> --->
						</td>
				</tr>
					<!--- ********************************************************************************* --->
					<tr>	<td align="center" colspan="4" nowrap bgcolor="##CCCCCC">
							<strong>Seleccion del Proceso a ejecutar</strong>
						</td>
					</tr>            
					<!--- ********************************************************************************* --->
					<tr>
						<td colspan="4">
							<table width="100%" border="0"  id="tblcuenta" >
								<tr>
									<td>
										<strong>Proceso a Ejecutar:</strong>
										<select name="proceso" id="proceso" onChange="javascript:ParaDepreciacion(this.options[this.selectedIndex].value)" tabindex="1">
										<cfif isdefined("proceso")>
											<cfif proceso eq 1>
												<option value="1" selected>Cálculo de la Depresiacion</option>
												<option value="2">Aplicación de Relaciones</option>										
											<cfelse>
												<option value="1">Cálculo de la Depresiacion</option>
												<option value="2" selected>Aplicación de Relaciones</option>												
											</cfif>
										<cfelse>
											<option value="1">Cálculo de la Depresiacion</option>
											<option value="2">Aplicación de Relaciones</option>
										</cfif>
										</select>
									</td>
									<td nowrap colspan="3">&nbsp;</td> 
								</tr>
							</table>
						</td>
					</tr>
					<tr>						
					  	<td nowrap><strong>Hora de ejecución:</strong>&nbsp;&nbsp;&nbsp;
						<select id="HORA" name="HORA" tabindex="5">
						  	<cfloop from="1" to="12" index="H">
								<cfif H LT 10>
									<option value="#H#" <cfif H EQ H_ACTUAL>selected</cfif>>0#H#</option>
								<cfelse>	
								   <option value="#H#" <cfif H EQ H_ACTUAL>selected</cfif>>#H#</option>
								</cfif>
							</cfloop>
						</select>
						
						<select id="MINUTOS"  name="MINUTOS" tabindex="5">
						  	<cfloop from="0" to="59" index="M">
								<cfif M LT 10>
									<option value="#M#" <cfif M EQ M_ACTUAL>selected</cfif>>0#M#</option>
								<cfelse>	
								   <option value="#M#" <cfif M EQ M_ACTUAL>selected</cfif>>#M#</option>
								</cfif>
							</cfloop>
						</select>
						
						<select  id="PMAM" name="PMAM" tabindex="5">
							<option value="AM" <cfif "AM" EQ T_ACTUAL>selected</cfif>>AM</option>
							<option value="PM" <cfif "PM" EQ T_ACTUAL>selected</cfif>>PM</option>
						</select>
					  	</td>

					</tr>			
					<tr>
						<td align="center" colspan="4" nowrap bgcolor="##CCCCCC">
							<strong>Filtros de Busqueda</strong>
						</td>
					</tr>					
					<tr>
						<td colspan="4">
							<table width="40%" border="0"  id="tblrango" >
								<tr>
									<td>
										&nbsp;<strong>Desde:</strong>										
									</td>
									<td><input type="text" name="txt_desde" maxlength="7" style="width:70px" <cfif isdefined("txt_desde")>value="#txt_desde#"</cfif>></td>
								</tr>
								<tr>	
									<td>
										&nbsp;<strong>Hasta:</strong>										
									</td>
									<td><input type="text" name="txt_hasta" maxlength="7" style="width:70px" <cfif isdefined("txt_hasta")>value="#txt_hasta#"</cfif>></td>																		
								</tr>
							</table>
						</td>
					</tr>						
					<tr>					
						<td colspan="4">
						
							<cfif isdefined("proceso")>
								<cfif proceso eq 1>
									<table width="40%" border="0" id="tbldep" style="visibility:visible">
								<cfelse>
									<table width="40%" border="0" id="tbldep" style="visibility:hidden">
								</cfif>
							<cfelse>
								<table width="40%" border="0" id="tbldep" style="visibility:visible">
							</cfif>
								<tr>
									<td width="35%">
										<strong>Depresiacion de:</strong>										
									</td>
									<td>										
										<select name="txt_tipodep" id="txt_tipodep" onChange="javascript:document.getElementById('Generar').style.visibility = 'hidden'">
										<cfif isdefined("txt_tipodep")>
											<cfif txt_tipodep eq 1>
												<option value="1" selected>Plantas y Centrales</option>
												<option value="2">Activos Inmovilizados</option>		
											<cfelse>
												<option value="1">Plantas y Centrales</option>
												<option value="2" selected>Activos Inmovilizados</option>											
											</cfif>								
										<cfelse>
											<option value="1" selected>Plantas y Centrales</option>
											<option value="2">Activos Inmovilizados</option>										
										</cfif>
										</select>
									</td>
								</tr>
							</table>
						</td>
					</tr>								
					<tr>
						<td colspan="2">
						
							<cfif isdefined("proceso")>
								<cfif proceso eq 1>
									<table align="left" id="tbl_asiento" cellpadding="0" cellspacing="0" style="visibility:hidden">
								<cfelse>
									<table align="left" id="tbl_asiento" cellpadding="0" cellspacing="0" style="visibility:visible">
								</cfif>
							<cfelse>
								<table align="left" id="tbl_asiento" cellpadding="0" cellspacing="0" style="visibility:hidden">
							</cfif>												
							<tr>
								<td>
									<strong>Generar un nuevo asiento:</strong>
									<input type="checkbox" name="chk_asiento" checked>
								</td>
							</tr>
							</table>
						</td>
					</tr>
					
					<cfif isdefined("txt_desde") and isdefined("txt_hasta")>
					<!--- ********************************************************************************* --->			
						<cfif proceso eq 1>
							<tr>
								<td align="center" colspan="4" nowrap bgcolor="##CCCCCC">
									<strong>Listado de Categorias</strong>
								</td>
							</tr>
							<!---********************************************************************************* --->            					
							<tr>
								<td colspan="2">								
									<cfinclude template="cmn_Depreciasion.cfm">									
								</td>
							</tr>
						<cfelse>
							<tr>
								<td align="center" colspan="4" nowrap bgcolor="##CCCCCC">
									<strong>Listado de Relaciones</strong>
								</td>
							</tr>
							<!---********************************************************************************* --->            					
							<tr>
								<td colspan="2">								
									<cfinclude template="cmn_Relaciones.cfm">																					
								</td>
							</tr>						
						</cfif>
					</cfif>
				</table>
				
				<!--- -------------------------------------- --->
				<!--- --     FIN PINTADO DE LA PANTALLA      --->
				<!--- -------------------------------------- --->
    		</td>
  		</tr>
	</table>
	</form>
	</cfoutput>
	<script language="JavaScript1.2" type="text/javascript">
	function checkALL(){
		var CANTIDAD 	= new Number(document.form1.Cantidad.value);
		for(var i=0; i<CANTIDAD; i++) {
			eval("document.form1.chktran["+i+"].checked=true")
		}
	}
	/***************************************************************************************************/
   function UncheckALL(){
		var CANTIDAD 	= new Number(document.form1.Cantidad.value);
		for(var i=0; i<CANTIDAD; i++) {
			eval("document.form1.chktran["+i+"].checked=false")
		}
	}
	</script>