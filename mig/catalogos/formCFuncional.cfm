<cfif isdefined('url.CFpk') and not isdefined('form.CFpk')>
	<cfparam name="form.CFpk" default="#url.CFpk#">
</cfif>

<cfif isdefined("Form.CFpk")>
	<cfset modo="CAMBIO">
<cfelseif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!--- Verifica integracion con RH --->
<cfquery name="rsIntegracion" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo=520
</cfquery>
<!--- Verifica si requiere del Centro Fu --->
<cfquery name="rsRequiereCF" datasource="#Session.DSN#">
	select Pvalor as RequiereCF
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Pcodigo = 400
</cfquery>
<cfif modo NEQ "ALTA">
	<cfquery name="rsForm" datasource="#Session.DSN#">
		select 
			<cf_dbfunction2 name="to_char" args="CFid" datasource="#session.dsn#"> as CFpk,	
			Ecodigo, 
			CFcodigo, 
			Dcodigo, 
			Ocodigo,
			CFcorporativo,
			<cf_dbfunction2 name="to_char" args="RHPid" datasource="#session.dsn#"> as RHPid,
			CFdescripcion, 
			<cf_dbfunction2 name="to_char" args="CFidresp" datasource="#session.dsn#"> as CFpkresp,			
			
			CFcuentaaf,
			CFcuentaaf as CFcuentaafform, 	--Formato de cta de activos
			'' as CFcuentaafdesc,			--Descripcion de cta de activos
			'' as CFcuentaafcuenta,			--Cuenta de cta de activos

			CFcuentaingreso, 
			CFcuentaingreso as CFINformato,
			'' as CFINdescripcion,

			CFcuentac, 
			CFcuentac as Cformato,
			'' as Cdescripcion,
			'' as Ccuenta,

			CFcuentainventario, 
			CFcuentainventario as CFCIformato,
			'' as CFCIdescripcion,

			CFcuentainversion, 
			CFcuentainversion as CFAFformato,
			'' as CFAFdescripcion,
			
			coalesce(CFuresponsable,0) as CFuresponsable,
			coalesce(CFcomprador,0) as CFcomprador,
			coalesce(CFautoccontrato,0) as CFautoccontrato,
			ts_rversion
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">		
	</cfquery>
	<cfquery name="rsFormING" datasource="#Session.DSN#">
		select CFcuentaingreso as CFcuentac,
			   CFcuentaingreso as Cformato,
			   '' as Cdescripcion,
			   '' as Ccuenta
		from CFuncional
		where Ecodigo  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">		
	</cfquery>		

	<cfquery name="rsFormCI" datasource="#Session.DSN#">
		select CFcuentainventario as CFcuentac, 
			   CFcuentainventario as Cformato,
			   '' as Cdescripcion,
			   '' as Ccuenta
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">		
	</cfquery>

	<cfquery name="rsFormAF" datasource="#Session.DSN#">
		select CFcuentainversion as CFcuentac,
			   CFcuentainversion as Cformato,
			   '' as Cdescripcion,
			   '' as Ccuenta
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">		
	</cfquery>
	
	<cfquery name="rsActivoFijo" datasource="#Session.DSN#">
		select CFcuentaaf as CFcuentac,
			   CFcuentaaf as Cformato,
			   '' as Cdescripcion,
			   '' as Ccuenta
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">		
	</cfquery>
	<cfquery name="rsRetiroG" datasource="#Session.DSN#">
		select CFcuentagastoretaf as CFcuentac,
			   CFcuentagastoretaf as Cformato,
			   '' as Cdescripcion,
			   '' as Ccuenta
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">		
	</cfquery>
	<cfquery name="rsRetiroI" datasource="#Session.DSN#">
		select CFcuentaingresoretaf as CFcuentac,
			   CFcuentaingresoretaf as Cformato,
			   '' as Cdescripcion,
			   '' as Ccuenta
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">		
	</cfquery>

	<!--- Crear los tres querys segun la cuenta, ajusta los alias y ya --->

	<cfquery name="rsNombreCMC" datasource="#Session.DSN#">
		select CMCnombre
		from CMCompradores
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CFcomprador#">
	</cfquery>
	
	<cfquery name="rsNombreCMC2" datasource="#Session.DSN#">
		select CMCnombre
		from CMCompradores
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CFautoccontrato#">
	</cfquery>
	
	<cfif rsForm.RecordCount GT 0 and len(trim(rsForm.CFpkresp)) GT 0>
		
		<cfquery name="rsNombreCF" datasource="#Session.DSN#">
			select CFid as CFpkresp, CFcodigo as CFcodigoresp, CFdescripcion as CFdescripcionresp from CFuncional 
			where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CFpkresp#">
		</cfquery>
		
		<cfset tieneJefe = true>		
	<cfelse>
		<cfset tieneJefe = false>
	</cfif>

	<!--- Verifica si hay plazas para este centro funcional --->	
	<cfquery name="rsPlazasCF" datasource="#Session.DSN#">
		select count(1) as valor 
		from RHPlazas p, LineaTiempo lt
		where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		  and p.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
		  and p.RHPid = lt.RHPid
		  and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">  between lt.LTdesde and lt.LThasta
	</cfquery>
	
	<cfif Len(Trim(rsForm.RHPid)) GT 0 >	
		<cfquery name="rsNombrePlazaResponsable" datasource="#Session.DSN#">
			select RHPcodigo, RHPdescripcion from RHPlazas 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			  and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.RHPid#">
		</cfquery>		
	</cfif>	
