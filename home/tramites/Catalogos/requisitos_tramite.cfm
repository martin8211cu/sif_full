<style type="text/css">
	.botonNaranja{ cursor:pointer;  
			font-size:10px;
			font-family:Verdana,Helvetica;
			font-weight:bold;
			color:black;
			background:#cc9933;
			border:0px;
			border:1px solid black;
			height:19px; }
	.botonAzul{ cursor:pointer;  
			font-size:10px;
			font-family:Verdana,Helvetica;
			font-weight:bold;
			color:black;
			background:#3399CC;
			border:0px;
			border:1px solid black;
			height:19px; }
	.letra{ color: #0099cc;
			font-size:14px;
			font-weight:bold;  }
	input {background-color: #FAFAFA; font-family: Tahoma, sans-serif; font-size: 8pt; border:1px solid gray; padding:2;}
</style> 

<table width="100%" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<tr><td bgcolor="#ECE9D8" style="padding:3px;" ><font size="1">Requisitos Asociados al Trámite</font></td></tr>
		<td width="40%" valign="top">
			<table width="80%" align="center" cellpadding="0" cellspacing="0">
				<tr><td>&nbsp;</td></tr>
				<tr><td>
					<cfoutput>
					<form name="form1" method="post" style="margin:0;" action="tramite-paso-sql.cfm" onSubmit="return validar();">
						<input type="hidden" name="id_tramite" value="#form.id_tramite#" >
						<input type="hidden" name="tab" value="3" >
						<input type="hidden" name="id_paso" value="" >
						<input type="hidden" name="id_requisito" value="" >

						<table bgcolor="##F5F5F5" width="100%" cellpadding="3" cellspacing="0" style="border:1px solid gray ">
							<tr>
								<td width="1%" class="tituloListas">N&uacute;mero</td>
								<td width="1%" class="tituloListas">Descripci&oacute;n</td>
							</tr>
							<tr>
								<td width="1%"><input type="text" name="numero_paso" size="4" maxlength="4"></td>
								<td width="1%"> <input type="text" name="nombre_paso" size="60" maxlength="100"></td>
								<td >
									<input class="botonAzul" style="width:100; " type="submit" name="AgregarPaso" value="Agregar Paso">
									<!---<input disabled="disabled" class="botonAzul" style="width:100; " type="submit" name="EliminarPaso" value="Eliminar Paso">--->
									<input class="botonAzul" type="button" name="Limpiar" value="Limpiar" onClick="javascript:limpiar();">
								</td>
							</tr>
						</table>
					</form>
					</cfoutput>
				</td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td>		
						<cfquery name="pasos" datasource="#session.tramites.dsn#">
							select id_paso, numero_paso, nombre_paso
							from TPTramitePaso
							where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
							order by numero_paso
						</cfquery>
						
						<table width="100%" cellpadding="2" cellspacing="0" border="0">
							<cfoutput>
							<cfloop query="pasos">
								<cfquery name="lista" datasource="#session.tramites.dsn#">
									select 	#form.id_tramite# as id_tramite, 
											a.numero_paso,
											a.id_requisito,
											b.codigo_requisito, 
											b.nombre_requisito,
											a.id_paso,
											'3' as tab,
											a.es_obligatorio
		
									from TPRReqTramite a
									
									inner join TPRequisito b
									on b.id_requisito=a.id_requisito
									
									where a.id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
									and a.id_paso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pasos.id_paso#">
									order by a.numero_paso
								</cfquery>
							
								<tr><td colspan="5">
									<table width="100%" border="0" style="border-bottom:1px solid gray " cellpadding="1" cellspacing="0">
										<tr>
											<td style="cursor:pointer;" title="Modificar Paso" class="letra" width="5%" onClick="javascript:modificar(#pasos.id_paso#, '#pasos.numero_paso#', '#pasos.nombre_paso#');" >#pasos.numero_paso#</td>
											<td style="cursor:pointer;" title="Modificar Paso" class="letra" onClick="javascript:modificar(#pasos.id_paso#, '#pasos.numero_paso#', '#pasos.nombre_paso#');">#pasos.nombre_paso#</td>
											<td width="100" align="right"><input class="botonNaranja" type="button" name="Agregar" value="Agregar Requisito" onClick="javascript:agregar(#pasos.id_paso#, 0);"></td>
											<cfif lista.recordcount eq 0 >
												<form name="formp#pasos.currentrow#" method="post" style="margin:0;" action="tramite-paso-sql.cfm" >
													<input type="hidden" name="id_tramite" value="#form.id_tramite#" >
													<input type="hidden" name="tab" value="3" >
													<input type="hidden" name="id_paso" value="#pasos.id_paso#" >
													<td width="1%" align="center"><input style="border:0 solid white " type="image" name="eliminar" src="../images/Borrar01_S.gif" title="Eliminar Paso" onClick="javascript:return eliminar_paso(#pasos.currentrow#, #pasos.id_paso#);" ></td>
												</form>
											</cfif>
										</tr>
									</table>
								</td></tr>
								
								<tr>
									<td style="padding-left:20px; " align="center" class="tituloListas">N&uacute;mero</td>
									<td  width="2%">&nbsp;</td>
									<td class="tituloListas">Requisito</td>
									<td class="tituloListas" align="center">Obligatorio</td>
									<td class="tituloListas" align="center">Eliminar</td>
								</tr>
								
								<cfif lista.recordcount gt 0 >
									<cfset i = 1 >
										<cfloop query="lista">
											<form name="forml#pasos.currentrow##lista.currentrow#" method="post" style="margin:0;" action="requisitos_tramite-sql.cfm" >
												<input type="hidden" name="id_tramite" value="#form.id_tramite#" >
												<input type="hidden" name="tab" value="3" >
												<input type="hidden" name="id_paso" value="#pasos.id_paso#" >
												<input type="hidden" name="id_requisito" value="" >

												<tr style="cursor:pointer;" onMouseOver="javascript:this.className='listaParSel'" onMouseOut="this.className='<cfif i mod 2 >listaPar<cfelse>listaNon</cfif>'" class="<cfif i mod 2 >listaPar<cfelse>listaNon</cfif>">
													<td onClick="javascript:agregar(#lista.id_paso#, #lista.id_requisito#)" align="right" width="5%" style="padding-left:20px; " >#lista.numero_paso#</td>
													<td  width="2%">&nbsp;</td>
													<td onClick="javascript:agregar(#lista.id_paso#, #lista.id_requisito#)" >#lista.codigo_requisito# - #lista.nombre_requisito#</td>
													<td onClick="javascript:agregar(#lista.id_paso#, #lista.id_requisito#)" width="10%" align="center"><img border="0" title="<cfif lista.es_obligatorio eq 1>Es<cfelse>No es</cfif> obligatorio para completar el paso" src="<cfif lista.es_obligatorio eq 1>../images/checked.gif<cfelse>../images/unchecked.gif</cfif>"></td>
													<td width="10%" align="center"><input style="border:0 solid white " type="image" name="eliminar" src="../images/Borrar01_S.gif" title="Eliminar Requisito" onClick="javascript:return eliminar(#pasos.currentrow##lista.currentrow#, #lista.id_requisito#);"></td>
												</tr>
											</form>
											<cfset i = i+1 >
										</cfloop>
								<cfelse>
									<tr class="listaPar">
										<td colspan="5" style="padding-left:20px; ">No existen requisitos</td>
									</tr>
								</cfif>
							</cfloop>
							</cfoutput>
							<tr><td></td></tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<cfoutput>
<script type="text/javascript" language="javascript1.2">
	var popUpWinAgregar=0;
	function popUpWindowAgregar(URLStr, left, top, width, height){
		if(popUpWinAgregar) {
			if(!popUpWinAgregar.closed) popUpWinAgregar.close();
		}
		popUpWinAgregar = open(URLStr, 'popUpWinAgregar', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function agregar(paso, requisito){
		var params ="";
		<cfoutput>
		params = "?id_tramite=#form.id_tramite#&id_paso="+paso;
		</cfoutput>
		
		params = ( requisito != 0 ) ? (params+'&id_requisito='+requisito) : params;
		
		popUpWindowAgregar("/cfmx/home/tramites/Catalogos/trabajar-requisito.cfm"+params,250,200,650,450);
	}
	
	function validar(){
		var msj = '';
		
		if( document.form1.numero_paso.value == '' ){
			msj += ' - El campo Número de Paso es requerido.\n';
		}
		if( isNaN(document.form1.numero_paso.value) ){
			msj += ' - El campo Número de Paso debe ser numérico.\n';
		}
		if( document.form1.nombre_paso.value == '' ){
			msj += ' - El campo Nombre de Paso es requerido.\n';
		}
		if ( msj != '' ){
			alert('Se presentaron los siguientes errores:\n' + msj);
			return false;
		}
		return true;
	}
	
	function modificar(id_paso, numero, nombre){
		document.form1.AgregarPaso.value = 'Modificar Paso';
		document.form1.id_paso.value = id_paso;
		document.form1.numero_paso.value = numero;
		document.form1.nombre_paso.value = nombre;
	}

	function limpiar(){
		document.form1.AgregarPaso.value = 'Agregar Paso';
		document.form1.id_paso.value = '';
		document.form1.numero_paso.value = '';
		document.form1.nombre_paso.value = '';
	}

	function eliminar(indice, id){
		var f = eval('document.forml'+indice);
		if ( confirm('Desea eliminar el registro?') ){
			f.id_requisito.value = id;
			return true;
		}
		return false;
	}

	function eliminar_paso(indice, id){
		var f = eval('document.formp'+indice);
		if ( confirm('Desea eliminar el paso?') ){
			f.id_paso.value = id;
			return true;
		}
		return false;
	}
</script>

<form name="form3" method="post" style="margin:0;" action="tramites.cfm">
	<input type="hidden" name="id_tramite" value="#form.id_tramite#" >
	<input type="hidden" name="tab" value="3" >
</form>
</cfoutput>