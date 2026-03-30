<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Calculo de una celda específica</title>
</head>

<body>

<cfparam name="form.Mcodigo" default="-1">
<cfparam name="form.ACmLocal" default="0">

<cfif isdefined("proceder")>

	<cfif form.ANubicaTipo EQ "GE">
		<cfset myEcodigo = -1>
		<cfset myOcodigo = -1>
		<cfset myGOid    = -1>
		<cfset myGEid    = form.ANubicaGEid>
	<cfelseif  form.ANubicaTipo EQ "E">
		<cfset myEcodigo = form.ANubicaEcodigo>
		<cfset myOcodigo = -1>
		<cfset myGOid    = -1>
		<cfset myGEid    = -1>
	<cfelseif  form.ANubicaTipo EQ "O">
		<cfset myEcodigo = form.ANubicaEcodigo>
		<cfset myOcodigo = form.ANubicaOcodigo>
		<cfset myGOid    = -1>
		<cfset myGEid    = -1>
	<cfelseif  form.ANubicaTipo EQ "GO">
		<cfset myEcodigo = form.ANubicaEcodigo>
		<cfset myOcodigo = -1>
		<cfset myGOid    = form.ANubicaGOid>
		<cfset myGEid    = -1>
	</cfif>

	<cfset ValordeCelda = structNew()>
	<cfset ValordeCelda.Monto = false>
	<cfset ValordeCelda.Valor = "">

	<cfparam name="form.ACmLocal" default="0">

	<cfinvoke component="sif.an.operacion.calculo.calculo" 
		method="calcularCeldaAnexo"
		returnvariable="ValordeCelda"
		DataSource="#session.dsn#" 
		AnexoCelId="#form.AnexoCelId#" 
		AnexoId = "#form.AnexoId#"
		ACano = "#form.ACano#"
		ACmes = "#form.ACmes#"
		ACunidad = "#form.ACunidad#"
		Mcodigo = "#form.Mcodigo#"
		ACmLocal = "#form.ACmLocal#"
		Ecodigo = "#myEcodigo#"
		Ocodigo = "#myOcodigo#"
		GEid = "#myGEid#"
		GOid = "#myGOid#"
		/>
		
	
	<table width="100%" border="0" align="center" cellpadding="2" cellspacing="2" class="ayuda">
	<tr>
		<td>
			<strong>Vista Previa del Cálculo del Rango <cfoutput>#Form.AnexoRan#</cfoutput>:</strong>
		</td>
	</tr>
	<tr> 
		<td height="87" align="center">
	
			<font size="+1">
		<cfoutput>
			<cfif ValordeCelda.Tipo EQ "M">
				<cfif form.ACunidad EQ 1000>
					#numberformat(ValordeCelda.Valor,",9.00000")# miles
				<cfelseif  form.ACunidad EQ 1e6>
					#numberformat(ValordeCelda.Valor,",9.00000000")# millones
				<cfelse>
					#numberformat(ValordeCelda.Valor,",9.00")#
				</cfif>
			<cfelse>
				#ValordeCelda.Valor#
			</cfif>
		</cfoutput>
			</font>
				
		</td>
	</tr>
	<tr>
		  <td colspan="2" align="center">
		  <input type="button" id="boton" style="width:70px; " name="Regresar" value="Regresar" 
		  			onClick="javascript:history.go(-1);">
		  <input type="button" id="boton" style="width:70px; " name="CerrarV" value="Cerrar" onClick="javascript:window.close();">
		  </td>
	</tr>	
	</table>			
					

