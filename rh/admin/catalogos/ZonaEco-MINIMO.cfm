<!---
<cfdump var="#form#">
<cfdump var="#url#">
--->

<cfif isdefined("url.fZEcodigo") and len(trim(url.fZEcodigo))>
	<cfset form.fZEcodigo = url.fZEcodigo>
</cfif>
<cfif isdefined("url.fZEdescripcion") and len(trim(url.fZEdescripcion))>
	<cfset form.fZEdescripcion = url.fZEdescripcion>
</cfif>
<cfparam name="form.PageNum" default="1">
<cfif isdefined("url.PageNum") and len(trim(url.PageNum))>
	<cfset form.PageNum = url.PageNum>
</cfif>
<cfparam name="navegacion2" default="">
<cfif isdefined("form.fZEcodigo") and len(trim(form.fZEcodigo))>
	<cfset navegacion2 = navegacion2 & iif(len(navegacion2),DE('&'),DE('?')) & 'fZEcodigo=' & form.fZEcodigo>
</cfif>
<cfif isdefined("form.fZEdescripcion") and len(trim(form.fZEdescripcion))>
	<cfset navegacion2 = navegacion2 & iif(len(navegacion2),DE('&'),DE('?')) & 'fZEdescripcion=' & form.fZEdescripcion>
</cfif>
<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
	<cfset navegacion2 = navegacion2 & iif(len(navegacion2),DE('&'),DE('?')) & 'PageNum=' & form.PageNum>
</cfif>

<cfif not isdefined("form.SZEdesdeLista")>
	<cfset ModoLista = 'Alta'>
<cfelse>
	<cfset ModoLista = 'Cambio'>
</cfif>

<cfinvoke key="MSG_DebeDigitarMontoMayorA0" default="Debe digitar un monto mayor a cero " returnvariable="MSG_DebeDigitarMontoMayorA0" component="sif.Componentes.Translate" method="Translate"/>


<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Desde"
Default="Desde"
returnvariable="LB_Desde"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Hasta"
Default="Hasta"
returnvariable="LB_Hasta"/>


<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_SalarioMinimo"
Default="Salario M&iacute;nimo"
returnvariable="LB_SalarioMinimo"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Estado"
Default="Estado"
returnvariable="LB_Estado"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="BTN_Agregar"
Default="Agregar"
returnvariable="BTN_Agregar"/>


<cfif ModoLista eq 'Cambio'>
	<cfquery name="rsZE" datasource="#session.DSN#">
    	select 
        	ZEid, 
            SZEdesde, 
            SZEhasta, 
            SZEsalarioMinimo, 
            SZEestado, 
            case when SZEestado = 0 then 'Abierto' else 'Cerrado' end as Estado
        from SalarioMinimoZona
        where ZEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ZEid#">
        and SZEdesde = '#form.SZEdesdeLista#'
    </cfquery>
</cfif>

<cfquery name="rsLista2" datasource="#session.dsn#">
        select 
        	ZEid, 
            SZEdesde as SZEdesdeLista, 
            SZEhasta as SZEhastaLista, 
            SZEsalarioMinimo as SZEsalarioMinimoLista, 
            SZEestado as SZEestadoLista, 
            case when SZEestado = 0 then 'Abierto' else 'Cerrado' end as EstadoLista, 
            1 as Lista, 
            'CAMBIO' as ModoLista,
			#form.PageNum# as PageNum
        from SalarioMinimoZona
        where ZEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ZEid#">
        order by SZEdesde
    </cfquery>

