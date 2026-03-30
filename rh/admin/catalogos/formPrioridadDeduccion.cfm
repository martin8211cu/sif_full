<cfif isdefined('url.modo') and not isdefined('form.modo')>
	<cfset form.modo = url.modo>
</cfif>
<cfif isdefined('url.RHPDid') and not isdefined('form.RHPDid')>
	<cfset form.RHPDid = url.RHPDid>
</cfif>

<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!--- Consultas --->
<cfif modo NEQ "ALTA">
	<!--- Form --->
	<cf_translatedata name="get" tabla="RHPrioridadDed" col="RHPDdescripcion" returnvariable="LvarRHPDdescripcion">
	<cfquery name="rsForm" datasource="#session.DSN#">
        select RHPDid, RHPDcodigo, Ecodigo, #LvarRHPDdescripcion# as RHPDdescripcion, RHPDorden,	RHPDordmonto, RHPDordfecha,ts_rversion
        from RHPrioridadDed
        where RHPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPDid#">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
</cfif>

<!--- registros existentes --->
<cf_translatedata name="get" tabla="RHPrioridadDed" col="RHPDdescripcion" returnvariable="LvarRHPDdescripcion">
<cfquery name="rsCodigos" datasource="#session.DSN#">
	select rtrim(#LvarRHPDdescripcion#) as RHPDdescripcion
	from RHPrioridadDed
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif modo neq 'ALTA'>
		and RHPDid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPDid#">
	</cfif>
</cfquery>


<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript1.2" type="text/javascript">	
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>
<style type="text/css">
<!--
.style1 {font-size: 9px}
-->
</style>
<cfif modo NEQ 'ALTA' and isdefined("rsForm.RHPDid")>
	<cf_translatedata name="validar" tabla="RHPrioridadDed" filtro="RHPDid = #rsForm.RHPDid#"/>
</cfif>
<form name="form1" method="post" action="SQLPrioridadDeduccion.cfm">
<cfif isdefined('PageNum')>
	<input name="PageNum" type="hidden" value="<cfoutput>#PageNum#</cfoutput>"/>
</cfif>
	<cfoutput>
		<table width="98%" border="0" cellspacing="0" cellpadding="2" align="center">

			<tr>
				<td align="right" width="22%">#LB_CodPrioridadDeDeduccion#:&nbsp;</td>
				<td>
					<input type="text" name="RHPDcodigo" value="<cfif modo NEQ 'ALTA'>#rsForm.RHPDcodigo#<cfelse></cfif>" size="10" maxlength="10" onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,0);"  onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;">
				</td>
			</tr>

			<tr>
				<td align="right" width="22%">#LB_DESCRIPCION#:&nbsp;</td>
				<td width="10%" >
					<input type="text" name="RHPDdescripcion" value="<cfif modo NEQ 'ALTA'>#rsForm.RHPDdescripcion#</cfif>" size="50" maxlength="20" onfocus="this.select();" >
				</td>
			</tr>
            
            <tr>
				<td align="right" width="22%">#LB_PrioridadDeDeduccion#:&nbsp;</td>
				<td>
					<input type="text" name="RHPDorden" value="<cfif modo NEQ 'ALTA'>#rsForm.RHPDorden#<cfelse></cfif>" size="10" maxlength="10" onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,0);"  onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;">
				</td>
			</tr>
			<tr>
				<td align="right" width="22%" valign="top">
			  <cf_translate  key="LB_Criterio">Criterio</cf_translate>:&nbsp;</td>
				<td>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td valign="middle">
								<input type="radio" name="RHPDcriterio" value="1" <cfif modo NEQ 'ALTA' and rsForm.RHPDordmonto EQ 1>checked</cfif>><cf_translate  key="RAD_MontoAscendente">Monto Ascendente</cf_translate> 
							</td>
							<td>
								<input type="radio" name="RHPDcriterio" value="2" <cfif (modo NEQ 'ALTA' and rsForm.RHPDordmonto EQ 2) or (modo EQ 'ALTA')>checked</cfif>><cf_translate  key="RAD_MontoDescendente">Monto Descendente</cf_translate>
							</td>
						</tr>
						<tr>
							<td>
								<input type="radio" name="RHPDcriterio" value="3" <cfif modo NEQ 'ALTA' and rsForm.RHPDordfecha EQ 1>checked</cfif>><cf_translate  key="RAD_FechaAscendente">Fecha Ascendente</cf_translate> 
							</td>
							<td>
								<input type="radio" name="RHPDcriterio" value="4" <cfif modo NEQ 'ALTA' and rsForm.RHPDordfecha EQ 2>checked</cfif>><cf_translate  key="RAD_FechaDescendente">Fecha Descendente</cf_translate>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr><td colspan="2"></td></tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr><td colspan="2" align="center">
			<cfset Lvar_Botones = ''>
            <cfif modo NEQ "ALTA">
                <cfset Lvar_Botones = Lvar_Botones>
            </cfif>
            <cf_botones modo='#modo#' include="#Lvar_Botones#">
			</td></tr>
			<tr>
			<td colspan="2" nowrap>
			<cf_web_portlet_start titulo="" border="true"  skin="info1">
				<strong><cf_translate  key="AYUDA_General_General"></cf_translate></strong>
				<cf_translate  key="AYUDA_PagoParcial"></cf_translate>
				<cf_translate  key="AYUDA_Criterio">  
				  <strong>Criterio</strong>
				  <br>
				  El criterio define el criterio por el cual será procesado la Prioridad de Deducción.
				  <br>
				</cf_translate>
				<ul>
					<li class="style1"><cf_translate  key="AYUDA_MontoAscendente"> <u>Monto Ascendente:</u> Los montos menores serán procesados primero</cf_translate>.</li>
				  	<br>
					<li class="style1"><cf_translate  key="AYUDA_MontoDescendente"><u>Monto Descendente:</u> Los montos mayores serán procesados primero.</cf_translate></li>
				  	<br>
					<li class="style1"><cf_translate  key="AYUDA_FechaAscendente"><u>Fecha Ascendente:</u> Se procesan primero las deducciones con menor fecha de inicio.</cf_translate></li>
				  	<br>
					<li class="style1"><cf_translate  key="AYUDA_FechaDescendente"><u>Fecha Descendente:</u> Se procesan primero las deducciones con mayor fecha de inicio.</cf_translate></li>
			  </ul></td>
			</tr>
		</table>
		
		<!--- OCULTOS --->
