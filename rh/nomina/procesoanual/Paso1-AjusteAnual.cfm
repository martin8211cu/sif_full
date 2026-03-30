<cfinvoke Key="LB_Codigo" 
	Default="C&oacute;digo" 
    returnvariable="LB_Codigo" 
    component="sif.Componentes.Translate" 
    method="Translate"/>
    
<cfinvoke Key="LB_Descripcion" 
	Default="Descripci&oacute;n" 
    returnvariable="LB_Descripcion" 
    component="sif.Componentes.Translate" 
    method="Translate"/>
    
<cfinvoke component="sif.Componentes.Translate"
                    method="Translate"
                    key="LB_ListadeTablasdeRenta"
                    default="Lista de Tablas de Renta"
                    returnvariable="LB_ListadeTablasdeRenta"/>
    
<cfif isdefined("form.RHAAid") and len(trim(form.RHAAid))>
	<cfset modoE = 'CAMBIO'>
</cfif>

<cfif modoE eq 'CAMBIO'>
    <cfquery name="rsRHAjusteAnual" datasource="#session.DSN#">
       select RHAAid,RHAAcodigo,RHAAdescrip,RHAAfecharige,RHAAfechavence,EIRid 
	   from RHAjusteAnual
       where Ecodigo = #session.Ecodigo#
       and RHAAid = #form.RHAAid#
    </cfquery>
</cfif>

<cfoutput>
<form name= "form" method="post" style="margin: 0;" action="AjusteAnual-sql.cfm">
<cfif isdefined("form.RHAAid") and len(trim(form.RHAAid))>
	<input type="hidden" name="RHAAid" value="#form.RHAAid#">
</cfif>
<table width="90%" align="center">
	<tr>
    	<td width="22.5%">
    	</td>
    	<td width="20%" align="left">
			#LB_Codigo#
        </td>
        <td width="35%" align="left" nowrap>
        		<cfif modoE EQ "CAMBIO">
                <input type="text" name="RHAAcodigo" size="15" maxlength="20" value="#HTMLEditFormat(rsRHAjusteAnual.RHAAcodigo)#"/>
                <cfelse>
                <input type="text" name="RHAAcodigo" size="15" maxlength="20" value=""/>
                </cfif>        	
        </td>
        <td width="22.5%">
    	</td>
    </tr>
    <tr>
    	<td width="22.5%">
    	</td>
    	<td width="20%" align="left">
        	#LB_Descripcion#
        </td>
        <td width="35%" align="left">
        		<input type="text" name="RHAAdescrip" size="30" maxlength="80" value="<cfif modoE EQ "CAMBIO">#HTMLEditFormat(rsRHAjusteAnual.RHAAdescrip)#</cfif>" />
        </td>
        <td width="22.5%">
    	</td>
    </tr>
    <tr>
    	<td width="22.5%">
    	</td>
    	<td width="20%" align="left">
        	<cf_translate key="LB_FechaRige">Fecha Rige</cf_translate>
        </td>
        <td width="35%" align="left">
        	<cfset fdesde = "">
                <cfif modoE EQ "CAMBIO">
                    <cfset fdesde = LSDateFormat(rsRHAjusteAnual.RHAAfecharige, 'dd/mm/yyyy')>
                </cfif>
        	<cf_sifcalendario form="form" name="FechaDesde" value="#fdesde#">
        </td>
        <td width="22.5%">
    	</td>
    </tr>
    <tr>
    	<td width="22.5%">
    	</td>
    	<td width="20%" align="left">
        	<cf_translate key="LB_FechaVence">Fecha Vence</cf_translate>
        </td>
        <td width="35%" align="left">
            <cfset fhasta = "">
                <cfif modoE EQ "CAMBIO">
                    <cfset fhasta = LSDateFormat(rsRHAjusteAnual.RHAAfechavence, 'dd/mm/yyyy')>
                </cfif>
        	<cf_sifcalendario form="form" name="FechaHasta" value="#fhasta#">
        </td>
        <td width="22.5%">
    	</td>
    </tr>
    <tr>
    	<td width="22.5%">
    	</td>
    	<td width="20%" align="left">
        	<cf_translate key="LB_TablaImp">Tabla de Impuestos de Renta</cf_translate>
        </td>
        <td width="35%" align="left">
            <cfset values = ''>
            <cfif modoE EQ "CAMBIO">
            	<cfquery name="rsTraeIRenta" datasource="#session.DSN#">
                	select IRcodigo, rtrim(ltrim(IRdescripcion)) as IRdescripcion
                	from ImpuestoRenta 
                    where IRcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Trim(rsRHAjusteAnual.EIRid)#">
                </cfquery>
            	<cfset values = '#rsTraeIRenta.IRcodigo#,#rsTraeIRenta.IRdescripcion#'>
            </cfif>
                <cf_conlis title="#LB_ListadeTablasdeRenta#"
                    campos = "IRcodigo,IRdescripcion" 
                    desplegables = "S,S" 
                    size = "10,30"
                    values="#values#"
                    tabla="ImpuestoRenta"
                    columnas="IRcodigo,IRdescripcion"
                    filtro=""
                    desplegar="IRcodigo,IRdescripcion"
                    etiquetas="#LB_Codigo#,#LB_Descripcion#"
                    formatos="S,S"
                    align="left,left"
                    conexion="#session.DSN#"
                    form = "form">
        </td>
        <td width="22.5%">
    	</td>
    </tr>
     <tr>
    	<td colspan="4" align="center">
        	<cfset LvarExclude= ''>
            <cfif modoE eq 'CAMBIO'>
                <cfset LvarExclude= 'Nuevo'>
            <cfelse>
            	<!---<cfset LvarExclude= 'Cambio'>--->
			</cfif>
         	<cf_botones form='form' modo=#modoE# include="Regresar" exclude="#LvarExclude#">
        </td>
     </tr>
</table>
</form>
</cfoutput>

<cf_qforms form="form" objForm="objForm">
<script language="javascript" type="text/javascript">
	function funcAlta(){
		<cfoutput>
			objForm.RHAAid.required = true;
			objForm.RHAAid.description = "Código";
			
			objForm.RHAAdescrip.required = true;
			objForm.RHAAdescrip.description = "Descripción";
			
			objForm.FechaDesde.required = true;
			objForm.FechaDesde.description = "Fecha Rige";
			
			objForm.FechaHasta.required = true;
			objForm.FechaHasta.description = "Fecha Vence";
			
		</cfoutput>
	}
	function funcRegresar(){
		document.form.action='AjusteAnual-lista.cfm';
		document.form.submit();
		}
</script>