<script language="javascript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"><!--// JS DE MONTOS //--></script>
<form action="ZonaEco-SQL.cfm" method="post" name="form2">
	<input name="ZEid" value="<cfif isdefined("form.ZEid")><cfoutput>#form.ZEid#</cfoutput></cfif>" type="hidden">
	<input name="PageNum" value="<cfoutput>#form.PageNum#</cfoutput>" type="hidden">
	
    <fieldset><legend><cfoutput>#LB_SalarioMinimo#</cfoutput></legend>
    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td nowrap><strong><cfoutput>#LB_Desde#</cfoutput>:</strong></td>
        <td>&nbsp;</td>
        <td nowrap><strong><cfoutput>#LB_Hasta#</cfoutput>:</strong></td>
        <td>&nbsp;</td>
        <td nowrap><strong><cfoutput>#LB_SalarioMinimo#</cfoutput>:</strong></td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td nowrap>&nbsp;</td>
        <td nowrap>&nbsp;</td>
        <td nowrap>
            <cfif isdefined("rsZE.SZEdesde") and isdate(rsZE.SZEdesde)>
                <cf_sifcalendario form="form2" name="SZEdesde" value="#LSDateFormat(rsZE.SZEdesde,'dd/mm/yyyy')#">
            <cfelse>
                <cf_sifcalendario form="form2" name="SZEdesde">
            </cfif>
        </td>
        <td nowrap>&nbsp;</td>
        <td nowrap>
            <input type="text" name="SZEhasta" class="cajasinbordeb" readonly="true" value="<cfif isdefined("rsZE.SZEhasta") and isdate(rsZE.SZEhasta)><cfoutput>#trim(LSDateFormat(rsZE.SZEhasta,'dd/mm/yyyy'))#</cfoutput></cfif>">
        </td>
        <td nowrap>&nbsp;</td>
        <td nowrap>
            <input name="SZEsalarioMinimo" 
            type="text" 
            size="20" 
            maxlength="18" 
            style="text-align: right"  
            onfocus="this.value=qf(this); this.select();" 
            onblur="javascript: fm(this,2);"  
            onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
            value="<cfif (isdefined("rsZE.SZEsalarioMinimo"))><cfoutput>#LSCurrencyFormat(rsZE.SZEsalarioMinimo,'none')#</cfoutput><cfelse>0.00</cfif>">
        </td>
        <td>&nbsp;</td>
        <!--- <td nowrap><cf_botones modo=#ModoLista# sufijo="Minimo" values="#BTN_Agregar#" names="AgregarMinimo"></td> --->
        <td nowrap>&nbsp;</td>
      </tr>
      <tr>
      	<td nowrap colspan="9">
	        <!--- SZEestado: 1: cerrado, 0: abierto --->
            <cfset LvarExclude = "">
            <cfset LvarInclude = "">
            <!--- Solo puede eliminar los registros en estado 0: abierto --->
            <!--- si el registro acutal tiene estado cerrado (1) entonces se excluye el botón Eliminar (LZ) --->
	        <cfif isdefined("rsZE") and  rsZE.SZEestado eq 1>
   	        	<cfset LvarExclude = LvarExclude & "Baja,Cambio">
            </cfif>
            
            <cfif isdefined("rsZE") and  rsZE.SZEestado eq 0>
                <cfset LvarInclude = LvarInclude & "Cerrar">
            </cfif>

			<!--- solo puede agregar si todos los niveles estan cerrados (LZ)  --->

            <cfloop query="rsLista2">
            	<cfif rsLista2.SZEestadoLista eq 0> <!--- si encuntra un nivel abierto entonces excluye el boton nuevo --->
                	<cfset LvarExclude = LvarExclude & ",Alta,Nuevo">
                </cfif>
            </cfloop>

            <!--- <cfoutput>*#LvarExclude#*</cfoutput><cfoutput>*#ModoLista#*</cfoutput> --->
        	<cf_botones form="form2" modo="#ModoLista#" exclude="#LvarExclude#" include="#LvarInclude#" sufijo="Minimo">
        </td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
    </table>

</form>    

	<!---<cfinvoke 
	component="rh.Componentes.pListas" 
	method="pListaQuery" 
	returnvariable="ret"
	query="#rsLista2#"
	desplegar="SZEdesdeLista,SZEhastaLista,SZEsalarioMinimoLista, EstadoLista"
	etiquetas="#LB_Desde#, #LB_Hasta#,#LB_SalarioMinimo#,#LB_Estado#"
	formatos="D,D,M,S"
	keys="ZEid,SZEdesdeLista"
	align="center,center,right,center"
	formname="formLista"
	irA="ZonaEco.cfm"
	incluyeform="true"
	showLink="true"
	navegacion="#navegacion2#"
	maxrows="2"
	/>--->
	
	<form name="formLista" action="ZonaEco.cfm" method="post" enctype="multipart/form-data" >
	<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="SalarioMinimoZona"/>
			<cfinvokeargument name="columnas" value="ZEid,SZEdesde as SZEdesdeLista, SZEhasta as SZEhastaLista, SZEsalarioMinimo as SZEsalarioMinimoLista, SZEestado as SZEestadoLista, case when SZEestado = 0 then 'Abierto' else 'Cerrado' end as EstadoLista, 1 as Lista, 'CAMBIO' as ModoLista,#form.PageNum# as PageNum "/>
			<cfinvokeargument name="desplegar" value="SZEdesdeLista,SZEhastaLista,SZEsalarioMinimoLista, EstadoLista"/>
			<cfinvokeargument name="etiquetas" value="#LB_Desde#, #LB_Hasta#,#LB_SalarioMinimo#,#LB_Estado#"/>
			<cfinvokeargument name="formatos" value="D,D,M,S"/>
			<cfinvokeargument name="filtro" value="ZEid = #form.ZEid# order by SZEdesde"/>
			<cfinvokeargument name="align" value="center,center,right,center"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="checkboxes" value="N"/>				
			<cfinvokeargument name="irA" value="ZonaEco.cfm"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
			<!---<cfinvokeargument name="incluyeform" value="true"/>--->
			<cfinvokeargument name="formName" value="formLista"/>
			<cfinvokeargument name="navegacion" value="#navegacion2#"/>
			<cfinvokeargument name="PageIndex" value="2"/>
			<cfinvokeargument name="maxrows" value="3"/><!------>
		</cfinvoke>
   </form>
</fieldset>   


<cf_qforms form="form2" objForm="objForm2">

<script language="javascript" type="text/javascript">

	<!--//
		<cfif (modocambio)>
			function __isPorcentajeSalario() {
				if (objForm2.SZEsalarioMinimo.value == 0 ){
					this.error = "<cfoutput>#MSG_DebeDigitarMontoMayorA0#</cfoutput>"
				}
			}	
			 _addValidator("isPorcentajeSalario", __isPorcentajeSalario);
	
			objForm2.SZEsalarioMinimo.validatePorcentajeSalario();
			objForm2.SZEdesde.description="<cfoutput>#LB_Desde#</cfoutput>";
			objForm2.required("SZEdesde");
		</cfif>
	//-->
</script>