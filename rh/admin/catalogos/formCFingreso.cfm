<!--- Consultas --->
<!-- Establecimiento del modo -->
<cfif isdefined("form.CFCid2")>
	<cfset modo="CAMBIO_I">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA_I">
	<cfelseif form.modo EQ "CAMBIO_I">
		<cfset modo="CAMBIO_I">
	<cfelse>
		<cfset modo="ALTA_I">
	</cfif>
</cfif>
<cfquery name="rsFormS" datasource="#session.DSN#" maxrows="1">
	select  sum(CFCporc) as suma, CFCtipo, CFid
    from CfuncionalConc
    where Ecodigo = #session.Ecodigo#
    and CFid = #form.CFpk#
    and coalesce(CFCporc, 0) > 0
    group by CFCtipo, CFid
</cfquery>
<cfset valor = 0>
<cfif rsFormS.CFCtipo gt 0>
	<cfset valor = rsFormS.suma>
</cfif>

<cfif modo neq 'ALTA_I'>
	<!--- Form --->
	<cfquery name="rsFormIng" datasource="#session.DSN#">
		select c.Ccodigo, c.Cdescripcion, c.Cporc, c.Cid, cfc.CFid, cfc.ts_rversion, cfc.CFCid, cfc.CFCid_Costo,
		cfc.CFCporc, cfc.CFCtipo, cfc.CFidD
		from CfuncionalConc cfc
        inner join Conceptos c
        on c.Cid = cfc.Cid
            and c.Ecodigo = cfc.Ecodigo
		where cfc.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and cfc.CFid = (select CFid from CFuncional where CFcodigo ='#form.CFcodigo#' and Ecodigo=#session.Ecodigo#)
			and cfc.CFCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFCid2#">
	</cfquery>
    <cfset valor = valor - rsFormIng.CFCporc>
</cfif>
<cfset filtro = "">
<cfif modo eq 'ALTA_I'>
<cfset filtro = "">
</cfif>

<cfset filtroI = "and not exists (select 1 from CfuncionalConc cfco
								where cfco.CFCid_Costo = c.Cid 
								and cfco.CFid = #LvarCFid#
								and Ecodigo = #session.Ecodigo#)">

<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<form name="formIngreso" method="post" action="SQLCFuncional.cfm">
  <cfoutput>
  <table width="100%" border="0" cellspacing="1" cellpadding="0">
    <tr> 
      <td style="padding-left: 10px;">&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td>&nbsp;</td> 	
      <td><strong><cf_translate XmlFile="/rh/generales.xml" key="LB_INGRESO">Ingreso</cf_translate>:</strong>&nbsp;</td>
      <td>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_TITULOCONLIS"
			Default="Lista de Ingresos"
			returnvariable="LB_TITULOCONLIS"/>	

			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_CODIGO"
			Default="Codigo"
			returnvariable="LB_CODIGO"/>	
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_CONCEPTO"
			Default="Concepto"
			returnvariable="LB_CONCEPTO"/>	
            
            <cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_PORCENTAJE"
			Default="Porcentaje"
			returnvariable="LB_PORCENTAJE"/>
            <cfset ValuesArray2=ArrayNew(1)>
			<cfif (modo neq "ALTA_I")>
                <cfset ArrayAppend(ValuesArray2,rsFormIng.Ccodigo)>
                <cfset ArrayAppend(ValuesArray2,rsFormIng.Cdescripcion)>
                <cfset ArrayAppend(ValuesArray2,rsFormIng.Cid)>
            </cfif>		
			<cf_conlis title="#LB_TITULOCONLIS#"
            campos = "Ccodigo2, Cdescripcion2, Cid2, Cporc2" 
            ValuesArray="#ValuesArray2#"
            desplegables = "S,S,N,N" 
            modificables = "N,N,N,N" 
            size = "10,30,0"
            asignar="Ccodigo2, Cdescripcion2, Cid2, Cporc2"
            asignarformatos="S,S,S"
            tabla="Conceptos c"																	
            columnas="c.Ccodigo as Ccodigo2, c.Cdescripcion as Cdescripcion2, c.Cid as Cid2, c.Cporc as Cporc2"
            filtro="c.Ecodigo = #session.Ecodigo#
					    and c.Ctipo = 'I'
					  	#filtro#"
            filtrar_por="Ccodigo, Cdescripcion"            
            desplegar="Ccodigo2, Cdescripcion2"
            etiquetas="#LB_CODIGO#, #LB_CONCEPTO#"
            formatos="S,S,V"
            align="left,left,left"
            showEmptyListMsg="true"
            form="formIngreso"
            width="800"
            height="500"
         	>
	  </td>
    </tr>
    <tr>
    	<td>&nbsp;</td>
    	<td><strong>Porcentaje Total:&nbsp;</strong></td>
        <td><input type="checkbox" name="CFCtipo" onClick="javascript: cambioCosto(); limpiarDetalle();" 
		<cfif rsFormS.recordcount gt 0>disabled</cfif>
        <cfif (modo NEQ 'ALTA_I' and rsFormIng.CFCtipo gt 0) or rsFormS.CFCtipo gt 0>checked</cfif>
        />
        <input type="hidden" id="CFCtipoR" name="CFCtipoR" value="<cfoutput>#rsFormS.CFCtipo#</cfoutput>"/>
        </td>
    </tr>
    <tr>
    	<td>&nbsp;</td>
    	<td><strong>Porcentaje:&nbsp;</strong></td>
        <td><input type="text" name="CFCporc" id="CFCporc" size="7" maxlength="9" value="<cfif modo NEQ 'ALTA_I'><cfoutput>#rsFormIng.CFCporc#</cfoutput></cfif>"
        					onBlur="javascript:fm(this,2); _mayor(this.value);"  onFocus="javascript:this.value=qf(this); this.select();"  
                            onKeyUp="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
                            alt="Porcentaje"/></td>
    </tr>
    <tr id="cos" <cfif (modo neq "ALTA_I" and rsFormIng.CFCtipo gt 0) or rsFormS.CFCtipo gt 0> style="visibility:hidden; position:absolute;" </cfif>> 
      <cfif isdefined ('form.CFcodigo') and len(trim(form.CFcodigo)) gt 0>
		<cfquery name="rsCFid" datasource="#session.dsn#">
			select CFid from CFuncional where CFcodigo='#form.CFcodigo#' and Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfif rsCFid.recordcount gt 0>
			<input type="hidden" name="CFid" value="#rsCFid.CFid#" />
			<cfset LvarCFid=#rsCFid.CFid#>
		</cfif>
	  </cfif>	
      <td>&nbsp;</td> 	
      
      <td id="costo"><strong><cf_translate XmlFile="/rh/generales.xml" key="LB_COSTO">Costo</cf_translate>:</strong>&nbsp;</td>
      <td id="costo2">
      		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_TITULOCONLIS2"
			Default="Lista de Costos"
			returnvariable="LB_TITULOCONLIS2"/>	
			<cfset ValuesArray3 = ArrayNew(1)>
			<cfif (modo neq "ALTA_I") and rsFormIng.CFCtipo eq 0>
            <cfquery name="rsFormCo" datasource="#session.DSN#">
                select c.Ccodigo, c.Cdescripcion, c.Cid, cfc.CFCid, cfc.ts_rversion
                from CfuncionalConc cfc
                inner join Conceptos c
                on c.Cid = cfc.Cid
                    and c.Ecodigo = cfc.Ecodigo
                where cfc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                    and cfc.CFid  = (select CFid from CFuncional where CFcodigo ='#form.CFcodigo#' and Ecodigo=#session.Ecodigo#)
                    and cfc.CFCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormIng.CFCid_Costo#">
            </cfquery>
            	<cfset ArrayAppend(ValuesArray3,rsFormCo.Ccodigo)>
                <cfset ArrayAppend(ValuesArray3,rsFormCo.Cdescripcion)>
                <cfset ArrayAppend(ValuesArray3,rsFormCo.CFCid)>
            </cfif>	
            <cf_conlis title="#LB_TITULOCONLIS2#"
            campos = "Ccodigo3, Cdescripcion3, CFCid3" 
            ValuesArray="#ValuesArray3#"
            desplegables = "S,S,N" 
            modificables = "N,N,N" 
            size = "10,30,0"
            asignar="Ccodigo3, Cdescripcion3, CFCid3"
            asignarformatos="S,S,S"
            tabla="CfuncionalConc cf 
            	   inner join Conceptos c
                   on c.Cid = cf.Cid
                   and c.Ecodigo = cf.Ecodigo"																	
            columnas="c.Ccodigo as Ccodigo3, c.Cdescripcion as Cdescripcion3, cf.CFCid as CFCid3"
            filtro="cf.Ecodigo  = #session.Ecodigo#
					and c.Ctipo = 'G'
                    and cf.CFid = #LvarCFid#
                    #filtroI#"
            filtrar_por="Ccodigo, Cdescripcion"  
            desplegar="Ccodigo3, Cdescripcion3"
            etiquetas="#LB_CODIGO#, #LB_CONCEPTO#"
            formatos="S,S"
            align="left,left"
            showEmptyListMsg="true"
            form="formIngreso"
            width="800"
            height="500"
         	>
	  </td>
      
    </tr>
    <tr>
    	<td>&nbsp;</td>
    	<td><strong>Centro Funcional Destino:&nbsp;</strong></td>
    	<td>
        	<cfset valuesArraySN = ArrayNew(1)>
			<cfif isdefined("rsFormIng.CFidD") and len(trim(rsFormIng.CFidD))>
                <cfquery datasource="#Session.DSN#" name="rsSN">
                    select 
                    CFid,
                    CFcodigo,
                    CFdescripcion
                    from CFuncional			
                    where Ecodigo = #session.Ecodigo#
                    and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormIng.CFidD#">
                </cfquery>
                <cfset ArrayAppend(valuesArraySN, rsSN.CFid)>
                <cfset ArrayAppend(valuesArraySN, rsSN.CFcodigo)>
                <cfset ArrayAppend(valuesArraySN, rsSN.CFdescripcion)>
            </cfif>   
            <cf_conlis
            Campos="CFidD,CFcodigoD,CFdescripcionD"
            valuesArray="#valuesArraySN#"
            Desplegables="N,S,S"
            Modificables="N,S,N"
            Size="0,10,35"
            tabindex="5"
            Title="Lista de Centros Funcionales"
            Tabla="CFuncional cf"
            Columnas="distinct cf.CFid as CFidD, cf.CFcodigo as CFcodigoD, cf.CFdescripcion as CFdescripcionD"
            Filtro=" cf.Ecodigo = #Session.Ecodigo# order by cf.CFcodigo"
            Desplegar="CFcodigoD,CFdescripcionD"
            Etiquetas="Codigo,Descripcion"
            filtrar_por="CFcodigo,CFdescripcion"
            Formatos="S,S"
            Align="left,left"
            form="formIngreso"
            Asignar="CFidD,CFcodigoD,CFdescripcionD"
            Asignarformatos="S,S,S"											
            /> 
        </td>
    </tr>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr><td colspan="3" align="center">
		<cfif modo neq "ALTA_I">
			<cf_botones modo="CAMBIO" sufijo="Ing" exclude="Baja" functions="return Comprobar();">
            <div id="form" name="form" style="position: relative; left: 155px; top: -25px; width: 90px;">
            	<cf_botones names="Baja" sufijo="Ing" values="Eliminar">
            </div>
		<cfelse>
			<cf_botones modo="ALTA" sufijo="Ing" functions="return Comprobar();">
		</cfif>
	</td></tr>
	<tr>
		<td colspan="3" align="center">&nbsp;</td>
	</tr>
	<cfset ts = "">	
	<input type="hidden" name="modo" value="#modo#" />
	<cfif modo neq "ALTA_I">
		<cfinvoke 
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsFormIng.ts_rversion#"/>
		</cfinvoke>
        <input type="hidden" name="CFCid2" value="<cfoutput>#rsFormIng.CFCid#</cfoutput>">
	</cfif>

	<tr><td><input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA_I'><cfoutput>#ts#</cfoutput></cfif>"></td></tr>
  </table>  
  </cfoutput>
 </form>

<script language="JavaScript1.2" type="text/javascript">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_INGRESO"
	Default="Ingreso"
	returnvariable="LB_INGRESO"/>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CO"
	Default="Costo"
	returnvariable="LB_CO"/>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CFD"
	Default="Centro Funcional Destino"
	returnvariable="LB_CFD"/>
	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formIngreso");
	
	objForm.Ccodigo2.required = true;
	objForm.Ccodigo2.description="<cfoutput>#LB_INGRESO#</cfoutput>";	
	objForm.CFCporc.required = true;
	objForm.CFCporc.description="<cfoutput>#LB_PORCENTAJE#</cfoutput>";	
	objForm.CFcodigoD.required = true;
	objForm.CFcodigoD.description="<cfoutput>#LB_CFD#</cfoutput>";	
	if (document.formIngreso.CFCtipo.checked == 'false'){
		objForm.Ccodigo3.required = true;
		objForm.Ccodigo3.description="<cfoutput>#LB_CO#</cfoutput>";	
	}
	
	function deshabilitarValidacion(){
		objForm.Ccodigo2.required = false;
		objForm.CFCporc.required = false;
		objForm.CFcodigoD.required = false;
		if (document.formIngreso.CFCtipo.checked == 'false'){
			objForm.Ccodigo3.required = false;
		}
	}
	function habilitarValidacion(){
		objForm.Ccodigo2.required = true;
		objForm.CFCporc.required = true;
		objForm.CFcodigoD.required = true;
		if (document.formIngreso.CFCtipo.checked == 'false'){
			objForm.Ccodigo3.required = true;
		}
	}	
	function limpiar() {
		objForm.reset();
	}
	
	function funcRegresarDet(id){
		document.location.href = 'CFuncional.cfm?CFcodigo1=' & id;
	}
	function _mayor(number){	
		if ( number > 100 ){
			document.formIngreso.CFCporc.value = '0.00';
			alert ('El campo no puede ser mayor a 100');
			return false;
		}
	}
	function limpiarDetalle() {
		var f = document.formIngreso;
		f.Ccodigo3.value="";
		f.Cdescripcion3.value="";
		f.CFCid3.value="";		
	}
	
	// cambia según el item que se escogió
	function cambioCosto(){		
		var f = document.formIngreso;
		if(f.CFCtipo.checked == true){
			document.getElementById("cos").style.visibility = "hidden";
			document.getElementById("cos").style.position = "absolute";
		}
		if(f.CFCtipo.checked == false){
			document.getElementById("cos").style.visibility = "visible";
			document.getElementById("cos").style.position = "relative";
		}
	}
	
	function Comprobar() {

		<cfoutput>
		if( (parseFloat(#valor#) + parseFloat(document.formIngreso.CFCporc.value)) > 100){
			total = (100 - parseFloat(#valor#));
			alert ('Tienes ' +total+ ' para distribuir, no se puede pasar del 100%')
			return false;
		}	
		</cfoutput>
	} 
	function Eliminar() {
	}
</script> 