</cfif>

<!--- Departamentos--->
<cfquery name="rsDepartamentos" datasource="#session.DSN#">
	select Dcodigo, Ddescripcion
	from Departamentos
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Ddescripcion
</cfquery>

<!--- Oficinas --->
<cfquery name="rsOficinas" datasource="#session.DSN#">
	select Ocodigo, Odescripcion
	from Oficinas
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Odescripcion
</cfquery>


<script language="JavaScript1.2" >
var popUpWin=0; 
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function doConlisResponsables() {
		popUpWindow("/cfmx/rh/Utiles/ConlisCFuncional.cfm?form=form1&id=CFpkresp&name=CFpkrespnom",250,200,400,300);
	}

	function doConlisCompradores() {
		popUpWindow("ConlisCompradores.cfm?formulario=form1&CMCid=CFcomprador&desc=CMCnombre",250,200,600,500);
	}
	function doConlisCompradores2() {
		popUpWindow("ConlisCompradores.cfm?formulario=form1&CMCid=CFautoccontrato&desc=CMCnombre2",250,200,600,500);
	}

	var boton = "";
	function setBtn(button){
		boton = button.name;
	}
	
	function valida(form){
		var mensaje = "Se presentaron los siguientes errores:\n\n";
		var salir = false; 
		if ( boton != 'Eliminar' && boton != 'Nuevo' /*&& boton != 'btnRegresar'*/){
			if (!salir && form.CFcodigo.value == ""){
				mensaje = mensaje + "El código del centro funcional es requerido.\n";
				salir = true;
			}
		<cfif NOT (modo NEQ "ALTA" AND isdefined("rsCFraiz") and rsCFraiz.CFid EQ rsForm.CFpk)>
			if (!salir && form.CFpkresp.value == ""){
				mensaje = mensaje + "El centro funcional Responsable es requerido.\n";
				salir = true;								
			}
		</cfif>
			if (!salir && form.CFdescripcion.value == ""){
				mensaje = mensaje + "La descripción del centro funcional es requerida.\n";
				salir = true;								
			}
			if (!salir && form.Ocodigo.value == ""){
				mensaje = mensaje + "La oficina es requerida.\n";
				salir = true;
			}
			if (!salir && form.Dcodigo.value == ""){
				mensaje = mensaje + "El departamento es requerido.\n";
				salir = true;
			}

			if (salir) alert(mensaje);			
			return !salir;			
		}
		return true;
	}
	
</script>

<form action="SQLCFuncional.cfm" method="post" name="form1" onSubmit="javascript: return valida(this);">
  <cfoutput>			