<input type="text" name="nada" value="" class="cajasinbordeb">
		<input type="hidden" name="RHPDid" value="<cfif modo NEQ 'ALTA'>#rsForm.RHPDid#</cfif>">
		
		<!--- ts_rversion --->
		<cfset ts = "">	
		<cfif modo neq "ALTA">
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'>#ts#</cfif>">					
	</cfoutput>
</form>

<script language="JavaScript1.2" type="text/javascript">

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Codigo"
	Default="Código"
	returnvariable="MSG_Codigo"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripción"
	returnvariable="MSG_Descripcion"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Prioridad"
	Default="Prioridad"
	returnvariable="MSG_Prioridad"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Criterio"
	Default="Criterio"
	returnvariable="MSG_Criterio"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_LaPrioridadYaExiste"
	Default="El Código de Tipo de Deducción ya existe"
	returnvariable="MSG_LaPrioridadYaExiste"/>	


<!---	objForm.TDcodigo.required = true;
	objForm.TDcodigo.description="<cfoutput>#MSG_Codigo#</cfoutput>";--->

	objForm.RHPDdescripcion.required = true;
	objForm.RHPDdescripcion.description="<cfoutput>#MSG_Descripcion#</cfoutput>";
	
	objForm.RHPDorden.required = true;
	objForm.RHPDorden.description = "<cfoutput>#MSG_Prioridad#</cfoutput>";

	objForm.RHPDcriterio.required = true;
	objForm.RHPDDcriterio.description = "<cfoutput>#MSG_Criterio#</cfoutput>";

	function deshabilitarValidacion(){
		objForm.TDcodigo.required      = false;
		objForm.RHPDdescripcion.required = false;
		objForm.RHPDorden.required = false;
		objForm.RHPDDcriterio.required = false;
	}
		

function limpiar(){
		document.form1.reset();
		}
	
	function codigos(obj){
		if (obj.value != "") {
			var empresa = <cfoutput>#session.Ecodigo#</cfoutput>
			var dato    = obj.value + "|" + empresa;
			var temp    = new String();

	
			<cfloop query="rsCodigos">
				temp = '<cfoutput>#rsCodigos.RHPDdescripcion#</cfoutput>' + "|" + empresa
				if (dato == temp){
					alert('<cfoutput>#MSG_LaPrioridadYaExiste#</cfoutput>');
					obj.value = "";
					obj.focus();
					return false;
				}
			</cfloop>
		}	
		return true;
	}

<!---function funcMarcar(LvarV){
	if (LvarV=1){
		document.form1.TDobligatoria.checked=true;
	}
	else{
		document.form1.TDobligatoria.checked=false;
	}
}--->
	function mover(llave,index,dir){
		var dummy = new Date().getTime();
		var index2 =  (dir == -1) ? index-1 : index+1;

		for (var i=0; i<=3; i++){
			var id1 = document.getElementById('a'+index+i);
			var id2 = document.getElementById('a'+index2+i);
			
			var temp = id1.innerHTML;
			id1.innerHTML = id2.innerHTML;
			id2.innerHTML = temp;
		}
		
		//cambia el valor de los objetos llaves
		var name1 = 'document.form1.RHPDid' + index;
		var name2 = 'document.form1.RHPDid' + index2;
		temp = eval(name1).value;

		eval(name1).value = eval(name2).value
		eval(name2).value = temp
		
		document.getElementById("updLista").src="/cfmx/rh/admin/catalogos/listaQuery.cfm?&llave1=" + eval(name1).value + "&llave2=" + eval(name2).value + "&dir="+dir+"&dummy="+dummy;
		return;
	}

</script>