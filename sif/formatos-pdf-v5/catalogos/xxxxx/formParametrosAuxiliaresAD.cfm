<cfset hayVencimiento1 = 0 >
<cfset hayVencimiento2 = 0 >
<cfset hayVencimiento3 = 0 >
<cfset hayVencimiento4 = 0 >
<cfset hayTipoRequisicion = 0 >
<cfset haySolicitante = 0 >
<cfset hayAutorizacion = 0 >
<cfset haycalculoImp = 0 >
<cfset haySupervisor = 0 >

 <!--- Obtiene los datos de la tabla de Parámetros según el pcodigo --->
<cffunction name="ObtenerDato" returntype="query">
	<cfargument name="pcodigo" type="numeric" required="true">	
	<cfquery name="rs" datasource="#Session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfreturn #rs#>
</cffunction>

<cfset definidos = ObtenerDato(5)>
<cfset existenParametrosDefinidos = false >
<cfif definidos.RecordCount GT 0 >
	<cfif definidos.Pvalor NEQ "N" >
		<cfset existenParametrosDefinidos = true >
	</cfif>
</cfif>
<cfset vencimiento = "">

<cfquery name="rsTipoRequisicion" datasource="#Session.DSN#">
	select Ecodigo, TRcodigo, TRdescripcion, timestamp from TRequisicion 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfset trequisicion = "">

<cfset solicitante = "">

<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>
<SCRIPT SRC="../../js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!--//
// specify the path where the "/qforms/" subfolder is located
qFormAPI.setLibraryPath("../../js/qForms/");
// loads all default libraries
qFormAPI.include("*");
//-->
</SCRIPT>

<script language="JavaScript1.2" >
		
	// valida los campos
	function valida() {
		<cfif not existenParametrosDefinidos >		
			alert('¡No están definidos los parámetros generales!');
			return false;
		</cfif>		
		return true;			
	}	

var popUpWin=0; 
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doSolicitantes() {
		popUpWindow("ConlisSolicitantesCM.cfm?form=form1&id=CMSid&nombre=CMSnombre",250,200,650,350);
	}

	function doSupervisor() {
		popUpWindow("ConlisUsuariosFA.cfm",250,200,650,350);
	}

</script>

