<!-- Establecimiento del modo -->
<cfif isdefined('form.RHTid') and form.RHTid GT 0>
	<cfset form.modo = 'CAMBIO'>
</cfif>
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

<cfif modo neq 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
		select RHTid, RHTcodigo, RHTdesc, RHTpaga, RHTpfijo, 
		       RHTpmax, RHTcomportam, RHTposterior, RHTautogestion, RHTindefinido, 
			   RHTctiponomina, RHTcregimenv, RHTcoficina, RHTcdepto, RHTcplaza, RHTcpuesto, 
			   RHTccomp, RHTcsalariofijo, RHTcjornada, RHTvisible, RHTccatpaso, RHTcempresa, 
			   RHTidtramite, RHTnorenta, RHTnocargas, RHTnodeducciones, RHTcuentac, RHTnoretroactiva, 
			   RHTcantdiascont, CIncidente1, CIncidente2, RHTliquidatotal, RHTnocargasley, ts_rversion,
			   RHTdatoinforme, RHTpension, RHTnoveriplaza, RHTalerta, coalesce(RHTdiasalerta, 0) as RHTdiasalerta,
			   RHTtiponomb,RHTafectafantig,RHTafectafvac
		from RHTipoAccion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTid#">
	</cfquery>
</cfif>

<cfquery name="rsCodigos" datasource="#session.DSN#">
	select rtrim(RHTcodigo) as RHTcodigo
	from RHTipoAccion
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif modo neq 'ALTA'>
		and RHTid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTid#">
	</cfif>
</cfquery>

<cfinvoke component="sif.Componentes.Workflow.plantillas" method="CrearPkg" returnvariable="WfPackage">
	<cfinvokeargument name="PackageBaseName" value="RH" />
</cfinvoke>

<cfquery name="rsProcesos" datasource="#Session.DSN#">
	select ProcessId, Name, upper(Name) as upper_name, PublicationStatus
	from WfProcess
	where WfProcess.Ecodigo = #session.Ecodigo#
	  and (PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#WfPackage.PackageId#">
	       and PublicationStatus = 'RELEASED'
	<cfif IsDefined('rsForm') and Len(rsForm.RHTidtramite)>
	or ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.RHTidtramite#">
	</cfif>)
	order by upper_name
</cfquery>

<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>

<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_MESAJEERROR1"
	Default="El Código de Acción ya existe."
	returnvariable="LB_MESAJEERROR1"/>
	
	function codigos(obj){
		if (obj.value != "") {
			var empresa = <cfoutput>#session.Ecodigo#</cfoutput>
			var dato    = obj.value + "|" + empresa;
			var temp    = new String();
	
			<cfloop query="rsCodigos">
				temp = '<cfoutput>#rsCodigos.RHTcodigo#</cfoutput>' + "|" + empresa
				if (dato == temp){
					alert('<cfoutput>#LB_MESAJEERROR1#</cfoutput>');
					obj.value = "";
					obj.focus();
					return false;
				}
			</cfloop>
		}	
		return true;
	}
	

	function validar(f) {
		return true;
	}
	


	


	

	
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	function deshabilitarValidacion(){
		objForm.RHTcodigo.required = false;
		objForm.RHTdesc.required = false;
	}
	
	function fm_2(campo,ndec){
		var s = "";
		if (campo.name){
			s=campo.value
		}	
		else{
			s=campo
		}	
	 
		if( s=='' && ndec>0 ){
			s='0'
		}	
	 
	   var nc=""
	   var s1=""
	   var s2=""
	
		if (s != '') {
			str = new String("")
			str_temp = new String(s)
			t1 = str_temp.length
			cero_izq = false
	
			if (t1 > 0) {
				for(i=0;i<t1;i++) {
					c = str_temp.charAt(i)
					str += c
				}
			}
	
			t1 = str.length
			p1 = str.indexOf(".")
			p2 = str.lastIndexOf(".")
		  
			if ((p1 == p2) && t1 > 0){
	
				if (p1>0){
					str+="00000000"
				}	
				else{
					str+=".0000000"
				}	
	
				p1 = str.indexOf(".")
				s1 = str.substring(0,p1)
				s2 = str.substring(p1+1,p1+1+ndec)
				t1 = s1.length
				n = 0
	
				for(i=t1-1;i>=0;i--) {
					c=s1.charAt(i)
					if (c == ".") { flag=0;nc="."+nc;n=0 }
					
					if (c>="0" && c<="9") {
					if (n < 2) {
					   nc = c+nc;
					   n++;
					}
					else {
						n=0
						nc=c+nc
						if (i > 0){
							nc = nc
						 } 
					}
				}
			}
			if (nc != "" && ndec > 0)
				nc+="."+s2
			}
			else {ok=1}
		}
	   
		if(campo.name) {
			if(ndec>0) {
				campo.value=nc
			}
			else {
				campo.value=qf(nc)
			}
		}
		else {
			return nc
		}
	}
	
	function snumber_2(obj,e,d){
		str= new String("")
		str= obj.value
		var tam=obj.size
		var t=Key(e)
		var ok=false
		
		if(tam>d) {tam=tam-d}
		if(tam>1) {tam=tam-1}
		 
		if(t==9 || t==8 || t==13 || t==20 || t==27 || t==45 || t==46)  return true;
		
		// acepta guiones
		//if(t==109 || t==189)  return true;
	
		if(t>=16 && t<=20) return false;
		if(t>=33 && t<=40) return false;
		if(t>=112 && t<=123) return false;
		if(!ints(str,tam)) obj.value=str.substring(0,str.length-1)
		if(!decimals(str,d)) obj.value=str.substring(0,str.length-1)
		 
		if(t>=48 && t<=57)  ok=true
		if(t>=96 && t<=105) ok=true
		//if(d>=0) {if(t==188) ok=true} //LA COMA
		 
		if(d>0)
		{
		if(t==110) ok=true
		if(t==190) ok=true
		}
		 
		if(!ok){    
			str=fm_2(str,d)
			obj.value=str
		}
		
		return true
	}

	function goTipo(f) {
		location.href =  "TipoAccionUsuario.cfm<cfif isdefined("form.RHTid")>?RHTid=<cfoutput>#form.RHTid#</cfoutput></cfif>&especial=S";
	}



