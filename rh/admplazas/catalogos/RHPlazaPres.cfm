<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Plazas Presupuestarias'>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<cfif isdefined("url.RHPPid") and len(trim(url.RHPPid))>
	<cfset form.RHPPid = url.RHPPid>
</cfif>
<cfset modo = "ALTA">
<cfif isdefined("form.RHPPid") and len(trim(form.RHPPid))>
	<cfset modo = "CAMBIO">
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery datasource="#session.dsn#" name="data">
		select 	a.RHPPid, 
				a.RHPPcodigo, 
				a.RHPPdescripcion, 
				a.Complemento, 
				a.ts_rversion
		from  RHPlazaPresupuestaria a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPPid#"> 
	</cfquery>	
</cfif>

<script type="text/javascript" language="javascript1.2">
	function funcRegresar(){
		location.href = 'RHPlazaPres-lista.cfm';
	}
</script>
<cfoutput>

<script language="javascript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
<form action="RHPlazaPres-sql.cfm" method="post" name="form1" id="form1">
	<table width="100%" border="0" cellspacing="0">
		<tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
		<tr>
			<!----<td valign="top" width="55%">		
			</td>----->
			<td width="42%" align="right"><strong>C&oacute;digo:&nbsp;</strong></td>
			<td width="58%" valign="top"><input name="RHPPcodigo" size="10" id="RHPPcodigo" type="text" value="<cfif modo NEQ 'ALTA'>#trim(data.RHPPcodigo)#</cfif>" maxlength="10" onfocus="this.select()"></td>
		</tr>
		<tr>
			<td align="right"><strong>Descripci&oacute;n:&nbsp;</strong></td>
			<td>
				<input name="RHPPdescripcion" size="40" id="RHPPdescripcion" type="text" value="<cfif modo NEQ 'ALTA'>#trim(data.RHPPdescripcion)#</cfif>" maxlength="80" onfocus="this.select()">
			</td>
		</tr>
		
		<tr>
			<td align="right" nowrap><strong>Complemento:</strong>&nbsp;</td>
			<td colspan="3">
				<input name="complemento" type="text" value="<cfif modo NEQ "ALTA">#trim(data.Complemento)#</cfif>" size="50" maxlength="100" style="text-align:left" onkeyup="if(snumber_2(this,event,0)){ if(Key(event)=='13') {this.blur();}}" onBlur="javascript:fm_2(this,0);" onFocus="javascript:this.select();"  >
			</td>
		</tr>
		
		
		<!----<tr>
			<td align="right"><strong>Categor&iacute;a:&nbsp;</strong></td>
			<td>
				<cfset arrValuesCambio = ArrayNew(1)>
				<cfset filtro = "">
				<cfif modo NEQ 'ALTA'>
					<cfif len(trim(data.RHCid))>
						<cfset ArrayAppend(arrValuesCambio, data.RHCid)>
						<cfset ArrayAppend(arrValuesCambio, data.RHCcodigo)>
						<cfset ArrayAppend(arrValuesCambio, data.RHCdescripcion)>
					</cfif>
				</cfif>
				<cf_conlis 
					campos="RHCid,RHCcodigo,RHCdescripcion"
					size="0,10,40"
					desplegables="N,S,S"
					modificables="N,S,N"
					valuesArray="#arrValuesCambio#"
					title="Lista de Categor&iacute;as"
					tabla="RHCategoria"
					columnas="RHCid, RHCcodigo, RHCdescripcion"
					filtro="Ecodigo = #Session.Ecodigo# Order by RHCcodigo,RHCdescripcion"
					filtrar_por="RHCcodigo, RHCdescripcion"
					desplegar="RHCcodigo, RHCdescripcion"
					etiquetas="C&oacute;digo, Descripci&oacute;n"
					formatos="S,S"
					align="left,left"
					asignar="RHCid,RHCcodigo, RHCdescripcion"
					asignarFormatos="I,S,S"
					form="form1"
					showEmptyListMsg="true"
					EmptyListMsg=" --- No se encotraron registros --- "/>
			</td>------>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" class="formButtons" align="center">
				<cfif modo eq 'ALTA'>
					<input type="submit" name="Alta" value="Agregar" onClick="javascript: habilitarValidacion();">
					<input type="reset" name="Limpiar" value="Limpiar">
				<cfelse>
					<input type="submit" name="Cambio" value="Modificar" onClick="habilitarValidacion();">
					<input type="submit" name="Baja" value="Eliminar" onClick="if ( confirm('Desea eliminar el registro?') ){deshabilitarValidacion(); return true;} return false;">
					<input type="submit" name="Nuevo" value="Nuevo" onClick="deshabilitarValidacion();">
				</cfif>
				<input type="button" name="btn_regresar" value="Regresar" onClick="javascript: location.href='RHPlazaPres-lista.cfm';">
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</table>
	<cfif modo neq 'ALTA'>
		<input type="hidden" name="RHPPid" value="#data.RHPPid#">
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

	objForm.RHPPcodigo.required = true;
	objForm.RHPPcodigo.description="Código";				
	objForm.RHPPdescripcion.required= true;
	objForm.RHPPdescripcion.description="Descripción";	
	
	function habilitarValidacion(){
		objForm.RHPPcodigo.required = true;
		objForm.RHPPdescripcion.required = true;
	}

	function deshabilitarValidacion(){
		objForm.RHPPcodigo.required = false;
		objForm.RHPPdescripcion.required = false;
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