<form action="SQLParametrosAuxiliaresAD.cfm" method="post" name="form1">
  <table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <cfset venc = ObtenerDato(310)>
      <cfif venc.RecordCount GT 0 >
        <cfset hayVencimiento1 = 1 >
        <cfset vencimiento = venc.Pvalor>
      </cfif>
      <td width="50%"><div align="right">1&ordm; Vencimiento:</div></td>
      <td width="50%"><input name="vencimiento1" alt="1º vencimiento" style="text-align:right" onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" onFocus="javascript:this.select();" onChange="javascript:fm(this,0);" type="text" value="<cfoutput>#vencimiento#</cfoutput>" size="4" maxlength="4">
        d&iacute;as </td>
    </tr>
    <tr> 
      <cfset venc = ObtenerDato(320)>
      <cfif venc.RecordCount GT 0 >
        <cfset hayVencimiento2 = 1 >
        <cfset vencimiento = venc.Pvalor>
      </cfif>
      <td><div align="right">2&ordm; Vencimiento:</div></td>
      <td><input name="vencimiento2" alt="2º vencimiento" style="text-align:right" onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" onFocus="javascript:this.select();" onChange="javascript:fm(this,0);" type="text" value="<cfoutput>#vencimiento#</cfoutput>" size="4" maxlength="4">
        d&iacute;as </td>
    </tr>
    <tr> 
      <cfset venc = ObtenerDato(330)>
      <cfif venc.RecordCount GT 0 >
        <cfset hayVencimiento3 = 1 >
        <cfset vencimiento = venc.Pvalor>
      </cfif>
      <td><div align="right">3&ordm; Vencimiento:</div></td>
      <td><input name="vencimiento3" alt="3º vencimiento" style="text-align:right" onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" onFocus="javascript:this.select();" onChange="javascript:fm(this,0);"  type="text" value="<cfoutput>#vencimiento#</cfoutput>" size="4" maxlength="4">
        d&iacute;as</td>
    </tr>
    <tr> 
      <cfset venc = ObtenerDato(340)>
      <cfif venc.RecordCount GT 0 >
        <cfset hayVencimiento4 = 1 >
        <cfset vencimiento = venc.Pvalor>
      </cfif>
      <td><div align="right">4&ordm; Vencimiento:</div></td>
      <td><input name="vencimiento4" alt="4º vencimiento" style="text-align:right" onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" onFocus="javascript:this.select();" onChange="javascript:fm(this,0);"  type="text" value="<cfoutput>#vencimiento#</cfoutput>" size="4" maxlength="4">
        d&iacute;as </td>
    </tr>
    <tr> 
      <cfset req = ObtenerDato(360)>
      <cfif req.RecordCount GT 0 >
        <cfset hayTipoRequisicion = 1 >
        <cfset trequisicion = req.Pvalor>
      </cfif>
      <td><div align="right">Tipo de Requisici&oacute;n Default:</div></td>
      <td>
	  	<select name="TipoRequisicion">	  
	  	<cfif rsTipoRequisicion.RecordCount EQ 0>
			<option value="-1"></option>
		</cfif>
	  	<cfoutput query="rsTipoRequisicion">
	        <option value="#rsTipoRequisicion.TRcodigo#" <cfif Compare(Trim(rsTipoRequisicion.TRcodigo),Trim(trequisicion)) EQ 0> selected </cfif> >#rsTipoRequisicion.TRdescripcion#</option>
        </cfoutput></select></td>
    </tr>
    <tr>
      <cfset solic = ObtenerDato(370)>
      <cfif solic.RecordCount GT 0 >
        <cfset haySolicitante = 1 >
        <cfset solicitante = solic.Pvalor>
		<cfif Len(Trim(solicitante)) GT 0>
			<cfquery name="rsSolicitante" datasource="#Session.DSN#">
				select CMSnombre from CMSolicitantes 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#solicitante#">
			</cfquery>
		</cfif>
      </cfif>
      <td><div align="right">Solicitante Default:</div></td>
      <td>
        <input name="CMSnombre" type="text" value="<cfif Len(Trim(solicitante)) GT 0><cfoutput>#rsSolicitante.CMSnombre#</cfoutput></cfif>" id="CMSnombre" size="40" maxlength="80" readonly tabindex="-1">
        <a href="#" tabindex="-1"><img src="../../Imagenes/Description.gif" alt="Lista de Solicitantes" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doSolicitantes();"></a> 
        <input name="CMSid" type="hidden" id="CMSid" value="<cfoutput>#solicitante#</cfoutput>"></td>
    </tr>

    <cfset aprobar = ObtenerDato(410)>
    <cfif aprobar.RecordCount GT 0 >
		<cfset hayAutorizacion = 1 >
		<cfset aprobacion = aprobar.Pvalor>
	<cfelse>
		<cfset aprobacion = '1' >
    </cfif>	
	<tr>
		<td align="right">Aprobar Solictudes de Compra:</td>		
		<td><input type="checkbox" name="chkAutorizar" <cfif aprobacion eq '1'>checked</cfif> ></td>
	</tr>

	<cfset calculo = ObtenerDato(420)>
	<cfif calculo.RecordCount GT 0 >
		<cfset haycalculoImp = 1 >
	</cfif>		
	<tr>
		<td align="right">Forma de Cálculo de Impuesto:</td>
		<td>
			<select name="CalculoImp">
				<option value="0" <cfif trim(calculo.Pvalor) eq 0 >selected</cfif> >Calcular Impuesto al Total</option>
				<option value="1" <cfif trim(calculo.Pvalor) eq 1 >selected</cfif> >Calcular Impuesto al SubTotal</option>
			</select>
		</td>
	</tr>
	
	<cfset rsSupervisor = ObtenerDato(430)>
	<cfif rsSupervisor.RecordCount GT 0 >
		<cfset haySupervisor = 1 >
		<cfset supervisor = rsSupervisor.Pvalor>
	<cfelse>	
		<cfset supervisor = '' >
	</cfif>
	<tr>
	  <td><div align="right">Supervisor de Cierre de Cajas:</div></td>
	  <td>
		<cfif Len(Trim(supervisor)) GT 0>
			<cfquery name="rsNombre" datasource="sdc">
				select Pnombre + ' ' + Papellido1 + ' ' + Papellido2 as Nombre  from Usuario
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#supervisor#">
			</cfquery>
			<cfset nombre = rsNombre.Nombre >
		<cfelse>
			<cfset nombre = '' >
		</cfif>
		<input name="FANombreSupervisor" type="text" value="<cfoutput>#nombre#</cfoutput>" id="FANombreSupervisor" size="40" maxlength="80" readonly tabindex="-1">
		<a href="#" tabindex="-1"><img src="../../Imagenes/Description.gif" alt="Lista de Usuarios de SIF" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doSupervisor();"></a>
		<input name="FASupervisor" type="hidden" id="FASupervisor" value="<cfoutput>#supervisor#</cfoutput>">
	  </td>
	</tr>
	
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>

    <tr> 
      <td colspan="2"><div align="center"> 
          <input type="submit" name="Aceptar" value="Aceptar" onClick="javascript: return valida();">		  		  
        </div></td>
    </tr>
  </table>

