<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_MaestroDePuestosPresupuestarios"
	Default="Maestro de Puestos Presupuestarios"
	returnvariable="LB_MaestroDePuestosPresupuestarios"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Codigo" Default="Código" XmlFile="/rh/generales.xml" returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripción" XmlFile="/rh/generales.xml" returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Modificar" Default="Modificar" XmlFile="/rh/generales.xml" returnvariable="BTN_Modificar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Eliminar" Default="Elininar" XmlFile="/rh/generales.xml" returnvariable="BTN_Eliminar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Nuevo" Default="Nuevo" XmlFile="/rh/generales.xml" returnvariable="BTN_Nuevo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Agregar" Default="Agregar" XmlFile="/rh/generales.xml" returnvariable="BTN_Agregar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Limpiar" Default="Limpiar" XmlFile="/rh/generales.xml" returnvariable="BTN_Limpiar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Regresar" Default="Regresar" XmlFile="/rh/generales.xml" returnvariable="BTN_Regresar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Complemento" Default="Complemento" XmlFile="/rh/generales.xml" returnvariable="LB_Complemento"/>


<cf_templateheader  template="#session.sitio.template#">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center">
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<cfif isdefined("url.RHMPPid") and len(trim(url.RHMPPid))>
	<cfset form.RHMPPid = url.RHMPPid>
</cfif>
<cfset modo = "ALTA">
<cfif isdefined("form.RHMPPid") and len(trim(form.RHMPPid))>
	<cfset modo = "CAMBIO">
</cfif>

<cfif modo neq 'ALTA'>
	<cf_translatedata name="validar" tabla="RHMaestroPuestoP" col="RHMPPdescripcion" filtro="RHMPPid = #form.RHMPPid#">
	<cf_translatedata name="get" tabla="RHMaestroPuestoP" col="RHMPPdescripcion" returnvariable="LvarRHMPPdescripcion">
	<cf_translatedata name="get" tabla="RHCategoria" col="RHCdescripcion" returnvariable="LvarRHCdescripcion">

	<cfquery datasource="#session.dsn#" name="data">
		select 	a.RHMPPid, a.RHMPPcodigo, #LvarRHMPPdescripcion# as RHMPPdescripcion,
				a.ts_rversion, a.RHCid,
				b.RHCcodigo, #LvarRHCdescripcion# as RHCdescripcion, a.Complemento 
		from  RHMaestroPuestoP a
			left outer join RHCategoria b
				on a.RHCid = b.RHCid
		where  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHMPPid#"> 
	</cfquery>	
</cfif>

<script type="text/javascript" language="javascript1.2">
	function funcRegresar(){
		location.href = 'RMaestroPuestoP-lista.cfm';
	}
</script>
<cfoutput>

<script language="javascript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
<form action="RHMaestroPuestoP-sql.cfm" method="post" name="form1" id="form1">
	<table width="100%" border="0" cellspacing="0">
		<tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
		<tr>
			<!----<td valign="top" width="55%">		
			</td>----->
			<td width="42%" align="right"><strong>#LB_Codigo#:&nbsp;</strong></td>
			<td width="58%" valign="top"><input name="RHMPPcodigo" size="10" id="RHMPPcodigo" type="text" value="<cfif modo NEQ 'ALTA'>#trim(data.RHMPPcodigo)#</cfif>" maxlength="10" onfocus="this.select()"></td>
		</tr>
		<tr>
			<td align="right"><strong>#LB_Descripcion#:&nbsp;</strong></td>
			<td>
				<input name="RHMPPdescripcion" size="40" id="RHMPPdescripcion" type="text" value="<cfif modo NEQ 'ALTA'>#trim(data.RHMPPdescripcion)#</cfif>" maxlength="80" onfocus="this.select()">
			</td>
		</tr>
		
		<tr>
			<td align="right" nowrap><strong>#LB_Complemento#:</strong>&nbsp;</td>
			<td colspan="3">
				<input name="complemento" type="text" value="<cfif modo NEQ "ALTA">#trim(data.Complemento)#</cfif>" size="50" maxlength="100" style="text-align:left" onkeyup="if(snumber_2(this,event,0)){ if(Key(event)=='13') {this.blur();}}" onBlur="javascript:fm_2(this,0);" onFocus="javascript:this.select();"  >
			</td>
		</tr>
		
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" class="formButtons" align="center">
				<cfif modo eq 'ALTA'>
					<input type="submit" name="Alta" value="#BTN_Agregar#" onClick="javascript: habilitarValidacion();">
					<input type="reset" name="Limpiar" value="#BTN_Limpiar#">
				<cfelse>
					<input type="submit" name="Cambio" value="#BTN_Modificar#" onClick="habilitarValidacion();">
					<input type="submit" name="Baja" value="#BTN_Eliminar#" onClick="deshabilitarValidacion(); return true;">
					<input type="submit" name="Nuevo" value="#BTN_Nuevo#" onClick="deshabilitarValidacion();">
				</cfif>
				<input type="button" name="btn_regresar" value="#BTN_Regresar#" onClick="javascript: location.href='RMaestroPuestoP-lista.cfm';">
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</table>
	<cfif modo neq 'ALTA'>
		<input type="hidden" name="RHMPPid" value="#data.RHMPPid#">
		<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
	</cfif>
</form>	
</cfoutput>
<script language="JavaScript" type="text/javascript">	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.RHMPPcodigo.required = true;
	objForm.RHMPPcodigo.description="Cdigo";				
	objForm.RHMPPdescripcion.required= true;
	objForm.RHMPPdescripcion.description="Descripcin";	
	
	function habilitarValidacion(){
		objForm.RHMPPcodigo.required = true;
		objForm.RHMPPdescripcion.required = true;
	}

	function deshabilitarValidacion(){
		objForm.RHMPPcodigo.required = false;
		objForm.RHMPPdescripcion.required = false;
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
</script>
<cf_web_portlet_end>
<cf_templatefooter>	