<cfelse>


	<cfparam name="url.msg" default="">
	<cfparam name="url.AnexoId" default="">
	
	<!--- Obtiene el grupo al que pertenece el Anexo --->
	<cfquery name="rsAnexos" datasource="#session.DSN#">
	Select GAid
	from Anexo 
	where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoId#">
	</cfquery>
	
	<cfset VGAid = rsAnexos.GAid>
	
	
	<cfquery name="rsAnexos" datasource="#session.DSN#">
		<!--- buscar los anexos usando el cubo de grupos --->
		select ag.GAid, ag.GAnombre, a.AnexoId, a.AnexoDes, coalesce(a.AnexoSaldoConvertido,0) as TipoSaldo
		from AnexoGrupoCubo cubo
			join Anexo a
				on a.GAid = cubo.GAhijo
				and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	
			join AnexoPermisoDef pd
				on (pd.GAid = a.GAid or pd.AnexoId = a.AnexoId)
				and pd.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				and pd.APcalc = 1
				and pd.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				
			join AnexoGrupo ag
				on ag.GAid = a.GAid
	
			join AnexoEm ae
				on ae.AnexoId = a.AnexoId
				and ae.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	
		where cubo.GApadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VGAid#">
		  and ag.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		order by ag.GAruta, a.AnexoDes
	</cfquery>
	
	<cfquery name="rsACcel" datasource="#session.DSN#">
		select 	coalesce(Ecodigocel,-1) as Ecodigo,
				coalesce(Ocodigo,-1) 	as Ocodigo,
				coalesce(GEid,-1) 		as GEid,
				coalesce(GOid,-1) 		as GOid
		  from AnexoCel
		 where AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoCelId#">
	</cfquery>
	
	<cfquery name="monedas" datasource="#session.DSN#">
		select Mcodigo id, Mnombre as descripcion
		from Monedas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		order by Mnombre
	</cfquery>
	
	<cfquery name="mes" datasource="#session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Pcodigo = 60
	</cfquery>
	<cfparam name="url.ACmes" default="#mes.Pvalor#">
	<cfquery name="periodo" datasource="#session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Pcodigo = 50
	</cfquery>
	<cfparam name="url.ACano" default="#periodo.Pvalor#">
	<cfquery name="grupo" datasource="#session.DSN#">
		select GAcodigo, GAnombre
		from AnexoGrupo
		where GAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VGAid#">
	</cfquery>
	<script language="javascript1.2" type="text/javascript" src="../../../js/utilesMonto.js"></script>
	
	<script language="javascript1.2" type="text/javascript">
		function validar(formulario){
			var error_input;
			var error_msg = '';
	
			if (formulario.ACmes.value == "") {
				error_msg += "\n - El campo Mes es requerido.";
				error_input = formulario.ACmes;
			}
		
			if (formulario.ACano.value == "") {
				error_msg += "\n - El campo Año es requerido.";
				error_input = formulario.ACano;
			}
	
			if (formulario.ACunidad.value == "") {
				error_msg += "\n - El campo Unidades es requerido.";
				error_input = formulario.ACunidad;
			}
			
			
			// Validacion terminada
			if (error_msg.length != "") {
				alert("Se presentaron los siguientes errores:"+error_msg);
				error_input.focus();
				return false;
			}
			return true;
		}	
	</script>
	
	<form name="form1" method="post" action="CalculoCeldaPopup.cfm" onSubmit="javascript:return validar(this);">
	  <cfoutput>
		<input type="hidden" name="GAid" value="#HTMLEditFormat(VGAid)#">
	  </cfoutput>
	  <input type="hidden" name="proceder" value="1">
	  <table cellpadding="2" cellspacing="0" width="450" align="center" border="0">
		<tr>
			<td colspan="4" align="center">
			<strong>Defina los Valores de Cálculo</strong>
			</td>
		</tr>
		<tr><td colspan="4">&nbsp;</td></tr>
		<tr>
		  <td width="134" align="right" valign="top">Origen de Datos:&nbsp;</td>
		  <td width="306" colspan="3" valign="top">
				<cf_cboANubicacion
							Ecodigo="#rsACcel.Ecodigo#" 
							Ocodigo="#rsACcel.Ocodigo#" 
							GOid="#rsACcel.GOid#" 
							GEid="#rsACcel.GEid#" 
							modo="CAMBIO" tipo="CALCULOCELDA"
							propio="#rsACcel.Ecodigo+rsACcel.Ocodigo+rsACcel.GOid+rsACcel.GEid NEQ -4#"
							>
		  </TD>
		<tr>
			<td align="right" valign="top"><input type="checkbox" style="visibility:hidden">Movs. en Moneda:&nbsp;</td>
			<td colspan="3" valign="top" nowrap="nowrap">
			<cfif rsAnexos.TipoSaldo EQ 2>
				<input type="checkbox" style="visibility:hidden">
				<strong>El anexo es multi-monedas</strong>
			<cfelse>
				<select name="Mcodigo" style="width:200px" onChange="if(this.value==-1){this.form.ACmLocal.disabled=true;this.form.ACmLocal.checked=true;} else if (this.form.ACmLocal.disabled){this.form.ACmLocal.disabled=false;this.form.ACmLocal.checked=false;}">
					  <option value="-1" >-Movimientos en cualquier moneda-</option>
					  <cfoutput query="monedas">
						<option value="#monedas.id#" >#monedas.descripcion#</option>
					  </cfoutput>
				</select><input type="checkbox" name="ACmLocal" value="1" checked disabled>Expr. en Local
			</cfif>
			</td>
		</tr>
		<tr>
		  <td align="right" valign="top">Mes:&nbsp;</td>
		  <td colspan="3" valign="top"><select name="ACmes" style="width:120px">
			  <option value="" >-seleccionar-</option>
			  <option value="1" <cfif url.ACmes eq 1>selected</cfif> >Enero</option>
			  <option value="2" <cfif url.ACmes eq 2>selected</cfif>>Febrero</option>
			  <option value="3" <cfif url.ACmes eq 3>selected</cfif>>Marzo</option>
			  <option value="4" <cfif url.ACmes eq 4>selected</cfif>>Abril</option>
			  <option value="5" <cfif url.ACmes eq 5>selected</cfif>>Mayo</option>
			  <option value="6" <cfif url.ACmes eq 6>selected</cfif>>Junio</option>
			  <option value="7" <cfif url.ACmes eq 7>selected</cfif>>Julio</option>
			  <option value="8" <cfif url.ACmes eq 8>selected</cfif>>Agosto</option>
			  <option value="9" <cfif url.ACmes eq 9>selected</cfif>>Setiembre</option>
			  <option value="10" <cfif url.ACmes eq 10>selected</cfif>>Octubre</option>
			  <option value="11" <cfif url.ACmes eq 11>selected</cfif>>Noviembre</option>
			  <option value="12" <cfif url.ACmes eq 12>selected</cfif>>Diciembre</option>
			</select>
			<cfoutput>
			  <input name="ACano" value="#url.ACano#" size="5" maxlength="5" style="text-align: right;width:75px" 
					onBlur="javascript:fm(this,0);" onFocus="javascript:this.value=qf(this); this.select();"  
					onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" >
			</cfoutput> </td>
		</tr>
		<tr>
		  <td align="right" valign="top">Unidades:&nbsp;</td>
		  <td colspan="3" valign="top"><select name="ACunidad" style="width:200px">
			  <option value="1" >Monto en unidades</option>
			  <option value="1000" >Monto en miles</option>
			  <option value="1000000" >Monto en millones</option>
			</select>
		  </td>
		</tr>
		<tr>
		  <td colspan="4" align="center">&nbsp;</td>
		</tr>
		<tr>
		  <td colspan="2" align="center">
		  <input type="submit" id="boton" style="width:70px; " name="Calcular" value="Calcular" onClick="return fnANubicaVerifica();">
		  </td>
		  <td colspan="2" align="center">
		  <input type="button" id="boton" style="width:70px; " name="CerrarV" value="Cerrar" onClick="javascript:window.close();">
		  </td>
		</tr>
	  </table>
	  <cfoutput>
	  <input type="hidden" name="AnexoCelId" value="#url.AnexoCelId#">
	  <input type="hidden" name="AnexoId" value="#url.AnexoId#">
	  <input type="hidden" name="AnexoRan" value="#url.AnexoRan#">	  
	  </cfoutput>

	</form>
	
	<form name="form2" action="calcular-sql.cfm" style="margin:0;" method="post">
	  <input type="hidden" name="ACid" value="">
	  <cfoutput>
		<input type="hidden" name="GAid" value="#VGAid#">
	  </cfoutput>
	</form>


</cfif>
  
</body>
</html>