<table border="0" cellspacing="0" cellpadding="1" width="100%">
			<tr> 
				<td><div align="right">C&oacute;digo:</div></td>
				<td nowrap>
					<input name="CFcodigo" type="text" id="CFcodigo" 
						value="<cfif modo NEQ "ALTA">#trim(rsForm.CFcodigo)#</cfif>" 
						size="12" maxlength="10" tabindex="1" onFocus="javascript:this.select();">
				</td>
				
			</tr>
			<tr>
				<td><div align="right">Oficina:</div></td>
				<td>
					<cfif modo NEQ "ALTA" and rsPlazasCF.valor GT 0>
						<cfset descripcion = "">
						<cfloop query="rsOficinas">
							 <cfif rsForm.Ocodigo EQ rsOficinas.Ocodigo ><cfset descripcion = rsOficinas.Odescripcion ></cfif>				 
						</cfloop>
						<input type="hidden" name="Ocodigo" value="#rsForm.Ocodigo#">
						<label>#descripcion#</label>									
					<cfelse>
						<select name="Ocodigo" tabindex="1" >
							<cfloop query="rsOficinas">
								<option value="#rsOficinas.Ocodigo#" <cfif modo neq 'ALTA' and (rsForm.Ocodigo eq rsOficinas.Ocodigo) >
										selected</cfif> >
									#rsOficinas.Odescripcion#
								</option>				
							</cfloop>
						</select>
					</cfif>	  	  	
				
				</td>
			</tr>
			
			<tr> 
				<td><div align="right">Descripci&oacute;n:</div></td>
				<td>
					<input name="CFdescripcion" type="text" id="CFdescripcion" 
						   value="<cfif modo NEQ "ALTA">#rsForm.CFdescripcion#</cfif>" size="40" maxlength="60" tabindex="1" 
						   onFocus="javascript:this.select();">          
					<input type="hidden" name="CFpk" value="<cfif modo NEQ "ALTA">#rsForm.CFpk#</cfif>">
				</td>
			</tr>
			
			<tr>
			<td><div align="right">Departamento:</div></td>
				<td>
					<cfif modo NEQ "ALTA" and rsPlazasCF.valor GT 0>
						<cfset descripcion = "">
						<cfloop query="rsDepartamentos">
							 <cfif rsForm.Dcodigo EQ rsDepartamentos.Dcodigo ><cfset descripcion = rsDepartamentos.Ddescripcion ></cfif>				 				</cfloop>
						<input type="hidden" name="Dcodigo" value="#rsForm.Dcodigo#">
						<label>#descripcion#</label>														
					<cfelse>
						<select name="Dcodigo" tabindex="1">
							<cfloop query="rsDepartamentos">
								<option value="#rsDepartamentos.Dcodigo#" 
										<cfif modo neq 'ALTA' and (rsForm.Dcodigo eq rsDepartamentos.Dcodigo) >selected</cfif> >
									#rsDepartamentos.Ddescripcion#
								</option>
							</cfloop>		
						</select>
					</cfif>	
				</td>	
			</tr>
			<tr> 
				<td><div align="right">Centro responsable:</div></td>
				<td nowrap>    
				<!---
				  <input name="CFpkrespnom" type="text" value="<cfif modo NEQ "ALTA" and isDefined("rsNombreCF") >#rsNombreCF.CFdescripcion#</cfif>" id="CFpkrespnom" size="40" maxlength="80" readonly tabindex="1" onFocus="javascript:this.select();">
				  <a href="##" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Responsables" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisResponsables();"></a> 
				  <a href="##" tabindex="-1"><img src="/cfmx/rh/imagenes/delete.small.png" alt="Limpiar Responsable" name="imagenLimpiar" width="16" height="16" border="0" align="absmiddle" onClick="javascript: document.form1.CFpkresp.value = ''; document.form1.CFpkrespnom.value = '';"></a>        
				<input name="CFpkresp" type="hidden" id="CFpkresp" value="<cfif modo NEQ "ALTA">#rsForm.CFpkresp#</cfif>"> 
				--->
				
					<cfif modo NEQ "ALTA" AND isdefined("rsCFraiz") and rsCFraiz.CFid EQ rsForm.CFpk>
					PRIMER NIVEL <input type="hidden" name="CFpkresp" value="">
					<cfelseif modo neq 'ALTA' and tieneJefe>
						<cf_rhcfuncional form="form1" size="30" id="CFpkresp" name="CFcodigoresp" desc="CFdescripcionresp" 
							titulo="Seleccione el Centro Funcional Responsable" excluir="#Form.CFpk#" query="#rsNombreCF#" >
					<cfelseif modo neq 'ALTA'>
						<cf_rhcfuncional form="form1" size="30" id="CFpkresp" name="CFcodigoresp" desc="CFdescripcionresp" 
							titulo="Seleccione el Centro Funcional Responsable" excluir="#Form.CFpk#" >
					<cfelse>
						<cf_rhcfuncional form="form1" size="30" id="CFpkresp" name="CFcodigoresp" desc="CFdescripcionresp" 
						titulo="Seleccione el Centro Funcional Responsable" excluir="-1" >
					</cfif>		
					<input name="RHPid" type="hidden" id="RHPid" 
						   value="<cfif isDefined("Form.RHPid") and Len(Trim(rsForm.RHPid)) GT 0 >#rsForm.RHPid#</cfif>">
				</td>
				
			</tr>
			
			<tr><td><div align="right"><cfif modo NEQ "ALTA" and Len(Trim(rsForm.RHPid)) GT 0 >Plaza Responsable:</cfif></div></td>
				<td>
					<label>
						<cfif modo NEQ "ALTA" and Len(Trim(rsForm.RHPid)) GT 0 >
							#rsNombrePlazaResponsable.RHPcodigo# - #rsNombrePlazaResponsable.RHPdescripcion#
						</cfif>
					</label>
				</td>
			</tr>
			
			<tr> 
				<td  nowrap align="right" valign="middle" >Cuenta de Gasto:</td>
				<td>
					<cfif modo EQ "ALTA">
						<cf_cuentasanexo 
							auxiliares="S" 
							movimiento="N"
							conlis="S"
							ccuenta="Ccuenta" 
							cdescripcion="Cdescripcion" 
							cformato="Cformato" 
							conexion="#Session.DSN#"
							form="form1"
							frame="frCuentac"
							comodin="?">
					<cfelse>	
						<cf_cuentasanexo 
							auxiliares="S" 
							movimientos="N"
							conlis="S"
							ccuenta="Ccuenta" 
							cdescripcion="Cdescripcion" 
							cformato="Cformato" 
							conexion="#Session.DSN#"
							form="form1"
							frame="frCuentac"
							query="#rsForm#"
							comodin="?">
					</cfif>
				</td>
			</tr>
			<tr> 
				<td  nowrap align="right" valign="middle" >Cuenta de Inventario:</td>
				<td>
					<cfif modo EQ "ALTA">
						<cf_cuentasanexo 
							auxiliares="S" 
							movimiento="N"
							conlis="S"
							ccuenta="CFcuentainventario" 
							cdescripcion="CFCIdescripcion" 
							cformato="CFCIformato" 
							conexion="#Session.DSN#"
							form="form1"
							frame="frCuentaIV"
							comodin="?">
					<cfelse>	
						<cf_cuentasanexo 
							auxiliares="S" 
							movimiento="N"
							conlis="S"
							ccuenta="CFcuentainventario" 
							cdescripcion="CFCIdescripcion" 
							cformato="CFCIformato" 
							conexion="#Session.DSN#"
							form="form1"
							frame="frCFCI"
							query="#rsFormCI#"
							comodin="?">
					</cfif>
				</td>
			</tr> 

			<tr> 
				<td  nowrap align="right" valign="middle" >Cuenta de Inversi&oacute;n:</td>
				<td>
					<cfif modo EQ "ALTA">
						<cf_cuentasanexo 
							auxiliares="S" 
							movimiento="N"
							conlis="S"
							ccuenta="CFcuentainversion" 
							cdescripcion="CFAFdescripcion" 
							cformato="CFAFformato" 
							conexion="#Session.DSN#"
							form="form1"
							frame="frCuentaAF"
							comodin="?">
					<cfelse>	
						<cf_cuentasanexo 
							auxiliares="S" 
							movimiento="N"
							conlis="S"
							ccuenta="CFcuentainversion" 
							cdescripcion="CFAFdescripcion" 
							cformato="CFAFformato" 
							conexion="#Session.DSN#"
							form="form1"
							frame="frCuentaAF"
							query="#rsFormAF#"
							comodin="?">
					</cfif>
				</td>
			</tr> 
			<tr>
				<td  nowrap align="right" valign="middle" >Cuenta de Activos:</td>	
				<td>				
					<cfif modo EQ "ALTA">
						<cf_cuentasanexo 
							auxiliares="S" 
							movimiento="N"
							conlis="S"
							ccuenta="CFcuentaafcuenta" 
							cdescripcion="CFcuentaafdesc" 
							cformato="CFcuentaafform" 
							conexion="#Session.DSN#"
							form="form1"
							frame="frCuentaaf"
							comodin="?">
					<cfelse>	
						<cf_cuentasanexo 
							auxiliares="S" 
							movimientos="N"
							conlis="S"
							ccuenta="CFcuentaafcuenta" 
							cdescripcion="CFcuentaafdesc" 
							cformato="CFcuentaafform" 
							conexion="#Session.DSN#"
							form="form1"
							frame="frCuentaaf"
							query="#rsActivoFijo#"
							comodin="?">
					</cfif>
				</td>	
			</tr>
			<tr>
				<td  nowrap align="right" valign="middle" >Cuenta de Ingreso:</td>	
				<td>
					<cfif modo EQ "ALTA">
						<cf_cuentasanexo 
							auxiliares="S" 
							movimiento="N"
							conlis="S"
							ccuenta="CFcuentaingreso" 
							cdescripcion="CFINdescripcion" 
							cformato="CFINformato" 
							conexion="#Session.DSN#"
							form="form1"
							frame="frCuentaing"
							comodin="?">
					<cfelse>	
						<cf_cuentasanexo 
							auxiliares="S" 
							movimientos="N"
							conlis="S"
							ccuenta="CFcuentaingreso" 
							cdescripcion="CFINdescripcion" 
							cformato="CFINformato" 
							conexion="#Session.DSN#"
							form="form1"
							frame="frCuentaing"
							query="#rsFormING#"
							comodin="?">
					</cfif>
				</td>	
			</tr>								
			<cfif rsIntegracion.RecordCount gt 0 and rsIntegracion.Pvalor eq 'N'>
				<tr>
					<td nowrap align="right">Usuario responsable:</td>
					<td nowrap>
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td width="1%">
									<cfif modo neq 'ALTA'>
										<cf_sifusuarioe idusuario="#rsForm.CFuresponsable#" usucodigo="CFuresponsable" size="48">
									<cfelse>
										<cf_sifusuarioe usucodigo="CFuresponsable" size="48">
									</cfif>
								</td>
								<td>&nbsp;<img style="cursor:hand; " src="/cfmx/rh/imagenes/delete.small.png" 
										   alt="Limpiar Usuario Responsable" name="imagenLimpiarUR" width="16" height="16" 
										   border="0" align="absmiddle" 
										   onClick="javascript: document.form1.CFuresponsable.value = ''; document.form1.Nombre.value = '';">
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</cfif>
				
			<tr>
			<td align="right">Comprador:</td>
			<td nowrap>           
				<input name="CMCnombre" type="text" 
					   value="<cfif modo NEQ "ALTA" and isDefined("rsNombreCMC") >#rsNombreCMC.CMCnombre#</cfif>" 
					   id="CMCnombre" size="48" maxlength="80" readonly tabindex="1" onFocus="javascript:this.select();">
					<img src="/cfmx/rh/imagenes/Description.gif" style="cursor:hand;" alt="Lista de Compradores" name="imagen" width="18" 
						 height="14" border="0" align="absmiddle" onClick="javascript:doConlisCompradores();">
					<img src="/cfmx/rh/imagenes/delete.small.png" style="cursor:hand;" alt="Limpiar Comprador asignado" name="imagenLimpiarCE" 					 width="16" height="16" border="0" align="absmiddle" 
						 onClick="javascript: document.form1.CMCnombre.value = ''; document.form1.CFcomprador.value = '';">
				<input name="CFcomprador" type="hidden" id="CFcomprador" value="<cfif modo NEQ "ALTA">#rsForm.CFcomprador#</cfif>"> 
			</td>
			</tr>
			<!--- Valida que el parametro: "Multiples Contratos" en Parametros Adicionales
			en el modulo de Compras este activado--->
			<cfquery name="verifica_Parametro" datasource="#session.dsn#">
				select 1 from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Pcodigo = 730
				and Pvalor = '1'
			</cfquery>
			<cfif verifica_Parametro.recordcount GT 0 >
			<tr>
			  <td nowrap>Autorizador de OC de Contratos:</td>
			  <td>
			  	<input name="CMCnombre2" type="text" 
					   value="<cfif modo NEQ "ALTA" and isDefined("rsNombreCMC2") >#rsNombreCMC2.CMCnombre#</cfif>" 
					   id="CMCnombre2" size="48" maxlength="80" readonly tabindex="1" onFocus="javascript:this.select();">
					<img src="/cfmx/rh/imagenes/Description.gif" style="cursor:hand;" alt="Lista de Compradores" name="imagen" width="18" 
						 height="14" border="0" align="absmiddle" onClick="javascript:doConlisCompradores2();">
					<img src="/cfmx/rh/imagenes/delete.small.png" style="cursor:hand;" alt="Limpiar Comprador asignado" name="imagenLimpiarCE" 					 width="16" height="16" border="0" align="absmiddle" 
						 onClick="javascript: document.form1.CMCnombre2.value = ''; document.form1.CFautoccontrato.value = '';">
				<input name="CFautoccontrato" type="hidden" id="CFautoccontrato" value="<cfif modo NEQ "ALTA">#rsForm.CFautoccontrato#</cfif>"> 
				</td>
			</tr>
			</cfif>
						
			<tr>
			  <td><div align="right">Corporativo:</div></td>
			  <td><input type="checkbox" name="CFcorporativo" value="CFcorporativo" <cfif modo NEQ "ALTA" and rsForm.CFcorporativo>checked</cfif>></td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
		  </tr>
			<!--- *************************************************** --->
			<cfif modo NEQ 'ALTA'>
				<tr>
				  <td colspan="2" align="center" class="tituloListas">Complementos Contables</td>
				</tr>
				<tr><td colspan="2" align="center">
				<cf_sifcomplementofinanciero action='display'
						tabla="CFuncional"
						form = "form1"
						llave="#form.CFpk#" />	
				</td></tr>
			</cfif>	
			<!--- *************************************************** ---> 	
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr> 
				<td colspan="2"><div align="center"> 
					<cfif modo EQ "ALTA" or isDefined("Form.Nuevo")>
						<input type="submit" name="Alta" value="Agregar" onClick="javascript: setBtn(this);" tabindex="3">
						<input type="reset" name="Limpiar" value="Limpiar" onClick="javascript: setBtn(this);" tabindex="3">
					<cfelse>
						<input type="submit" name="Cambio" value="Modificar" tabindex="3"
							   onClick="javascript: setBtn(this);" >
						<input type="submit" name="Baja" value="Eliminar" tabindex="3" 
							   onClick="javascript: setBtn(this); return confirm('¿Desea eliminar este registro?');">
						<input type="submit" name="Nuevo" value="Nuevo" tabindex="3" onClick="javascript: setBtn(this);">
					</cfif></div>
				</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
		</table>
	
		<cfset ts = "">
		<cfif modo NEQ "ALTA">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
		</cfif>  
		<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>">
		
  </cfoutput>
</form>
	
	<script language="JavaScript1.2">
	<cfif modo NEQ 'CAMBIO'>
		document.form1.CFcodigo.focus();
	</cfif>
	</script>