<!--- Variables para saber si hay que hacer un insert o un update en el .sql de cada uno de estos registros ---->
<cfif definidos.Recordcount GT 0 ><cfset hayParametrosDefinidos = 1 ></cfif>

<input type="hidden" name="hayVencimiento1" value="<cfoutput>#hayVencimiento1#</cfoutput>">
<input type="hidden" name="hayVencimiento2" value="<cfoutput>#hayVencimiento2#</cfoutput>">
<input type="hidden" name="hayVencimiento3" value="<cfoutput>#hayVencimiento3#</cfoutput>">
<input type="hidden" name="hayVencimiento4" value="<cfoutput>#hayVencimiento4#</cfoutput>">
<input type="hidden" name="hayTipoRequisicion" value="<cfoutput>#hayTipoRequisicion#</cfoutput>">
<input type="hidden" name="haySolicitante" value="<cfoutput>#haySolicitante#</cfoutput>">
<input type="hidden" name="hayAutorizacion" value="<cfoutput>#hayAutorizacion#</cfoutput>">
<input type="hidden" name="haycalculoImp" value="<cfoutput>#haycalculoImp#</cfoutput>">
<input type="hidden" name="haySupervisor" value="<cfoutput>#haySupervisor#</cfoutput>">
</form>

<SCRIPT LANGUAGE="JavaScript">
	<!--- valida que no sea cero --->
	function __isNotCero() {
		if (new Number(qf(this.value)) == 0) {
			this.error = "El campo " + this.description + " no puede ser cero!";
		}
	}

	_addValidator("isNotCero", __isNotCero);
	qFormAPI.errorColor = "#FFFF99";	

	objForm = new qForm("form1");
	
	// validación de campos requeridos
	objForm.vencimiento1.required = true;
	objForm.vencimiento1.description="1º Vencimiento";			
	objForm.vencimiento1.validateNotCero();
	objForm.vencimiento2.required = true;
	objForm.vencimiento2.description="2º Vencimiento";		
	objForm.vencimiento2.validateNotCero();
	objForm.vencimiento3.required = true;
	objForm.vencimiento3.description="3º Vencimiento";		
	objForm.vencimiento3.validateNotCero();
	objForm.vencimiento4.required = true;
	objForm.vencimiento4.description="4º Vencimiento";		
	objForm.vencimiento4.validateNotCero();

</SCRIPT>



