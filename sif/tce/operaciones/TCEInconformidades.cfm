<cfif IsDefined("url.LvarECid")>
	<cfset form.ECid = url.LvarECid>
<cfelseif IsDefined("form.LvarECid")>
	<cfset form.ECid = form.LvarECid>    
</cfif>

<style type="text/css">
input {background-color: #FAFAFA; font-family: Tahoma, sans-serif; font-size: 8pt; border:1px solid gray}
.Estilo1 {
	font-size: 24px;
	font-weight: bold;
}
.Estilo2 {
	color: #003366;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 18;
}
.Estilo8 {font-size: 20px; font-weight: bold;}

</style>
<!---Qry para obtener las partidas no conciliadas
--->
<cfquery name="rsBancosNoConciliados" datasource="#Session.DSN#">
	Select 	
		 a.ECid
		,a.CDBlinea
		,a.CDBfechabanco 
		,a.CDBtipomov
		,a.CDBmonto		
		,cb.CBcodigo
		,mo.Miso4217
		,bt.BTcodigo
		,a.CDBinconformidad as BitInconforme
 	from CDBancos a
			inner join Bancos b
				 on a.Bid = b.Bid
				and a.Ecodigo = b.Ecodigo
			inner join ECuentaBancaria ec
				 on ec.ECid = a.ECid
			inner join CuentasBancos cb
				 on cb.CBid = ec.CBid
			inner join Monedas mo
				on cb.Mcodigo=mo.Mcodigo
			left join BTransacciones bt
				on bt.BTid = a.BTid
			   and bt.Ecodigo = a.Ecodigo
	where    a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(form.ECid)#">
		and  a.CDBconciliado= <cfqueryparam cfsqltype="cf_sql_char" value="N">
		and  a.CDBinconformidad = 0
		<cfif isdefined("form.CDBfechabanco") and len(trim(form.CDBfechabanco))>
			and CDBfechabanco = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.CDBfechabanco)#">
		</cfif>  
		<cfif isdefined("form.filtro_CDBfechabanco") and len(trim(form.filtro_CDBfechabanco))>
			and CDBfechabanco = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.filtro_CDBfechabanco)#">
		</cfif>  
		<cfif isdefined("form.filtro_CDBtipomov") and len(trim(form.filtro_CDBtipomov))>
			and upper(CDBtipomov) like upper( <cfqueryparam cfsqltype="cf_sql_char" value="%#form.filtro_CDBtipomov#%"> )
		</cfif>  
		<cfif isdefined("form.filtro_CDBmonto") and len(trim(form.filtro_CDBmonto))>
			and CDBmonto like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.filtro_CDBmonto#%">
		</cfif>  
		<cfif isdefined("form.filtro_Miso4217") and len(trim(form.filtro_Miso4217))>
			and upper(Miso4217) like upper( <cfqueryparam cfsqltype="cf_sql_char" value="%#form.filtro_Miso4217#%">)
		</cfif> 
		<cfif isdefined("form.filtro_CBcodigo") and len(trim(form.filtro_CBcodigo))>
			and upper(CBcodigo) like upper( <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.filtro_CBcodigo#%">)
		</cfif>  
		
</cfquery>
   
<!---  Qry de las partidas no conciliadas con Inconformidad
---> 
<cfquery name="rsConInconformidad" datasource="#Session.DSN#">
		Select 	
		 a.ECid
		,a.CDBlinea
		,a.CDBfechabanco as CDBfechabanco2
		,a.CDBtipomov as CDBtipomov2
		,a.CDBmonto	as CDBmonto2	
		,cb.CBcodigo CBcodigo2
		,mo.Miso4217 as Miso42172
		,bt.BTcodigo
		,a.CDBinconformidad as BitInconforme
		,a.CDBjustificacion as Justificacion
		,'<a href="" onmouseout="javascript: hiddeMsg();" onmouseover="javascript: showMsg(''' + coalesce(a.CDBjustificacion,'') + ''');"><img src="../../imagenes/Help01_T.gif" width="25" height="23" border="0"></a>' as popJusti
 	from CDBancos a
			inner join Bancos b
				 on a.Bid = b.Bid
				and a.Ecodigo = b.Ecodigo
			inner join ECuentaBancaria ec
				 on ec.ECid = a.ECid
			inner join CuentasBancos cb
				 on cb.CBid = ec.CBid
			inner join Monedas mo
				on cb.Mcodigo=mo.Mcodigo
			left join BTransacciones bt
				on bt.BTid = a.BTid
			   and bt.Ecodigo = a.Ecodigo
	where    a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(form.ECid)#">
		and  a.CDBconciliado= <cfqueryparam cfsqltype="cf_sql_char" value="N">
		and  a.CDBinconformidad = 1
   		<cfif isdefined("form.filtro_CDBfechabanco2") and len(trim(form.filtro_CDBfechabanco2))>
			and CDBfechabanco = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.filtro_CDBfechabanco2)#">
		</cfif>  
		<cfif isdefined("form.filtro_CDBtipomov2") and len(trim(form.filtro_CDBtipomov2))>
			and upper(CDBtipomov) like upper( <cfqueryparam cfsqltype="cf_sql_char" value="%#form.filtro_CDBtipomov2#%"> )
		</cfif>  
		<cfif isdefined("form.filtro_CDBmonto2") and len(trim(form.filtro_CDBmonto2))>
			and CDBmonto like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.filtro_CDBmonto2#%">
		</cfif>  
		<cfif isdefined("form.filtro_Miso42172") and len(trim(form.filtro_Miso42172))>
			and upper(Miso4217) like upper( <cfqueryparam cfsqltype="cf_sql_char" value="%#form.filtro_Miso42172#%">)
		</cfif> 
		<cfif isdefined("form.filtro_CBcodigo2") and len(trim(form.filtro_CBcodigo2))>
			and upper(CBcodigo) like upper( <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.filtro_CBcodigo2#%">)
		</cfif>  

</cfquery> 

<!---======================ENCABEZADO DE LA TABLA==============================--->
<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td width="100%" valign="top" style="height:50px;">
				<div align="center" class="Estilo2">
					<div align="left">
						<span class="Estilo8">Partidas con Inconformidad </span>
					</div>
				</div>
		</td>
	</tr>
	<tr>
		<td bgcolor="#A0BAD3" style="height:25px;">&nbsp;&nbsp;</td>
		<td bgcolor="#A0BAD3"></td><td bgcolor="#A0BAD3"></td><td bgcolor="#A0BAD3"></td><td bgcolor="#A0BAD3"></td>
	
	</tr>	
	<tr>
	<div class="ayuda" id="floatinlayer" style="display:none; width:25%;position:absolute;padding:45px;"></div>
		<td>
			<form name="justify" action="" method="post" >
				<table width="100%" align="center" border="0">
					<tr>
						<td style="text-align:left; font-weight:bold; width:50%;" align="center">			
							&nbsp;&nbsp;&nbsp;&nbsp;Justificaci&oacute;n:<br>
							&nbsp;&nbsp;<textarea name="txt_justificacion"  cols="60" rows="2" style="width:95%;"></textarea> 
						</td>
						<td valign="bottom" style="font-weight:bold; width:50%;" align="center">
							<table width="97%" class="ayuda" align="center" border="0">
								<tr>
									<td align="center">
										<p align="justify">
										En esta pantalla se definen los movimientos con inconformidad por parte del Titular de la tarjeta de credito. Para 
										establecer una inconformidad, debe seleccionar el o los movimientos que considere y presionar el bot&oacute;n &quot;Incoformidades&quot;
										</p>
									</td>	
								</tr>
							</table>	
						</td>
					</tr>
				</table>
			</form>
		</td>
	</tr>
	<tr><td>&nbsp;&nbsp;&nbsp;</td></tr>
	<tr>
		<td>
			<!---==========TABLAS===========--->
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				
				<tr>
					<td colspan="0" bgcolor="#A0BAD3">&nbsp;</td>
					<td>&nbsp;&nbsp;&nbsp;</td>
					<td colspan="0" bgcolor="#A0BAD3">&nbsp;</td>
				</tr>
				
				<tr>
					<td align="center" valign="top" class="tituloListas" colspan="0">Movimientos de Bancos</td>
					<td>&nbsp;&nbsp;&nbsp;</td>
					<td align="center" valign="top" class="tituloListas" colspan="0">Movimientos con Inconformidad</td>
				</tr>
				
				<tr>
					<td>
						<!---==========TABLA IZQ===========--->
						<form method="post" name="form1" class="Estilo1">
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								
								<cfoutput> 
									<tr>
									 <cfsavecontent variable="helpimg">
										<img src="../../imagenes/Help01_T.gif" width="25" height="23" border="0">
									</cfsavecontent>
									<!---<cf_notas titulo="Inconformidad" link="#helpimg#" pageIndex="2" msg = "OK" animar="true" >--->
									<td align="center">
										<cfinvoke 
										component="sif.Componentes.pListas"
										method="pListaQuery"
										returnvariable="pListaBanco">
										<cfinvokeargument name="query" 					value="#rsBancosNoConciliados#"/>
										<cfinvokeargument name="desplegar" 				value="Miso4217,CBcodigo,CDBfechabanco ,CDBtipomov,CDBmonto"/>
										<cfinvokeargument name="etiquetas" 				value="Moneda, Cuenta, Fecha,Tipo, Monto"/>
										<cfinvokeargument name="formatos" 				value="V,V,D,V,V"/>
										<cfinvokeargument name="align" 					value="center,left,left,center,left"/>
										<cfinvokeargument name="ajustar" 				value="S,S,D,S"/>
										<cfinvokeargument name="irA" 					value=""/>				
										<cfinvokeargument name="checkboxes" 			value="S"/>
										<cfinvokeargument name="keys" 					value="ECid,CDBlinea"/>
										<cfinvokeargument name="incluyeform"			value="false"/>
										<cfinvokeargument name="formname" 				value="form1"/>
										<cfinvokeargument name="showEmptyListMsg" 		value="true"/>
										<cfinvokeargument name="PageIndex" 				value="1"/>
										<cfinvokeargument name="MaxRows" 				value="12"/>
										<cfinvokeargument name="checkall" 				value="S">
										<cfinvokeargument name="width"     				value="Moneda, Cuenta, Fecha,Tipo, Monto">
										<cfinvokeargument name="filtrar_por"  			value="Miso4217, CBcodigo,CDBfechabanco, CDBtipomov, CDBmonto"/>
										<cfinvokeargument name="mostrar_filtro"			value="true"/>
										<cfinvokeargument name="filtrar_automatico"		value="true"/>
										</cfinvoke>
									</td>
								</tr>	
							</table>
							<input type="hidden" name="justificacion" id="justificacion">
							<input type="hidden" name="LvarECid" value="#form.ECid#">
							</cfoutput>
						</form>
					</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td valign="top">
						<!---==========TABLA DERECHA===========--->
						<form action="" method="post" name="form2" class="Estilo1" style="margin: 0;">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">						
							<cfoutput> 
								<tr>
									<td valign="top" >
										<cfinvoke 
										component="sif.Componentes.pListas"
										method="pListaQuery"
										>
										<cfinvokeargument name="query" 				value="#rsConInconformidad#"/>
										<cfinvokeargument name="desplegar" 			value="Miso42172,CBcodigo2,CDBfechabanco2 ,CDBtipomov2,CDBmonto2,popJusti"/>
										<cfinvokeargument name="etiquetas" 			value="Moneda, Cuenta, Fecha,Tipo, Monto, Justi"/>
										<cfinvokeargument name="formatos" 			value="V,V,D,V,V,IMAG"/>
										<cfinvokeargument name="align" 				value="center,left,left,center,left,left"/>
										<cfinvokeargument name="ajustar" 			value="S,S,D,S,S"/>
										<cfinvokeargument name="irA" 				value=""/>				
										<cfinvokeargument name="checkboxes" 		value="S"/>
										<cfinvokeargument name="keys" 				value="ECid,CDBlinea"/>
										<cfinvokeargument name="incluyeform"		value="false"/>
										<cfinvokeargument name="formname" 			value="form2"/>
										<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
										<cfinvokeargument name="PageIndex" 			value="2"/>
										<cfinvokeargument name="MaxRows" 			value="12"/>
										<cfinvokeargument name="checkall" 			value="S">
										<cfinvokeargument name="width"      		value="true">
										<cfinvokeargument name="filtrar_por"  		value="Miso42172, CBcodigo2,CDBfechabanco2, CDBtipomov2, CDBmonto2"/>
										<cfinvokeargument name="mostrar_filtro"		value="true"/>
										<cfinvokeargument name="filtrar_automatico"	value="false"/>
										
										</cfinvoke>
									</td>
								</tr>	
							</table>
							<input type="hidden" name="rechazo"  id="rechazo" value="1">
							<input type="hidden" name="LvarECid" id="LvarECid" value="#form.ECid#">
							</cfoutput>
							</form>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td bgcolor="#A0BAD3" style="height:25px;">
		&nbsp;&nbsp;
		<input type="button" name="bt_Inconforme" value="Inconforme >>" style="width:100px;" onclick="javascript: funcAplicarInconformidad(document.forms.justify.txt_justificacion.value);">
		<input type="button" name="bt_Rechazo" value="<< Deshacer" style="width:100px;" onclick="javascript:  funcAplicarRechazo();">
		<input type="button" name="Cerrar" value="Cerrar" style="width:100px;" onClick="javascript: funcCerrar();"> 
		</td>
		<td bgcolor="#A0BAD3"></td><td bgcolor="#A0BAD3"></td><td bgcolor="#A0BAD3"></td><td bgcolor="#A0BAD3"></td>
		
	</tr>						
</table>

<script language="javascript" type="text/javascript">
	<!--//
	function showMsg(LvarMsg){
  	var msgtext = LvarMsg;
 	if(!msgtext)return;
	with(document.getElementById('floatinlayer')){
		innerHTML = msgtext;
		style.top = 100+"px";//mlm_top(target) + "px";
		style.left = 65+"%";//mlm_left(target) - 320 + "px";
		style.display='block';
	}
 	}
	function hiddeMsg(){
	document.getElementById('floatinlayer').style.display='none';
 	}
	
 	function funcCerrar() {
		 window.close()
	}
	function validaJustificacion(campo){
		if(campo.length == 0){
			alert("El campo Justificacion no debe estar vacio!")
			return false;
		}
		else{
			return true;
			}
		}	
  	function algunoMarcado(num){
	//valida para los casos en que sea la lista de la izquierda
		if(num==1){
		f = document.form1;
		if (f.chk != null) {
			if (f.chk.value) {
				if (f.chk.checked) {
					return true;
				}
			} else {
				for (var i=0; i<f.chk.length; i++) {
					if (f.chk[i].checked) {
						return true;
					}
				}
			}
		} 
		alert("Debe marcar al menos un elemento de la lista para realizar esta accion!");
		return false;
	//valida para los casos en que sea la lista de la derecha
	}else{
		f = document.form2;
		if (f.chk != null) {
			if (f.chk.value) {
				if (f.chk.checked) {
					return true;
				}
			} else {
				for (var i=0; i<f.chk.length; i++) {
					if (f.chk[i].checked) {
						return true;
					}
				}
			}
		} 
		alert("Debe marcar al menos un elemento de la lista para realizar esta accion!");
		return false;
		}
	}
 	/*Para enviar la inconformidad, se verifican sus campos del form1 para el post*/
 	function funcAplicarInconformidad(campo){
	
 		if (algunoMarcado(1) && validaJustificacion(campo)){
			var just = document.justify.txt_justificacion.value;
 			//document.getElementById("justificacion").value = just;*/
			var obj_just = document.getElementById("justificacion");
			obj_just.value = just;
			
   			document.form1.action="SQL-InconformidadTCE.cfm";
			document.form1.submit();
		}	
		else{ return false; }
	}
	/*Para enviar la inconformidad, se verifican sus campos del form1 para el post*/
  	function funcAplicarRechazo(){
 		if (algunoMarcado(2)){
 			document.form2.action="SQL-InconformidadTCE.cfm";
			document.forms.form2.submit();
		}	
		else{ return false; }
		return true;
	}
  	//-->
</script>