</script>

<cfset pagina = 1 >
<cfif isdefined("form.pagenum")>
	<cfset pagina = form.pagenum >
<cfelseif isdefined("url.PageNum_Lista") and not isdefined("form.nuevo")>
	<cfset pagina = url.PageNum_Lista >
</cfif>
<form name="form1" method="post" action="SQLTipoAccionSP.cfm">
	<input type="hidden" name="pagina" value="<cfoutput>#pagina#</cfoutput>">

	<cfset ts = "">	
	<cfif modo neq "ALTA">
		<cfinvoke 
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
		</cfinvoke>
	</cfif>
	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
  <cfoutput>
    
  <table width="100%" border="0" cellpadding="1" cellspacing="0">
    <tr> 
      <td colspan="4" align="center" class="tituloAlterno"> 
	  	  <cfif modo NEQ 'ALTA'>
	  		<cf_translate key="LB_Tcambio">Modificaci&oacute;n de Tipo de Acci&oacute;n Especial</cf_translate>
          <cfelse>
            <cf_translate key="LB_Tnuevo">Nuevo Tipo de Acci&oacute;n Especial</cf_translate>
		  </cfif> </td>
    </tr>
    
	<tr> 
      <td width="33%" align="right">#LB_CODIGO#:&nbsp;</td>
      <td colspan="3">
			<input name="RHTcodigo" type="text" value="<cfif modo neq 'ALTA'>#HTMLEditFormat(trim(rsForm.RHTcodigo))#</cfif>" size="5" maxlength="3" onblur="javascript:codigos(this);" onfocus="javascript:this.select();" alt="El C&oacute;digo de Acci&oacute;n" > 
			<cfif modo neq 'ALTA'>
				<input type="hidden" name="RHTid" value="#rsForm.RHTid#" >
			</cfif> 
	  </td>
	</tr>
	
	<tr>
      <td align="right"><cf_translate key="LB_Comportamiento">Comportamiento</cf_translate>:&nbsp;</td>
     	<td width="30%">
	  		<select name="RHTcomportam" >
			  	<option value="10" <cfif modo neq 'ALTA' and rsForm.RHTcomportam eq 10 >selected</cfif> ><cf_translate key="LB_RHTcomportam10">Anotaci&oacute;n</cf_translate></option>
			  	<option value="11" <cfif modo neq 'ALTA' and rsForm.RHTcomportam eq 11 >selected</cfif> ><cf_translate key="LB_RHTcomportam11">Antig&uuml;edad</cf_translate></option>
				<option value="14" <cfif modo neq 'ALTA' and rsForm.RHTcomportam eq 14 >selected</cfif> ><cf_translate key="LB_RHTcomportam14">Cambio de Puesto</cf_translate></option>
			</select>
	  </td>
	</tr>
	
	<tr>
      <td align="right"><cf_translate XmlFile="/rh/generales.xml" key="LB_TRAMITE">Tr&aacute;mite</cf_translate>:&nbsp;</td>
      <td colspan="3">   	   

	  
			<select name="RHTidtramite">
				<option value="N"> -- <cf_translate key="LB_Ninguno">Ninguno</cf_translate> -- </option>
				<cfloop query="rsProcesos">
					<option value="#rsProcesos.ProcessId#" <cfif modo NEQ 'ALTA' and isdefined('rsForm') and rsForm.RHTidtramite EQ rsProcesos.ProcessId> selected</cfif>>#rsProcesos.Name#
					<cfif rsProcesos.PublicationStatus neq 'RELEASED'> (#rsProcesos.PublicationStatus#)</cfif>
					</option>
				</cfloop>
			</select>
	  </td>
    </tr>
    <tr> 
      <td align="right">#LB_DESCRIPCION#:&nbsp;</td>
      <td colspan="3"> <input name="RHTdesc" type="text" value="<cfif modo neq 'ALTA'>#HTMLEditFormat(rsForm.RHTdesc)#</cfif>" size="35" maxlength="60" onFocus="javascript:this.select();" alt="La Descripci&oacute;n" ></td>
    </tr>

	<!--- <tr>
		<td align="right" nowrap><cf_translate key="LB_OBJGASTO">Objeto de Gasto</cf_translate>:&nbsp;</td>
		<td colspan="3">
			<input name="RHTcuentac" type="text" value="<cfif modo NEQ "ALTA">#trim(rsForm.RHTcuentac)#</cfif>" size="50" maxlength="100" style="text-align:left" onkeyup="if(snumber_2(this,event,0)){ if(Key(event)=='13') {this.blur();}}" onBlur="javascript:fm_2(this,0);" onFocus="javascript:this.select();"  >
		</td>
	</tr> --->

    <tr> 
      <td colspan="4" align="center">
	    <table width="90%" border="0" cellpadding="1" cellspacing="0" align="center">




          <tr> 
            <td align="right" nowrap><input type="checkbox" <cfif modo neq 'ALTA' and rsForm.RHTautogestion eq 1>checked</cfif> name="RHTautogestion" value="checkbox"></td>
            <td align="left" nowrap><cf_translate key="LB_INCLUIRAUTOGESTION">Incluir en Autogesti&oacute;n</cf_translate></td>
            <td nowrap align="right"><input type="checkbox" <cfif modo neq 'ALTA' and rsForm.RHTvisible eq 1 >checked</cfif> name="RHTvisible" value="checkbox"></td>
            <td align="left" nowrap><cf_translate key="LB_RHTvisible">Visible para Tr&aacute;mites de Empleado</cf_translate></td>
			<td nowrap>&nbsp;</td>
          </tr>
        </table>
		</td>
    </tr>
    <tr> 
      <td colspan="4" align="center">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="4" align="center"> 
	  	<cfinclude template="/rh/portlets/pBotones.cfm">
	  	<cfif modo neq "ALTA">
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Permisos"
			Default="Permisos"
			returnvariable="BTN_Permisos"/>
			<input type="button" name="TipoAccion" value="<cfoutput>#BTN_Permisos#</cfoutput>" onClick="javascript: goTipo(this.form);">	
		</cfif>
      </td>
    </tr>
    <tr> 
      <td colspan="4" align="center">&nbsp;</td>
    </tr>
    <tr> 
    </tr>
  </table>
  </cfoutput> 
</form>

<script language="JavaScript1.2" type="text/javascript">

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_MESAJEERROR4"
	Default="Código de Tipo de Acción"
	returnvariable="LB_MESAJEERROR4"/>	

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_MESAJEERROR5"
	Default="Descripción"
	returnvariable="LB_MESAJEERROR5"/>	

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.RHTcodigo.required = true;
	objForm.RHTcodigo.description="<cfoutput>#LB_MESAJEERROR4#</cfoutput>";

	objForm.RHTdesc.required = true;
	objForm.RHTdesc.description="<cfoutput>#LB_MESAJEERROR5#</cfoutput>";

</script>